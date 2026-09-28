import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { validateArchitecture } from './validate.mjs';

const data = JSON.parse(await readFile(new URL('./domain-architecture.json', import.meta.url), 'utf8'));
const counts = validateArchitecture(data);
assert.equal(counts.nodes, 87);
const broken = structuredClone(data);
broken.nodes[0].memberFacts[0].id = 'orphan';
assert.throws(() => validateArchitecture(broken), /Member owner mismatch/);
console.log('Schema and broken member identity verified.');
