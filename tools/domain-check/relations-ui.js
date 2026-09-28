const relationLabels = {
  extends: 'Наследование', implements: 'Реализация интерфейса', mixin: 'Mixin',
  'field-type': 'Тип поля', 'parameter-type': 'Тип параметра', 'return-type': 'Тип результата',
  call: 'Вызов метода', create: 'Создание объекта', 'constructor-call': 'Вызов конструктора', 'type-use': 'Аргумент generic-типа'
};
const relationsById = new Map();
const occurrencesById = new Map();

function setupRelations() {
  state.data.relations.forEach((relation) => relationsById.set(relation.id, relation));
  state.data.relationOccurrences.forEach((occurrence) => occurrencesById.set(occurrence.id, occurrence));
  $('#show-overview').addEventListener('click', () => setViewerMode('overview'));
  $('#show-object').addEventListener('click', () => setViewerMode('object'));
  $('#show-scenario').addEventListener('click', () => setViewerMode('scenario'));
  $('#show-map').addEventListener('click', () => setViewerMode('map'));
  $('#mobile-show-map').addEventListener('click', () => setMobilePane('map'));
  $('#mobile-show-detail').addEventListener('click', () => setMobilePane('detail'));
  setViewerMode('overview', false);
}

function setMobilePane(pane) {
  $('.workspace').dataset.pane = pane;
  $('#mobile-show-map').setAttribute('aria-pressed', String(pane === 'map'));
  $('#mobile-show-detail').setAttribute('aria-pressed', String(pane === 'detail'));
  if (pane === 'map') requestAnimationFrame(() => { syncViewerHeight(); applyGraphZoom(); });
}

function setViewerMode(mode, updateHistory = true) {
  state.viewerMode = mode;
  $('#area-overview').hidden = mode !== 'overview';
  $('#scenario-view').hidden = mode !== 'scenario';
  $('.workspace').hidden = mode !== 'map' && mode !== 'object';
  $('.workspace').classList.toggle('object-mode', mode === 'object');
  $('.inventory-panel').hidden = mode !== 'map';
  for (const option of ['overview', 'object', 'scenario', 'map']) $('#show-' + option).setAttribute('aria-pressed', String(mode === option));
  if (mode === 'map') {
    if (!$('.workspace').dataset.pane) setMobilePane('map');
    renderGraph(visibleNodes());
    requestAnimationFrame(() => { syncViewerHeight(); applyGraphZoom(); });
  }
  renderBreadcrumbs();
  if (updateHistory) pushViewerHistory();
}

function relationButton(relation) {
  const source = byId.get(relation.sourceId)?.title || relation.sourceId;
  const target = byId.get(relation.targetId)?.title || relation.targetName || 'неизвестная цель';
  return `<button type="button" class="relation semantic-relation" data-relation="${escapeHtml(relation.id)}">${escapeHtml(source)} → ${escapeHtml(target)} · ${relationLabels[relation.kind] || relation.kind} · ${relation.occurrences.length}</button>`;
}

function wireRelationButtons(container) {
  container.querySelectorAll('[data-relation]').forEach((button) => button.addEventListener('click', () => {
    const relation = relationsById.get(button.dataset.relation);
    state.search = ''; state.area = 'all'; state.kind = 'all';
    $('#search').value = ''; $('#area-filter').value = 'all'; $('#kind-filter').value = 'all';
    setViewerMode('object');
    selectNode(relation.sourceId, relation.id);
    $('#relation-evidence').scrollIntoView({ block: 'nearest' });
  }));
}

function semanticRelationSections(node) {
  const outgoing = state.data.relations.filter((r) => r.sourceId === node.id);
  const incoming = state.data.relations.filter((r) => r.targetId === node.id && r.sourceId !== node.id);
  const visible = outgoing.filter((r) => r.targetScope === 'domain');
  const other = outgoing.filter((r) => r.targetScope !== 'domain');
  return `<section class="detail-section"><h3>Связи из кода</h3><p>Статические объявления; runtime-реализация может отличаться.</p>${visible.map(relationButton).join('') || '<p>Нет прямых Domain-зависимостей.</p>'}</section><section class="detail-section"><h3>Кто использует объект</h3>${incoming.map(relationButton).join('') || '<p>Нет входящих связей.</p>'}</section>${other.length ? `<details class="detail-section"><summary>SDK, внешние и неизвестные цели · ${other.length}</summary>${other.map(relationButton).join('')}</details>` : ''}`;
}

