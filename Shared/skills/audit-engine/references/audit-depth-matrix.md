# Audit Depth Matrix

This reference defines how deep an 08 health audit must go before it can make a claim. The caller may choose a depth explicitly, but the audit engine must still downgrade claims when evidence is missing.

## Depth Selection

| Depth | Trigger | Required Scope | Output Claim |
|---|---|---|---|
| quick | Director asks for quick check, routine preflight, or obvious red flags | Project surface detection, tool availability, major governance drift, obvious failing scripts | Quick risk scan only. Never claim deep pass. |
| standard | Default when no depth is provided | Baseline scans, main entry inventory, critical behavior sampling, evidence-backed gates | Standard health signal with explicit sampling limits. |
| deep | Director asks for complete, deep, thorough, full, or serious review | Full feature, endpoint, command, job, interface, data-flow, performance, and risk inventories for detected surfaces | Every critical inventory item is passed, failed, unverified, blocked, or not applicable. |
| forensic | Director suspects legacy defects, pre-release risk, security incident, or hidden regressions | Deep mode plus cross-file data flow, dead code, regression surface, reliability, observability, release governance, and historical drift | Coverage and blind spots must be reported as first-class findings. |

## Modifier Mapping

| Director Wording | Depth |
|---|---|
| quick, fast, simple, smoke, 快速, 簡查 | quick |
| standard, normal, default, 一般, 標準 | standard |
| deep, full, complete, thorough, 深層, 深度, 完整, 全面 | deep |
| forensic, release readiness, incident, 遺留問題, 上線前, 鑑識, 高風險 | forensic |

If multiple modifiers appear, choose the highest-risk depth unless the Director explicitly narrows scope.

## Minimum Inventories By Depth

| Inventory | quick | standard | deep | forensic |
|---|---|---|---|---|
| Project surfaces | required | required | required | required |
| Tool and platform capability | required | required | required | required |
| Features and user flows | obvious only | main entries | complete for detected surfaces | complete plus historical drift |
| API or route endpoints | obvious only | public or configured entries | complete route/controller contract map | complete plus auth, side effect, and regression map |
| Commands, scripts, jobs | obvious only | primary scripts | complete executable command/task inventory | complete plus shell/platform compatibility |
| Interfaces and operation paths | obvious only | critical paths | complete critical and common paths | complete plus edge and failure paths |
| Data flows | not required unless obvious risk | critical paths | cross-module flow and persistence map | cross-module plus reliability and observability |
| Performance and latency targets | smoke timing only | primary path timing or available reports | per-surface performance evidence | performance, cold start, load, and degradation evidence |
| Risk register | obvious blockers | high and medium risks | all detected risks with severity | all risks plus unknowns and release blockers |

## Evidence Quotas

| Depth | Evidence Requirement |
|---|---|
| quick | At least one concrete evidence item for each red or blocked finding. |
| standard | Evidence for each high-risk claim, plus sampled evidence for core behavior. |
| deep | Evidence, unverified status, blocked status, or not-applicable reason for every critical inventory item. |
| forensic | Deep evidence plus explicit coverage denominator, sampling limits, unreviewed areas, and regression/release risk. |

## Stop Conditions

An audit must stop or downgrade instead of producing a pass when:

- A required project entry point cannot be identified.
- Credentials, login, network access, host application, device, or external service is required and unavailable.
- A destructive action would be needed to validate behavior.
- Tool output is unavailable or ambiguous and no equivalent evidence path exists.
- The depth requires complete inventory coverage but inventory construction is incomplete.

## Reporting Rule

The final report must show the selected depth, the reason for that depth, coverage denominators, and every downgraded claim. A sample is not a full pass unless the report says it is only a sample.
