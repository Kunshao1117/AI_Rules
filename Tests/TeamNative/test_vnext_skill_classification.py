"""Read-only Phase 4B-1 migration-reference contracts, not loader execution.

Classification semantics require independent architecture review. These checks
protect the actual denominator, explicit user decisions and safe batch fields.
No installation, runtime sync, external tool or test fixture mutation occurs.
"""
from collections import Counter
from pathlib import Path
import re
import unittest
from vnext_source_paths import artifacts, historical_path

ROOT = Path(__file__).resolve().parents[2]
MAP = ROOT / "Shared/policies/references/skill-architecture-disposition.md"
DISPOSITIONS = {
    "KEEP_AS_SKILL", "KEEP_BUT_REWRITE", "MOVE_TO_AGENT", "MOVE_TO_POLICY",
    "MOVE_TO_WORKFLOW", "MOVE_TO_REFERENCE", "MERGE_INTO_EXISTING",
    "OPTIONAL_PACK", "PROJECT_DERIVED", "RETIRE", "DEFER_MEMORY_SUBSYSTEM",
    "UNDECIDED",
}
TYPES = {"Policy", "Workflow", "Agent", "Skill", "Reference", "Memory"}
MEMORY = {
    "memory-ops", "memory-arch", "team-specialist-memory-closure",
    "team-specialist-memory-docs", "team-memory-closure-delivery-artifact",
    "team-memory-docs-delivery-artifact",
}
FIELDS = {
    "skill", "current_path", "current_purpose", "true_type", "disposition",
    "target_owner", "target_concept_path", "content_to_preserve",
    "content_to_remove", "overlaps", "platform_coupling", "memory_coupling",
    "provider_specific", "implicit_invocation", "migration_risk",
    "migration_batch", "confidence",
}


def read(path):
    return (ROOT / path).read_text(encoding="utf-8-sig")


def parse_map(text):
    blocks = re.findall(r"<!-- SKILL_DISPOSITION_MAP_START -->(.*?)<!-- SKILL_DISPOSITION_MAP_END -->", text, re.S)
    if len(blocks) != 1:
        raise ValueError("Expected one migration table")
    lines = [line for line in blocks[0].splitlines() if line.startswith("|")]
    cells = [[c.strip() for c in line.strip("|").split("|")] for line in lines]
    columns = cells[0]
    if len(columns) != len(set(columns)) or not FIELDS <= set(columns):
        raise ValueError("Missing or duplicate required columns")
    result = []
    for values in cells[2:]:
        if len(values) != len(columns) or any(not v for v in values):
            raise ValueError("Incomplete classification")
        result.append(dict(zip(columns, values)))
    if any(n != 1 for n in Counter(row["skill"] for row in result).values()):
        raise ValueError("Duplicate classification")
    if any(row["disposition"] not in DISPOSITIONS or row["true_type"] not in TYPES for row in result):
        raise ValueError("Unknown type or disposition")
    return result


