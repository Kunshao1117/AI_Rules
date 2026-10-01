"""A6 source/metadata and evidence-interpretation contracts.

Fixtures are bounded source/evidence examples, not a native NLP trigger router,
browser driver, accessibility scanner or performance engine. Production loading
and projection are exercised separately in the PowerShell isolated fixture.
"""
import hashlib
import json
import re
import tempfile
import unittest
from pathlib import Path
import yaml
from vnext_source_paths import ROOT

SKILLS = ROOT / 'Shared/skills'
TARGETS = {'browser-testing', 'test-automation-strategy', 'test-patterns',
           'impact-test-strategy', 'a11y-testing', 'performance-audit'}
MARKER = b'<!-- PRE_A6_ORIGINAL_START -->\n'


def read(name, relative='SKILL.md'):
    return (SKILLS / name / relative).read_text(encoding='utf-8-sig')


def original_files():
    result = {}
    for name in TARGETS:
        root = SKILLS / name / 'references/legacy'
        for path in root.rglob('*.md'):
            suffix = path.relative_to(root).as_posix()
            if suffix == 'pre-a6-entry.md':
                suffix = 'SKILL.md'
            result['Shared/skills/' + name + '/' + suffix] = path.read_bytes().split(MARKER, 1)[1]
    return result


def pre_a6_shared_records(excluded_skill_names=()):
    """Reconstruct previous source oracles without changing earlier pinned hashes."""
    from test_vnext_a7_gitnexus import pre_a7_shared_bytes
    records = []
    for relative, data in pre_a7_shared_bytes().items():
        path = ROOT / relative
        if any(path.is_relative_to(SKILLS / name) for name in TARGETS | set(excluded_skill_names)):
            continue
        records.append(relative + ':' + hashlib.sha256(data).hexdigest())
    for path, data in original_files().items():
        if path.split('/')[2] not in excluded_skill_names:
            records.append(path + ':' + hashlib.sha256(data).hexdigest())
    return records


