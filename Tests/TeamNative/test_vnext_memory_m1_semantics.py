"""M1 source contracts only; never call Memory tools or change runtime state."""

import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
POLICY = "Shared/policies/memory-governance.md"
EVIDENCE = "Shared/policies/references/workflow-memory-evidence.md"
AUTH = "Shared/policies/authorization-resolution.md"
REGISTRY = "Shared/policies/references/protected-action-registry.md"
PHASES = "Shared/policies/references/authorization-phase-registry.md"
COMPLETION = "Shared/policies/completion-policy.md"

DISPOSITIONS = {
    "memory-not-required",
    "memory-attributed-no-write",
    "memory-required",
    "memory-card-missing",
    "memory-blocked-by-scope",
    "memory-conflict-or-compaction-blocked",
    "memory-unverified",
}


def source(path):
    return (ROOT / path).read_text(encoding="utf-8")


def prose(path):
    return re.sub(r"\s+", " ", source(path))


def disposition_body(name):
    match = re.search(
        rf"(?ms)^### `{re.escape(name)}`\s*$(.*?)(?=^### `memory-|^## |\Z)",
        source(EVIDENCE),
    )
    if match is None:
        raise AssertionError(f"Missing disposition: {name}")
    return match.group(1)


def authorization_result(*facts):
    block = source(AUTH).split("<!-- AUTHORIZATION_DECISION_TABLE_START -->", 1)[1]
    block = block.split("<!-- AUTHORIZATION_DECISION_TABLE_END -->", 1)[0]
    for line in block.splitlines():
        match = re.fullmatch(r"\| ([a-z_]+) \| ([a-z_]+) \|", line.strip())
        if match and (match.group(1) in facts or match.group(1) == "otherwise"):
            return match.group(2)
    raise AssertionError("No authorization result")


