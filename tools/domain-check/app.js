const kindColors = {
  class: '#5bc0ff', 'abstract-class': '#b789ff', 'sealed-class': '#ff7a9e',
  interface: '#ffb900', enum: '#56d6a5'
};

const state = { data: null, selectedId: null, search: '', area: 'all', kind: 'all', relationshipFocus: false };
const panState = { pointerId: null, startX: 0, startY: 0, scrollLeft: 0, scrollTop: 0 };
const graphZoom = {
  mode: 'manual',
  scale: 1,
  layout: null,
  minScale: .1,
  maxScale: 2,
  buttonStep: .1,
  storageKey: 'tournamentHub.domainCheck.graphScale'
};
const byId = new Map();
const $ = (selector) => document.querySelector(selector);
const graphLayout = {
  columns: 3,
  clusterWidth: 780,
  clusterGap: 112,
  outerGap: 56,
  clusterHeaderHeight: 76,
  clusterPadding: 32,
  folderHeaderHeight: 38,
  folderPadding: 18,
  folderGap: 28,
  nodeColumns: 2,
  nodeGapX: 72,
  nodeGapY: 36,
  nodeHeights: { prominent: 176, standard: 142, compact: 118 },
  edgePortOffset: 18
};

async function start() {
  try {
    const response = await fetch('domain-architecture.json');
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    state.data = await response.json();
    if (state.data.version !== 9) throw new Error('Несовместимая схема. Выполни make domain-check-generate.');
    try {
      const traceResponse = await fetch('operation-trace.json');
      if (!traceResponse.ok) throw new Error(`HTTP ${traceResponse.status}`);
      state.operationTrace = await traceResponse.json();
      if (state.operationTrace.version !== 1) throw new Error('Несовместимая версия operation trace');
    } catch (error) {
      state.operationTrace = null;
      state.traceError = error.message;
    }
    renderAnalysisReport();
    state.data.nodes.forEach((node) => byId.set(node.id, node));
    setupRelations();
    setupControls();
    setupViewportInteraction();
    setupGraphZoom();
    setupKeyboardShortcuts();
    render();
    restoreViewerLocation();
    requestAnimationFrame(() => {
      syncViewerHeight();
      applyGraphZoom();
    });
  } catch (error) {
    $('#subtitle').textContent = 'Не удалось загрузить JSON-инвентарь.';
    $('#inventory').innerHTML = `<p class="empty">Запусти viewer через <code>make domain-check</code>. ${error.message}</p>`;
  }
}

function renderAnalysisReport() {
  const container = $('#analysis-summary');
  const report = state.data.analysis;
  if (!report) {
    container.textContent = 'Отчёт отсутствует. Обнови данные через make domain-check-generate.';
    return;
  }
  const paragraph = (label, value) => {
    const element = document.createElement('p');
    const title = document.createElement('strong');
    title.textContent = `${label}: `;
    element.append(title, document.createTextNode(value));
    container.append(element);
  };
  paragraph('Проверенная область', report.primaryRoot);
  paragraph('Источник', `${report.generator} · resolved AST · analyzer ${report.analyzer} · Dart ${report.dart} · schema ${state.data.version}`);
  paragraph('Извлечено', `${report.scannedFiles} Dart-файлов, ${report.extractedDeclarations} объектов, ${state.data.edges.length} связей объектов, ${state.data.relationOccurrences.length} оснований связей`);
  paragraph('Неизвестные вызовы/типы', `dynamic: ${state.data.relationOccurrences.filter((r) => r.resolution === 'dynamic').length}; unresolved: ${state.data.relationOccurrences.filter((r) => r.resolution === 'unresolved').length}. Статическая цель вызова не гарантирует runtime-реализацию.`);
  paragraph('Исключено', report.excludedFiles.length ? report.excludedFiles.join(', ') : 'нет; barrel domain.dart тоже анализируется');
  paragraph('Описания из ///', `${report.descriptions.documented} из ${report.descriptions.total}. Остальные описания — технические сводки, назначение не описано.`);
  const coverage = state.data.semantic?.coverage;
  paragraph('Смысловой контекст', coverage ? `${coverage.areas} областей, ${coverage.objects} из ${coverage.requiredObjects} ключевых объектов; ${state.data.contextDiagnostics.length} диагностик. Назначения взяты из docs/architecture, не из AST.` : 'Описания отсутствуют; технический реестр доступен.');
  if (state.data.contextDiagnostics?.length) paragraph('Пробелы описаний', state.data.contextDiagnostics.map((d) => `${d.code}: ${d.target}`).join('; '));
  for (const layer of report.layers) {
    paragraph(layer.root, layer.present ? 'каталог существует; содержимое не анализировалось' : 'каталог отсутствует');
  }
  if (report.implementationScan) paragraph('Проверка контрактов', `${report.implementationScan.outsideDomainFiles.join(', ') || 'нет внешних Dart-файлов'}; найдено ${report.implementationScan.found.length} объявленных реализаций. Runtime DI не проверен.`);
  const diagnostics = document.createElement('ul');
  for (const diagnostic of report.diagnostics) {
    const item = document.createElement('li');
    item.textContent = diagnostic.message;
    diagnostics.append(item);
  }
  container.append(diagnostics);
}

