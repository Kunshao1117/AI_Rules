"""Project discovery fixtures and A4 source contracts; never execute verifiers.

The small fixture reader below reads real manifests/CI using the Reference's
evidence-path table. It is test-only, not a shipped provider/verification engine.
Evidence need is supplied by the case; the reader returns declarations only.
"""
import hashlib
import json
import re
import tempfile
import unittest
from pathlib import Path
import yaml
from vnext_source_paths import ROOT, artifacts, historical_bytes
from test_vnext_a3_retirement import table, resolve

REFERENCE = 'Shared/policies/references/project-derived-verification.md'


def read(path):
    return (ROOT / path).read_text(encoding='utf-8-sig')


def declared_inventory(root):
    # Interpret the documented evidence paths, not an invented global tool list.
    rows = re.findall(r'^\| (JavaScript/TypeScript|Python|Rust|Go|\.NET) \| (.+) \|$', read(REFERENCE), re.M)
    evidence = {stack: [str(p.relative_to(root)) for pattern in patterns.split('; ')
                        for p in root.glob(pattern) if p.is_file()] for stack, patterns in rows}
    routes = {}
    package = root / 'package.json'
    if package.is_file():
        data = json.loads(package.read_text())
        manager = data.get('packageManager', '').split('@')[0]
        for name, body in data.get('scripts', {}).items():
            # A fixture's explicit package-manager convention is required.
            routes['script:' + name] = {'command': f'{manager} run {name}' if manager else None, 'body': body}
    def runs(node):
        if isinstance(node, dict):
            for key, value in node.items():
                if key == 'run' and isinstance(value, str):
                    yield value
                else:
                    yield from runs(value)
        elif isinstance(node, list):
            for item in node:
                yield from runs(item)
    for ci in (root / '.github/workflows').glob('*.yml'):
        for number, command in enumerate(runs(yaml.safe_load(ci.read_text()))):
            routes[f'ci:{ci.name}:{number}'] = {'command': command, 'body': command}
    return {'evidence': {k: v for k, v in evidence.items() if v}, 'routes': routes}


