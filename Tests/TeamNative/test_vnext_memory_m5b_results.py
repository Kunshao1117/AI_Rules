"""Evidence interpretation contracts; no real project/tool invocation."""
import json
import os
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def read(path):
    return (ROOT / path).read_text(encoding="utf-8-sig")


class M5BResultContracts(unittest.TestCase):
    def test_partial_success_and_dependency_warning_remain_distinct(self):
        reference = read("Shared/policies/references/memory-update-sync-evidence.md")
        completion = read("Shared/policies/completion-policy.md")
        for observation, required in (
            ("card_write_success_index_success", "derived state"),
            ("card_write_success_INDEX_SYNC_PARTIAL", "index failure"),
            ("dependency_recomputation_warning", "insufficient"),
        ):
            row = next(line for line in reference.splitlines() if line.startswith(f"| {observation} |"))
            self.assertIn(required, row)
        self.assertIn("partial result", completion)
        for marker in ("indexSynchronized", "warnings", "residual_risk"):
            self.assertIn(marker, reference)

    def test_full_reindex_never_inherits_a_card_scope(self):
        reference = read("Shared/policies/references/memory-update-sync-evidence.md")
        auth = read("Shared/policies/authorization-resolution.md")
        self.assertIn("do not inherit single-card authority", reference)
        self.assertIn("project-wide scope", reference)
        self.assertIn("memory_reindex", auth)
        self.assertIn("frozen_memory_action", auth)
        self.assertIn("confirm:true", auth)
        self.assertIn("tool confirmation is not user authorization", auth)

    def test_persistent_evidence_is_not_a_new_authorization_flag(self):
        reference = read("Shared/policies/references/memory-cutover-deployment-evidence.md")
        for marker in ("runtime_instance_version", "managed_path_inventory", "projection_hashes",
                       "rollback_point", "new_session_smoke", "activation_eligibility",
                       "REAL_SESSION_BEHAVIOR_REQUIRES_M5C"):
            self.assertIn(marker, reference)
        self.assertIn("not authorization", reference)
        self.assertIn("no authorization resolver reads a boolean", " ".join(reference.split()))
        auth = read("Shared/policies/authorization-resolution.md")
        self.assertNotIn("rollback.json", auth)
        self.assertNotIn("memory-cutover-deployment-evidence.md", auth)

    def test_fixture_runner_has_explicit_roots_and_no_cartridge_build_output(self):
        runner = read("Tests/TeamNative/MemoryM5BCartridge.mjs")
        self.assertIn("fixtureRoot", runner)
        self.assertIn("requires a new fixture root", runner)
        self.assertIn("outfile", runner)
        self.assertNotIn("npm install", runner)
        self.assertNotIn("memory_commit", runner)

    def test_actual_isolated_cartridge_results_are_not_claimed_as_real_sessions(self):
        report = os.environ.get("M5B_CARTRIDGE_REPORT")
        if not report:
            self.skipTest("Run the explicit isolated Cartridge probe to supply observation evidence")
        observed = json.loads(Path(report).read_text(encoding="utf-8"))
        self.assertFalse(observed["isolation"]["realProjectUsed"])
        cases = observed["cases"]
        self.assertEqual(cases["registered_commit"]["summary"]["status"], "success")
        self.assertTrue(cases["registered_commit"]["summary"]["indexSynchronized"])
        dependency = cases["dependency_warning_commit"]["summary"]
        self.assertTrue(dependency["indexSynchronized"])
        self.assertTrue(any("DEPENDENCY" in w for w in dependency["warnings"]))
        partial = cases["unregistered_new_card_commit"]["summary"]
        self.assertEqual(partial["status"], "success")
        self.assertFalse(partial["indexSynchronized"])
        self.assertTrue(any("INDEX_SYNC_PARTIAL" in w for w in partial["warnings"]))
        self.assertTrue(any("DEPENDENCY" in w for w in partial["warnings"]))
        self.assertIn("index_repaired", json.dumps(cases["invalid_index_repair"]))
        self.assertIn("REAL_SESSION_BEHAVIOR_REQUIRES_M5C", observed["limits"])

    def test_warning_self_write_observation_preserves_the_finding(self):
        report = os.environ.get("M5B_CARTRIDGE_REPORT")
        if not report:
            self.skipTest("Explicit watcher observation unavailable")
        observed = json.loads(Path(report).read_text(encoding="utf-8"))
        warning = observed["cases"]["warning_self_write"]
        self.assertTrue(warning["warningInjected"])
        self.assertGreater(len(warning["beforeSelfWrite"]["pendingChanges"]), 0)
        if not warning["semanticInvariant"]:
            self.assertEqual(warning["finding"], "PENDING_CLEARED_BY_WARNING_SELF_WRITE")
            self.assertGreater(warning["afterSelfWrite"]["staleness"], 0)
        self.assertFalse(observed["cases"]["watcher_startup"]["indexChanged"])


if __name__ == "__main__":
    unittest.main()
