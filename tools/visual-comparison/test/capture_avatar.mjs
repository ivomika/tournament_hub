import fs from 'node:fs/promises';
const pages = await (await fetch('http://127.0.0.1:9226/json')).json();
const page = pages.find(p=>p.type==='page');
const ws = new WebSocket(page.webSocketDebuggerUrl);
await new Promise(resolve=>ws.addEventListener('open',resolve,{once:true}));
let id=0;const pending=new Map();
ws.onmessage=e=>{const m=JSON.parse(e.data);if(m.id){const {resolve,reject}=pending.get(m.id);pending.delete(m.id);m.error?reject(m.error):resolve(m.result);}};
function call(method,params={}) {return new Promise((resolve,reject)=>{const n=++id;pending.set(n,{resolve,reject});ws.send(JSON.stringify({id:n,method,params}));});}
async function evaluate(expression){const r=await call('Runtime.evaluate',{expression,awaitPromise:true,returnByValue:true});if(r.exceptionDetails)throw r.exceptionDetails;return r.result.value;}
// Fixed Avatar visual-fixture capture, not a generic production comparison tool.
const root = new URL('../../../docs/design/prototype/comparison/avatar/', import.meta.url);
await fs.mkdir(new URL('web/',root),{recursive:true});
await call('Page.enable');
const scenarios=[];
for (const width of [390,1440]) {
 await call('Emulation.setDeviceMetricsOverride',{width,height:900,deviceScaleFactor:1,mobile:false});
 await call('Page.navigate',{url:`http://127.0.0.1:8094/ui-kit.html?avatar-capture=${width}#c-avatar`});
 for(let n=0;n<100;n++){if(await evaluate('!!document.querySelector("#c-avatar .flow-avatar")'))break;await new Promise(r=>setTimeout(r,100));}
 await evaluate('document.fonts.ready.then(()=>true)');
 const samples=await evaluate(`Array.from(document.querySelectorAll('#c-avatar .kit-component')).flatMap(section=>Array.from(section.querySelectorAll('.kit-component-states .kit-specimen')).slice(0,2).map((s,i)=>{const a=s.querySelector('[data-kit-part="Avatar"]');return {size:parseInt(section.querySelector('h4').textContent.split('·')[1]),shape:i?'round':'tile',html:a.closest('.kit-avatar-size').outerHTML};}))`);
 for (const sample of samples) {
  const viewport=width===390?'mobile':'desktop';
  const id=`${viewport}-${sample.size}-${sample.shape}`;
  const html=`<div class="kit-scope ${viewport==='desktop'?'desktop-gallery':''}"><div class="kit-context flow-screen ${viewport==='desktop'?'desktop-screen':''}" style="padding:0;margin:0;border:0;width:${sample.size}px;height:${sample.size}px;min-height:0;position:relative">${sample.html}</div></div>`;
  await evaluate(`document.body.innerHTML=${JSON.stringify(html)};document.body.style.margin='0';document.body.style.padding='0';document.documentElement.style.scrollBehavior='auto';window.scrollTo(0,0);`);
  const metrics=await evaluate(`(()=>{const a=document.querySelector('[data-kit-part="Avatar"]');const c=getComputedStyle(a);const r=a.getBoundingClientRect();const range=document.createRange();range.selectNodeContents(a);const t=range.getBoundingClientRect();const ctx=document.createElement('canvas').getContext('2d');ctx.font=c.fontStyle+' '+c.fontWeight+' '+c.fontSize+' '+c.fontFamily;const m=ctx.measureText(a.textContent);return {baseline:(r.height-m.fontBoundingBoxAscent-m.fontBoundingBoxDescent)/2+m.fontBoundingBoxAscent,fontAscent:m.fontBoundingBoxAscent,fontDescent:m.fontBoundingBoxDescent,initials:a.textContent,x:r.x,y:r.y,width:r.width,height:r.height,fontFamily:c.fontFamily,fontSize:parseFloat(c.fontSize),fontWeight:c.fontWeight,lineHeight:parseFloat(c.lineHeight),letterSpacing:c.letterSpacing,color:c.color,background:c.backgroundColor,radius:c.borderRadius,border:c.borderWidth,textRange:{x:t.x-r.x,y:t.y-r.y,width:t.width,height:t.height},fontLoaded:document.fonts.check(c.font)}})()`);
  if(metrics.x!==0 || metrics.y!==0 || metrics.width!==sample.size || metrics.height!==sample.size || !metrics.fontLoaded) throw new Error(`Invalid isolated source ${id}: ${JSON.stringify(metrics)}`);
  const snap=await call('Page.captureScreenshot',{format:'png',captureBeyondViewport:true,clip:{x:0,y:0,width:sample.size,height:sample.size,scale:1}});
  await fs.writeFile(new URL(`web/${id}.png`,root),Buffer.from(snap.data,'base64'));
  scenarios.push({id,viewport,size:sample.size,shape:sample.shape,...metrics});
 }
}
const version=await call('Browser.getVersion');
await fs.writeFile(new URL('web-metrics.json',root),JSON.stringify({source:'http://127.0.0.1:8094/ui-kit.html#c-avatar',browser:version.product,dpr:1,scenarios},null,2));
console.log(`Captured ${scenarios.length} original Avatar samples; fonts ready, all bounds verified.`);
ws.close();
