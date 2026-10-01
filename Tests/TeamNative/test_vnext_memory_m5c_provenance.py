"""Read-only independent verification of historical M5C approval evidence.

Run with python -B. No runtime writes, Git mutation or Cartridge calls.
"""
import base64
import gzip
import collections
import hashlib
import json
from pathlib import Path
import re
import subprocess
import unittest

ROOT = Path(__file__).resolve().parents[2]
MANIFEST = json.loads((ROOT / 'Shared/policies/references/m5c-runtime-provenance.json').read_text(encoding='utf-8-sig'))
ARTIFACT_ROOT = Path(MANIFEST['historical_evidence_root'])
FIXTURE = json.loads((ROOT / 'Tests/TeamNative/m5c-historical-provenance-fixture.json').read_text(encoding='utf-8-sig'))

def sha(data):
    return hashlib.sha256(data).hexdigest()

def norm(data):
    return data.decode('utf-8-sig').replace('\r\n', '\n')

def git_blob(revision, source):
    return subprocess.check_output(['git', '-C', str(ROOT), 'show', revision + ':' + source], stderr=subprocess.DEVNULL)

def flatten(obj, prefix=''):
    if isinstance(obj, dict):
        for key, value in obj.items():
            yield prefix + '/' + key, value
            yield from flatten(value, prefix + '/' + key)
    elif isinstance(obj, list):
        for i, value in enumerate(obj):
            yield from flatten(value, prefix + '/' + str(i))

class HistoricalProvenance(unittest.TestCase):
    def test_all_records_have_non_circular_evidence(self):
        artifacts = {}
        for record in MANIFEST['records']:
            with self.subTest(path=record['path']):
                self.assertIn(record['classification'], ('FRAMEWORK_PROVEN_EXACT', 'FRAMEWORK_PROVEN_COMPATIBLE'))
                data = gzip.decompress(base64.b64decode(FIXTURE['approved_preimages'][record['path']]['gzip_base64']))
                self.assertEqual(sha(data), record['known_sha256'])
                self.assertTrue(record['evidence'])
                for evidence in record['evidence']:
                    kind = evidence['kind']
                    if kind in ('trusted_phase_source_fingerprint', 'preexisting_phase_raw_fingerprint'):
                        path = evidence['artifact']
                        if path not in artifacts:
                            blob = gzip.decompress(base64.b64decode(FIXTURE['historical_artifacts'][path]['gzip_base64']))
                            artifacts[path] = (sha(blob), dict(flatten(json.loads(blob.decode('utf-8-sig')))))
                        digest, fields = artifacts[path]
                        self.assertEqual(digest, evidence['artifact_sha256'])
                        self.assertEqual(fields[evidence['field']], record['known_sha256'])
                        if kind == 'trusted_phase_source_fingerprint':
                            self.assertRegex(evidence['field'], r'/(Shared|Codex|Antigravity)/')
                    else:
                        blob = git_blob(evidence['revision'], evidence['source'])
                        self.assertEqual(sha(blob), evidence['historical_blob_sha256'])
                        if kind == 'immutable_git_projection':
                            projected = norm(blob).encode('utf-8')
                            if evidence['eol'] == 'CRLF':
                                projected = projected.replace(b'\n', b'\r\n')
                            if evidence['bom']:
                                projected = b'\xef\xbb\xbf' + projected
                            self.assertEqual(sha(projected), record['known_sha256'])
                        elif kind == 'immutable_git_body_identity':
                            self.assertEqual(norm(blob), norm(data))
                            self.assertEqual(sha(norm(blob).encode()), evidence['normalized_sha256'])
                        elif kind == 'immutable_git_version_generator':
                            self.assertEqual(sha(blob.decode('utf-8-sig').strip().encode()), record['known_sha256'])
                        elif kind == 'immutable_git_generated_entry':
                            adapter = git_blob(evidence['revision'], evidence['adapter_source'])
                            self.assertEqual(sha(adapter), evidence['adapter_blob_sha256'])
                            pattern = r'(?s)<!-- AI_RULES_SHARED_SUBAGENT_POLICY_START -->.*?<!-- AI_RULES_SHARED_SUBAGENT_POLICY_END -->'
                            self.assertEqual(re.sub(pattern, '', norm(blob)), re.sub(pattern, '', norm(data)))
                            block = re.search(r'(?s)<!--\s*SUBAGENT_POLICY:ANTIGRAVITY_START\s*-->\s*(.*?)\s*<!--\s*SUBAGENT_POLICY:ANTIGRAVITY_END\s*-->', norm(adapter)).group(1).strip()
                            self.assertEqual(re.search(pattern, norm(data)).group(0), '<!-- AI_RULES_SHARED_SUBAGENT_POLICY_START -->\n' + block + '\n<!-- AI_RULES_SHARED_SUBAGENT_POLICY_END -->')
                        else:
                            self.fail('unrecognized provenance evidence: ' + kind)

    def test_58_are_exactly_two_private_surfaces_and_29_identities(self):
        rows = [r for r in MANIFEST['records'] if r['operation'] == 'retire' and '/skills/' in r['path']]
        self.assertEqual(len(rows), 58)
        self.assertEqual(len({r['path'] for r in rows}), 58)
        self.assertEqual(collections.Counter(r['path'].split('/')[0] for r in rows), {'.agents':29, '.claude':29})
        self.assertEqual(len({r['path'].split('/skills/')[1] for r in rows}), 29)
        self.assertEqual(collections.Counter(r['classification'] for r in rows), {'FRAMEWORK_PROVEN_EXACT':48, 'FRAMEWORK_PROVEN_COMPATIBLE':10})

    def test_memory_m3_entries_are_not_reapproved_by_this_manifest(self):
        old = ('team-specialist-memory-docs', 'team-specialist-memory-closure', 'team-memory-docs-delivery-artifact', 'team-memory-closure-delivery-artifact')
        for row in MANIFEST['records']:
            self.assertFalse(any('/' + skill + '/SKILL.md' in row['path'] for skill in old))
        migrations = json.loads((ROOT/'Shared/policies/references/legacy-skill-migration.json').read_text(encoding='utf-8-sig'))
        rows = [r for r in migrations['artifacts'] if r.get('batch') == 'M3']
        self.assertEqual(len(rows), 4)
        self.assertFalse(any('provenance_manifest' in v for r in rows for v in r['known_versions']))

    def test_original_update_cohort_and_three_hooks_are_covered(self):
        paths = MANIFEST['audit_cohorts']['original_existing_updates_113']
        self.assertEqual(len(paths), 113)
        self.assertEqual(len(set(paths)), 113)
        records = {r['path']:r for r in MANIFEST['records']}
        for path in paths:
            self.assertIn(path, records)
            self.assertTrue(records[path]['known_sha256'])
            self.assertTrue(records[path]['historical_owner'])
        self.assertEqual(len(MANIFEST['audit_cohorts']['hook_paths']), 3)

if __name__ == '__main__':
    unittest.main()
