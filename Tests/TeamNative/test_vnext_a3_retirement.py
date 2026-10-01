"""A3 source conformance and preservation; not a model/provider execution test."""
import hashlib
import json
import re
import unittest
import yaml
from vnext_source_paths import ROOT, artifacts, historical_bytes
from test_vnext_skill_classification import parse_map

TARGETS = {'structured-reasoning', 'code-diagnosis'}
BLUEPRINT = 'Shared/policies/references/task-assignment-methods.md'
DEBUG = 'Shared/policies/references/debug-investigation-methods.md'


def read(path):
    return (ROOT / path).read_text(encoding='utf-8-sig')


def fingerprint(paths):
    records = sorted(p.relative_to(ROOT).as_posix() + ':' + hashlib.sha256(p.read_bytes()).hexdigest() for p in paths)
    return hashlib.sha256('\n'.join(records).encode()).hexdigest()


def table(path, header):
    text = read(path).split(header, 1)[1].split('\n\n', 1)[0]
    return re.findall(r'^\| ([a-z_]+(?: & [a-z_]+)*) \| ([a-z_]+) \|\s*$', text, re.M)


def resolve(rows, facts):
    # Same first-match interpretation as prior source tests; decisions live in
    # canonical policy, not in this harness or a new routing implementation.
    for predicate, result in rows:
        if all(term == 'otherwise' or facts.get(term) is True for term in predicate.split(' & ')):
            return result
    return None


