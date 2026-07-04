import * as cp from "child_process";
import * as fs from "fs";
import * as path from "path";
import * as vscode from "vscode";

const DEFAULT_REPO_URL = "https://github.com/Kunshao1117/AI_Rules.git";
const MANAGED_REPO_DIR = "AI_Rules";
const MANAGED_BRANCH = "main";
const MANAGER_SCRIPT_GIT_PATH = "Scripts/AI-RulesManager.ps1";
const MANAGER_SCRIPT_RELATIVE = path.join("Scripts", "AI-RulesManager.ps1");
const TRUSTED_REPO_URLS_KEY = "trustedRepoUrls";

export type ManagerAction =
  | "Check"
  | "Plan"
  | "Apply"
  | "Doctor"
  | "SyncGlobal"
  | "SyncProjectRules"
  | "MemoryMigration"
  | "Gitignore"
  | "CleanupOrphans";

export type ProjectPlatform = "Auto" | "Codex" | "Claude" | "Antigravity";
export type GitignoreMode = "Append" | "CleanSimilar";

export interface RunOptions {
  apply?: boolean;
  removeOrphans?: boolean;
  projectPlatform?: ProjectPlatform;
  gitignoreMode?: GitignoreMode;
  whatIf?: boolean;
}

interface RepoResolution {
  repoRoot: string;
  managed: boolean;
  trustedRepoUrl: string;
}

type TrustedSettingKey = "repoRoot" | "repoUrl" | "powerShellPath";

interface ConfigurationInspection<T> {
  defaultValue?: T;
  globalValue?: T;
  workspaceValue?: T;
  workspaceFolderValue?: T;
}

export class ScriptRunner {
  constructor(
    private readonly context: vscode.ExtensionContext,
    private readonly output: vscode.OutputChannel
  ) {}

  async run(action: ManagerAction, options: RunOptions = {}): Promise<string> {
    const source = await this.resolveRepoRoot();
    const repoRoot = source.repoRoot;
    const script = this.resolveManagerScript(repoRoot);
    const ps = this.getTrustedConfigurationString("powerShellPath", "powershell.exe") || "powershell.exe";
    const target = this.resolveExecutionTarget(repoRoot);
    await this.assertReadyToRun(source, script, target);
    const args = [
      "-NoProfile",
      "-ExecutionPolicy",
      "Bypass",
      "-File",
      script,
      "-Action",
      action,
      "-RepoRoot",
      repoRoot,
      "-Target",
      target
    ];

    if (source.managed) args.push("-ManagedSource");
    if (options.apply) args.push("-Apply");
    if (options.removeOrphans) args.push("-RemoveOrphans");
    if (options.projectPlatform) args.push("-ProjectPlatform", options.projectPlatform);
    if (options.gitignoreMode) args.push("-GitignoreMode", options.gitignoreMode);
    if (options.whatIf) args.push("-WhatIf");

    this.output.show(true);
    this.output.appendLine(`> ${ps} ${args.map(quoteArg).join(" ")}`);

    return new Promise((resolve, reject) => {
      const child = cp.spawn(ps, args, { cwd: repoRoot, windowsHide: true });
      let buffer = "";
      child.stdout.on("data", (chunk) => {
        const text = chunk.toString();
        buffer += text;
        this.output.append(text);
      });
      child.stderr.on("data", (chunk) => {
        const text = chunk.toString();
        buffer += text;
        this.output.append(text);
      });
      child.on("error", reject);
      child.on("close", (code) => {
        if (code === 0) resolve(buffer);
        else reject(new Error(`AI_Rules script exited with code ${code}`));
      });
    });
  }

  private async resolveRepoRoot(): Promise<RepoResolution> {
    const trustedRepoUrl = await this.resolveTrustedRepoUrl(
      this.getTrustedConfigurationString("repoUrl", DEFAULT_REPO_URL) || DEFAULT_REPO_URL
    );
    const configRoot = this.getTrustedConfigurationString("repoRoot");
    if (configRoot) {
      const repoRoot = this.canonicalizeExistingDirectory(configRoot, "aiRules.repoRoot");
      if (this.hasManagerScript(repoRoot)) {
        await this.assertGitRepoIdentity(repoRoot, trustedRepoUrl);
        return { repoRoot, managed: false, trustedRepoUrl };
      }
      throw new Error(`aiRules.repoRoot 無效，找不到 Scripts\\AI-RulesManager.ps1：${configRoot}`);
    }

    const workspaceRoot = await this.findWorkspaceRepoRoot(trustedRepoUrl);
    if (workspaceRoot) return { repoRoot: workspaceRoot, managed: false, trustedRepoUrl };

    return this.ensureManagedRepoRoot(trustedRepoUrl);
  }

