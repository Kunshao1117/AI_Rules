"""Read-only Phase 3 source conformance; not a runtime worker simulator.

Run: python -m unittest discover -s Tests/TeamNative -p test_vnext_agent_sources.py -v
Uses Python 3.11+ tomllib and the locally available PyYAML parser. No installation,
deployment, login, subprocess launch, source repair or temporary directory cleanup.
"""
import hashlib
import re
import tomllib
import unittest
from pathlib import Path

import yaml
from vnext_source_paths import historical_source

ROOT = Path(__file__).resolve().parents[2]
ROLES = {"reviewer", "verifier", "researcher", "security-reviewer", "architect", "implementer"}
FIELDS = {"name", "purpose", "activation_conditions", "non_triggers", "scope_boundary",
          "independence_requirement", "write_boundary", "required_capabilities",
          "forbidden_actions", "output_contract"}


def source(path):
    return historical_source(path)


def active(text):
    return re.sub(r"<!-- LEGACY_TEAM_COMPATIBILITY_START -->.*?<!-- LEGACY_TEAM_COMPATIBILITY_END -->",
                  "", text, flags=re.S)


def frontmatter(text):
    match = re.match(r"\A---\n(.*?)\n---\n", text, re.S)
    if not match:
        raise ValueError("Missing leading YAML frontmatter")
    data = yaml.safe_load(match[1])
    if not isinstance(data, dict):
        raise ValueError("Frontmatter must be a mapping")
    return data


def role(name):
    return frontmatter(source(f"Shared/agents/{name}.md"))


def table(path, marker):
    text = source(path).split(f"<!-- {marker}_START -->", 1)[1].split(f"<!-- {marker}_END -->", 1)[0]
    return [[cell.strip() for cell in row.strip().strip("|").split("|")]
            for row in text.splitlines() if row.startswith("|")][2:]


def fact_result(rows, facts):
    return next(result for fact, result in rows if fact == "otherwise" or facts.get(fact, False))


def valid_native(data, platform, key):
    """Deliberately narrow supported-schema subset used by these templates."""
    if platform == "codex":
        required = {"name", "description", "developer_instructions"}
        allowed = required | {"sandbox_mode"}
    else:
        required = {"name", "description", "tools", "permissionMode"}
        allowed = required | {"disallowedTools"}
    if not required <= data.keys() or not data.keys() <= allowed:
        return False
    if data["name"] != "ai-rules-" + key or not isinstance(data["description"], str) or not data["description"]:
        return False
    if platform == "codex":
        if not isinstance(data["developer_instructions"], str) or not data["developer_instructions"]:
            return False
        expected_sandbox = None if key in {"verifier", "implementer"} else "read-only"
        return data.get("sandbox_mode") == expected_sandbox
    expected = {"Read", "Glob", "Grep"}
    if key == "researcher":
        expected |= {"WebSearch", "WebFetch"}
    if key in {"verifier", "implementer"}:
        expected.add("Bash")
    if key == "implementer":
        expected |= {"Edit", "Write"}
    return (set(data["tools"]) == expected and data["permissionMode"] == "default"
            and set(data.get("disallowedTools", [])) == (set() if key == "implementer" else {"Edit", "Write"}))


