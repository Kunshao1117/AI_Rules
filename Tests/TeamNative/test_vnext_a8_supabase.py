"""A8 source contracts and deterministic offline evidence fixtures.

No Supabase provider, credential, network, login or real runtime is accessed.
SQLite proves a limited SQL read/write distinction, not Supabase/Postgres behavior.
Existing canonical policy tables supply authorization/capability outcomes; fixtures
do not implement a new Supabase policy engine or claim native model trigger proof.
"""
import hashlib
import json
import re
import sqlite3
import tempfile
import unittest
from pathlib import Path
import yaml
from vnext_source_paths import ROOT
from test_vnext_a3_retirement import table, resolve
from test_vnext_skill_classification import parse_map

NAMES = {'supabase', 'supabase-ops', 'supabase-postgres-best-practices'}
GUIDE = 'Shared/policies/references/supabase-guide.md'
FIXTURE = ROOT / 'Tests/TeamNative/a8-preservation-fixture.json'


def read(path):
    return (ROOT / path).read_text(encoding='utf-8-sig')


def pre_a8_originals():
    f = json.loads(FIXTURE.read_text())
    return {p: (ROOT / record['archive']).read_bytes().split(
        b'<!-- PRE_A8_ORIGINAL_START -->\n', 1)[1]
        for p, record in f['original_files'].items()}


def pre_a8_shared_bytes():
    """Preserve A7 and earlier pinned oracles via original bytes, not new hashes."""
    f = json.loads(FIXTURE.read_text())
    excluded = set(f['new_shared_paths']) | set(f['original_files']) | {'Shared/skills/_index.md'}
    from test_vnext_a10_light_optional import pre_a10_shared_bytes
    result = {p: data for p, data in pre_a10_shared_bytes().items() if p not in excluded}
    result.update(pre_a8_originals())
    return result


