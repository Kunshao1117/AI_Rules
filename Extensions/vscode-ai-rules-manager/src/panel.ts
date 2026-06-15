import * as crypto from "crypto";
import * as vscode from "vscode";

export class AiRulesPanelProvider implements vscode.WebviewViewProvider {
  static readonly viewType = "aiRules.panel";
  private static readonly allowedCommands = new Set([
    "aiRules.checkUpdate",
    "aiRules.checkExtensionUpdate",
    "aiRules.planUpdate",
    "aiRules.applyUpdate",
    "aiRules.doctor",
    "aiRules.syncCoverageCheck",
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

  setStatus(text: string): void {
    void this.view?.webview.postMessage({ type: "status", text });
  }

  private getHtml(): string {
    const nonce = crypto.randomBytes(16).toString("base64");
    const sections = [
      {
        title: "來源更新與巡檢",
        buttons: [
          ["aiRules.checkUpdate", "檢查來源狀態", "讀取 AI_Rules 遠端來源與使用者層規則漂移"],
          ["aiRules.checkExtensionUpdate", "檢查 VSIX 新版", "查 GitHub Release 是否有新版安裝包"],
          ["aiRules.planUpdate", "查看來源更新影響", "說明遠端來源對齊後會做的巡檢"],
          ["aiRules.applyUpdate", "對齊 AI_Rules 遠端來源", "確認後對齊來源；不安裝 VSIX、不同步專案規則"],
          ["aiRules.doctor", "治理巡檢 Doctor", "只檢查規範、技能與連結；不寫入"],
          ["aiRules.syncCoverageCheck", "同步完整性檢查", "檢查共用治理參考、支援檔與外掛入口是否完整"]
        ]
      },
      {
        title: "規則同步",
        buttons: [
          ["aiRules.syncGlobalRules", "同步使用者層規則", "只更新 ~/.codex、~/.claude、~/.gemini"],
          ["aiRules.syncProjectRules", "同步已安裝平台規則", "先對齊遠端來源，再更新目前專案規則"]
        ]
      },
      {
        title: "單平台同步",
        buttons: [
          ["aiRules.syncProjectRulesCodex", "同步 Codex", "更新 .codex 與 Codex 工作流技能"],
          ["aiRules.syncProjectRulesClaude", "同步 Claude", "更新 .claude rules / commands / skills"],
          ["aiRules.syncProjectRulesAntigravity", "同步 Antigravity", "更新 .agents rules / workflows / skills"]
        ]
      },
      {
        title: "維護",
        buttons: [
          ["aiRules.gitignoreMaintenance", "版控排除規則健檢", "掃描 .gitignore，列出相似規則並補入帶繁中註解的標準規則"],
          ["aiRules.memoryMigration", "記憶主檔遷移", "先乾跑盤點；確認後才更名作用中記憶主檔"],
          ["aiRules.cleanupOrphans", "清理孤兒檔案", "先預覽，確認後清理"]
        ]
      }
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
    .section-title { font-size: 11px; font-weight: 700; opacity: 0.72; margin: 14px 0 4px; text-transform: uppercase; }
    button { width: 100%; text-align: left; padding: 9px 10px; margin: 5px 0; border: 1px solid var(--vscode-button-border, transparent); background: var(--vscode-button-secondaryBackground); color: var(--vscode-button-secondaryForeground); cursor: pointer; }
    button:hover { background: var(--vscode-button-secondaryHoverBackground); }
    .title { display: block; font-weight: 600; }
    .desc { display: block; opacity: 0.8; font-size: 12px; margin-top: 2px; }
  </style>
</head>
<body>
  <h2>AI Rules</h2>
  <div id="status" class="status">尚未執行檢查</div>
  ${sections.map((section) => `<div class="section-title">${section.title}</div>${section.buttons.map(([command, title, desc]) => `<button data-command="${command}"><span class="title">${title}</span><span class="desc">${desc}</span></button>`).join("")}`).join("")}
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
