"""Historical source/archive resolution and sealed phase-fixture integrity.

Old aggregate hashes described a prior phase, not an invariant on future
authorized source. Full intermediate Shared trees were not archived, so a
fixture-integrity check does not pretend to rerun those old byte aggregates.
Current inventory and canonical behavior have separate current-source tests.
"""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
MANIFEST = ROOT / 'Shared/policies/references/legacy-skill-migration.json'
M3_RETIRED = {
    'team-specialist-memory-docs', 'team-memory-docs-delivery-artifact',
    'team-specialist-memory-closure', 'team-memory-closure-delivery-artifact',
}
SEALED_PHASE_FIXTURES = {
    'a5-preservation-fixture.json': 'd946cfc7facd8945e8ba53f65eb6e72cc4dc8b8bf2cc52c0a0589d9dbbd47ef6',
    'a6-preservation-fixture.json': '4ed0e391f1d5c6f40e81f8897dfcf16608eaab6d9e7d92658a85566cfa2560f0',
    'a7-preservation-fixture.json': 'fe588a8c8a82c6c7b874732aa58f46a1bd6c8c165006894ecb52e2857445eca6',
    'a8-preservation-fixture.json': '4575124a5ee572da75c2e881568ed0cea40481be817d17d80dcc5756be2c0d3f',
    'a10-originals-fixture.json': '25ca0e5a0bfec5810aacb68f6dceeb0d6c511ce6c456804d2b431fa95a265dee',
    'a11-originals-fixture.json': 'e3a5523e0c541ec02eac730a22660e495085d99747286f94cbed6b908ff16537',
    'a12-originals-fixture.json': '35d6c31b6ff5f04d72a70a003f9b635e9278a80a59b38073078e71c5b9cdae27',
    'a13-originals-fixture.json': 'e28c31049e6da5368373740af40180c3ce8f85a7bd972e6d54ffb23583b29bdf',
}


def assert_sealed_phase_fixture(testcase, filename):
    path = ROOT / 'Tests/TeamNative' / filename
    testcase.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(),
                         SEALED_PHASE_FIXTURES[filename], filename)


def artifacts(batch=None):
    records = json.loads(MANIFEST.read_text(encoding='utf-8'))['artifacts']
    return [a for a in records if batch is None or a.get('batch', '4B2A1') == batch]


def pre_m5c_mapping_records(records):
    """Keep historical sealed invariants while separately testing new approvals.

    M5C is authorized to append independently proven known_versions. Never
    refresh historical digest constants or strip original record fields.
    """
    proof = json.loads((ROOT / 'Shared/policies/references/m5c-runtime-provenance.json').read_text(encoding='utf-8-sig'))
    approved = {r['path']: r for r in proof['records']}
    result = []
    for record in records:
        clone = dict(record)
        kept = []
        for version in record['known_versions']:
            if version.get('provenance_manifest') == 'm5c-runtime-provenance.json':
                row = approved['.agents/skills/' + record['old_relative_path']]
                assert version['sha256'] == row['known_sha256']
                assert version['classification'] == row['classification']
                assert version['historical_evidence'] == row['evidence']
                assert row['classification'] in ('FRAMEWORK_PROVEN_EXACT', 'FRAMEWORK_PROVEN_COMPATIBLE')
            else:
                kept.append(version)
        clone['known_versions'] = kept
        result.append(clone)
    return result


def historical_path(relative):
    mapping = {'Shared/skills/' + a['old_relative_path']:
               ROOT / 'Shared' / a.get('archive_relative_path', a['reference_relative_path'])
               for a in artifacts()}
    return mapping.get(relative, ROOT / relative)


def historical_source(relative):
    text = historical_path(relative).read_text(encoding='utf-8-sig')
    marker = '<!-- ARCHIVED_SKILL_BODY_START -->\n'
    return text.split(marker, 1)[1].lstrip('\ufeff') if marker in text else text


def historical_bytes(relative):
    data = historical_path(relative).read_bytes()
    marker = b'<!-- ARCHIVED_SKILL_BODY_START -->\n'
    return data.split(marker, 1)[1] if marker in data else data
