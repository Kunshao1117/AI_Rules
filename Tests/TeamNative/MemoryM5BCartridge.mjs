// Bundle unchanged local Cartridge source into an external disposable fixture.
// No install, build output, test cache or configuration is written to Cartridge.
import fs from 'node:fs';
import path from 'node:path';
import {createRequire} from 'node:module';
import {spawnSync} from 'node:child_process';
const [cartridgeRoot, fixtureRoot] = process.argv.slice(2).map(p => path.resolve(p));
if (!cartridgeRoot || !fixtureRoot || fixtureRoot.toLowerCase().startsWith('d:\\ai_rules') ||
    fixtureRoot.toLowerCase().startsWith(cartridgeRoot.toLowerCase())) throw new Error('Non-isolated Cartridge target');
if (fs.existsSync(fixtureRoot)) throw new Error('Probe requires a new fixture root');
fs.mkdirSync(fixtureRoot, {recursive:true});
const require = createRequire(path.join(cartridgeRoot, 'package.json'));
const esbuild = require('esbuild');
const outfile = path.join(fixtureRoot, 'probe.cjs');
await esbuild.build({
  entryPoints:[path.join(import.meta.dirname,'MemoryM5BCartridgeProbe.ts')],
  outfile, bundle:true, platform:'node', format:'cjs', logLevel:'silent',
  plugins:[{name:'exact-cartridge-source',setup(build){
    build.onResolve({filter:/^cartridge\//}, args => ({path:path.join(cartridgeRoot,'src',args.path.slice('cartridge/'.length)+'.ts')}));
  }}]
});
const result=spawnSync(process.execPath,[outfile,fixtureRoot],{cwd:fixtureRoot,encoding:'utf8',timeout:20000});
fs.writeFileSync(path.join(fixtureRoot,'process.log'),(result.stdout??'')+(result.stderr??''));
if(result.status!==0) throw new Error('Cartridge fixture failed: '+result.stderr);
const observed=JSON.parse(fs.readFileSync(path.join(fixtureRoot,'probe-result.json'),'utf8'));
console.log(JSON.stringify({fixtureRoot,normalRebuild:!!observed.cases.normal_rebuild,
  registeredCommitSync:observed.cases.registered_commit.summary.indexSynchronized,
  newCardCommitSync:observed.cases.unregistered_new_card_commit.summary.indexSynchronized,
  watcherFinding:observed.cases.warning_self_write.finding}));