class ClassificationFreeze(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.text = MAP.read_text(encoding="utf-8")
        cls.rows = parse_map(cls.text)
        cls.by_name = {r["skill"]: r for r in cls.rows}
        cls.actual = {p.parent.name for p in (ROOT / "Shared/skills").glob("*/SKILL.md")}

    def test_actual_denominator_matches_exactly_without_count_target(self):
        migrated = {a['skill'] for a in artifacts()}
        self.assertFalse(migrated & self.actual)
        self.assertEqual(set(self.by_name), self.actual | migrated)
        self.assertEqual(len(self.rows), len(self.actual) + len(migrated))
        for r in self.rows:
            self.assertEqual(r["current_path"], f'Shared/skills/{r["skill"]}/SKILL.md')
            self.assertTrue(historical_path(r["current_path"]).is_file())

    def test_every_required_field_is_present(self):
        for r in self.rows:
            self.assertTrue(FIELDS <= set(r))
            self.assertTrue(all(r[f].strip() for f in FIELDS))

    def test_closed_disposition_enum_and_no_unresolved_items(self):
        self.assertTrue({r["disposition"] for r in self.rows} <= DISPOSITIONS)
        self.assertNotIn("UNDECIDED", {r["disposition"] for r in self.rows})

    def test_malformed_duplicate_disposition_is_rejected(self):
        line = next(line for line in self.text.splitlines() if line.startswith("| browser-testing |"))
        with self.assertRaises(ValueError):
            parse_map(self.text.replace(line, line + "\n" + line))
        with self.assertRaises(ValueError):
            parse_map(self.text.replace("| KEEP_BUT_REWRITE |", "| KEEP_AND_REDESIGN |", 1))

    def test_missing_required_field_is_rejected(self):
        with self.assertRaises(ValueError):
            parse_map(self.text.replace("| target_owner |", "| invented_owner |", 1))

    def test_index_omissions_are_in_census_not_repaired(self):
        index = read("Shared/skills/_index.md")
        indexed = re.findall(r"^- Skill: (.+)$", index, re.M)
        self.assertEqual(len(indexed), len(set(indexed)))
        self.assertTrue(set(indexed) <= self.actual)
        # B1 records the historical omissions; M3 has now retired both paths.
        self.assertEqual(self.actual - set(indexed), set())
        self.assertNotIn("verification-strategy", indexed)
        self.assertIn("Policy navigation (not a Skill registry entry)", index)

    def test_empty_directories_are_not_skill_rows(self):
        empty = {p.name for p in (ROOT / "Shared/skills").iterdir() if p.is_dir() and not any(p.iterdir())}
        # A migrated entry may leave an empty directory; directory cleanup is
        # not a condition of active identity removal or census completeness.
        migrated = {a['skill'] for a in artifacts()}
        self.assertFalse((empty - migrated) & set(self.by_name))

    def test_memory_subsystem_is_frozen(self):
        actual_memory = {r["skill"] for r in self.rows if r["true_type"] == "Memory"}
        self.assertEqual(actual_memory, MEMORY)
        for name in MEMORY:
            r = self.by_name[name]
            self.assertEqual(r["disposition"], "DEFER_MEMORY_SUBSYSTEM")
            self.assertEqual(r["memory_coupling"], "frozen")
            self.assertEqual(r["target_concept_path"], r["current_path"])
            self.assertEqual(r["migration_batch"], "DEFER_MEMORY")

    def test_context_is_policy_but_sensitive_migration_deferred(self):
        r = self.by_name["project-context-protocol"]
        self.assertEqual((r["true_type"], r["disposition"], r["memory_coupling"]), ("Policy", "MOVE_TO_POLICY", "high"))
        self.assertEqual(r["migration_batch"], "defer-sensitive-migration")

    def test_gitnexus_cli_remains_method_skill_in_pack(self):
        r = self.by_name["gitnexus-cli"]
        self.assertEqual((r["true_type"], r["disposition"], r["optional_pack"]), ("Skill", "KEEP_BUT_REWRITE", "gitnexus"))
        for name in ["gitnexus-exploring", "gitnexus-debugging", "gitnexus-impact-analysis", "gitnexus-refactoring"]:
            self.assertEqual(self.by_name[name]["true_type"], "Skill")
            self.assertEqual(self.by_name[name]["disposition"], "OPTIONAL_PACK")
        self.assertEqual(self.by_name["gitnexus-guide"]["disposition"], "MOVE_TO_REFERENCE")

    def test_retire_preserves_methods_and_physical_sources(self):
        for name in ["structured-reasoning", "code-diagnosis"]:
            r = self.by_name[name]
            self.assertEqual(r["disposition"], "RETIRE")
            self.assertEqual(r["migration_batch"], "C")
            self.assertIn("07-debug", r["target_concept_path"])
            # The frozen classification survives later authorized retirement;
            # preserve its original source through the explicit artifact alias.
            self.assertTrue(historical_path(r["current_path"]).is_file())
        self.assertIn("hypothesis", self.by_name["structured-reasoning"]["content_to_preserve"])
        self.assertIn("data-flow", self.by_name["code-diagnosis"]["content_to_preserve"])

    def test_project_native_audit_is_not_universal_js_verifier(self):
        r = self.by_name["code-audit"]
        self.assertEqual(r["disposition"], "PROJECT_DERIVED")
        self.assertIn("project-native", r["target_owner"])
        self.assertIn("universal ESLint", r["content_to_remove"])

    def test_specialists_map_only_to_existing_six_roles(self):
        moved = [r for r in self.rows if r["disposition"] == "MOVE_TO_AGENT"]
        paths = {r["target_concept_path"] for r in moved}
        expected = {f"Shared/agents/{role}.md" for role in ["reviewer", "verifier", "researcher", "security-reviewer", "architect", "implementer"]}
        self.assertEqual(paths, expected)
        self.assertEqual(len(moved), len(expected))
        self.assertTrue(all((ROOT / path).is_file() for path in paths))

    def test_team_content_is_not_one_blanket_disposition(self):
        self.assertGreaterEqual(len({r["disposition"] for r in self.rows if r["skill"].startswith("team-")}), 6)
        for r in self.rows:
            if r["skill"].startswith("team-"):
                self.assertIn(r["memory_coupling"], {"high", "frozen"})

    def test_true_types_agree_with_moves(self):
        for r in self.rows:
            if r["disposition"].startswith("MOVE_TO_"):
                self.assertEqual(r["true_type"].upper(), r["disposition"].removeprefix("MOVE_TO_"))
            if r["disposition"] in {"KEEP_AS_SKILL", "KEEP_BUT_REWRITE", "OPTIONAL_PACK", "PROJECT_DERIVED"}:
                self.assertEqual(r["true_type"], "Skill")

    def test_core_methods_are_not_retired_for_count(self):
        for name in ["browser-testing", "security-sre", "tech-stack-protocol", "skill-factory", "test-patterns", "impact-test-strategy", "test-automation-strategy", "a11y-testing", "performance-audit"]:
            self.assertEqual(self.by_name[name]["disposition"], "KEEP_BUT_REWRITE")

    def test_supabase_keeps_three_distinct_uses(self):
        names = ["supabase", "supabase-ops", "supabase-postgres-best-practices"]
        self.assertEqual(len({self.by_name[n]["current_purpose"] for n in names}), 3)
        for name in names:
            self.assertEqual(self.by_name[name]["disposition"], "OPTIONAL_PACK")
        self.assertIn("environment/context routing issue", self.text)
        self.assertEqual(self.by_name[names[-1]]["provider_specific"], "no")

    def test_invocation_and_risk_fields_are_closed(self):
        for r in self.rows:
            self.assertIn(r["implicit_invocation"], {"allowed", "restricted", "manual_only"})
            self.assertIn(r["memory_coupling"], {"none", "low", "medium", "high", "frozen"})
            self.assertIn(r["migration_risk"], {"low", "medium", "high"})
            self.assertIn(r["confidence"], {"low", "medium", "high"})
        for name in ["skill-factory", "plugin-release-governance", "gitnexus-cli", "supabase-ops"]:
            self.assertEqual(self.by_name[name]["implicit_invocation"], "manual_only")

    def test_provider_recipes_record_presence_fallback_and_no_install(self):
        for r in self.rows:
            self.assertIn(r["provider_specific"], {"yes", "no"})
            self.assertEqual(r["no_implicit_install"], "yes")
            if r["provider_specific"] == "yes":
                self.assertNotEqual(r["provider_presence_required"], "not_required")
                self.assertIn("report", r["missing_provider_behavior"])

    def test_safe_batches_do_not_authorize_physical_migration(self):
        normalized = " ".join(self.text.split())
        self.assertIn("Source absence does not remove old copies", normalized)
        self.assertIn("High coupling never permits changing or retiring", normalized)
        self.assertIn("Current Full/Diff Skill copy can overwrite", normalized)
        self.assertIn("modified and user-owned copies must remain", normalized)
        self.assertIn("Current index edits alone neither alter physical copy inclusion", normalized)

    def test_registry_and_map_are_not_new_runtime_owners(self):
        governance = read("Shared/skill-governance.md")
        self.assertIn("not a runtime registry", governance)
        for owner in ["verification-strategy.md", "review-governance.md", "completion-policy.md", "agent-governance.md", "model-profile-routing.md"]:
            self.assertIn(owner, governance)
        self.assertIn("No generic AI CLI delegation", governance)
        self.assertNotIn("VERIFICATION_SCOPE_TABLE_START", self.text)

    def test_structured_reasoning_no_longer_forces_general_tool_use(self):
        text = historical_path("Shared/skills/structured-reasoning/SKILL.md").read_text(encoding="utf-8-sig")
        self.assertIn("superseded for general vNext invocation", text)
        self.assertIn("block direct reasoning", text)
        self.assertEqual(self.by_name["structured-reasoning"]["current_lifecycle"], "newly_inactive")


if __name__ == "__main__":
    unittest.main()
