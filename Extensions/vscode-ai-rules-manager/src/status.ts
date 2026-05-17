import * as vscode from "vscode";

export class AiRulesStatus implements vscode.Disposable {
  private readonly item = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 50);

  constructor() {
    this.item.command = "aiRules.checkUpdate";
    this.item.show();
  }

  setIdle(text = "AI Rules: OK"): void {
    this.item.text = "$(shield) " + text;
    this.item.tooltip = "AI_Rules 管理器";
    this.item.backgroundColor = undefined;
  }

  setBusy(text: string): void {
    this.item.text = "$(sync~spin) " + text;
    this.item.tooltip = "AI_Rules 正在執行";
  }

  setWarning(text: string): void {
    this.item.text = "$(warning) " + text;
    this.item.tooltip = "AI_Rules 需要處理";
    this.item.backgroundColor = new vscode.ThemeColor("statusBarItem.warningBackground");
  }

  dispose(): void {
    this.item.dispose();
  }
}
