"""M4D isolated Cartridge-result cases; never invokes a Memory tool."""

import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


class MemoryM4ToolCases(unittest.TestCase):
    def test_all_six_isolated_cases_have_distinct_required_interpretations(self):
        reference = (ROOT / "Shared/policies/references/memory-update-sync-evidence.md").read_text(encoding="utf-8")
        table = reference.split("<!-- MEMORY_SYNC_CASES_START -->", 1)[1].split("<!-- MEMORY_SYNC_CASES_END -->", 1)[0]
        rows = dict(re.findall(r"(?m)^\| ([a-zA-Z_]+) \| (.+) \|$", table))
        self.assertEqual(set(rows), {
            "card_write_success_index_success",
            "card_write_success_INDEX_SYNC_PARTIAL",
            "dependency_recomputation_warning",
            "full_reindex_success",
            "invalid_index_repair",
            "new_card_not_registered",
        })
        self.assertIn("derived state", rows["card_write_success_index_success"])
        self.assertIn("index failure", rows["card_write_success_INDEX_SYNC_PARTIAL"])
        self.assertIn("insufficient", rows["dependency_recomputation_warning"])
        self.assertIn("project-wide scope", rows["full_reindex_success"])
        self.assertIn("before repair", rows["invalid_index_repair"])
        self.assertIn("incomplete", rows["new_card_not_registered"])

    def test_mock_success_label_cannot_hide_partial_index(self):
        reference = (ROOT / "Shared/policies/references/memory-update-sync-evidence.md").read_text(encoding="utf-8")
        completion = (ROOT / "Shared/policies/completion-policy.md").read_text(encoding="utf-8")
        synthetic_result = {
            "status": "success",
            "cardWrite": "success",
            "indexSynchronized": False,
            "warnings": ["INDEX_SYNC_PARTIAL"],
        }
        self.assertEqual(synthetic_result["cardWrite"], "success")
        self.assertFalse(synthetic_result["indexSynchronized"])
        for marker in ("status: success", "indexSynchronized: false", "INDEX_SYNC_PARTIAL"):
            self.assertIn(marker, reference)
            self.assertIn(marker, completion)
        self.assertIn("not full sync", reference)
        self.assertIn("partial result", completion)


if __name__ == "__main__":
    unittest.main()
