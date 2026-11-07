import test from 'node:test';
import assert from 'node:assert/strict';
import {spawnSync} from 'node:child_process';
import {fileURLToPath} from 'node:url';

// Test-first: load only the planned production APIs. Missing modules are the
// expected missing capability; unrelated load/syntax failures still propagate.
async function plannedModule(name) {
  try { return await import(new URL(`../lib/${name}.mjs`, import.meta.url)); }
  catch (error) { if (error.code === 'ERR_MODULE_NOT_FOUND' && error.url?.endsWith(`/lib/${name}.mjs`)) return {}; throw error; }
}
const specification=await plannedModule('spec');
const comparison=await plannedModule('compare');
const reporting=await plannedModule('report');
const pipeline=await plannedModule('pipeline');
function capability(module,name) {
  assert.equal(typeof module[name],'function',`Missing shared ${name} capability; fixed Avatar scripts do not implement it`);
  return module[name];
}
const clone=value=>structuredClone(value);
function spec(component='roster-row') {
  return {version:1,component,title:'Строка участников',source:{url:'http://127.0.0.1:8094/ui-kit.html'},tolerances:{geometry:0.1,typography:0.01,baseline:0.5},scenarios:[
    {id:'mobile-default',viewport:{width:390,height:900,dpr:1},webSelector:'#c-row .roster-default',controls:[
      {id:'avatar',webSelector:'.flow-avatar',properties:['rect']},
      {id:'name',webSelector:'.flow-person strong',properties:['rect','fontSize','color','baseline']},
    ]},
  ]};
}
function frame() {
  return {id:'mobile-default',root:{x:0,y:0,width:342,height:72},controls:{
    avatar:{rect:{x:16,y:12,width:48,height:48}},
    name:{rect:{x:80,y:24,width:110,height:24},fontSize:18,color:'#f4f2eeff',baseline:42},
  },artifacts:{image:'web/mobile-default.png'}};
}
function compare(raw=spec(),web=frame(),native=frame()) {
  return capability(comparison,'compareScenario')(raw.scenarios[0],web,native,raw.tolerances);
}

// Validate the declaration, rather than requiring a bespoke capture per component.
test('accept a two-control roster declaration',()=>{
  const value=capability(specification,'validateSpec')(spec());
  assert.equal(value.component,'roster-row');assert.equal(value.scenarios[0].controls.length,2);
});
test('same schema accepts a component unrelated to Avatar',()=>{
  const value=capability(specification,'validateSpec')(spec('surface'));
  assert.equal(value.component,'surface');
});
for(const [name,mutate] of [
  ['duplicate scenario IDs',s=>s.scenarios.push(clone(s.scenarios[0]))],
  ['duplicate control IDs',s=>s.scenarios[0].controls.push(clone(s.scenarios[0].controls[0]))],
  ['missing web selector',s=>delete s.scenarios[0].webSelector],
  ['empty scenarios',s=>s.scenarios=[]],
  ['nonfinite viewport',s=>s.scenarios[0].viewport.width=Infinity],
  ['negative geometry tolerance',s=>s.tolerances.geometry=-1],
  ['unknown measured property',s=>s.scenarios[0].controls[0].properties=['inventedMetric']],
  ['path-like component ID',s=>s.component='../avatar'],
]) test(`reject ${name}`,()=>{
  const input=spec();mutate(input);
  const validate=capability(specification,'validateSpec');
  assert.throws(()=>validate(input));
});