  private getTrustedConfigurationString(key: TrustedSettingKey, fallback = ""): string {
    const config = vscode.workspace.getConfiguration("aiRules");
    const inspection = config.inspect<string>(key);
    this.rejectWorkspaceConfiguration(key, inspection);

    for (const folder of vscode.workspace.workspaceFolders || []) {
      const folderInspection = vscode.workspace.getConfiguration("aiRules", folder.uri).inspect<string>(key);
      this.rejectWorkspaceConfiguration(key, folderInspection);
    }

    const value = inspection?.globalValue ?? inspection?.defaultValue ?? fallback;
    return typeof value === "string" ? value.trim() : fallback;
  }

  private rejectWorkspaceConfiguration(
    key: TrustedSettingKey,
    inspection: ConfigurationInspection<string> | undefined
  ): void {
    if (!inspection) return;
    if (inspection.workspaceValue !== undefined || inspection.workspaceFolderValue !== undefined) {
      throw new Error(
        `AI Rules 設定（aiRules.${key}）不可放在目前專案的設定檔。` +
        "請移到 VS Code 使用者設定，避免陌生專案改寫 AI_Rules 來源或執行檔。"
      );
    }
  }

  private async findWorkspaceRepoRoot(trustedRepoUrl: string): Promise<string | undefined> {
    this.assertWorkspaceTrusted();
    for (const folder of vscode.workspace.workspaceFolders || []) {
      if (folder.uri.scheme !== "file") {
        throw new Error(`AI Rules 只能對本機檔案工作區執行管理腳本：${folder.uri.toString()}`);
      }

      const repoRoot = this.canonicalizeExistingDirectory(folder.uri.fsPath, "VS Code workspace folder");
      if (!this.hasManagerScript(repoRoot)) continue;

      await this.assertGitRepoIdentity(repoRoot, trustedRepoUrl);
      return repoRoot;
    }
    return undefined;
  }

  private async ensureManagedRepoRoot(repoUrl: string): Promise<RepoResolution> {
    const trustedRepoUrl = await this.resolveTrustedRepoUrl(repoUrl);
    const storageRoot = this.realPathOrResolved(this.context.globalStorageUri.fsPath);
    const managedRoot = path.join(storageRoot, MANAGED_REPO_DIR);
    this.assertManagedPath(storageRoot, managedRoot);

    if (fs.existsSync(managedRoot) && !(await this.isVerifiableManagedRepo(managedRoot, trustedRepoUrl))) {
      this.assertManagedPath(storageRoot, managedRoot);
      this.output.show(true);
      this.output.appendLine(`AI_Rules 管理快取無法驗證，將重新建立：${managedRoot}`);
      fs.rmSync(managedRoot, { recursive: true, force: true });
    }

    if (!fs.existsSync(managedRoot)) {
      const answer = await vscode.window.showWarningMessage(
        `目前專案不是 AI_Rules repo。是否要從 ${trustedRepoUrl} 建立 AI_Rules 管理快取？`,
        { modal: true },
        "建立快取"
      );
      if (answer !== "建立快取") {
        throw new Error("尚未建立 AI_Rules 管理快取，無法執行管理腳本。");
      }

      fs.mkdirSync(storageRoot, { recursive: true });
      await this.runGit(["clone", trustedRepoUrl, managedRoot], storageRoot);
    }

    await this.alignManagedRepoRoot(storageRoot, managedRoot, trustedRepoUrl);

    if (!this.hasManagerScript(managedRoot)) {
      throw new Error(`AI_Rules 管理快取已對齊遠端，但找不到 Scripts\\AI-RulesManager.ps1：${managedRoot}`);
    }

    await this.assertGitRepoIdentity(managedRoot, trustedRepoUrl);
    return { repoRoot: managedRoot, managed: true, trustedRepoUrl };
  }