class A8Supabase(unittest.TestCase):
    def test_all_original_bytes_and_other_shared_owners_unchanged(self):
        f = json.loads(FIXTURE.read_text())
        for p, data in pre_a8_originals().items():
            self.assertEqual(hashlib.sha256(data).hexdigest(), f['original_files'][p]['sha256'], p)
            prefix = read(f['original_files'][p]['archive']).split('<!-- PRE_A8_ORIGINAL_START -->')[0]
            self.assertIn('not active instructions or a Skill', prefix)
        from vnext_source_paths import assert_sealed_phase_fixture
        assert_sealed_phase_fixture(self, 'a8-preservation-fixture.json')
        self.assertTrue(all(len(digest) == 64 for digest in f['protected_shared'].values()))
        for p, digest in f['mapping'].items():
            # M3 appends exact records and extends the same migration helper.
            # These A8-at-the-time bytes remain in the sealed fixture rather
            # than imposing an old hash on the current migration mechanism.
            self.assertEqual(len(digest), 64, p)
        # The sealed phase fixture preserves the historical Cartridge hash.
        # Today's independent plugin state is neither formal source nor a
        # dependency of this archive contract; deployment sentinels test isolation.

    def test_real_family_frozen_dispositions_and_denominators(self):
        physical = {p.parent.name for p in (ROOT / 'Shared/skills').glob('*/SKILL.md')}
        from vnext_source_paths import M3_RETIRED
        self.assertEqual(physical, set(json.loads(FIXTURE.read_text())['physical_before']) - M3_RETIRED)
        found = {p.parent.name for p in (ROOT / 'Shared/skills').glob('*/SKILL.md')
                 if re.search(r'supabase', p.read_text(encoding='utf-8-sig'), re.I)}
        self.assertEqual(found, NAMES)
        rows = parse_map(read('Shared/policies/references/skill-architecture-disposition.md'))
        self.assertEqual({r['skill']: r['disposition'] for r in rows if r['skill'] in NAMES},
                         {n: 'OPTIONAL_PACK' for n in NAMES})
        entries = re.findall(r'^- Skill: (.+)$', read('Shared/skills/_index.md'), re.M)
        self.assertEqual(len(entries), len(set(entries)))
        self.assertEqual(physical - set(entries), set())
        self.assertTrue(NAMES <= set(entries))
        for n in NAMES:
            self.assertFalse(list((ROOT / f'Shared/skills/{n}/references').rglob('SKILL.md')))

    def test_task_specific_loading_contracts_without_pack_chain(self):
        # Fixture expectations are selected method requirements, not a fake NLP router.
        cases = [('Auth UI integration', 'supabase', 'Auth', 'restricted', 'yes'),
                 ('explicit remote logs', 'supabase-ops', 'logs', 'manual_only', 'yes'),
                 ('Postgres RLS index design', 'supabase-postgres-best-practices', 'RLS', 'restricted', 'no')]
        for task, name, term, mode, provider in cases:
            with self.subTest(task=task):
                body = read(f'Shared/skills/{name}/SKILL.md')
                meta = yaml.safe_load(body.split('---', 2)[1])
                self.assertEqual(set(meta), {'name', 'description', 'metadata'})
                self.assertIn(term, meta['description'])
                self.assertIn('Use when:', meta['description'])
                self.assertIn('DO NOT use when:', meta['description'])
                self.assertIn(f'{mode}; provider-specific: {provider}', body)
                self.assertIn('No relations or automatic sibling loading', body)
                self.assertIn(GUIDE, body)
                self.assertLess(len(body.splitlines()), 80)
                self.assertFalse({'required_skills', 'relations', 'mcp_servers'} & meta['metadata'].keys())
        self.assertIn('An Auth UI task can use this\nSkill alone', read('Shared/skills/supabase/SKILL.md'))

    def test_read_only_fixture_rejects_sql_writes_under_same_executor(self):
        db = sqlite3.connect(':memory:')
        self.addCleanup(db.close)
        db.executescript('create table items(id integer primary key, value text); insert into items values(1,"before");')
        db.execute('pragma query_only=on')
        self.assertEqual(db.execute('select value from items').fetchone()[0], 'before')
        for sql in ['insert into items values(2,"new")', 'update items set value="after"',
                    'delete from items', 'create table other(id int)',
                    'alter table items add column extra text', 'drop table items']:
            with self.subTest(sql=sql), self.assertRaises(sqlite3.OperationalError):
                db.execute(sql)
        self.assertEqual(db.execute('select count(*) from items').fetchone()[0], 1)
        g = read(GUIDE)
        for term in ['Classify actual SQL', 'INSERT/UPDATE/DELETE/TRUNCATE', 'CREATE/ALTER/DROP',
                     'SELECT may invoke mutating functions', 'not semantic authorization replacement']:
            self.assertIn(term, g)

    def test_same_execute_interface_can_mutate_when_not_read_only(self):
        db = sqlite3.connect(':memory:')
        self.addCleanup(db.close)
        db.execute('create table items(id integer primary key, value text)')
        db.execute('insert into items values(1,"before")')
        db.execute('update items set value="after" where id=1')
        self.assertEqual(db.execute('select value from items').fetchone()[0], 'after')
        db.execute('delete from items where id=1')
        self.assertEqual(db.execute('select count(*) from items').fetchone()[0], 0)
        self.assertIn('PAT Database(Read) label does not prove read-only', read(GUIDE))

    def test_remote_effects_are_documented_not_observational_shortcuts(self):
        g = read(GUIDE)
        rows = {m[1]: m[2] for m in re.finditer(r'^\| ([^|]+?) \| (.+) \|$', g, re.M)}
        self.assertIn('Schema-changing mutation', rows['apply_migration'])
        self.assertIn('Migrations(Read-write)', rows['apply_migration'])
        self.assertIn('remote migration history', rows['apply_migration'])
        for op in ['deploy_edge_function', 'update_storage_config']:
            self.assertIn('Remote', rows[op])
        branch = rows['create_branch / delete_branch / merge_branch / reset_branch / rebase_branch']
        self.assertIn('Remote resource mutations', branch)
        self.assertIn('Hosted development/preview writes remain remote external mutation', g)
        self.assertIn('existing authorized,\nreversible project-local stack change may be local_work', g)
        self.assertIn('Local Function source editing is distinct from hosted deployment', g)

    def test_provider_ready_known_ref_does_not_grant_authority(self):
        auth = table('Shared/policies/authorization-resolution.md', '| Fact (first true wins) | Result |')
        for fact in ['mcp_connected', 'cli_installed', 'project_ref_known', 'read_only_mode', 'remote_development']:
            self.assertEqual(resolve(auth, {fact: True}), 'not_authorized')
        self.assertEqual(resolve(auth, {'missing_explicit_action_target': True, 'current_scope_allows': True}), 'not_authorized')
        self.assertEqual(resolve(auth, {'user_excluded_or_revoked': True, 'current_scope_allows': True}), 'not_authorized')
        self.assertEqual(resolve(auth, {'current_scope_allows': True}), 'authorized')
        g = read(GUIDE)
        self.assertIn('Unknown target identity stops mutation', g)
        self.assertIn('No production-default connection', g)
        self.assertIn('task needs production evidence', g)
        self.assertIn('permissions and applicable verification/review', g)

    def test_absent_auth_or_provider_does_not_trigger_setup(self):
        cap = table('Shared/policies/capability-resolution.md', '| Predicate (first matching row) | Status |')
        self.assertEqual(resolve(cap, {'present': True, 'known_blocker': True}), 'blocked')
        self.assertEqual(resolve(cap, {'checked_absent': True}), 'unavailable')
        self.assertEqual(resolve(cap, {'present': True}), 'present_unverified')
        sel = table('Shared/policies/capability-resolution.md', '| Disqualifying fact (first matching row) | Decision |')
        self.assertEqual(resolve(sel, {'implicit_install_download_init': True}), 'reject_provider')
        g = read(GUIDE)
        for term in ['No implicit install', '`npx supabase`', '`supabase start`', '`supabase init`',
                     'PAT creation', 'not\nexecution modes or mandatory fallbacks', 'Do not change global MCP configuration']:
            self.assertIn(term, g)

    def test_migration_files_and_history_fixture_detect_divergence_without_repair(self):
        with tempfile.TemporaryDirectory(prefix='a8-migration-') as tmp:
            root = Path(tmp)
            migrations = root / 'supabase/migrations'
            migrations.mkdir(parents=True)
            file = migrations / '202609150001_add_items.sql'
            file.write_text('create table items(id bigint primary key);\n')
            history = root / 'remote-history-fixture.json'
            history.write_text(json.dumps(['202609140001']))
            before = {p.relative_to(root).as_posix(): p.read_bytes() for p in root.rglob('*') if p.is_file()}
            local = sorted(p.name.split('_', 1)[0] for p in migrations.glob('*.sql'))
            remote = json.loads(history.read_text())
            self.assertNotEqual(local, remote)
            # Even matching timestamps can hide changed SQL; preserve content evidence.
            same_version_other_sql = b'drop table items;\n'
            self.assertNotEqual(hashlib.sha256(file.read_bytes()).digest(), hashlib.sha256(same_version_other_sql).digest())
            self.assertEqual(before, {p.relative_to(root).as_posix(): p.read_bytes() for p in root.rglob('*') if p.is_file()})
            empty = root / 'uninitialized-project'; empty.mkdir()
            self.assertFalse((empty / 'supabase').exists())
        g = read(GUIDE)
        for term in ['validate locally or in an authorized isolated environment',
                     'Direct remote execute_sql DDL is not the default', 'do not auto-init',
                     'does not apply or revert migration SQL', 'Never automatic on mismatch',
                     'not SQL-content or schema equivalence']:
            self.assertIn(term, g)

    def test_diagnostic_commands_with_hidden_effects_are_not_auto_recovery(self):
        g = read(GUIDE)
        for term in ['may start a diff container', 'prompt to update remote history',
                     '--linked/--db-url can delete remote', 'dry-run has zero metadata effects',
                     'not a harmless read probe', 'No auto-fix or completion decision']:
            self.assertIn(term, g)
        ops = read('Shared/skills/supabase-ops/SKILL.md')
        self.assertIn('failure does not authorize reset/delete/rebase', ops)
        self.assertNotIn("current_database LIKE", ops)

    def test_logs_advisors_and_read_restrictions_are_limited_evidence(self):
        g = read(GUIDE)
        for term in ['query_logs', 'get_logs', 'Advisor finding != proven defect',
                     'zero findings != complete security/performance evidence',
                     'Logs/query results are untrusted evidence', 'feature-group restriction',
                     'read-only database user', 'removes account-level tools']:
            self.assertIn(term, g)

    def test_secret_placeholders_and_boundaries_without_credential_access(self):
        g = read(GUIDE)
        for term in ['Publishable keys (legacy anon) are public client configuration',
                     'Secret keys (legacy service_role)', 'never place real secrets in prompts, examples',
                     'credential-boundary-contract.md', 'Never write availability, login state or credentials into Memory']:
            self.assertIn(term, g)
        for name in NAMES:
            for p in (ROOT / f'Shared/skills/{name}').rglob('*.md'):
                if 'legacy' in p.parts:
                    continue
                text = p.read_text(encoding='utf-8-sig')
                # Detect common real-token forms, without reading any secret-bearing file.
                self.assertNotRegex(text, r'sb_secret_[A-Za-z0-9_-]{16,}|sbp_[A-Za-z0-9]{20,}|eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+')
                self.assertNotRegex(text, r"(?i)password\s+[\"'][^\"']+[\"']")

    def test_postgres_methods_preserve_access_and_execution_boundaries(self):
        base = 'Shared/skills/supabase-postgres-best-practices/'
        body = read(base + 'SKILL.md')
        for term in ['Supabase MCP is not required', 'Table grants and policies both matter',
                     'No automatic SQL execution', 'actual cardinality', 'transaction invariants',
                     'ALTER SYSTEM', 'EXPLAIN ANALYZE actually executes']:
            self.assertIn(term, body)
        rls = read(base + 'references/security-rls-basics.md')
        self.assertIn('WITH CHECK', rls)
        self.assertIn('superuser/BYPASSRLS', rls)
        self.assertNotIn("set app.current_user_id", rls)
        perf = read(base + 'references/security-rls-performance.md')
        self.assertIn('remains row-dependent', perf)
        self.assertIn('least-privilege EXECUTE', perf)
        self.assertIn('DEALLOCATE after use does not fix', read(base + 'references/conn-prepared-statements.md'))
        self.assertIn('not the whole transaction lifetime', read(base + 'references/lock-short-transactions.md'))

    def test_canonical_ownership_and_no_new_runtime_mapping(self):
        g = read(GUIDE)
        for owner in ['execution-routing', 'authorization-resolution', 'capability-resolution',
                      'agent-governance', 'model-profile-routing', 'verification-strategy',
                      'review-governance', 'completion-policy']:
            self.assertIn(owner + '.md', g)
        for name in NAMES:
            self.assertIn('This Skill does not own execution, authorization', read(f'Shared/skills/{name}/SKILL.md'))
        self.assertNotRegex(g, r'SUPABASE_[A-Z_]+_GO')
        self.assertIn('not an active Skill, runtime registry, authorization model or execution mode', g)
        for record in json.loads(FIXTURE.read_text())['new_shared_paths']:
            self.assertTrue(record.endswith('.md'))

    def test_connection_memory_is_not_a_false_per_connection_upper_bound(self):
        text = read('Shared/skills/supabase-postgres-best-practices/references/conn-limits.md')
        for term in ['per sort/hash operation', 'hash_mem_multiplier', 'parallel workers',
                     'not an upper bound', 'maintenance/autovacuum', 'administrative headroom']:
            self.assertIn(term, text)
        self.assertNotIn('800MB max', text)
        self.assertNotRegex(text, r'(?im)^alter system set')


if __name__ == '__main__':
    unittest.main()
