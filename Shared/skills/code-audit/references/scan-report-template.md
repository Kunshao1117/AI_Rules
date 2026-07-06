# 掃描報告模板（Scan Report Template）

CLI 必須將 `scan_report.md` 按以下結構寫入；總監可見標題與欄位使用繁中 meaning-first，
必要 canonical key 放在括號中。

```markdown
# 工具掃描報告（Tool Scan Report）
> 產出時間（generated_at）: {ISO 8601 timestamp}
> 掃描工具（scan_tools）: ESLint MCP + Snyk CLI

## ESLint 程式碼品質（ESLint Code Quality）
- 錯誤數（errors）: {N} / 警告數（warnings）: {M}
- 最常違反規則（most_frequent_violated_rules）:
  1. {rule-name}（{count} 次）
  2. ...
- 前 10 項嚴重問題（top_severe_findings）:
  | # | 檔案（file） | 行號（line） | 規則（rule） | 訊息（message） |
  |---|------|------|------|---------|
  | 1 | ... | ... | ... | ... |

## Snyk 安全掃描（Snyk Security Scan）
- 漏洞統計（vulnerability_counts）: Critical {N} / High {N} / Medium {N} / Low {N}
- 前 5 項嚴重漏洞（top_severe_vulnerabilities）:
  | # | 套件（package） | 版本（version） | 漏洞（vulnerability） | 修復建議（remediation） |
  |---|---------|---------|---------------|-------------|
  | 1 | ... | ... | ... | ... |

## TypeScript 型別檢查（TypeScript Type Check）
- 錯誤總數（total_errors）: {N}
- 前 10 項錯誤（top_errors）:
  | # | 檔案（file） | 行號（line） | 錯誤訊息（error_message） |
  |---|------|------|---------------|
  | 1 | ... | ... | ... |

## 代辦標記（Task Markers）
- TODO: {N} / FIXME: {N} / HACK: {N} / XXX: {N} / TEMP: {N}

## 環境變數一致性（Environment Variable Consistency）
- 程式碼引用但 `.env.example` 缺少（referenced_missing_from_env_example）: {list}
- `.env.example` 定義但程式碼未引用（defined_but_unreferenced）: {list}
```