class MemoryM1Semantics(unittest.TestCase):
    def test_policy_owns_semantics_without_owning_tools_or_other_enums(self):
        policy = source(POLICY)
        for phrase in (
            "sole canonical Policy owner", "Memory Impact Review", "stale",
            "operator recall", "Main Agent", "project-context-protocol.md",
        ):
            self.assertIn(phrase, policy)
        self.assertNotRegex(policy, r"(?m)^### `memory-")
        self.assertNotRegex(policy, r"(?m)^\| (complete|partial|blocked|unverified) \|")
        self.assertNotRegex(policy, r"\b(memory_list|memory_read|memory_status|memory_reindex)\(")

    def test_seven_dispositions_have_one_definition_owner(self):
        names = "|".join(re.escape(name) for name in sorted(DISPOSITIONS))
        pattern = rf"(?m)^### `({names})`\s*$"
        headings = re.findall(pattern, source(EVIDENCE))
        self.assertEqual(set(headings), DISPOSITIONS)
        self.assertEqual(len(headings), len(DISPOSITIONS))
        for path in ROOT.joinpath("Shared/policies").rglob("*.md"):
            if path != ROOT / EVIDENCE:
                self.assertNotRegex(path.read_text(encoding="utf-8"), pattern)

    def test_no_write_requires_comparison_not_just_an_owner(self):
        body = disposition_body("memory-attributed-no-write")
        for evidence in (
            "current source evidence", "relevant Memory evidence",
            "owner and valid scope", "affected durable claims",
            "comparison result", "no Memory content change required",
        ):
            self.assertIn(evidence, body)
        self.assertIn("completed Memory Impact Review", body)
        self.assertIn("not prove that stale or index state is cleared", body)
        self.assertIn("return `memory-required` with `tracking-only` reason instead", prose(EVIDENCE))
        self.assertNotIn("Existing memory attribution already covers the change", body)

    def test_missing_card_does_not_prove_memory_not_required(self):
        self.assertIn("missing card is not evidence", disposition_body("memory-not-required"))
        self.assertIn("owner card", disposition_body("memory-card-missing"))

    def test_stale_is_review_needed_not_wrong_or_unusable(self):
        policy = prose(POLICY)
        for phrase in (
            "stale = review needed", "does not prove the card is wrong",
            "does not mandate content mutation", "historical clue",
            "not current truth without revalidation",
        ):
            self.assertIn(phrase, policy)

    def test_tracking_only_is_a_reason_not_an_eighth_disposition(self):
        body = disposition_body("memory-required")
        self.assertIn("tracking-only", body)
        self.assertIn("content", body)
        self.assertIn("reason", body)
        self.assertEqual(len(DISPOSITIONS), 7)

    def test_main_direct_work_is_not_independent_judgment(self):
        policy = prose(POLICY)
        self.assertIn("default owner of ordinary Memory Impact Review", policy)
        self.assertIn("direct verification", policy)
        self.assertIn("not independent review or independent verification", policy)
        self.assertIn("review-governance.md", policy)
        self.assertIn("verification-strategy.md", policy)
        self.assertIn("does not create a Memory Agent", policy)

    def test_ordinary_target_and_legacy_path_are_disjoint(self):
        policy = source(POLICY)
        auth = source(AUTH)
        self.assertIn("target semantics", policy)
        self.assertIn("any physical `.agents/memory/**` mutation", prose(POLICY))
        self.assertIn("M4 changes Shared source contracts only and activates no project/runtime", prose(AUTH))
        self.assertIn("completion_bundle", auth)
        self.assertIn("every attempted `.agents/memory/**` card write", prose(AUTH))
        self.assertIn("regardless of caller, loaded Skill, alias, tool, or Team station", prose(AUTH))
        self.assertIn("omitting an old Skill or bundle cannot select `local_work`", prose(AUTH))
        self.assertIn("commit/reindex/index sync still use the legacy rows", prose(REGISTRY))
        self.assertEqual(authorization_result("current_scope_allows"), "authorized")
        self.assertEqual(
            authorization_result("frozen_memory_action", "current_scope_allows"),
            "legacy_memory_contract",
        )
        self.assertEqual(
            authorization_result("user_excluded_or_revoked", "current_scope_allows"),
            "not_authorized",
        )
        self.assertIn("protected-memory-write", source(REGISTRY))
        self.assertIn("protected-memory-commit", source(PHASES))
        self.assertIn("existing_owner_scope_ref", source("Shared/policies/references/memory-closure-bundle-contract.md"))
        self.assertIn("unchanged same-named legacy judgment/receipt conditions", prose(EVIDENCE))
        self.assertIn("legacy no-write receipt is not V2 no-write evidence", prose(EVIDENCE))
        self.assertIn("does not by itself establish V2", prose(COMPLETION))

    def test_tool_confirmation_does_not_grant_authorization(self):
        auth = source(AUTH)
        self.assertIn("confirm:true", auth)
        self.assertIn("tool confirmation is not user authorization", auth)

    def test_completion_consumes_obligation_without_another_state_set(self):
        completion = source(COMPLETION)
        block = completion.split("<!-- COMPLETION_STATES_START -->", 1)[1]
        block = block.split("<!-- COMPLETION_STATES_END -->", 1)[0]
        states = re.findall(r"(?m)^\| (complete|complete_with_followups|partial|blocked|unverified) \|", block)
        self.assertEqual(set(states), {"complete", "complete_with_followups", "partial", "blocked", "unverified"})
        self.assertEqual(len(states), 5)
        self.assertIn("Memory obligation", completion)
        self.assertIn("not automatically a global blocked state", completion)
        self.assertIn("optional", completion)

    def test_project_context_keeps_its_persistence_owner(self):
        policy = prose(POLICY)
        context = prose("Shared/policies/project-context-protocol.md")
        self.assertIn("technical rationale", policy)
        self.assertIn("GO CONTEXT", context)
        self.assertIn("approved project direction", context)
        self.assertIn("does not define Context persistence or card schema", policy)


if __name__ == "__main__":
    unittest.main()