class ProjectFixtures(unittest.TestCase):
    def fixture(self, files):
        temp = tempfile.TemporaryDirectory(prefix='ai-rules-a4-discovery-')
        self.addCleanup(temp.cleanup)
        root = Path(temp.name)
        for path, body in files.items():
            p = root / path
            p.parent.mkdir(parents=True, exist_ok=True)
            p.write_text(body, encoding='utf-8')
        return root

    def test_js_ts_preserves_declared_verify_instead_of_rebuilding_tools(self):
        root = self.fixture({'package.json': json.dumps({'packageManager': 'npm@10.0.0', 'scripts': {
            'verify': 'eslint . && tsc --noEmit && vitest run', 'test:unit': 'vitest run unit'}}),
            'tsconfig.json': '{"compilerOptions":{"noEmit":true}}', 'eslint.config.js': 'export default []'})
        inventory = declared_inventory(root)
        self.assertEqual(set(inventory['evidence']), {'JavaScript/TypeScript'})
        self.assertEqual(inventory['routes']['script:verify']['command'], 'npm run verify')
        self.assertEqual(inventory['routes']['script:verify']['body'], 'eslint . && tsc --noEmit && vitest run')
        self.assertEqual(inventory['routes']['script:test:unit']['command'], 'npm run test:unit')
        self.assertNotIn('ready', inventory)
        # Discovery does not run or expand all routes, nor infer installed tools.
        self.assertFalse(any(p.name in {'node_modules', '.agents'} for p in root.iterdir()))
        self.assertIn('focused UI-copy check does not automatically select it', read(REFERENCE))

    def test_python_uses_its_ci_route_without_node_requirements(self):
        root = self.fixture({'pyproject.toml': '[tool.pytest.ini_options]\ntestpaths=["tests"]\n[tool.ruff]\nline-length=88',
            'requirements.txt': 'pytest\nruff', '.github/workflows/check.yml': 'jobs:\n  test:\n    steps:\n      - run: python -m pytest tests\n'})
        result = declared_inventory(root)
        self.assertEqual(set(result['evidence']), {'Python'})
        self.assertEqual(result['routes']['ci:check.yml:0']['command'], 'python -m pytest tests')
        self.assertNotRegex(json.dumps(result), r'ESLint|tsc|npm|process\.env|\.env\.example')

    def test_rust_go_and_dotnet_read_actual_project_routes(self):
        cases = [('Rust', {'Cargo.toml': '[workspace]\nmembers=["app"]'}, 'cargo test --workspace'),
                 ('Go', {'go.mod': 'module example.test/app\ngo 1.22'}, 'go test ./...'),
                 ('.NET', {'App.sln': 'Microsoft Visual Studio Solution File', 'App.csproj': '<Project />'}, 'dotnet test App.sln')]
        for stack, files, command in cases:
            with self.subTest(stack=stack):
                root = self.fixture(dict(files, **{'.github/workflows/check.yml': f'jobs:\n  test:\n    steps:\n      - run: {command}\n'}))
                result = declared_inventory(root)
                self.assertEqual(set(result['evidence']), {stack})
                self.assertEqual(result['routes']['ci:check.yml:0']['command'], command)
                self.assertNotRegex(json.dumps(result), r'ESLint|tsc|npm')

    def test_no_setup_does_not_invent_command_or_toolchain(self):
        root = self.fixture({'README.md': 'No configured verifier.', 'app.txt': 'plain text'})
        self.assertEqual(declared_inventory(root), {'evidence': {}, 'routes': {}})
        text = read(REFERENCE)
        self.assertIn('do not invent a toolchain or install one', text)
        self.assertIn('available direct source/behavior evidence', text)
        self.assertIn('necessary missing evidence as unverified', text)

    def test_ci_without_listed_language_and_mixed_package_scope(self):
        root = self.fixture({'.github/workflows/check.yml': 'jobs:\n  test:\n    steps:\n      - run: make verify\n',
                             'Makefile': 'verify:\n\t./scripts/check.sh\n',
                             'web/package.json': '{"packageManager":"pnpm@9.0.0","scripts":{"verify":"local-check"}}',
                             'service/pyproject.toml': '[tool.pytest.ini_options]'})
        self.assertEqual(declared_inventory(root)['routes']['ci:check.yml:0']['command'], 'make verify')
        self.assertEqual(set(declared_inventory(root / 'web')['evidence']), {'JavaScript/TypeScript'})
        self.assertEqual(set(declared_inventory(root / 'service')['evidence']), {'Python'})

    def test_environment_consistency_is_project_specific(self):
        node = self.fixture({'.env.example': 'API_URL=example', 'app.js': 'process.env.API_URL'})
        python = self.fixture({'settings.py': 'class Settings: endpoint: str', 'config.toml': 'endpoint="example"'})
        self.assertIn('API_URL', (node / '.env.example').read_text())
        self.assertIn('endpoint', (python / 'config.toml').read_text())
        self.assertFalse((python / '.env.example').exists())
        text = read(REFERENCE)
        for concept in ['typed settings', 'config schema', 'secret-manager', 'without exposing secret values',
                        'one possible example, never a requirement']:
            self.assertIn(concept, text)

    def test_conditional_candidates_do_not_set_scope_independence_or_completion(self):
        text = read(REFERENCE)
        for concept in ['Dependency change', 'security-sensitive package issue', 'explicit audit request',
                        'release/security evidence need', 'Relevant typed/compiled boundary',
                        'existing applicable linter/analyzer', 'Selected audit, release readiness, cleanup']:
            self.assertIn(concept, text)
        self.assertIn('ordinary source change or UI-copy fix does not automatically need dependency', text)
        self.assertIn('not automatic verification', text)
        for marker, expected in [('VERIFICATION_SCOPE_TABLE', 'focused'), ('VERIFICATION_INDEPENDENCE_TABLE', 'direct')]:
            block = read('Shared/policies/verification-strategy.md').split(f'<!-- {marker}_START -->')[1].split(f'<!-- {marker}_END -->')[0]
            rows = re.findall(r'^\| ([a-z_]+) \| ([a-z_]+) \|$', block, re.M)
            self.assertEqual(resolve(rows, {'dependency_changed': True, 'lint_config_present': True}), expected)

    def test_declarations_and_absent_binary_are_not_readiness_or_install_authority(self):
        path = 'Shared/policies/capability-resolution.md'
        ready = table(path, '| Predicate (first matching row) | Status |')
        select = table(path, '| Disqualifying fact (first matching row) | Decision |')
        self.assertIsNone(resolve(ready, {'declared': True}))
        self.assertEqual(resolve(ready, {'present': True}), 'present_unverified')
        self.assertEqual(resolve(ready, {'checked_absent': True}), 'unavailable')
        self.assertEqual(resolve(select, {'not_ready': True}), 'inspect_or_alternative')
        self.assertEqual(resolve(select, {'implicit_install_download_init': True}), 'reject_provider')
        text = read(REFERENCE)
        self.assertIn('Never use `npx`', text)
        self.assertIn('do not install, log in', text)
        self.assertIn('Inspect scripts for', text)
        self.assertIn('do not automatically generate a project verification Skill', text)