function renderSelectedRelation() {
  const relation = relationsById.get(state.selectedRelationId);
  if (!relation) return;
  const section = document.createElement('section');
  section.id = 'relation-evidence';
  section.className = 'detail-section relation-evidence';
  const source = byId.get(relation.sourceId)?.title;
  const target = byId.get(relation.targetId)?.title || relation.targetName || 'неизвестная цель';
  section.innerHTML = `<h3>${relationLabels[relation.kind] || relation.kind}</h3><p><strong>${escapeHtml(source)} → ${escapeHtml(target)}</strong></p><p>${relation.occurrences.length} оснований. Хранение ID не означает владение или каскадное удаление.</p>${relation.occurrences.map((id) => {
    const occurrence = occurrencesById.get(id);
    const member = byId.get(occurrence.sourceId)?.memberFacts.find((m) => m.id === occurrence.sourceMemberId);
    return `<details class="relation-occurrence"><summary>${member ? escapeHtml(member.name) : 'Объявление объекта'} · строка ${occurrence.evidence.line} · ${escapeHtml(occurrence.resolution)}</summary>${member ? `<p><a href="#member=${encodeURIComponent(member.id)}">Открыть ${escapeHtml(member.name)}</a></p>` : ''}${occurrence.targetMember ? `<p>Статическая цель: ${escapeHtml(target)}.${escapeHtml(occurrence.targetMember)}</p>` : ''}${occurrence.type ? `<p>Тип: ${escapeHtml(occurrence.type.display)}</p>` : ''}${occurrence.parameter ? `<p>Параметр: ${escapeHtml(occurrence.parameter)}</p>` : ''}<pre>${escapeHtml(occurrence.evidence.code)}</pre></details>`;
  }).join('')}`;
  $('#detail').prepend(section);
}

function renderAreaOverview(nodes) {
  const visibleIds = new Set(nodes.map((n) => n.id));
  const relations = state.data.relations.filter((r) => r.targetScope === 'domain' && visibleIds.has(r.sourceId) && visibleIds.has(r.targetId));
  $('#area-cards').innerHTML = state.data.areas.map((area) => {
    const objects = nodes.filter((n) => n.area === area.id);
    if (!objects.length) return '';
    const roles = [...new Set(objects.map((n) => n.role))].map((role) => `${role}: ${objects.filter((n) => n.role === role).length}`).join(' · ');
    const contracts = objects.filter((n) => n.role === 'port' || n.role === 'repository');
    const implementations = state.data.analysis.implementationScan?.found.filter((item) => contracts.some((contract) => contract.id === item.contractId)) || [];
    return `<article class="area-card"><h3>${escapeHtml(area.title)}</h3><p>${escapeHtml(state.data.semantic?.areas?.[area.id] || 'Назначение области не описано.')}</p><p>${objects.length} объектов · ${objects.reduce((sum, n) => sum + n.memberFacts.filter((m) => m.visibility === 'public' && ['method', 'getter', 'setter', 'operator'].includes(m.kind)).length, 0)} публичных операций/accessors</p><p>Контрактов: ${contracts.length}; объявленных реализаций в проверенном внешнем scope: ${implementations.length}.</p><p>${escapeHtml(roles)}</p><details><summary>Объекты области</summary><div class="area-objects">${objects.map((n) => `<button type="button" data-object="${escapeHtml(n.id)}">${escapeHtml(n.title)}</button>`).join('')}</div></details></article>`;
  }).join('') || '<p>Области не найдены по текущим фильтрам.</p>';
  $('#area-cards').querySelectorAll('[data-object]').forEach((button) => button.addEventListener('click', () => { selectNode(button.dataset.object); }));
  const pairs = new Map();
  for (const relation of relations) {
    const from = byId.get(relation.sourceId).area;
    const to = byId.get(relation.targetId).area;
    if (from === to) continue;
    const key = `${from}:${to}`;
    if (!pairs.has(key)) pairs.set(key, { from, to, relations: [] });
    pairs.get(key).relations.push(relation);
  }
  $('#area-connections').innerHTML = [...pairs.values()].map((pair) => `<details class="area-connection"><summary>${escapeHtml(pair.from)} → ${escapeHtml(pair.to)} · ${pair.relations.length} связей · ${pair.relations.reduce((sum, r) => sum + r.occurrences.length, 0)} оснований</summary><div class="relations">${pair.relations.map(relationButton).join('')}</div></details>`).join('') || '<p>Межобластных связей в текущей выборке нет.</p>';
  wireRelationButtons($('#area-connections'));
}