class A6Methods(unittest.TestCase):
    def fixture(self, files):
        temp = tempfile.TemporaryDirectory(prefix='a6-method-case-')
        self.addCleanup(temp.cleanup)
        root = Path(temp.name)
        for name, content in files.items():
            path = root / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(content, encoding='utf-8')
        return root

    def test_originals_frozen_owners_a5_and_other_skills(self):
        fixture = json.loads((ROOT / 'Tests/TeamNative/a6-preservation-fixture.json').read_text())
        originals = original_files()
        self.assertEqual(set(originals), set(fixture['original_files']))
        for path, expected in fixture['original_files'].items():
            self.assertEqual(hashlib.sha256(originals[path]).hexdigest(), expected, path)
        from vnext_source_paths import assert_sealed_phase_fixture
        assert_sealed_phase_fixture(self, 'a6-preservation-fixture.json')
        self.assertRegex(fixture['protected_shared_sha256'], r'^[0-9a-f]{64}$')
        # The sealed phase fixture preserves the historical Cartridge hash.
        # Today's independent plugin state is neither formal source nor a
        # dependency of this archive contract; deployment sentinels test isolation.

    def test_metadata_unique_identity_and_no_chain_loading(self):
        index = (SKILLS / '_index.md').read_text(encoding='utf-8')
        entries = re.findall(r'^- Skill: (.+)$', index, re.M)
        self.assertEqual(len(entries), len(set(entries)))
        for name in TARGETS:
            text = read(name)
            meta = yaml.safe_load(text.split('---', 2)[1])
            self.assertEqual(meta['name'], name)
            self.assertEqual(meta['metadata']['memory_awareness'], 'none')
            self.assertEqual(set(meta), {'name', 'description', 'metadata'})
            for key in ['required_skills', 'relations', 'mcp_servers']:
                self.assertNotIn(key, meta)
                self.assertNotIn(key, meta['metadata'])
            self.assertEqual(entries.count(name), 1)
            self.assertLess(len(meta['description']), 1024)
            self.assertLess(len(text.splitlines()), 125)
            self.assertIn('Invocation classification: restricted', text)
            self.assertIn('Load other methods only for a separately identified', text)
            self.assertFalse(list((SKILLS / name / 'references').rglob('SKILL.md')))
            for part in [meta['description'], *re.split('Use when:|DO NOT use when:', meta['description'])[1:]]:
                self.assertRegex(part.strip()[0], '[\u4e00-\u9fff]')
            for ref in re.findall(r'(?<!/)references/[\w/-]+\.md', text):
                self.assertTrue((SKILLS / name / ref).is_file(), ref)

    def test_positive_cases_and_ordinary_work_exclusions_are_in_metadata(self):
        # Check each declared narrow trigger, not an invented NLP interpreter.
        cases = [('browser-testing', '視覺缺陷', '只改來源'),
                 ('test-automation-strategy', '不穩定失敗', '一般 source bug'),
                 ('test-patterns', '設計或修改具體測試', 'source edit'),
                 ('impact-test-strategy', '共用契約', '局部的變更'),
                 ('a11y-testing', '鍵盤焦點缺陷', '一般視覺 UI bug'),
                 ('performance-audit', '頁面載入', '普通視覺 UI bug')]
        for name, positive, negative in cases:
            description = yaml.safe_load(read(name).split('---', 2)[1])['description']
            yes, no = description.split('Use when:', 1)[1].split('DO NOT use when:')
            self.assertIn(positive, yes)
            self.assertIn(negative, no)
        self.assertIn('without an accessibility or performance question', read('browser-testing'))

    def test_browser_evidence_distinguishes_snapshot_interaction_and_persistence(self):
        ref = read('browser-testing', 'references/evidence-boundaries.md')
        rows = {cells[0]: cells[1:] for line in ref.splitlines() if line.startswith('| ')
                for cells in [[c.strip() for c in line.strip('|').split('|')]]}
        self.assertIn('Visible state', rows['Screenshot'][0])
        self.assertIn('Persistence', rows['Screenshot'][1])
        self.assertIn('state transition', rows['Actual runtime interaction and observed result'][0])
        self.assertIn('request occurred', rows['Request and response observation'][0])
        self.assertIn('Durable commit', rows['Request and response observation'][1])
        skill = read('browser-testing')
        for text in ['CLI, MCP or native', 'Main using a browser remains Direct',
                     'helper using it is\nAssisted', 'desktop IDE panel does not imply mobile/tablet',
                     'not mandatory for every interaction']:
            self.assertIn(text, skill)

    def test_locators_are_contextual_without_fixed_ranking(self):
        ref = read('test-automation-strategy', 'references/locator-and-fixture-methods.md')
        root = self.fixture({'panel.html': '<label for="email">電子郵件</label><input id="email">'
                                         '<button>儲存</button><p>已儲存</p><canvas data-testid="canvas-export"></canvas>'})
        html = (root / 'panel.html').read_text(encoding='utf-8')
        for token in ['<button>儲存', 'for="email"', '已儲存', 'data-testid="canvas-export"']:
            self.assertIn(token, html)
        for locator in ["getByRole('button'", "getByLabel('電子郵件')", "getByText('已儲存'", "getByTestId('canvas-export')"]:
            self.assertIn(locator, ref)
        self.assertIn('No row is a fixed ranking', ref)
        self.assertIn('Long CSS/XPath', ref)
        self.assertIn('Text\n   locators are not categorically forbidden', read('test-automation-strategy'))
        self.assertIn('https://playwright.dev/docs/locators', ref)

    def test_failure_classification_precedes_expectation_changes(self):
        text = read('test-automation-strategy')
        for kind in ['product defect', 'stale expectation', 'locator failure', 'timing issue', 'environment issue', 'provider failure']:
            self.assertIn(kind, text)
        for text_part in ['Never\n   loosen expectations', 'arbitrary sleeps', 'deterministic setup',
                          'test-order coupling', 'product\'s actual\n   locale']:
            self.assertIn(text_part, text)
        self.assertNotIn('Auto-Pass', text)

    def test_project_native_tests_and_mock_boundaries(self):
        from test_vnext_a4_project_derived import declared_inventory
        root = self.fixture({'pyproject.toml': '[tool.pytest.ini_options]',
                             '.github/workflows/check.yml': 'jobs:\n  test:\n    steps:\n      - run: python -m pytest tests\n'})
        found = declared_inventory(root)
        self.assertEqual(set(found['evidence']), {'Python'})
        self.assertEqual(found['routes']['ci:check.yml:0']['command'], 'python -m pytest tests')
        text = read('test-patterns')
        for concept in ['No Memory card', 'real core logic', 'Do not mock away',
                        'Not every external dependency must be mocked', 'observable business outcome',
                        'does not itself admit a new permanent test']:
            self.assertIn(concept, text)
        self.assertNotIn('@testing-library/react-hooks', read('test-patterns', 'references/hook-test-template.md'))

    def test_impact_uses_actual_surface_and_policy_retains_scope(self):
        from test_vnext_a3_retirement import table, resolve
        root = self.fixture({'contract.py': 'def decode(value): return value',
                             'consumer.py': 'from contract import decode\nresult = decode(payload)',
                             'unrelated.txt': 'no contract use'})
        consumers = [p.name for p in root.glob('*.py') if 'from contract import' in p.read_text()]
        self.assertEqual(consumers, ['consumer.py'])
        text = read('impact-test-strategy')
        for concept in ['actual consumers', 'configuration consumers', 'File/module counts alone',
                        'empty consumer list can be legitimate', 'not an automatic broad decision']:
            self.assertIn(concept, text)
        path = 'Shared/policies/verification-strategy.md'
        policy = (ROOT / path).read_text()
        scope_block = policy.split('<!-- VERIFICATION_SCOPE_TABLE_START -->')[1]
        rows = re.findall(r'^\| ([a-z_]+) \| ([a-z_]+) \|$', scope_block.split('<!-- VERIFICATION_SCOPE_TABLE_END -->')[0], re.M)
        self.assertEqual(resolve(rows, {'file_count_ten': True, 'module_count_three': True}), 'focused')
        self.assertEqual(resolve(rows, {'affected_boundary_is_broad': True}), 'broad')
        self.assertNotRegex(text, r'3\+ modules|scan all memory cards|affected_modules\[\]')

    def test_a11y_zero_findings_is_not_full_accessibility(self):
        root = self.fixture({'scan.json': '{"violations":[],"checkedRules":["label"]}'})
        report = json.loads((root / 'scan.json').read_text())
        self.assertEqual(report['violations'], [])
        self.assertEqual(report['checkedRules'], ['label'])
        text = read('a11y-testing')
        for concept in ['zero findings does not prove complete accessibility',
                        'actual focus flow', 'not a screen-reader execution',
                        'local change does not force a site-wide audit', 'standard, version/level']:
            self.assertIn(concept, text)
        self.assertNotIn('WCAG 2.1 Level AA', text)
        self.assertNotIn('scanAccessibility', text)

    def test_performance_comparison_does_not_equate_score_with_truth(self):
        root = self.fixture({'before.json': '{"metric":"duration_ms","condition":"lab-a","values":[100,110,105]}',
                             'after.json': '{"metric":"duration_ms","condition":"lab-a","values":[150,160,155]}'})
        before = json.loads((root / 'before.json').read_text())
        after = json.loads((root / 'after.json').read_text())
        self.assertEqual(before['condition'], after['condition'])
        self.assertGreater(min(after['values']), max(before['values']))
        text = read('performance-audit')
        for concept in ['before/after', 'comparable', 'sample distribution/variation',
                        'not all product performance', 'missing baseline', 'does not trigger installation']:
            self.assertIn(concept, text)
        ref = read('performance-audit', 'references/measurement-interpretation.md')
        self.assertIn('LCP, INP and CLS', ref)
        self.assertIn('not substitutes for INP or LCP', ref)
        self.assertIn('SEO, accessibility and best-practice scores are separate', text)
        self.assertNotIn('ALL four categories', text)

    def test_canonical_ownership_and_no_provider_or_legacy_governance(self):
        for name in TARGETS:
            text = read(name)
            for owner in ['verification-strategy.md', 'review-governance.md', 'completion-policy.md',
                          'execution-routing.md', 'authorization-resolution.md', 'capability-resolution.md']:
                self.assertIn(owner, text)
            self.assertIn('No implicit install, `npx` presence probe', text)
            self.assertIn('automatic login', text)
            self.assertIn('MCP server startup', text)
            self.assertIn('Provider-specific: no', text)
            for path in (SKILLS / name).rglob('*.md'):
                if 'legacy' in path.parts:
                    continue
                active = path.read_text(encoding='utf-8')
                for obsolete in ['Captain Board', 'role_instance', 'handoff packet', 'magic GO',
                                 'CLI branch', 'browser branch', '[SUDO]', 'Team completion', 'Auto-Pass']:
                    self.assertNotIn(obsolete, active, str(path))


if __name__ == '__main__':
    unittest.main()
