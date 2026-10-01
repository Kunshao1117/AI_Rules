"""A1 active identity and preservation contracts; fixture projection is in Pester."""
import hashlib
import json
import re
import subprocess
import unittest
from pathlib import Path
import yaml
from vnext_source_paths import ROOT, artifacts, historical_path, historical_bytes, historical_source, M3_RETIRED

TARGETS = set('delegation-strategy programming-team-governance team-role-boundaries team-completion-gate ai-dev-quality-gate intent-alignment-gate quality-review-governance team-specialist-registry team-specialist-intent-requirements team-specialist-scope-impact team-specialist-architecture-contract team-specialist-change-delivery team-specialist-external-research team-specialist-review team-specialist-security-reliability team-specialist-validation'.split())
MEMORY = set('memory-ops memory-arch team-specialist-memory-closure team-specialist-memory-docs team-memory-closure-delivery-artifact team-memory-docs-delivery-artifact'.split())
ROLES = {'architecture-contract': 'architect', 'change-delivery': 'implementer',
         'external-research': 'researcher', 'review': 'reviewer',
         'security-reliability': 'security-reviewer', 'validation': 'verifier'}


def read(relative):
    return (ROOT / relative).read_text(encoding='utf-8-sig')


class A1Migration(unittest.TestCase):
    def test_checkout_approvals_are_exact_immutable_git_bytes(self):
        manifest = json.loads((ROOT / 'Shared/policies/references/legacy-skill-migration.json').read_text(encoding='utf-8'))
        rows = manifest['approved_checkout_representations']
        self.assertEqual({r['old_relative_path'] for r in rows}, {a['old_relative_path'] for a in manifest['artifacts']})
        self.assertEqual(len(rows), len(manifest['artifacts']))
        for row in rows:
            with self.subTest(path=row['source']):
                self.assertEqual(row['source'], 'Shared/skills/' + row['old_relative_path'])
                self.assertRegex(row['revision'], r'^[0-9a-f]{40}$')
                identity = row['revision'] + ':' + row['source']
                data = subprocess.check_output(['git', '-C', str(ROOT), 'show', identity])
                oid = subprocess.check_output(['git', '-C', str(ROOT), 'rev-parse', identity]).decode().strip()
                self.assertEqual(oid, row['git_blob_oid'])
                self.assertEqual(hashlib.sha256(data).hexdigest(), row['git_blob_sha256'])
                data.decode('utf-8', errors='strict')
                self.assertNotIn(b'\r', data)
                self.assertEqual(row['encoding'], 'UTF-8')
                self.assertEqual(row['bom'], data.startswith(b'\xef\xbb\xbf'))
                self.assertEqual(row['terminal_newline'], data.endswith(b'\n'))
                self.assertEqual(row['representations'], {
                    'git_blob': hashlib.sha256(data).hexdigest(),
                    'LF': hashlib.sha256(data).hexdigest(),
                    'CRLF': hashlib.sha256(data.replace(b'\n', b'\r\n')).hexdigest(),
                })

    def test_frozen_memory_and_context_bytes_match_pre_a1(self):
        # Historical pre-A1 aggregate: 066b7c54b542c544ad2d94473b90a4959d346fe7e46cacb81ba2b04c754eb35c.
        # It cannot be rerun against M1/M2/M3 source. Check every retired M3
        # original against its proven pre-M3 hash instead; current semantics
        # are covered by dedicated M1/M2/M3 tests.
        for artifact in artifacts('M3'):
            relative = 'Shared/skills/' + artifact['old_relative_path']
            self.assertEqual(hashlib.sha256(historical_bytes(relative)).hexdigest(),
                             artifact['known_versions'][0]['sha256'])
        self.assertTrue(historical_path('Shared/skills/project-context-protocol/SKILL.md').is_file())
        self.assertTrue((ROOT / 'Shared/policies/references/memory-closure-bundle-contract.md').is_file())

    def test_exact_batch_and_no_discoverable_archived_entries(self):
        self.assertEqual({a['skill'] for a in artifacts('4B2A1')}, TARGETS)
        physical = {p.parent.name for p in (ROOT / 'Shared/skills').glob('*/SKILL.md')}
        active = set(re.findall(r'^- Skill: (.+)$', read('Shared/skills/_index.md'), re.M))
        self.assertFalse(TARGETS & physical)
        self.assertFalse(TARGETS & active)
        self.assertEqual(physical - active, set())
        self.assertFalse(list((ROOT / 'Shared/policies/references/legacy-skills').rglob('SKILL.md')))
        self.assertEqual(MEMORY - M3_RETIRED, MEMORY & physical)
        self.assertFalse(M3_RETIRED & physical)

    def test_every_archived_original_byte_and_asset_is_preserved(self):
        for a in artifacts('4B2A1'):
            self.assertNotIn(a['skill'], MEMORY)
            data = (ROOT / 'Shared' / a['reference_relative_path']).read_bytes()
            if a['old_relative_path'].endswith('/SKILL.md'):
                self.assertIn(b'not an invocable Skill', data)
                data = data.split(b'<!-- ARCHIVED_SKILL_BODY_START -->\n', 1)[1]
            self.assertEqual(hashlib.sha256(data).hexdigest(), a['known_versions'][0]['sha256'])
            self.assertTrue(all(v['provenance'] for v in a['known_versions']))

    def test_other_batches_remain_physical_and_active(self):
        active = set(re.findall(r'^- Skill: (.+)$', read('Shared/skills/_index.md'), re.M))
        for name in ['code-quality','ui-ux-standards','project-context-protocol','plugin-release-governance',
                     'ui-design-exploration','team-specialist-git-checkpoint','team-specialist-release-completion',
                     'structured-reasoning','code-diagnosis','code-audit','browser-testing','security-sre',
                     'tech-stack-protocol','skill-factory','test-patterns','test-automation-strategy',
                     'impact-test-strategy','a11y-testing','performance-audit','gitnexus-cli','gitnexus-guide',
                     'gitnexus-exploring','gitnexus-debugging','gitnexus-impact-analysis','gitnexus-refactoring',
                     'supabase','supabase-ops','supabase-postgres-best-practices','github-ops','cloudflare-ops',
                     'sentry-ops','trunk-ops','maps-assist','excel-ops','stitch-design','context7-docs']:
            if name in {a['skill'] for batch in ['4B2A2', '4B2A3', '4B2A4', '4B2A7'] for a in artifacts(batch)}:
                self.assertNotIn(name, active)
                self.assertTrue(historical_path(f'Shared/skills/{name}/SKILL.md').is_file())
            else:
                self.assertIn(name, active)
                self.assertTrue((ROOT / f'Shared/skills/{name}/SKILL.md').is_file())

    def test_six_agents_have_thin_provider_neutral_methods(self):
        methods = read('Shared/agents/references/role-methods.md')
        for old, role in ROLES.items():
            text = read(f'Shared/agents/{role}.md')
            data = yaml.safe_load(text.split('---', 2)[1])
            self.assertIn('Shared/agents/references/role-methods.md#', text)
            self.assertLess(len(text.splitlines()), 35)
            self.assertFalse({'model', 'station_mode', 'role_instance_id'} & data.keys())
            self.assertNotRegex(' '.join(data['required_capabilities']), r'(?i)github|supabase|codex|claude|mcp|gpt-')
            self.assertIn('## ' + data['name'], methods)
            self.assertTrue(historical_path(f'Shared/skills/team-specialist-{old}/SKILL.md').is_file())
        self.assertNotRegex(methods, r'\[SUDO\]|formal-write|station_mode|role_instance_id|gpt-')

    def test_active_method_owners_preserve_the_unique_work(self):
        task = read('Shared/policies/references/task-assignment-methods.md')
        for concept in ['Requirement replay', 'non-goals', 'acceptance', 'contradictions',
                        'inference', 'tradeoffs', 'Scope and impact', 'regression', 'Bounded assignment']:
            self.assertIn(concept, task)
        roles = read('Shared/agents/references/role-methods.md')
        for concept in ['fallback', 'current diff', 'publication/version', 'checked-at',
                        'speculative abstraction', 'availability', 'observability', 'reproduction']:
            self.assertIn(concept, roles)
        visual = read('Shared/policies/references/workflow-review-visual-evidence.md')
        for concept in ['Component reuse', 'new primitive', 'Generated', 'terminal wrapping', 'font']:
            self.assertIn(concept, visual)

    def test_canonical_decision_owners_remain_present_and_not_in_archive(self):
        for owner in ['execution-routing','authorization-resolution','capability-resolution','agent-governance',
                      'model-profile-routing','verification-strategy','review-governance','completion-policy']:
            self.assertTrue((ROOT / f'Shared/policies/{owner}.md').is_file())
        review = read('Shared/policies/review-governance.md')
        self.assertNotIn('retained `quality-review-governance` Skill supplies', review)
        self.assertIn('Shared/agents/references/role-methods.md#reviewer', review)
        self.assertIn('task-assignment-methods.md', read('Shared/policies/requirement-precision.md'))

    def test_no_platform_required_skill_reintroduces_a1_identity(self):
        for platform in ['Codex','Claude','Antigravity','Cursor']:
            for p in (ROOT/platform).rglob('*.md'):
                text=p.read_text(encoding='utf-8-sig')
                if not text.startswith('---\n'):continue
                # Some unrelated legacy descriptions are not valid YAML. Parse
                # the actual required_skills field without repairing that data.
                header=text.split('---',2)[1]
                match=re.search(r'^required_skills:[^\n]*(?:\n[ \t]+-[^\n]*)*',header,re.M)
                if not match:continue
                data=yaml.safe_load(match[0]) or {}
                self.assertFalse(TARGETS & set(data.get('required_skills') or []), str(p))

    def test_alias_lookup_is_consumed_by_shared_loading_and_handoff(self):
        for path in ['Shared/skill-governance.md', 'Shared/skills/team-station-handoff-packet/references/packet-schema-and-routing.md']:
            text=historical_path(path).read_text(encoding='utf-8-sig')
            self.assertIn('legacy-skill-migration.md', text)
            self.assertIn('loaded_skill_refs', text)
        for name in ['team-specialist-memory-docs','team-specialist-memory-closure']:
            text=historical_source(f'Shared/skills/{name}/SKILL.md')
            self.assertIn('team-role-boundaries', text)
            self.assertNotIn('legacy-skill-migration', text)


if __name__ == '__main__':
    unittest.main()
