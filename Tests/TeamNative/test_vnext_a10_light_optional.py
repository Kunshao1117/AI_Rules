"""A10 source-contract regressions, not an NLP loader or live-provider test.

Task examples test entry descriptions and method boundaries. Policy outcomes
consume existing canonical tables; they do not implement a new pack runtime.
Original bytes are test-only and keep earlier preservation oracles unchanged.
"""
import base64
import hashlib
import json
import re
import unittest
import yaml
from vnext_source_paths import ROOT, M3_RETIRED
from test_vnext_a3_retirement import table, resolve

NAMES = {'trunk-ops', 'excel-ops', 'context7-docs'}
FIXTURE = ROOT / 'Tests/TeamNative/a10-originals-fixture.json'


def read(path):
    return (ROOT / path).read_text(encoding='utf-8-sig')


def originals():
    return {p: base64.b64decode(data, validate=True) for p, data in
            json.loads(FIXTURE.read_text())['originals_base64'].items()}


def pre_a10_shared_bytes():
    from test_vnext_a11_github_cloudflare import pre_a11_shared_bytes
    result = pre_a11_shared_bytes()
    result.update(originals())
    return result


def entry(name):
    return read(f'Shared/skills/{name}/SKILL.md')


def registry_without_targets(data):
    return re.sub(rb'## \d+\. (?:trunk-ops|excel-ops|context7-docs)\r?\n.*?(?=## |\Z)',
                  b'', data, flags=re.S)