test('equal root and every inner control pass',()=>{
  const result=compare();assert.equal(result.status,'pass');assert.deepEqual(result.findings,[]);
});
test('inner label shift fails even though root is identical',()=>{
  const native=frame();native.controls.name.rect.y+=5;
  const result=compare(spec(),frame(),native);
  assert.equal(result.status,'fail');
  assert.ok(result.findings.some(f=>f.control==='name'&&f.property==='rect.y'&&f.delta===5));
});
test('native natural height mismatch is not hidden by capture constraints',()=>{
  const native=frame();native.root.height=64;
  const result=compare(spec(),frame(),native);assert.equal(result.status,'fail');
  assert.ok(result.findings.some(f=>f.control==='root'&&f.property==='rect.height'));
});
test('geometry within explicitly declared tolerance passes',()=>{
  const native=frame();native.controls.avatar.rect.x+=0.05;assert.equal(compare(spec(),frame(),native).status,'pass');
});
test('baseline tolerance does not loosen geometry',()=>{
  const native=frame();native.controls.name.baseline+=0.17;
  assert.equal(compare(spec(),frame(),native).status,'pass');
  native.controls.name.rect.y+=0.3;assert.equal(compare(spec(),frame(),native).status,'fail');
});
test('typography is checked independently from root shape',()=>{
  const native=frame();native.controls.name.fontSize=20;
  const result=compare(spec(),frame(),native);assert.equal(result.status,'fail');
  assert.ok(result.findings.some(f=>f.property==='fontSize'&&f.control==='name'));
});
test('text color mismatch is not accepted by geometry tolerance',()=>{
  const native=frame();native.controls.name.color='#ffffffff';
  assert.equal(compare(spec(),frame(),native).status,'fail');
});
test('missing expected control produces a named failure',()=>{
  const native=frame();delete native.controls.name;
  const result=compare(spec(),frame(),native);assert.equal(result.status,'fail');
  assert.ok(result.findings.some(f=>f.control==='name'));
});
test('missing measured property fails closed',()=>{
  const native=frame();delete native.controls.name.fontSize;assert.equal(compare(spec(),frame(),native).status,'fail');
});
test('nonfinite measured rect fails closed',()=>{
  const native=frame();native.controls.name.rect.y=NaN;assert.equal(compare(spec(),frame(),native).status,'fail');
});
test('mismatched scenario identity cannot reuse stale measurements',()=>{
  const native=frame();native.id='old-run-scenario';assert.equal(compare(spec(),frame(),native).status,'fail');
});

test('report includes every case and inner-control findings',()=>{
  const input=spec();input.scenarios.push({...clone(input.scenarios[0]),id:'desktop-focus'});
  const html=capability(reporting,'renderReport')({spec:input,results:[
    {id:'mobile-default',status:'pass',findings:[],artifacts:{web:'web/a.png',flutter:'flutter/a.png',overlay:'overlay/a.png',diff:'diff/a.png'}},
    {id:'desktop-focus',status:'fail',findings:[{control:'name',property:'rect.y',expected:24,actual:29,delta:5,tolerance:0.1}],artifacts:{}},
  ]});
  for(const value of ['mobile-default','desktop-focus','name','rect.y','overlay/a.png','diff/a.png'])assert.ok(html.includes(value),`Missing ${value}`);
});
test('missing capture stays visible instead of dropping a scenario',()=>{
  const html=capability(reporting,'renderReport')({spec:spec(),results:[]});
  assert.ok(html.includes('mobile-default'));assert.match(html,/missing|отсутств|не получ|не захвачен/i);
});
test('report escapes fixture text and diagnostic markup',()=>{
  const input=spec();input.title='<script>unsafe()</script>';
  const html=capability(reporting,'renderReport')({spec:input,results:[]});
  assert.ok(!html.includes(input.title));assert.ok(html.includes('&lt;script&gt;'));
});

