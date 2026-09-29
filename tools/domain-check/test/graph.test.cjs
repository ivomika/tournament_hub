const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');
const { layoutGraph } = require('../graph-layout.js');

const graph = JSON.parse(fs.readFileSync(
  path.join(__dirname, '..', 'domain-architecture.json'), 'utf8'));
const nodes = new Map(graph.nodes.map(node => [node.id, node]));

test('карта содержит все области без ранжирования объектов', () => {
  assert.equal(graph.schemaVersion, 1);
  assert.deepEqual(graph.areas, [...graph.areas].sort());
  assert.equal(nodes.size, graph.nodes.length);
  assert.ok(graph.nodes.length > 0);
  for (const node of graph.nodes) {
    assert.ok(graph.areas.includes(node.area));
    assert.equal(Object.hasOwn(node, 'importance'), false);
    assert.ok(Array.isArray(node.fields));
    assert.ok(Array.isArray(node.methods));
  }
});

test('подтверждённые рёбра указывают на существующие объявления или методы', () => {
  const methods = new Set(graph.nodes.flatMap(node => node.methods.map(method => method.id)));
  for (const edge of graph.edges) {
    if (edge.kind === 'type') {
      assert.ok(nodes.has(edge.from));
      assert.ok(nodes.has(edge.to));
    } else {
      assert.ok(methods.has(edge.from));
      if (edge.kind === 'call') assert.ok(methods.has(edge.to));
      if (edge.kind === 'throw' && edge.to === null) {
        assert.ok(edge.externalName);
      }
    }
  }
});

test('Tournament.finish показывает только подтверждённые вызовы и исключения', () => {
  const start = 'tournament.Tournament::finish';
  const direct = graph.edges.filter(edge => edge.kind === 'call' && edge.from === start);
  assert.deepEqual(direct.map(edge => edge.to).sort(), [
    'tournament.Tournament::_copy',
    'tournament.Tournament::_requireLifecycle',
    'tournament.Tournament::_validateOutcome',
  ]);
  const reached = new Set([start]);
  const queue = [start];
  while (queue.length) {
    const from = queue.shift();
    for (const edge of graph.edges.filter(edge => edge.kind === 'call' && edge.from === from)) {
      if (!reached.has(edge.to)) {
        reached.add(edge.to);
        queue.push(edge.to);
      }
    }
  }
  assert.ok(reached.has('tournament.Tournament::Tournament._'));
  assert.ok(reached.has('tournament.Tournament::_validate'));
  assert.ok(reached.has('tournament.Tournament::_requireUtc'));
  assert.deepEqual([...new Set(graph.edges.filter(edge => edge.kind === 'throw' && reached.has(edge.from))
    .map(edge => edge.externalName || nodes.get(edge.to)?.name))].sort(),
  ['ArgumentError', 'StateError']);
  assert.equal(graph.edges.some(edge => edge.from === 'tournament.TournamentCompletionPort::finish'
    && edge.to === start), false);
  assert.deepEqual(nodes.get('tournament.TournamentCompletionPort').implementedBy, []);
});

test('радиальный граф ставит объект с максимумом исходящих связей в центр и не теряет объявления', () => {
  const entries = graph.nodes.filter(node => node.area === 'tournament');
  const ids = new Set(entries.map(node => node.id));
  const edges = graph.edges.filter(edge => edge.kind === 'type'
    && ids.has(edge.from) && ids.has(edge.to));
  const layout = layoutGraph(entries, edges);
  assert.equal(layout.hub, 'tournament.Match');
  assert.equal(layout.outgoingCount, 8);
  assert.equal(layout.positions.size, entries.length);
  assert.deepEqual([...layout.positions.entries()],
    [...layoutGraph(entries, edges).positions.entries()]);
  for (const pair of layout.treePairs) {
    assert.ok(edges.some(edge => [edge.from, edge.to].sort().join('|') === pair));
  }
  for (const entry of entries) {
    const position = layout.positions.get(entry.id);
    assert.ok(Number.isFinite(position.x) && Number.isFinite(position.y));
    assert.ok(position.x > 0 && position.x < layout.width);
    assert.ok(position.y > 0 && position.y < layout.height);
  }
});

test('изолированные компоненты остаются на графе без выдуманных рёбер', () => {
  const entries = [{id:'a'}, {id:'b'}, {id:'c'}, {id:'d'}];
  const edges = [{from:'a', to:'b'}, {from:'a', to:'c'}];
  const layout = layoutGraph(entries, edges);
  assert.equal(layout.hub, 'a');
  assert.equal(layout.positions.size, 4);
  assert.equal(layout.treePairs.size, 2);
  assert.notEqual(layout.positions.get('d').component, layout.positions.get('a').component);
});

test('центр выбирается по исходящим, а не по входящим зависимостям', () => {
  const entries = [{id:'provider'}, {id:'consumer'}, {id:'other'}];
  const edges = [
    {from:'consumer', to:'provider'},
    {from:'consumer', to:'other'},
    {from:'other', to:'provider'},
  ];
  const layout = layoutGraph(entries, edges);
  assert.equal(layout.hub, 'consumer');
  assert.equal(layout.outgoingCount, 2);
});
