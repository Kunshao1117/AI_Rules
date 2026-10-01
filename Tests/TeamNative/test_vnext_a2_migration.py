"""A2 source contracts. Runtime retirement/rollback is exercised in Pester."""
import hashlib
import json
import re
import unittest
import yaml
from vnext_source_paths import ROOT, artifacts, historical_bytes, historical_source, M3_RETIRED
from test_vnext_skill_classification import parse_map, MEMORY

POLICIES = {'code-quality', 'ui-ux-standards', 'project-context-protocol'}
WORKFLOWS = {'plugin-release-governance': 'plugin-release',
             'team-specialist-git-checkpoint': 'git-checkpoint',
             'team-specialist-release-completion': 'release-readiness',
             'ui-design-exploration': 'ui-design-exploration'}
REFERENCES = {'team-change-delivery-artifact', 'team-review-delivery-artifact',
              'team-validation-delivery-artifact', 'team-task-board', 'team-station-handoff-packet'}
TARGETS = POLICIES | WORKFLOWS.keys() | REFERENCES
EXCLUDED = {'gitnexus-guide'}  # Excluded from A2; independently migrated by A7.


def read(relative):
    return (ROOT / relative).read_text(encoding='utf-8-sig')


def digest_records(paths):
    records = sorted(p.relative_to(ROOT).as_posix() + ':' + hashlib.sha256(p.read_bytes()).hexdigest()
                     for p in paths)
    return hashlib.sha256('\n'.join(records).encode()).hexdigest()


def sections(text):
    return {m[1]: m[0].strip() for m in re.finditer(r'^## ([^\n]+)\n.*?(?=^## |\Z)', text, re.M | re.S)}


