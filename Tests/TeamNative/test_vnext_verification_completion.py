"""Phase 4A read-only policy scenarios; no runtime, login, deployment or fixtures.

The normalized tables are canonical source contracts, not an application engine.
Scenario expectations below come from the Phase 4A acceptance independently.
Run with python -B -m unittest discover -s Tests/TeamNative -p test_vnext*.py -v.
"""
import hashlib
import re
import unittest
from pathlib import Path
from vnext_source_paths import historical_source

ROOT = Path(__file__).resolve().parents[2]


def read(relative):
    return historical_source(relative)


def active(text):
    # Phase 3 Team blocks and Phase 4A compatibility sections are disjoint here.
    for name in ("TEAM", "COMPLETION"):
        text = re.sub(r"<!-- LEGACY_" + name + r"_COMPATIBILITY_START -->.*?<!-- LEGACY_" + name + r"_COMPATIBILITY_END -->", "", text, flags=re.S)
    return text


def rows(path, marker):
    data = read(path).split(f"<!-- {marker}_START -->")[1].split(f"<!-- {marker}_END -->")[0]
    return [[v.strip() for v in line.strip().strip("|").split("|")]
            for line in data.splitlines() if line.startswith("|")][2:]


VERIFY = "Shared/policies/verification-strategy.md"
REVIEW = "Shared/policies/review-governance.md"
COMPLETE = "Shared/policies/completion-policy.md"
STATUS = "Shared/policies/references/status-ontology.md"


def decide(path, marker, facts):
    return next(result for fact, result in rows(path, marker) if fact == "otherwise" or facts.get(fact, False))


class VerificationAxes(unittest.TestCase):
    def axes(self, **facts):
        return (decide(VERIFY, "VERIFICATION_SCOPE_TABLE", facts),
                decide(VERIFY, "VERIFICATION_INDEPENDENCE_TABLE", facts))

    def test_small_fix_focused_direct(self):
        self.assertEqual(self.axes(small_fix=True), ("focused", "direct"))

    def test_shared_library_broad_not_automatically_independent(self):
        self.assertEqual(self.axes(affected_boundary_is_broad=True, shared_library=True), ("broad", "direct"))

    def test_small_auth_fix_focused_independent(self):
        self.assertEqual(self.axes(required_judgment_separation=True, small_auth_fix=True), ("focused", "independent"))

    def test_large_low_risk_refactor_broad_direct(self):
        self.assertEqual(self.axes(affected_boundary_is_broad=True, low_risk=True), ("broad", "direct"))

    def test_broad_independent_is_also_valid(self):
        self.assertEqual(self.axes(affected_boundary_is_broad=True, required_judgment_separation=True), ("broad", "independent"))

    def test_no_model_authorization_tool_file_count_cascade(self):
        for unrelated in ["deep_model", "protected_action", "high_risk", "multi_file", "source_write", "browser", "api", "testing"]:
            self.assertEqual(self.axes(**{unrelated: True}), ("focused", "direct"), unrelated)
            self.assertEqual(self.axes(affected_boundary_is_broad=True, **{unrelated: True}), ("broad", "direct"))

    def test_only_two_values_per_axis_and_no_independence_as_scope(self):
        self.assertEqual({r[1] for r in rows(VERIFY, "VERIFICATION_SCOPE_TABLE")}, {"focused", "broad"})
        self.assertEqual({r[1] for r in rows(VERIFY, "VERIFICATION_INDEPENDENCE_TABLE")}, {"direct", "independent"})

    def test_existing_evidence_first_without_full_suite_or_test_generation(self):
        text = active(read(VERIFY))
        self.assertIn("Prefer an existing direct evidence route", text)
        self.assertIn("Do not create a new test by default", text)
        self.assertIn("broad does not mean all tests or a full suite", text)
        self.assertIn("independent acceptance oracle", text)


