import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { readFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';

const script = fileURLToPath(new URL('./domain-structure.mjs', import.meta.url));
const output = new URL('./domain-architecture.json', import.meta.url);
const run = () => spawnSync(process.execPath, [script], { encoding: 'utf8', maxBuffer: 1024 * 1024 });
const first = run();
assert.equal(first.status, 0, first.stderr);
const bytesA = await readFile(output);
const second = run();
assert.equal(second.status, 0, second.stderr);
const bytesB = await readFile(output);
assert(bytesA.equals(bytesB), 'Two generations must be byte-identical');
console.log('Two consecutive Domain inventory generations are byte-identical.');
