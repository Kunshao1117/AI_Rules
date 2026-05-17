import * as crypto from "crypto";
import * as vscode from "vscode";

export class AiRulesPanelProvider implements vscode.WebviewViewProvider {
  static readonly viewType = "aiRules.panel";
  private static readonly allowedCommands = new Set([
    "aiRules.checkUpdate",
    "aiRules.planUpdate",
    "aiRules.applyUpdate",
    "aiRules.doctor",
    "aiRules.syncGlobalRules",
    "aiRules.cleanupOrphans"
  ]);

  private view?: vscode.WebviewView;

  constructor(
    private readonly extensionUri: vscode.Uri,
    private readonly runAction: (commandId: string) => void
  ) {}

  resolveWebviewView(webviewView: vscode.WebviewView): void {
    this.view = webviewView;
    webviewView.webview.options = { enableScripts: true };
    webviewView.webview.html = this.getHtml();
    webviewView.webview.onDidReceiveMessage((message: { command?: string }) => {
      if (message.command && AiRulesPanelProvider.allowedCommands.has(message.command)) {
        this.runAction(message.command);
      }
    });
  }

  setStatus(text: string): void {
    void this.view?.webview.postMessage({ type: "status", text });
  }

  private getHtml(): string {
    const nonce = crypto.randomBytes(16).toString("base64");
    const buttons = [
      ["aiRules.checkUpdate", "檢查更新", "讀取 Git 與全域規則狀態"],
      ["aiRules.planUpdate", "查看更新內容", "用白話列出更新影響"],
      ["aiRules.applyUpdate", "套用更新", "確認後更新 AI_Rules repo"],
      ["aiRules.doctor", "健康檢查", "執行治理巡檢"],
      ["aiRules.syncGlobalRules", "同步全域規則", "確認後更新使用者層規則"],
      ["aiRules.cleanupOrphans", "清理孤兒檔案", "先預覽，確認後清理"]
    ];

    return `<!DOCTYPE html>
<html lang="zh-Hant">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="Content-Security-Policy" content="default-src 'none'; style-src 'unsafe-inline'; script-src 'nonce-${nonce}';">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body { font-family: var(--vscode-font-family); padding: 12px; color: var(--vscode-foreground); }
    h2 { font-size: 15px; margin: 0 0 12px; }
    .status { border: 1px solid var(--vscode-panel-border); padding: 8px; margin-bottom: 12px; }
    button { width: 100%; text-align: left; padding: 9px 10px; margin: 5px 0; border: 1px solid var(--vscode-button-border, transparent); background: var(--vscode-button-secondaryBackground); color: var(--vscode-button-secondaryForeground); cursor: pointer; }
    button:hover { background: var(--vscode-button-secondaryHoverBackground); }
    .title { display: block; font-weight: 600; }
    .desc { display: block; opacity: 0.8; font-size: 12px; margin-top: 2px; }
  </style>
</head>
<body>
  <h2>AI Rules</h2>
  <div id="status" class="status">尚未執行檢查</div>
  ${buttons.map(([command, title, desc]) => `<button data-command="${command}"><span class="title">${title}</span><span class="desc">${desc}</span></button>`).join("")}
  <script nonce="${nonce}">
    const vscode = acquireVsCodeApi();
    document.querySelectorAll("button[data-command]").forEach((button) => {
      button.addEventListener("click", () => vscode.postMessage({ command: button.dataset.command }));
    });
    window.addEventListener("message", (event) => {
      if (event.data.type === "status") document.getElementById("status").textContent = event.data.text;
    });
  </script>
</body>
</html>`;
  }
}