class EvidenceClaims(unittest.TestCase):
    def supports(self, evidence, claim):
        claims = ["rendering", "exercised_behavior", "persistence", "publication"]
        record = next(row for row in rows(VERIFY, "EVIDENCE_CLAIM_TABLE") if row[0] == evidence)
        return record[claims.index(claim) + 1] == "yes"

    def test_static_ui_does_not_prove_rendering(self):
        self.assertFalse(self.supports("static_ui", "rendering"))
        self.assertFalse(self.supports("static_ui", "exercised_behavior"))

    def test_actual_browser_dom_runtime_can_prove_observed_rendering_behavior(self):
        self.assertTrue(self.supports("browser_dom_runtime", "rendering"))
        self.assertTrue(self.supports("browser_dom_runtime", "exercised_behavior"))
        self.assertIn("terminal provider does not make that evidence merely static", active(read(VERIFY)))

    def test_screenshot_cannot_prove_persistence_or_publication(self):
        self.assertTrue(self.supports("screenshot", "rendering"))
        self.assertFalse(self.supports("screenshot", "persistence"))
        self.assertFalse(self.supports("screenshot", "publication"))

    def test_api_response_needs_durable_contract_or_followup_for_persistence(self):
        self.assertFalse(self.supports("api_response", "persistence"))
        self.assertTrue(self.supports("api_durable_contract", "persistence"))
        self.assertTrue(self.supports("persisted_state_read", "persistence"))

    def test_projects_keep_their_existing_verifier_not_a_shared_tool_mandate(self):
        text = active(read(VERIFY))
        self.assertIn("Shared specifies no universal\nverifier", text)
        for source in ["manifests", "scripts", "lockfiles", "configuration", "installed project tools"]:
            self.assertIn(source, text)
        self.assertNotRegex(text, r"(?i)must use (npm|pytest|playwright|CLI|MCP)|run all tests")
        self.assertIn("PROJECT_DERIVED", text)


class FailureAndRepair(unittest.TestCase):
    def test_failure_classes_cover_the_required_distinctions(self):
        classes = {row[0] for row in rows(VERIFY, "VERIFICATION_FAILURE_CLASSES")}
        self.assertEqual(classes, {"implementation_defect", "test_evidence_defect", "environment_tool_failure",
            "stale_expectation", "capability_limitation", "authorization_permission_block", "unknown"})

    def test_stale_expectation_requires_accepted_oracle_before_edit(self):
        meanings = dict(rows(VERIFY, "VERIFICATION_FAILURE_CLASSES"))
        self.assertIn("prove the change before updating", meanings["stale_expectation"])
        self.assertIn("accepted oracle before repair", meanings["test_evidence_defect"])
        self.assertIn("Never change a test just to turn it green", active(read(VERIFY)))

    def test_tool_failure_does_not_prove_product_failure_or_permit_bypass(self):
        meanings = dict(rows(VERIFY, "VERIFICATION_FAILURE_CLASSES"))
        self.assertIn("not proof that product behavior failed", meanings["environment_tool_failure"])
        self.assertIn("native denial stops the affected action", active(read(VERIFY)))
        self.assertIn("Do not switch providers to bypass denial", active(read(VERIFY)))

    def test_independent_failure_A_returns_to_main_and_requires_fresh_B(self):
        policy = active(read(VERIFY))
        self.assertRegex(policy, r"independent Verifier/Reviewer returns finding \+ evidence to Main/Implementer")
        self.assertIn("Independent roles never repair the implementation", policy)
        path = "Shared/policies/agent-governance.md"
        version_a = hashlib.sha256(b"implementation A").hexdigest()
        version_b = hashlib.sha256(b"implementation B").hexdigest()
        result = decide(path, "AGENT_FRESHNESS_TABLE", {"version_changed": version_a != version_b})
        self.assertEqual(result, "stale")
        self.assertEqual(decide(path, "AGENT_FRESHNESS_TABLE", {"version_matches": True}), "current")
        self.assertEqual(decide(path, "AGENT_FRESHNESS_TABLE", {"implementation_owned_by_judge": True, "version_matches": True}), "not_independent")


class ReviewTriggers(unittest.TestCase):
    def test_ordinary_bug_and_multifile_do_not_require_reviewer(self):
        for fact in ["ordinary_bug", "multi_file", "source_modification", "policy_modification", "browser_work", "test_work", "tool_available"]:
            self.assertEqual(decide(REVIEW, "REVIEW_APPLICABILITY_TABLE", {fact: True}), "not_required")

    def test_public_contract_review_applicable(self):
        self.assertEqual(decide(REVIEW, "REVIEW_APPLICABILITY_TABLE", {"actual_public_contract_change": True}), "applicable")

    def test_explicit_or_formal_separation_review_required(self):
        for fact in ["explicit_independent_review_request", "formal_review_separation_required"]:
            self.assertEqual(decide(REVIEW, "REVIEW_APPLICABILITY_TABLE", {fact: True}), "required")

    def test_security_review_applicable_without_replacing_runtime_acceptance(self):
        self.assertEqual(decide(REVIEW, "REVIEW_APPLICABILITY_TABLE", {"actual_security_sensitive_implementation": True}), "applicable")
        self.assertIn("does not replace unrelated runtime or general\nreview acceptance", read(REVIEW))

    def test_review_and_verification_are_not_interchangeable(self):
        text = read(REVIEW)
        self.assertIn("Passing tests is not architecture approval", text)
        self.assertIn("favorable\ndesign review is not proof of runtime behavior", text)
        self.assertIn("Use one, several or none", text)


