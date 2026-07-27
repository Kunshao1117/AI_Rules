import type { ManagerAction, RunOptions } from "./scriptRunner";

// User-visible wording follows Shared/policies/language-governance.md.
export const LANGUAGE_GOVERNANCE_SOURCE = "Shared/policies/language-governance.md";

export type UserResultState = "success" | "noChange" | "attention" | "cancelled" | "error";
export type UserStatus = "normal" | "busy" | "update" | "attention" | "warning" | "error" | "unavailable";

export interface UserFacingResult {
  state: UserResultState;
  status: UserStatus;
  title: string;
  summary: string;
  impact?: string;
  nextAction?: string;
  technicalDetailsAvailable: boolean;
}

export interface UserFacingConfirmation {
  message: string;
  confirmLabel: string;
}

export type ConfirmationKind = "updateRules" | "syncGlobal" | "syncProject" | "cleanup" | "memoryMigration" | "gitignore" | "trustSource" | "rebuildCache";

const TECHNICAL_DETAILS = true;

export function operationLabel(action: ManagerAction, options: RunOptions = {}): string {
  if (action === "Check") return "檢查目前狀態";
  if (action === "Plan") return "查看可更新內容";
  if (action === "Apply") return "更新 AI Rules";
  if (action === "SyncGlobal") return options.apply ? "更新個人共用規則" : "預先檢查個人共用規則";
  if (action === "SyncProjectRules") {
    const platform = options.projectPlatform;
    const target = platform && platform !== "Auto" ? `只同步 ${platform}` : "同步到目前專案";
    return options.apply ? target : `預先檢查：${target}`;
  }
  if (action === "Gitignore") return options.apply ? "整理不需要上傳的檔案規則" : "檢查不需要上傳的檔案規則";
  if (action === "MemoryMigration") return options.apply ? "整理舊版記憶檔" : "檢查舊版記憶檔";
  return options.apply ? "刪除列出的舊檔案" : "檢查可清理的舊檔案";
}

export function confirmationFor(kind: ConfirmationKind): UserFacingConfirmation {
  const confirmations: Record<ConfirmationKind, UserFacingConfirmation> = {
    updateRules: {
      message: "是否更新 AI Rules？這會下載最新規則，但不會修改目前專案，也不會更新插件本身。取消不會影響現有內容。",
      confirmLabel: "更新 AI Rules"
    },
    syncGlobal: {
      message: "是否更新個人共用規則？這會更新你已安裝 AI 工具的個人規則並保留現有設定的備份。取消不會修改目前專案。",
      confirmLabel: "更新個人共用規則"
    },
    syncProject: {
      message: "是否將最新規則套用到目前專案？這會更新已安裝的 AI 工具規則。專案記憶、專案設定和你尚未提交的修改會被保留；未安裝的工具不會被新增。取消不會修改任何內容。",
      confirmLabel: "同步到目前專案"
    },
    cleanup: {
      message: "是否刪除剛才列出的舊檔案？只會處理 AI Rules 已確認不再使用的檔案。專案記憶、專案設定與你自行修改的內容不會被刪除。取消不會修改任何內容。",
      confirmLabel: "刪除列出的舊檔案"
    },
    memoryMigration: {
      message: "是否整理剛才列出的舊版記憶檔？只有確認可安全整理的作用中記憶檔會變更；發現衝突時會停止。取消不會修改任何內容。",
      confirmLabel: "整理舊版記憶檔"
    },
    gitignore: {
      message: "是否整理不需要上傳的檔案規則？只會補入 AI Rules 的標準規則；若你選擇清理相似規則，只會處理剛才列出的項目。其他註解與專案設定會保留。",
      confirmLabel: "繼續整理"
    },
    trustSource: {
      message: "目前設定使用的是非預設 AI Rules 來源。信任後，插件可以下載並更新這個來源中的規則。只有插件管理的快取資料夾會被重新整理，不會清理目前專案。",
      confirmLabel: "信任並繼續"
    },
    rebuildCache: {
      message: "插件管理的 AI Rules 快取無法確認是否安全使用。重新建立只會處理插件管理的快取資料夾，不會修改目前專案。取消後不會執行任何管理動作。",
      confirmLabel: "重新建立快取"
    }
  };
  return confirmations[kind];
}

export function busyResult(action: ManagerAction, options: RunOptions = {}): UserFacingResult {
  return result("success", "busy", "AI Rules：處理中", `正在${operationLabel(action, options)}。`, undefined, "完成後會顯示結果。", false);
}

