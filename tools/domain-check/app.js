const kindColors = {
  aggregate: '#ffb900', entity: '#5bc0ff', model: '#b789ff',
  abstraction: '#e2e9ff', 'value-object': '#56d6a5', port: '#ff7a9e',
  repository: '#70a6ff', failure: '#a5afc4'
};

const state = { data: null, selectedId: null, search: '', area: 'all', kind: 'all', relationshipFocus: false };
const panState = { pointerId: null, startX: 0, startY: 0, scrollLeft: 0, scrollTop: 0 };
const byId = new Map();
const $ = (selector) => document.querySelector(selector);
const graphLayout = {
  columns: 3,
  clusterWidth: 780,
  clusterGap: 112,
  outerGap: 56,
  clusterHeaderHeight: 76,
  clusterPadding: 32,
  nodeColumns: 2,
  nodeGapX: 72,
  nodeGapY: 36,
  nodeHeights: { prominent: 156, standard: 124, compact: 102 },
  edgePortOffset: 18
};

async function start() {
  try {
    const response = await fetch('domain-architecture.json');
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    state.data = await response.json();
    state.data.nodes.forEach((node) => byId.set(node.id, node));
    setupControls();
    setupViewportInteraction();
    render();
    requestAnimationFrame(syncViewerHeight);
  } catch (error) {
    $('#subtitle').textContent = 'Не удалось загрузить JSON-инвентарь.';
    $('#inventory').innerHTML = `<p class="empty">Запусти viewer через <code>make domain-check</code>. ${error.message}</p>`;
  }
}

function setupControls() {
  $('#subtitle').textContent = `Источник: ${state.data.source}`;
  $('#node-count').textContent = state.data.nodes.length;
  $('#edge-count').textContent = state.data.edges.length;
  $('#area-count').textContent = state.data.areas.length;
  state.data.areas.forEach((area) => $('#area-filter').append(new Option(area.title, area.id)));
  [...new Set(state.data.nodes.map((node) => node.kind))].sort().forEach((kind) => {
    $('#kind-filter').append(new Option(kind, kind));
  });
  $('#search').addEventListener('input', (event) => { state.search = event.target.value.toLowerCase(); render(); });
  $('#area-filter').addEventListener('change', (event) => { state.area = event.target.value; render(); });
  $('#kind-filter').addEventListener('change', (event) => { state.kind = event.target.value; render(); });
  $('#relationship-focus').addEventListener('click', () => {
    state.relationshipFocus = !state.relationshipFocus;
    $('#relationship-focus').setAttribute('aria-pressed', state.relationshipFocus);
    $('#relationship-focus').classList.toggle('is-active', state.relationshipFocus);
    render();
  });
  $('#reset').addEventListener('click', () => {
    state.search = ''; state.area = 'all'; state.kind = 'all'; state.relationshipFocus = false;
    $('#search').value = ''; $('#area-filter').value = 'all'; $('#kind-filter').value = 'all'; render();
    $('#relationship-focus').setAttribute('aria-pressed', 'false');
    $('#relationship-focus').classList.remove('is-active');
  });
}

function visibleNodes() {
  return state.data.nodes.filter((node) => {
    const text = [node.title, node.summary, ...(node.members || [])].join(' ').toLowerCase();
    return (state.area === 'all' || node.area === state.area) &&
      (state.kind === 'all' || node.kind === state.kind) && text.includes(state.search);
  });
}

function render() {
  const visible = visibleNodes();
  renderLegend();
  renderGraph(visible);
  renderInventory(visible);
  if (state.selectedId && !visible.some((node) => node.id === state.selectedId)) {
    state.selectedId = null;
  }
  updateSelection();
}

function renderLegend() {
  const kinds = [...new Set(state.data.nodes.map((node) => node.kind))];
  $('.legend').innerHTML = kinds.map((kind) => `<span class="legend-item" style="--kind-color:${kindColors[kind]}">${kind}</span>`).join('');
}

