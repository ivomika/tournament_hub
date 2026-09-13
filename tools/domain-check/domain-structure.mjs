import { readFile, readdir, writeFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const toolDirectory = path.dirname(fileURLToPath(import.meta.url));
const repositoryRoot = path.resolve(toolDirectory, '..', '..');
const domainRoot = path.join(repositoryRoot, 'apps', 'tournament_app', 'lib', 'domain');
const outputPath = path.join(toolDirectory, 'domain-architecture.json');
const areaColors = ['#ffb900', '#7f8cff', '#ff6e96', '#56d6a5', '#3fb7ff', '#c58cff', '#f19962'];

const files = (await collectDartFiles(domainRoot))
  .filter((filePath) => path.basename(filePath) !== 'domain.dart')
  .sort();
const declarations = [];

for (const filePath of files) {
  const content = await readFile(filePath, 'utf8');
  const relativePath = path.relative(domainRoot, filePath).replaceAll('\\', '/');
  const pathParts = relativePath.split('/');
  const area = pathParts[0];
  const folderPath = pathParts.slice(1, -1).join('/') || '.';
  const folder = `${area}/${folderPath}`;
  const role = declarationRole(pathParts[1]);
  declarations.push(...extractDeclarations(content, area, folder, role));
}

const duplicateNames = [...new Set(declarations.map((item) => item.name)
  .filter((name, index, names) => names.indexOf(name) !== index))];
if (duplicateNames.length) throw new Error(`Duplicate Domain declarations: ${duplicateNames.join(', ')}`);

const names = new Set(declarations.map((item) => item.name));
const nodes = declarations
  .map(({ sourceText, codeText, ...declaration }) => ({
    id: declaration.name,
    area: declaration.area,
    folder: declaration.folder,
    kind: declaration.kind,
    role: declaration.role,
    importance: declarationImportance(declaration.name, declaration.area, declaration.role, declaration.kind),
    title: declaration.name,
    signature: declaration.signature,
    description: declaration.description,
    members: declaration.members,
    fields: declaration.fields,
    methods: declaration.methods
  }))
  .sort(compareNodes);
const edges = buildEdges(declarations, names);
const areaIds = [...new Set(nodes.map((node) => node.area))].sort();
const areas = areaIds.map((id, index) => ({
  id,
  title: id.split('_').map(capitalize).join(' '),
  accent: areaColors[index % areaColors.length]
}));
const folderIds = [...new Set(nodes.map((node) => node.folder))].sort();
const folders = folderIds.map((id) => {
  const area = nodes.find((node) => node.folder === id).area;
  return {
    id,
    area,
    title: id.slice(area.length + 1)
  };
});

const architecture = {
  title: 'TournamentHUB Domain',
  version: 6,
  source: 'generated from Dart declarations',
  areas,
  folders,
  nodes,
  edges
};
const serialized = `${JSON.stringify(architecture, null, 2)}\n`;

if (process.argv.includes('--check')) {
  const current = await readFile(outputPath, 'utf8').catch(() => '');
  if (current.replaceAll('\r\n', '\n') !== serialized) {
    throw new Error('domain-architecture.json is outdated. Regenerate Domain structure.');
  }
  console.log(`Validated ${nodes.length} Domain objects and ${edges.length} code references.`);
} else {
  await writeFile(outputPath, serialized, 'utf8');
  console.log(`Generated domain-architecture.json: ${nodes.length} objects, ${edges.length} references.`);
}

async function collectDartFiles(directory) {
  const entries = await readdir(directory, { withFileTypes: true });
  const nested = await Promise.all(entries.map((entry) => {
    const absolutePath = path.join(directory, entry.name);
    if (entry.isDirectory()) return collectDartFiles(absolutePath);
    return entry.isFile() && entry.name.endsWith('.dart') ? [absolutePath] : [];
  }));
  return nested.flat();
}

function extractDeclarations(content, area, folder, role) {
  const code = maskNonCode(content);
  const pattern = /^(?:(abstract|base|final|interface|sealed)\s+)*(class)\s+([A-Za-z_]\w*)|^(enum)\s+([A-Za-z_]\w*)/gm;
  const result = [];
  for (const match of code.matchAll(pattern)) {
    const openingBrace = code.indexOf('{', match.index + match[0].length);
    if (openingBrace < 0) throw new Error(`Declaration without body: ${match[3] ?? match[5]}`);
    const closingBrace = matchingBrace(code, openingBrace);
    const name = match[3] ?? match[5];
    const prefix = code.slice(match.index, openingBrace).trim().split(/\s+/);
    const kind = match[4] === 'enum' ? 'enum' : classKind(prefix);
    const sourceText = content.slice(match.index, closingBrace + 1);
    const codeText = code.slice(match.index, closingBrace + 1);
    const bodySource = content.slice(openingBrace + 1, closingBrace);
    const bodyCode = code.slice(openingBrace + 1, closingBrace);
    const members = kind === 'enum' ? enumValues(bodyCode) : [];
    const declarations = kind === 'enum'
      ? { fields: [], methods: [] }
      : declarationMembers(bodySource, bodyCode);
    result.push({
      name,
      area,
      folder,
      kind,
      role,
      signature: content.slice(match.index, openingBrace).replace(/\s+/g, ' ').trim(),
      description: declarationDescription(
        docCommentBefore(content, match.index),
        kind,
        members.length,
        declarations.fields.length,
        declarations.methods.length
      ),
      members,
      fields: declarations.fields,
      methods: declarations.methods,
      sourceText,
      codeText
    });
  }
  return result;
}

function declarationRole(directory) {
  const roles = {
    entities: 'entity',
    models: 'model',
    ports: 'port',
    repositories: 'repository',
    value_objects: 'value-object',
    failures: 'failure'
  };
  return roles[directory] ?? 'declaration';
}

function declarationImportance(name, area, role, kind) {
  if (role === 'entity' && name === area.split('_').map(capitalize).join('')) return 'prominent';
  if (role === 'value-object' || role === 'failure' || kind === 'enum') return 'compact';
  return 'standard';
}

function declarationMembers(source, code) {
  const fields = [];
  const methods = [];
  let start = 0;
  let curlyDepth = 0;
  let parenthesesDepth = 0;
  let bracketDepth = 0;

  for (let index = 0; index < code.length; index += 1) {
    const character = code[index];
    if (character === '(') parenthesesDepth += 1;
    if (character === ')') parenthesesDepth -= 1;
    if (character === '[') bracketDepth += 1;
    if (character === ']') bracketDepth -= 1;

    if (character === '{') {
      const candidate = source.slice(start, index).trim();
      if (curlyDepth === 0 && parenthesesDepth === 0 && bracketDepth === 0 && isCallable(candidate)) {
        methods.push(methodSignature(candidate));
        index = matchingBrace(code, index);
        start = index + 1;
        continue;
      }
      curlyDepth += 1;
      continue;
    }
    if (character === '}' && curlyDepth > 0) {
      curlyDepth -= 1;
      continue;
    }
    if (character !== ';' || curlyDepth !== 0 || parenthesesDepth !== 0 || bracketDepth !== 0) continue;

    const candidate = source.slice(start, index + 1).trim();
    if (candidate) {
      if (isCallable(candidate)) methods.push(methodSignature(candidate));
      else fields.push(fieldSignature(candidate));
    }
    start = index + 1;
  }

  return {
    fields: fields.filter(Boolean),
    methods: methods.filter(Boolean)
  };
}

function isCallable(candidate) {
  const clean = stripAnnotations(candidate);
  if (/^(?:external\s+)?(?:static\s+)?(?:late\s+)?(?:final|const|var)\b/.test(clean)) return false;
  if (/\b(?:get|set|operator)\b/.test(clean)) return true;
  const openingParenthesis = clean.indexOf('(');
  const assignment = clean.search(/(?<![=!<>])=(?!=|>)/);
  return openingParenthesis >= 0 && (assignment < 0 || openingParenthesis < assignment);
}

function methodSignature(candidate) {
  let signature = stripAnnotations(candidate).replace(/;\s*$/, '').trim();
  const arrow = signature.indexOf('=>');
  if (arrow >= 0) signature = signature.slice(0, arrow).trim();

  const openingParenthesis = signature.indexOf('(');
  if (openingParenthesis >= 0) {
    const closingParenthesis = matchingDelimiter(signature, openingParenthesis, '(', ')');
    if (closingParenthesis >= 0 && signature.slice(closingParenthesis + 1).trim().startsWith(':')) {
      signature = signature.slice(0, closingParenthesis + 1);
    }
  }
  return normalizeMember(signature);
}

function fieldSignature(candidate) {
  let signature = stripAnnotations(candidate).replace(/;\s*$/, '').trim();
  const assignment = signature.search(/(?<![=!<>])=(?!=|>)/);
  if (assignment >= 0) signature = signature.slice(0, assignment).trim();
  return normalizeMember(signature);
}

function stripAnnotations(value) {
  return value.replace(/^(?:\s*@\w+(?:\([^)]*\))?\s*)+/, '');
}