export function describeManagerOutput(action: ManagerAction, output: string, options: RunOptions = {}): UserFacingResult {
  if (hasNoPlatform(output)) {
    return result("noChange", "normal", "目前沒有可同步的工具", "目前專案沒有找到可同步的 AI 工具規則，因此沒有修改任何內容。", undefined, "你現在不用做任何事。", TECHNICAL_DETAILS);
  }

  if (needsAttention(output)) {
    if (action === "Check" || action === "Plan") {
      return result("attention", "update", "AI Rules：有更新", "有新版規則可以更新。更新只會下載 AI Rules，不會修改目前專案。", undefined, "你可以按「更新 AI Rules」，或先查看可更新內容。", TECHNICAL_DETAILS);
    }
    return result("attention", "attention", "AI Rules：需要確認", "主要工作已完成，但還有一項需要你確認。插件沒有自動覆蓋可能影響你的內容。", undefined, "按「查看技術資料」可以了解下一步。", TECHNICAL_DETAILS);
  }

  if (action === "Check") {
    return result("success", "normal", "AI Rules：正常", "AI Rules 可以正常使用，目前沒有需要處理的問題。", undefined, "你現在不用做任何事。", TECHNICAL_DETAILS);
  }
  if (action === "Plan") {
    return result("noChange", "normal", "已完成檢查", "目前沒有需要更新的內容。", "這次檢查沒有修改目前專案。", "你現在不用做任何事。", TECHNICAL_DETAILS);
  }
  if (action === "SyncProjectRules" && !options.apply) {
    return result("success", "attention", "已完成預先檢查", "接下來可以更新目前專案中已安裝的 AI 工具規則，並保留專案記憶與現有修改。", undefined, "請確認是否繼續同步。", TECHNICAL_DETAILS);
  }
  if (action === "SyncProjectRules") {
    return result("success", "normal", "同步完成", "已更新目前專案中已安裝的 AI 工具規則。", "專案記憶與尚未提交的修改已保留。", "你現在不用做任何事。", TECHNICAL_DETAILS);
  }
  if (action === "Apply") {
    return result("success", "normal", "更新完成", "AI Rules 已完成更新處理。", "目前專案與插件本身沒有被修改。", "你現在不用做任何事。", TECHNICAL_DETAILS);
  }
  return result("success", "normal", "操作完成", `${operationLabel(action, options)}已完成。`, undefined, "你現在不用做任何事。", TECHNICAL_DETAILS);
}

export function describeRunError(error: unknown): UserFacingResult {
  if (isCancellation(error)) return cancelledResult();

  const message = errorMessage(error);
  if (/workspace.*受信任|工作區.*受信任/i.test(message)) {
    return result("error", "unavailable", "AI Rules：目前無法使用", "目前專案尚未被 VS Code 設為信任。為了避免陌生專案執行管理指令，插件已停止。", "沒有修改任何內容。", "將專案設為信任後再重試，或查看技術資料。", TECHNICAL_DETAILS);
  }
  if (/workspace|工作區|本機檔案/i.test(message) && /(不存在|不是目錄|只能對)/i.test(message)) {
    return result("error", "unavailable", "目前無法執行", "尚未開啟可使用的本機資料夾，因此插件無法判斷要處理哪個專案。", "沒有修改任何內容。", "先開啟專案資料夾後再重試。", TECHNICAL_DETAILS);
  }
  if (/repoUrl|GitHub HTTPS|來源網址|URL/i.test(message)) {
    return result("error", "error", "來源設定無法使用", "AI Rules 的來源網址格式不正確，因此插件已停止。", "沒有修改目前專案。", "請檢查使用者設定中的來源網址，或查看技術資料。", TECHNICAL_DETAILS);
  }
  if (/尚未信任|信任.*來源/i.test(message)) {
    return result("cancelled", "attention", "已取消", "尚未信任這個自訂來源，因此插件沒有下載或修改任何內容。", "目前專案沒有被清理或修改。", "確認來源可信後，再選擇「信任並繼續」。", TECHNICAL_DETAILS);
  }
  if (/管理快取|managed cache/i.test(message)) {
    return result("error", "error", "AI Rules 快取無法使用", "插件無法確認管理快取是否安全，因此已停止。", "沒有修改目前專案。", "你可以稍後重試，或查看技術資料。", TECHNICAL_DETAILS);
  }
  if (/找不到.*AI-RulesManager|管理腳本|manager script/i.test(message)) {
    return result("error", "error", "找不到管理工具", "AI Rules 需要的管理工具不存在或無法使用，因此插件已停止。", "沒有修改目前專案。", "請更新 AI Rules 後再重試，或查看技術資料。", TECHNICAL_DETAILS);
  }
  if (/工作樹|未提交|安全覆蓋|dirty/i.test(message)) {
    return result("error", "attention", "需要保留目前修改", "目前專案有無法安全覆蓋的修改，因此插件已停止。", "你的現有修改已保留。", "請先查看問題，確認後再決定下一步。", TECHNICAL_DETAILS);
  }
  if (/預覽|preview/i.test(message)) {
    return result("error", "error", "預先檢查沒有完成", "插件無法安全確認接下來的修改，因此沒有繼續寫入。", "沒有修改任何內容。", "查看技術資料後修正問題，再重新嘗試。", TECHNICAL_DETAILS);
  }
  if (/powershell|ENOENT/i.test(message)) {
    return result("error", "unavailable", "無法啟動管理工具", "PowerShell 無法執行 AI Rules 的管理工具，因此插件已停止。", "沒有修改任何內容。", "檢查使用者設定後再試，或查看技術資料。", TECHNICAL_DETAILS);
  }
  if (/找不到 Git|Git 指令失敗|git /i.test(message)) {
    return result("error", "unavailable", "無法使用 Git", "AI Rules 無法使用必要的版本管理工具，因此插件已停止。", "沒有修改任何內容。", "確認 Git 可使用後再試，或查看技術資料。", TECHNICAL_DETAILS);
  }
  return result("error", "error", "發生未預期的問題", "插件已停止，沒有繼續寫入。", "目前無法從這個訊息判斷確切原因。", "請按「查看技術資料」取得完整錯誤內容。", TECHNICAL_DETAILS);
}

