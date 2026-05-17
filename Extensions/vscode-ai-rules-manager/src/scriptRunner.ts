import * as cp from "child_process";
import * as fs from "fs";
import * as path from "path";
import * as vscode from "vscode";

const DEFAULT_REPO_URL = "https://github.com/Kunshao1117/AI_Rules.git";
const MANAGED_REPO_DIR = "AI_Rules";

export type ManagerAction =
  | "Check"
  | "Plan"
  | "Apply"
  | "Doctor"
  | "SyncGlobal"
  | "CleanupOrphans";

export interface RunOptions {
  apply?: boolean;
  removeOrphans?: boolean;
  whatIf?: boolean;
}

export class ScriptRunner {
  constructor(
    private readonly context: vscode.ExtensionContext,
    private readonly output: vscode.OutputChannel
  ) {}

  async run(action: ManagerAction, options: RunOptions = {}): Promise<string> {
    const repoRoot = await this.resolveRepoRoot();
    const script = path.join(repoRoot, "Scripts", "AI-RulesManager.ps1");
    const config = vscode.workspace.getConfiguration("aiRules");
    const ps = config.get<string>("powerShellPath") || "powershell.exe";
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

    if (options.apply) args.push("-Apply");
    if (options.removeOrphans) args.push("-RemoveOrphans");
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

  private async resolveRepoRoot(): Promise<string> {
    const config = vscode.workspace.getConfiguration("aiRules");
    const configRoot = config.get<string>("repoRoot")?.trim();
    if (configRoot) {
      if (this.hasManagerScript(configRoot)) return configRoot;
      throw new Error(`aiRules.repoRoot 無效，找不到 Scripts\\AI-RulesManager.ps1：${configRoot}`);
    }

    const workspaceRoot = this.findWorkspaceRepoRoot();
    if (workspaceRoot) return workspaceRoot;

    return this.ensureManagedRepoRoot(config.get<string>("repoUrl")?.trim() || DEFAULT_REPO_URL);
  }

  private findWorkspaceRepoRoot(): string | undefined {
    for (const folder of vscode.workspace.workspaceFolders || []) {
      if (this.hasManagerScript(folder.uri.fsPath)) return folder.uri.fsPath;
    }
    return undefined;
  }

  private async ensureManagedRepoRoot(repoUrl: string): Promise<string> {
    const storageRoot = this.context.globalStorageUri.fsPath;
    const managedRoot = path.join(storageRoot, MANAGED_REPO_DIR);

    if (this.hasManagerScript(managedRoot)) return managedRoot;

    if (fs.existsSync(managedRoot)) {
      throw new Error(`AI_Rules 管理快取已存在但不完整：${managedRoot}。請刪除該資料夾或設定 aiRules.repoRoot。`);
    }

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

    if (!this.hasManagerScript(managedRoot)) {
      throw new Error(`Git clone 完成，但找不到 Scripts\\AI-RulesManager.ps1：${managedRoot}`);
    }

    return managedRoot;
  }

  private hasManagerScript(repoRoot: string): boolean {
    return fs.existsSync(path.join(repoRoot, "Scripts", "AI-RulesManager.ps1"));
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
        else reject(new Error(`Git clone 失敗，exit code ${code}`));
      });
    });
  }
}

function quoteArg(value: string): string {
  return /\s/.test(value) ? `"${value}"` : value;
}
