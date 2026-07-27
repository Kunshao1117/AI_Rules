import * as crypto from "crypto";
import * as vscode from "vscode";
import type { UserFacingResult } from "./userFacing";

type PanelButton = readonly [command: string, title: string, description: string];

export class AiRulesPanelProvider implements vscode.WebviewViewProvider {
  static readonly viewType = "aiRules.panel";
  private static readonly allowedCommands = new Set([
    "aiRules.checkUpdate",
    "aiRules.checkExtensionUpdate",
    "aiRules.showTechnicalDetails",
    "aiRules.planUpdate",
    "aiRules.applyUpdate",
    "aiRules.syncGlobalRules",
    "aiRules.syncProjectRules",
    "aiRules.syncProjectRulesCodex",
    "aiRules.syncProjectRulesClaude",
    "aiRules.syncProjectRulesAntigravity",
    "aiRules.gitignoreMaintenance",
    "aiRules.memoryMigration",
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

  setResult(result: UserFacingResult): void {
    void this.view?.webview.postMessage({ type: "result", result });
  }

  private getHtml(): string {
    const nonce = crypto.randomBytes(16).toString("base64");
    const primary: PanelButton[] = [
      ["aiRules.checkUpdate", "檢查目前狀態", "確認 AI Rules 是否可以正常使用。"],
      ["aiRules.applyUpdate", "更新 AI Rules", "下載最新規則；不會修改目前專案。"],
      ["aiRules.syncProjectRules", "同步到目前專案", "更新已安裝 AI 工具的規則，並保留你的專案內容。"]
    ];
    const supporting: PanelButton[] = [
      ["aiRules.checkExtensionUpdate", "檢查插件更新", "確認是否有可下載的新版本。"],
      ["aiRules.planUpdate", "查看可更新內容", "先了解規則更新可能帶來的變化。"],
      ["aiRules.showTechnicalDetails", "查看技術資料", "開啟完整的操作紀錄與診斷資訊。"]
    ];
    const advanced: PanelButton[] = [
      ["aiRules.syncGlobalRules", "更新個人共用規則", "更新你已安裝 AI 工具的個人規則。"],
      ["aiRules.syncProjectRulesCodex", "只同步 Codex", "只更新目前專案中的 Codex 規則。"],
      ["aiRules.syncProjectRulesClaude", "只同步 Claude", "只更新目前專案中的 Claude 規則。"],
      ["aiRules.syncProjectRulesAntigravity", "只同步 Antigravity", "只更新目前專案中的 Antigravity 規則。"],
      ["aiRules.gitignoreMaintenance", "整理不需要上傳的檔案規則", "先檢查，再由你決定是否整理。"],
      ["aiRules.memoryMigration", "整理舊版記憶檔", "先檢查，再確認是否安全整理。"],
      ["aiRules.cleanupOrphans", "檢查可清理的舊檔案", "只會在你確認後刪除已列出的檔案。"]
    ];
    const buttons = (items: PanelButton[]) => items.map(([command, title, description]) =>
      `<button data-command="${command}"><span class="title">${title}</span><span class="desc">${description}</span></button>`
    ).join("");

    return `<!DOCTYPE html>
<html lang="zh-Hant">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="Content-Security-Policy" content="default-src 'none'; style-src 'unsafe-inline'; script-src 'nonce-${nonce}';">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body { font-family: var(--vscode-font-family); padding: 12px; color: var(--vscode-foreground); }
    h2 { font-size: 15px; margin: 0 0 12px; }
    .status { border: 1px solid var(--vscode-panel-border); border-radius: 4px; padding: 10px; margin-bottom: 14px; }
    .label, .section-title { display: block; font-size: 11px; font-weight: 700; opacity: 0.72; margin-bottom: 4px; }
    #status-title { display: block; font-weight: 700; }
    #status-summary, #status-next { margin: 6px 0 0; font-size: 12px; line-height: 1.45; }
    .section-title { margin: 16px 0 5px; }
    button { width: 100%; text-align: left; padding: 9px 10px; margin: 5px 0; border: 1px solid var(--vscode-button-border, transparent); background: var(--vscode-button-secondaryBackground); color: var(--vscode-button-secondaryForeground); cursor: pointer; }
    button:hover { background: var(--vscode-button-secondaryHoverBackground); }
    .title { display: block; font-weight: 600; }
    .desc { display: block; opacity: 0.8; font-size: 12px; margin-top: 2px; line-height: 1.35; }
    details { margin-top: 16px; }
    summary { cursor: pointer; font-weight: 700; font-size: 12px; }
  </style>
</head>
<body>
  <h2>AI Rules 狀態</h2>
  <div class="status" aria-live="polite">
    <span class="label">目前狀態</span>
    <strong id="status-title">尚未檢查</strong>
    <p id="status-summary">先檢查目前狀態，確認 AI Rules 是否可以正常使用。</p>
    <p id="status-next">建議下一步：檢查目前狀態</p>
  </div>
  <div class="section-title">主要操作</div>
  ${buttons(primary)}
  <div class="section-title">其他操作</div>
  ${buttons(supporting)}
  <details>
    <summary>進階工具</summary>
    ${buttons(advanced)}
  </details>
  <script nonce="${nonce}">
    const vscode = acquireVsCodeApi();
    document.querySelectorAll("button[data-command]").forEach((button) => {
      button.addEventListener("click", () => vscode.postMessage({ command: button.dataset.command }));
    });
    window.addEventListener("message", (event) => {
      if (event.data.type !== "result") return;
      const result = event.data.result;
      document.getElementById("status-title").textContent = result.title;
      document.getElementById("status-summary").textContent = result.impact ? result.summary + " " + result.impact : result.summary;
      document.getElementById("status-next").textContent = "建議下一步：" + (result.nextAction || "你現在不用做任何事。");
    });
  </script>
</body>
</html>`;
  }
}
