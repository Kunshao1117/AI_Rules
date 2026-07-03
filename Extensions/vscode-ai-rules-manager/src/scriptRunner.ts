import * as cp from "child_process";
import * as fs from "fs";
import * as path from "path";
import * as vscode from "vscode";

const DEFAULT_REPO_URL = "https://github.com/Kunshao1117/AI_Rules.git";
const MANAGED_REPO_DIR = "AI_Rules";
const MANAGED_BRANCH = "main";
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
    const script = path.join(repoRoot, "Scripts", "AI-RulesManager.ps1");
    const ps = this.getTrustedConfigurationString("powerShellPath", "powershell.exe") || "powershell.exe";
    const target = vscode.workspace.workspaceFolders?.[0]?.uri.fsPath || repoRoot;
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
    const configRoot = this.getTrustedConfigurationString("repoRoot");
    if (configRoot) {
      if (this.hasManagerScript(configRoot)) return { repoRoot: configRoot, managed: false };
      throw new Error(`aiRules.repoRoot 無效，找不到 Scripts\\AI-RulesManager.ps1：${configRoot}`);
    }

    const workspaceRoot = this.findWorkspaceRepoRoot();
    if (workspaceRoot) return { repoRoot: workspaceRoot, managed: false };

    return this.ensureManagedRepoRoot(this.getTrustedConfigurationString("repoUrl", DEFAULT_REPO_URL) || DEFAULT_REPO_URL);
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

  private findWorkspaceRepoRoot(): string | undefined {
    for (const folder of vscode.workspace.workspaceFolders || []) {
      if (this.hasManagerScript(folder.uri.fsPath)) return folder.uri.fsPath;
    }
    return undefined;
  }

  private async ensureManagedRepoRoot(repoUrl: string): Promise<RepoResolution> {
    const trustedRepoUrl = await this.resolveTrustedRepoUrl(repoUrl);
    const storageRoot = this.context.globalStorageUri.fsPath;
    const managedRoot = path.join(storageRoot, MANAGED_REPO_DIR);
    this.assertManagedPath(storageRoot, managedRoot);

    if (fs.existsSync(managedRoot) && !this.isUsableManagedRepo(managedRoot)) {
      this.assertManagedPath(storageRoot, managedRoot);
      this.output.show(true);
      this.output.appendLine(`AI_Rules 管理快取不完整，將重新建立：${managedRoot}`);
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

    return { repoRoot: managedRoot, managed: true };
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
    return fs.existsSync(path.join(repoRoot, "Scripts", "AI-RulesManager.ps1"));
  }

  private isUsableManagedRepo(repoRoot: string): boolean {
    const gitDir = path.join(repoRoot, ".git");
    try {
      return fs.statSync(gitDir).isDirectory() && this.hasManagerScript(repoRoot);
    } catch {
      return false;
    }
  }

  private assertManagedPath(storageRoot: string, managedRoot: string): void {
    const expectedManagedRoot = path.join(storageRoot, MANAGED_REPO_DIR);
    if (path.resolve(managedRoot) !== path.resolve(expectedManagedRoot)) {
      throw new Error(`AI_Rules 管理快取路徑不符合預期：${managedRoot}`);
    }

    const storage = this.realPathOrResolved(storageRoot);
    const managed = fs.existsSync(path.resolve(managedRoot))
      ? this.realPathOrResolved(managedRoot)
      : path.join(storage, MANAGED_REPO_DIR);
    const relative = path.relative(storage, managed);
    if (!relative || relative.startsWith("..") || path.isAbsolute(relative)) {
      throw new Error(`AI_Rules 管理快取路徑不安全：${managedRoot}`);
    }
  }

  private realPathOrResolved(value: string): string {
    const resolved = path.resolve(value);
    return fs.existsSync(resolved) ? fs.realpathSync.native(resolved) : resolved;
  }

  private async alignManagedRepoRoot(storageRoot: string, managedRoot: string, repoUrl: string): Promise<void> {
    this.assertManagedPath(storageRoot, managedRoot);
    if (!this.isUsableManagedRepo(managedRoot)) {
      throw new Error(`AI_Rules 管理快取不是標準 Git repository，已停止 destructive Git 操作：${managedRoot}`);
    }

    this.output.show(true);
    this.output.appendLine(`→ AI_Rules 管理快取會自動對齊遠端版本庫：${repoUrl}#${MANAGED_BRANCH}`);
    try {
      await this.runGit(["remote", "set-url", "origin", repoUrl], managedRoot);
      await this.runGit(["fetch", "origin", MANAGED_BRANCH, "--prune"], managedRoot);
      this.assertManagedPath(storageRoot, managedRoot);
      await this.runGit(["reset", "--hard"], managedRoot);
      this.assertManagedPath(storageRoot, managedRoot);
      await this.runGit(["clean", "-fdx"], managedRoot);
      await this.runGit(["checkout", "-B", MANAGED_BRANCH, `origin/${MANAGED_BRANCH}`], managedRoot);
      this.assertManagedPath(storageRoot, managedRoot);
      await this.runGit(["reset", "--hard", `origin/${MANAGED_BRANCH}`], managedRoot);
      this.assertManagedPath(storageRoot, managedRoot);
      await this.runGit(["clean", "-fdx"], managedRoot);
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
}

function quoteArg(value: string): string {
  return /\s/.test(value) ? `"${value}"` : value;
}
