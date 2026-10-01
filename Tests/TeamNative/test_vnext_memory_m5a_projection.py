"""M5A platform-source contracts only; never invoke runtime or Memory tools."""

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


def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8-sig")


class MemoryM5APlatformProjection(unittest.TestCase):
    def test_four_thin_platform_entries_preserve_frozen_boundary(self):
        entries = (
            "Codex/.codex/AGENTS.md",
            "Claude/.claude/CLAUDE.md",
            "Cursor/.cursor/rules/00-core.mdc",
            "Antigravity/.agents/rules/00_core_identity.md",
        )
        for path in entries:
            with self.subTest(path=path):
                text = read(path)
                for marker in (".agents/memory/", "memory-ops", "memory-arch",
                               "frozen_memory_action"):
                    self.assertIn(marker, text, path)
                self.assertTrue("on demand" in text or "按需" in text, path)
                self.assertNotIn("At new conversation Turn=1", text)

    def test_skill_loading_is_conditional_and_no_old_required_skill(self):
        roots = (
            ROOT / "Codex/.agents/workflow-skills",
            ROOT / "Claude/.claude/commands",
            ROOT / "Cursor/.agents/workflow-skills",
            ROOT / "Antigravity/.agents/workflows",
        )
        for root in roots:
            for path in root.rglob("*"):
                if not path.is_file() or path.suffix not in {".md", ".mdc"}:
                    continue
                text = path.read_text(encoding="utf-8-sig")
                front = text.split("---", 2)[1] if text.startswith("---") and "---" in text[3:] else ""
                required = re.search(r"(?ms)^required_skills:\s*(.*?)(?=^(?:memory_awareness|user-invocable|metadata|---):?|\Z)", front)
                if required:
                    for skill in OLD | {"memory-ops", "memory-arch"}:
                        self.assertNotIn(skill, required.group(1), str(path))

    def test_no_compulsory_startup_memory_probe_or_wrong_claude_path(self):
        claude = read("Claude/.claude/rules/memory-contract.md")
        claude_guard = read("Claude/.claude/rules/cross-lingual-guard.md")
        ant = read("Antigravity/.agents/rules/06_memory_push.md")
        ant_guard = read("Antigravity/.agents/rules/01_cross_lingual_guard.md")
        for text in (claude, ant):
            self.assertIn("Do not call `memory_list`", text)
            self.assertNotIn("At new conversation Turn=1:", text)
            self.assertNotIn("對話啟動 -> 呼叫 cartridge-system__memory_list", text)
        self.assertNotIn("immediately read `~/.claude/projects", claude_guard)
        self.assertIn("separate platform feature", claude)
        self.assertIn(".agents/memory/", claude_guard)
        self.assertNotIn("首次回應（`Turn=1`）時，保留原有", ant_guard)

    def test_checkpoint_recovery_survives_without_memory_trigger(self):
        owner = read("Shared/policies/references/session-checkpoint-recovery.md")
        for marker in (".agents/logs/checkpoint.json", "in_progress", "completed",
                       "GO", "SKIP", "status", "workflow", "phase", "timestamp"):
            self.assertIn(marker, owner)
        for path in ("Claude/.claude/rules/session-checkpoint-recovery.md",
                     "Antigravity/.agents/rules/02_session_checkpoint_recovery.md"):
            text = read(path)
            self.assertIn(".agents/shared/policies/references/session-checkpoint-recovery.md", text)
            self.assertIn("startup", text)
            self.assertIn("never calls `memory_list`", text)

    def test_no_formal_memory_agent_or_ordinary_legacy_route(self):
        agents = (
            "Codex/.codex/agents", "Claude/.claude/agents",
            "Cursor/.cursor/agents", "Antigravity/.agents/agents",
        )
        for relative in agents:
            names = {p.stem for p in (ROOT / relative).iterdir() if p.is_file()}
            self.assertEqual(len(names), 6, relative)
            self.assertFalse(any("memory" in name for name in names), relative)
        for relative in ("Antigravity/.agents/workflows/05_condense(濃縮).md",
                         "Claude/.claude/commands/05_condense（濃縮）/SKILL.md",
                         "Codex/.agents/workflow-skills/05-condense-濃縮/SKILL.md",
                         "Cursor/.agents/workflow-skills/05-condense-濃縮/SKILL.md"):
            body = read(relative)
            front = body.split("---", 2)[1]
            self.assertFalse(any(old in front for old in OLD), relative)
            for old_route in ("/skills/programming-team-governance/SKILL.md",
                              "/skills/team-role-boundaries/SKILL.md",
                              "/skills/team-completion-gate/SKILL.md",
                              "Full team completion requires separated implementation change delivery"):
                self.assertNotIn(old_route, body, relative)
            for owner in ("memory-governance.md", "authorization-resolution.md",
                          "completion-policy.md"):
                self.assertIn(owner, body, relative)
        ant_core = read("Antigravity/.agents/rules/00_core_identity.md")
        self.assertNotIn("Shared/skills/team-memory-docs-delivery-artifact/SKILL.md", ant_core)
        self.assertIn("legacy-skills/team-memory-docs-delivery-artifact/REFERENCE.md", ant_core)

    def test_source_only_does_not_claim_runtime_activation(self):
        for path in ("Codex/.codex/AGENTS.md", "Claude/.claude/CLAUDE.md",
                     "Cursor/.cursor/rules/00-core.mdc",
                     "Antigravity/.agents/rules/00_core_identity.md"):
            text = read(path)
            self.assertIn("M5C", text)
            self.assertIn("frozen_memory_action", text)
        self.assertIn("no-write", read("Claude/.claude/rules/memory-contract.md"))
        self.assertIn("no-write", read("Antigravity/.agents/rules/03_memory_skill_contract.md"))


if __name__ == "__main__":
    unittest.main()
