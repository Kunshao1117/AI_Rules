import * as cp from "child_process";
import * as fs from "fs";
import * as path from "path";
import * as vscode from "vscode";

const DEFAULT_REPO_URL = "https://github.com/Kunshao1117/AI_Rules.git";
const MANAGED_REPO_DIR = "AI_Rules";
const MANAGED_BRANCH = "main";

export type ManagerAction =
  | "Check"
  | "Plan"
  | "Apply"
  | "Doctor"
  | "SyncGlobal"
  | "SyncProjectRules"
  | "CleanupOrphans";

export type ProjectPlatform = "Auto" | "Codex" | "Claude" | "Antigravity";

export interface RunOptions {
  apply?: boolean;
  removeOrphans?: boolean;
  projectPlatform?: ProjectPlatform;
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
    const storageRoot = this.context.globalStorageUri.fsPath;
    const managedRoot = path.join(storageRoot, MANAGED_REPO_DIR);
    this.assertManagedPath(storageRoot, managedRoot);

    if (fs.existsSync(managedRoot) && !this.isUsableManagedRepo(managedRoot)) {
      this.output.show(true);
      this.output.appendLine(`AI_Rules 管理快取不完整，將重新建立：${managedRoot}`);
      fs.rmSync(managedRoot, { recursive: true, force: true });
    }

    if (!fs.existsSync(managedRoot)) {
      const answer = await vscode.window.showWarningMessage(
        `目前專案不是 AI_Rules repo。是否要從 ${repoUrl} 建立 AI_Rules 管理快取？`,
        { modal: true },
        "建立快取"
      );
      if (answer !== "建立快取") {
        throw new Error("尚未建立 AI_Rules 管理快取，無法執行管理腳本。");
      }

      fs.mkdirSync(storageRoot, { recursive: true });
      await this.runGit(["clone", repoUrl, managedRoot], storageRoot);
    }

    await this.alignManagedRepoRoot(managedRoot, repoUrl);

    if (!this.hasManagerScript(managedRoot)) {
      throw new Error(`AI_Rules 管理快取已對齊遠端，但找不到 Scripts\\AI-RulesManager.ps1：${managedRoot}`);
    }

    return { repoRoot: managedRoot, managed: true };
  }

  private hasManagerScript(repoRoot: string): boolean {
    return fs.existsSync(path.join(repoRoot, "Scripts", "AI-RulesManager.ps1"));
  }

  private isUsableManagedRepo(repoRoot: string): boolean {
    return fs.existsSync(path.join(repoRoot, ".git")) && this.hasManagerScript(repoRoot);
  }

  private assertManagedPath(storageRoot: string, managedRoot: string): void {
    const storage = path.resolve(storageRoot);
    const managed = path.resolve(managedRoot);
    const relative = path.relative(storage, managed);
    if (!relative || relative.startsWith("..") || path.isAbsolute(relative)) {
      throw new Error(`AI_Rules 管理快取路徑不安全：${managedRoot}`);
    }
  }

  private async alignManagedRepoRoot(managedRoot: string, repoUrl: string): Promise<void> {
    this.output.show(true);
    this.output.appendLine(`→ AI_Rules 管理快取會自動對齊遠端版本庫：${repoUrl}#${MANAGED_BRANCH}`);
    try {
      await this.runGit(["remote", "set-url", "origin", repoUrl], managedRoot);
      await this.runGit(["fetch", "origin", MANAGED_BRANCH, "--prune"], managedRoot);
      await this.runGit(["reset", "--hard"], managedRoot);
      await this.runGit(["clean", "-fdx"], managedRoot);
      await this.runGit(["checkout", "-B", MANAGED_BRANCH, `origin/${MANAGED_BRANCH}`], managedRoot);
      await this.runGit(["reset", "--hard", `origin/${MANAGED_BRANCH}`], managedRoot);
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
