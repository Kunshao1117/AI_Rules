"""M4B completion consumption tests; inspect source contracts only."""

import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")


def decision(*facts):
    body = read("Shared/policies/completion-policy.md")
    table = body.split("<!-- COMPLETION_DECISION_TABLE_START -->", 1)[1]
    table = table.split("<!-- COMPLETION_DECISION_TABLE_END -->", 1)[0]
    for fact, state in re.findall(r"(?m)^\| ([a-z_]+) \| ([a-z_]+) \|$", table):
        if fact in facts or fact == "otherwise":
            return state
    raise AssertionError("missing completion result")


class MemoryM4Completion(unittest.TestCase):
    def test_five_states_and_required_gap_priority_are_unchanged(self):
        body = read("Shared/policies/completion-policy.md")
        table = body.split("<!-- COMPLETION_STATES_START -->", 1)[1]
        table = table.split("<!-- COMPLETION_STATES_END -->", 1)[0]
        states = re.findall(r"(?m)^\| ([a-z_]+) \|", table)
        self.assertEqual(states, ["complete", "complete_with_followups", "partial", "blocked", "unverified"])
        self.assertEqual(decision("necessary_work_blocked", "requested_work_unfinished"), "blocked")
        self.assertEqual(decision("requested_work_unfinished"), "partial")
        self.assertEqual(decision("required_evidence_missing_or_stale"), "unverified")
        self.assertEqual(decision("all_required_satisfied_with_optional_followups"), "complete_with_followups")

    def test_no_write_is_current_comparison_without_fake_receipt(self):
        completion = read("Shared/policies/completion-policy.md")
        review = read("Shared/policies/references/memory-review-evidence.md")
        for term in ("source/card comparison", "stale tool indicator", "tracking-only"):
            self.assertIn(term.lower(), completion.lower())
        self.assertIn("needs no fabricated `memory_no_write_receipt`", " ".join(completion.split()))
        self.assertIn("unrelated file change does not erase", review)
        self.assertIn("ordinary no-write result needs no legacy bundle receipt", review.lower())

    def test_commit_success_with_partial_index_is_not_complete(self):
        completion = read("Shared/policies/completion-policy.md")
        evidence = read("Shared/policies/references/memory-update-sync-evidence.md")
        normalized = " ".join(completion.split())
        for term in ("status: success", "indexSynchronized: false", "INDEX_SYNC_PARTIAL",
                     "required derived-state", "not a fully synchronized Memory obligation"):
            self.assertIn(term, normalized)
        for term in ("tool_target", "exact module and project root", "indexSynchronized",
                     "warnings", "partial_failure", "canonical index before commit"):
            self.assertIn(term, evidence)
        self.assertIn("Do not turn a necessary commit", completion)

    def test_freshness_and_review_are_scoped_to_real_dependency(self):
        body = read("Shared/policies/completion-policy.md")
        self.assertIn("Memory claim depends on verified", body)
        self.assertIn("independent Review is awaited only", body)
        self.assertIn("unrelated file changes do not invalidate", body)
        self.assertIn("legacy `memory_no_write_receipt` does not by itself establish V2", body)
        review = " ".join(read("Shared/policies/references/memory-review-evidence.md").split())
        self.assertIn("affected claims, owner, scope and tracked relation", review)
        self.assertIn("requires a focused reassessment", review)


if __name__ == "__main__":
    unittest.main()
