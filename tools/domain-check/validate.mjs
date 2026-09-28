import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';

const schema = JSON.parse(await readFile(new URL('./domain-architecture.schema.json', import.meta.url), 'utf8'));
const nodeSchema = schema.$defs.node;
function objectShape(value, shape, label) {
  assert(value && typeof value === 'object' && !Array.isArray(value), `${label} must be an object`);
  for (const key of shape.required) assert(Object.hasOwn(value, key), `${label}.${key} missing`);
}
export function validateArchitecture(data) {
  objectShape(data, schema, 'architecture');
  assert.equal(data.version, schema.properties.version.const);
  objectShape(data.analysis, schema.properties.analysis, 'analysis');
  for (const key of ['areas', 'nodes', 'relations', 'relationOccurrences', 'contextDiagnostics']) assert(Array.isArray(data[key]), `${key} must be an array`);
  objectShape(data.semantic, schema.properties.semantic, 'semantic');
  const nodes = new Map();
  const members = new Map();
  const areas = new Set(data.areas.map((area) => { objectShape(area, schema.properties.areas.items, 'area'); return area.id; }));
  for (const node of data.nodes) {
    objectShape(node, nodeSchema, 'node');
    assert(!nodes.has(node.id), `Duplicate node ${node.id}`);
    assert(areas.has(node.area), `Unknown area ${node.area}`);
    assert(Array.isArray(node.memberFacts) && Array.isArray(node.inheritedFacts));
    nodes.set(node.id, node);
    for (const member of node.memberFacts) {
      objectShape(member, nodeSchema.properties.memberFacts.items, 'member');
      assert(member.id.startsWith(node.id + '/'), `Member owner mismatch ${member.id}`);
      assert(!members.has(member.id), `Duplicate member ${member.id}`);
      members.set(member.id, member);
    }
  }
  const occurrences = new Set();
  for (const occurrence of data.relationOccurrences) {
    objectShape(occurrence, schema.properties.relationOccurrences.items, 'occurrence');
    assert(!occurrences.has(occurrence.id), `Duplicate occurrence ${occurrence.id}`);
    assert(nodes.has(occurrence.sourceId), `Missing source ${occurrence.sourceId}`);
    assert(!occurrence.sourceMemberId || members.has(occurrence.sourceMemberId), `Missing source member ${occurrence.sourceMemberId}`);
    assert(occurrence.evidence && typeof occurrence.evidence.code === 'string', `Missing evidence ${occurrence.id}`);
    occurrences.add(occurrence.id);
  }
  for (const relation of data.relations) {
    objectShape(relation, schema.properties.relations.items, 'relation');
    assert(nodes.has(relation.sourceId), `Missing relation source ${relation.sourceId}`);
    for (const id of relation.occurrences) assert(occurrences.has(id), `Missing occurrence ${id}`);
  }
  return { nodes: nodes.size, members: members.size, occurrences: occurrences.size };
}

if (process.argv[1] && fileURLToPath(import.meta.url) === fileURLToPath(new URL(`file:///${process.argv[1].replaceAll('\\', '/')}`))) {
  const data = JSON.parse(await readFile(new URL('./domain-architecture.json', import.meta.url), 'utf8'));
  console.log('Schema/structure validated:', validateArchitecture(data));
}