class RoleArchitecture(unittest.TestCase):
    def test_exact_six_single_source_roles(self):
        files = {p.stem for p in (ROOT / "Shared/agents").glob("*.md") if p.stem != "_registry"}
        self.assertEqual(files, ROLES)
        registry = source("Shared/agents/_registry.md")
        for key in ROLES:
            self.assertIn(f"{key}.md", registry)
            data = role(key)
            self.assertEqual(set(data), FIELDS)
            self.assertTrue(all(data.values()))

    def test_roles_are_not_skills_or_transports(self):
        for key in ROLES:
            text = source(f"Shared/agents/{key}.md")
            self.assertNotRegex(text, r"(?i)must use (CLI|MCP|browser)|gpt-[\w.-]+|claude-(opus|sonnet|haiku)|station_id|role_instance_id|dispatch_wave|W50|nonce")
            self.assertNotIn("agent_type", role(key))
            self.assertTrue(all(re.fullmatch(r"[a-z_]+", value) for value in role(key)["required_capabilities"]))
        self.assertIn("outside this Skill registry", source("Shared/skills/_index.md"))

    def test_direct_ordinary_implementation_has_no_assignment(self):
        text = source("Shared/policies/agent-governance.md")
        self.assertIn("Direct creates no formal Agent assignment and does not spawn an Implementer", text)
        self.assertIn("main agent is the work owner and ordinary implementer in every mode", text)
        self.assertIn("Direct work", " ".join(role("implementer")["non_triggers"]))

    def test_assisted_exploration_stays_a_helper(self):
        text = source("Shared/policies/agent-governance.md")
        self.assertRegex(text, r"Assisted adds a bounded auxiliary worker.*\n.*Team record")
        self.assertNotIn("explorer", ROLES)
        self.assertIn("Assisted helper use", " ".join(role("implementer")["non_triggers"]))

    def test_reviewer_returns_findings_without_implementation(self):
        data = role("reviewer")
        self.assertIn("Must not implement, repair or own", data["independence_requirement"])
        self.assertIn("No source writes or repairs", data["write_boundary"])
        self.assertIn("Protected actions", " ".join(data["forbidden_actions"]))
        self.assertNotIn("test_execution", data["required_capabilities"])

    def test_verifier_can_collect_evidence_but_not_repair(self):
        data = role("verifier")
        self.assertIn("classify failures and return", data["scope_boundary"])
        self.assertIn("Source repair forbidden", data["write_boundary"])
        self.assertIn("incidental local test/runtime", data["write_boundary"])
        self.assertIn("test_execution", data["required_capabilities"])
        self.assertIn("native permissions", data["write_boundary"])

    def test_security_copy_nontrigger_and_auth_trigger(self):
        data = role("security-reviewer")
        self.assertIn("Ordinary UI copy change", " ".join(data["non_triggers"]))
        self.assertIn("authentication, authorization, credential", data["purpose"])
        self.assertIn("concrete security-sensitive boundary", " ".join(data["activation_conditions"]))
        self.assertIn("Must not implement or repair", data["independence_requirement"])

    def test_architecture_is_not_file_count(self):
        data = role("architect")
        self.assertRegex(" ".join(data["non_triggers"]), r"(?i)multi.file|multiple files")
        self.assertRegex(" ".join(data["activation_conditions"]), r"(?i)contract|migration")
        self.assertRegex(data["scope_boundary"], r"(?i)design|decision")

    def test_conditional_implementation_requires_team_stream(self):
        data = role("implementer")
        self.assertIn("Resolved Team needs", " ".join(data["activation_conditions"]))
        self.assertIn("independently bounded implementation stream", " ".join(data["activation_conditions"]))
        self.assertIn("exact source allowlist", data["write_boundary"])
        self.assertIn("Commit, push, release or deployment", data["forbidden_actions"])

    def test_no_fixed_roster_or_nonagent_workflow_conversion(self):
        text = source("Shared/policies/agent-governance.md")
        self.assertIn("Main + Reviewer or Main + Verifier can be sufficient", text)
        self.assertIn("There is no fixed roster", text)
        self.assertIn("Git and release\nremain workflows", text)
        self.assertFalse(ROLES & {"memory-docs", "memory-closure", "intent-requirements", "git-checkpoint", "release-completion", "explorer"})

    def test_evidence_A_cannot_approve_B_or_same_owner(self):
        rows = table("Shared/policies/agent-governance.md", "AGENT_FRESHNESS_TABLE")
        review = {"source": hashlib.sha256(b"revision A").hexdigest(), "judge": "reviewer"}
        def assess(current, judge="reviewer"):
            return fact_result(rows, {"implementation_owned_by_judge": judge == "implementer",
                "version_missing": current is None,
                "version_changed": current is not None and current != review["source"],
                "version_matches": current == review["source"]})
        self.assertEqual(assess(review["source"]), "current")
        self.assertEqual(assess(hashlib.sha256(b"revision B").hexdigest()), "stale")
        self.assertEqual(assess(None), "unverified")
        self.assertEqual(assess(review["source"], "implementer"), "not_independent")


