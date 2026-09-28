import { readFile, readdir, writeFile } from 'node:fs/promises';
import { spawnSync } from 'node:child_process';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { createHash } from 'node:crypto';

const toolDirectory = path.dirname(fileURLToPath(import.meta.url));
const repositoryRoot = path.resolve(toolDirectory, '..', '..');
const outputPath = path.join(toolDirectory, 'domain-architecture.json');
const contextPath = process.env.DOMAIN_VIEWER_CONTEXT_PATH ? path.resolve(process.env.DOMAIN_VIEWER_CONTEXT_PATH) : path.join(repositoryRoot, 'docs', 'architecture', 'domain-viewer-context.json');
// Windows exposes dart.bat. Only fixed tool-owned arguments pass through cmd.
const result = process.platform === 'win32'
  ? spawnSync('cmd.exe', ['/d', '/s', '/c', 'dart run bin/inventory.dart'], { cwd: path.join(toolDirectory, 'analyzer'), encoding: 'utf8', maxBuffer: 32 * 1024 * 1024 })
  : spawnSync('dart', ['run', 'bin/inventory.dart'], { cwd: path.join(toolDirectory, 'analyzer'), encoding: 'utf8', maxBuffer: 32 * 1024 * 1024 });
if (result.error || result.status !== 0) throw new Error(`Dart inventory failed. Run make domain-check-analyzer-bootstrap.\n${result.error ?? result.stderr}`);
const inventory = JSON.parse(result.stdout);
const nodes = inventory.nodes.sort((a, b) => a.area.localeCompare(b.area) || a.folder.localeCompare(b.folder) || a.title.localeCompare(b.title));
const fingerprint = (value) => createHash('sha256').update((value.match(/"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|\w+|[^\s]/g) || []).join('\u0000')).digest('hex').slice(0, 16);
for (const node of nodes) {
  node.apiFingerprint = fingerprint([node.signature, ...node.memberFacts.filter((member) => member.visibility === 'public').map((member) => member.signature)].join('|'));
  for (const member of node.memberFacts) {
    member.apiFingerprint = fingerprint(member.signature);
    member.implementationFingerprint = fingerprint(member.evidence.code);
  }
}
const context = await readFile(contextPath, 'utf8').then(JSON.parse).catch((error) => {
  if (error.code === 'ENOENT') return null;
  throw error;
});
const operationTrace = await readFile(path.join(toolDirectory, 'operation-trace.json'), 'utf8').then(JSON.parse).catch((error) => {
  if (error.code === 'ENOENT') return null;
  throw error;
});
const traceSteps = new Map(operationTrace ? [operationTrace.operation, ...operationTrace.helpers].flatMap((operation) => operation.steps.map((step) => [step.id, step])) : []);
const contextDiagnostics = [];
const nodeByTitle = new Map(nodes.map((node) => [node.title, node]));
const nodeById = new Map(nodes.map((node) => [node.id, node]));
const findNode = (reference) => nodeById.get(reference) || nodeByTitle.get(reference);
const memberById = new Map(nodes.flatMap((node) => node.memberFacts.map((member) => [member.id, member])));
let semantic = { status: 'missing', areas: {}, objects: {}, scenarios: [], coverage: { areas: 0, objects: 0, requiredObjects: nodes.filter((n) => ['entity', 'model', 'port', 'repository'].includes(n.role)).length } };
if (context) {
  if (context.version !== 1) throw new Error('Unsupported domain-viewer-context.json version');
  if (process.argv.includes('--stamp-context')) {
    context.objects = Object.fromEntries(Object.entries(context.objects).map(([reference, purpose]) => [findNode(reference)?.id || reference, purpose]));
    context.fingerprints = Object.fromEntries(Object.keys(context.objects).map((reference) => [reference, findNode(reference)?.apiFingerprint]));
    context.scenarios.forEach((scenario) => {
      scenario.implementationFingerprint = memberById.get(scenario.member)?.implementationFingerprint;
      scenario.steps.forEach((step) => { step.implementationFingerprint = memberById.get(step.member)?.implementationFingerprint; });
    });
    await writeFile(contextPath, `${JSON.stringify(context, null, 2)}\n`, 'utf8');
  }
  for (const area of Object.keys(context.areas)) if (!nodes.some((node) => node.area === area)) contextDiagnostics.push({ severity: 'error', code: 'UNKNOWN_AREA', target: area });
  for (const reference of Object.keys(context.objects)) {
    const node = findNode(reference);
    if (!node) contextDiagnostics.push({ severity: 'error', code: 'UNKNOWN_OBJECT', target: reference });
    else if (context.fingerprints?.[reference] !== node.apiFingerprint) contextDiagnostics.push({ severity: 'stale', code: 'OBJECT_API_CHANGED', target: reference });
  }
  for (const scenario of context.scenarios) {
    const references = [{ member: scenario.member, implementationFingerprint: scenario.implementationFingerprint }, ...scenario.steps];
    for (const reference of references) {
      const member = memberById.get(reference.member);
      if (!member) contextDiagnostics.push({ severity: 'error', code: 'UNKNOWN_MEMBER', target: reference.member });
      else if (reference.implementationFingerprint !== member.implementationFingerprint) contextDiagnostics.push({ severity: 'stale', code: 'MEMBER_IMPLEMENTATION_CHANGED', target: reference.member });
    }
    for (const step of scenario.steps) if (!traceSteps.has(step.traceStep)) contextDiagnostics.push({ severity: 'error', code: 'UNKNOWN_TRACE_STEP', target: step.traceStep });
  }
  const required = nodes.filter((node) => ['entity', 'model', 'port', 'repository'].includes(node.role));
  for (const node of required) if (!context.objects[node.id]) contextDiagnostics.push({ severity: 'warning', code: 'MISSING_DESCRIPTION', target: node.id });
  semantic = { status: 'available', areas: context.areas, objects: context.objects, scenarios: context.scenarios, coverage: { areas: Object.keys(context.areas).length, objects: required.filter((n) => context.objects[n.id]).length, requiredObjects: required.length } };
} else contextDiagnostics.push({ severity: 'warning', code: 'CONTEXT_MISSING', target: 'docs/architecture/domain-viewer-context.json' });
const colors = ['#ffb900', '#7f8cff', '#ff6e96', '#56d6a5', '#3fb7ff', '#c58cff', '#f19962'];
const areas = [...new Set(nodes.map((n) => n.area))].sort().map((id, index) => ({ id, title: id.split('_').map(capitalize).join(' '), accent: colors[index % colors.length] }));
const folders = [...new Set(nodes.map((n) => n.folder))].sort().map((id) => ({ id, area: nodes.find((n) => n.folder === id).area, title: id.slice(id.indexOf('/') + 1) }));
const nodeIds = new Set(nodes.map((node) => node.id));
const relationOccurrences = inventory.relationOccurrences.map((occurrence) => ({ ...occurrence, targetScope: nodeIds.has(occurrence.targetId) ? 'domain' : occurrence.targetId ? 'external' : 'unknown' }));
const groupedRelations = new Map();
for (const occurrence of relationOccurrences) {
  const id = `relation:${encodeURIComponent(occurrence.sourceId)}:${encodeURIComponent(occurrence.targetId || occurrence.resolution)}:${occurrence.kind}`;
  if (!groupedRelations.has(id)) groupedRelations.set(id, { id, sourceId: occurrence.sourceId, targetId: occurrence.targetId, targetName: occurrence.targetName, targetScope: occurrence.targetScope, kind: occurrence.kind, occurrences: [] });
  groupedRelations.get(id).occurrences.push(occurrence.id);
}
const relations = [...groupedRelations.values()].sort((a, b) => a.id.localeCompare(b.id));
const groupedEdges = new Map();
for (const relation of relations) {
  if (relation.targetScope !== 'domain' || relation.sourceId === relation.targetId) continue;
  const key = JSON.stringify([relation.sourceId, relation.targetId]);
  if (!groupedEdges.has(key)) groupedEdges.set(key, new Set());
  groupedEdges.get(key).add(relation.kind);
}
const edges = [...groupedEdges].map(([key, kinds]) => [...JSON.parse(key), [...kinds].sort().join(', ')]);
edges.sort((a, b) => a.join(':').localeCompare(b.join(':')));
const architecture = {
  title: 'TournamentHUB Domain', version: 9, source: 'resolved Dart AST inventory and relation occurrences',
  analysis: {
    generator: 'tools/domain-check/analyzer/bin/inventory.dart', method: 'resolved-ast-inventory',
    dart: inventory.dart, analyzer: inventory.analyzer,
    primaryRoot: 'apps/tournament_app/lib/domain', excludedFiles: [],
    scannedFiles: inventory.scannedFiles, extractedDeclarations: nodes.length,
    semanticResolution: true, relationResolution: true, implementationLookup: 'resolved-interfaces-outside-domain',
    implementationScan: inventory.implementationScan,
    layers: await Promise.all(['application', 'infrastructure'].map(async (layer) => {
      const root = `apps/tournament_app/lib/${layer}`;
      const entries = await readdir(path.join(repositoryRoot, root)).catch((error) => { if (error.code === 'ENOENT') return null; throw error; });
      return { root, present: entries !== null };
    })),
    descriptions: { documented: nodes.filter((n) => n.descriptionSource === 'doc-comment').length, total: nodes.length },
    diagnostics: [
      { code: 'STATIC_RELATIONS', message: 'Связи получены из resolved AST: типы, наследование, создание объектов и явные вызовы. Это статические объявления, не runtime dispatch, владение или каскадное удаление.' },
      { code: 'INVENTORY_SCOPE', message: 'Реестр поддерживает class и enum, включая поля, конструкторы, getters/setters и методы. Другие declarations обозначаются отдельной диагностикой; inherited members пока не перечисляются.' },
      { code: 'IMPLEMENTATION_SCAN_SCOPE', message: `Проверены ${inventory.implementationScan.outsideDomainFiles.length} Dart-файлов вне Domain в apps/tournament_app/lib; найдено ${inventory.implementationScan.found.length} class/port объявлений. Это не доказывает runtime DI или отсутствие реализаций в других roots.` },
      ...inventory.diagnostics
    ]
  }, areas, folders, nodes, edges, relations, relationOccurrences, semantic, contextDiagnostics
};
const serialized = `${JSON.stringify(architecture, null, 2)}\n`;
if (process.argv.includes('--validate-context-only')) {
  if (contextDiagnostics.some((item) => item.severity === 'error' || item.severity === 'stale')) throw new Error(`Semantic context invalid: ${JSON.stringify(contextDiagnostics)}`);
  console.log(`Context diagnostics: ${JSON.stringify(contextDiagnostics)}`);
  process.exit(0);
}
if (process.argv.includes('--check')) {
  if (contextDiagnostics.some((item) => item.severity === 'error' || item.severity === 'stale')) throw new Error(`Semantic context invalid: ${JSON.stringify(contextDiagnostics)}`);
  const current = await readFile(outputPath, 'utf8').catch(() => '');
  if (current.replaceAll('\r\n', '\n') !== serialized) throw new Error('domain-architecture.json is outdated. Run make domain-check-generate.');
  console.log(`Validated ${nodes.length} objects, ${edges.length} object edges, ${relationOccurrences.length} relation occurrences.`);
} else {
  await writeFile(outputPath, serialized, 'utf8');
  console.log(`Generated ${nodes.length} objects, ${edges.length} object edges, ${relationOccurrences.length} relation occurrences.`);
}
function capitalize(value) { return value.charAt(0).toUpperCase() + value.slice(1); }
