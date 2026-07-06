---
description: 所有 Writer/Worker 工作流共用的靜默完成閘門。
---

<!-- 所有 Writer/Worker 工作流共用的完成閘門（Shared Completion Gate） -->

本共用片段只作為精簡入口引用。完成語義、交付件要求、memory/docs 處置、validation、review、同步證據、剩餘風險回報，以及阻塞/未驗證/總監承擔風險結案狀態，由 `Shared/skills/team-completion-gate/SKILL.md` 管理，並部署到 `.agents/skills/team-completion-gate/SKILL.md`。

納入此片段的 workflow entries MUST：

1. 載入 workflow frontmatter 指定的已部署團隊治理與完成技能。
2. 依 `Shared/policies/workflow-orchestration.md` 的路由到完成順序處理：route -> authorization -> operation_mode -> board -> wave -> artifact -> completion。
3. 若缺少 change delivery、memory/docs delivery、validation、review、sync、authorization 或 trace evidence，必須回報為阻塞（`blocked`）、未驗證（`unverified`）或總監承擔風險結案（`closed-with-director-risk`），不得宣稱 complete。
4. 避免 workflow entries 與 shared snippets 變成治理規則傾倒區。持久完成規則要放到 shared completion skill 或其 references，不要把 checklist 複製到這裡。