function setupViewportInteraction() {
  const viewport = $('#graph-viewport');
  viewport.addEventListener('pointerdown', (event) => {
    if (event.button !== 0 || event.target.closest('button, a, input, select')) return;
    panState.pointerId = event.pointerId;
    panState.startX = event.clientX;
    panState.startY = event.clientY;
    panState.scrollLeft = viewport.scrollLeft;
    panState.scrollTop = viewport.scrollTop;
    viewport.setPointerCapture(event.pointerId);
    viewport.classList.add('is-panning');
  });
  viewport.addEventListener('pointermove', (event) => {
    if (event.pointerId !== panState.pointerId) return;
    viewport.scrollLeft = panState.scrollLeft - (event.clientX - panState.startX);
    viewport.scrollTop = panState.scrollTop - (event.clientY - panState.startY);
    event.preventDefault();
  });
  const stopPanning = (event) => {
    if (event.pointerId !== panState.pointerId) return;
    if (viewport.hasPointerCapture(event.pointerId)) viewport.releasePointerCapture(event.pointerId);
    panState.pointerId = null;
    viewport.classList.remove('is-panning');
  };
  viewport.addEventListener('pointerup', stopPanning);
  viewport.addEventListener('pointercancel', stopPanning);
}

function syncViewerHeight() {
  const panel = $('.architecture-panel');
  const availableHeight = window.innerHeight - panel.getBoundingClientRect().top - 24;
  panel.style.height = `${Math.max(320, availableHeight)}px`;
}

function renderGraph(nodes) {
  const canvas = $('#graph-canvas');
  const graphClusters = $('#graph-clusters');
  const graphNodes = $('#graph-nodes');
  const edgeLayer = $('#edges');
  const layout = clusterLayout(nodes);
  canvas.style.width = `${layout.width}px`;
  canvas.style.height = `${layout.height}px`;
  graphClusters.innerHTML = '';
  graphNodes.innerHTML = '';
  layout.clusters.forEach((cluster) => {
    graphClusters.insertAdjacentHTML('beforeend', `
      <section class="area-cluster" data-area="${cluster.area.id}" style="left:${cluster.x}px;top:${cluster.y}px;width:${cluster.width}px;height:${cluster.height}px;--area-color:${cluster.area.accent}">
        <div class="cluster-heading"><span>${cluster.area.title}</span><strong>${cluster.nodes.length}</strong></div>
      </section>`);
  });
  nodes.forEach((node) => {
    const template = $('#node-template').content.cloneNode(true);
    const element = template.querySelector('button');
    const position = layout.nodePositions.get(node.id);
    element.dataset.id = node.id;
    element.dataset.tier = position.tier;
    element.classList.add(`node-${position.tier}`);
    element.style.left = `${position.x}px`;
    element.style.top = `${position.y}px`;
    element.style.width = `${position.width}px`;
    element.style.height = `${position.height}px`;
    element.style.setProperty('--area-color', state.data.areas.find((area) => area.id === node.area).accent);
    element.querySelector('.node-kind').style.setProperty('--kind-color', kindColors[node.kind]);
    element.querySelector('.node-kind').textContent = node.kind;
    element.querySelector('strong').textContent = node.title;
    element.querySelector('small').textContent = node.summary;
    element.addEventListener('click', () => selectNode(node.id));
    graphNodes.append(element);
  });
  requestAnimationFrame(() => renderEdges(nodes, edgeLayer));
}

function renderEdges(nodes, edgeLayer) {
  const visibleIds = new Set(nodes.map((node) => node.id));
  const canvasRect = $('#graph-canvas').getBoundingClientRect();
  edgeLayer.innerHTML = '<defs><marker id="edge-arrow" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><path fill="context-stroke" d="M 0 0 L 8 4 L 0 8 z" /></marker></defs>';
  state.data.edges.forEach(([from, to, label]) => {
    if (!visibleIds.has(from) || !visibleIds.has(to)) return;
    const fromElement = document.querySelector(`.architecture-node[data-id="${from}"]`);
    const toElement = document.querySelector(`.architecture-node[data-id="${to}"]`);
    if (!fromElement || !toElement) return;
    const a = fromElement.getBoundingClientRect(); const b = toElement.getBoundingClientRect();
    const geometry = edgeGeometry(a, b, canvasRect);
    const direction = state.selectedId === from ? ' is-outbound' : state.selectedId === to ? ' is-inbound' : '';
    const related = direction ? ' is-related' : '';
    const muted = state.relationshipFocus && state.selectedId && !direction ? ' is-muted' : '';
    const interCluster = byId.get(from).area !== byId.get(to).area ? ' is-inter-cluster' : '';
    edgeLayer.insertAdjacentHTML('beforeend', `<path class="edge${interCluster}${related}${direction}${muted}" data-from="${from}" data-to="${to}" d="${geometry.path}" marker-end="url(#edge-arrow)"><title>${label}</title></path>`);
    if (direction) {
      edgeLayer.insertAdjacentHTML('beforeend', `<text class="edge-label${direction}" x="${geometry.labelX}" y="${geometry.labelY}">${label}</text>`);
    }
  });
}

