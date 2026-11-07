import fs from 'node:fs/promises';
import {spawn} from 'node:child_process';
import path from 'node:path';
import os from 'node:os';
export class CaptureBrowser {
 constructor(){this.children=[];this.sequence=0;this.pending=new Map();}
 async open(root){
  try{const response=await fetch('http://127.0.0.1:8094/ui-kit.html');if(!response.ok)throw Error('not prototype');}
  catch{this.children.push(spawn(process.env.PYTHON??'python3',['tools/serve_prototype.py'],{cwd:root,stdio:'ignore'}));await this.until(async()=>{try{return(await fetch('http://127.0.0.1:8094/ui-kit.html')).ok;}catch{return false;}},15000,'prototype server');}
  this.profile=await fs.mkdtemp(path.join(os.tmpdir(),'th-compare-'));
  const executable=process.env.CHROME??(process.platform==='darwin'?'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome':process.platform==='win32'?'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe':'google-chrome');
  this.chrome=spawn(executable,['--headless=new','--disable-gpu','--no-first-run','--no-default-browser-check',`--user-data-dir=${this.profile}`,'--remote-debugging-port=0','about:blank'],{stdio:['ignore','ignore','pipe']});this.children.push(this.chrome);
  let endpoint='';let startupError;
  this.chrome.on('error',e=>startupError=e);this.chrome.stderr.on('data',b=>{const match=b.toString().match(/DevTools listening on (ws:\/\/[^\s]+)/);if(match)endpoint=match[1];});
  await this.until(()=>{if(startupError)throw startupError;return endpoint;},20000,'Chrome DevTools');
  const base=endpoint.replace('ws:','http:').replace(/\/devtools\/browser\/.*/, '');
  const pages=await(await fetch(`${base}/json`)).json();
  const page=pages.find(p=>p.type==='page');if(!page)throw Error('No capture page');
  this.ws=new WebSocket(page.webSocketDebuggerUrl);
  await new Promise((resolve,reject)=>{this.ws.addEventListener('open',resolve,{once:true});this.ws.addEventListener('error',reject,{once:true});});
  this.ws.onmessage=event=>{const message=JSON.parse(event.data);if(message.id){const task=this.pending.get(message.id);if(!task)return;this.pending.delete(message.id);clearTimeout(task.timer);message.error?task.reject(Error(JSON.stringify(message.error))):task.resolve(message.result);}};
  this.ws.onclose=()=>{for(const task of this.pending.values()){clearTimeout(task.timer);task.reject(Error('Capture browser closed'));}this.pending.clear();};
  await this.call('Page.enable');
 }
 async until(check,timeout,label){const start=Date.now();while(Date.now()-start<timeout){if(await check())return;await new Promise(r=>setTimeout(r,100));}throw Error(`${label} timeout`);}
 call(method,params={}){return new Promise((resolve,reject)=>{const id=++this.sequence;const timer=setTimeout(()=>{this.pending.delete(id);reject(Error(`${method} timeout`));},15000);this.pending.set(id,{resolve,reject,timer});this.ws.send(JSON.stringify({id,method,params}));});}
 async evaluate(expression){const result=await this.call('Runtime.evaluate',{expression,awaitPromise:true,returnByValue:true});if(result.exceptionDetails)throw Error(JSON.stringify(result.exceptionDetails));return result.result.value;}
 async capture(spec,output){
  const frames=[];
  for(const scenario of spec.scenarios){
   console.log(`  Web ${scenario.id}`);
   await this.call('Emulation.setDeviceMetricsOverride',{width:scenario.viewport.width,height:scenario.viewport.height,deviceScaleFactor:scenario.viewport.dpr,mobile:false});
   await this.call('Page.navigate',{url:`${spec.source.url}?comparison=${encodeURIComponent(scenario.id)}-${Date.now()}`});
   if(scenario.webOpenSelector){
    await this.until(()=>this.evaluate(`!!document.querySelector(${JSON.stringify(scenario.webOpenSelector)})`),15000,scenario.id+' trigger');
    await this.evaluate(`document.querySelector(${JSON.stringify(scenario.webOpenSelector)}).click()`);
   }
   await this.until(()=>this.evaluate(`!!document.querySelector(${JSON.stringify(scenario.webSelector)})`),15000,scenario.id);
   await this.evaluate('document.fonts.ready.then(()=>true)');
   const frame=await this.evaluate(`(${measure.toString()})(${JSON.stringify(scenario)})`);
   const padding=scenario.capturePadding??0;
   const shot=await this.call('Page.captureScreenshot',{format:'png',captureBeyondViewport:true,clip:{x:frame.pageX-padding,y:frame.pageY-padding,width:Math.ceil(frame.root.width+padding*2),height:Math.ceil(frame.root.height+padding*2),scale:1}});
   await fs.writeFile(path.join(output,'web',`${scenario.id}.png`),Buffer.from(shot.data,'base64'));frames.push(frame);
  }
  return frames;
 }
 async close(){
  if(this.ws){this.ws.onclose=null;for(const task of this.pending.values())clearTimeout(task.timer);this.pending.clear();this.ws.close();}
  for(const child of this.children.reverse())if(child.exitCode===null)child.kill('SIGTERM');
  if(this.profile)await fs.rm(this.profile,{recursive:true,force:true,maxRetries:4,retryDelay:200});
 }
}
// Executed in the source page. No CSS/layout values are recreated here.
function measure(scenario){
 const root=document.querySelector(scenario.webSelector);if(!root)throw Error('Missing root');
 if(scenario.webClass)root.classList.add(...scenario.webClass.split(' '));
 if(scenario.webText!==undefined)root.textContent=scenario.webText;
 for(const animation of document.getAnimations()){animation.pause();animation.currentTime=scenario.freezeMilliseconds??0;}
 const original=root.getBoundingClientRect();
 const captureInset=scenario.capturePadding??0;
 const mask=document.createElement('div');Object.assign(mask.style,{position:'fixed',inset:'0',width:Math.max(innerWidth,original.width+captureInset*2)+'px',height:Math.max(innerHeight,original.height+captureInset*2)+'px',background:getComputedStyle(document.body).backgroundColor,zIndex:'2147483646'});document.body.append(mask);
 // Normalize only capture placement. Keep the original DOM ancestry, SVG
 // symbols, state classes and measured width; never replace component CSS.
 root.style.position='fixed';root.style.left='0px';root.style.top='0px';root.style.margin='0px';root.style.width=`${original.width}px`;root.style.zIndex='2147483647';
 for(let parent=root.parentElement;parent&&parent!==document.body;parent=parent.parentElement)parent.style.overflow='visible';
 let placed=root.getBoundingClientRect();root.style.left=`${captureInset-placed.left}px`;root.style.top=`${captureInset-placed.top}px`;
 const r=root.getBoundingClientRect();
 if(Math.abs(r.width-original.width)>0.25||Math.abs(r.height-original.height)>0.25)throw Error('Isolation changed source component dimensions');
 const rect=(box)=>({x:box.left-r.left,y:box.top-r.top,width:box.width,height:box.height});
 const color=value=>{const m=value.match(/[\d.]+/g);if(!m||m.length<3)return value;return '#'+m.slice(0,3).map(v=>Math.round(Number(v)).toString(16).padStart(2,'0')).join('')+Math.round((m[3]===undefined?1:Number(m[3]))*255).toString(16).padStart(2,'0');};
 const controls={};
 for(const control of scenario.controls){
  const node=control.webSelector===':scope'?root:root.querySelector(control.webSelector);if(!node)continue;
  const c=getComputedStyle(node,control.webPseudo??null);let box=node.getBoundingClientRect();if(control.webPseudo){const left=parseFloat(c.left)||0,top=parseFloat(c.top)||0;box={left:box.left+left,top:box.top+top,width:parseFloat(c.width),height:parseFloat(c.height)};}const range=document.createRange();range.selectNodeContents(node);if(control.textRange){const text=[...node.childNodes].find(n=>n.nodeType===Node.TEXT_NODE&&n.textContent.trim());if(text)range.selectNodeContents(text);}const rangeBox=range.getBoundingClientRect();
  const context=document.createElement('canvas').getContext('2d');context.font=`${c.fontStyle} ${c.fontWeight} ${c.fontSize} ${c.fontFamily}`;const font=context.measureText(node.textContent??'');
  if(node.textContent?.trim()&&!document.fonts.check(c.font))throw Error(`Font not ready for ${control.id}`);
  const radius=c.borderTopLeftRadius.endsWith('%')?Math.min(box.width,box.height)*parseFloat(c.borderTopLeftRadius)/100:parseFloat(c.borderTopLeftRadius);
  controls[control.id]={rect:rect(control.textRange?rangeBox:box),width:control.textRange?rangeBox.width:box.width,height:control.textRange?rangeBox.height:box.height,fontSize:parseFloat(c.fontSize),fontWeight:parseInt(c.fontWeight),lineHeight:c.lineHeight==='normal'?null:parseFloat(c.lineHeight)/parseFloat(c.fontSize),color:color(c.color),background:color(c.backgroundColor),radius:Math.min(radius,Math.min(box.width,box.height)/2),borderWidth:parseFloat(c.borderTopWidth),borderColor:color(c.borderTopColor),baseline:rangeBox.top-r.top+font.fontBoundingBoxAscent,opacity:parseFloat(c.opacity),strokeWidth:parseFloat(c.strokeWidth)};
  if(node instanceof HTMLInputElement || node instanceof HTMLTextAreaElement || node instanceof HTMLSelectElement){
   const lines=node.value.split('\n');const metrics=lines.map(line=>context.measureText(line));
   const lineHeight=c.lineHeight==='normal'?font.fontBoundingBoxAscent+font.fontBoundingBoxDescent:parseFloat(c.lineHeight);
   const ascent=context.measureText('Hg').fontBoundingBoxAscent,descent=context.measureText('Hg').fontBoundingBoxDescent;
   const top=node instanceof HTMLTextAreaElement ? box.top+parseFloat(c.borderTopWidth)+parseFloat(c.paddingTop) : box.top+(box.height-lineHeight)/2;
   controls[control.id].baseline=top-r.top+(lineHeight-ascent-descent)/2+ascent;
   if(control.textRange)controls[control.id].width=Math.max(0,...metrics.map(m=>m.width));
  }

 }
 return {id:scenario.id,root:{x:0,y:0,width:r.width,height:r.height},controls,originalRoot:{width:original.width,height:original.height},pageX:r.left+scrollX,pageY:r.top+scrollY,artifacts:{image:`web/${scenario.id}.png`}};
}