function setupControls() {
  $('#subtitle').textContent = `Источник: ${state.data.source}`;
  $('#node-count').textContent = state.data.nodes.length;
  $('#edge-count').textContent = state.data.edges.length;
  $('#area-count').textContent = state.data.areas.length;
  $('#enum-count').textContent = state.data.nodes.filter((node) => node.kind === 'enum').length;
  state.data.areas.forEach((area) => $('#area-filter').append(new Option(area.title, area.id)));
  [...new Set(state.data.nodes.map((node) => node.kind))].sort().forEach((kind) => {
    $('#kind-filter').append(new Option(kind, kind));
  });
  $('#search').addEventListener('input', (event) => { state.search = event.target.value.toLowerCase(); render(); });
  $('#area-filter').addEventListener('change', (event) => { state.area = event.target.value; render(); });
  $('#kind-filter').addEventListener('change', (event) => { state.kind = event.target.value; render(); });
  $('#relationship-focus').addEventListener('click', toggleRelationshipFocus);
  $('#reset').addEventListener('click', () => {
    state.search = ''; state.area = 'all'; state.kind = 'all';
    setRelationshipFocus(false, false);
    $('#search').value = ''; $('#area-filter').value = 'all'; $('#kind-filter').value = 'all'; render();
  });
}

function toggleRelationshipFocus() {
  setRelationshipFocus(!state.relationshipFocus);
}

function setRelationshipFocus(enabled, renderView = true) {
  state.relationshipFocus = enabled;
  $('#relationship-focus').setAttribute('aria-pressed', String(enabled));
  $('#relationship-focus').classList.toggle('is-active', enabled);
  if (renderView) render();
}

function visibleNodes() {
  return state.data.nodes.filter((node) => {
    const text = [
      node.title,
      node.signature,
      node.description,
      node.kind,
      node.role,
      node.importance,
      ...(node.members || []),
      ...(node.fields || []),
      ...(node.methods || [])
    ].join(' ').toLowerCase();
    return (state.area === 'all' || node.area === state.area) &&
      (state.kind === 'all' || node.kind === state.kind) && text.includes(state.search);
  });
}

