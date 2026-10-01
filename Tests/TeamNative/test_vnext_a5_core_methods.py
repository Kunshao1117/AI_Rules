"""A5 method/source contracts and deterministic local discovery fixtures.

No NLP router, real scanner/compiler, install or persistent project behavior is
implemented here. Projection/loadability is exercised by the PowerShell fixture.
"""
import hashlib
import json
import re
import tempfile
import unittest
from pathlib import Path
import yaml
from vnext_source_paths import ROOT

TARGETS = {'security-sre', 'tech-stack-protocol', 'skill-factory'}
SKILLS = ROOT / 'Shared/skills'
MARKER = b'<!-- PRE_A5_ORIGINAL_START -->\n'


def read(name, relative='SKILL.md'):
    return (SKILLS / name / relative).read_text(encoding='utf-8-sig')


def original_files():
    """Only exact pre-A5 paths; no runtime or active source resolver changes."""
    result = {}
    for name in sorted(TARGETS):
        root = SKILLS / name / 'references/legacy'
        for path in root.rglob('*.md'):
            relative = path.relative_to(root).as_posix()
            if relative == 'pre-a5-entry.md':
                relative = 'SKILL.md'
            result['Shared/skills/' + name + '/' + relative] = path.read_bytes().split(MARKER, 1)[1]
    return result


def pre_a5_skill_records():
    # Keep A3/A4 original content oracles instead of weakening their frozen hash.
    from test_vnext_a6_browser_methods import pre_a6_shared_records
    records = [r for r in pre_a6_shared_records(TARGETS) if r.startswith('Shared/skills/')]
    records += [path + ':' + hashlib.sha256(data).hexdigest() for path, data in original_files().items()]
    return records


def admission(facts):
    text = read('skill-factory').split('| Admission fact (first matching row) | Recommendation |')[1].split('\n\n')[0]
    rows = re.findall(r'^\| ([a-z_]+(?: & [a-z_]+)*) \| ([a-z_]+) \|$', text, re.M)
    for fact, result in rows:
        if all(term == 'otherwise' or facts.get(term) is True for term in fact.split(' & ')):
            return result