  private async resolveTrustedRepoUrl(repoUrl: string): Promise<string> {
    const normalized = this.normalizeRepoUrl(repoUrl);
    if (normalized === DEFAULT_REPO_URL) return normalized;

    const trusted = this.context.globalState.get<string[]>(TRUSTED_REPO_URLS_KEY, []);
    if (trusted.includes(normalized)) return normalized;

    const answer = await vscode.window.showWarningMessage(
      `aiRules.repoUrl 指向非預設來源：${normalized}。信任後才會允許 extension 對此來源的管理快取執行 clone/fetch/reset/clean。`,
      { modal: true },
      "信任此來源"
    );
    if (answer !== "信任此來源") {
      throw new Error(`尚未信任 AI_Rules 來源，已停止管理快取 Git 操作：${normalized}`);
    }

    await this.context.globalState.update(TRUSTED_REPO_URLS_KEY, [...trusted, normalized]);
    return normalized;
  }

  private normalizeRepoUrl(repoUrl: string): string {
    const value = repoUrl.trim();
    let parsed: URL;

    try {
      parsed = new URL(value);
    } catch {
      throw new Error(`aiRules.repoUrl 必須是 HTTPS GitHub repository URL：${repoUrl}`);
    }

    const repoPath = parsed.pathname.replace(/\/+$/, "");
    if (
      parsed.protocol !== "https:" ||
      parsed.hostname.toLowerCase() !== "github.com" ||
      parsed.username ||
      parsed.password ||
      parsed.search ||
      parsed.hash ||
      !/^\/[A-Za-z0-9_.-]+\/[A-Za-z0-9_.-]+(?:\.git)?$/.test(repoPath)
    ) {
      throw new Error(`aiRules.repoUrl 必須是無憑證、無查詢參數的 GitHub HTTPS repository URL：${repoUrl}`);
    }

    return `https://github.com${repoPath.endsWith(".git") ? repoPath : `${repoPath}.git`}`;
  }

  private hasManagerScript(repoRoot: string): boolean {
    try {
      this.resolveManagerScript(repoRoot);
      return true;
    } catch {
      return false;
    }
  }

  private isUsableManagedRepo(repoRoot: string): boolean {
    const gitDir = path.join(repoRoot, ".git");
    try {
      return fs.statSync(gitDir).isDirectory() && this.hasManagerScript(repoRoot);
    } catch {
      return false;
    }
  }

  private async isVerifiableManagedRepo(repoRoot: string, repoUrl: string): Promise<boolean> {
    if (!this.isUsableManagedRepo(repoRoot)) return false;
    try {
      await this.assertGitRepoIdentity(repoRoot, repoUrl);
      return true;
    } catch {
      return false;
    }
  }

  private assertManagedPath(storageRoot: string, managedRoot: string): void {
    const expectedManagedRoot = path.join(storageRoot, MANAGED_REPO_DIR);
    if (!this.samePath(managedRoot, expectedManagedRoot)) {
      throw new Error(`AI_Rules 管理快取路徑不符合預期：${managedRoot}`);
    }

    const storage = this.realPathOrResolved(storageRoot);
    const managed = fs.existsSync(path.resolve(managedRoot))
      ? this.realPathOrResolved(managedRoot)
      : path.join(storage, MANAGED_REPO_DIR);
    if (!this.samePath(managed, path.join(storage, MANAGED_REPO_DIR)) || !this.isPathInside(storage, managed, false)) {
      throw new Error(`AI_Rules 管理快取路徑不安全：${managedRoot}`);
    }
  }

  private realPathOrResolved(value: string): string {
    const resolved = path.resolve(value);
    return fs.existsSync(resolved) ? fs.realpathSync.native(resolved) : resolved;
  }

  private canonicalizeExistingDirectory(value: string, label: string): string {
    const resolved = path.resolve(value);
    let stat: fs.Stats;
    try {
      stat = fs.statSync(resolved);
    } catch {
      throw new Error(`${label} 不存在：${value}`);
    }

    if (!stat.isDirectory()) {
      throw new Error(`${label} 不是目錄：${value}`);
    }

    return fs.realpathSync.native(resolved);
  }

  private resolveManagerScript(repoRoot: string): string {
    const root = this.canonicalizeExistingDirectory(repoRoot, "AI_Rules repo root");
    const expectedScript = path.join(root, MANAGER_SCRIPT_RELATIVE);
    let stat: fs.Stats;
    try {
      stat = fs.statSync(expectedScript);
    } catch {
      throw new Error(`找不到 Scripts\\AI-RulesManager.ps1：${repoRoot}`);
    }

    if (!stat.isFile()) {
      throw new Error(`AI_Rules 管理腳本不是檔案：${expectedScript}`);
    }

    const script = fs.realpathSync.native(expectedScript);
    if (!this.samePath(script, expectedScript) || !this.isPathInside(root, script, false)) {
      throw new Error(`AI_Rules 管理腳本路徑不安全：${expectedScript}`);
    }

    return script;
  }

