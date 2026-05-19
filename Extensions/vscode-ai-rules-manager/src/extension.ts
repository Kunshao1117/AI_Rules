import * as vscode from "vscode";
import { registerAiRulesCommands } from "./commands";
import { ExtensionUpdateChecker } from "./extensionUpdate";
import { AiRulesPanelProvider } from "./panel";
import { ScriptRunner } from "./scriptRunner";
import { AiRulesStatus } from "./status";

export function activate(context: vscode.ExtensionContext): void {
  const output = vscode.window.createOutputChannel("AI Rules");
  const status = new AiRulesStatus();
  const runner = new ScriptRunner(context, output);
  const panel = new AiRulesPanelProvider(context.extensionUri, (action) => {
    void vscode.commands.executeCommand(action);
  });
  const updateChecker = new ExtensionUpdateChecker(context, output, status, panel);

  context.subscriptions.push(output, status);
  context.subscriptions.push(
    vscode.window.registerWebviewViewProvider(AiRulesPanelProvider.viewType, panel)
  );
  registerAiRulesCommands(context, runner, status, panel, updateChecker);
  status.setIdle("AI Rules: ready");
  void updateChecker.checkForUpdates({ manual: false });
}

export function deactivate(): void {
  // Nothing to dispose manually; subscriptions own runtime resources.
}