class Models(unittest.TestCase):
    def profile(self, complexity, uncertainty, risk, verifiability):
        facts = [complexity, uncertainty, risk, verifiability]
        rows = table("Shared/policies/model-profile-routing.md", "MODEL_PROFILE_TABLE")
        return next(row[4] for row in rows if all(expected == "*" or expected == actual for expected, actual in zip(row[:4], facts)))

    def test_fast_bounded_search(self):
        self.assertEqual(self.profile("low", "low", "low", "high"), "fast")

    def test_balanced_ordinary_engineering(self):
        self.assertEqual(self.profile("medium", "medium", "medium", "high"), "balanced")

    def test_deep_complex_architecture_and_uncertain_security(self):
        self.assertEqual(self.profile("high", "medium", "medium", "high"), "deep")
        self.assertEqual(self.profile("medium", "high", "high", "low"), "deep")

    def test_high_destructive_risk_does_not_alone_select_deep(self):
        self.assertEqual(self.profile("low", "low", "high", "high"), "balanced")

    def test_low_verifiability_requires_evidence_not_model_upgrade(self):
        self.assertEqual(self.profile("low", "low", "low", "low"), "balanced")
        self.assertIn("a stronger model alone does not repair the evidence gap", source("Shared/policies/model-profile-routing.md"))

    def test_exact_request_preserved_without_profile_substitution(self):
        text = source("Shared/policies/model-profile-routing.md")
        self.assertIn("Preserve an exact request verbatim", text)
        self.assertRegex(text, r"do not replace it with\na profile")
        self.assertIn("`requested_model` has a value only for an exact user request", text)

    def test_unavailable_or_effective_mismatch_wins_over_spawn(self):
        rows = table("Shared/policies/model-profile-routing.md", "MODEL_RESOLUTION_TABLE")
        for fact in ["exact_unavailable", "exact_effective_mismatch"]:
            self.assertEqual(fact_result(rows, {fact: True, "effective_model_verified": True}), "unavailable")

    def test_profile_preferred_unavailable_allows_same_profile(self):
        text = source("Shared/policies/model-profile-routing.md")
        self.assertRegex(text, r"preferred model's unavailability permits another available\nmodel or provider fitting the same profile")
        self.assertIn("existing capability/authorization scope admits it", text)

    def test_agent_id_alone_is_unreported(self):
        rows = table("Shared/policies/model-profile-routing.md", "MODEL_RESOLUTION_TABLE")
        self.assertEqual(fact_result(rows, {"agent_id": "a-worker", "spawn_success": True}), "unreported")
        self.assertEqual(fact_result(rows, {"effective_model_unreported": True, "effective_model_verified": True}), "unreported")
        self.assertEqual(fact_result(rows, {"effective_model_verified": True}), "confirmed")

    def test_one_active_model_owner_without_legacy_scoring(self):
        marker = "<!-- MODEL_PROFILE_TABLE_START -->"
        owners = [p for p in (ROOT / "Shared/policies").rglob("*.md") if marker in active(p.read_text(encoding="utf-8-sig"))]
        self.assertEqual([p.name for p in owners], ["model-profile-routing.md"])
        for rel in ["Shared/policies/task-capability-assessment.md", "Shared/skills/delegation-strategy/SKILL.md", "Shared/policies/subagent-invocation.md"]:
            self.assertIn("model-profile-routing.md", active(source(rel)))
            self.assertNotRegex(active(source(rel)), r"W50|W90|W99|latency coefficient|gpt-[\w.-]+|U/E/R/V/B/A/D/C/F")


