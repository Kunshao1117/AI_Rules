---
name: gitnexus-cli
description: >
  已選用且可用的 GitNexus CLI 操作方法。
  Use when: 此次明確需要 GitNexus 狀態、索引維護或 Wiki 操作，而且相應能力與作用範圍已確認。
  DO NOT use when: 一般程式搜尋、普通除錯或重構，或只因找不到工具或索引過期。
metadata:
  author: gitnexus
  version: "7.0"
  origin: framework
  kind: operational
  memory_awareness: none
---

# gitnexus-cli

GitNexus Optional Pack. Invocation classification: restricted; provider-specific: yes.
This classification is not platform invocation enforcement. Load this method
only for the selected task, never the entire pack or a keyword-only match.

## Shared prerequisite reference

Read `Shared/policies/references/gitnexus-guide.md` for common readiness, side effects, fallback and policy boundaries.
`Shared/policies/capability-resolution.md` remains the readiness/selection owner.
The guide is a document, not another Skill. No relations or automatic sibling
loading is introduced. Missing GitNexus leaves ordinary work on native methods.

## Specific method

Disposition: KEEP_BUT_REWRITE. This remains a Tool Skill.
1. Identify the requested command, exact repository/output targets and purpose.
   Consult the Guide command effects before launch, including startup behavior.
2. Match existing executable/package provenance and syntax to the installed
   version. Passive discovery is sufficient when a probe cannot be safe.
3. For status/list, distinguish registry presence from target applicability,
   index coverage, content freshness and functional readiness. A status hint to
   analyze is tool output, never permission to do so.
4. For analyze, enumerate index, registry, context/skill injection and optional
   model/network effects first. Missing/stale index does not auto-analyze.
   A limited flag is not proof that every out-of-scope write is disabled.
5. For clean, preview the exact intended index/registry removal using already
   available metadata. Do not use --all, --force or corruption as authorization.
6. For wiki, distinguish local output from LLM data egress and optional public
   publication. Do not inspect secrets or configure another AI worker.
7. After an authorized operation, inspect its actual result and relevant changed
   targets. Report partial/stale evidence honestly; no automatic retry, reindex,
   restart, follow-on Skill loading or completion claim follows success.

Example: a requested status check may stop at present_unverified if startup
effects cannot be bounded. Continue the original code task with native search.