function clusterLayout(nodes) {
  const grouped = new Map(state.data.areas.map((area) => [area.id, []]));
  nodes.forEach((node) => grouped.get(node.area).push(node));
  const visibleAreas = state.data.areas.filter((area) => grouped.get(area.id).length);
  const columnCount = Math.min(graphLayout.columns, Math.max(1, visibleAreas.length));
  const columnHeights = Array(columnCount).fill(graphLayout.outerGap);
  const clusters = [];
  const nodePositions = new Map();

  visibleAreas.forEach((area) => {
    const areaNodes = grouped.get(area.id);
    const rows = nodeRows(areaNodes);
    const contentHeight = rows.reduce((total, row) => total + row.height, 0) +
      Math.max(0, rows.length - 1) * graphLayout.nodeGapY;
    const height = graphLayout.clusterHeaderHeight + graphLayout.clusterPadding * 2 + contentHeight;
    const column = columnHeights.indexOf(Math.min(...columnHeights));
    const x = graphLayout.outerGap + column * (graphLayout.clusterWidth + graphLayout.clusterGap);
    const y = columnHeights[column];
    const cluster = { area, nodes: areaNodes, x, y, width: graphLayout.clusterWidth, height };
    clusters.push(cluster);
    columnHeights[column] += height + graphLayout.clusterGap;

    const innerWidth = graphLayout.clusterWidth - graphLayout.clusterPadding * 2;
    const columnWidth = (innerWidth - graphLayout.nodeGapX) / graphLayout.nodeColumns;
    let rowY = y + graphLayout.clusterHeaderHeight + graphLayout.clusterPadding;
    rows.forEach((row) => {
      row.items.forEach((item, index) => {
        nodePositions.set(item.node.id, {
          x: x + graphLayout.clusterPadding + (item.span === graphLayout.nodeColumns ? 0 : index * (columnWidth + graphLayout.nodeGapX)),
          y: rowY,
          width: item.span === graphLayout.nodeColumns ? innerWidth : columnWidth,
          height: graphLayout.nodeHeights[item.tier],
          tier: item.tier
        });
      });
      rowY += row.height + graphLayout.nodeGapY;
    });
  });

  return {
    clusters,
    nodePositions,
    width: graphLayout.outerGap * 2 + columnCount * graphLayout.clusterWidth + Math.max(0, columnCount - 1) * graphLayout.clusterGap,
    height: Math.max(630, ...columnHeights) + graphLayout.outerGap - graphLayout.clusterGap
  };
}

function nodeRows(nodes) {
  const rows = [];
  let current = [];
  const pushCurrent = () => {
    if (!current.length) return;
    rows.push({
      items: current,
      height: Math.max(...current.map((item) => graphLayout.nodeHeights[item.tier]))
    });
    current = [];
  };

  nodes.forEach((node) => {
    const tier = nodeTier(node);
    const span = tier === 'prominent' ? graphLayout.nodeColumns : 1;
    if (span === graphLayout.nodeColumns) {
      pushCurrent();
      current.push({ node, tier, span });
      pushCurrent();
      return;
    }
    current.push({ node, tier, span });
    if (current.length === graphLayout.nodeColumns) pushCurrent();
  });
  pushCurrent();
  return rows;
}

function nodeTier(node) {
  if (node.kind === 'aggregate') return 'prominent';
  if (node.kind === 'value-object' || node.kind === 'failure') return 'compact';
  return 'standard';
}

function edgeGeometry(source, target, canvas) {
  const sourceCenter = { x: source.left + source.width / 2, y: source.top + source.height / 2 };
  const targetCenter = { x: target.left + target.width / 2, y: target.top + target.height / 2 };
  const dx = targetCenter.x - sourceCenter.x;
  const dy = targetCenter.y - sourceCenter.y;

  if (Math.abs(dx) >= Math.abs(dy)) {
    const direction = dx >= 0 ? 1 : -1;
    const x1 = (direction > 0 ? source.right : source.left) - canvas.left;
    const y1 = sourceCenter.y - canvas.top - graphLayout.edgePortOffset;
    const x2 = (direction > 0 ? target.left : target.right) - canvas.left;
    const y2 = targetCenter.y - canvas.top + graphLayout.edgePortOffset;
    const bend = Math.max(56, Math.abs(x2 - x1) * .42);
    return {
      path: `M ${x1} ${y1} C ${x1 + direction * bend} ${y1}, ${x2 - direction * bend} ${y2}, ${x2} ${y2}`,
      labelX: (x1 + x2) / 2,
      labelY: (y1 + y2) / 2 - 9
    };
  }

  const direction = dy >= 0 ? 1 : -1;
  const x1 = sourceCenter.x - canvas.left - graphLayout.edgePortOffset;
  const y1 = (direction > 0 ? source.bottom : source.top) - canvas.top;
  const x2 = targetCenter.x - canvas.left + graphLayout.edgePortOffset;
  const y2 = (direction > 0 ? target.top : target.bottom) - canvas.top;
  const bend = Math.max(56, Math.abs(y2 - y1) * .42);
  return {
    path: `M ${x1} ${y1} C ${x1} ${y1 + direction * bend}, ${x2} ${y2 - direction * bend}, ${x2} ${y2}`,
    labelX: (x1 + x2) / 2 + 10,
    labelY: (y1 + y2) / 2
  };
}