class ProjectionsAndCompatibility(unittest.TestCase):
    def test_all_native_definitions_parse_and_fit_documented_subset(self):
        for platform, directory, suffix in [("codex", "Codex/.codex/agents", ".toml"), ("claude", "Claude/.claude/agents", ".md")]:
            paths = list((ROOT / directory).glob("*" + suffix))
            self.assertEqual(len(paths), 6)
            for key in ROLES:
                text = source(f"{directory}/ai-rules-{key}{suffix}")
                data = tomllib.loads(text) if platform == "codex" else frontmatter(text)
                self.assertTrue(valid_native(data, platform, key), (platform, key))
                prompt = data["developer_instructions"] if platform == "codex" else text
                self.assertIn(f".agents/shared/agents/{key}.md", prompt)
                self.assertIn(role(key)["purpose"], prompt)
                self.assertIn(role(key)["write_boundary"], prompt)

    def test_boundary_check_rejects_writable_reviewer_or_persistent_memory(self):
        good = frontmatter(source("Claude/.claude/agents/ai-rules-reviewer.md"))
        self.assertFalse(valid_native({**good, "tools": good["tools"] + ["Write"]}, "claude", "reviewer"))
        self.assertFalse(valid_native({**good, "memory": "project"}, "claude", "reviewer"))
        self.assertFalse(valid_native({**good, "model": "fixed-model"}, "claude", "reviewer"))
        codex = tomllib.loads(source("Codex/.codex/agents/ai-rules-reviewer.toml"))
        self.assertFalse(valid_native({**codex, "sandbox_mode": "workspace-write"}, "codex", "reviewer"))
        self.assertFalse(valid_native({**codex, "role_instance_id": "invented"}, "codex", "reviewer"))

    def test_verifier_incidental_effect_limitation_is_explicit(self):
        text = active(source("Shared/policies/adapters/claude-subagent-invocation.md"))
        self.assertIn("Bash can still write files", text)
        self.assertIn("not a filesystem side-effect guarantee", text)
        self.assertIn("verify an authorized native tool mapping", text)

    def test_current_precedence_and_no_false_native_loading(self):
        codex = source("Shared/policies/references/codex-model-resolution.md")
        self.assertIn("custom-agent file is applied afterward", codex)
        self.assertIn("cannot prove the file was loaded", codex)
        claude = source("Shared/policies/references/claude-model-resolution.md")
        self.assertIn("v2.1.251", claude)
        self.assertIn("CLAUDE_CODE_SUBAGENT_MODEL_FORCE=1", claude)
        self.assertIn("availableModels", claude)

    def test_other_platforms_use_verified_native_schema_without_runtime_claims(self):
        expected = {"antigravity": "Antigravity/.agents/agents/",
                    "cursor": "Cursor/.cursor/agents/"}
        for platform, native_path in expected.items():
            text = active(source(f"Shared/policies/adapters/{platform}-subagent-invocation.md"))
            self.assertIn(native_path, text)
            self.assertIn("Shared/agents/_registry.md", text)
            self.assertTrue("unverified" in text or "CURSOR_REAL_DISCOVERY_SMOKE_PENDING" in text)

    def test_legacy_fields_present_but_not_general_required_runtime(self):
        paths = ["Shared/policies/team-native-core.md", "Shared/policies/subagent-invocation.md",
                 "Shared/policies/workflow-orchestration.md", "Shared/policies/references/workflow-execution-spec-contract.md",
                 "Shared/skills/team-task-board/SKILL.md", "Shared/skills/team-station-handoff-packet/references/execution-lifecycle.md"]
        for path in paths:
            text = source(path)
            self.assertIn("<!-- LEGACY_TEAM_COMPATIBILITY_START -->", text)
            self.assertIn("not required for\ngeneral vNext work", active(text))
            self.assertNotRegex(active(text), r"role_instance_id|handoff_packet_id|W50|W90|W99|dispatch_wave|standby|requested/accepted/applied")
        self.assertIn("role_instance_id", source("Shared/skills/team-task-board/references/board-field-slice-and-roles.md"))
        routing = source("Shared/policies/execution-routing.md")
        self.assertNotIn("Only Team loads `team-native-core.md`", routing)
        self.assertIn("Team loads `agent-governance.md`", routing)

    def test_all_general_entries_route_to_agent_owner(self):
        count = 0
        for root in ["Codex/.agents/workflow-skills", "Cursor/.agents/workflow-skills", "Claude/.claude/commands", "Antigravity/.agents/workflows"]:
            for path in (ROOT / root).rglob("*.md"):
                if path.name.startswith("_") or re.match(r"^(05|10)", path.name) or re.match(r"^(05|10)", path.parent.name):
                    continue
                text = path.read_text(encoding="utf-8-sig")
                self.assertIn("agent-governance.md", text, str(path))
                self.assertIn("compatibility-only, not required for general vNext work", text)
                self.assertNotRegex(text, r"Only Team loads|only positive Team triggers load the legacy|For Team-Native work, load|Full team completion requires separated")
                count += 1
        self.assertEqual(count, 47)

    def test_mixed_domain_references_scope_old_runtime_not_memory(self):
        for path in ["Shared/workflow-stage-procedures.md", "Shared/workflow-capability-evidence-matrix.md",
                     "Shared/policies/grounding-governance.md", "Shared/policies/platform-plan-mapping.md"]:
            text = source(path)
            self.assertIn("## General Agent applicability", text)
            self.assertIn("frozen Memory semantics remain in force", text)
            self.assertIn("Shared/policies/verification-strategy.md", text)
            self.assertIn("Shared/policies/completion-policy.md", text)


if __name__ == "__main__":
    unittest.main()
