"""M4C ordinary/legacy Memory bundle applicability checks (read-only)."""

import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def source(path):
    return (ROOT / path).read_text(encoding="utf-8")


class MemoryM4Bundle(unittest.TestCase):
    def test_ordinary_path_has_each_required_owner_without_a_bundle(self):
        owners = {
            "owner and scope": {
                "Shared/policies/memory-governance.md": ("sole canonical Policy owner of Memory Impact Review", "owner and valid", "scope"),
                "Shared/policies/authorization-resolution.md": ("semantic authorization owner", "Memory scope never grants Context persistence"),
            },
            "source freshness": {
                "Shared/policies/grounding-governance.md": ("source-freshness boundary", "current relevant source evidence"),
            },
            "verification": {
                "Shared/policies/verification-strategy.md": ("single general owner of verification scope", "independence"),
            },
            "review": {
                "Shared/policies/review-governance.md": ("single general owner of review applicability", "independent review request"),
            },
            "no-write": {
                "Shared/policies/references/memory-review-evidence.md": ("no_write_rationale", "current source/card comparison"),
            },
            "update and sync": {
                "Shared/policies/references/memory-update-sync-evidence.md": ("tool_target: exact module and project root", "indexSynchronized", "partial_failure"),
            },
            "completion": {
                "Shared/policies/completion-policy.md": ("sole owner of general vNext work completion", "Memory obligation consumption", "required derived-state"),
            },
            "topology": {
                "Shared/skills/memory-arch/SKILL.md": ("unique owner location", "request a topology decision"),
            },
        }
        for responsibility, paths in owners.items():
            for path, terms in paths.items():
                with self.subTest(responsibility=responsibility, owner=path):
                    body = " ".join(source(path).split()).lower()
                    for term in terms:
                        self.assertIn(term.lower(), body)
        workflow = source("Shared/policies/references/workflow-memory-evidence.md")
        self.assertIn("ordinary vNext evidence path does not require `completion_bundle_ref`", workflow)
        self.assertIn("completion_bundle_ref`, a", workflow)
        self.assertIn("legacy bundle remains applicable", workflow)

    def test_direct_consumers_scope_bundle_to_legacy(self):
        for path in (
            "Shared/policies/references/memory-closure-bundle-contract.md",
            "Shared/policies/references/completion-state-machine.md",
            "Shared/workflow-stage-procedures.md",
            "Shared/workflow-capability-evidence-matrix.md",
            "Shared/policies/references/workflow-execution-spec-contract.md",
        ):
            with self.subTest(path=path):
                text = source(path).lower()
                self.assertIn("legacy", text)
                self.assertIn("ordinary vnext", text)
        self.assertIn("not need a `completion_bundle_ref`", source("Shared/workflow-stage-procedures.md"))
        stages = " ".join(source("Shared/workflow-stage-procedures.md").split())
        self.assertIn("In a legacy bundle-backed route, keep implementation, validation", stages)
        self.assertIn("Ordinary vNext resolves Verification, Review, Memory Impact Review", stages)
        self.assertIn("Ordinary vNext completion uses `Shared/policies/completion-policy.md`", stages)

    def test_legacy_bundle_schema_and_receipts_survive(self):
        bundle = source("Shared/policies/references/memory-closure-bundle-contract.md")
        self.assertIn("LEGACY_COMPAT_ONLY", bundle)
        for term in ("completion_bundle_id", "memory_docs", "protected_memory_write",
                     "protected_memory_commit", "source-level-explicit"):
            self.assertIn(term, bundle)
        machine = source("Shared/policies/references/completion-state-machine.md")
        for target in ("source-level", "process-complete", "release-ready"):
            self.assertIn(target, machine)
        transition = source("Shared/policies/references/legacy-memory-team-transition.md")
        self.assertIn("LEGACY_COMPAT_ONLY", transition)

    def test_seven_dispositions_remain_exactly_the_canonical_set(self):
        dispositions = re.findall(
            r"(?m)^### `(memory-[a-z-]+)`$",
            source("Shared/policies/references/workflow-memory-evidence.md"),
        )
        self.assertEqual(dispositions, [
            "memory-not-required", "memory-attributed-no-write", "memory-required",
            "memory-card-missing", "memory-blocked-by-scope",
            "memory-conflict-or-compaction-blocked", "memory-unverified",
        ])


if __name__ == "__main__":
    unittest.main()
