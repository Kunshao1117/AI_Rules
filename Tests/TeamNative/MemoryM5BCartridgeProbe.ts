import fs from 'node:fs';
import path from 'node:path';
import assert from 'node:assert/strict';
import {createHash} from 'node:crypto';
import {createConfig} from 'cartridge/config';
import {CartridgeIndexManager} from 'cartridge/index-manager';
import {MemoryWriter} from 'cartridge/writer';
import {StalenessAnalyzer} from 'cartridge/analyzer';
import {GitignoreFilter} from 'cartridge/gitignore-filter';
import {refreshMemoryIndex} from 'cartridge/memory-reindex';
import {handleProjectFileEvent} from 'cartridge/monitoring/project-event-handler';
import {NodeProjectWatcher} from 'cartridge/monitoring/node-project-watcher';
import {handleMemoryCommit,handleMemoryReindex} from 'cartridge/mcp-handlers';

const root=path.resolve(process.argv[2]);
assert(!root.toLowerCase().startsWith('d:\\ai_rules'));
assert(!root.toLowerCase().startsWith('d:\\cartridge_system'));
const write=(rel:string,text:string)=>{const p=path.join(root,rel);fs.mkdirSync(path.dirname(p),{recursive:true});fs.writeFileSync(p,text);return p;};
const sleep=(ms:number)=>new Promise(r=>setTimeout(r,ms));
const card=(name:string,files:string[],dependency='')=>`---
name: ${name}
description: Synthetic M5B card
staleness: 0
status: stable
memory_schema_version: 2
memory_quality_version: 1
memory_kind: implementation
verification_status: verified
last_verified: 2026-09-30T00:00:00+08:00
valid_scope: [src/a.ts]
last_updated: 2026-09-30T00:00:00+08:00
dependencies: [${dependency}]
metadata:
  author: fixture
  version: '1'
  origin: project
  memory_awareness: full
  tool_scope: []
---
# Synthetic ${name}
## Current Truth
This card describes fixture source only.
## Active Constraints
Synthetic scope only.
## Archive Index
None.
## Evidence Base
- src/a.ts
## Read Contract
Read current synthetic source before using this card.
## Conflicts and Supersession
None.
## 中文摘要
隔離測試卡。
## Tracked Files
${files.map(p=>'\u002d \u0060'+p+'\u0060').join('\n')}
## Relations
None.
## History Summary
Synthetic initial state.
## Cycle Events
None.
`;
const envelope=(r:any)=>JSON.parse(r.content[0].text);
const observations:any={isolation:{root,realProjectUsed:false},sourceExecution:'unchanged Cartridge source bundled externally',cases:{}};

