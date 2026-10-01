"""Current M3 source contract; historical phase fixtures live in older tests."""

import hashlib
import json
import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
OLD = {
    "team-specialist-memory-docs",
    "team-memory-docs-delivery-artifact",
    "team-specialist-memory-closure",
    "team-memory-closure-delivery-artifact",
}
MEMORY = {"memory-ops", "memory-arch"}
HASHES = {
    "team-specialist-memory-docs": "e33ed4d69e5aa2d7d107f22fba5ebb85e7896b508cb3ef110c8ee22a42bb3f69",
    "team-memory-docs-delivery-artifact": "9fedfbd6668de89d71571d6c774a6d9e6b12538c52267c2c7de47742d7f99a12",
    "team-specialist-memory-closure": "5a5f5f6ab7d3d94fb5ff4b94c9217865ffb436669b5e1016c10cae597d3277ff",
    "team-memory-closure-delivery-artifact": "ea8121daf9d523025498427a5c1410b9aaf880fd8368a46f6b44d108dd113046",
}


def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8-sig")


class MemoryM3Retirement(unittest.TestCase):
    def test_only_two_active_memory_skills_remain(self):
        physical = {p.parent.name for p in (ROOT / "Shared/skills").glob("*/SKILL.md")}
        active = set(re.findall(r"^- Skill: (.+)$", read("Shared/skills/_index.md"), re.M))
        self.assertFalse(OLD & physical)
        self.assertFalse(OLD & active)
        self.assertEqual(MEMORY & physical, MEMORY)
        self.assertEqual(MEMORY & active, MEMORY)
        self.assertEqual(physical, active)
        self.assertFalse(list((ROOT / "Shared/policies/references/legacy-skills").rglob("SKILL.md")))

    def test_two_thin_evidence_references_cover_old_methods(self):
        review = read("Shared/policies/references/memory-review-evidence.md")
        update = read("Shared/policies/references/memory-update-sync-evidence.md")
        self.assertFalse(review.startswith("---"))
        self.assertFalse(update.startswith("---"))
        for field in ("memory_impact", "docs_impact", "index_impact", "generated_copy_impact",
                      "required_target_or_no_change", "no_write_rationale", "unresolved_conflict", "residual_risk"):
            self.assertIn(field, review)
        for owner in ("workflow-memory-evidence.md", "workflow-stage-procedures.md", "platform-copy-map.md"):
            self.assertIn(owner, review)
        for field in ("memory_owner", "source_revision_evidence", "target_card", "content_update_result",
                      "tracking_update_result", "memory_commit_result", "index_or_derived_sync_result",
                      "partial_failure", "residual_risk"):
            self.assertIn(field, update)
        for text in (review, update):
            self.assertNotIn("required_skills:", text)
            self.assertNotIn("role_instance_id:", text)
            self.assertNotIn("candidate_phase_map:", text)

    def test_aliases_resolve_and_original_bytes_remain_archived(self):
        manifest = json.loads(read("Shared/policies/references/legacy-skill-migration.json"))
        batch = [a for a in manifest["artifacts"] if a.get("batch") == "M3"]
        self.assertEqual({a["skill"] for a in batch}, OLD)
        self.assertEqual(len(batch), 4)
        for artifact in batch:
            name = artifact["skill"]
            self.assertEqual(artifact["old_relative_path"], f"{name}/SKILL.md")
            self.assertEqual(artifact["reference_relative_path"], f"policies/references/legacy-skills/{name}/REFERENCE.md")
            alias = read("Shared/" + artifact["reference_relative_path"])
            self.assertIn("batch `M3`", alias)
            self.assertIn("not an active", alias.lower())
            self.assertIn("no worker", alias.lower())
            archive = ROOT / "Shared" / artifact["archive_relative_path"]
            self.assertTrue(archive.is_file())
            self.assertEqual(hashlib.sha256(archive.read_bytes()).hexdigest(), HASHES[name])
            self.assertIn(HASHES[name], [v["sha256"] for v in artifact["known_versions"]])
            self.assertTrue(all(v["provenance"] for v in artifact["known_versions"]))
            self.assertEqual(artifact["retirement_class"], "exact_framework_owned_entry")
            self.assertEqual(set(artifact["runtime_relative_paths"]),
                             {f".agents/skills/{name}/SKILL.md", f".claude/skills/{name}/SKILL.md",
                              f".cursor/skills/{name}/SKILL.md"})

    def test_transition_retains_frozen_safety_without_new_agent(self):
        transition = read("Shared/policies/references/legacy-memory-team-transition.md")
        for term in ("frozen_memory_action", "memory-docs", "memory-closure", "protected-memory-write",
                     "protected-memory-commit", "completion_bundle_ref", "delivery_slice_revision",
                     "existing owner", "expiry", "distinct", "stales", "partial failure",
                     "blocked", "Conditional Implementer"):
            self.assertIn(term.lower(), transition.lower())
        self.assertNotRegex(transition, r"(?m)^\s*candidate_phase_map\s*:")
        self.assertNotRegex(transition, r"(?m)^name:\s*")
        self.assertIn("independent candidate binding is current and eligible", transition)
        self.assertIn("review acceptance for the current delivery-slice revision", transition)
        self.assertIn("ordinary M1 Memory Impact Review", transition)
        registry = read("Shared/agents/_registry.md")
        self.assertNotRegex(registry.lower(), r"memory[- ](?:docs|closure|maintainer) agent")
        self.assertEqual(len(list((ROOT / "Shared/agents").glob("*.md"))) - 1, 6)
        self.assertIn("frozen_memory_action", read("Shared/policies/authorization-resolution.md"))
        self.assertIn("candidate_phase_map", read("Shared/policies/references/memory-closure-bundle-contract.md"))

    def test_current_consumers_do_not_require_old_active_skill_paths(self):
        for relative in ("Shared/skill-governance.md", "Shared/workflow-stage-procedures.md",
                         "Shared/workflow-capability-evidence-matrix.md", "Shared/policies/workflow-orchestration.md"):
            body = read(relative)
            for name in OLD:
                self.assertNotIn(f"Shared/skills/{name}/SKILL.md", body, relative)
        governance = read("Shared/skill-governance.md")
        self.assertNotIn("pass implementation, validation, review, memory/docs, and completion work to the matching station skills", governance)
        self.assertIn("compatibility lookups, not active Skill loads", governance)
        self.assertIn("POST_M3_MEMORY_IMPACT_REVIEW", read("Shared/policies/references/legacy-skill-migration.md"))
        self.assertIn("M5_DOWNSTREAM_CONSUMER", read("Shared/policies/references/legacy-skill-migration.md"))


if __name__ == "__main__":
    unittest.main()