export function cancelledResult(): UserFacingResult {
  return result("cancelled", "normal", "已取消", "已取消，沒有修改任何內容。", undefined, "你可以在準備好後重新操作。", TECHNICAL_DETAILS);
}

export function extensionUpdateAvailable(): UserFacingResult {
  return result("attention", "update", "AI Rules：有更新", "有新版插件可以下載。目前版本仍可使用；更新後需要重新啟動 VS Code。", undefined, "按「前往下載頁」取得新版。", TECHNICAL_DETAILS);
}

export function extensionIsCurrent(): UserFacingResult {
  return result("noChange", "normal", "插件目前已是最新版本", "目前不需要下載或安裝新版插件。", undefined, "你現在不用做任何事。", TECHNICAL_DETAILS);
}

export function extensionUpdateError(): UserFacingResult {
  return result("error", "warning", "無法檢查插件更新", "目前無法確認是否有新版插件。", "目前安裝的版本仍可繼續使用。", "請稍後再試，或查看技術資料。", TECHNICAL_DETAILS);
}

export function resultMessage(result: UserFacingResult): string {
  return [result.summary, result.impact, result.nextAction].filter((value): value is string => Boolean(value)).join("\n");
}

export function technicalResultLabel(result: UserFacingResult): string {
  if (result.state === "error") return "失敗";
  if (result.state === "attention") return "需要處理";
  if (result.state === "cancelled") return "已取消";
  return "成功";
}

function result(
  state: UserResultState,
  status: UserStatus,
  title: string,
  summary: string,
  impact: string | undefined,
  nextAction: string | undefined,
  technicalDetailsAvailable: boolean
): UserFacingResult {
  return { state, status, title, summary, impact, nextAction, technicalDetailsAvailable };
}

function needsAttention(output: string): boolean {
  return /狀態：偵測到遠端更新|狀態：可快轉更新|狀態：來源庫分叉|狀態：本機領先遠端|工作樹有變更/.test(output)
    || hasPositiveCounter(output, "Yellow")
    || hasPositiveCounter(output, "Red")
    || /規則與 source 不同|待授權|有差異|來源庫更新失敗|無法快轉/.test(output)
    || /缺少標準根目錄規則：\s*[1-9]/.test(output)
    || /寬鬆規則：\s*[1-9]/.test(output)
    || /舊主檔（SKILL\.md）：\s*[1-9]/.test(output)
    || /雙主檔衝突：\s*[1-9]/.test(output)
    || /文內舊路徑引用：\s*[1-9]/.test(output);
}

function hasNoPlatform(output: string): boolean {
  return /沒有.*可同步.*平台|未偵測到.*平台|沒有安裝.*平台/.test(output);
}

function hasPositiveCounter(output: string, label: "Yellow" | "Red"): boolean {
  const pattern = new RegExp(`${label}[：:]\\s*(\\d+)`, "g");
  let match: RegExpExecArray | null;
  while ((match = pattern.exec(output)) !== null) {
    if (Number.parseInt(match[1], 10) > 0) return true;
  }
  return false;
}

function isCancellation(error: unknown): boolean {
  return error instanceof Error && error.name === "UserCancelledError";
}

function errorMessage(error: unknown): string {
  return error instanceof Error ? error.message : String(error);
}
