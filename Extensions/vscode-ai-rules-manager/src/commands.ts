import * as vscode from "vscode";
import { ExtensionUpdateChecker } from "./extensionUpdate";
import { AiRulesPanelProvider } from "./panel";
import { ManagerAction, ProjectPlatform, RunOptions, ScriptRunner } from "./scriptRunner";
import { AiRulesStatus } from "./status";

export function registerAiRulesCommands(
  context: vscode.ExtensionContext,
  runner: ScriptRunner,
  status: AiRulesStatus,
  panel: AiRulesPanelProvider,
  updateChecker: ExtensionUpdateChecker
): void {
  const runReadOnly = (commandId: string, label: string, action: ManagerAction) => {
    context.subscriptions.push(vscode.commands.registerCommand(commandId, async () => {
      await run(label, action, runner, status, panel);
    }));
  };

  runReadOnly("aiRules.checkUpdate", "檢查更新", "Check");
  context.subscriptions.push(vscode.commands.registerCommand("aiRules.checkExtensionUpdate", async () => {
    await updateChecker.checkForUpdates({ manual: true });
  }));
  runReadOnly("aiRules.planUpdate", "查看更新內容", "Plan");
  runReadOnly("aiRules.doctor", "健康檢查", "Doctor");

  context.subscriptions.push(vscode.commands.registerCommand("aiRules.applyUpdate", async () => {
    const ok = await confirm("套用更新會執行 git pull --ff-only，並重新執行治理巡檢。");
    if (ok) await run("套用更新", "Apply", runner, status, panel, { apply: true });
  }));

  context.subscriptions.push(vscode.commands.registerCommand("aiRules.syncGlobalRules", async () => {
    await run("同步使用者層規則預覽", "SyncGlobal", runner, status, panel);
    const ok = await confirm("要寫入使用者層規則並備份舊檔嗎？這不會更新目前專案的 .codex/ 或 .agents/skills。");
    if (ok) await run("同步使用者層規則", "SyncGlobal", runner, status, panel, { apply: true });
  }));

  context.subscriptions.push(vscode.commands.registerCommand("aiRules.syncProjectRules", async () => {
    await runProjectSync("同步已安裝平台規則", "Auto", runner, status, panel);
  }));

  context.subscriptions.push(vscode.commands.registerCommand("aiRules.syncProjectRulesCodex", async () => {
    await runProjectSync("同步 Codex 專案規則", "Codex", runner, status, panel);
  }));

  context.subscriptions.push(vscode.commands.registerCommand("aiRules.syncProjectRulesClaude", async () => {
    await runProjectSync("同步 Claude 專案規則", "Claude", runner, status, panel);
  }));

  context.subscriptions.push(vscode.commands.registerCommand("aiRules.syncProjectRulesAntigravity", async () => {
    await runProjectSync("同步 Antigravity 專案規則", "Antigravity", runner, status, panel);
  }));

  context.subscriptions.push(vscode.commands.registerCommand("aiRules.cleanupOrphans", async () => {
    await run("孤兒檔案預覽", "CleanupOrphans", runner, status, panel);
    const ok = await confirm("要刪除上方列出的孤兒檔案嗎？memory / project_skills 不會被清理。");
    if (ok) await run("清理孤兒檔案", "CleanupOrphans", runner, status, panel, { apply: true, removeOrphans: true });
  }));
}

async function run(
  label: string,
  action: ManagerAction,
  runner: ScriptRunner,
  status: AiRulesStatus,
  panel: AiRulesPanelProvider,
  options: RunOptions = {}
): Promise<void> {
  try {
    status.setBusy(`AI Rules: ${label}`);
    panel.setStatus(`${label}執行中...`);
    const output = await runner.run(action, options);
    if (needsAttention(output)) {
      status.setWarning("AI Rules: 需要處理");
      panel.setStatus(`${label}完成：需要處理`);
    } else {
      status.setIdle("AI Rules: OK");
      panel.setStatus(`${label}完成`);
    }
  } catch (error) {
    status.setWarning("AI Rules: 失敗");
    panel.setStatus(`${label}失敗`);
    const message = error instanceof Error ? error.message : String(error);
    void vscode.window.showErrorMessage(message);
  }
}

async function runProjectSync(
  label: string,
  projectPlatform: ProjectPlatform,
  runner: ScriptRunner,
  status: AiRulesStatus,
  panel: AiRulesPanelProvider
): Promise<void> {
  await run(`${label}預覽`, "SyncProjectRules", runner, status, panel, { projectPlatform });
  const ok = await confirm("要更新目前專案已安裝的對應平台規則嗎？未安裝平台不會被建立，memory / project_skills 不會被覆寫。");
  if (ok) await run(label, "SyncProjectRules", runner, status, panel, { apply: true, projectPlatform });
}

async function confirm(message: string): Promise<boolean> {
  const answer = await vscode.window.showWarningMessage(message, { modal: true }, "確認執行");
  return answer === "確認執行";
}

function needsAttention(output: string): boolean {
  return /狀態：偵測到遠端更新/.test(output)
    || hasPositiveCounter(output, "Yellow")
    || hasPositiveCounter(output, "Red")
    || /規則與 source 不同|待授權|有差異/.test(output);
}

function hasPositiveCounter(output: string, label: "Yellow" | "Red"): boolean {
  const pattern = new RegExp(`${label}[：:]\\s*(\\d+)`, "g");
  let match: RegExpExecArray | null;
  while ((match = pattern.exec(output)) !== null) {
    if (Number.parseInt(match[1], 10) > 0) return true;
  }
  return false;
}