async function main(){
  const tracked=write('src/a.ts','export const a=1;');
  const memory=write('.agents/memory/alpha/MEMORY.md',card('alpha',['src/a.ts','src/gone.ts']));
  const config=createConfig(root);const manager=new CartridgeIndexManager(config);
  const rebuilt=await refreshMemoryIndex({projectRoot:root,indexManager:manager,includeProjectFiles:true,persist:true});
  observations.cases.normal_rebuild=rebuilt;
  assert(manager.getIndex().cartridges.alpha);
  const writer=new MemoryWriter(config);const analyzer=new StalenessAnalyzer(config,manager,writer);
  const filter=new GitignoreFilter(root);filter.reload();
  const events:any[]=[];let queue=Promise.resolve();let warningState:any;
  const originalInject=writer.injectWarning.bind(writer);
  writer.injectWarning=async (...args:any[])=>{await originalInject(...args);warningState=structuredClone(manager.getIndex().cartridges.alpha);};
  const errors:any[]=[];
  const watcher=new NodeProjectWatcher({projectRoot:root,debounceMs:25,onEvent:(abs:string,eventType:any)=>{
    assert(!path.relative(root,abs).startsWith('..'));
    queue=queue.then(async()=>{
      await handleProjectFileEvent({config,indexManager:manager,analyzer,gitignoreFilter:filter,writer,absFilePath:abs,eventType});
      events.push({path:path.relative(root,abs).replace(/\\/g,'/'),eventType,state:structuredClone(manager.getIndex().cartridges.alpha)});
    }).catch(e=>errors.push(String(e)));
  },onRescan:()=>errors.push('unexpected rescan'),onError:(e:any)=>errors.push(String(e))});
  const hash=()=>createHash('sha256').update(fs.readFileSync(path.join(root,'.cartridge/index.json'))).digest('hex');
  const beforeStartup=hash();watcher.start();await sleep(150);
  observations.cases.watcher_startup={indexChanged:hash()!==beforeStartup};
  fs.appendFileSync(tracked,'\nexport const b=2;');
  for(let i=0;i<60&&!events.some(e=>e.path.endsWith('/MEMORY.md'));i++)await sleep(50);
  watcher.stop();await queue;
  assert.equal(errors.length,0,errors.join('\n'));assert(warningState,'tracked source must inject a warning');
  assert(events.some(e=>e.path.endsWith('/MEMORY.md')),'real fs watcher must process warning self-write');
  const after=structuredClone(manager.getIndex().cartridges.alpha);
  observations.cases.warning_self_write={warningInjected:fs.readFileSync(memory,'utf8').includes('CARTRIDGE_SYSTEM_WARNING_START'),beforeSelfWrite:warningState,afterSelfWrite:after,events,
    semanticInvariant:warningState.pendingChanges.length>0&&after.pendingChanges.length>0,
    finding:warningState.pendingChanges.length>0&&after.pendingChanges.length===0?'PENDING_CLEARED_BY_WARNING_SELF_WRITE':null};

  const committed=envelope(await handleMemoryCommit({projectRoot:root,moduleName:'alpha',confirm:true}));
  observations.cases.registered_commit=committed;
  assert.equal(committed.summary.status,'success');assert.equal(committed.summary.indexSynchronized,true);
  write('.agents/memory/alpha/MEMORY.md',card('alpha',['src/a.ts'],'missing-dependency'));
  const dependency=envelope(await handleMemoryCommit({projectRoot:root,moduleName:'alpha',confirm:true}));
  observations.cases.dependency_warning_commit=dependency;
  assert.equal(dependency.summary.indexSynchronized,true);
  assert(dependency.summary.warnings.some((w:string)=>w.includes('DEPENDENCY')));
  write('.agents/memory/new-module/MEMORY.md',card('new-module',['src/a.ts'],'missing-dependency'));
  const newResult=envelope(await handleMemoryCommit({projectRoot:root,moduleName:'new-module',confirm:true}));
  observations.cases.unregistered_new_card_commit=newResult;
  assert.equal(newResult.summary.status,'success');assert.equal(newResult.summary.indexSynchronized,false);
  assert(newResult.summary.warnings.some((w:string)=>w.includes('INDEX_SYNC_PARTIAL')));
  const disk=JSON.parse(fs.readFileSync(path.join(root,'.cartridge/index.json'),'utf8'));
  assert(!disk.cartridges['new-module'],'new card commit must not be assumed to register the card');
  write('.cartridge/index.json','{ invalid index');
  const repaired=envelope(await handleMemoryReindex({projectRoot:root,confirm:true}));
  observations.cases.invalid_index_repair=repaired;
  assert(JSON.stringify(repaired).includes('index_repaired'));
  const finalIndex=JSON.parse(fs.readFileSync(path.join(root,'.cartridge/index.json'),'utf8'));
  assert(finalIndex.cartridges.alpha&&finalIndex.cartridges['new-module']);
  observations.limits=['Synthetic fixture only','Installed extension/desktop not verified','REAL_SESSION_BEHAVIOR_REQUIRES_M5C','AI_Rules authorization/completion remain canonical policy decisions, not this handler'];
  fs.writeFileSync(path.join(root,'probe-result.json'),JSON.stringify(observations,null,2));
}
main().catch(e=>{console.error(e);process.exitCode=1;});
