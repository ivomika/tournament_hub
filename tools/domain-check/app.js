const domainMap = (() => {
  const state = {data:null, mode:'overview', area:null, selected:null, method:null, zoom:1, areaScroll:null, areaLayout:null};
  const byId = id => document.getElementById(id);
  const viewport=byId('viewport'),stage=byId('stage'),stageShell=byId('stage-shell');
  const nodesEl=byId('nodes'),edgesEl=byId('edges'),details=byId('details'),hullsEl=byId('branch-hulls');
  const point=new Map();
  const escapeHtml = value => String(value ?? '').replace(/[&<>"']/g, char => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[char]));
  const displayArea = area => area.split('_').map(part => part.charAt(0).toUpperCase()+part.slice(1)).join(' ');
  const label = node => node.name || node.id;
  const nodesInArea = area => state.data.nodes.filter(node => node.area===area);
  const selectedNode = () => state.data.nodes.find(node => node.id===state.selected);
  function setZoom(value){state.zoom=Math.min(2,Math.max(.25,value));stage.style.transform=`scale(${state.zoom})`;stageShell.style.width=`${Number(stage.dataset.width||900)*state.zoom}px`;stageShell.style.height=`${Number(stage.dataset.height||700)*state.zoom}px`;byId('zoom-value').textContent=`${Math.round(state.zoom*100)}%`}
  function fit(){setZoom(Math.min(1,Math.max(.25,(viewport.clientWidth-26)/Number(stage.dataset.width||900))))}
  function node(id,x,y,name,kind,subtitle){const satellite=kind==='area'&&state.mode!=='overview'&&id!==state.area;point.set(id,{x,y,kind:satellite?'satellite':kind});const button=document.createElement('button');button.type='button';button.className=`node ${kind||''} ${state.selected===id?'selected':''}`;if(satellite)button.classList.add('satellite');button.dataset.node=id;button.style.left=`${x}px`;button.style.top=`${y}px`;button.title=name;button.innerHTML=`<strong>${escapeHtml(kind==='area'?displayArea(name):name)}</strong><small>${escapeHtml(subtitle||'')}</small>`;nodesEl.appendChild(button);return button}
  function edge(a,b,kind,count,secondary=false){const p=point.get(a),q=point.get(b);if(!p||!q)return;const dx=q.x-p.x,dy=q.y-p.y,distance=Math.hypot(dx,dy);if(distance<1)return;const ux=dx/distance,uy=dy/distance,px=-uy*5,py=ux*5;const border=n=>{if(['object','method','failure','boundary'].includes(n.kind))return n.hub?19:11;const w=n.kind==='area'?102:n.kind==='satellite'?63:90;const h=n.kind==='satellite'?25:36;return Math.min(w/(Math.abs(ux)||.001),h/(Math.abs(uy)||.001))+4};const c1=Math.min(border(p),distance*.47),c2=Math.min(border(q),distance*.47);const x1=p.x+ux*c1+px,y1=p.y+uy*c1+py,x2=q.x-ux*c2+px,y2=q.y-uy*c2+py;const path=document.createElementNS('http://www.w3.org/2000/svg','path');path.setAttribute('class',`${kind}${secondary?' secondary':''}`);path.setAttribute('d',`M${x1} ${y1} L${x2} ${y2}`);if(!secondary&&kind!=='unknown')path.setAttribute('marker-end',`url(#arrow-${kind})`);if(count)path.setAttribute('aria-label',`${count} связей`);edgesEl.appendChild(path)}
  function clear(height,width=900){point.clear();nodesEl.replaceChildren();hullsEl.replaceChildren();edgesEl.innerHTML='<defs><marker id="arrow-type" viewBox="0 0 8 8" refX="7" refY="4" markerWidth="7" markerHeight="7" orient="auto"><path d="M0 0 L8 4 L0 8 Z" fill="var(--blue)"/></marker><marker id="arrow-call" viewBox="0 0 8 8" refX="7" refY="4" markerWidth="7" markerHeight="7" orient="auto"><path d="M0 0 L8 4 L0 8 Z" fill="var(--gold)"/></marker><marker id="arrow-throw" viewBox="0 0 8 8" refX="7" refY="4" markerWidth="7" markerHeight="7" orient="auto"><path d="M0 0 L8 4 L0 8 Z" fill="var(--red)"/></marker></defs>';stage.style.height=`${height}px`;stage.style.width=`${width}px`;stage.dataset.height=height;stage.dataset.width=width;edgesEl.setAttribute('viewBox',`0 0 ${width} ${height}`);stageShell.style.width=`${width*state.zoom}px`;stageShell.style.height=`${height*state.zoom}px`}
  function areaPairs(){const pairs=new Map();for(const e of state.data.edges.filter(x=>x.kind==='type')){const from=state.data.nodes.find(n=>n.id===e.from),to=state.data.nodes.find(n=>n.id===e.to);if(!from||!to||from.area===to.area)continue;const key=`${from.area}|${to.area}`;pairs.set(key,(pairs.get(key)||0)+1)}return pairs}
  function drawOverview(){clear(710);byId('cluster').hidden=true;const areas=state.data.areas;const center=state.area||'tournament';const ordered=[center,...areas.filter(a=>a!==center)];node(center,450,350,displayArea(center),'area','область domain');const others=ordered.slice(1);others.forEach((area,i)=>{const angle=(i/others.length)*Math.PI*2-Math.PI/2;node(area,450+305*Math.cos(angle),350+258*Math.sin(angle),displayArea(area),'area',`${nodesInArea(area).length} объявлений`)});for(const [pair,count] of areaPairs()){const [a,b]=pair.split('|');edge(a,b,'type',count)}byId('graph-status').textContent=`${areas.length} областей · ${state.data.nodes.length} объявлений`;}
  function drawArea(){
    const entries=nodesInArea(state.area);
    const ids=new Set(entries.map(entry=>entry.id));
    const realEdges=state.data.edges.filter(e=>e.kind==='type'&&ids.has(e.from)&&ids.has(e.to));
    const layout=DomainGraphLayout.layoutGraph(entries,realEdges);
    state.areaLayout=layout;
    clear(layout.height,layout.width);
    byId('cluster').hidden=true;
    const satellites=state.data.areas.filter(area=>area!==state.area);
    satellites.forEach((area,i)=>{
      const x=170+i*((layout.width-340)/Math.max(1,satellites.length-1));
      node(area,x,45,area,'area','');
    });
    node(state.area,layout.width/2,92,state.area,'area','нажмите, чтобы свернуть');
    for(const group of layout.clusters){
      const positions=group.members.map(id=>layout.positions.get(id)).filter(Boolean);
      const xs=positions.map(p=>p.x),ys=positions.map(p=>p.y);
      const hull=document.createElement('div');
      hull.className='branch-hull';
      Object.assign(hull.style,{
        left:`${Math.min(...xs)-78}px`,top:`${Math.min(...ys)-82}px`,
        width:`${Math.max(...xs)-Math.min(...xs)+156}px`,
        height:`${Math.max(...ys)-Math.min(...ys)+164}px`,
      });
      hullsEl.appendChild(hull);
    }
    for(const entry of entries){
      const p=layout.positions.get(entry.id);
      const button=node(entry.id,p.x,p.y,entry.name,'object',entry.kind);
      if(entry.id===layout.hub){button.classList.add('hub');point.get(entry.id).hub=true}
    }
    const selected=state.selected;
    const related=selected?realEdges.filter(e=>e.from===selected||e.to===selected):realEdges;
    for(const e of related){
      const pair=[e.from,e.to].sort().join('|');
      edge(e.from,e.to,'type',null,!selected&&!layout.treePairs.has(pair));
    }
    if(selected){
      for(const button of nodesEl.querySelectorAll('.node.object')){
        if(button.dataset.node!==selected&&!related.some(e=>e.from===button.dataset.node||e.to===button.dataset.node))button.classList.add('dimmed');
      }
    }
    const hub=entries.find(entry=>entry.id===layout.hub);
    byId('graph-status').textContent=`${displayArea(state.area)} · ${entries.length} объектов · центр ${hub?.name||'—'} (${layout.outgoingCount} исходящих зависимостей)`;
  }
  function reachable(methodId){const found=new Set([methodId]);const queue=[methodId];while(queue.length){const current=queue.shift();for(const e of state.data.edges.filter(edge=>edge.kind==='call'&&edge.from===current)){if(e.to&&!found.has(e.to)){found.add(e.to);queue.push(e.to)}}}return [...found]}
  function drawMethod(){
    const ids=reachable(state.method),owner=selectedNode();
    const methodMap=new Map(owner.methods.map(m=>[m.id,m]));
    const list=ids.filter(id=>methodMap.has(id));
    const throws=state.data.edges.filter(e=>e.kind==='throw'&&list.includes(e.from));
    const errorNames=[...new Set(throws.map(e=>e.to||`external:${e.externalName}`))];
    const unknownMethods=list.filter(id=>methodMap.get(id).unresolvedCalls.length);
    const unknownCount=unknownMethods.reduce((sum,id)=>sum+methodMap.get(id).unresolvedCalls.length,0);
    const missingImplementation=owner.kind==='interface'&&!owner.implementedBy?.length;
    const hasBoundary=unknownCount||missingImplementation;
    const callEdges=state.data.edges.filter(e=>e.kind==='call'&&list.includes(e.from)&&list.includes(e.to));
    const throwEdges=throws.map(e=>({from:e.from,to:e.to||`external:${e.externalName}`,kind:'throw'}));
    const unknownEdges=unknownMethods.map(id=>({from:id,to:'unknown-boundary',kind:'unknown'}));
    if(missingImplementation)unknownEdges.push({from:state.method,to:'unknown-boundary',kind:'unknown'});
    const graphEntries=[...list.map(id=>({id})),...errorNames.map(id=>({id})),...(hasBoundary?[{id:'unknown-boundary'}]:[])];
    const graphEdges=[...callEdges,...throwEdges,...unknownEdges];
    const layout=DomainGraphLayout.layoutGraph(graphEntries,graphEdges,state.method);
    state.methodLayout=layout;
    clear(layout.height,layout.width);
    byId('cluster').hidden=true;
    const satellites=state.data.areas.filter(a=>a!==state.area);
    satellites.forEach((area,i)=>{
      const x=170+i*((layout.width-340)/Math.max(1,satellites.length-1));
      node(area,x,45,area,'area','').classList.add('dimmed');
    });
    node(state.area,layout.width/2,92,state.area,'area','нажмите, чтобы свернуть');
    for(const id of list){
      const p=layout.positions.get(id),method=methodMap.get(id);
      const button=node(id,p.x,p.y,method.name,'method',method.signature);
      if(id===state.method){button.classList.add('hub');point.get(id).hub=true}
    }
    for(const id of errorNames){
      const p=layout.positions.get(id);
      node(id,p.x,p.y,id.startsWith('external:')?id.slice(9):(state.data.nodes.find(n=>n.id===id)?.name||id),'failure','исключение');
    }
    if(hasBoundary){
      const p=layout.positions.get('unknown-boundary');
      node('unknown-boundary',p.x,p.y,missingImplementation?'Реализация не установлена':'Продолжение не установлено','boundary',`${unknownCount} вызовов`);
    }
    for(const e of callEdges)edge(e.from,e.to,'call');
    for(const e of throwEdges)edge(e.from,e.to,'throw');
    for(const e of unknownEdges)edge(e.from,e.to,'unknown');
    byId('graph-status').textContent=`${owner.name}.${methodMap.get(state.method)?.name} · ${list.length} подтверждённых методов · ${errorNames.length} типов ошибок`;
  }
  function drawDetails(){const selected=selectedNode();if(state.mode==='overview'&&!selected){details.innerHTML='<span class="overline">Обзор</span><h2>Области domain</h2><p>Выберите область. Карта раскроет все её объявления без оценки «важности».</p>';return}if(state.mode==='area'&&!selected){const center=state.data.nodes.find(n=>n.id===state.areaLayout?.hub);details.innerHTML=`<span class="overline">Область</span><h2>${escapeHtml(displayArea(state.area))}</h2><p>${nodesInArea(state.area).length} объявлений. В центре — ${escapeHtml(center?.name||'—')}: он использует больше всего других объектов этой области (${state.areaLayout?.outgoingCount||0} исходящих зависимостей). Положение не означает важность. Выберите объект, чтобы увидеть поля, методы и связи.</p>`;return}if(!selected){details.innerHTML='<h2>Объект не найден</h2>';return}const incoming=state.data.edges.filter(e=>e.kind==='type'&&e.to===selected.id),outgoing=state.data.edges.filter(e=>e.kind==='type'&&e.from===selected.id);let html=`<span class="overline">${escapeHtml(selected.kind)} · ${escapeHtml(displayArea(selected.area))}</span><h2>${escapeHtml(selected.name)}</h2><p>${escapeHtml(selected.description||'Описание в исходном коде отсутствует.')}</p>`;if(state.mode==='method'){const m=selected.methods.find(x=>x.id===state.method);html+=`<h3>Выбранный метод</h3><div class="row">${escapeHtml(m?.signature||'')}</div>`;const unresolved=reachable(state.method).flatMap(id=>selected.methods.find(x=>x.id===id)?.unresolvedCalls||[]);if(unresolved.length)html+=`<details><summary>Продолжение не установлено · ${unresolved.length} вызовов</summary>${unresolved.map(x=>`<div class="row">${escapeHtml(x)}</div>`).join('')}</details>`;}
    if(selected.kind==='interface')html+=`<h3>Реализация контракта</h3><div class="row">${selected.implementedBy?.length?`${selected.implementedBy.length} прямых implements в domain`:'Прямой implements в domain не найден; реализация может быть во внешнем слое или отсутствовать.'}</div>`;
    html+=`<h3>Поля и значения</h3>${selected.fields.length?selected.fields.map(x=>`<div class="row">${escapeHtml(x)}</div>`).join(''):'<div class="row">Нет</div>'}`;
    html+=`<h3>Методы и конструкторы</h3>${selected.methods.length?selected.methods.map(m=>`<button class="row" data-method="${escapeHtml(m.id)}">${escapeHtml(m.name)}<small>${escapeHtml(m.signature)}</small></button>`).join(''):'<div class="row">Нет</div>'}`;
    for(const [heading,items,target] of [['Использует',outgoing,'to'],['Используется в',incoming,'from']])html+=`<h3>${heading}</h3>${items.length?items.map(e=>`<button class="row" data-object="${escapeHtml(e[target])}">${escapeHtml(state.data.nodes.find(n=>n.id===e[target])?.name||e[target])}</button>`).join(''):'<div class="row">Нет прямых связей</div>'}`;
    details.innerHTML=html;
    details.scrollTop=0;
  }
  function render(){byId('collapse').hidden=state.mode==='overview';byId('breadcrumbs').innerHTML='<button type="button" data-go="overview">Domain</button>'+(state.mode==='overview'?'':`<span>›</span><button type="button" data-go="area">${escapeHtml(state.area)}</button>`)+(state.mode==='method'?'<span>›</span><span>метод</span>':'');if(state.mode==='overview')drawOverview();else if(state.mode==='area')drawArea();else drawMethod();drawDetails();setZoom(state.zoom)}
  function goArea(area){state.area=area;state.mode='area';state.selected=null;state.method=null;render();fit();const center=state.areaLayout?.positions.get(state.areaLayout.hub);if(center)viewport.scrollTo({left:center.x*state.zoom-viewport.clientWidth/2,top:center.y*state.zoom-viewport.clientHeight/2})}
  function enterMethod(id){if(state.mode!=='method')state.areaScroll={left:viewport.scrollLeft,top:viewport.scrollTop,zoom:state.zoom};state.method=id;state.mode='method';render();fit();const center=state.methodLayout?.positions.get(id);if(center)viewport.scrollTo({left:center.x*state.zoom-viewport.clientWidth/2,top:center.y*state.zoom-viewport.clientHeight/2})}
  function leaveMethod(){state.mode='area';state.method=null;render();if(state.areaScroll){setZoom(state.areaScroll.zoom);viewport.scrollTo(state.areaScroll)}}
  nodesEl.addEventListener('click',event=>{const button=event.target.closest('[data-node]');if(!button)return;const id=button.dataset.node;if(state.data.areas.includes(id)){if(state.mode!=='overview'&&id===state.area){state.mode='overview';state.selected=null;state.method=null;render()}else goArea(id);return}if(id.includes('::')){enterMethod(id);return}const entry=state.data.nodes.find(n=>n.id===id);if(entry){state.area=entry.area;state.selected=id;state.mode='area';state.method=null;render()}});
  details.addEventListener('click',event=>{const method=event.target.closest('[data-method]');if(method){enterMethod(method.dataset.method);return}const object=event.target.closest('[data-object]');if(object){const n=state.data.nodes.find(x=>x.id===object.dataset.object);if(n){state.area=n.area;state.selected=n.id;state.mode='area';state.method=null;render()}}});
  byId('breadcrumbs').addEventListener('click',event=>{const go=event.target.closest('[data-go]');if(!go)return;if(go.dataset.go==='overview'){state.mode='overview';state.selected=null;state.method=null;render()}else if(state.mode==='method'){leaveMethod()}else{state.mode='area';state.method=null;render()}});
  byId('collapse').addEventListener('click',()=>{if(state.mode==='method')leaveMethod();else{state.mode='overview';state.selected=null;render()}});
  byId('zoom-in').addEventListener('click',()=>setZoom(state.zoom+.1));byId('zoom-out').addEventListener('click',()=>setZoom(state.zoom-.1));byId('zoom-fit').addEventListener('click',fit);
  document.addEventListener('keydown',event=>{if(event.key!=='Escape')return;if(state.mode==='method')leaveMethod();else if(state.mode==='area'){state.mode='overview';state.selected=null;render()}});
  let drag=null;viewport.addEventListener('pointerdown',event=>{if(event.button!==0||event.target.closest('button'))return;drag={x:event.clientX,y:event.clientY,left:viewport.scrollLeft,top:viewport.scrollTop};viewport.classList.add('dragging');viewport.setPointerCapture(event.pointerId)});viewport.addEventListener('pointermove',event=>{if(!drag)return;viewport.scrollLeft=drag.left-(event.clientX-drag.x);viewport.scrollTop=drag.top-(event.clientY-drag.y)});viewport.addEventListener('pointerup',()=>{drag=null;viewport.classList.remove('dragging')});
  fetch('domain-architecture.json').then(r=>{if(!r.ok)throw Error(`HTTP ${r.status}`);return r.json()}).then(data=>{if(data.schemaVersion!==1)throw Error('Неизвестная версия схемы');state.data=data;render();fit()}).catch(error=>{byId('graph-status').textContent=`Не удалось открыть карту: ${error.message}`;details.innerHTML='<h2>Данные недоступны</h2><p>Запустите make domain-check-generate, затем make domain-check.</p>'});
  return state;
})();
