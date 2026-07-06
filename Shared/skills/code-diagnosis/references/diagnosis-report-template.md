# 診斷報告模板（Diagnosis Report Template）

CLI 必須將 `diagnosis_report.md` 按以下結構寫入；總監可見標題與欄位使用繁中 meaning-first，
必要 canonical key 放在括號中。

```markdown
# 程式碼診斷報告（Code Diagnosis Report）
> 分析時間（analyzed_at）: {ISO 8601 timestamp}
> 分析範圍（analysis_scope）: {module list}
> 故障症狀（failure_symptoms）: {symptom description}

## 已讀取檔案（Files Read）
| # | 檔案路徑（file_path） | 行數（lines） | 備註（notes） |
|---|-----------|-------|-------|
| 1 | ... | ... | ... |

## 可疑區域，依可能性排序（Suspect Areas, Sorted By Likelihood）

### 可疑點 1（suspect_1）: {file name:line range}
- **可疑原因（why_suspect）**: {detailed explanation}
- **相關程式碼（related_code）**:
  ```
  {suspect code snippet with line numbers}
  ```
- **建議調查方向（suggested_investigation）**: {specific investigation guidance for the captain}

### 可疑點 2（suspect_2）: ...

## 已排除區域（Ruled-Out Areas）
| # | 檔案路徑（file_path） | 排除理由（exclusion_reason） |
|---|-----------|------------------|
| 1 | ... | ... |

## 跨模組關聯分析（Cross-Module Relationship Analysis）
- **資料流路徑（data_flow_path）**: {how data moves between modules}
- **依賴鏈（dependency_chain）**: {relevant import/require relationships}
- **共用狀態（shared_state）**: {state or resources shared by multiple modules}

## 初步結論（Preliminary Conclusion）
{CLI's preliminary root-cause judgment. Mark clearly: "此為初步分析，需隊長複查（Preliminary analysis; captain review required）."}
```