function normalizeMember(value) {
  return value.replace(/\s+/g, ' ').trim();
}

function matchingDelimiter(value, openingIndex, opening, closing) {
  let depth = 0;
  for (let index = openingIndex; index < value.length; index += 1) {
    if (value[index] === opening) depth += 1;
    if (value[index] === closing) depth -= 1;
    if (depth === 0) return index;
  }
  return -1;
}

function docCommentBefore(content, declarationIndex) {
  const prefix = content.slice(0, declarationIndex);
  const match = prefix.match(/(?:^|\n)((?:[ \t]*\/\/\/[^\n]*(?:\n|$))+)[ \t]*$/);
  if (!match) return '';
  return match[1]
    .split(/\r?\n/)
    .map((line) => line.replace(/^\s*\/\/\/\s?/, '').trim())
    .filter(Boolean)
    .join(' ');
}

function declarationDescription(docComment, kind, enumCount, fieldCount, methodCount) {
  if (docComment) return docComment;
  if (kind === 'enum') return `Enum: ${counted(enumCount, 'значение', 'значения', 'значений')}.`;
  const labels = {
    interface: 'Интерфейс',
    'sealed-class': 'Sealed class',
    'abstract-class': 'Абстрактный класс',
    class: 'Класс'
  };
  return `${labels[kind]}: ${counted(fieldCount, 'поле', 'поля', 'полей')}, ${counted(methodCount, 'метод', 'метода', 'методов')}.`;
}