class CompletionTruth(unittest.TestCase):
    def completion(self, **facts):
        return decide(COMPLETE, "COMPLETION_DECISION_TABLE", facts)

    def test_only_five_general_completion_states(self):
        expected = {"complete", "complete_with_followups", "partial", "blocked", "unverified"}
        self.assertEqual({row[0] for row in rows(COMPLETE, "COMPLETION_STATES")}, expected)
        self.assertEqual({row[1] for row in rows(COMPLETE, "COMPLETION_DECISION_TABLE")}, expected)

    def test_changed_only_is_not_complete_or_verified(self):
        self.assertEqual(self.completion(changed=True), "unverified")
        facts = {row[0]: row for row in rows(STATUS, "TRUTH_FACTS_TABLE")}
        self.assertIn("verified", facts["changed"][2])

    def test_verified_A_but_requested_B_unfinished_is_partial(self):
        self.assertEqual(self.completion(changed=True, verified=True, requested_work_unfinished=True), "partial")

    def test_done_implementation_missing_evidence_is_unverified(self):
        self.assertEqual(self.completion(implementation_done=True, required_evidence_missing_or_stale=True), "unverified")

    def test_permission_block_has_specific_requirement_and_precedence(self):
        self.assertEqual(self.completion(necessary_work_blocked=True, requested_work_unfinished=True), "blocked")
        self.assertRegex(read(COMPLETE), r"affected requirement, exact\ncondition and missing evidence/input")

    def test_all_required_satisfied_is_complete(self):
        self.assertEqual(self.completion(all_required_satisfied=True), "complete")

    def test_only_optional_cleanup_can_be_complete_with_followups(self):
        self.assertEqual(self.completion(all_required_satisfied_with_optional_followups=True), "complete_with_followups")
        self.assertEqual(self.completion(required_evidence_missing_or_stale=True, all_required_satisfied_with_optional_followups=True), "unverified")

    def test_risk_acceptance_does_not_supply_required_acceptance(self):
        for gap, expected in [("requested_work_unfinished", "partial"), ("necessary_work_blocked", "blocked"), ("required_evidence_missing_or_stale", "unverified")]:
            self.assertEqual(self.completion(risk_accepted=True, **{gap: True}), expected)
        self.assertEqual(self.completion(risk_accepted=True, all_required_satisfied_with_optional_followups=True), "complete_with_followups")

    def test_truth_facts_are_exactly_six_and_require_separate_evidence(self):
        facts = {row[0]: row for row in rows(STATUS, "TRUTH_FACTS_TABLE")}
        self.assertEqual(set(facts), {"changed", "verified", "completed", "committed", "published", "deployed"})
        for left, right in [("changed", "verified"), ("verified", "completed"), ("committed", "published"), ("published", "deployed"), ("completed", "committed")]:
            self.assertIn(right, facts[left][2])
        self.assertIn("Actual Git commit evidence", facts["committed"][1])
        self.assertIn("publication target evidence", facts["published"][1])
        self.assertIn("named runtime/environment", facts["deployed"][1])

    def test_complete_does_not_require_unrequested_commit_publish_deploy(self):
        self.assertEqual(self.completion(all_required_satisfied=True, committed=False, published=False, deployed=False), "complete")
        self.assertIn("Do not demand deployment/commit/publication when\nthey were not requested", read(COMPLETE))


