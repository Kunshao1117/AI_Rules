"""M2_CANONICAL_METHOD_TEST: read source contracts without touching Memory runtime."""

import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
OPS = ROOT / "Shared/skills/memory-ops/SKILL.md"
ARCH = ROOT / "Shared/skills/memory-arch/SKILL.md"
OPS_REFS = ROOT / "Shared/skills/memory-ops/references"
ARCH_REFS = ROOT / "Shared/skills/memory-arch/references"


def read(path):
    return path.read_text(encoding="utf-8")


def prose(text):
    return re.sub(r"\s+", " ", text).lower()


def section(path, heading):
    match = re.search(rf"(?ms)^## {re.escape(heading)}\s*$(.*?)(?=^## |\Z)", read(path))
    if not match:
        raise AssertionError(f"Missing section {heading} in {path}")
    return match.group(1)


class MemoryM2Methods(unittest.TestCase):
    def test_distinct_on_demand_routes(self):
        ops = read(OPS)
        arch = read(ARCH)
        self.assertIn("DISCOVERABLE_ON_DEMAND", ops)
        self.assertIn("DISCOVERABLE_ON_DEMAND", arch)
        for term in ("operator recall", "Memory Impact Review", "stale review", "existing-card maintenance"):
            self.assertIn(term, ops)
        for term in ("new-card topology", "owner ambiguity", "split", "compaction", "archive"):
            self.assertIn(term, arch)
        self.assertIn("ordinary content edit", arch)
        self.assertIn("does not require `memory-arch`", ops)

    def test_shortest_read_route_and_recall(self):
        ops = read(OPS)
        self.assertIn("known module", ops)
        self.assertIn("unknown owner", ops)
        self.assertIn("memory_status", ops)
        self.assertIn("memory_read", ops)
        self.assertIn("memory_list", ops)
        self.assertIn("memory_graph", ops)
        self.assertIn("memory_deps", ops)
        self.assertIn("Do not scan every card", ops)
        recall = section(OPS, "Operator Recall")
        for term in ("historical conclusion", "reason", "scope", "current validity", "Project Context", "current direct evidence"):
            self.assertIn(term, recall)

    def test_impact_review_and_no_write_comparison(self):
        impact = prose(section(OPS, "Memory Impact Review Method"))
        for term in ("current source evidence", "relevant Memory evidence", "owner and valid scope", "affected durable claims", "tracking", "comparison result", "reason"):
            self.assertIn(term.lower(), impact)
        self.assertIn("workflow-memory-evidence.md", impact)
        self.assertIn("memory-attributed-no-write", impact)
        self.assertIn("existing card alone", impact)
        self.assertNotRegex(read(OPS) + read(ARCH), r"(?m)^### `memory-")

    def test_stale_and_tracking_only(self):
        impact = section(OPS, "Memory Impact Review Method")
        self.assertIn("stale = review needed", impact)
        self.assertIn("historical clue", impact)
        self.assertIn("not current truth", impact)
        self.assertIn("no-write", impact)
        self.assertIn("content update", impact)
        self.assertIn("tracking-only", impact)
        self.assertIn("memory-required", impact)
        self.assertIn("not an eighth disposition", impact)

    def test_update_sync_partial_failure_and_direct_independence(self):
        ops = prose(read(OPS))
        for term in ("Impact Review", "necessary content or tracking edit", "memory_commit", "inspect result", "content update result", "commit result", "index or derived-state result", "remaining warnings"):
            self.assertIn(term.lower(), ops)
        self.assertIn("direct verification is not independent", ops)
        self.assertIn("review-governance.md", ops)
        self.assertIn("verification-strategy.md", ops)
        self.assertIn("completion-policy.md", ops)

    def test_frozen_mutation_and_tool_acknowledgment(self):
        ops = read(OPS)
        arch = read(ARCH)
        for text in (ops, arch):
            self.assertIn("authorization-resolution.md", text)
            self.assertIn("frozen_memory_action", text)
            self.assertIn(".agents/memory/**", text)
        self.assertIn("confirm:true", ops)
        self.assertIn("tool mutation acknowledgement", ops)
        self.assertIn("not user authorization", ops)

    def test_no_active_memory_update_fallback(self):
        for path in (OPS, OPS_REFS / "memory-lifecycle-procedures.md", OPS_REFS / "memory-mcp-tool-contract.md"):
            body = read(path)
            self.assertNotRegex(body, r"(?i)memory_update\s*\([^\n]*fallback")
            if "memory_update" in body:
                self.assertIn("legacy compatibility only", prose(body))

    def test_admission_and_context_are_references_not_new_governance(self):
        ops = read(OPS)
        self.assertIn("memory-governance.md", ops)
        self.assertIn("project-context-protocol.md", ops)
        self.assertIn("formally evaluated", ops)
        self.assertIn("high rediscovery cost", ops)
        self.assertIn("archive", ops)
        self.assertIn("not a changelog", prose(ops))
        self.assertNotRegex(ops + read(ARCH), r"(?m)^\| (complete|complete_with_followups|partial|blocked|unverified) \|")
        self.assertNotRegex(ops + read(ARCH), r"(?m)^\| (local_work|protected_external|legacy_memory_contract) \|")

    def test_architecture_preserves_structural_methods(self):
        arch = read(ARCH)
        topology = read(ARCH_REFS / "topology-rules.md")
        playbooks = read(ARCH_REFS / "maintenance-playbooks.md")
        for term in ("navigation-only", "Tracked Files", "dependencies", "Relations", "Applicable Skills", "static container"):
            self.assertIn(term, arch + topology)
        for term in ("split", "Compaction", "archive", "Static Container"):
            self.assertIn(term, arch + playbooks)
        self.assertIn("same-scope", topology)
        self.assertIn("memory-card-missing", topology)
        self.assertIn("topology decision", topology)
        self.assertIn("child/module is known", topology)
        self.assertIn("directly", topology)
        self.assertNotIn("Dependency Write Gate", topology)

    def test_direct_references_do_not_restore_old_governance(self):
        blueprint = read(ARCH_REFS / "memory-quality-migration-blueprint.md")
        lifecycle = read(OPS_REFS / "memory-lifecycle-procedures.md")
        self.assertIn("Content Admission Examples", blueprint)
        self.assertNotIn("Memory write boundary", blueprint)
        self.assertNotRegex(blueprint, r"(?m)^\| (Condense|Build|Fix|Test|Audit) \| May write")
        self.assertIn("authorization-resolution.md", blueprint)
        self.assertIn("remains frozen until evidenced m5 cutover", prose(blueprint))
        self.assertIn("permits the physical card write", prose(blueprint))
        self.assertIn("exact operation is permitted under the currently active contract", prose(blueprint))
        self.assertIn("completion-policy.md", lifecycle)
        self.assertIn("memory-closure-bundle-contract.md", lifecycle)
        self.assertIn("route compaction or split to `memory-arch`", lifecycle)
        self.assertIn("tracking-only", lifecycle)
        self.assertIn("does not automatically rebuild the whole card", prose(lifecycle))
        self.assertIn("permits the physical `.agents/memory/**` write", prose(lifecycle))
        self.assertIn("after that authorized write", prose(lifecycle))

    def test_legacy_contract_retained_but_not_general_method(self):
        for path in (OPS, ARCH):
            legacy = section(path, "Legacy Compatibility")
            self.assertIn("memory-closure-bundle-contract.md", legacy)
            self.assertIn("not the ordinary method", legacy)
        ordinary = read(OPS).split("## Legacy Compatibility", 1)[0]
        self.assertNotIn("role_instance", ordinary)
        self.assertNotIn("memory_docs_handoff", ordinary)
        self.assertNotIn("completion_bundle", ordinary)


if __name__ == "__main__":
    unittest.main()