class A2Migration(unittest.TestCase):
    def test_candidate_denominator_from_frozen_census_and_explicit_boundary(self):
        rows = parse_map(read('Shared/policies/references/skill-architecture-disposition.md'))
        a1 = {a['skill'] for a in artifacts('4B2A1')}
        candidates = {r['skill'] for r in rows if r['disposition'] in
                      {'MOVE_TO_POLICY', 'MOVE_TO_WORKFLOW', 'MOVE_TO_REFERENCE'}} - a1
        self.assertEqual(candidates, TARGETS | EXCLUDED)
        self.assertEqual({a['skill'] for a in artifacts('4B2A2')}, TARGETS)
        physical = {p.parent.name for p in (ROOT / 'Shared/skills').glob('*/SKILL.md')}
        active_list = re.findall(r'^- Skill: (.+)$', read('Shared/skills/_index.md'), re.M)
        active = set(active_list)
        self.assertEqual(len(active), len(active_list))
        self.assertFalse(TARGETS & (physical | active))
        later_retired = {a['skill'] for batch in ['4B2A3', '4B2A4', '4B2A7'] for a in artifacts(batch)}
        self.assertEqual({r['skill'] for r in rows}, physical | a1 | TARGETS | later_retired | M3_RETIRED)
        self.assertEqual(physical - active, set())
        self.assertEqual(EXCLUDED, {a['skill'] for a in artifacts('4B2A7')})
        self.assertFalse(EXCLUDED & active)

    def test_a1_records_and_archive_bytes_unchanged(self):
        from vnext_source_paths import pre_m5c_mapping_records
        serialized = json.dumps(pre_m5c_mapping_records(artifacts('4B2A1')), sort_keys=True, separators=(',', ':')).encode()
        self.assertEqual(hashlib.sha256(serialized).hexdigest(),
                         'f148669dce787c6cca167f2acf1fbdde4a3981df7ed65b056f54ed3e47a0d720')
        paths = [ROOT / 'Shared' / a['reference_relative_path'] for a in artifacts('4B2A1')]
        self.assertEqual(digest_records(paths),
                         'ae753cf67ca8d010511c515c793f97fdb3baca9323192e22dc892c6c8ce99477')

    def test_all_moved_bytes_and_exact_aliases_preserved(self):
        aliases = [a['old_relative_path'] for a in artifacts()]
        self.assertEqual(len(aliases), len(set(aliases)))
        for a in artifacts('4B2A2'):
            old = 'Shared/skills/' + a['old_relative_path']
            self.assertFalse((ROOT / old).exists())
            self.assertEqual(hashlib.sha256(historical_bytes(old)).hexdigest(), a['known_versions'][0]['sha256'])
            if old.endswith('/SKILL.md'):
                self.assertIn('not an active Skill', read('Shared/' + a['reference_relative_path']))
            self.assertTrue(all(v['provenance'] for v in a['known_versions']))
        self.assertFalse(list((ROOT / 'Shared/policies/references/legacy-skills').rglob('SKILL.md')))

    def test_memory_entire_subtrees_and_bundle_frozen(self):
        # Historical A2 aggregate: 06f7cac56b90f091894a92b326e103bbeadcc7c156c78322e5652709279308c7.
        # M2 changed method Skills and M3 retired four Team entries. Keep the
        # proven originals and test the current frozen bundle separately.
        for artifact in artifacts('M3'):
            old = 'Shared/skills/' + artifact['old_relative_path']
            self.assertEqual(hashlib.sha256(historical_bytes(old)).hexdigest(),
                             artifact['known_versions'][0]['sha256'])
        self.assertIn('candidate_phase_map', read('Shared/policies/references/memory-closure-bundle-contract.md'))

    def test_context_persistence_approval_and_precedence_clauses_unchanged(self):
        old = sections(historical_source('Shared/skills/project-context-protocol/SKILL.md'))
        new = sections(read('Shared/policies/project-context-protocol.md'))
        # Exact A2 clauses are historical; M1 later aligned the canonical
        # Context/Memory boundary. Preserve the archived original and assert
        # current approval/precedence clauses through the current owner.
        for name in ['Purpose', 'Layer Boundary', 'Read Priority', 'Write Approval',
                     'Candidate Handling', 'Promotion to Project Skill']:
            self.assertIn(name, old)
            self.assertIn(name, new)
        self.assertIn('GO CONTEXT', read('Shared/policies/project-context-protocol.md'))
        self.assertIn('authorization-resolution.md', read('Shared/policies/project-context-protocol.md'))
        fmt = sections(read('Shared/policies/references/project-context-format.md'))
        for name in ['Card Format', 'Report Contract']:
            self.assertEqual(old[name].replace('`references/context-template.md`',
                                              '`Shared/policies/references/context-template.md`'), fmt[name])
        # The archive has a raw-byte contract; the active template is ordinary
        # UTF-8 source under Git's existing EOL policy. Compare its exact text
        # while the separate archive test retains the original raw hash.
        original = historical_bytes('Shared/skills/project-context-protocol/references/context-template.md')
        self.assertEqual(original.decode('utf-8').replace('\r\n', '\n'),
                         (ROOT / 'Shared/policies/references/context-template.md').read_text(encoding='utf-8'))

    def test_policy_and_workflow_owners_are_not_skill_entries(self):
        paths = [f'Shared/policies/{name}.md' for name in POLICIES]
        paths += [f'Shared/workflows/{name}.md' for name in WORKFLOWS.values()]
        for path in paths:
            text = read(path)
            self.assertLess(len(text.splitlines()), 160, path)
            self.assertFalse(text.startswith('---'), path)
            self.assertNotRegex(text, r'(?m)^(required_skills|trigger|description|name):')
        for name in ['code-quality', 'ui-ux-standards']:
            text = read(f'Shared/policies/{name}.md')
            self.assertIn('review-governance', text)
            self.assertIn('completion-policy', text)
        for name in WORKFLOWS.values():
            text = read(f'Shared/workflows/{name}.md')
            self.assertRegex(text.lower(), 'authoriz')
            self.assertRegex(text.lower(), 'completion')
        self.assertIn('manual-only', read('Shared/workflows/plugin-release.md'))

    def test_preserved_method_owners_cover_a2_specific_work(self):
        checks = {
            'Shared/policies/references/code-quality-methods.md': ['SOLID', 'composition'],
            'Shared/policies/references/ui-ux-methods.md': ['terminal', 'density'],
            'Shared/workflows/ui-design-exploration.md': ['project state', 'references', 'primitives', 'candidate DNA'],
            'Shared/workflows/plugin-release.md': ['VSIX', 'version tag', 'update-reminder', 'Marketplace'],
            'Shared/workflows/git-checkpoint.md': ['stage', 'exact', 'mismatch', 'receipt'],
            'Shared/workflows/release-readiness.md': ['evidence', 'published', 'deployed', 'Memory'],
        }
        for path, concepts in checks.items():
            for concept in concepts:
                self.assertIn(concept.lower(), read(path).lower(), path)

    def test_no_platform_required_skill_reintroduces_a2(self):
        for platform in ['Codex', 'Claude', 'Antigravity', 'Cursor']:
            for path in (ROOT / platform).rglob('*.md'):
                text = path.read_text(encoding='utf-8-sig')
                if not text.startswith('---\n'):
                    continue
                match = re.search(r'^required_skills:[^\n]*(?:\n[ \t]+-[^\n]*)*', text.split('---', 2)[1], re.M)
                if match:
                    self.assertFalse(TARGETS & set((yaml.safe_load(match[0]) or {}).get('required_skills') or []), str(path))

    def test_active_factory_and_review_consumers_do_not_restore_archived_gate(self):
        factory = read('Shared/skills/skill-factory/SKILL.md')
        self.assertNotIn('Auto-inject Risk-Closure Request & Sandbox Detection template', factory)
        self.assertNotIn('legacy-skills/code-quality/REFERENCE.md', factory)
        for path in ['Shared/policies/authorization-resolution.md',
                     'Shared/workflow-stage-procedures.md', 'Shared/policies/completion-policy.md']:
            self.assertIn(path, factory)
            self.assertTrue((ROOT / path).is_file())
        review = read('Shared/skills/pr-review-ops/SKILL.md')
        self.assertNotIn('`Shared/policies/code-quality.md` thresholds', review)
        self.assertIn('`Shared/policies/source-document-size-governance.md` thresholds', review)


if __name__ == '__main__':
    unittest.main()
