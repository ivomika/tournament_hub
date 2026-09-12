const kindColors = {
  aggregate: '#ffb900', entity: '#5bc0ff', model: '#b789ff',
  abstraction: '#e2e9ff', 'value-object': '#56d6a5', port: '#ff7a9e',
  repository: '#70a6ff', failure: '#a5afc4'
};

const state = { data: null, selectedId: null, search: '', area: 'all', kind: 'all' };
const byId = new Map();
const $ = (selector) => document.querySelector(selector);

async function start() {
  try {
    const response = await fetch('domain-architecture.json');
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    state.data = await response.json();
    state.data.nodes.forEach((node) => byId.set(node.id, node));
    setupControls();
    render();
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
  $('#reset').addEventListener('click', () => {
    state.search = ''; state.area = 'all'; state.kind = 'all';
    $('#search').value = ''; $('#area-filter').value = 'all'; $('#kind-filter').value = 'all'; render();
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
  if (state.selectedId && !visible.some((node) => node.id === state.selectedId)) selectNode(null);
  else updateSelection();
}

function renderLegend() {
  const kinds = [...new Set(state.data.nodes.map((node) => node.kind))];
  $('.legend').innerHTML = kinds.map((kind) => `<span class="legend-item" style="--kind-color:${kindColors[kind]}">${kind}</span>`).join('');
}

function renderGraph(nodes) {
  const canvas = $('#graph-canvas');
  const graphNodes = $('#graph-nodes');
  const edgeLayer = $('#edges');
  const areaIndex = new Map(state.data.areas.map((area, index) => [area.id, index]));
  const grouped = new Map(state.data.areas.map((area) => [area.id, []]));
  state.data.nodes.forEach((node) => grouped.get(node.area).push(node));
  const maxRows = Math.max(...[...grouped.values()].map((items) => items.length));
  canvas.style.minHeight = `${Math.max(860, maxRows * 138 + 100)}px`;
  graphNodes.innerHTML = '';
  nodes.forEach((node) => {
    const template = $('#node-template').content.cloneNode(true);
    const element = template.querySelector('button');
    const position = grouped.get(node.area).indexOf(node);
    element.dataset.id = node.id;
    element.style.left = `${20 + areaIndex.get(node.area) * 310}px`;
    element.style.top = `${34 + position * 138}px`;
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
  edgeLayer.innerHTML = '';
  state.data.edges.forEach(([from, to, label]) => {
    if (!visibleIds.has(from) || !visibleIds.has(to)) return;
    const fromElement = document.querySelector(`.architecture-node[data-id="${from}"]`);
    const toElement = document.querySelector(`.architecture-node[data-id="${to}"]`);
    if (!fromElement || !toElement) return;
    const a = fromElement.getBoundingClientRect(); const b = toElement.getBoundingClientRect();
    const x1 = a.right - canvasRect.left; const y1 = a.top + a.height / 2 - canvasRect.top;
    const x2 = b.left - canvasRect.left; const y2 = b.top + b.height / 2 - canvasRect.top;
    const bend = Math.max(50, Math.abs(x2 - x1) * .45);
    const selectedClass = state.selectedId === from || state.selectedId === to ? ' is-related' : '';
    edgeLayer.insertAdjacentHTML('beforeend', `<path class="edge${selectedClass}" data-from="${from}" data-to="${to}" data-label="${label}" d="M ${x1} ${y1} C ${x1 + bend} ${y1}, ${x2 - bend} ${y2}, ${x2} ${y2}"/>`);
  });
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
  updateSelection();
}

function updateSelection() {
  document.querySelectorAll('.architecture-node, .inventory-card').forEach((item) => item.classList.toggle('is-selected', item.dataset.id === state.selectedId));
  document.querySelectorAll('.edge').forEach((edge) => edge.classList.toggle('is-related', edge.dataset.from === state.selectedId || edge.dataset.to === state.selectedId));
  const node = byId.get(state.selectedId);
  if (!node) return;
  const related = state.data.edges.filter(([from, to]) => from === node.id || to === node.id).map(([from, to, label]) => ({ id: from === node.id ? to : from, label }));
  $('#detail').innerHTML = `
    <p class="eyebrow">${node.area.toUpperCase()} / ${node.kind.toUpperCase()}</p>
    <h2>${node.title}</h2><p>${node.summary}</p>
    ${detailList('Поля', node.fields)}${detailList('Методы', node.methods)}${detailList('Состав', node.members)}
    <section class="detail-section"><h3>Прямые связи</h3><div class="relations">${related.length ? related.map((item) => `<button class="relation" data-id="${item.id}">${item.label} → ${byId.get(item.id).title}</button>`).join('') : '<span class="relation">Нет</span>'}</div></section>`;
  document.querySelectorAll('.relation[data-id]').forEach((button) => button.addEventListener('click', () => selectNode(button.dataset.id)));
}

function detailList(title, items = []) {
  if (!items.length) return '';
  return `<section class="detail-section"><h3>${title}</h3><ul>${items.map((item) => `<li>${item}</li>`).join('')}</ul></section>`;
}

window.addEventListener('resize', () => requestAnimationFrame(() => renderEdges(visibleNodes(), $('#edges'))));
start();
