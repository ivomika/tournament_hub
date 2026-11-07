export function compareScenario(spec, web, native, tolerances={}) {
  const findings=[];
  const add=(control,property,expected,actual,tolerance=0)=>findings.push({control,property,expected,actual,delta:typeof expected==='number'&&typeof actual==='number'?Math.abs(expected-actual):null,tolerance});
  const check=(control,property,expected,actual,tolerance)=>{
    if(expected===undefined||actual===undefined||expected===null||actual===null){add(control,property,expected??'missing',actual??'missing',tolerance);return;}
    if(typeof expected==='number'){
      if(!Number.isFinite(expected)||!Number.isFinite(actual)||Math.abs(expected-actual)>tolerance)add(control,property,expected,actual,tolerance);
    }else if(expected!==actual)add(control,property,expected,actual,tolerance);
  };
  if(!web||!native||web.id!==spec.id||native.id!==spec.id)add('root','scenario.id',spec.id,`${web?.id??'missing'} / ${native?.id??'missing'}`);
  const geom=tolerances.geometry??0.1;
  for(const key of ['width','height'])check('root',`rect.${key}`,web?.root?.[key],native?.root?.[key],geom);
  for(const control of spec.controls){
    const a=web?.controls?.[control.id], b=native?.controls?.[control.id];
    if(!a||!b){add(control.id,'control','present',!a?'web missing':'Flutter missing');continue;}
    const limits={...tolerances,...control.tolerances};
    for(const property of control.properties){
      if(property==='rect'){
        for(const key of ['x','y','width','height'])check(control.id,`rect.${key}`,a.rect?.[key],b.rect?.[key],limits.geometry??geom);
      }else if(property==='center'){
        for(const [axis,dimension] of [['x','width'],['y','height']]){
          const ac=a.rect?.[axis]+a.rect?.[dimension]/2,bc=b.rect?.[axis]+b.rect?.[dimension]/2;
          check(control.id,`center.${axis}`,ac,bc,limits.geometry??geom);
        }
      }else {
        const limit=property==='baseline'?(limits.baseline??0.5):['fontSize','lineHeight','strokeWidth','radius','borderWidth','opacity'].includes(property)?(limits.typography??0.01):property==='width'||property==='height'?geom:0;
        check(control.id,property,a[property],b[property],limit);
      }
    }
  }
  return {id:spec.id,title:spec.title??spec.id,expectedFailure:spec.expectedFailure??null,status:findings.length?'fail':'pass',findings,web,native,artifacts:{web:`web/${spec.id}.png`,flutter:`flutter/${spec.id}.png`,overlay:`overlay/${spec.id}.png`,diff:`diff/${spec.id}.png`},raster:native?.raster??null};
}
