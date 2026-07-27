import * as vscode from "vscode";
import { ExtensionUpdateChecker } from "./extensionUpdate";
import { AiRulesPanelProvider } from "./panel";
import { GitignoreMode, ManagerAction, ProjectPlatform, RunOptions, ScriptRunner } from "./scriptRunner";
import { AiRulesStatus } from "./status";
import {
  cancelledResult,
  confirmationFor,
  describeManagerOutput,
  describeRunError,
  busyResult,
  resultMessage,
  technicalResultLabel,
  UserFacingResult
} from "./userFacing";

const VIEW_TECHNICAL_DETAILS = "查看技術資料";

export function registerAiRulesCommands(
  context: vscode.ExtensionContext,
  runner: ScriptRunner,
  status: AiRulesStatus,
  panel: AiRulesPanelProvider,
  updateChecker: ExtensionUpdateChecker
): void {
  const runReadOnly = (commandId: string, action: ManagerAction) => {
    context.subscriptions.push(vscode.commands.registerCommand(commandId, async () => {
      await run(action, runner, status, panel);
    }));
  };

  runReadOnly("aiRules.checkUpdate", "Check");
  context.subscriptions.push(vscode.commands.registerCommand("aiRules.checkExtensionUpdate", async () => {
    await updateChecker.checkForUpdates({ manual: true });
  }));
  context.subscriptions.push(vscode.commands.registerCommand("aiRules.showTechnicalDetails", () => runner.showTechnicalDetails()));
  runReadOnly("aiRules.planUpdate", "Plan");

  context.subscriptions.push(vscode.commands.registerCommand("aiRules.applyUpdate", async () => {
    if (await confirm("updateRules", runner, status, panel)) await run("Apply", runner, status, panel, { apply: true });
  }));

  context.subscriptions.push(vscode.commands.registerCommand("aiRules.syncGlobalRules", async () => {
    const preview = await run("SyncGlobal", runner, status, panel);
    if (!canContinueAfterPreview(preview)) return;
    if (await confirm("syncGlobal", runner, status, panel)) await run("SyncGlobal", runner, status, panel, { apply: true });
  }));

  context.subscriptions.push(vscode.commands.registerCommand("aiRules.syncProjectRules", async () => {
    await runProjectSync("Auto", runner, status, panel);
  }));

  context.subscriptions.push(vscode.commands.registerCommand("aiRules.syncProjectRulesCodex", async () => {
    await runProjectSync("Codex", runner, status, panel);
  }));

  context.subscriptions.push(vscode.commands.registerCommand("aiRules.syncProjectRulesClaude", async () => {
    await runProjectSync("Claude", runner, status, panel);
  }));

  context.subscriptions.push(vscode.commands.registerCommand("aiRules.syncProjectRulesAntigravity", async () => {
    await runProjectSync("Antigravity", runner, status, panel);
  }));

  context.subscriptions.push(vscode.commands.registerCommand("aiRules.cleanupOrphans", async () => {
    const preview = await run("CleanupOrphans", runner, status, panel);
    if (!canContinueAfterPreview(preview)) return;
    if (await confirm("cleanup", runner, status, panel)) await run("CleanupOrphans", runner, status, panel, { apply: true, removeOrphans: true });
  }));

  context.subscriptions.push(vscode.commands.registerCommand("aiRules.memoryMigration", async () => {
    const preview = await run("MemoryMigration", runner, status, panel);
    if (!canContinueAfterPreview(preview)) return;
    if (await confirm("memoryMigration", runner, status, panel)) await run("MemoryMigration", runner, status, panel, { apply: true });
  }));

  context.subscriptions.push(vscode.commands.registerCommand("aiRules.gitignoreMaintenance", async () => {
    const preview = await run("Gitignore", runner, status, panel);
    if (!canContinueAfterPreview(preview)) return;
    const confirmation = confirmationFor("gitignore");
    const choice = await vscode.window.showWarningMessage(
      confirmation.message,
      { modal: true },
      "只補標準規則",
      "刪除列出的相似規則"
    );
    if (!choice) {
      await present(cancelledResult(), runner, status, panel);
      return;
    }
    const mode: GitignoreMode = choice === "刪除列出的相似規則" ? "CleanSimilar" : "Append";
    await run("Gitignore", runner, status, panel, { apply: true, gitignoreMode: mode });
  }));
}

async function run(
  action: ManagerAction,
  runner: ScriptRunner,
  status: AiRulesStatus,
  panel: AiRulesPanelProvider,
  options: RunOptions = {}
): Promise<UserFacingResult> {
  const busy = busyResult(action, options);
  status.setState(busy.status);
  panel.setResult(busy);

  try {
    const output = await runner.run(action, options);
    const result = describeManagerOutput(action, output, options);
    runner.appendResult(technicalResultLabel(result));
    await present(result, runner, status, panel);
    return result;
  } catch (error) {
    runner.recordFailure(error);
    const result = describeRunError(error);
    runner.appendResult(technicalResultLabel(result));
    await present(result, runner, status, panel, result.state === "error");
    return result;
  }
}

async function runProjectSync(
  projectPlatform: ProjectPlatform,
  runner: ScriptRunner,
  status: AiRulesStatus,
  panel: AiRulesPanelProvider
): Promise<void> {
  const preview = await run("SyncProjectRules", runner, status, panel, { projectPlatform });
  if (!canContinueAfterPreview(preview)) return;
  if (await confirm("syncProject", runner, status, panel)) {
    await run("SyncProjectRules", runner, status, panel, { apply: true, projectPlatform });
  }
}

async function confirm(
  kind: Parameters<typeof confirmationFor>[0],
  runner: ScriptRunner,
  status: AiRulesStatus,
  panel: AiRulesPanelProvider
): Promise<boolean> {
  const confirmation = confirmationFor(kind);
  const answer = await vscode.window.showWarningMessage(
    confirmation.message,
    { modal: true },
    confirmation.confirmLabel,
    "取消"
  );
  if (answer === confirmation.confirmLabel) return true;
  await present(cancelledResult(), runner, status, panel);
  return false;
}

function canContinueAfterPreview(result: UserFacingResult): boolean {
  return result.state === "success" || result.state === "attention";
}

async function present(
  result: UserFacingResult,
  runner: ScriptRunner,
  status: AiRulesStatus,
  panel: AiRulesPanelProvider,
  showTechnicalDetails = false
): Promise<void> {
  status.setState(result.status);
  panel.setResult(result);
  if (showTechnicalDetails) runner.showTechnicalDetails();

  const message = `${result.title}\n${resultMessage(result)}`;
  const actions = result.technicalDetailsAvailable ? [VIEW_TECHNICAL_DETAILS] : [];
  const selected = result.state === "error"
    ? await vscode.window.showErrorMessage(message, ...actions)
    : result.state === "attention"
      ? await vscode.window.showWarningMessage(message, ...actions)
      : await vscode.window.showInformationMessage(message, ...actions);
  if (selected === VIEW_TECHNICAL_DETAILS) runner.showTechnicalDetails();
}
