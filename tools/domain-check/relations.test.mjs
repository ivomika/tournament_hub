import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const data = JSON.parse(await readFile(new URL('./domain-architecture.json', import.meta.url), 'utf8'));
assert.equal(data.version, 9);
const nodes = new Map(data.nodes.map((node) => [node.id, node]));
const members = new Set(data.nodes.flatMap((node) => node.memberFacts.map((member) => member.id)));
const occurrences = new Map(data.relationOccurrences.map((occurrence) => [occurrence.id, occurrence]));
assert.equal(occurrences.size, data.relationOccurrences.length);
const sourceCache = new Map();
for (const occurrence of occurrences.values()) {
  assert(nodes.has(occurrence.sourceId));
  assert(!occurrence.sourceMemberId || members.has(occurrence.sourceMemberId));
  if (occurrence.targetScope === 'domain') assert(nodes.has(occurrence.targetId));
  if (!sourceCache.has(occurrence.evidence.source)) sourceCache.set(occurrence.evidence.source, await readFile(new URL(`../../${occurrence.evidence.source}`, import.meta.url), 'utf8'));
  const source = sourceCache.get(occurrence.evidence.source);
  assert.equal(source.slice(occurrence.evidence.offset, occurrence.evidence.offset + occurrence.evidence.length), occurrence.evidence.code);
}
for (const relation of data.relations) {
  assert(relation.occurrences.length > 0);
  for (const id of relation.occurrences) {
    const occurrence = occurrences.get(id);
    assert(occurrence);
    assert.equal(occurrence.sourceId, relation.sourceId);
    assert.equal(occurrence.targetId, relation.targetId);
    assert.equal(occurrence.kind, relation.kind);
  }
}
for (const [source, target] of data.edges) assert(source !== target && nodes.has(source) && nodes.has(target));
const assignment = data.nodes.find((node) => node.title === 'CharacterAssignment');
const participantField = assignment.memberFacts.find((member) => member.name === 'participantId');
const dependencies = data.relationOccurrences.filter((occurrence) => occurrence.sourceMemberId === participantField.id);
assert(dependencies.some((occurrence) => nodes.get(occurrence.targetId)?.title === 'ParticipantId'));
assert(!dependencies.some((occurrence) => nodes.get(occurrence.targetId)?.title === 'Profile'));
console.log(`Validated ${occurrences.size} relation evidence spans, identities and grouping; participantId does not invent a Profile dependency.`);
