"""Source-contract acceptance only: no runtime unlock or Memory mutation."""

import hashlib
import itertools
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
AUTH = ROOT / "Shared/policies/authorization-resolution.md"
REFERENCE = ROOT / "Shared/policies/references/repository-memory-reconciliation.md"


def requirements():
    table = AUTH.read_text(encoding="utf-8").split("<!-- REPOSITORY_MEMORY_REQUIREMENTS_START -->", 1)[1]
    table = table.split("<!-- REPOSITORY_MEMORY_REQUIREMENTS_END -->", 1)[0]
    return set(re.findall(r"(?m)^\| ([a-z_]+) \|", table))


def source_contract_result(*facts):
    """Model normalization from evidence facts; never an executable guard/API."""
    facts = set(facts)
    if "source_card" in facts and not requirements() <= facts:
        facts.add("frozen_memory_action")
    if facts & {"runtime_card", "memory_commit", "memory_reindex", "index_sync"}:
        facts.add("frozen_memory_action")
    table = AUTH.read_text(encoding="utf-8").split("<!-- AUTHORIZATION_DECISION_TABLE_START -->", 1)[1]
    table = table.split("<!-- AUTHORIZATION_DECISION_TABLE_END -->", 1)[0]
    for fact, outcome in re.findall(r"(?m)^\| ([a-z_]+) \| ([a-z_]+) \|$", table):
        if fact in facts or fact == "otherwise":
            return outcome
    raise AssertionError("Missing decision fallback")


class RepositoryMemoryReconciliation(unittest.TestCase):
    def test_frozen_legacy_body_remains_byte_identical(self):
        text = AUTH.read_bytes()
        legacy = text.split(b"<!-- LEGACY_MEMORY_AUTHORIZATION_START -->", 1)[1]
        legacy = legacy.split(b"<!-- LEGACY_MEMORY_AUTHORIZATION_END -->", 1)[0]
        # Immutable b61b27c source body: do not weaken phase/envelope/receipt rules.
        self.assertEqual(hashlib.sha256(legacy).hexdigest(), "4db90fa45fd0e33bf0e443e0c1200bd02497f1bcb7385202406fec47cf205a4e")

    def test_requirements_are_exact_and_conjunctive(self):
        self.assertEqual(requirements(), {
            "explicit_source_scope", "isolated_source_target", "current_claim_evidence",
            "independent_patch_review", "recoverable_history", "bounded_source_effects",
            "truthful_validation",
        })
        # Exhaust the 127 incomplete evidence combinations, not just a happy path.
        fields = sorted(requirements())
        for count in range(len(fields)):
            for present in itertools.combinations(fields, count):
                with self.subTest(present=present):
                    self.assertEqual(source_contract_result("source_card", "current_scope_allows", *present), "legacy_memory_contract")

    def test_complete_evidence_permits_only_bounded_source_action(self):
        self.assertEqual(source_contract_result("source_card", "current_scope_allows", *requirements()), "authorized")
        self.assertEqual(source_contract_result("source_card", *requirements()), "not_authorized")

    def test_source_evidence_cannot_activate_runtime_or_provider_mutation(self):
        for action in ("runtime_card", "memory_commit", "memory_reindex", "index_sync"):
            with self.subTest(action=action):
                self.assertEqual(source_contract_result(action, "current_scope_allows", *requirements()), "legacy_memory_contract")

    def test_platform_denial_and_user_exclusion_keep_priority(self):
        for boundary, outcome in (("platform_denied", "stop_affected_action"), ("user_excluded_or_revoked", "not_authorized")):
            self.assertEqual(source_contract_result("source_card", "current_scope_allows", boundary, *requirements()), outcome)

    def test_native_invalid_scope_and_protected_safety_cannot_be_bypassed(self):
        for boundary, outcome in (
            ("native_required_contract_invalid", "stop_affected_action"),
            ("out_of_scope", "scope_decision_required"),
            ("missing_explicit_action_target", "not_authorized"),
            ("missing_material_destructive_safety", "safety_evidence_required"),
        ):
            self.assertEqual(source_contract_result("source_card", "current_scope_allows", boundary, *requirements()), outcome)

    def test_flags_tests_skill_and_author_self_review_are_not_evidence(self):
        for signal in ("approved", "m5_complete", "skill_loaded", "ci_green", "author_review", "confirm_true"):
            self.assertEqual(source_contract_result("source_card", "current_scope_allows", signal), "legacy_memory_contract")

    def test_method_preserves_receipts_and_history_and_rejects_path_escape(self):
        method = re.sub(r"\s+", " ", REFERENCE.read_text(encoding="utf-8"))
        for marker in (
            "not an authorization owner, runtime switch or substitute receipt",
            "immutable base commit", "not a symlink/alias", "current hashes equal",
            "later edit blocks automatic restoration", "original hashes after restoration",
            "all existing archive bytes", "exact manifest and governing policy content hash",
            "path traversal", "additions, deletions and non-allowlisted writes",
        ):
            self.assertIn(marker.lower(), method.lower())
        self.assertIn("a JSON `approved` field is not review", method)

    def test_scope_and_consumer_followup_are_explicit(self):
        auth = re.sub(r"\s+", " ", AUTH.read_text(encoding="utf-8"))
        method = re.sub(r"\s+", " ", REFERENCE.read_text(encoding="utf-8"))
        for marker in ("no new owner, split/move/delete, Context", "no symlink/alias to an active runtime", "Do not retry an already denied runtime action"):
            self.assertIn(marker, auth)
        for marker in ("different project root", "index, cached metadata or dependency state", "`.cartridge/index.json`", "historical timestamp", "provider mutation result (not run on this route)", "normal path is inspection", "partial, blocked or unverified"):
            # Completion owns the last phrase; the method owns consumer facts.
            surface = method if marker != "partial, blocked or unverified" else re.sub(r"\s+", " ", (ROOT / "Shared/policies/completion-policy.md").read_text(encoding="utf-8"))
            self.assertIn(marker, surface)


if __name__ == "__main__":
    unittest.main()
