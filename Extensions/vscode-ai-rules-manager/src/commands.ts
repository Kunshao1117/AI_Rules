import * as vscode from "vscode";
import { AiRulesPanelProvider } from "./panel";
import { ManagerAction, ScriptRunner } from "./scriptRunner";
import { AiRulesStatus } from "./status";

export function registerAiRulesCommands(
  context: vscode.ExtensionContext,
  runner: ScriptRunner,
  status: AiRulesStatus,
  panel: AiRulesPanelProvider
): void {
  const runReadOnly = (commandId: string, label: string, action: ManagerAction) => {
    context.subscriptions.push(vscode.commands.registerCommand(commandId, async () => {
      await run(label, action, runner, status, panel);
    }));
  };

  runReadOnly("aiRules.checkUpdate", "檢查更新", "Check");
  runReadOnly("aiRules.planUpdate", "查看更新內容", "Plan");
  runReadOnly("aiRules.doctor", "健康檢查", "Doctor");

  context.subscriptions.push(vscode.commands.registerCommand("aiRules.applyUpdate", async () => {
    const ok = await confirm("套用更新會執行 git pull --ff-only，並重新執行治理巡檢。");
    if (ok) await run("套用更新", "Apply", runner, status, panel, { apply: true });
  }));

  context.subscriptions.push(vscode.commands.registerCommand("aiRules.syncGlobalRules", async () => {
    await run("同步全域規則預覽", "SyncGlobal", runner, status, panel);
    const ok = await confirm("要寫入使用者層全域規則並備份舊檔嗎？");
    if (ok) await run("同步全域規則", "SyncGlobal", runner, status, panel, { apply: true });
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
  options: { apply?: boolean; removeOrphans?: boolean } = {}
): Promise<void> {
  try {
    status.setBusy(`AI Rules: ${label}`);
    panel.setStatus(`${label}執行中...`);
    const output = await runner.run(action, options);
    if (/偵測到遠端更新|Yellow|規則與 source 不同|待授權|有差異/.test(output)) {
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

async function confirm(message: string): Promise<boolean> {
  const answer = await vscode.window.showWarningMessage(message, { modal: true }, "確認執行");
  return answer === "確認執行";
}