class A4Preservation(unittest.TestCase):
    def test_exact_identity_and_original_bytes(self):
        records = artifacts('4B2A4')
        self.assertEqual({a['skill'] for a in records}, {'code-audit'})
        self.assertEqual({a['old_relative_path'] for a in records}, {'code-audit/SKILL.md',
            'code-audit/references/scan-task-prompt.md', 'code-audit/references/scan-report-template.md',
            'code-audit/references/tool-command-reference.md'})
        for a in records:
            old = 'Shared/skills/' + a['old_relative_path']
            self.assertFalse((ROOT / old).exists())
            self.assertEqual(hashlib.sha256(historical_bytes(old)).hexdigest(), a['known_versions'][0]['sha256'])
        self.assertNotIn('- Skill: code-audit', read('Shared/skills/_index.md'))
        self.assertFalse(list((ROOT / 'Shared/policies/references/legacy-skills').rglob('SKILL.md')))
        for name in ['project-audit', 'universal-audit', 'smart-audit', 'dynamic-audit']:
            self.assertFalse((ROOT / 'Shared/skills' / name).exists())
        self.assertIn(REFERENCE, read('Shared/policies/verification-strategy.md'))
        self.assertLess(len(read(REFERENCE).splitlines()), 125)

    def test_prior_records_archives_and_other_skills_frozen(self):
        from vnext_source_paths import pre_m5c_mapping_records
        prior = pre_m5c_mapping_records([a for a in artifacts() if a.get('batch', '4B2A1') in {'4B2A1', '4B2A2', '4B2A3'}])
        self.assertEqual(hashlib.sha256(json.dumps(prior, sort_keys=True, separators=(',', ':')).encode()).hexdigest(),
                         'd1fdec067b1c0999678c7d8101a74bb1c42008f19eca11f6a4f3c6cb2137f2f2')
        paths = [ROOT / 'Shared' / a['reference_relative_path'] for a in prior]
        def fingerprint(paths):
            records = sorted(p.relative_to(ROOT).as_posix() + ':' + hashlib.sha256(p.read_bytes()).hexdigest() for p in paths)
            return hashlib.sha256('\n'.join(records).encode()).hexdigest()
        self.assertEqual(fingerprint(paths), 'c8494883ccec21be5f326cb87feca73bd48821ae9bfe4bb70dbb1b1acab455b1')
        # Historical A4 other-Skills aggregate: 2979256c49b32f830d23895e5c60e0b2b86af6ed1a875ef3f8abae01a43a29f3.
        # The A5+ source is legitimately different; keep its sealed original
        # fixture instead of asserting perpetual live-tree equality.
        from vnext_source_paths import assert_sealed_phase_fixture
        assert_sealed_phase_fixture(self, 'a5-preservation-fixture.json')


if __name__ == '__main__':
    unittest.main()
