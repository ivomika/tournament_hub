const properties = new Set(['rect','center','width','height','fontSize','fontWeight','lineHeight','color','background','radius','borderWidth','borderColor','baseline','strokeWidth','opacity']);
export function validateSpec(raw) {
  const fail = path => {throw new Error(`Invalid comparison specification: ${path}`);};
  if(raw?.version!==1)fail('version');
  if(!/^[a-z][a-z0-9-]*$/.test(raw.component??''))fail('component');
  if(typeof raw.source?.url!=='string' || !/^https?:\/\//.test(raw.source.url))fail('source.url');
  for(const [key,value] of Object.entries(raw.tolerances??{}))if(!Number.isFinite(value)||value<0)fail(`tolerances.${key}`);
  if(!Array.isArray(raw.scenarios)||!raw.scenarios.length)fail('scenarios');
  const ids=new Set();
  for(const scenario of raw.scenarios){
    if(!/^[a-z0-9][a-z0-9-]*$/.test(scenario.id??'')||ids.has(scenario.id))fail('scenario.id');ids.add(scenario.id);
    if(typeof scenario.webSelector!=='string'||!scenario.webSelector.trim())fail(`${scenario.id}.webSelector`);
    if(scenario.webOpenSelector!==undefined && (typeof scenario.webOpenSelector!=='string'||!scenario.webOpenSelector.trim()))fail(`${scenario.id}.webOpenSelector`);
    for(const key of ['width','height','dpr'])if(!Number.isFinite(scenario.viewport?.[key])||scenario.viewport[key]<=0)fail(`${scenario.id}.viewport.${key}`);
    if(!Array.isArray(scenario.controls))fail(`${scenario.id}.controls`);
    const names=new Set();
    for(const control of scenario.controls){
      if(!control.id||names.has(control.id))fail(`${scenario.id}.control.id`);names.add(control.id);
      if(control.webPseudo!==undefined && !['::before','::after'].includes(control.webPseudo))fail(`${control.id}.webPseudo`);
      if(typeof control.webSelector!=='string')fail(`${control.id}.webSelector`);
      if(!Array.isArray(control.properties)||!control.properties.length||control.properties.some(p=>!properties.has(p)))fail(`${control.id}.properties`);
      for(const [key,value] of Object.entries(control.tolerances??{}))if(!Number.isFinite(value)||value<0)fail(`${control.id}.tolerances.${key}`);
    }
  }
  return structuredClone(raw);
}
