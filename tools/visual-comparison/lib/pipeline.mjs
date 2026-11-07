import {validateSpec} from './spec.mjs';
import {compareScenario} from './compare.mjs';
export async function runPipeline(raw,adapters) {
 let spec=raw,results=[],error=null,reportPath=null,exitCode=2;
 try {
  spec=validateSpec(raw);
  const web=await adapters.captureWeb(spec);
  const native=await adapters.captureFlutter(spec,web);
  for(const [name,frames] of [['web',web],['Flutter',native]]){
   if(!Array.isArray(frames))throw new Error(`${name}: missing measurements`);
   const ids=new Set();for(const frame of frames){if(ids.has(frame.id))throw new Error(`${name}: duplicate scenario ${frame.id}`);ids.add(frame.id);}
  }
  results=spec.scenarios.map(s=>compareScenario(s,web.find(f=>f.id===s.id),native.find(f=>f.id===s.id),spec.tolerances));
  for(const result of results){
   if(result.expectedFailure){const expected=result.expectedFailure;result.expectedFailureVerified=result.findings.some(f=>f.control===expected.control&&f.property===expected.property);}
  }
  exitCode=results.every(r=>r.expectedFailure?r.expectedFailureVerified:r.status==='pass')?0:1;
 }catch(failure){error=String(failure.message??failure);results=(spec.scenarios??[]).map(s=>({id:s.id,status:'fail',findings:[{control:'root',property:'capture',actual:error}]}));}
 try{reportPath=await adapters.publishReport({spec,results,error});}catch(failure){error=String(failure.message??failure);exitCode=2;}
 finally{try{await adapters.close();}catch(failure){error=String(failure.message??failure);exitCode=2;try{reportPath=await adapters.publishReport({spec,results,error});}catch{}}}
 return {exitCode,results,error,reportPath};
}
