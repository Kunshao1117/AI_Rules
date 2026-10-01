"""M4A source authorization contract; no Memory or runtime tool calls."""

import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")


def compact(relative):
    return re.sub(r"\s+", " ", read(relative))


def decision(*facts):
    source = read("Shared/policies/authorization-resolution.md")
    table = source.split("<!-- AUTHORIZATION_DECISION_TABLE_START -->", 1)[1]
    table = table.split("<!-- AUTHORIZATION_DECISION_TABLE_END -->", 1)[0]
    for fact, outcome in re.findall(r"(?m)^\| ([a-z_]+) \| ([a-z_]+) \|$", table):
        if fact in facts or fact == "otherwise":
            return outcome
    raise AssertionError("missing authorization decision")


class MemoryM4Authorization(unittest.TestCase):
    def test_current_runtime_frozen_rule_wins_independent_of_skill_load(self):
        auth = compact("Shared/policies/authorization-resolution.md")
        self.assertIn("M4 changes Shared source contracts only and activates no project/runtime", auth)
        self.assertIn("Missing or uncertain cutover evidence means frozen", auth)
        self.assertIn("regardless of caller, loaded Skill, alias, tool, or Team station", auth)
        self.assertEqual(decision("frozen_memory_action", "current_scope_allows"), "legacy_memory_contract")
        self.assertEqual(decision("user_excluded_or_revoked", "frozen_memory_action"), "not_authorized")
        self.assertEqual(decision("platform_denied", "frozen_memory_action"), "stop_affected_action")

    def test_target_existing_card_edit_and_commit_are_one_bounded_scope(self):
        auth = compact("Shared/policies/authorization-resolution.md")
        for condition in (
            "exact existing owner and affected claims are known",
            "there is no observe-only/no-write exclusion",
            "no Skill load, alias, Team station, provider availability",
            "necessary `memory_commit` after that actual authorized edit may share its `local_work` scope",
            "exact module and project root",
            "Never commit solely to clear a stale indicator",
        ):
            self.assertIn(condition.lower(), auth.lower())
        self.assertIn("tool confirmation is not user authorization", auth)

    def test_reindex_and_new_card_cannot_expand_single_card_scope(self):
        auth = compact("Shared/policies/authorization-resolution.md")
        for condition in (
            "project-wide `memory_reindex` is separate",
            "single-card edit or commit does not authorize it",
            "intent explicitly covers project-wide index maintenance",
            "An invalid-index repair needs its own scope and risk decision",
            "Card creation does not authorize full reindex",
            "Verify canonical index registration",
            "project-wide operation, resolve that scope separately",
        ):
            self.assertIn(condition.lower(), auth.lower())
        self.assertIn("protected.destructive", auth)

    def test_topology_context_and_protected_classes_remain_separate(self):
        auth = compact("Shared/policies/authorization-resolution.md")
        registry = compact("Shared/policies/references/protected-action-registry.md")
        self.assertIn("Split, merge or move needs a topology/scope decision", auth)
        self.assertIn("Memory scope never grants Context persistence", auth)
        self.assertIn("An uncertain activation state is frozen", registry)
        self.assertIn("Memory is not a fifth protected class", registry)
        self.assertIn("project-context-protocol.md", auth)
        for name in ("protected.external", "protected.destructive", "protected.credential_privilege", "protected.system"):
            self.assertIn(name, registry)

    def test_legacy_phases_remain_without_ordinary_second_gate(self):
        phase = compact("Shared/policies/references/authorization-phase-registry.md")
        transition = compact("Shared/policies/references/legacy-memory-team-transition.md")
        for name in ("memory-docs", "protected-memory-write", "protected-memory-commit"):
            self.assertIn(name, phase)
            self.assertIn(name, transition)
        self.assertIn("one bounded `local_work` task", phase)
        self.assertIn("`LEGACY_COMPAT_ONLY`", transition)
        self.assertIn("unknown or user-modified old runtime Skill blocks ordinary cutover", transition)

    def test_exclusions_owner_and_old_runtime_prevent_target_write_shortcuts(self):
        auth = compact("Shared/policies/authorization-resolution.md")
        for term in (
            "observe-only/no-write exclusion",
            "An ambiguous owner, unrelated card, or material topology choice needs a scope decision",
            "removal of old Skill loader/required_skills routes",
            "Missing or uncertain cutover evidence means frozen",
        ):
            self.assertIn(term.lower(), auth.lower())


if __name__ == "__main__":
    unittest.main()
