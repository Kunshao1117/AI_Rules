"""A13 source contracts, exhaustive classification and canonical decision fixtures.

This is test-only census data, not a runtime pack registry or an NLP router.
Scenario facts exercise existing policy tables, not provider calls or a new engine.
Original bytes reconstruct earlier phase boundaries without changing their oracles.
"""
import base64
import hashlib
import json
import re
import unittest
import yaml
from vnext_source_paths import ROOT, M3_RETIRED
from test_vnext_a3_retirement import table, resolve

MAPS = 'Shared/skills/maps-assist/SKILL.md'
GUIDE = 'Shared/policies/references/maps-guide.md'
INDEX = 'Shared/skills/_index.md'
PATTERN = rb'## \d+\. maps-assist\r?\n.*?(?=## |\Z)'
PACKS = {
    'GitNexus': {'gitnexus-cli', 'gitnexus-debugging', 'gitnexus-exploring',
                'gitnexus-impact-analysis', 'gitnexus-refactoring'},
    'Supabase': {'supabase', 'supabase-ops', 'supabase-postgres-best-practices'},
    'Trunk': {'trunk-ops'}, 'Excel': {'excel-ops'}, 'Context7': {'context7-docs'},
    'GitHub': {'github-ops', 'pr-review-ops'}, 'Cloudflare': {'cloudflare-ops'},
    'Sentry': {'sentry-ops'}, 'Stitch': {'stitch-design'}, 'Maps': {'maps-assist'}}
CORE = {'browser-testing', 'security-sre', 'test-automation-strategy',
        'tech-stack-protocol', 'skill-factory', 'test-patterns',
        'impact-test-strategy', 'a11y-testing', 'performance-audit'}
MEMORY = {'memory-ops', 'memory-arch'}
OMITTED_MEMORY = set()  # M3 retired the earlier physical-only omissions.
NEUTRAL_PACK_METHODS = {'excel-ops', 'supabase-postgres-best-practices'}


def read(path):
    return (ROOT/path).read_text(encoding='utf-8-sig')


def fixture():
    return json.loads(read('Tests/TeamNative/a13-originals-fixture.json'))


def original_bytes():
    return {p: base64.b64decode(data, validate=True)
            for p, data in fixture()['originals_base64'].items()}


def pre_a13_index_bytes():
    old = base64.b64decode(fixture()['index_blocks_base64']['maps-assist'], validate=True)
    return re.sub(PATTERN, lambda _: old, (ROOT/INDEX).read_bytes(), flags=re.S)


def pre_a13_shared_bytes():
    result = {p.relative_to(ROOT).as_posix(): p.read_bytes()
              for p in (ROOT/'Shared').rglob('*') if p.is_file()
              and p.relative_to(ROOT).as_posix() != GUIDE}
    result.update(original_bytes())
    result[INDEX] = pre_a13_index_bytes()
    return result