function render() {
  const visible = visibleNodes();
  renderLegend();
  if (state.viewerMode === 'map') renderGraph(visible);
  renderInventory(visible);
  renderAreaOverview(visible);
  updateSelection();
  renderScenarioView();
  renderBreadcrumbs();
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

function setupGraphZoom() {
  const savedScale = readSavedGraphScale();
  if (savedScale !== null) {
    graphZoom.scale = savedScale;
  }

  $('#zoom-out').addEventListener('click', () => {
    setManualGraphScale(graphZoom.scale - graphZoom.buttonStep, true);
  });
  $('#zoom-in').addEventListener('click', () => {
    setManualGraphScale(graphZoom.scale + graphZoom.buttonStep, true);
  });
  $('#zoom-range').addEventListener('input', (event) => {
    setManualGraphScale(Number(event.target.value) / 100, true);
  });
  $('#zoom-reset').addEventListener('click', () => {
    setManualGraphScale(1, true);
  });
  $('#zoom-fit').addEventListener('click', () => {
    graphZoom.mode = 'fit';
    clearSavedGraphScale();
    applyGraphZoom();
  });
}

function setupKeyboardShortcuts() {
  document.addEventListener('keydown', (event) => {
    if (event.ctrlKey || event.metaKey || event.altKey || isShortcutInput(event.target)) return;
    if (event.code === 'Equal' || event.code === 'NumpadAdd') {
      setManualGraphScale(graphZoom.scale + graphZoom.buttonStep, true);
    } else if (event.code === 'Minus' || event.code === 'NumpadSubtract') {
      setManualGraphScale(graphZoom.scale - graphZoom.buttonStep, true);
    } else if (event.code === 'Digit0' || event.code === 'Numpad0') {
      setManualGraphScale(1, true);
    } else if (event.code === 'KeyF' && !event.repeat) {
      toggleRelationshipFocus();
    } else {
      return;
    }
    event.preventDefault();
  });
}

function isShortcutInput(target) {
  return target instanceof Element && Boolean(target.closest(
    'input, select, textarea, [contenteditable]:not([contenteditable="false"])'
  ));
}

function setManualGraphScale(scale, preserveCenter = false) {
  const viewport = $('#graph-viewport');
  const center = preserveCenter ? {
    x: (viewport.scrollLeft + viewport.clientWidth / 2) / graphZoom.scale,
    y: (viewport.scrollTop + viewport.clientHeight / 2) / graphZoom.scale
  } : null;
  graphZoom.mode = 'manual';
  graphZoom.scale = clampGraphScale(scale);
  saveGraphScale(graphZoom.scale);
  applyGraphZoom();
  if (center) {
    viewport.scrollLeft = center.x * graphZoom.scale - viewport.clientWidth / 2;
    viewport.scrollTop = center.y * graphZoom.scale - viewport.clientHeight / 2;
  }
}

function syncViewerHeight() {
  const panel = $('.architecture-panel');
  const viewport = $('#graph-viewport');
  const headerHeight = panel.querySelector('.panel-heading').offsetHeight;
  const minViewportHeight = Math.max(320, window.innerHeight - headerHeight);
  viewport.style.minHeight = `${minViewportHeight}px`;
  panel.style.height = `${headerHeight + minViewportHeight}px`;
  $('#detail').style.height = `${headerHeight + minViewportHeight}px`;
}

function applyGraphZoom() {
  if (!graphZoom.layout) return;
  const viewport = $('#graph-viewport');
  if (graphZoom.mode === 'fit') {
    const horizontalScale = Math.max(0, viewport.clientWidth - 24) / graphZoom.layout.width;
    const verticalScale = Math.max(0, viewport.clientHeight - 24) / graphZoom.layout.height;
    graphZoom.scale = clampGraphScale(Math.min(horizontalScale, verticalScale));
  }
  const stage = $('#graph-stage');
  const canvas = $('#graph-canvas');
  const scaledWidth = graphZoom.layout.width * graphZoom.scale;
  const scaledHeight = graphZoom.layout.height * graphZoom.scale;
  stage.style.width = `${scaledWidth}px`;
  stage.style.height = `${scaledHeight}px`;
  stage.style.marginLeft = `${Math.max(0, (viewport.clientWidth - scaledWidth) / 2)}px`;
  stage.style.marginTop = `${Math.max(0, (viewport.clientHeight - scaledHeight) / 2)}px`;
  canvas.style.transform = `scale(${graphZoom.scale})`;
  const percent = Math.round(graphZoom.scale * 100);
  $('#zoom-range').value = String(percent);
  $('#zoom-value').textContent = `${percent}%`;
  $('#zoom-fit').classList.toggle('is-active', graphZoom.mode === 'fit');
  $('#zoom-reset').classList.toggle('is-active', graphZoom.mode === 'manual' && graphZoom.scale === 1);
}

function clampGraphScale(scale) {
  return Math.min(graphZoom.maxScale, Math.max(graphZoom.minScale, Math.round(scale * 100) / 100));
}

function readSavedGraphScale() {
  try {
    const value = Number.parseFloat(localStorage.getItem(graphZoom.storageKey));
    return Number.isFinite(value) ? clampGraphScale(value) : null;
  } catch (_) {
    return null;
  }
}

function saveGraphScale(scale) {
  try {
    localStorage.setItem(graphZoom.storageKey, String(scale));
  } catch (_) {
    // Viewer remains functional when persistent browser storage is unavailable.
  }
}

function clearSavedGraphScale() {
  try {
    localStorage.removeItem(graphZoom.storageKey);
  } catch (_) {
    // Viewer remains functional when persistent browser storage is unavailable.
  }
}

function renderGraph(nodes) {
  const canvas = $('#graph-canvas');
  const graphClusters = $('#graph-clusters');
  const graphNodes = $('#graph-nodes');
  const edgeLayer = $('#edges');
  const layout = clusterLayout(nodes);
  graphZoom.layout = layout;
  canvas.style.width = `${layout.width}px`;
  canvas.style.height = `${layout.height}px`;
  graphClusters.innerHTML = '';
  graphNodes.innerHTML = '';
  layout.clusters.forEach((cluster) => {
    graphClusters.insertAdjacentHTML('beforeend', `
      <section class="area-cluster" data-area="${cluster.area.id}" style="left:${cluster.x}px;top:${cluster.y}px;width:${cluster.width}px;height:${cluster.height}px;--area-color:${cluster.area.accent}">
        <div class="cluster-heading"><span>${cluster.area.title}</span><strong>${cluster.nodes.length}</strong></div>
        ${cluster.folders.map((folder) => `
          <section class="folder-cluster" data-folder="${folder.folder.id}" style="left:${folder.x - cluster.x}px;top:${folder.y - cluster.y}px;width:${folder.width}px;height:${folder.height}px">
            <div class="folder-heading"><span>${escapeHtml(folder.folder.title)}</span><strong>${folder.nodes.length}</strong></div>
          </section>`).join('')}
      </section>`);
  });
  nodes.forEach((node) => {
    const template = $('#node-template').content.cloneNode(true);
    const element = template.querySelector('button');
    const position = layout.nodePositions.get(node.id);
    element.dataset.id = node.id;
    element.dataset.tier = position.tier;
    element.title = `${node.role} · ${node.importance}`;
    element.classList.add(`node-${position.tier}`);
    element.style.left = `${position.x}px`;
    element.style.top = `${position.y}px`;
    element.style.width = `${position.width}px`;
    element.style.height = `${position.height}px`;
    element.style.setProperty('--area-color', state.data.areas.find((area) => area.id === node.area).accent);
    element.querySelector('.node-kind').style.setProperty('--kind-color', kindColors[node.kind]);
    element.querySelector('.node-kind').textContent = node.kind;
    element.querySelector('strong').textContent = node.title;
    element.querySelector('.node-description').textContent = node.description;
    element.addEventListener('click', () => selectNode(node.id));
    graphNodes.append(element);
  });
  renderEdges(nodes, edgeLayer, layout);
  applyGraphZoom();
}

function renderEdges(nodes, edgeLayer, layout = graphZoom.layout) {
  const visibleIds = new Set(nodes.map((node) => node.id));
  edgeLayer.innerHTML = '<defs><marker id="edge-arrow" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><path fill="context-stroke" d="M 0 0 L 8 4 L 0 8 z" /></marker></defs>';
  state.data.edges.forEach(([from, to, label]) => {
    if (!visibleIds.has(from) || !visibleIds.has(to)) return;
    const fromPosition = layout.nodePositions.get(from);
    const toPosition = layout.nodePositions.get(to);
    if (!fromPosition || !toPosition) return;
    const geometry = edgeGeometry(positionRect(fromPosition), positionRect(toPosition));
    const direction = state.selectedId === from ? ' is-outbound' : state.selectedId === to ? ' is-inbound' : '';
    const related = direction ? ' is-related' : '';
    const muted = state.relationshipFocus && state.selectedId && !direction ? ' is-muted' : '';
    const interCluster = byId.get(from).area !== byId.get(to).area ? ' is-inter-cluster' : '';
    const selectedRelation = relationsById.get(state.selectedRelationId);
    const selected = selectedRelation?.sourceId === from && selectedRelation?.targetId === to ? ' is-selected-relation' : '';
    edgeLayer.insertAdjacentHTML('beforeend', `<path class="edge${interCluster}${related}${direction}${muted}${selected}" data-from="${from}" data-to="${to}" d="${geometry.path}" marker-end="url(#edge-arrow)"><title>${label}</title></path>`);
    if (direction) {
      edgeLayer.insertAdjacentHTML('beforeend', `<text class="edge-label${direction}" x="${geometry.labelX}" y="${geometry.labelY}">${label}</text>`);
    }
  });
}

function positionRect(position) {
  return {
    left: position.x,
    top: position.y,
    right: position.x + position.width,
    bottom: position.y + position.height,
    width: position.width,
    height: position.height
  };
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
    const visibleIds = new Set(areaNodes.map((node) => node.id));
    const folders = state.data.folders
      .filter((folder) => folder.area === area.id)
      .map((folder) => ({
        folder,
        nodes: state.data.nodes.filter((node) => node.folder === folder.id && visibleIds.has(node.id))
      }))
      .filter((folder) => folder.nodes.length)
      .map((folder) => {
        const rows = nodeRows(folder.nodes);
        const nodesHeight = rows.reduce((total, row) => total + row.height, 0) +
          Math.max(0, rows.length - 1) * graphLayout.nodeGapY;
        return {
          ...folder,
          rows,
          height: graphLayout.folderHeaderHeight + graphLayout.folderPadding * 2 + nodesHeight
        };
      });
    const contentHeight = folders.reduce((total, folder) => total + folder.height, 0) +
      Math.max(0, folders.length - 1) * graphLayout.folderGap;
    const height = graphLayout.clusterHeaderHeight + graphLayout.clusterPadding * 2 + contentHeight;
    const column = columnHeights.indexOf(Math.min(...columnHeights));
    const x = graphLayout.outerGap + column * (graphLayout.clusterWidth + graphLayout.clusterGap);
    const y = columnHeights[column];
    const cluster = { area, nodes: areaNodes, folders: [], x, y, width: graphLayout.clusterWidth, height };
    clusters.push(cluster);
    columnHeights[column] += height + graphLayout.clusterGap;

    const folderWidth = graphLayout.clusterWidth - graphLayout.clusterPadding * 2;
    let folderY = y + graphLayout.clusterHeaderHeight + graphLayout.clusterPadding;
    folders.forEach((folder) => {
      const folderX = x + graphLayout.clusterPadding;
      const innerWidth = folderWidth - graphLayout.folderPadding * 2;
      const columnWidth = (innerWidth - graphLayout.nodeGapX) / graphLayout.nodeColumns;
      cluster.folders.push({ ...folder, x: folderX, y: folderY, width: folderWidth });
      let rowY = folderY + graphLayout.folderHeaderHeight + graphLayout.folderPadding;
      folder.rows.forEach((row) => {
        row.items.forEach((item, index) => {
          nodePositions.set(item.node.id, {
            x: folderX + graphLayout.folderPadding + (item.span === graphLayout.nodeColumns ? 0 : index * (columnWidth + graphLayout.nodeGapX)),
            y: rowY,
            width: item.span === graphLayout.nodeColumns ? innerWidth : columnWidth,
            height: graphLayout.nodeHeights[item.tier],
            tier: item.tier
          });
        });
        rowY += row.height + graphLayout.nodeGapY;
      });
      folderY += folder.height + graphLayout.folderGap;
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
  return node.importance;
}

function edgeGeometry(source, target) {
  const sourceCenter = { x: source.left + source.width / 2, y: source.top + source.height / 2 };
  const targetCenter = { x: target.left + target.width / 2, y: target.top + target.height / 2 };
  const dx = targetCenter.x - sourceCenter.x;
  const dy = targetCenter.y - sourceCenter.y;

  if (Math.abs(dx) >= Math.abs(dy)) {
    const direction = dx >= 0 ? 1 : -1;
    const x1 = direction > 0 ? source.right : source.left;
    const y1 = sourceCenter.y - graphLayout.edgePortOffset;
    const x2 = direction > 0 ? target.left : target.right;
    const y2 = targetCenter.y + graphLayout.edgePortOffset;
    const bend = Math.max(56, Math.abs(x2 - x1) * .42);
    return {
      path: `M ${x1} ${y1} C ${x1 + direction * bend} ${y1}, ${x2 - direction * bend} ${y2}, ${x2} ${y2}`,
      labelX: (x1 + x2) / 2,
      labelY: (y1 + y2) / 2 - 9
    };
  }

  const direction = dy >= 0 ? 1 : -1;
  const x1 = sourceCenter.x - graphLayout.edgePortOffset;
  const y1 = direction > 0 ? source.bottom : source.top;
  const x2 = targetCenter.x + graphLayout.edgePortOffset;
  const y2 = direction > 0 ? target.top : target.bottom;
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
      <strong>${escapeHtml(node.title)}</strong><p>${escapeHtml(node.description)}</p>
    </button>`).join('') : '<p class="empty">По фильтрам ничего не найдено.</p>';
  document.querySelectorAll('.inventory-card').forEach((card) => card.addEventListener('click', () => selectNode(card.dataset.id)));
}

function selectNode(id, relationId = null) {
  state.selectedId = id;
  state.selectedRelationId = relationId;
  render();
  setViewerMode(state.viewerMode === 'map' ? 'map' : 'object');
  if (state.viewerMode === 'map' && matchMedia('(max-width: 900px)').matches) setMobilePane('detail');
  $('#viewer-status').textContent = `Открыт объект ${byId.get(id)?.title || id}`;
  requestAnimationFrame(() => {
    const heading = $('#detail').querySelector(relationId ? '#relation-evidence h3' : 'h2');
    if (heading) { heading.tabIndex = -1; heading.focus({ preventScroll: true }); }
  });
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
    $('#detail').innerHTML = '<p class="eyebrow">DETAILS</p><h2>Выбери declaration</h2><p>Стрелка идёт от declaration к другому Domain-типу, который упомянут в его коде.</p>';
    return;
  }
  $('#detail').innerHTML = `
    <p class="eyebrow">${node.area.toUpperCase()} / ${node.role.toUpperCase()} / ${node.kind.toUpperCase()} / ${node.importance.toUpperCase()}</p>
    <h2>${escapeHtml(node.title)}</h2><p><code>${escapeHtml(node.signature)}</code></p>
    <p class="detail-description">${escapeHtml(state.data.semantic?.objects?.[node.id] || 'Назначение не описано.')}</p>
    <p>Описание: ${state.data.semantic?.objects?.[node.id] ? 'курируемый контекст из docs/architecture' : 'отсутствует'} · API fingerprint <code>${escapeHtml(node.apiFingerprint)}</code>.</p>
    ${state.data.contextDiagnostics.filter((d) => d.target === node.title || d.target === node.id).map((d) => `<p class="context-warning">${escapeHtml(d.severity)}: ${escapeHtml(d.code)}. Проверь docs/architecture/domain-viewer-context.json.</p>`).join('')}
    <p>Роль ${escapeHtml(node.role)} определена по каталогу. Состав ниже — declared members из AST. Наследованные members не перечисляются.</p>
    ${['port', 'repository'].includes(node.role) ? `<p>Поиск реализации: проверены ${escapeHtml(state.data.analysis.implementationScan?.outsideDomainFiles.join(', ') || 'внешние файлы не найдены')} в ${escapeHtml(state.data.analysis.implementationScan?.root || 'неизвестном scope')}; объявлено ${state.data.analysis.implementationScan?.found.filter((item) => item.contractId === node.id).length || 0} реализаций. Runtime DI не проверен.</p>` : ''}
    ${(state.data.semantic?.scenarios || []).filter((scenario) => scenario.member.startsWith(node.id + '/')).map((scenario) => `<button class="scenario-link" type="button" data-scenario="${escapeHtml(scenario.id)}">Открыть сценарий: ${escapeHtml(scenario.title)}</button>`).join('')}
    ${memberSections(node)}
    ${inheritedSections(node)}
    ${semanticRelationSections(node)}`;
  document.querySelectorAll('.relation[data-id]').forEach((button) => button.addEventListener('click', () => selectNode(button.dataset.id)));
  if (state.viewerMode === 'map') renderOperationTrace(node);
  $('#detail').querySelectorAll('[data-scenario]').forEach((button) => button.addEventListener('click', () => setViewerMode('scenario')));
  wireRelationButtons($('#detail'));
  renderSelectedRelation();
}

function renderOperationTrace(node) {
  if (node.title !== 'Tournament') return;
  const section = document.createElement('section');
  section.className = 'detail-section operation-trace';
  const trace = state.operationTrace;
  if (!trace) {
    section.textContent = `Трасса операции недоступна: ${state.traceError}. Выполни make domain-check-operation-generate.`;
  } else {
    const labels = { condition: 'Условие', call: 'Вызов', constructor: 'Создание', return: 'Возврат', throw: 'Исключение', local: 'Локальное значение', assignment: 'Присваивание', argument: 'Именованный аргумент' };
    const steps = (operation) => `<ol class="trace-steps">${operation.steps.map((step) => `<li><strong>${labels[step.kind] || step.kind}</strong><span class="trace-location"> · строка ${step.line}</span>${step.context.length ? `<p>${escapeHtml(step.context.join(' → '))}</p>` : ''}<pre>${escapeHtml(step.code)}</pre>${step.target ? `<p>Цель объявления: <code>${escapeHtml(step.target)}</code></p>` : ''}</li>`).join('')}</ol>`;
    section.innerHTML = `<h3>Операция: ${escapeHtml(trace.owner)}.${escapeHtml(trace.method)}</h3><p>Факты resolved AST · analyzer ${escapeHtml(trace.analyzer)}</p><p>Порядок ниже — обход структуры кода, не порядок выполнения.</p>${steps(trace.operation)}${trace.helpers.map((helper) => `<details><summary>Helper ${escapeHtml(helper.name)}</summary>${steps(helper)}</details>`).join('')}<p>${trace.limitations.map(escapeHtml).join(' ')}</p>`;
  }
  $('#detail').append(section);
}

function typeLabel(type) {
  if (!type) return '';
  const status = type.resolution === 'resolved' ? 'разрешён' : type.resolution === 'dynamic' ? 'dynamic' : 'не разрешён';
  return `${escapeHtml(type.display)} · ${status}${type.nullable ? ' · nullable' : ''}`;
}

function memberSections(node) {
  const groups = [
    ['Поля', (m) => m.kind === 'field'],
    ['Конструкторы', (m) => m.kind === 'constructor'],
    ['Публичные операции и accessors', (m) => !['field', 'constructor', 'enum-value'].includes(m.kind) && m.visibility === 'public'],
    ['Внутренние операции', (m) => !['field', 'constructor', 'enum-value'].includes(m.kind) && m.visibility === 'private'],
    ['Значения enum', (m) => m.kind === 'enum-value']
  ];
  return groups.map(([title, predicate]) => {
    const members = node.memberFacts.filter(predicate);
    if (!members.length) return '';
    return `<section class="detail-section"><h3>${title}</h3>${members.map((member) => `<details class="member-fact" id="${escapeHtml(member.id)}"><summary>${escapeHtml(member.signature)}</summary><p>${escapeHtml(member.kind)} · ${escapeHtml(member.visibility)}${member.hasBody === false ? (member.kind === 'constructor' ? ' · без блока тела' : ' · объявление без тела') : ''}</p>${member.type ? `<p>Тип: ${typeLabel(member.type)}</p>` : ''}${member.returnType ? `<p>Результат: ${typeLabel(member.returnType)}</p>` : ''}${(member.parameters || []).map((param) => `<p>Параметр ${escapeHtml(param.name)}: ${typeLabel(param.type)}${param.named ? ' · named' : ''}${param.required ? ' · required' : ''}</p>`).join('')}<a href="#view=object&object=${encodeURIComponent(node.id)}&member=${encodeURIComponent(member.id)}">Ссылка на ${escapeHtml(member.name)}</a><details><summary>Основание из исходника · строка ${member.evidence.line}</summary><pre>${escapeHtml(member.evidence.code)}</pre></details></details>`).join('')}</section>`;
  }).join('');
}

function inheritedSections(node) {
  const facts = node.inheritedFacts || [];
  if (!facts.length) return '';
  const domain = facts.filter((fact) => byId.has(fact.declaringTypeId));
  const external = facts.filter((fact) => !byId.has(fact.declaringTypeId));
  const list = (items) => `<ul>${items.map((fact) => `<li><code>${escapeHtml(fact.name)}</code> · объявлен в ${escapeHtml(fact.declaringType)}${fact.overriddenHere ? ' · переопределён здесь' : ' · не переопределён здесь'}</li>`).join('')}</ul>`;
  return `<section class="detail-section inherited-members"><h3>Наследованные members</h3><p>Отдельно от declared members; declaring type определён analyzer.</p>${domain.length ? list(domain) : '<p>Наследованных Domain members нет.</p>'}${external.length ? `<details><summary>SDK и внешние типы · ${external.length}</summary>${list(external)}</details>` : ''}</section>`;
}

function viewerUrl() {
  const params = new URLSearchParams();
  params.set('view', state.viewerMode || 'overview');
  if (state.selectedId) params.set('object', state.selectedId);
  if (state.selectedRelationId) params.set('relation', state.selectedRelationId);
  if (state.scenarioStep) params.set('step', state.scenarioStep);
  if (state.area !== 'all') params.set('area', state.area);
  if (state.kind !== 'all') params.set('kind', state.kind);
  if (state.search) params.set('search', state.search);
  if (graphZoom.scale !== 1) params.set('zoom', String(graphZoom.scale));
  return '#' + params.toString();
}

function pushViewerHistory() {
  const url = viewerUrl();
  if (location.hash === url) return;
  history.replaceState({ ...(history.state || {}), scrollX: scrollX, scrollY: scrollY, graphX: $('#graph-viewport').scrollLeft, graphY: $('#graph-viewport').scrollTop }, '');
  history.pushState({}, '', url);
}

function restoreViewerLocation() {
  if (!state.data) return;
  const params = new URLSearchParams(location.hash.slice(1));
  const memberId = params.get('member');
  const owner = memberId && state.data.nodes.find((n) => n.memberFacts.some((m) => m.id === memberId));
  state.selectedId = owner?.id || (byId.has(params.get('object')) ? params.get('object') : null);
  state.selectedRelationId = params.get('relation');
  state.scenarioStep = params.get('step');
  state.area = params.get('area') || 'all'; state.kind = params.get('kind') || 'all'; state.search = params.get('search') || '';
  $('#area-filter').value = state.area; $('#kind-filter').value = state.kind; $('#search').value = state.search;
  const zoom = Number(params.get('zoom'));
  if (zoom >= graphZoom.minScale && zoom <= graphZoom.maxScale) graphZoom.scale = zoom;
  const view = params.get('view') || (memberId ? 'object' : 'overview');
  setViewerMode(['overview', 'object', 'scenario', 'map'].includes(view) ? view : 'overview', false);
  render();
  if (memberId) requestAnimationFrame(() => { const element = document.getElementById(memberId); if (element) { element.open = true; element.scrollIntoView({ block: 'nearest' }); } });
  if (history.state?.scrollY !== undefined) requestAnimationFrame(() => { scrollTo(history.state.scrollX || 0, history.state.scrollY); $('#graph-viewport').scrollLeft = history.state.graphX || 0; $('#graph-viewport').scrollTop = history.state.graphY || 0; });
}

function renderBreadcrumbs() {
  const node = byId.get(state.selectedId);
  $('#breadcrumbs').innerHTML = `<button type="button" data-view="overview">Обзор</button>${node ? ` <span aria-hidden="true">›</span> <button type="button" data-view="object">${escapeHtml(node.title)}</button>` : ''}${state.viewerMode === 'scenario' ? ' <span aria-hidden="true">›</span> <span>Сценарий</span>' : ''}`;
  $('#breadcrumbs').querySelectorAll('[data-view]').forEach((button) => button.addEventListener('click', () => setViewerMode(button.dataset.view)));
}

function renderScenarioView() {
  const target = $('#scenario-content');
  const scenarios = state.data.semantic?.scenarios || [];
  if (!scenarios.length) { target.textContent = 'Сценарии не описаны. Технический inventory остаётся доступен.'; return; }
  const traceById = new Map(state.operationTrace ? [state.operationTrace.operation, ...state.operationTrace.helpers].flatMap((operation) => operation.steps.map((step) => [step.id, step])) : []);
  target.innerHTML = scenarios.map((scenario) => `<article class="scenario-card"><h3>${escapeHtml(scenario.title)}</h3><p>${escapeHtml(scenario.summary)}</p><p>Курируемое описание · ${escapeHtml(scenario.status)} · ${escapeHtml(scenario.provenance)}</p><ol>${scenario.steps.map((step) => { const fact = traceById.get(step.traceStep); return `<li><details class="scenario-step" data-step="${escapeHtml(step.traceStep)}"><summary>${escapeHtml(step.label)}</summary><p>Факт из кода: ${fact ? `${escapeHtml(fact.kind)} · строка ${fact.line}` : 'основание не найдено'}</p>${fact ? `<pre>${escapeHtml(fact.code)}</pre>` : ''}<button type="button" data-member="${escapeHtml(step.member)}">Открыть member в объекте</button><small>Контекст: ${escapeHtml(step.member)}</small></details></li>`; }).join('')}</ol></article>`).join('') + (state.operationTrace ? `<details><summary>Техническая AST-трасса ${escapeHtml(state.operationTrace.owner)}.${escapeHtml(state.operationTrace.method)} — не runtime-порядок</summary><ol>${state.operationTrace.operation.steps.map((step) => `<li><strong>${escapeHtml(step.kind)}</strong> · строка ${step.line}<pre>${escapeHtml(step.code)}</pre></li>`).join('')}</ol></details>` : '<p>Техническая трасса недоступна.</p>');
  target.querySelectorAll('.scenario-step').forEach((details) => details.addEventListener('toggle', () => { if (details.open) { state.scenarioStep = details.dataset.step; pushViewerHistory(); } }));
  target.querySelectorAll('[data-member]').forEach((button) => button.addEventListener('click', () => { location.hash = `view=object&member=${encodeURIComponent(button.dataset.member)}`; restoreViewerLocation(); }));
  if (state.scenarioStep) requestAnimationFrame(() => { const element = [...target.querySelectorAll('.scenario-step')].find((step) => step.dataset.step === state.scenarioStep); if (element) { element.open = true; element.scrollIntoView({ block: 'nearest' }); } });
}

window.addEventListener('popstate', restoreViewerLocation);
window.addEventListener('hashchange', restoreViewerLocation);

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

function escapeHtml(value) {
  return String(value)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#039;');
}

window.addEventListener('resize', () => requestAnimationFrame(() => {
  syncViewerHeight();
  applyGraphZoom();
}));
start();
