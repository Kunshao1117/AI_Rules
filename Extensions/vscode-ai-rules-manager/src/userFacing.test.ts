import * as assert from "node:assert";
import {
  cancelledResult,
  describeManagerOutput,
  describeRunError,
  extensionIsCurrent,
  extensionUpdateAvailable
} from "./userFacing";

function check(condition: unknown, message: string): void {
  assert.ok(condition, message);
}

const normal = describeManagerOutput("Check", "Green: 3\nYellow: 0\nRed: 0");
check(normal.summary === "AI Rules 可以正常使用，目前沒有需要處理的問題。", "normal status should be plain language");
check(normal.technicalDetailsAvailable, "technical details should remain available");

const update = describeManagerOutput("Check", "狀態：偵測到遠端更新");
check(update.status === "update" && update.summary.includes("不會修改目前專案"), "source update should explain impact");

const preview = describeManagerOutput("SyncProjectRules", "完成", { projectPlatform: "Auto" });
check(preview.title === "已完成預先檢查", "project sync preview should prepare a confirmation");

const noPlatform = describeManagerOutput("SyncProjectRules", "目前沒有可同步的平台", { projectPlatform: "Auto" });
check(noPlatform.state === "noChange" && noPlatform.summary.includes("沒有修改任何內容"), "missing platforms should not be an error");

const untrusted = describeRunError(new Error("目前 VS Code workspace 尚未受信任"));
check(untrusted.summary.includes("尚未被 VS Code 設為信任") && untrusted.impact === "沒有修改任何內容。", "workspace trust should be actionable");

const sourceTrust = describeRunError(new Error("尚未信任 AI_Rules 來源"));
check(sourceTrust.state === "cancelled", "untrusted custom sources should be a safe cancellation");

const powershell = describeRunError(new Error("powershell.exe ENOENT"));
check(powershell.title === "無法啟動管理工具", "PowerShell failures should be classified");

const git = describeRunError(new Error("找不到 Git"));
check(git.title === "無法使用 Git", "Git failures should be classified");

const sourceUrl = describeRunError(new Error("aiRules.repoUrl 必須是 GitHub HTTPS repository URL"));
check(sourceUrl.title === "來源設定無法使用", "invalid source URLs should be classified");

const cache = describeRunError(new Error("AI_Rules 管理快取無法驗證"));
check(cache.title === "AI Rules 快取無法使用", "managed caches should be classified");

const script = describeRunError(new Error("找不到 Scripts\\AI-RulesManager.ps1"));
check(script.title === "找不到管理工具", "missing manager scripts should be classified");

const unsafeChanges = describeRunError(new Error("工作樹有變更，無法安全覆蓋"));
check(unsafeChanges.title === "需要保留目前修改", "unsafe project changes should be classified");

const previewFailure = describeRunError(new Error("預覽失敗"));
check(previewFailure.title === "預先檢查沒有完成", "preview failures should be classified");

check(extensionIsCurrent().title === "插件目前已是最新版本", "current plugin status should be clear");
check(extensionUpdateAvailable().summary.includes("重新啟動 VS Code"), "new plugin update should describe its effect");
check(cancelledResult().state === "cancelled", "cancellation should not be treated as failure");

console.log("User-facing message scenarios passed.");
