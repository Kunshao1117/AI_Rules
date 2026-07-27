import * as vscode from "vscode";
import type { UserStatus } from "./userFacing";

export class AiRulesStatus implements vscode.Disposable {
  private readonly item = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 50);

  constructor() {
    this.item.command = "aiRules.checkUpdate";
    this.item.show();
  }

  setState(state: UserStatus): void {
    const presentation: Record<UserStatus, { icon: string; text: string; tooltip: string; background?: string }> = {
      normal: { icon: "$(shield)", text: "AI Rules：正常", tooltip: "AI Rules 可以正常使用。按一下可檢查目前狀態。" },
      busy: { icon: "$(sync~spin)", text: "AI Rules：處理中", tooltip: "AI Rules 正在處理你的操作。" },
      update: { icon: "$(cloud-download)", text: "AI Rules：有更新", tooltip: "有可下載的規則或插件更新。" },
      attention: { icon: "$(question)", text: "AI Rules：需要確認", tooltip: "有一項內容需要你確認後才能繼續。", background: "statusBarItem.warningBackground" },
      warning: { icon: "$(warning)", text: "AI Rules：需要處理", tooltip: "有需要注意的內容。按一下可檢查目前狀態。", background: "statusBarItem.warningBackground" },
      error: { icon: "$(error)", text: "AI Rules：發生問題", tooltip: "操作已停止。請查看問題或技術資料。", background: "statusBarItem.errorBackground" },
      unavailable: { icon: "$(circle-slash)", text: "AI Rules：目前無法使用", tooltip: "目前無法安全執行操作。請先處理提示的問題。", background: "statusBarItem.warningBackground" }
    };
    const current = presentation[state];
    this.item.text = `${current.icon} ${current.text}`;
    this.item.tooltip = current.tooltip;
    this.item.backgroundColor = current.background ? new vscode.ThemeColor(current.background) : undefined;
  }

  dispose(): void {
    this.item.dispose();
  }
}
