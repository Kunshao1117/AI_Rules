import * as cp from "child_process";
import * as fs from "fs";
import * as path from "path";
import * as vscode from "vscode";

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
    const repoRoot = this.findRepoRoot();
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

  private findRepoRoot(): string {
    const configRoot = vscode.workspace.getConfiguration("aiRules").get<string>("repoRoot");
    const candidates = [
      configRoot,
      ...(vscode.workspace.workspaceFolders || []).map((folder) => folder.uri.fsPath),
      path.resolve(this.context.extensionPath, "..", "..")
    ].filter((item): item is string => Boolean(item && item.trim()));

    for (const candidate of candidates) {
      const script = path.join(candidate, "Scripts", "AI-RulesManager.ps1");
      if (fs.existsSync(script)) return candidate;
    }
    throw new Error("找不到 AI_Rules repo。請設定 aiRules.repoRoot。");
  }
}

function quoteArg(value: string): string {
  return /\s/.test(value) ? `"${value}"` : value;
}