class A10LightOptional(unittest.TestCase):
    def test_original_bytes_match_unchanged_a8_oracle(self):
        a8 = json.loads((ROOT / 'Tests/TeamNative/a8-preservation-fixture.json').read_text())
        self.assertEqual(set(originals()), {f'Shared/skills/{n}/SKILL.md' for n in NAMES})
        for path, data in originals().items():
            self.assertEqual(hashlib.sha256(data).hexdigest(), a8['protected_shared'][path], path)

    def test_other_shared_sources_and_registry_blocks_byte_preserved(self):
        from vnext_source_paths import assert_sealed_phase_fixture
        # Full intermediate A10 source bytes were not archived. Seal the
        # historical fixture; current owners have separate live tests.
        assert_sealed_phase_fixture(self, FIXTURE.name)
        f = json.loads(FIXTURE.read_text())
        self.assertRegex(f['other_shared_sha256'], r'^[0-9a-f]{64}$')
        self.assertRegex(f['other_registry_sha256'], r'^[0-9a-f]{64}$')

    def test_retained_inventory_no_nested_skill_or_new_archive(self):
        f = json.loads(FIXTURE.read_text())
        physical = sorted(p.parent.name for p in (ROOT / 'Shared/skills').glob('*/SKILL.md'))
        active = re.findall(r'^- Skill: (.+)$', read('Shared/skills/_index.md'), re.M)
        self.assertEqual(physical, [n for n in f['physical'] if n not in M3_RETIRED])
        self.assertEqual(active, [n for n in f['active'] if n not in M3_RETIRED])
        for name in NAMES:
            self.assertIn(name, active)
            self.assertEqual([p.name for p in (ROOT / f'Shared/skills/{name}').rglob('*') if p.is_file()], ['SKILL.md'])

    def test_restricted_loading_no_relations_or_pack_chain(self):
        for name in NAMES:
            with self.subTest(skill=name):
                body = entry(name)
                meta = yaml.safe_load(body.split('---', 2)[1])
                self.assertEqual(set(meta), {'name', 'description', 'metadata'})
                self.assertFalse({'required_skills', 'relations', 'mcp_servers'} & meta['metadata'].keys())
                self.assertIn('Invocation classification: restricted', body)
                self.assertIn('No automatic sibling loading', body)
                self.assertIn('Use when:', meta['description'])
                self.assertIn('DO NOT use when:', meta['description'])
                self.assertLess(len(body.splitlines()), 95)

    def test_task_loading_examples_bound_to_description(self):
        # These explicit positive/negative cases check the source route contract,
        # not native model behavior or a keyword-only classification engine.
        cases = [('trunk-ops', 'Trunk CI Autopilot failure', 'ordinary local test failure'),
                 ('excel-ops', 'workbook formulas', 'CSV-only work'),
                 ('context7-docs', 'version-sensitive API', 'routine coding')]
        for name, positive, negative in cases:
            desc = yaml.safe_load(entry(name).split('---', 2)[1])['description']
            accepted, excluded = desc.split('DO NOT use when:', 1)
            self.assertIn(positive, accepted)
            self.assertIn(negative, excluded)

    def test_trunk_evidence_does_not_apply_fix_or_authorize_push(self):
        b = entry('trunk-ops')
        for term in ['get-root-cause-analysis', 'existing PR analysis', 'current schema',
                     'product/version-specific', 'not assumed interchangeable aliases',
                     'not source-write\nauthorization', 'Do not automatically commit or push',
                     'not Git commit or push authorization', 'source changed, fix applied or verification passed',
                     'Main / an authorized Implementer', 'External AI provider coupling: yes',
                     'not a generic\nAI worker', 'report source changed only with an actual diff']:
            self.assertIn(term, b)
        auth = table('Shared/policies/authorization-resolution.md', '| Fact (first true wins) | Result |')
        for fact in ['recommendation_received', 'provider_workflow_says_push', 'analysis_success']:
            self.assertEqual(resolve(auth, {fact: True}), 'not_authorized')
        self.assertEqual(resolve(auth, {'current_scope_allows': True}), 'authorized')
        self.assertEqual(resolve(auth, {'missing_explicit_action_target': True, 'current_scope_allows': True}), 'not_authorized')

    def test_trunk_missing_provider_and_remote_prerequisites(self):
        b = entry('trunk-ops')
        for term in ['ordinary Debug / Verification', 'other available authorized evidence',
                     'install, login, configure MCP, upload CI data', 'OAuth/OIDC',
                     'minimize data egress', 'do not initiate login or read credentials',
                     'not necessarily the GitHub org', 'not executable instructions']:
            self.assertIn(term, b)
        for old in ['Master Agent', 'non-Gateway', 'tool-first gate', '[SUDO]', 'MCP HITL GATE']:
            self.assertNotIn(old, b)

    def test_excel_provider_is_unresolved_and_capability_derived(self):
        b = entry('excel-ops')
        for term in ['provider_unspecified / capability-derived', 'provider-specific: no',
                     'workbook_read', 'workbook_write', 'formula_inspection', 'range_update',
                     'Do not require Graph, openpyxl or MCP', 'not invented executable tools',
                     'Do not automatically install libraries/integrations']:
            self.assertIn(term, b)
        metadata = yaml.safe_load(b.split('---', 2)[1])['metadata']
        self.assertFalse({'mcp_servers', 'tool_scope'} & metadata.keys())
        self.assertNotIn('18 tools', b)

    def test_excel_identity_and_formula_checks_precede_recipes(self):
        b = entry('excel-ops')
        prewrite = b.split('## Before any write', 1)[1].split('## Bounded workbook recipes', 1)[0]
        for term in ['target workbook identity', 'target worksheet', 'exact range/table',
                     'headers', 'table boundaries', 'blank rows', 'merged cells', 'hidden rows',
                     'unknown target/effect stops the write', 'formula preservation',
                     'formatting is in scope', 'recoverable original data']:
            self.assertIn(term, prewrite)
        formula = b.split('- **Formula edit:**', 1)[1].split('- **Chart:**', 1)[0]
        self.assertLess(formula.index('validate syntax'), formula.index('before applying'))
        self.assertIn('cached value does not prove recalculation', formula)

    def test_excel_distinct_effects_and_preserved_methods(self):
        b = entry('excel-ops')
        for term in ['read, append, update cells, replace range, replace worksheet',
                     'create worksheet, delete worksheet and overwrite workbook',
                     '2D table', 'relative/absolute references', 'bar versus scatter',
                     'row/column/value fields', 'sum/count/average', 'refresh behavior',
                     'not merely the\n  first blank cell', 'Read back',
                     'Verify append did not replace existing rows', 'not a cleanup chain']:
            self.assertIn(term, b)

    def test_context7_version_and_identity_before_docs(self):
        b = entry('context7-docs')
        for term in ['manifest may specify a range', 'lockfile', 'resolved\n   version',
                     'resolve-library-id', 'query-docs', 'libraryName', 'libraryId',
                     'publisher/source', 'previously verified exact ID',
                     'matching the actual project version', '/owner/repo/<version>',
                     '/owner/repo@<version>', 'not a fabricated version tag',
                     'do not silently substitute latest', 'Query success is not product runtime evidence',
                     'Community-indexed material is not automatically official']:
            self.assertIn(term, b)
        self.assertLess(b.index('Resolve identity and version'), b.index('4. Use MCP `query-docs`'))
        for old in ['grounding_tier: G2', 'route `G3`', 'station-owned', 'MCP Server:', 'queries the **latest**']:
            self.assertNotIn(old, b)

    def test_context7_fallback_setup_and_credentials(self):
        b = entry('context7-docs')
        for term in ['unavailable, blocked or present_unverified', 'official vendor docs',
                     'official repository, project-local docs', 'does not block ordinary research',
                     'Do not probe presence with `npx ctx7`', 'No implicit setup, install',
                     'login/OAuth or API-key creation', 'not\npermission to execute',
                     'requirements depend on access mode', 'do not read\nsecrets',
                     'does not automatically load\ntech-stack-protocol']:
            self.assertIn(term, b)
        sel = table('Shared/policies/capability-resolution.md', '| Disqualifying fact (first matching row) | Decision |')
        for fact in ['implicit_install_download_init', 'missing_authorization', 'external_ai_unrequested']:
            self.assertEqual(resolve(sel, {fact: True}), 'reject_provider')
        self.assertEqual(resolve(sel, {'not_ready': True}), 'inspect_or_alternative')

    def test_all_ownership_stays_with_canonical_policies(self):
        for name in NAMES:
            b = entry(name)
            for owner in ['execution-routing.md', 'authorization-resolution.md', 'capability-resolution.md',
                          'agent-governance.md', 'model-profile-routing.md', 'verification-strategy.md',
                          'review-governance.md', 'completion-policy.md']:
                self.assertIn(owner, b)
                self.assertTrue((ROOT / 'Shared/policies' / owner).is_file())
            self.assertIn('frozen', b)
            self.assertIn('Memory /', b)
            self.assertNotRegex(b, r'(?i)station lifecycle|G2 / G3|MCP HITL GATE')

    def test_explicit_shared_owner_references_resolve(self):
        for name in NAMES:
            paths = re.findall(r'`(Shared/[^`]+\.md)`', entry(name))
            self.assertTrue(paths)
            for path in paths:
                self.assertTrue((ROOT / path).is_file(), f'{name}: {path}')
        for name in ['trunk-ops', 'context7-docs']:
            self.assertIn('Shared/policies/references/credential-boundary-contract.md', entry(name))


if __name__ == '__main__':
    unittest.main()
