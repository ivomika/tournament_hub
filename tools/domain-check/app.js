const domainMap = (() => {
  const areaColors = {
    character_assignment:'#d9a0c5', game:'#91b2ec', history:'#dda083',
    profile:'#8ccbb0', statistics:'#79c5d5', tournament:'#e4bc78',
    tournament_format:'#b4a1e8',
  };
  const state = {data:null, mode:'overview', area:null, selected:null, method:null, zoom:1, areaScroll:null, areaLayout:null, overviewLayout:null, overviewDegree:null, methodReturnMode:null, moved:new Map(), kindFilter:new Set()};
  const byId = id => document.getElementById(id);
  const viewport=byId('viewport'),stage=byId('stage'),stageShell=byId('stage-shell');
  const nodesEl=byId('nodes'),edgesEl=byId('edges'),details=byId('details');
  const point=new Map();
  const edgePaths=[];
  const escapeHtml = value => String(value ?? '').replace(/[&<>"']/g, char => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[char]));
  const displayArea = area => area.split('_').map(part => part.charAt(0).toUpperCase()+part.slice(1)).join(' ');
  function radialPath(radius,steps=96,reverse=false){
    const points=Array.from({length:steps},(_,index)=>{
      const angle=-Math.PI/2+2*Math.PI*(reverse?steps-index:index)/steps;
      const distance=radius(angle);
      return `${(50+Math.cos(angle)*distance).toFixed(2)} ${(50+Math.sin(angle)*distance).toFixed(2)}`;
    });
    return `M${points.join(' L')} Z`;
  }
  const glyphs={
    'class':'<circle class="shape-fill" cx="50" cy="50" r="40"/>',
    'sealed class':`<path class="shape-fill" d="${radialPath(angle=>40/Math.pow(Math.pow(Math.abs(Math.cos(angle)),4)+Math.pow(Math.abs(Math.sin(angle)),4),.25))}"/><path class="shape-rim" d="${radialPath(angle=>32/Math.pow(Math.pow(Math.abs(Math.cos(angle)),4)+Math.pow(Math.abs(Math.sin(angle)),4),.25))}"/>`,
    'abstract class':'<circle class="shape-fill" cx="50" cy="50" r="32"/><path class="shape-orbit" d="M 12 35 A 41 41 0 1 0 88 35"/>',
    'interface':`<path class="shape-fill shape-ring" fill-rule="evenodd" d="${radialPath(angle=>39+2.8*Math.cos(6*angle),192)} ${radialPath(angle=>25+1.7*Math.cos(6*angle),192,true)}"/>`,
    'enum':`<path class="shape-fill" d="${radialPath(angle=>31+10*Math.cos(4*angle))}"/>`,
  };
  const glyph = kind => `<svg class="node-symbol" viewBox="0 0 100 100" aria-hidden="true">${glyphs[kind]||glyphs.class}</svg>`;
  for(const [kind,selector] of Object.entries({'class':'.node-legend .class','sealed class':'.node-legend .sealed','abstract class':'.node-legend .abstract','interface':'.node-legend .interface','enum':'.node-legend .enum'})){
    const icon=document.querySelector(selector);
    if(icon)icon.innerHTML=glyph(kind);
  }
  const label = node => node.name || node.id;
  const nodesInArea = area => state.data.nodes.filter(node => node.area===area);
  const selectedNode = () => state.data.nodes.find(node => node.id===state.selected);
  function setZoom(value){state.zoom=Math.min(2,Math.max(.08,value));stage.style.transform=`scale(${state.zoom})`;stageShell.style.width=`${Number(stage.dataset.width||900)*state.zoom}px`;stageShell.style.height=`${Number(stage.dataset.height||700)*state.zoom}px`;stage.dataset.detail=state.mode==='overview'?(state.zoom<.28?'far':state.zoom<.7?'mid':state.zoom<1.2?'near':'deep'):'deep';stage.style.setProperty('--inverse-zoom',String(1/state.zoom));byId('zoom-value').textContent=`${Math.round(state.zoom*100)}%`}
  function fit(){const width=(viewport.clientWidth-26)/Number(stage.dataset.width||900),height=(viewport.clientHeight-26)/Number(stage.dataset.height||700);setZoom(Math.min(1,state.mode==='overview'?Math.min(width,height):width))}
  function viewKey(){return state.mode==='overview'?'overview':state.mode==='method'?`method:${state.area}:${state.method}`:`area:${state.area}`}
  function node(id,x,y,name,kind,subtitle){
    const satellite=kind==='area'&&state.mode!=='overview'&&id!==state.area;
    const saved=state.moved.get(viewKey())?.get(id);
    if(saved){x=saved.x;y=saved.y}
    const area=kind==='area'?id:state.data.nodes.find(entry=>entry.id===id)?.area||state.area;
    const connections=state.overviewDegree?.get(id)||0;
    const dotSize=kind==='object'?(state.mode==='overview'?(connections>=6?48:connections>=3?38:connections>=1?30:24):id===state.areaLayout?.hub?34:21)
      :kind==='method'&&id===state.method?34:['method','failure','boundary'].includes(kind)?21:null;
    point.set(id,{x,y,kind:satellite?'satellite':kind,area,radius:dotSize?dotSize/2:null});
    const button=document.createElement('button');
    button.type='button';
    button.className=`node ${kind||''} ${state.selected===id?'selected':''}`;
    if(satellite)button.classList.add('satellite');
    if(state.mode==='overview')button.classList.add(kind==='area'?'overview-area':'overview-object');
    if(areaColors[area]&&(kind==='object'||kind==='area'))button.style.setProperty('--area-color',areaColors[area]);
    if(dotSize){button.style.setProperty('--dot-size',`${dotSize}px`);button.style.setProperty('--dot-offset',`${-dotSize/2}px`)}
    button.dataset.node=id;
    if(kind==='object')button.dataset.kind=subtitle;
    button.style.left=`${x}px`;
    button.style.top=`${y}px`;
    button.title=name;
    button.innerHTML=`${kind==='object'?glyph(subtitle):''}<strong>${escapeHtml(kind==='area'?displayArea(name):name)}</strong><small>${escapeHtml(subtitle||'')}</small>`;
    nodesEl.appendChild(button);
    return button;
  }
  function edgeGeometry(a,b){
    const p=point.get(a),q=point.get(b);
    if(!p||!q)return '';
    const dx=q.x-p.x,dy=q.y-p.y,distance=Math.hypot(dx,dy);
    if(distance<1)return '';
    const ux=dx/distance,uy=dy/distance,px=-uy*5,py=ux*5;
    const border=n=>{
      if(n.radius)return n.radius;
      const w=n.kind==='area'?102:n.kind==='satellite'?63:90;
      const h=n.kind==='satellite'?25:36;
      return Math.min(w/(Math.abs(ux)||.001),h/(Math.abs(uy)||.001))+4;
    };
    const c1=Math.min(border(p)+5,distance*.47),c2=Math.min(border(q)+8,distance*.47);
    return `M${p.x+ux*c1+px} ${p.y+uy*c1+py} L${q.x-ux*c2+px} ${q.y-uy*c2+py}`;
  }
  function edge(a,b,kind,count,secondary=false){
    const path=document.createElementNS('http://www.w3.org/2000/svg','path');
    path.setAttribute('class',`${kind}${secondary?' secondary':''}`);
    path.dataset.from=a;
    path.dataset.to=b;
    path.setAttribute('d',edgeGeometry(a,b));
    if(kind!=='unknown'){
      const from=point.get(a),to=point.get(b);
      const colorArea=kind==='type'&&from&&to&&from.area===to.area&&areaColors[from.area]?from.area:null;
      if(colorArea)path.style.setProperty('--edge-color',areaColors[colorArea]);
      path.setAttribute('marker-end',`url(#arrow-${kind}${colorArea?`-${colorArea}`:''})`);
    }
    if(count)path.setAttribute('aria-label',`${count} связей`);
    edgesEl.appendChild(path);
    edgePaths.push({a,b,path});
    return path;
  }
  function updateNodeEdges(id){for(const item of edgePaths){if(item.a===id||item.b===id)item.path.setAttribute('d',edgeGeometry(item.a,item.b))}}
  function clear(height,width=900){point.clear();edgePaths.length=0;nodesEl.replaceChildren();const marker=(id,color)=>`<marker id="arrow-${id}" viewBox="0 0 9 9" refX="8" refY="4.5" markerWidth="9" markerHeight="9" orient="auto" markerUnits="userSpaceOnUse"><path d="M0 0 L9 4.5 L0 9 Z" fill="${color}"/></marker>`;edgesEl.innerHTML=`<defs>${marker('type','var(--blue)')}${marker('call','var(--gold)')}${marker('throw','var(--red)')}${Object.entries(areaColors).map(([area,color])=>marker(`type-${area}`,color)).join('')}</defs>`;stage.style.height=`${height}px`;stage.style.width=`${width}px`;stage.dataset.height=height;stage.dataset.width=width;edgesEl.setAttribute('viewBox',`0 0 ${width} ${height}`);stageShell.style.width=`${width*state.zoom}px`;stageShell.style.height=`${height*state.zoom}px`}
  function drawOverview(){
    const layout=DomainGraphLayout.layoutOverview(state.data);
    state.overviewLayout=layout;
    clear(layout.height,layout.width);
    const byNode=new Map(state.data.nodes.map(entry=>[entry.id,entry]));
    const allEdges=state.data.edges.filter(e=>e.kind==='type'&&byNode.has(e.from)&&byNode.has(e.to));
    state.overviewDegree=new Map(state.data.nodes.map(entry=>[entry.id,0]));
    for(const e of allEdges){
      state.overviewDegree.set(e.from,state.overviewDegree.get(e.from)+1);
      state.overviewDegree.set(e.to,state.overviewDegree.get(e.to)+1);
    }
    for(const area of state.data.areas){
      const center=layout.areaCenters.get(area);
      node(area,center.x,center.y-layout.areaRadius.get(area)-145,area,'area',`${nodesInArea(area).length} объектов`);
    }
    for(const entry of state.data.nodes){
      const p=layout.positions.get(entry.id);
      node(entry.id,p.x,p.y,entry.name,'object',entry.kind);
    }
    const related=state.selected?allEdges.filter(e=>e.from===state.selected||e.to===state.selected):allEdges;
    for(const e of related){
      const cross=byNode.get(e.from).area!==byNode.get(e.to).area;
      const pair=[e.from,e.to].sort().join('|');
      const path=edge(e.from,e.to,'type',null,!state.selected&&!layout.treePairs.has(pair));
      if(cross)path.classList.add('cross');
    }
    if(state.selected){
      for(const button of nodesEl.querySelectorAll('.node.overview-object')){
        if(button.dataset.node!==state.selected&&!related.some(e=>e.from===button.dataset.node||e.to===button.dataset.node))button.classList.add('dimmed');
      }
    }
    byId('graph-status').textContent=`${state.data.areas.length} областей · ${state.data.nodes.length} объектов · приближайте для подписей`;
  }
  function drawArea(){
    const entries=nodesInArea(state.area);
    const ids=new Set(entries.map(entry=>entry.id));
    const realEdges=state.data.edges.filter(e=>e.kind==='type'&&ids.has(e.from)&&ids.has(e.to));
    const layout=DomainGraphLayout.layoutGraph(entries,realEdges);
    state.areaLayout=layout;
    clear(layout.height,layout.width);
    const satellites=state.data.areas.filter(area=>area!==state.area);
    satellites.forEach((area,i)=>{
      const x=170+i*((layout.width-340)/Math.max(1,satellites.length-1));
      node(area,x,45,area,'area','');
    });
    node(state.area,layout.width/2,92,state.area,'area','нажмите, чтобы свернуть');
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
  function drawDetails(){const selected=selectedNode();if(state.mode==='overview'&&!selected){details.innerHTML='<span class="overline">Обзор</span><h2>Весь domain</h2><p>На карте показаны все объекты. Приближайте для подписей, выберите объект для его связей или нажмите название модуля, чтобы открыть его отдельно.</p>';return}if(state.mode==='area'&&!selected){const center=state.data.nodes.find(n=>n.id===state.areaLayout?.hub);details.innerHTML=`<span class="overline">Область</span><h2>${escapeHtml(displayArea(state.area))}</h2><p>${nodesInArea(state.area).length} объявлений. В центре — ${escapeHtml(center?.name||'—')}: он использует больше всего других объектов этой области (${state.areaLayout?.outgoingCount||0} исходящих зависимостей). Положение не означает важность. Выберите объект, чтобы увидеть поля, методы и связи.</p>`;return}if(!selected){details.innerHTML='<h2>Объект не найден</h2>';return}const incoming=state.data.edges.filter(e=>e.kind==='type'&&e.to===selected.id),outgoing=state.data.edges.filter(e=>e.kind==='type'&&e.from===selected.id);let html=`<span class="overline">${escapeHtml(selected.kind)} · ${escapeHtml(displayArea(selected.area))}</span><h2>${escapeHtml(selected.name)}</h2><p>${escapeHtml(selected.description||'Описание в исходном коде отсутствует.')}</p>`;if(state.mode==='method'){const m=selected.methods.find(x=>x.id===state.method);html+=`<h3>Выбранный метод</h3><div class="row">${escapeHtml(m?.signature||'')}</div>`;const unresolved=reachable(state.method).flatMap(id=>selected.methods.find(x=>x.id===id)?.unresolvedCalls||[]);if(unresolved.length)html+=`<details><summary>Продолжение не установлено · ${unresolved.length} вызовов</summary>${unresolved.map(x=>`<div class="row">${escapeHtml(x)}</div>`).join('')}</details>`;}
    if(selected.kind==='interface')html+=`<h3>Реализация контракта</h3><div class="row">${selected.implementedBy?.length?`${selected.implementedBy.length} прямых implements в domain`:'Прямой implements в domain не найден; реализация может быть во внешнем слое или отсутствовать.'}</div>`;
    html+=`<h3>Поля и значения</h3>${selected.fields.length?selected.fields.map(x=>`<div class="row">${escapeHtml(x)}</div>`).join(''):'<div class="row">Нет</div>'}`;
    html+=`<h3>Методы и конструкторы</h3>${selected.methods.length?selected.methods.map(m=>`<button class="row" data-method="${escapeHtml(m.id)}">${escapeHtml(m.name)}<small>${escapeHtml(m.signature)}</small></button>`).join(''):'<div class="row">Нет</div>'}`;
    for(const [heading,items,target] of [['Использует',outgoing,'to'],['Используется в',incoming,'from']])html+=`<h3>${heading}</h3>${items.length?items.map(e=>`<button class="row" data-object="${escapeHtml(e[target])}">${escapeHtml(state.data.nodes.find(n=>n.id===e[target])?.name||e[target])}</button>`).join(''):'<div class="row">Нет прямых связей</div>'}`;
    details.innerHTML=html;
    details.scrollTop=0;
  }
  function applyKindFilter(){
    const active=state.kindFilter;
    const allKinds=new Set(state.data.nodes.map(node=>node.kind));
    const filtering=active.size<allKinds.size&&state.mode!=='method';
    const matches=id=>active.has(state.data.nodes.find(entry=>entry.id===id)?.kind);
    for(const button of nodesEl.querySelectorAll('.node.object'))button.classList.toggle('kind-muted',filtering&&!active.has(button.dataset.kind));
    for(const {a,b,path} of edgePaths)path.classList.toggle('kind-muted',filtering&&!matches(a)&&!matches(b));
    for(const button of document.querySelectorAll('[data-kind-filter]')){
      button.disabled=state.mode==='method';
      button.setAttribute('aria-pressed',String(active.has(button.dataset.kindFilter)));
    }
    const objects=nodesEl.querySelectorAll('.node.object');
    const focused=[...objects].filter(button=>!filtering||active.has(button.dataset.kind)).length;
    byId('kind-filter-count').textContent=state.mode==='method'?'Фильтр доступен на карте объектов':filtering?`В фокусе ${focused} из ${objects.length}`:`Все объекты · ${objects.length}`;
  }
  function render(){byId('collapse').hidden=state.mode==='overview';byId('breadcrumbs').innerHTML='<button type="button" data-go="overview">Domain</button>'+(state.mode==='overview'?'':`<span>›</span><button type="button" data-go="area">${escapeHtml(state.area)}</button>`)+(state.mode==='method'?'<span>›</span><span>метод</span>':'');if(state.mode==='overview')drawOverview();else if(state.mode==='area')drawArea();else drawMethod();drawDetails();setZoom(state.zoom);applyKindFilter()}
  function returnOverview(){state.mode='overview';state.selected=null;state.method=null;render();fit();viewport.scrollTo({top:0,left:0})}
  function goArea(area){state.area=area;state.mode='area';state.selected=null;state.method=null;render();fit();const center=point.get(state.areaLayout?.hub);if(center)viewport.scrollTo({left:center.x*state.zoom-viewport.clientWidth/2,top:center.y*state.zoom-viewport.clientHeight/2})}
  function enterMethod(id){if(state.mode!=='method'){state.areaScroll={left:viewport.scrollLeft,top:viewport.scrollTop,zoom:state.zoom};state.methodReturnMode=state.mode}state.method=id;state.mode='method';render();fit();const center=point.get(id);if(center)viewport.scrollTo({left:center.x*state.zoom-viewport.clientWidth/2,top:center.y*state.zoom-viewport.clientHeight/2})}
  function leaveMethod(){state.mode=state.methodReturnMode||'area';state.method=null;render();if(state.areaScroll){setZoom(state.areaScroll.zoom);viewport.scrollTo(state.areaScroll)}}
  function chooseMethod(id){if(state.mode==='method'&&state.method===id)leaveMethod();else enterMethod(id)}
  function chooseObject(entry){state.selected=state.selected===entry.id?null:entry.id;state.area=entry.area;if(state.mode!=='overview')state.mode='area';state.method=null;render()}
  let nodeDrag=null,suppressNodeClick=null;
  nodesEl.addEventListener('pointerdown',event=>{
    const button=event.target.closest('[data-node]');
    if(event.button!==0||!button)return;
    const id=button.dataset.node,p=point.get(id);
    if(!p)return;
    nodeDrag={id,button,pointerId:event.pointerId,startX:event.clientX,startY:event.clientY,x:p.x,y:p.y,moved:false,key:viewKey()};
    button.setPointerCapture(event.pointerId);
  });
  nodesEl.addEventListener('pointermove',event=>{
    if(!nodeDrag||nodeDrag.pointerId!==event.pointerId)return;
    const dx=event.clientX-nodeDrag.startX,dy=event.clientY-nodeDrag.startY;
    if(!nodeDrag.moved&&Math.hypot(dx,dy)<5)return;
    nodeDrag.moved=true;
    const p=point.get(nodeDrag.id);
    p.x=Math.max(20,Math.min(Number(stage.dataset.width)-20,nodeDrag.x+dx/state.zoom));
    p.y=Math.max(20,Math.min(Number(stage.dataset.height)-20,nodeDrag.y+dy/state.zoom));
    nodeDrag.button.style.left=`${p.x}px`;
    nodeDrag.button.style.top=`${p.y}px`;
    nodeDrag.button.classList.add('moving');
    updateNodeEdges(nodeDrag.id);
  });
  function finishNodeDrag(event){
    if(!nodeDrag||nodeDrag.pointerId!==event.pointerId)return;
    const active=nodeDrag;
    nodeDrag=null;
    active.button.classList.remove('moving');
    if(!active.moved)return;
    if(!state.moved.has(active.key))state.moved.set(active.key,new Map());
    const p=point.get(active.id);
    state.moved.get(active.key).set(active.id,{x:p.x,y:p.y});
    suppressNodeClick=active.id;
    setTimeout(()=>{if(suppressNodeClick===active.id)suppressNodeClick=null},0);
  }
  nodesEl.addEventListener('pointerup',finishNodeDrag);
  nodesEl.addEventListener('pointercancel',finishNodeDrag);
  nodesEl.addEventListener('click',event=>{const button=event.target.closest('[data-node]');if(!button)return;const id=button.dataset.node;if(suppressNodeClick===id){suppressNodeClick=null;return}if(state.data.areas.includes(id)){if(state.mode!=='overview'&&id===state.area)returnOverview();else goArea(id);return}if(id.includes('::')){chooseMethod(id);return}const entry=state.data.nodes.find(n=>n.id===id);if(entry)chooseObject(entry)});
  details.addEventListener('click',event=>{const method=event.target.closest('[data-method]');if(method){chooseMethod(method.dataset.method);return}const object=event.target.closest('[data-object]');if(object){const entry=state.data.nodes.find(x=>x.id===object.dataset.object);if(entry)chooseObject(entry)}});
  document.querySelector('.node-legend').addEventListener('click',event=>{
    const button=event.target.closest('[data-kind-filter]');
    if(!button||button.disabled||!state.data)return;
    const kind=button.dataset.kindFilter;
    if(state.kindFilter.has(kind))state.kindFilter.delete(kind);
    else state.kindFilter.add(kind);
    if(state.selected&&!state.kindFilter.has(selectedNode()?.kind)){state.selected=null;render()}
    else applyKindFilter();
  });
  byId('breadcrumbs').addEventListener('click',event=>{const go=event.target.closest('[data-go]');if(!go)return;if(go.dataset.go==='overview')returnOverview();else if(state.mode==='method')leaveMethod();else{state.mode='area';state.method=null;render()}});
  byId('collapse').addEventListener('click',()=>{if(state.mode==='method')leaveMethod();else returnOverview()});
  byId('zoom-in').addEventListener('click',()=>setZoom(state.zoom+.1));byId('zoom-out').addEventListener('click',()=>setZoom(state.zoom-.1));byId('zoom-fit').addEventListener('click',fit);
  viewport.addEventListener('wheel',event=>{
    event.preventDefault();
    const before=stageShell.getBoundingClientRect();
    const graphX=(event.clientX-before.left)/state.zoom;
    const graphY=(event.clientY-before.top)/state.zoom;
    const delta=event.deltaY*(event.deltaMode===1?16:event.deltaMode===2?viewport.clientHeight:1);
    setZoom(state.zoom*Math.exp(-delta*.0015));
    const after=stageShell.getBoundingClientRect();
    viewport.scrollLeft+=after.left+graphX*state.zoom-event.clientX;
    viewport.scrollTop+=after.top+graphY*state.zoom-event.clientY;
  },{passive:false});
  document.addEventListener('keydown',event=>{if(event.key!=='Escape')return;if(state.mode==='method')leaveMethod();else if(state.mode==='area')returnOverview()});
  let drag=null;viewport.addEventListener('pointerdown',event=>{if(event.button!==0||event.target.closest('button'))return;drag={x:event.clientX,y:event.clientY,left:viewport.scrollLeft,top:viewport.scrollTop};viewport.classList.add('dragging');viewport.setPointerCapture(event.pointerId)});viewport.addEventListener('pointermove',event=>{if(!drag)return;viewport.scrollLeft=drag.left-(event.clientX-drag.x);viewport.scrollTop=drag.top-(event.clientY-drag.y)});viewport.addEventListener('pointerup',()=>{drag=null;viewport.classList.remove('dragging')});
  fetch('domain-architecture.json').then(r=>{if(!r.ok)throw Error(`HTTP ${r.status}`);return r.json()}).then(data=>{if(data.schemaVersion!==1)throw Error('Неизвестная версия схемы');state.data=data;state.kindFilter=new Set(data.nodes.map(node=>node.kind));render();fit()}).catch(error=>{byId('graph-status').textContent=`Не удалось открыть карту: ${error.message}`;details.innerHTML='<h2>Данные недоступны</h2><p>Запустите make domain-check-generate, затем make domain-check.</p>'});
  return state;
})();
