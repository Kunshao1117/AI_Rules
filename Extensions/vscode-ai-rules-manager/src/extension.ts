import * as vscode from "vscode";
import { registerAiRulesCommands } from "./commands";
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

  context.subscriptions.push(output, status);
  context.subscriptions.push(
    vscode.window.registerWebviewViewProvider(AiRulesPanelProvider.viewType, panel)
  );
  registerAiRulesCommands(context, runner, status, panel);
  status.setIdle("AI Rules: ready");
}

export function deactivate(): void {
  // Nothing to dispose manually; subscriptions own runtime resources.
}