class A5Methods(unittest.TestCase):
    def test_complete_original_archive_and_frozen_owners(self):
        fixture = json.loads((ROOT / 'Tests/TeamNative/a5-preservation-fixture.json').read_text())
        originals = original_files()
        self.assertEqual(set(originals), set(fixture['original_files']))
        for path, expected in fixture['original_files'].items():
            self.assertEqual(hashlib.sha256(originals[path]).hexdigest(), expected, path)
        from vnext_source_paths import assert_sealed_phase_fixture
        # The aggregate is an A5-at-the-time record; later approved phases
        # changed Shared. Preserve its fixture and the original method bytes.
        assert_sealed_phase_fixture(self, 'a5-preservation-fixture.json')
        self.assertRegex(fixture['protected_shared_sha256'], r'^[0-9a-f]{64}$')
        # The sealed phase fixture preserves the historical Cartridge hash.
        # Today's independent plugin state is neither formal source nor a
        # dependency of this archive contract; deployment sentinels test isolation.

    def fixture(self, files):
        temp = tempfile.TemporaryDirectory(prefix='a5-method-case-')
        self.addCleanup(temp.cleanup)
        root = Path(temp.name)
        for name, content in files.items():
            path = root / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(content, encoding='utf-8')
        return root

    def test_three_metadata_entries_remain_narrow_and_unique(self):
        index = (SKILLS / '_index.md').read_text(encoding='utf-8')
        entries = re.findall(r'^- Skill: (.+)$', index, re.M)
        self.assertEqual(len(entries), len(set(entries)))
        for name in TARGETS:
            with self.subTest(name=name):
                text = read(name)
                meta = yaml.safe_load(text.split('---', 2)[1])
                self.assertEqual(meta['name'], name)
                self.assertEqual(meta['metadata']['memory_awareness'], 'none')
                self.assertEqual(set(meta), {'name', 'description', 'metadata'})
                self.assertEqual(entries.count(name), 1)
                self.assertLess(len(meta['description']), 1024)
                for part in [meta['description'], *re.split('Use when:|DO NOT use when:', meta['description'])[1:]]:
                    self.assertRegex(part.strip()[0], '[\u4e00-\u9fff]')
                self.assertIn('DO NOT use when:', meta['description'])
                self.assertNotIn('required_skills', meta)
                self.assertFalse(list((SKILLS / name / 'references').rglob('SKILL.md')))
                self.assertLess(len(text.splitlines()), 150)
                self.assertIn('Invocation classification:', text)
                # Every active reference chosen by the entry exists.
                for ref in re.findall(r'(?<!/)references/[\w/-]+\.md', text):
                    self.assertTrue((SKILLS / name / ref).is_file(), ref)
        self.assertIn('Invocation classification: manual_only', read('skill-factory'))
        security_index = index.split('## 25. security-sre')[1].split('\n## ')[0]
        self.assertNotIn('MCP Server: snyk', security_index)
        self.assertNotIn('self-extend', index.split('## 44. skill-factory')[1].split('\n## ')[0])

    def test_security_project_native_boundary_examples_across_stacks(self):
        examples = read('security-sre', 'references/boundary-and-failure-methods.md')
        cases = [
            ('TypeScript API', 'route.ts', 'parseRequest(request.body)', 'runtime parser'),
            ('Python API', 'view.py', 'serializer.is_valid(raise_exception=True)', 'serializer'),
            ('Rust service', 'main.rs', 'parse_and_validate_domain(input)', 'domain invariants'),
            ('Go service', 'main.go', 'decodeAndValidate(request)', 'domain constraints'),
            ('.NET API', 'Controller.cs', 'ValidateBoundRequest(request)', 'validation pipeline')]
        for stack, path, content, concept in cases:
            with self.subTest(stack=stack):
                root = self.fixture({path: content})
                row = next(line for line in examples.splitlines() if line.startswith('| ' + stack + ' |'))
                self.assertIn(concept, row)
                self.assertEqual((root / path).read_text(), content)
                self.assertNotRegex(row, r'(?:require|must use) (?:Zod|Joi)')
        skill = read('security-sre')
        self.assertIn('actual runtime boundary', skill)
        self.assertIn('static type assertion is not runtime validation', skill)
        self.assertIn('Do not require Zod/Joi', skill)

    def test_security_plain_text_observation_and_secret_contract(self):
        root = self.fixture({'app.log': 'request=42 operation=save failed timeout\n',
                             'settings.toml': 'credential_ref="application-secret-reference"'})
        observation = (root / 'app.log').read_text()
        self.assertIn('request=42', observation)
        self.assertIn('failed timeout', observation)
        with self.assertRaises(json.JSONDecodeError):
            json.loads(observation)
        examples = read('security-sre', 'references/boundary-and-failure-methods.md')
        self.assertIn('text log with useful correlation can suffice', examples)
        skill = read('security-sre')
        for method in ['Never hard-code secrets', 'unnecessary model', 'logs, errors or',
                       'least', 'user-facing failure', 'silently swallow', 'idempotency',
                       'rollback and recovery', 'uncertain external mutations']:
            self.assertIn(method, skill)
        self.assertNotRegex(skill, r'MUST.*(?:JSON|Winston|Pino|process.env|error.log|\+08:00)')

    def test_security_positive_auth_and_negative_copy_metadata(self):
        description = yaml.safe_load(read('security-sre').split('---', 2)[1])['description']
        positive, negative = description.split('Use when:', 1)[1].split('DO NOT use when:')
        self.assertIn('認證授權邊界', positive)
        self.assertIn('前端文案', negative)
        self.assertIn('一般欄位格式', negative)
        self.assertIn('A Skill match does not spawn anyone', read('security-sre'))

    def test_lazy_scoped_discovery_python_typescript_mixed_and_no_manifest(self):
        from test_vnext_a4_project_derived import declared_inventory
        root = self.fixture({'web/package.json': '{"scripts":{"verify":"local-check"}}',
                             'web/tsconfig.json': '{}',
                             'api/pyproject.toml': '[project]\nrequires-python=">=3.10"',
                             'plain/app.py': 'from application import service'})
        self.assertEqual(set(declared_inventory(root / 'web')['evidence']), {'JavaScript/TypeScript'})
        self.assertEqual(set(declared_inventory(root / 'api')['evidence']), {'Python'})
        self.assertEqual(declared_inventory(root / 'plain'), {'evidence': {}, 'routes': {}})
        self.assertTrue((root / 'plain/app.py').read_text().startswith('from application'))
        skill = read('tech-stack-protocol')
        for concept in ['only the affected', 'scoped source/config', 'instead of trying every language',
                        'Only if execution/version evidence is needed', 'do not probe unrelated languages']:
            self.assertIn(concept, skill)
        self.assertNotRegex(skill, r'Run `node -v`|Get-CimInstance|uname')

    def test_locked_project_version_and_session_absence_do_not_mutate_facts(self):
        root = self.fixture({'package.json': '{"dependencies":{"example-framework":"2.4.0"}}'})
        before = (root / 'package.json').read_bytes()
        declared = json.loads(before)['dependencies']['example-framework']
        session = {'present': False, 'ready': False}
        self.assertEqual(declared, '2.4.0')
        self.assertFalse(session['ready'])
        self.assertEqual((root / 'package.json').read_bytes(), before)
        skill = read('tech-stack-protocol')
        for concept in ['Session readiness is not part of the long-term project matrix',
                        'does not authorize installation', 'Do not upgrade to latest',
                        'Do not automatically persist', 'does not read or write Memory as a prerequisite']:
            self.assertIn(concept.lower(), skill.lower())

    def test_factory_prevention_order_all_rejection_cases(self):
        cases = [('ordinary_model_knowledge', 'no_skill'), ('policy_responsibility', 'existing_policy'),
                 ('workflow_sequence', 'existing_workflow'), ('agent_identity', 'existing_agent'),
                 ('reference_only', 'reference'), ('existing_skill_extension', 'extend_reference'),
                 ('provider_syntax_only', 'pack_reference'), ('one_off_task', 'no_skill'),
                 ('lacks_specialized_reusable_method', 'no_skill'), ('lacks_real_demand_or_value', 'no_skill')]
        for fact, expected in cases:
            self.assertEqual(admission({fact: True}), expected)
        self.assertEqual(admission({'policy_responsibility': True, 'existing_skill_extension': True}), 'existing_policy')
        self.assertEqual(admission({'existing_skill_extension': True, 'provider_syntax_only': True}), 'extend_reference')
        # A repeated specialized method with real value and no earlier owner only
        # earns a candidate, never automatic registry activation.
        self.assertEqual(admission({'specialized_reusable_method': True, 'real_demand_or_value': True,
                                    'owner_search_complete': True}), 'candidate')
        self.assertEqual(admission({}), 'no_skill')
        self.assertEqual(admission({'specialized_reusable_method': True}), 'no_skill')

    def test_no_self_proliferation_and_release_is_workflow(self):
        skill = read('skill-factory')
        for evidence in ['loaded_factory', 'noticed_technique', 'two_hypothetical_uses']:
            self.assertEqual(admission({evidence: True}), 'no_skill')
        self.assertEqual(admission({'workflow_sequence': True, 'release_automation': True}), 'existing_workflow')
        for concept in ['outside every loader/discovery root', 'syntax tables alone',
                        'candidate', 'approval']:
            self.assertIn(concept, skill + read('skill-factory', 'references/skill-template.md'))
        for forbidden in ['New-Item -ItemType SymbolicLink', 'notify_user', 'Auto-inject',
                          '2+ future scenarios', 'dispatch wave', 'role_instance', 'completion bundle']:
            for path in (SKILLS / 'skill-factory').rglob('*.md'):
                if 'legacy' not in path.parts:
                    self.assertNotIn(forbidden, path.read_text(encoding='utf-8'), path)

    def test_ownership_and_provider_boundaries_without_persistence(self):
        for name in TARGETS:
            text = read(name)
            self.assertIn('capability-resolution.md', text)
            self.assertIn('authorization-resolution.md', text)
            self.assertIn('Provider-specific: no', text)
            self.assertNotIn('mcp:cartridge-system', text)
            self.assertNotIn('Captain Board', text)
        factory = read('skill-factory')
        self.assertIn('Shared/skill-governance.md', factory)
        self.assertIn('canonical architecture taxonomy owner', factory)
        self.assertIn('Memory availability is not required', factory)
        self.assertIn('Existing Memory/Project Context contracts remain frozen', read('tech-stack-protocol'))


if __name__ == '__main__':
    unittest.main()
