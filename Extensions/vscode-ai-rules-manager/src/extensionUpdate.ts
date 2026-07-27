import * as https from "https";
import * as vscode from "vscode";
import { AiRulesPanelProvider } from "./panel";
import { AiRulesStatus } from "./status";
import {
  extensionIsCurrent,
  extensionUpdateAvailable,
  extensionUpdateError,
  resultMessage,
  technicalResultLabel,
  UserFacingResult
} from "./userFacing";

const LATEST_RELEASE_URL = "https://api.github.com/repos/Kunshao1117/AI_Rules/releases/latest";
const RELEASE_RESPONSE_LIMIT = 1024 * 1024;
const VIEW_TECHNICAL_DETAILS = "查看技術資料";

interface ExtensionUpdateOptions {
  manual: boolean;
}

interface GithubRelease {
  tagName: string;
  htmlUrl: string;
  draft: boolean;
  prerelease: boolean;
}

interface Semver {
  major: number;
  minor: number;
  patch: number;
}

export class ExtensionUpdateChecker {
  constructor(
    private readonly context: vscode.ExtensionContext,
    private readonly output: vscode.OutputChannel,
    private readonly status: AiRulesStatus,
    private readonly panel: AiRulesPanelProvider
  ) {}

  async checkForUpdates(options: ExtensionUpdateOptions): Promise<void> {
    const currentVersion = this.getCurrentVersion();
    this.output.appendLine("");
    this.output.appendLine("操作：檢查插件更新");
    this.output.appendLine(`時間：${new Date().toLocaleString("zh-TW")}`);

    try {
      this.output.appendLine(`[Extension Update] Checking ${LATEST_RELEASE_URL}`);
      const release = await fetchLatestRelease();
      const latestVersion = parseReleaseVersion(release.tagName);

      if (!latestVersion || release.draft || release.prerelease) {
        this.output.appendLine(`[Extension Update] Ignored non-stable release tag: ${release.tagName}`);
        this.output.appendLine("結果：需要處理");
        if (options.manual) await this.present(extensionUpdateError());
        return;
      }

      const current = parseVersion(currentVersion);
      if (!current) throw new Error(`Invalid extension version: ${currentVersion}`);

      if (compareVersions(latestVersion, current) > 0) {
        this.output.appendLine(`[Extension Update] New version available: ${release.tagName}; current version: ${currentVersion}`);
        this.output.appendLine("結果：需要處理");
        const result = extensionUpdateAvailable();
        this.status.setState(result.status);
        this.panel.setResult(result);
        if (options.manual) {
          const answer = await vscode.window.showInformationMessage(
            `${result.title}\n${resultMessage(result)}`,
            "前往下載頁",
            VIEW_TECHNICAL_DETAILS,
            "稍後"
          );
          if (answer === "前往下載頁") await vscode.env.openExternal(vscode.Uri.parse(release.htmlUrl));
          if (answer === VIEW_TECHNICAL_DETAILS) this.output.show(true);
        } else {
          const answer = await vscode.window.showInformationMessage(
            `${result.title}\n${resultMessage(result)}`,
            "前往下載頁",
            "稍後"
          );
          if (answer === "前往下載頁") await vscode.env.openExternal(vscode.Uri.parse(release.htmlUrl));
        }
        return;
      }

      this.output.appendLine(`[Extension Update] Current version ${currentVersion} is up to date.`);
      this.output.appendLine("結果：成功");
      if (options.manual) await this.present(extensionIsCurrent());
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      this.output.appendLine(`[Extension Update] ${message}`);
      this.output.appendLine("結果：失敗");
      if (options.manual) await this.present(extensionUpdateError());
    }
  }

  private async present(result: UserFacingResult): Promise<void> {
    this.status.setState(result.status);
    this.panel.setResult(result);
    const answer = result.state === "error"
      ? await vscode.window.showWarningMessage(`${result.title}\n${resultMessage(result)}`, VIEW_TECHNICAL_DETAILS)
      : await vscode.window.showInformationMessage(`${result.title}\n${resultMessage(result)}`, VIEW_TECHNICAL_DETAILS);
    if (answer === VIEW_TECHNICAL_DETAILS) this.output.show(true);
    this.output.appendLine(`顯示結果：${technicalResultLabel(result)}`);
  }

  private getCurrentVersion(): string {
    const packageJson = this.context.extension.packageJSON as { version?: unknown };
    return typeof packageJson.version === "string" ? packageJson.version : "0.0.0";
  }
}

function fetchLatestRelease(): Promise<GithubRelease> {
  return new Promise((resolve, reject) => {
    const request = https.get(
      LATEST_RELEASE_URL,
      {
        headers: {
          "Accept": "application/vnd.github+json",
          "User-Agent": "AI-Rules-Manager"
        }
      },
      (response) => {
        const statusCode = response.statusCode ?? 0;
        if (statusCode < 200 || statusCode >= 300) {
          response.resume();
          reject(new Error(`GitHub release check failed with HTTP ${statusCode}.`));
          return;
        }

        let body = "";
        response.setEncoding("utf8");
        response.on("data", (chunk: string) => {
          body += chunk;
          if (body.length > RELEASE_RESPONSE_LIMIT) request.destroy(new Error("GitHub release response is too large."));
        });
        response.on("end", () => {
          try {
            resolve(parseGithubRelease(JSON.parse(body) as unknown));
          } catch (error) {
            reject(error);
          }
        });
      }
    );

    request.setTimeout(10000, () => request.destroy(new Error("GitHub release check timed out.")));
    request.on("error", reject);
  });
}

function parseGithubRelease(payload: unknown): GithubRelease {
  if (!payload || typeof payload !== "object") throw new Error("GitHub release response is not an object.");
  const data = payload as Record<string, unknown>;
  if (typeof data.tag_name !== "string" || typeof data.html_url !== "string") {
    throw new Error("GitHub release response is missing tag_name or html_url.");
  }
  return { tagName: data.tag_name, htmlUrl: data.html_url, draft: data.draft === true, prerelease: data.prerelease === true };
}

function parseReleaseVersion(tagName: string): Semver | undefined {
  const match = /^v(\d+)\.(\d+)\.(\d+)$/.exec(tagName);
  return match ? { major: Number.parseInt(match[1], 10), minor: Number.parseInt(match[2], 10), patch: Number.parseInt(match[3], 10) } : undefined;
}

function parseVersion(version: string): Semver | undefined {
  const match = /^(\d+)\.(\d+)\.(\d+)$/.exec(version);
  return match ? { major: Number.parseInt(match[1], 10), minor: Number.parseInt(match[2], 10), patch: Number.parseInt(match[3], 10) } : undefined;
}

function compareVersions(left: Semver, right: Semver): number {
  if (left.major !== right.major) return left.major - right.major;
  if (left.minor !== right.minor) return left.minor - right.minor;
  return left.patch - right.patch;
}
