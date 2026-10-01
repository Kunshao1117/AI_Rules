"""A11 source contracts and offline fixtures, never live GitHub/Cloudflare calls.

Examples use evidenced facts with existing canonical tables. They are not NLP
routing, new authorization code, or proof of native model/provider enforcement.
SQLite supplies limited SQL-effect evidence, not a remote D1 implementation.
"""
import base64
import hashlib
import json
import re
import sqlite3
import unittest
import yaml
from vnext_source_paths import ROOT
from test_vnext_a3_retirement import table, resolve

NAMES = {'github-ops', 'pr-review-ops', 'cloudflare-ops'}
GUIDES = {'Shared/policies/references/github-guide.md', 'Shared/policies/references/cloudflare-guide.md'}
FIXTURE = ROOT / 'Tests/TeamNative/a11-originals-fixture.json'
INDEX_PATTERN = rb'## \d+\. (?:github-ops|pr-review-ops|cloudflare-ops)\r?\n.*?(?=## |\Z)'


def fixture():
    return json.loads(FIXTURE.read_text())


def read(path):
    return (ROOT / path).read_text(encoding='utf-8-sig')


def original_bytes():
    return {p: base64.b64decode(data, validate=True) for p, data in fixture()['originals_base64'].items()}


def pre_a11_index_bytes():
    from test_vnext_a12_sentry_stitch import pre_a12_index_bytes
    blocks = fixture()['index_blocks_base64']
    def replace(match):
        name = re.search(rb'^## \d+\. ([^\r\n]+)', match.group()).group(1).decode()
        return base64.b64decode(blocks[name], validate=True)
    return re.sub(INDEX_PATTERN, replace, pre_a12_index_bytes(), flags=re.S)


def pre_a11_shared_bytes():
    from test_vnext_a12_sentry_stitch import pre_a12_shared_bytes
    excluded = set(fixture()['new_shared_paths'])
    result = {p: data for p, data in pre_a12_shared_bytes().items() if p not in excluded}
    result.update(original_bytes())
    result['Shared/skills/_index.md'] = pre_a11_index_bytes()
    return result


def skill(name):
    return read(f'Shared/skills/{name}/SKILL.md')


