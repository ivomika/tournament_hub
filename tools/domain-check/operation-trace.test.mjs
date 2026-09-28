import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const trace = JSON.parse(await readFile(new URL('./operation-trace.json', import.meta.url), 'utf8'));
const source = await readFile(new URL('../../apps/tournament_app/lib/domain/tournament/entities/tournament.dart', import.meta.url), 'utf8');
assert.equal(trace.version, 1);
const steps = trace.operation.steps;
assert(steps.some((s) => s.kind === 'call' && s.target === 'Tournament._requireLifecycle'));
assert(steps.some((s) => s.kind === 'call' && s.target === 'CharacterAssignmentSet.remove'));
assert(steps.some((s) => s.kind === 'call' && s.target === 'Tournament._copy'));
assert(steps.some((s) => s.kind === 'throw' && s.context.some((c) => c.startsWith('if:'))));
assert(trace.helpers.find((h) => h.name === '_copy').steps.some((s) => s.code.includes('revision: revision + 1')));
for (const operation of [trace.operation, ...trace.helpers]) {
  for (const step of operation.steps) {
    assert.equal(source.slice(step.offset, step.offset + step.length), step.code);
    assert.equal(source.slice(0, step.offset).split('\n').length, step.line);
    assert.notEqual(step.target, 'unresolved');
  }
}
console.log('Operation evidence, resolved targets, conditional throw and revision verified.');
