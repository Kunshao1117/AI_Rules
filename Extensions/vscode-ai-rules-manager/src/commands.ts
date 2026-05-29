import * as vscode from "vscode";
import { ExtensionUpdateChecker } from "./extensionUpdate";
import { AiRulesPanelProvider } from "./panel";
import { GitignoreMode, ManagerAction, ProjectPlatform, RunOptions, ScriptRunner } from "./scriptRunner";
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

  runReadOnly("aiRules.checkUpdate", "檢查來源狀態", "Check");
  context.subscriptions.push(vscode.commands.registerCommand("aiRules.checkExtensionUpdate", async () => {
    await updateChecker.checkForUpdates({ manual: true });
  }));
  runReadOnly("aiRules.planUpdate", "查看來源更新影響", "Plan");
  runReadOnly("aiRules.doctor", "治理巡檢 Doctor", "Doctor");

  context.subscriptions.push(vscode.commands.registerCommand("aiRules.applyUpdate", async () => {
    const ok = await confirm("這會對齊 AI_Rules 遠端來源庫，然後跑治理巡檢。不會安裝新版 VSIX，也不會同步目前專案的 .agents / .claude / .codex。明確設定的本機來源只檢查狀態，不會被自動重設。");
    if (ok) await run("對齊 AI_Rules 遠端來源", "Apply", runner, status, panel, { apply: true });
  }));

  context.subscriptions.push(vscode.commands.registerCommand("aiRules.syncGlobalRules", async () => {
    const previewOk = await run("同步使用者層規則預覽", "SyncGlobal", runner, status, panel);
    if (!previewOk) return;
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
    const previewOk = await run("孤兒檔案預覽", "CleanupOrphans", runner, status, panel);
    if (!previewOk) return;
    const ok = await confirm("要刪除上方列出的孤兒檔案嗎？memory / project_skills / context 不會被清理。");
    if (ok) await run("清理孤兒檔案", "CleanupOrphans", runner, status, panel, { apply: true, removeOrphans: true });
  }));

  context.subscriptions.push(vscode.commands.registerCommand("aiRules.gitignoreMaintenance", async () => {
    const previewOk = await run("版控排除規則健檢", "Gitignore", runner, status, panel);
    if (!previewOk) return;
    const choice = await vscode.window.showWarningMessage(
      "要如何處理目前專案的 .gitignore？若已有 AI Rules 管理區塊，會更新同一區塊不重複插入。不覆蓋會保留既有寬鬆規則並補入根目錄標準區塊；覆蓋會移除 AI Rules 相關寬鬆規則與舊管理區塊後重建標準區塊。",
      { modal: true },
      "不覆蓋，補標準區塊",
      "覆蓋整理 AI Rules 規則"
    );
    if (!choice) return;
    const mode: GitignoreMode = choice === "覆蓋整理 AI Rules 規則" ? "Overwrite" : "Append";
    await run("版控排除規則整理", "Gitignore", runner, status, panel, { apply: true, gitignoreMode: mode });
  }));
}

async function run(
  label: string,
  action: ManagerAction,
  runner: ScriptRunner,
  status: AiRulesStatus,
  panel: AiRulesPanelProvider,
  options: RunOptions = {}
): Promise<boolean> {
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
    return true;
  } catch (error) {
    status.setWarning("AI Rules: 失敗");
    panel.setStatus(`${label}失敗`);
    const message = error instanceof Error ? error.message : String(error);
    void vscode.window.showErrorMessage(message);
    return false;
  }
}

async function runProjectSync(
  label: string,
  projectPlatform: ProjectPlatform,
  runner: ScriptRunner,
  status: AiRulesStatus,
  panel: AiRulesPanelProvider
): Promise<void> {
  const previewOk = await run(`${label}預覽`, "SyncProjectRules", runner, status, panel, { projectPlatform });
  if (!previewOk) return;
  const ok = await confirm("要先確認 AI_Rules 遠端來源已對齊，再把規則、Shared Skills 與平台入口同步到目前專案已安裝的平台嗎？未安裝平台不會被建立，memory / project_skills / context 不會被覆寫。");
  if (ok) await run(label, "SyncProjectRules", runner, status, panel, { apply: true, projectPlatform });
}

async function confirm(message: string): Promise<boolean> {
  const answer = await vscode.window.showWarningMessage(message, { modal: true }, "確認執行");
  return answer === "確認執行";
}

function needsAttention(output: string): boolean {
  return /狀態：偵測到遠端更新|狀態：可快轉更新|狀態：來源庫分叉|狀態：本機領先遠端|工作樹有變更/.test(output)
    || hasPositiveCounter(output, "Yellow")
    || hasPositiveCounter(output, "Red")
    || /規則與 source 不同|待授權|有差異|來源庫更新失敗|無法快轉/.test(output)
    || /缺少標準根目錄規則：\s*[1-9]/.test(output)
    || /寬鬆規則：\s*[1-9]/.test(output);
}

function hasPositiveCounter(output: string, label: "Yellow" | "Red"): boolean {
  const pattern = new RegExp(`${label}[：:]\\s*(\\d+)`, "g");
  let match: RegExpExecArray | null;
  while ((match = pattern.exec(output)) !== null) {
    if (Number.parseInt(match[1], 10) > 0) return true;
  }
  return false;
}