function counted(count, one, few, many) {
  const lastTwo = count % 100;
  const last = count % 10;
  const word = lastTwo >= 11 && lastTwo <= 14 ? many : last === 1 ? one : last >= 2 && last <= 4 ? few : many;
  return `${count} ${word}`;
}

function classKind(signatureParts) {
  if (signatureParts.includes('interface')) return 'interface';
  if (signatureParts.includes('sealed')) return 'sealed-class';
  if (signatureParts.includes('abstract')) return 'abstract-class';
  return 'class';
}

function enumValues(body) {
  const valuesSection = body.split(';')[0];
  return valuesSection.split(',')
    .map((value) => value.trim().match(/^([A-Za-z_]\w*)/)?.[1])
    .filter(Boolean);
}

function buildEdges(items, names) {
  const edges = [];
  for (const item of items) {
    const header = item.signature;
    for (const target of names) {
      if (target === item.name || !new RegExp(`\\b${target}\\b`).test(item.codeText)) continue;
      const label = new RegExp(`\\bextends\\s+${target}\\b`).test(header)
        ? 'extends'
        : new RegExp(`\\bimplements\\s+[^{};]*\\b${target}\\b`).test(header)
          ? 'implements'
          : 'references';
      edges.push([item.name, target, label]);
    }
  }
  return edges.sort((left, right) => left.join(':').localeCompare(right.join(':')));
}

function matchingBrace(code, openingBrace) {
  let depth = 0;
  for (let index = openingBrace; index < code.length; index += 1) {
    if (code[index] === '{') depth += 1;
    if (code[index] === '}') depth -= 1;
    if (depth === 0) return index;
  }
  throw new Error('Unbalanced declaration body.');
}

function maskNonCode(source) {
  const chars = [...source];
  let index = 0;
  while (index < chars.length) {
    if (chars[index] === '/' && chars[index + 1] === '/') {
      while (index < chars.length && chars[index] !== '\n') chars[index++] = ' ';
      continue;
    }
    if (chars[index] === '/' && chars[index + 1] === '*') {
      chars[index++] = ' '; chars[index++] = ' ';
      while (index < chars.length && !(chars[index] === '*' && chars[index + 1] === '/')) {
        if (chars[index] !== '\n') chars[index] = ' ';
        index += 1;
      }
      if (index < chars.length) { chars[index++] = ' '; chars[index++] = ' '; }
      continue;
    }
    if (chars[index] === "'" || chars[index] === '"') {
      const quote = chars[index];
      const triple = chars[index + 1] === quote && chars[index + 2] === quote;
      const delimiterLength = triple ? 3 : 1;
      for (let offset = 0; offset < delimiterLength; offset += 1) chars[index++] = ' ';
      while (index < chars.length) {
        if (!triple && chars[index] === '\\') {
          chars[index++] = ' ';
          if (index < chars.length && chars[index] !== '\n') chars[index++] = ' ';
          continue;
        }
        if ((triple && chars[index] === quote && chars[index + 1] === quote && chars[index + 2] === quote) || (!triple && chars[index] === quote)) {
          for (let offset = 0; offset < delimiterLength; offset += 1) chars[index++] = ' ';
          break;
        }
        if (chars[index] !== '\n') chars[index] = ' ';
        index += 1;
      }
      continue;
    }
    index += 1;
  }
  return chars.join('');
}

function compareNodes(left, right) {
  return left.area.localeCompare(right.area) ||
    left.folder.localeCompare(right.folder) ||
    left.title.localeCompare(right.title);
}

function capitalize(value) {
  return value.charAt(0).toUpperCase() + value.slice(1);
}