  private resolveExecutionTarget(repoRoot: string): string {
    this.assertWorkspaceTrusted();
    const folders = vscode.workspace.workspaceFolders || [];
    if (folders.length === 0) return this.canonicalizeExistingDirectory(repoRoot, "AI_Rules repo root");

    const folder = folders[0];
    if (folder.uri.scheme !== "file") {
      throw new Error(`AI Rules 只能對本機檔案工作區執行管理腳本：${folder.uri.toString()}`);
    }

    return this.canonicalizeExistingDirectory(folder.uri.fsPath, "VS Code workspace folder");
  }

  private async assertReadyToRun(source: RepoResolution, script: string, target: string): Promise<void> {
    this.assertWorkspaceTrusted();
    this.resolveManagerScript(source.repoRoot);
    this.canonicalizeExistingDirectory(target, "AI Rules 目標工作區");

    if (source.managed) {
      this.assertManagedPath(this.realPathOrResolved(this.context.globalStorageUri.fsPath), source.repoRoot);
    }

    if (!this.isPathInside(source.repoRoot, script, false)) {
      throw new Error(`AI_Rules 管理腳本不在受信任 repo root 內：${script}`);
    }

    await this.assertGitRepoIdentity(source.repoRoot, source.trustedRepoUrl);
    if (source.managed) {
      await this.assertManagedRepoHead(source.repoRoot);
    }
  }

  private assertWorkspaceTrusted(): void {
    if (!vscode.workspace.isTrusted) {
      throw new Error("目前 VS Code workspace 尚未受信任，已停止執行 AI_Rules 高風險管理腳本。");
    }
  }

  private async assertGitRepoIdentity(repoRoot: string, expectedRepoUrl: string): Promise<void> {
    const root = this.canonicalizeExistingDirectory(repoRoot, "AI_Rules repo root");
    const topLevel = this.canonicalizeExistingDirectory(
      await this.runGitCapture(["rev-parse", "--show-toplevel"], root),
      "AI_Rules Git root"
    );
    if (!this.samePath(root, topLevel)) {
      throw new Error(`AI_Rules repoRoot 必須等於 Git root：${repoRoot}`);
    }

    const remoteUrl = await this.runGitCapture(["remote", "get-url", "origin"], root);
    let normalizedRemoteUrl: string;
    try {
      normalizedRemoteUrl = this.normalizeRepoUrl(remoteUrl);
    } catch {
      throw new Error(`AI_Rules repo origin 不是可信 GitHub HTTPS URL：${remoteUrl}`);
    }

    if (!this.sameRepoUrl(normalizedRemoteUrl, expectedRepoUrl)) {
      throw new Error(`AI_Rules repo origin 與信任來源不符：${normalizedRemoteUrl}`);
    }

    this.resolveManagerScript(root);
    await this.assertTrackedCleanManagerScript(root);
  }

  private async assertTrackedCleanManagerScript(repoRoot: string): Promise<void> {
    try {
      await this.runGitCapture(["ls-files", "--error-unmatch", "--", MANAGER_SCRIPT_GIT_PATH], repoRoot);
    } catch {
      throw new Error(`AI_Rules 管理腳本不是 Git 追蹤檔案：${MANAGER_SCRIPT_GIT_PATH}`);
    }

    const status = await this.runGitCapture(["status", "--porcelain", "--", MANAGER_SCRIPT_GIT_PATH], repoRoot);
    if (status) {
      throw new Error(`AI_Rules 管理腳本存在未提交變更，已停止執行：${MANAGER_SCRIPT_GIT_PATH}`);
    }
  }

  private async assertManagedRepoHead(repoRoot: string): Promise<void> {
    const head = await this.runGitCapture(["rev-parse", "HEAD"], repoRoot);
    const originHead = await this.runGitCapture(["rev-parse", `origin/${MANAGED_BRANCH}`], repoRoot);
    if (head !== originHead) {
      throw new Error(`AI_Rules 管理快取未對齊 origin/${MANAGED_BRANCH}，已停止執行管理腳本。`);
    }
  }

