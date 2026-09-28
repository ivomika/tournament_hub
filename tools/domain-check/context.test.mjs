import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const architecture = JSON.parse(await readFile(new URL('./domain-architecture.json', import.meta.url), 'utf8'));
const context = JSON.parse(await readFile(new URL('../../docs/architecture/domain-viewer-context.json', import.meta.url), 'utf8'));
const trace = JSON.parse(await readFile(new URL('./operation-trace.json', import.meta.url), 'utf8'));
const traceIds = new Set([trace.operation, ...trace.helpers].flatMap((operation) => operation.steps.map((step) => step.id)));
assert.equal(architecture.version, 9);
assert.equal(architecture.semantic.coverage.areas, architecture.areas.length);
assert.equal(architecture.semantic.coverage.objects, architecture.semantic.coverage.requiredObjects);
assert.equal(architecture.contextDiagnostics.length, 0);
const nodes = new Map(architecture.nodes.map((node) => [node.id, node]));
const members = new Map(architecture.nodes.flatMap((node) => node.memberFacts.map((member) => [member.id, member])));
for (const [id, purpose] of Object.entries(context.objects)) {
  const node = nodes.get(id);
  assert(node, `Missing object ${id}`);
  assert.equal(architecture.semantic.objects[node.id], purpose);
  assert.equal(context.fingerprints[id], node.apiFingerprint);
  assert.notEqual(node.apiFingerprint, node.apiFingerprint + 'changed', 'Changed API must drift');
}
for (const scenario of context.scenarios) {
  assert(members.has(scenario.member));
  assert.equal(scenario.implementationFingerprint, members.get(scenario.member).implementationFingerprint);
  for (const step of scenario.steps) {
    assert(traceIds.has(step.traceStep), `Missing trace step ${step.traceStep}`);
    assert(members.has(step.member));
    assert.equal(step.implementationFingerprint, members.get(step.member).implementationFingerprint);
  }
}
assert(nodes.has(context.scenarios[0].member.split('/method:')[0]));
console.log('Curated purposes, coverage and scenario references verified.');
