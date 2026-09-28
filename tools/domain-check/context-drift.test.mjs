import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { mkdtemp, readFile, writeFile, rm } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const script = fileURLToPath(new URL('./domain-structure.mjs', import.meta.url));
const source = JSON.parse(await readFile(new URL('../../docs/architecture/domain-viewer-context.json', import.meta.url), 'utf8'));
const temp = await mkdtemp(path.join(os.tmpdir(), 'domain-viewer-context-'));
try {
  const contextPath = path.join(temp, 'context.json');
  const run = () => spawnSync(process.execPath, [script, '--validate-context-only'], { encoding: 'utf8', env: { ...process.env, DOMAIN_VIEWER_CONTEXT_PATH: contextPath }, maxBuffer: 1024 * 1024 });
  await writeFile(contextPath, JSON.stringify(source));
  assert.equal(run().status, 0, 'Valid context must pass');
  const stale = structuredClone(source);
  const first = Object.keys(stale.fingerprints)[0];
  stale.fingerprints[first] = 'changed';
  await writeFile(contextPath, JSON.stringify(stale));
  const staleResult = run();
  assert.notEqual(staleResult.status, 0);
  assert.match(staleResult.stderr, /OBJECT_API_CHANGED/);
  const orphan = structuredClone(source);
  orphan.scenarios[0].steps[0].member = 'package:missing#Removed/method:gone';
  await writeFile(contextPath, JSON.stringify(orphan));
  const orphanResult = run();
  assert.notEqual(orphanResult.status, 0);
  assert.match(orphanResult.stderr, /UNKNOWN_MEMBER/);
  await rm(contextPath);
  const absent = run();
  assert.equal(absent.status, 0);
  assert.match(absent.stdout, /CONTEXT_MISSING/);
  console.log('Stale API, orphan member and absent description file diagnostics verified.');
} finally {
  await rm(temp, { recursive: true, force: true });
}
