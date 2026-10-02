import * as assert from "node:assert";
import {
  cancelledResult,
  describeManagerOutput,
  describeRunError,
  extensionIsCurrent,
  extensionUpdateAvailable,
  technicalResultLabel
} from "./userFacing";

let assertions = 0;
function check(condition: unknown, message: string): void {
  assert.ok(condition, message);
  assertions += 1;
}

function frame(value: unknown): string {
  return "AI_RULES_MANAGER_RESULT:" + JSON.stringify({ Version: 1, Action: "SyncProjectRules", Result: value });
}

function syncResult(applied: boolean, succeeded = true): object {
  const names = applied
    ? ["平台規則：Codex", "初始化 Agent 基礎設施", "更新 .gitignore 規則", "回填專案技能連結"]
    : ["平台規則：Codex"];
  return {
    Succeeded: succeeded, Applied: applied, Platforms: ["Codex"],
    RequiredStageResults: names.map((Stage, index) => ({ Stage, Required: true, Succeeded: succeeded, Status: succeeded ? "Succeeded" : index === 0 ? "Failed" : "Skipped" }))
  };
}

const normal = describeManagerOutput("Check", "Green: 3\nYellow: 0\nRed: 0");
check(normal.summary === "AI Rules 可以正常使用，目前沒有需要處理的問題。", "normal status should be plain language");
check(normal.technicalDetailsAvailable, "technical details should remain available");

const update = describeManagerOutput("Check", "狀態：偵測到遠端更新");
check(update.status === "update" && update.summary.includes("不會修改目前專案"), "source update should explain impact");

const preview = describeManagerOutput("SyncProjectRules", "有差異\n" + frame(syncResult(false)), { projectPlatform: "Auto" });
check(preview.title === "已完成預先檢查", "project sync preview should prepare a confirmation");
check(preview.state === "preview" && preview.summary.includes("尚未套用"), "differences must remain preview only");
check(!preview.summary.includes("主要工作已完成") && technicalResultLabel(preview).includes("未套用"), "preview must not be logged as completed sync");

const noPlatform = describeManagerOutput("SyncProjectRules", frame({ Succeeded: true, Applied: false, Platforms: [], RequiredStageResults: [] }), { projectPlatform: "Auto" });
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

const success = describeManagerOutput("SyncProjectRules", frame(syncResult(true)), { apply: true });
check(success.state === "success" && success.title === "同步完成", "all required apply stages must retain normal success");
for (const exitCode of [0, 1]) {
  const failed = describeManagerOutput("SyncProjectRules", "同步完成\n" + frame(syncResult(true, false)), { apply: true }, exitCode);
  check(failed.state === "error" && failed.title === "同步沒有完成", "Succeeded=false must override success-looking text and exit code");
  check(failed.summary.includes("平台規則：Codex"), "failed required stage must be explained");
}
for (const action of ["Check", "Plan", "SyncProjectRules"] as const) {
  const diverged = describeManagerOutput(action, "狀態：來源庫分叉", {}, action === "SyncProjectRules" ? 1 : 0);
  check(diverged.state === "attention" && diverged.status !== "update", "divergence must not be advertised as an ordinary update");
  check(diverged.summary.includes("分叉") && !diverged.summary.includes("主要工作已完成"), "divergence must explain the source mismatch");
}
for (const output of ["", "unrecognized output", "同步完成", "AI_RULES_MANAGER_RESULT:broken", frame(null), frame({ Succeeded: "true" }), frame(syncResult(true)) + "\n" + frame(syncResult(true))]) {
  check(describeManagerOutput("SyncProjectRules", output, { apply: true }).state === "unknown", "missing, malformed or ambiguous result must not imply success");
}
check(describeManagerOutput("SyncProjectRules", frame({ Succeeded: true, Applied: true, Platforms: ["Codex"], RequiredStageResults: [] }), { apply: true }).state === "unknown", "missing required stage evidence must prevent success");
check(describeManagerOutput("SyncProjectRules", frame(syncResult(false)), { apply: true }).state === "unknown", "an apply request must not treat a preview result as applied");
check(describeManagerOutput("SyncProjectRules", frame(syncResult(true)), { apply: true }, 1).state === "error", "nonzero exit must override a success envelope");
check(describeManagerOutput("SyncProjectRules", frame(syncResult(true)), { apply: true }, null).state === "unknown", "termination without exit result must not imply success");
check(describeManagerOutput("Check", "unrecognized output").state === "unknown", "unrecognized checks must not default to healthy");
check(describeManagerOutput("Check", "狀態：無法判斷來源庫狀態").state === "unknown", "unknown source relation must remain unknown");
check(describeManagerOutput("SyncGlobal", "有差異").state === "preview", "other sync previews must not claim applied work");