test('pipeline performs capture, comparison, report, cleanup in order',async()=>{
  const calls=[];
  const run=capability(pipeline,'runPipeline');
  const result=await run(spec(),{
    async captureWeb(){calls.push('web');return [frame()];},
    async captureFlutter(){calls.push('flutter');return [frame()];},
    async publishReport(payload){calls.push('report');assert.equal(payload.results[0].status,'pass');return '/tmp/report/index.html';},
    async close(){calls.push('cleanup');},
  });
  assert.equal(result.exitCode,0);assert.deepEqual(calls,['web','flutter','report','cleanup']);
});
test('pipeline comparison error returns nonzero and still publishes findings',async()=>{
  const native=frame();native.controls.name.rect.y+=5;let published;
  const result=await capability(pipeline,'runPipeline')(spec(),{
    async captureWeb(){return [frame()];},async captureFlutter(){return [native];},
    async publishReport(payload){published=payload;return '/tmp/report/index.html';},async close(){},
  });
  assert.notEqual(result.exitCode,0);assert.equal(published.results[0].status,'fail');
});
test('capture failure publishes diagnostics and closes owned resources',async()=>{
  const calls=[];
  const result=await capability(pipeline,'runPipeline')(spec(),{
    async captureWeb(){calls.push('web');throw new Error('font readiness timeout');},
    async captureFlutter(){calls.push('flutter');return [frame()];},
    async publishReport(payload){calls.push('report');assert.match(JSON.stringify(payload),/font readiness timeout/);return '/tmp/report/index.html';},
    async close(){calls.push('cleanup');},
  });
  assert.notEqual(result.exitCode,0);assert.deepEqual(calls,['web','report','cleanup']);
});
test('missing native scenario cannot produce a successful run',async()=>{
  let published;
  const result=await capability(pipeline,'runPipeline')(spec(),{
    async captureWeb(){return [frame()];},async captureFlutter(){return [];},
    async publishReport(payload){published=payload;return '/tmp/report/index.html';},async close(){},
  });
  assert.notEqual(result.exitCode,0);assert.equal(published.results.length,1);assert.equal(published.results[0].id,'mobile-default');assert.equal(published.results[0].status,'fail');
});
test('duplicate capture IDs are rejected, not overwritten',async()=>{
  const result=await capability(pipeline,'runPipeline')(spec(),{
    async captureWeb(){return [frame(),frame()];},async captureFlutter(){return [frame()];},
    async publishReport(){return '/tmp/report/index.html';},async close(){},
  });
  assert.notEqual(result.exitCode,0);
});
test('report failure still closes owned resources and returns failure',async()=>{
  let closed=false;
  const result=await capability(pipeline,'runPipeline')(spec(),{
    async captureWeb(){return [frame()];},async captureFlutter(){return [frame()];},
    async publishReport(){throw new Error('report write failed');},async close(){closed=true;},
  });
  assert.notEqual(result.exitCode,0);assert.equal(closed,true);
});
test('single-command CLI exposes help without starting captures',()=>{
  const file=fileURLToPath(new URL('../compare.mjs',import.meta.url));
  const result=spawnSync(process.execPath,[file,'--help'],{encoding:'utf8'});
  assert.equal(result.status,0,`Missing one-command CLI: ${result.stderr}`);assert.match(result.stdout,/component|компонент/i);
});

test('intentional control failure must match its declared finding',async()=>{
 const input=spec();input.scenarios[0].expectedFailure={control:'name',property:'rect.y'};
 const native=frame();native.controls.name.rect.y+=5;
 const result=await capability(pipeline,'runPipeline')(input,{async captureWeb(){return[frame()];},async captureFlutter(){return[native];},async publishReport(){return'/tmp/report';},async close(){}});
 assert.equal(result.exitCode,0);assert.equal(result.results[0].status,'fail');assert.equal(result.results[0].expectedFailureVerified,true);
});
test('intentional control cannot pass without detecting its defect',async()=>{
 const input=spec();input.scenarios[0].expectedFailure={control:'name',property:'rect.y'};
 const result=await capability(pipeline,'runPipeline')(input,{async captureWeb(){return[frame()];},async captureFlutter(){return[frame()];},async publishReport(){return'/tmp/report';},async close(){}});
 assert.notEqual(result.exitCode,0);
});
test('cleanup failure is included in the published report',async()=>{
 let published;
 const result=await capability(pipeline,'runPipeline')(spec(),{async captureWeb(){return[frame()];},async captureFlutter(){return[frame()];},async publishReport(payload){published=payload;return'/tmp/report';},async close(){throw Error('owned browser cleanup failed');}});
 assert.notEqual(result.exitCode,0);assert.match(JSON.stringify(published),/owned browser cleanup failed/);
});
