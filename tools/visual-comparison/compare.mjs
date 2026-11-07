#!/usr/bin/env node
import fs from 'node:fs/promises';
import path from 'node:path';
import os from 'node:os';
import {fileURLToPath} from 'node:url';
import {spawn} from 'node:child_process';
import {CaptureBrowser} from './lib/browser.mjs';
import {runPipeline} from './lib/pipeline.mjs';
import {renderReport} from './lib/report.mjs';
const args=process.argv.slice(2);
if(args.includes('--help')||!args.length){console.log('Usage: node tools/visual-comparison/compare.mjs <component> [--update-goldens]\nOne command exports declarations, captures Web/Flutter, compares controls and publishes a report.');process.exit(0);}
const component=args[0];if(!/^[a-z][a-z0-9-]*$/.test(component))throw Error('Invalid component ID');
const root=fileURLToPath(new URL('../../',import.meta.url));
const work=await fs.mkdtemp(path.join(os.tmpdir(),`th-visual-${component}-`));
const browser=new CaptureBrowser();
const runId=new Date().toISOString();
const output=path.join(root,'docs/design/prototype/comparison',component);
const app=path.join(root,'apps/tournament_app');
async function flutter(mode){
 await new Promise((resolve,reject)=>{
  const command=process.env.FLUTTER??'flutter';
  const child=spawn(command,['test','--no-pub',...(mode==='capture'&&args.includes('--update-goldens')?['--update-goldens']:[]),'test/visual_comparison/component_comparison_test.dart',`--dart-define=VC_COMPONENT=${component}`,`--dart-define=VC_MODE=${mode}`,`--dart-define=VC_RUN_DIR=${work}`],{cwd:app,stdio:'inherit'});
  child.once('error',reject);child.once('exit',code=>code===0?resolve():reject(Error(`Flutter ${mode} failed (exit ${code})`)));
 });
}
async function publishReport(payload){
 await fs.writeFile(path.join(work,'results.json'),JSON.stringify({...payload,runId},null,2));
 await fs.writeFile(path.join(work,'index.html'),renderReport({...payload,runId}));
 const temporary=`${output}.publishing`;await fs.rm(temporary,{recursive:true,force:true});await fs.cp(work,temporary,{recursive:true});await fs.rm(output,{recursive:true,force:true});await fs.rename(temporary,output);return `${output}/index.html`;
}
let spec;
try{
 await flutter('manifest');spec=JSON.parse(await fs.readFile(path.join(work,'spec.json'),'utf8'));
 for(const dir of ['web','flutter','overlay','diff'])await fs.mkdir(path.join(work,dir),{recursive:true});
 const result=await runPipeline(spec,{
  async captureWeb(current){await browser.open(root);const frames=await browser.capture(current,work);await fs.writeFile(path.join(work,'web.json'),JSON.stringify(frames,null,2));return frames;},
  async captureFlutter(){await flutter('capture');return JSON.parse(await fs.readFile(path.join(work,'native.json'),'utf8'));},
  publishReport,
  async close(){await browser.close();},
 });
 console.log(`Comparison ${component}: ${result.exitCode===0?'PASS':'FAIL'} → http://127.0.0.1:8094/comparison/${component}/index.html`);
 if(result.error)console.error(result.error);
 process.exitCode=result.exitCode;
}catch(failure){
 const error=String(failure.message??failure);
 await publishReport({spec:spec??{component,title:component,source:{url:'http://127.0.0.1:8094/ui-kit.html'},scenarios:[]},results:[],error});
 console.error(error);process.exitCode=2;
}finally{await browser.close();await fs.rm(work,{recursive:true,force:true});}
