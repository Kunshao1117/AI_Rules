---
name: skill-factory
description: >
  技能建立必要性判斷與候選維護方法。Use when: 使用者明確要求評估、建立或實質維護一個具體 Skill，或已授權的技能鍛造流程交付此任務。
  DO NOT use when: 只是稱讚方法可重用、Debug 發現新技巧、提出兩個假想用途、一般程式實作，或未要求技能工作的閒聊。
metadata:
  author: antigravity
  version: "6.0"
  origin: framework
  kind: operational
  style: guided
  memory_awareness: none
  tool_scope: ["filesystem:read", "filesystem:write"]
---

# Skill Factory — Necessity and Candidate Maintenance

## When to use / when not to use

Invocation classification: manual_only. Require an explicit Skill evaluation,
creation or substantive maintenance request, or assignment from an already
authorized forge workflow. Loading this Skill, discovering a useful technique
or imagining future scenarios does not initiate creation, registration or deployment.
This classification is a method contract, not invented platform enforcement metadata.

## First decide whether no new Skill is the right outcome

Apply `Shared/skill-governance.md` as the canonical architecture taxonomy owner:
Policy, Workflow, Agent, Skill, Reference. Memory is a separate frozen subsystem.
The ordered table operationalizes that owner's admission method; it does not
create a competing taxonomy or grant registry authority. Facts require actual
evidence, not invented cases. First matching row supplies the method recommendation.

| Admission fact (first matching row) | Recommendation |
|---|---|
| ordinary_model_knowledge | no_skill |
| policy_responsibility | existing_policy |
| workflow_sequence | existing_workflow |
| agent_identity | existing_agent |
| reference_only | reference |
| existing_skill_extension | extend_reference |
| provider_syntax_only | pack_reference |
| one_off_task | no_skill |
| lacks_specialized_reusable_method | no_skill |
| lacks_real_demand_or_value | no_skill |
| specialized_reusable_method & real_demand_or_value & owner_search_complete | candidate |
| otherwise | no_skill |

Ask those questions in order before writing. For rows 9 and 10, identify the
specialized method beyond ordinary model knowledge, actual repeated demand or
clear product use, trigger cost, missing existing owner and maintenance value.
Two hypothetical future uses alone do not satisfy admission. A repeated method
still belongs in an existing owner if that owner fits. Release automation is
normally Workflow with an explicitly initiated route, not an ordinary Skill.
Unknown or missing admission evidence cannot be treated as a passed check;
the candidate row requires positive evidence for all three facts.
For maintenance, prefer removing duplicate rules or extending the existing
reference over adding another active entry.

## Candidate procedure

1. Record the classification and existing-owner search result. A no-Skill outcome
   is valid. Do not create files merely to demonstrate that the factory ran.
2. If a candidate is justified, define one responsibility, narrow positive and
   negative triggers, exclusions, preserved method and evidence of future value.
   Read references/skill-template.md for format and eventual layer placement.
3. Set an invocation recommendation: allowed for unambiguous low-cost methods;
   restricted for a narrow domain need; manual_only for Skill creation, release,
   destructive or provider-heavy operations. This does not grant action authority.
   Use a platform disable mechanism only if actually supported and verified;
   otherwise rely on explicit invocation procedure and candidate isolation.
4. State provider-specific yes/no. If yes, name the method's genuine provider
   need, required presence, missing-provider alternative/limitation and no implicit
   install. Tool names or syntax tables alone belong in an existing pack Reference.
5. Create only an authorized candidate: use an existing documented draft area
   outside loader roots, or a reviewable text proposal outside discovery. Never
   put an unapproved candidate SKILL.md under Shared/skills, deployed skills,
   project discovery links or another scanner root. No new draft runtime is needed.
6. Read references/skill-style-guide.md for concise method/reference separation.
   Read references/skill-quality-checklist.md to check owners, duplication,
   positive/negative trigger examples, format and provider effects.
7. Present the concrete candidate for user/applicable-process approval. Existing
   explicit approval for that candidate/scope counts; do not invent another magic
   phrase. After approval, apply only the authorized activation step through the
   existing layer/registry mechanism. Drafting does not imply registration,
   symlink creation, installation, deployment or runtime sync.

## Ownership and persistence boundaries

`Shared/policies/authorization-resolution.md` owns writing/activation authority;
`Shared/policies/capability-resolution.md` owns actual providers/readiness.
`Shared/workflow-stage-procedures.md` owns workflow sequence; roles, execution,
model profiles, verification and review remain with their canonical owners.
`Shared/policies/completion-policy.md` owns completion. Do not inject copies of
governance gates, override machinery or old role/runtime fields into a candidate.
Provider-specific: no for this factory method itself; no provider is required to
decide classification and no implicit install is permitted.

Memory availability is not required for classification or candidate evaluation.
No Memory promotion, Memory write gate or Project Context persistence is redefined.
The original entry and three reference bodies are preserved under references/legacy/
for explicit compatibility investigation only; do not load that directory as a
creation checklist or execute its old registration, linking or persistence flow.