class OwnershipAndFrozenCompatibility(unittest.TestCase):
    def test_core_ingress_does_not_restore_legacy_completion_or_team_chain(self):
        for path in ["Codex/.codex/AGENTS.md", "Cursor/.cursor/rules/00-core.mdc",
                     "Claude/.claude/rules/core-identity.md", "Antigravity/.agents/rules/00_core_identity.md"]:
            text = active(read(path))
            self.assertIn("Shared/policies/completion-policy.md", text)
            self.assertNotIn("closed-with-director-risk", text)
            self.assertNotIn("Team artifacts are required only in Team", text)

    def test_each_canonical_decision_has_one_owner(self):
        for marker, expected in [("VERIFICATION_SCOPE_TABLE", "verification-strategy.md"),
            ("VERIFICATION_INDEPENDENCE_TABLE", "verification-strategy.md"),
            ("REVIEW_APPLICABILITY_TABLE", "review-governance.md"),
            ("COMPLETION_DECISION_TABLE", "completion-policy.md"),
            ("TRUTH_FACTS_TABLE", "status-ontology.md")]:
            found = [p.name for p in (ROOT / "Shared").rglob("*.md") if f"<!-- {marker}_START -->" in active(p.read_text(encoding="utf-8-sig"))]
            self.assertEqual(found, [expected])

    def test_methods_point_to_owners_and_do_not_restore_auto_pass(self):
        for skill in ["quality-review-governance", "ai-dev-quality-gate", "browser-testing", "test-patterns", "test-automation-strategy", "impact-test-strategy"]:
            text = active(read(f"Shared/skills/{skill}/SKILL.md"))
            for policy in ["verification-strategy.md", "review-governance.md", "completion-policy.md"]:
                self.assertIn(policy, text)
            self.assertNotIn("Linter + Tests pass 100% means additional human review is skipped", text)
            self.assertNotIn("This skill owns the internal review lifecycle", text)

    def test_all_general_entries_use_canonical_completion_without_ladder(self):
        count = 0
        for root in ["Codex/.agents/workflow-skills", "Cursor/.agents/workflow-skills", "Claude/.claude/commands", "Antigravity/.agents/workflows"]:
            for p in (ROOT / root).rglob("*.md"):
                if p.name.startswith("_") or re.match(r"^(05|10)", p.name) or re.match(r"^(05|10)", p.parent.name):
                    continue
                text = active(p.read_text(encoding="utf-8-sig"))
                for policy in ["verification-strategy.md", "review-governance.md", "completion-policy.md"]:
                    self.assertIn(policy, text, str(p))
                boundary = text.split("## Completion Boundary")[1]
                self.assertNotRegex(boundary, r"source-level|process-complete|release-ready|closed-with-director-risk")
                count += 1
        self.assertEqual(count, 47)

    def test_quality_method_consumers_use_canonical_review_applicability(self):
        for skill in ["intent-alignment-gate", "code-quality"]:
            text = active(read(f"Shared/skills/{skill}/SKILL.md"))
            self.assertIn("Shared/policies/review-governance.md", text)
            self.assertNotIn("when `quality-review-governance` applies", text)
            self.assertNotIn("Record the review state", text)
        core = active(read("Antigravity/.agents/rules/00_core_identity.md"))
        self.assertNotIn("review, validation, and completion evidence through the matching Skills", core)

    def test_public_completion_navigation_separates_frozen_memory(self):
        for platform in ["Codex", "Claude", "Antigravity"]:
            text = read(f"{platform}/README.md")
            self.assertIn("| General work completion | `Shared/policies/completion-policy.md` |", text)
            self.assertIn("| Frozen Memory / legacy completion targets | `Shared/policies/references/completion-state-machine.md` |", text)
            self.assertNotIn("| Completion targets and states |", text)

    def test_frozen_memory_keeps_original_legacy_vocabulary(self):
        frozen = read("Shared/policies/references/completion-state-machine.md")
        for name in ["source-level", "process-complete", "release-ready", "closed-with-director-risk"]:
            self.assertIn(name, frozen)
        self.assertNotIn("complete_with_followups", frozen)
        bundle = read("Shared/policies/references/memory-closure-bundle-contract.md")
        self.assertNotIn("complete_with_followups", bundle)
        self.assertIn("completion_bundle", read("Shared/skills/team-memory-closure-delivery-artifact/SKILL.md"))
        self.assertIn("Work completion != Memory completion", read(COMPLETE))

    def test_new_direct_completion_does_not_consume_memory_chain(self):
        self.assertEqual(decide(COMPLETE, "COMPLETION_DECISION_TABLE", {"all_required_satisfied": True, "memory_receipt": False}), "complete")
        self.assertIn("does not load a Memory chain merely to become complete", read(COMPLETE))
        self.assertIn("An explicitly requested\nMemory deliverable still needs its own unchanged consumer evidence", read(COMPLETE))


if __name__ == "__main__":
    unittest.main()