class A13MapsClosure(unittest.TestCase):
    def terms(self, path, terms):
        body = ' '.join(read(path).split())
        for term in terms:
            self.assertIn(term, body, path)

    def test_original_maps_is_pinned_to_prior_oracle(self):
        a8 = json.loads(read('Tests/TeamNative/a8-preservation-fixture.json'))
        self.assertEqual(set(original_bytes()), {MAPS})
        self.assertEqual(hashlib.sha256(original_bytes()[MAPS]).hexdigest(), a8['protected_shared'][MAPS])
        self.assertEqual(set(fixture()['index_blocks_base64']), {'maps-assist'})
        self.assertEqual(fixture()['new_shared_paths'], [GUIDE])

    def test_every_other_shared_file_and_registry_block_unchanged(self):
        from vnext_source_paths import assert_sealed_phase_fixture
        assert_sealed_phase_fixture(self, 'a13-originals-fixture.json')
        self.assertRegex(fixture()['other_shared_sha256'], r'^[0-9a-f]{64}$')
        self.assertRegex(fixture()['other_registry_sha256'], r'^[0-9a-f]{64}$')

    def test_retained_identity_no_relocation_or_retirement(self):
        physical = sorted(p.parent.name for p in (ROOT/'Shared/skills').glob('*/SKILL.md'))
        active = re.findall(r'^- Skill: (.+)$', read(INDEX), re.M)
        self.assertEqual(physical, [n for n in fixture()['physical'] if n not in M3_RETIRED])
        self.assertEqual(active, [n for n in fixture()['active'] if n not in M3_RETIRED])
        self.assertEqual(set(physical)-set(active), OMITTED_MEMORY)
        self.assertEqual([p.name for p in (ROOT/'Shared/skills/maps-assist').rglob('*') if p.is_file()], ['SKILL.md'])
        self.assertIn('Disposition: KEEP_BUT_REWRITE', read(MAPS))

    def test_exhaustive_disjoint_active_census(self):
        groups = list(PACKS.values())+[CORE, MEMORY]
        flattened = [name for group in groups for name in group]
        self.assertEqual(len(flattened), len(set(flattened)))
        active = re.findall(r'^- Skill: (.+)$', read(INDEX), re.M)
        self.assertEqual(set(flattened), set(active))
        self.assertEqual(len(active), len(set(active)))
        self.assertEqual(set(PACKS), {'GitNexus','Supabase','Trunk','Excel','Context7','GitHub','Cloudflare','Sentry','Stitch','Maps'})

    def test_provider_identity_covers_all_nonmemory_active_sources(self):
        optional = set.union(*PACKS.values())
        for name in optional | CORE:
            text = ' '.join(read(f'Shared/skills/{name}/SKILL.md').split()).lower()
            expected = 'no' if name in CORE | NEUTRAL_PACK_METHODS else 'yes'
            self.assertIn(f'provider-specific: {expected}', text, name)
        self.assertFalse(CORE & optional)

    def test_maps_development_positive_and_ordinary_place_negative(self):
        meta = yaml.safe_load(read(MAPS).split('---', 2)[1])
        positive, negative = meta['description'].split('DO NOT use when:', 1)
        for term in ['explicit Google Maps Platform implementation', 'Places / Routes / Geocoding', 'Maps-specific debugging', 'specific Maps provider question']:
            self.assertIn(term, positive)
        for term in ['ordinary place lookup', 'general geography', 'location questions', 'generic UI', 'arbitrary map keyword']:
            self.assertIn(term, negative)
        self.assertEqual(set(meta), {'name','description','metadata'})
        self.assertFalse({'mcp_servers','required_skills','relations','tool_scope'} & set(meta['metadata']))
        block = re.search(PATTERN, (ROOT/INDEX).read_bytes(), re.S).group().decode()
        self.assertIn('- Invocation: restricted;', block)
        self.assertIn('not ordinary place lookup', block)
        self.assertIn('Invocation classification: restricted;', read(MAPS))

    def test_domain_methods_exist_independently_of_provider(self):
        self.terms(MAPS, ['Maps for display', 'Places for place search/details/autocomplete',
                          'Geocoding for address-coordinate conversion', 'Routes for routes/matrices',
                          'Android, iOS and server/Web Service', 'place ID, address and latitude/longitude',
                          'loader lifecycle', 'clean up listeners', 'attribution visibility',
                          'Code Assist is an optional documentation provider'])
        self.assertNotIn('retrieve-instructions', read(MAPS))
        self.assertNotIn('llmQuery', read(MAPS))

    def test_missing_provider_keeps_documentation_alternatives(self):
        self.terms(MAPS, ['unavailable, blocked or present_unverified', 'official Google Maps docs',
                          'GitHub, project-local docs', 'Maps source work remains possible'])
        rows = table('Shared/policies/capability-resolution.md', '| Disqualifying fact (first matching row) | Decision |')
        self.assertEqual(resolve(rows, {'not_ready': True}), 'inspect_or_alternative')
        self.assertEqual(resolve(rows, {'action_denied': True, 'not_ready': True}), 'stop_action')

    def test_tool_order_and_schema_are_provider_scoped(self):
        self.terms(GUIDE, ['selected current provider contract', 'neither always-required nor always-forbidden',
                          '`llmQuery`', 'optional `filter` and `source`', 'not the old `search_context` recipe',
                          'documentationUri, apiState', 'cannot override AI_Rules policy'])

    def test_official_install_document_is_not_authority(self):
        self.terms(GUIDE, ['`npx skills add googlemaps/agent-skills`', 'documentation, not authorization',
                          'No implicit install', 'package download or presence probe'])
        cap = table('Shared/policies/capability-resolution.md', '| Disqualifying fact (first matching row) | Decision |')
        auth = table('Shared/policies/authorization-resolution.md', '| Fact (first true wins) | Result |')
        self.assertEqual(resolve(cap, {'implicit_install_download_init': True}), 'reject_provider')
        self.assertEqual(resolve(auth, {'official_install_documented': True}), 'not_authorized')

    def test_missing_key_does_not_authorize_setup_or_disclosure(self):
        self.terms(MAPS, ['prototype/demo keys, production API keys, server secrets and provider access credentials',
                          'never hardcode a key', 'ask for keys pasted into model context',
                          'login or inspect credential stores as a missing-key fallback',
                          'no automatic billing', 'Cloud project creation'])
        self.terms(GUIDE, ['not a production key', 'absence of billing setup does not authorize either',
                          'A missing key leaves a specific runtime evidence gap'])
        rows = table('Shared/policies/authorization-resolution.md', '| Fact (first true wins) | Result |')
        for facts in [{'key_missing': True}, {'demo_key_available': True}, {'billing_required': True}, {'provider_ready': True}]:
            self.assertEqual(resolve(rows, facts), 'not_authorized')

    def test_current_version_security_cost_and_terms_are_contextual(self):
        self.terms(MAPS, ['current official evidence', 'SDK version/channel', 'deprecations',
                          'do not silently substitute latest', 'application and API restrictions',
                          'Browser SDK keys can be client-visible', 'Secret service credentials stay server-side',
                          'only needed Places fields', 'session-token lifecycle',
                          'product/region-specific current terms', 'does not permit caching all place data'])
        self.terms(GUIDE, ['product, agreement and region', 'live Maps data'])

    def test_evidence_reassesses_a9_without_imported_orchestration(self):
        self.terms(GUIDE, ['August 2026', "A9's reference-only candidate", '2026-09-22',
                          'version 1.0.1', '6606930272e554171b42d69312674cbe40aa819c',
                          'Do not copy upstream mandatory first-fetch/always-fetch loops',
                          'tracking query parameters', 'completion appendices'])
        for term in ['Done When', 'MUST call', 'utm_campaign=', 'gmp_git_agentskills_v1']:
            self.assertNotIn(term, read(MAPS))
        self.assertFalse(read(GUIDE).startswith('---'))

    def test_no_pack_chain_or_core_provider_reclassification(self):
        for name in set.union(*PACKS.values()):
            meta = yaml.safe_load(read(f'Shared/skills/{name}/SKILL.md').split('---', 2)[1])
            self.assertFalse({'required_skills','relations'} & (set(meta) | set(meta.get('metadata', {}))), name)
        self.terms(MAPS, ['No automatic sibling loading or pack activation', 'No Memory / Project Context writes'])
        self.terms(GUIDE, ['not a Maps Agent, execution mode, pack loader or second registry'])

    def test_canonical_owner_links_resolve(self):
        for path in [MAPS, GUIDE]:
            for link in re.findall(r'`(Shared/[^`]+\.md)`', read(path)):
                self.assertTrue((ROOT/link).is_file(), f'{path}: {link}')
        for owner in ['execution-routing', 'authorization-resolution', 'capability-resolution',
                      'agent-governance', 'model-profile-routing', 'verification-strategy',
                      'review-governance', 'completion-policy', 'project-context-protocol']:
            self.assertIn(f'Shared/policies/{owner}.md', read(GUIDE))
        self.assertIn('credential-boundary-contract.md', read(GUIDE))
        self.assertLess(len(read(MAPS).splitlines()), 100)


if __name__ == '__main__':
    unittest.main()