  private sameRepoUrl(left: string, right: string): boolean {
    return left.toLowerCase() === right.toLowerCase();
  }

  private samePath(left: string, right: string): boolean {
    return this.normalizePathForComparison(path.resolve(left)) === this.normalizePathForComparison(path.resolve(right));
  }

  private isPathInside(parent: string, child: string, allowEqual = true): boolean {
    const relative = path.relative(parent, child);
    if (!relative) return allowEqual;
    return !relative.startsWith("..") && !path.isAbsolute(relative);
  }

  private normalizePathForComparison(value: string): string {
    const normalized = path.normalize(value);
    return process.platform === "win32" ? normalized.toLowerCase() : normalized;
  }

  private async alignManagedRepoRoot(storageRoot: string, managedRoot: string, repoUrl: string): Promise<void> {
    this.assertManagedPath(storageRoot, managedRoot);
    if (!this.isUsableManagedRepo(managedRoot)) {
      throw new Error(`AI_Rules 管理快取不是標準 Git repository，已停止 destructive Git 操作：${managedRoot}`);
    }
    await this.assertGitRepoIdentity(managedRoot, repoUrl);

    this.output.show(true);
    this.output.appendLine(`→ AI_Rules 管理快取會自動對齊遠端版本庫：${repoUrl}#${MANAGED_BRANCH}`);
    try {
      await this.runGit(["remote", "set-url", "origin", repoUrl], managedRoot);
      await this.runGit(
        ["fetch", "origin", `+refs/heads/${MANAGED_BRANCH}:refs/remotes/origin/${MANAGED_BRANCH}`, "--prune"],
        managedRoot
      );
      this.assertManagedPath(storageRoot, managedRoot);
      await this.runGit(["reset", "--hard"], managedRoot);
      this.assertManagedPath(storageRoot, managedRoot);
      await this.runGit(["clean", "-fdx"], managedRoot);
      await this.runGit(["checkout", "-B", MANAGED_BRANCH, `origin/${MANAGED_BRANCH}`], managedRoot);
      this.assertManagedPath(storageRoot, managedRoot);
      await this.runGit(["reset", "--hard", `origin/${MANAGED_BRANCH}`], managedRoot);
      this.assertManagedPath(storageRoot, managedRoot);
      await this.runGit(["clean", "-fdx"], managedRoot);
      await this.assertGitRepoIdentity(managedRoot, repoUrl);
      await this.assertManagedRepoHead(managedRoot);
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      throw new Error(`AI_Rules 管理快取無法對齊遠端版本庫，已停止避免使用舊規則同步專案。${message}`);
    }
  }

  private runGit(args: string[], cwd: string): Promise<void> {
    this.output.show(true);
    this.output.appendLine(`> git ${args.map(quoteArg).join(" ")}`);

    return new Promise((resolve, reject) => {
      const child = cp.spawn("git", args, { cwd, windowsHide: true });
      child.stdout.on("data", (chunk) => this.output.append(chunk.toString()));
      child.stderr.on("data", (chunk) => this.output.append(chunk.toString()));
      child.on("error", () => {
        reject(new Error("找不到 Git。請先安裝 Git，或手動設定 aiRules.repoRoot 指向已存在的 AI_Rules repo。"));
      });
      child.on("close", (code) => {
        if (code === 0) resolve();
        else reject(new Error(`Git 指令失敗：git ${args.join(" ")}，exit code ${code}`));
      });
    });
  }

  private runGitCapture(args: string[], cwd: string): Promise<string> {
    return new Promise((resolve, reject) => {
      const child = cp.spawn("git", args, { cwd, windowsHide: true });
      let stdout = "";
      let stderr = "";
      child.stdout.on("data", (chunk) => {
        stdout += chunk.toString();
      });
      child.stderr.on("data", (chunk) => {
        stderr += chunk.toString();
      });
      child.on("error", () => {
        reject(new Error("找不到 Git。請先安裝 Git，或手動設定 aiRules.repoRoot 指向已存在的 AI_Rules repo。"));
      });
      child.on("close", (code) => {
        if (code === 0) resolve(stdout.trim());
        else reject(new Error(`Git 指令失敗：git ${args.join(" ")}，exit code ${code}。${stderr.trim()}`));
      });
    });
  }
}

function quoteArg(value: string): string {
  return /\s/.test(value) ? `"${value}"` : value;
}