class A11GitHubCloudflare(unittest.TestCase):
    def test_originals_match_prior_pinned_hashes_without_runtime_archives(self):
        a8 = json.loads((ROOT / 'Tests/TeamNative/a8-preservation-fixture.json').read_text())
        self.assertEqual(set(original_bytes()), {f'Shared/skills/{n}/SKILL.md' for n in NAMES})
        self.assertEqual(set(fixture()['new_shared_paths']), GUIDES)
        for p, data in original_bytes().items():
            self.assertEqual(hashlib.sha256(data).hexdigest(), a8['protected_shared'][p], p)
        for n in NAMES:
            self.assertEqual([p.name for p in (ROOT / f'Shared/skills/{n}').rglob('*') if p.is_file()], ['SKILL.md'])

    def test_all_other_shared_sources_and_registry_blocks_preserved(self):
        from vnext_source_paths import assert_sealed_phase_fixture
        assert_sealed_phase_fixture(self, 'a11-originals-fixture.json')
        self.assertRegex(fixture()['other_shared_sha256'], r'^[0-9a-f]{64}$')
        self.assertRegex(fixture()['other_registry_sha256'], r'^[0-9a-f]{64}$')

    def test_inventory_retains_three_skills_and_frozen_omissions(self):
        physical = sorted(p.parent.name for p in (ROOT / 'Shared/skills').glob('*/SKILL.md'))
        active = re.findall(r'^- Skill: (.+)$', read('Shared/skills/_index.md'), re.M)
        from vnext_source_paths import M3_RETIRED
        self.assertEqual(physical, [n for n in fixture()['physical'] if n not in M3_RETIRED])
        self.assertEqual(active, [n for n in fixture()['active'] if n not in M3_RETIRED])
        self.assertEqual(set(physical)-set(active), set())
        self.assertTrue(NAMES <= set(active))
        for g in GUIDES:
            self.assertNotEqual((ROOT / g).name, 'SKILL.md')
            self.assertFalse(read(g).startswith('---'))

    def test_restricted_entry_contracts_and_positive_negative_examples(self):
        cases = [('github-ops', 'specific GitHub repository', 'ordinary local Git'),
                 ('pr-review-ops', 'specific GitHub PR', 'local diff'),
                 ('cloudflare-ops', 'Cloudflare Workers', 'general JavaScript')]
        for name, positive, negative in cases:
            body = skill(name)
            meta = yaml.safe_load(body.split('---', 2)[1])
            self.assertEqual(set(meta), {'name', 'description', 'metadata'})
            self.assertFalse({'required_skills', 'relations', 'mcp_servers'} & meta['metadata'].keys())
            yes, no = meta['description'].split('DO NOT use when:', 1)
            self.assertIn(positive, yes)
            self.assertIn(negative, no)
            self.assertIn('Invocation classification: restricted', body)
            self.assertIn('No automatic sibling loading', body)
            self.assertLess(len(body.splitlines()), 90)
        self.assertIn('An issue update does not load pr-review-ops', skill('github-ops'))
        self.assertIn('PR analysis does not require github-ops', skill('pr-review-ops'))
        self.assertIn('does not load GitHub', skill('cloudflare-ops'))

    def test_github_provider_readonly_is_a_capability_filter_not_user_intent(self):
        g = read('Shared/policies/references/github-guide.md')
        for term in ['Read-only\nfilters write tools even if explicitly included', '--toolsets', '--tools',
                     '--exclude-tools', '--read-only', 'do not edit config, environment',
                     'not grant write authority when read-only is disabled']:
            self.assertIn(term, g)
        auth = table('Shared/policies/authorization-resolution.md', '| Fact (first true wins) | Result |')
        for fact in ['provider_readonly_off', 'write_tool_visible', 'token_has_write_scope']:
            self.assertEqual(resolve(auth, {fact: True}), 'not_authorized')
        selection = table('Shared/policies/capability-resolution.md', '| Disqualifying fact (first matching row) | Decision |')
        self.assertEqual(resolve(selection, {'platform_denied': True}), 'reject_provider')
        self.assertEqual(resolve(selection, {'action_denied': True}), 'stop_action')
        self.assertIn('Never bypass an action-level denial using another provider', g)

    def test_github_lockdown_is_not_credential_boundary(self):
        g = read('Shared/policies/references/github-guide.md')
        for term in ['best-effort filter', 'not a credential/authorization boundary',
                     'prompt-injection guarantee', 'private repositories are unaffected', 'untrusted task data']:
            self.assertIn(term, g)

    def test_github_effect_catalog_covers_reads_and_distinct_mutations(self):
        g = read('Shared/policies/references/github-guide.md')
        for term in ['| Observation |', '| Collaboration mutation |', '| Repository mutation |',
                     '| PR creation |', '| Integration/publication |', 'issue_read', 'issue_write',
                     'pull_request_read', 'pull_request_review_write', 'add_comment_to_pending_review',
                     'actions_run_trigger', 'release-write or branch-delete', 'expectedHeadSha']:
            self.assertIn(term, g)
        self.assertIn('Reading a public repo does not require PR review', skill('github-ops'))

    def test_review_request_does_not_publish_or_merge(self):
        b = skill('pr-review-ops')
        for term in ['return findings in chat', 'does not\nby itself request publication',
                     '“Submit this review” identifies a remote collaboration request',
                     'exact repo/PR', 'content and intended event', 'Neither review pass nor CI green authorizes merge']:
            self.assertIn(term, b)
        auth = table('Shared/policies/authorization-resolution.md', '| Fact (first true wins) | Result |')
        cases = [('analyze PR', {'current_scope_allows': True}, 'authorized'),
                 ('publish after analysis only', {'missing_explicit_action_target': True}, 'not_authorized'),
                 ('explicit submit this review to target', {'current_scope_allows': True}, 'authorized'),
                 ('merge after review pass and CI green', {'review_pass': True, 'ci_green': True}, 'not_authorized'),
                 ('explicit merge resolved PR', {'current_scope_allows': True}, 'authorized')]
        for label, facts, expected in cases:
            with self.subTest(case=label):
                self.assertEqual(resolve(auth, facts), expected)

    def test_pending_review_is_server_state_not_local_draft(self):
        g = read('Shared/policies/references/github-guide.md')
        for term in ['Local analysis or a chat draft changes no GitHub state',
                     'A GitHub pending review\ndoes', 'creation, adding pending comments, submission',
                     'deleting the pending review', 'resolve/unresolve thread', 'still server-side state']:
            self.assertIn(term, g)

    def test_push_pr_creation_and_freshness_boundaries(self):
        b = skill('github-ops')
        for term in ['not remote push', '“Fix it and push', 'destination repo, exact head/base',
                     'Existing commits and completed', 'do not authorize creating a PR',
                     'blob SHA from the same', 'concurrent edits', 'ambiguous response',
                     'before any retry', 'Do not automatically push']:
            self.assertIn(term, b)
        auth = table('Shared/policies/authorization-resolution.md', '| Fact (first true wins) | Result |')
        self.assertEqual(resolve(auth, {'source_modified': True}), 'not_authorized')
        self.assertEqual(resolve(auth, {'current_scope_allows': True, 'platform_denied': True}), 'stop_affected_action')

    def test_pr_evidence_keeps_context_coordinates_and_stale_sha(self):
        b = skill('pr-review-ops')
        for term in ['base/head repositories', 'comparison base', 'pagination and truncation',
                     'actual risk', 'no universal TypeScript', 'issue-style PR comments',
                     'outdated thread', 'never invent a current line number', 'Combined commit status',
                     'check runs are distinct', 'diff side', 'severity', 'If it changed, reassess']:
            self.assertIn(term, b)
        self.assertNotIn('Gate cleared', b)
        self.assertNotIn('GO MERGE', b)

    def test_github_external_ai_requires_explicit_intent(self):
        g = read('Shared/policies/references/github-guide.md')
        for term in ['assign_copilot_to_issue', 'request_copilot_review', 'create_pull_request_with_copilot',
                     'Ordinary GitHub use never activates them', 'Only explicit external AI task intent',
                     'data-sharing boundary', 'No generic AI-to-AI fallback']:
            self.assertIn(term, g)
        sel = table('Shared/policies/capability-resolution.md', '| Disqualifying fact (first matching row) | Decision |')
        self.assertEqual(resolve(sel, {'external_ai_unrequested': True}), 'reject_provider')

    def test_cloudflare_identity_local_remote_and_setup_effects(self):
        g = read('Shared/policies/references/cloudflare-guide.md')
        for term in ['account/profile', 'environment', 'local/remote', 'Unknown identity stops remote mutation',
                     'presence or successful login does not prove', 'Missing config does not authorize init',
                     'Never use `npx wrangler`', 'default dependency installation', 'Deploy --temporary',
                     '--install-skills', '--local disables remote bindings', 'CLOUDFLARE_ENV']:
            self.assertIn(term, g)
        self.assertIn('No init or deploy as a presence probe', skill('cloudflare-ops'))

    def test_cloudflare_profile_and_secret_risks_are_not_presence_probes(self):
        g = read('Shared/policies/references/cloudflare-guide.md')
        for term in ['API\ntoken override', '--profile', 'nearest activated directory',
                     'One profile can reach multiple accounts', 'without inspecting token values',
                     'whoami', 'wrangler auth token', 'not a harmless readiness probe',
                     'No automatic login, account/profile switch', 'secret values or credential stores']:
            self.assertIn(term, g)

    def test_cloudflare_product_effects_cover_remote_cleanup(self):
        g = read('Shared/policies/references/cloudflare-guide.md')
        for term in ['Local source change', 'Remote upload/activation/traffic', 'Remote destructive removal',
                     'KV key get/list versus put/delete', 'R2 object get/put/delete', 'Queues/DNS/config',
                     'Logs/tail', 'Secret put/delete', 'Remote temporary/disposable resources',
                     'Cleanup requires an explicitly covered action/target']:
            self.assertIn(term, g)
        auth = table('Shared/policies/authorization-resolution.md', '| Fact (first true wins) | Result |')
        for fact in ['temporary_remote_resource', 'task_finished', 'container_test_failed']:
            self.assertEqual(resolve(auth, {fact: True}), 'not_authorized')

    def test_d1_offline_sql_effects_distinguish_target_and_actual_writes(self):
        # Both labelled targets are isolated in-memory SQLite. No D1 connection.
        # Authorizer evidence detects actual data/schema effects, not SQL prefixes.
        cases = [('local-db', 'local', 'SELECT value FROM items', False),
                 ('hosted-db-fixture', 'remote', 'SELECT value FROM items', False),
                 ('hosted-db-fixture', 'remote', 'INSERT INTO items VALUES(2, "b")', True),
                 ('hosted-db-fixture', 'remote', 'ALTER TABLE items ADD COLUMN note TEXT', True)]
        for target, location, sql, writes in cases:
            with self.subTest(target=target, location=location, sql=sql):
                db = sqlite3.connect(':memory:')
                try:
                    db.executescript('CREATE TABLE items(id INTEGER, value TEXT); INSERT INTO items VALUES(1,"a");')
                    actions = []
                    def capture(action, *args):
                        actions.append(action)
                        return sqlite3.SQLITE_OK
                    db.set_authorizer(capture)
                    db.execute(sql).fetchall()
                    self.assertEqual(any(a in {sqlite3.SQLITE_INSERT, sqlite3.SQLITE_UPDATE,
                                              sqlite3.SQLITE_DELETE, sqlite3.SQLITE_ALTER_TABLE} for a in actions), writes)
                finally:
                    db.close()
        g = read('Shared/policies/references/cloudflare-guide.md')
        for term in ['| Local D1 | Local observation', '| Remote D1 | Remote observation',
                     '| INSERT/UPDATE/DELETE | Remote D1 | Remote data mutation',
                     '| CREATE/ALTER/DROP | Remote D1 | Remote schema mutation']:
            self.assertIn(term, g)

    def test_d1_mixed_sql_and_migration_partial_state(self):
        db = sqlite3.connect(':memory:')
        self.addCleanup(db.close)
        db.executescript('CREATE TABLE items(id INTEGER); INSERT INTO items VALUES(1);')
        db.executescript('SELECT * FROM items; DELETE FROM items;')
        self.assertEqual(db.execute('SELECT count(*) FROM items').fetchone()[0], 0)
        g = read('Shared/policies/references/cloudflare-guide.md')
        for term in ['SELECT followed by DELETE is', 'no first-keyword', 'existing project\nmigration workflow',
                     'earlier successful migrations may remain applied', 'without automatic reset/repair']:
            self.assertIn(term, g)

    def test_container_deploy_partial_failure_contract_fixture(self):
        # Recorded-stage fixture follows official Worker-before-image order.
        # A failed later stage is deliberately unable to undo earlier evidence.
        before = {'worker': 'old', 'image': 'old', 'rollout': 'old'}
        events = [('worker_activated', 'new'), ('image_build_failed', None)]
        observed = dict(before)
        for event, value in events:
            if event == 'worker_activated':
                observed['worker'] = value
            elif event == 'image_build_failed':
                break
        self.assertNotEqual(observed, before)
        self.assertEqual(observed, {'worker': 'new', 'image': 'old', 'rollout': 'old'})
        g = read('Shared/policies/references/cloudflare-guide.md')
        self.assertIn('activates the Worker before processing Container configuration', g)
        self.assertIn('not transactional', g)
        self.assertIn('unknown remote state stays unknown', g)
        self.assertIn('No automatic rollback', g)
        self.assertIn('not mean all instances finished', g)

    def test_container_build_push_delete_and_mcp_execute_are_distinct(self):
        g = read('Shared/policies/references/cloudflare-guide.md')
        for term in ['containers build with --push adds registry mutation', 'application deletion, image deletion',
                     'registry configuration\ndeletion', 'Removing an image may break a later rollback',
                     'inspect every actual API call', 'not just the outer execute tool',
                     'not make invoked remote mutations read-only']:
            self.assertIn(term, g)

    def test_owners_paths_and_provider_gaps_do_not_restore_governance(self):
        for p in GUIDES | {f'Shared/skills/{n}/SKILL.md' for n in NAMES}:
            b = read(p)
            for link in re.findall(r'`(Shared/[^`]+\.md)`', b):
                self.assertTrue((ROOT / link).is_file(), f'{p}: {link}')
        for p in GUIDES:
            b = read(p)
            for owner in ['execution-routing', 'authorization-resolution', 'capability-resolution',
                          'agent-governance', 'model-profile-routing', 'verification-strategy',
                          'review-governance', 'completion-policy']:
                self.assertIn(f'Shared/policies/{owner}.md', b)
            self.assertIn('Memory', b)
            self.assertIn('Project Context', ' '.join(b.split()))
        sel = table('Shared/policies/capability-resolution.md', '| Disqualifying fact (first matching row) | Decision |')
        for fact in ['implicit_install_download_init', 'missing_authorization']:
            self.assertEqual(resolve(sel, {fact: True}), 'reject_provider')


if __name__ == '__main__':
    unittest.main()