class A3Retirement(unittest.TestCase):
    def test_exact_retire_set_and_denominator_without_fixed_count_target(self):
        rows = parse_map(read('Shared/policies/references/skill-architecture-disposition.md'))
        self.assertEqual({r['skill'] for r in rows if r['disposition'] == 'RETIRE'}, TARGETS)
        self.assertEqual({a['skill'] for a in artifacts('4B2A3')}, TARGETS)
        physical = {p.parent.name for p in (ROOT / 'Shared/skills').glob('*/SKILL.md')}
        active_list = re.findall(r'^- Skill: (.+)$', read('Shared/skills/_index.md'), re.M)
        active = set(active_list)
        self.assertFalse(TARGETS & (physical | active))
        self.assertEqual(len(active), len(active_list))
        self.assertEqual({r['skill'] for r in rows}, physical | {a['skill'] for a in artifacts()})
        self.assertEqual(physical - active, set())
        self.assertFalse(list((ROOT / 'Shared/policies/references/legacy-skills').rglob('SKILL.md')))

    def test_original_entry_and_reference_bytes_preserved(self):
        expected = {'structured-reasoning/SKILL.md', 'code-diagnosis/SKILL.md',
                    'code-diagnosis/references/diagnosis-task-prompt.md',
                    'code-diagnosis/references/diagnosis-report-template.md'}
        self.assertEqual({a['old_relative_path'] for a in artifacts('4B2A3')}, expected)
        for a in artifacts('4B2A3'):
            path = 'Shared/skills/' + a['old_relative_path']
            self.assertFalse((ROOT / path).exists())
            self.assertEqual(hashlib.sha256(historical_bytes(path)).hexdigest(), a['known_versions'][0]['sha256'])
            self.assertTrue(all(v['provenance'] for v in a['known_versions']))
            if path.endswith('/SKILL.md'):
                prefix = read('Shared/' + a['reference_relative_path']).split('<!-- ARCHIVED_SKILL_BODY_START -->')[0]
                self.assertIn('not an active Skill', prefix)
                self.assertIn('historical data only', prefix)

    def test_prior_mapping_and_archives_are_unchanged(self):
        from vnext_source_paths import pre_m5c_mapping_records
        prior = pre_m5c_mapping_records(artifacts('4B2A1') + artifacts('4B2A2'))
        self.assertEqual(hashlib.sha256(json.dumps(prior, sort_keys=True, separators=(',', ':')).encode()).hexdigest(),
                         '77fb2bcf9b40add101225d5488ee301d8216ac18fd9a9ac98caebd90e3650a47')
        self.assertEqual(fingerprint([ROOT / 'Shared' / a['reference_relative_path'] for a in prior]),
                         'daa51b08f30267ca89f9ef7f0fec396d0f2e6168c8a2a1444976483bdd3612ee')

    def test_all_other_skill_subtrees_remain_byte_identical(self):
        # Historical pre-A3 aggregate: 515ee2be45790a7df6ad9efca32342cf5c13d085b8cbc1c717b8066583a2efed.
        # Later authorized phases changed the live denominator. Validate the
        # exact archived originals that are still recoverable instead.
        for batch in ('4B2A4', 'M3'):
            for artifact in artifacts(batch):
                old = 'Shared/skills/' + artifact['old_relative_path']
                self.assertEqual(hashlib.sha256(historical_bytes(old)).hexdigest(),
                                 artifact['known_versions'][0]['sha256'])

    def test_architecture_method_is_reachable_from_blueprint_and_architect(self):
        architecture = read(BLUEPRINT).split('## Architecture alternatives and evidence', 1)[1].split('## Scope', 1)[0]
        for concept in ['alternatives', 'trade-offs', 'constraints', 'counter-evidence', 'assumptions',
                        'competing hypotheses', 'observed facts', 'inference', 'uncertainty',
                        'evidence is sufficient', 'decision rationale']:
            self.assertIn(concept, architecture)
        self.assertIn(BLUEPRINT + '#architecture-alternatives-and-evidence', read('Shared/workflow-stage-procedures.md'))
        self.assertIn(BLUEPRINT + '#architecture-alternatives-and-evidence', read('Shared/agents/references/role-methods.md'))
        self.assertIn('role-methods.md#architect', read('Shared/agents/architect.md'))
        self.assertIn('on demand', read('Shared/agents/references/role-methods.md'))
        self.assertIn('simple architecture question needs no', architecture)

    def test_debug_method_preserves_fault_analysis_without_cli_or_threshold_gate(self):
        text = read(DEBUG)
        for concept in ['symptom', 'reproduction', 'root-cause hypotheses', 'counter-evidence',
                        'data', 'call-chain', 'dependency', 'state transitions', 'boundary',
                        'error origin', 'downstream symptoms', 'known/unknown', 'premature fix',
                        'smallest authorized', 'evidence is', 'ruled-out', 'Main assesses']:
            self.assertIn(concept, text)
        self.assertNotRegex(text, r'(?i)\b(?:3 modules|15 files|30 files|CLI must|must.*CLI|totalThoughts|thoughtNumber)\b')
        self.assertIn('written report is optional', text)
        self.assertIn(DEBUG, read('Shared/workflow-stage-procedures.md'))
        for platform, rel in [('Codex', '.agents/workflow-skills/07-debug-除錯/SKILL.md'),
                              ('Cursor', '.agents/workflow-skills/07-debug-除錯/SKILL.md'),
                              ('Claude', '.claude/commands/07_debug(除錯)/SKILL.md'),
                              ('Antigravity', '.agents/workflows/07_debug(除錯).md')]:
            entry = read(platform + '/' + rel)
            self.assertIn('.agents/shared/policies/references/debug-investigation-methods.md', entry)
            self.assertNotRegex(entry, r'structured-reasoning|code-diagnosis')

    def test_no_reasoning_policy_or_new_agent(self):
        for name in ['reasoning-governance.md', 'deep-thinking-policy.md', 'thinking-runtime.md']:
            self.assertFalse((ROOT / 'Shared/policies' / name).exists())
        roles = [yaml.safe_load(read(p.relative_to(ROOT)).split('---', 2)[1])['name']
                 for p in (ROOT / 'Shared/agents').glob('*.md') if read(p.relative_to(ROOT)).startswith('---')]
        self.assertEqual(set(roles), {'Architect', 'Conditional Implementer', 'Researcher', 'Reviewer', 'Security Reviewer', 'Verifier'})
        self.assertLess(len(read(DEBUG).splitlines()), 110)
        self.assertNotRegex(read(DEBUG), r'(?m)^(required_skills|trigger|description|name):')

    def test_no_platform_source_retains_old_required_skill_or_invocation(self):
        for platform in ['Codex', 'Cursor', 'Claude', 'Antigravity']:
            for p in (ROOT / platform).rglob('*.md'):
                text = p.read_text(encoding='utf-8-sig')
                self.assertNotRegex(text, r'(?<![\w-])(?:structured-reasoning|code-diagnosis)(?![\w-])', str(p))

    def test_normalized_debug_and_architecture_modes_follow_existing_owner(self):
        rows = table('Shared/policies/execution-routing.md', '| Fact (first true wins) | Result |')
        cases = [({}, 'direct'), ({'complex_architecture': True}, 'direct'),
                 ({'file_count': 200, 'module_count': 40}, 'direct'),
                 ({'bounded_helper_use': True, 'large_search': True}, 'assisted'),
                 ({'required_duty_separation': True}, 'team')]
        for facts, expected in cases:
            for provider in ['sequentialthinking', 'gitnexus']:
                for ready in [False, True]:
                    with self.subTest(facts=facts, provider=provider, ready=ready):
                        self.assertEqual(resolve(rows, dict(facts, provider=provider, provider_ready=ready)), expected)

    def test_optional_provider_ready_absent_and_implicit_install_follow_capability_owner(self):
        path = 'Shared/policies/capability-resolution.md'
        readiness = table(path, '| Predicate (first matching row) | Status |')
        selection = table(path, '| Disqualifying fact (first matching row) | Decision |')
        for provider in ['sequentialthinking', 'gitnexus']:
            self.assertEqual(resolve(readiness, {'provider': provider, 'checked_absent': True}), 'unavailable')
            self.assertEqual(resolve(selection, {'provider': provider, 'not_ready': True}), 'inspect_or_alternative')
            self.assertEqual(resolve(readiness, {'provider': provider, 'present': True, 'sufficient': True}), 'ready')
            self.assertEqual(resolve(selection, {'provider': provider}), 'eligible')
            self.assertEqual(resolve(selection, {'provider': provider, 'implicit_install_download_init': True}), 'reject_provider')
        self.assertIn('absence does not block analysis', read(BLUEPRINT))
        self.assertIn('missing or unavailable providers do not block', read(DEBUG))
        self.assertIn('Do not automatically activate', read(DEBUG))


if __name__ == '__main__':
    unittest.main()