function renderInventory(nodes) {
  $('#inventory-count').textContent = `Показано: ${nodes.length} из ${state.data.nodes.length}`;
  $('#inventory').innerHTML = nodes.length ? nodes.map((node) => `
    <button class="inventory-card ${node.id === state.selectedId ? 'is-selected' : ''}" data-id="${node.id}" type="button">
      <span class="kind-badge" style="--kind-color:${kindColors[node.kind]}">${node.kind}</span>
      <strong>${node.title}</strong><p>${node.summary}</p>
    </button>`).join('') : '<p class="empty">По фильтрам ничего не найдено.</p>';
  document.querySelectorAll('.inventory-card').forEach((card) => card.addEventListener('click', () => selectNode(card.dataset.id)));
}

function selectNode(id) {
  state.selectedId = id;
  render();
}

function updateSelection() {
  const context = relationshipContext(state.selectedId);
  document.querySelectorAll('.architecture-node, .inventory-card').forEach((item) => {
    item.classList.toggle('is-selected', item.dataset.id === state.selectedId);
    item.classList.toggle('is-muted', Boolean(state.relationshipFocus && state.selectedId && !context.neighborIds.has(item.dataset.id)));
  });
  const relatedAreas = new Set([...context.neighborIds].map((id) => byId.get(id)?.area));
  document.querySelectorAll('.area-cluster').forEach((cluster) => {
    cluster.classList.toggle('is-muted', Boolean(state.relationshipFocus && state.selectedId && !relatedAreas.has(cluster.dataset.area)));
  });
  const node = byId.get(state.selectedId);
  if (!node) {
    $('#detail').innerHTML = '<p class="eyebrow">DETAILS</p><h2>Выбери объект</h2><p>Стрелки показывают направление связи: от использующего объекта к используемому.</p>';
    return;
  }
  $('#detail').innerHTML = `
    <p class="eyebrow">${node.area.toUpperCase()} / ${node.kind.toUpperCase()}</p>
    <h2>${node.title}</h2><p>${node.summary}</p>
    ${detailList('Поля', node.fields)}${detailList('Методы', node.methods)}${detailList('Состав', node.members)}
    ${relationList('Использует', context.outgoing, 'outgoing')}${relationList('Используется в', context.incoming, 'incoming')}`;
  document.querySelectorAll('.relation[data-id]').forEach((button) => button.addEventListener('click', () => selectNode(button.dataset.id)));
}

function relationshipContext(id) {
  const incoming = [];
  const outgoing = [];
  const neighborIds = new Set(id ? [id] : []);
  if (!id) return { incoming, outgoing, neighborIds };
  state.data.edges.forEach(([from, to, label]) => {
    if (from === id) { outgoing.push({ id: to, label }); neighborIds.add(to); }
    if (to === id) { incoming.push({ id: from, label }); neighborIds.add(from); }
  });
  return { incoming, outgoing, neighborIds };
}

function relationList(title, items, direction) {
  const content = items.length
    ? items.map((item) => `<button class="relation relation-${direction}" data-id="${item.id}">${direction === 'outgoing' ? `${item.label} → ${byId.get(item.id).title}` : `${byId.get(item.id).title} → ${item.label}`}</button>`).join('')
    : '<span class="relation">Нет</span>';
  return `<section class="detail-section"><h3>${title}</h3><div class="relations">${content}</div></section>`;
}

function detailList(title, items = []) {
  if (!items.length) return '';
  return `<section class="detail-section"><h3>${title}</h3><ul>${items.map((item) => `<li>${item}</li>`).join('')}</ul></section>`;
}

window.addEventListener('resize', () => requestAnimationFrame(() => {
  syncViewerHeight();
  renderEdges(visibleNodes(), $('#edges'));
}));
start();