async function checkCommandFlow(): Promise<void> {
  const Module = require("node:module") as any;
  const childProcess = require("node:child_process") as any;
  const { EventEmitter } = require("node:events");
  const originalLoad = Module._load;
  const originalSpawn = childProcess.spawn;
  const callbacks = new Map<string, () => Promise<void>>();
  const messages: string[] = [];
  const fakeVscode = {
    commands: { registerCommand: (id: string, callback: () => Promise<void>) => { callbacks.set(id, callback); return { dispose() {} }; } },
    window: {
      showInformationMessage: async (message: string) => { messages.push(message); return undefined; },
      showErrorMessage: async (message: string) => { messages.push(message); return undefined; },
      showWarningMessage: async (message: string, ...args: any[]) => { messages.push(message); return args[0]?.modal ? args[1] : undefined; }
    }
  };
  Module._load = function(request: string, ...args: any[]) {
    return request === "vscode" ? fakeVscode : originalLoad.call(this, request, ...args);
  };
  try {
    const { ScriptRunner } = require("./scriptRunner");
    const { registerAiRulesCommands } = require("./commands");
    const output = { append() {}, appendLine() {}, show() {} };
    for (const scenario of ["success", "failure", "diverged", "unknown", "unknownPreview"] as const) {
      let spawnCount = 0;
      let finalResult: any;
      messages.length = 0;
      childProcess.spawn = () => {
        spawnCount += 1;
        const child = new EventEmitter();
        child.stdout = new EventEmitter(); child.stderr = new EventEmitter();
        child.stdout.setEncoding = () => child.stdout; child.stderr.setEncoding = () => child.stderr;
        const text = spawnCount === 1
          ? scenario === "diverged" ? "狀態：來源庫分叉" : scenario === "unknownPreview" ? "unrecognized output" : frame(syncResult(false))
          : scenario === "unknown" ? "同步完成" : "同步完成\n" + frame(syncResult(true, scenario !== "failure"));
        queueMicrotask(() => {
          const split = Math.floor(text.length / 2);
          child.stdout.emit("data", Buffer.from(text.slice(0, split)));
          child.stderr.emit("data", Buffer.from("diagnostic text between stdout chunks"));
          child.stdout.emit("data", Buffer.from(text.slice(split)));
          child.emit("close", scenario === "diverged" ? 1 : 0);
        });
        return child;
      };
      const context = { subscriptions: [] };
      const runner = new ScriptRunner(context, output) as any;
      runner.resolveRepoRoot = async () => ({ repoRoot: process.cwd(), managed: false });
      runner.resolveManagerScript = () => "fixture-manager.ps1";
      runner.getTrustedConfigurationString = () => "powershell.exe";
      runner.resolveExecutionTarget = () => process.cwd();
      runner.assertReadyToRun = async () => {};
      registerAiRulesCommands(context, runner, { setState() {} }, { setResult(value: unknown) { finalResult = value; } }, {});
      await callbacks.get("aiRules.syncProjectRules")!();
      check(finalResult.state === ({ success: "success", failure: "error", diverged: "attention", unknown: "unknown", unknownPreview: "unknown" })[scenario], "real runner/command/presentation flow must preserve " + scenario);
      check(spawnCount === (["diverged", "unknownPreview"].includes(scenario) ? 1 : 2), "unsafe preview must not advance to apply confirmation");
      check(messages.some(message => message.includes(scenario === "success" ? "同步完成" : scenario === "failure" ? "同步沒有完成" : scenario === "diverged" ? "分叉" : "結果尚未確認")), "final VS Code message must match actual result");
    }
  } finally {
    Module._load = originalLoad;
    childProcess.spawn = originalSpawn;
  }
}

checkCommandFlow().then(() => console.log(`User-facing and command-flow checks: ${assertions} passed, 0 failed, 0 skipped.`)).catch(error => {
  console.error(error);
  process.exitCode = 1;
});
