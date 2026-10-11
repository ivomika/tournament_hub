const fs = require('node:fs');
const path = require('node:path');
const root = path.resolve(__dirname, '..');
const folder = path.join(root, 'ai-context/rules');
const registry = JSON.parse(fs.readFileSync(path.join(folder, 'registry.json'), 'utf8'));
const router = fs.readFileSync(path.join(folder, 'README.md'), 'utf8');
const requiredLinks = [];
let requiredSection = false;
for (const line of router.split(/\r?\n/)) {
  if (line.startsWith('## ')) requiredSection = line.startsWith('## Обязательные');
  if (!requiredSection) continue;
  const match = line.match(/^- \[(R-\d{3}(?:\.[a-z]+)?) · [^\]]+\]\(([^)]+)\)/);
  if (match) requiredLinks.push({ id: match[1], path: match[2] });
}
const errors = [];
if ('aliases' in registry || 'retired' in registry) errors.push('Registry должен содержать только текущие правила');
const ids = new Set();
const paths = new Set();
const groups = new Set(registry.groups.map(group => group.id));
if (groups.size !== registry.groups.length) errors.push('Повторяющиеся группы');
const rootNumbers = [...new Set([...registry.groups, ...registry.rules].map(entry => Number(entry.id.slice(2).split('.')[0])))].sort((a, b) => a - b);
if (rootNumbers.some((number, index) => number !== index + 1)) errors.push('Root ID должны идти подряд начиная с R-001');
const suffixNumber = suffix => [...suffix].reduce((value, char) => value * 26 + char.charCodeAt(0) - 96, 0);
for (const group of registry.groups) {
  const suffixes = registry.rules.filter(rule => rule.id.startsWith(group.id + '.')).map(rule => suffixNumber(rule.id.split('.')[1])).sort((a, b) => a - b);
  if (!suffixes.length || suffixes.some((number, index) => number !== index + 1)) errors.push(`Suffix группы ${group.id} должны идти подряд начиная с a`);
}
for (const rule of registry.rules) {
  if (!/^R-\d{3}(?:\.[a-z]+)?$/.test(rule.id) || ids.has(rule.id)) errors.push(`Некорректный/повторный ID: ${rule.id}`);
  ids.add(rule.id);
  if (rule.id.includes('.') && !groups.has(rule.id.split('.')[0])) errors.push(`Нет группы: ${rule.id}`);
  const group = registry.groups.find(group => group.id === rule.id.split('.')[0]);
  if (group && !rule.path.startsWith(group.folder + '/')) errors.push(`Неверная папка группы: ${rule.id}`);
  if (groups.has(rule.id)) errors.push(`Группа не может быть leaf: ${rule.id}`);
  if (paths.has(rule.path)) errors.push(`Повтор пути: ${rule.path}`);
  paths.add(rule.path);
  const file = path.resolve(folder, rule.path);
  if (!file.startsWith(folder + path.sep) || !fs.existsSync(file)) { errors.push(`Нет файла: ${rule.path}`); continue; }
  const source = fs.readFileSync(file, 'utf8');
  if (!source.startsWith(`# ${rule.id}. `)) errors.push(`Заголовок не соответствует ID: ${rule.path}`);
  const suffix = rule.id.slice(2).replace('.', '-');
  if (!path.basename(rule.path).startsWith(suffix + '-')) errors.push(`Имя файла не соответствует ID: ${rule.path}`);
  if (requiredLinks.filter(link => link.id === rule.id && link.path === rule.path).length !== 1) errors.push(`Rule отсутствует или повторяется в обязательном router: ${rule.id}`);
}
function walk(dir) {
  return fs.readdirSync(dir, { withFileTypes: true }).flatMap(entry => entry.isDirectory() ? walk(path.join(dir, entry.name)) : [path.join(dir, entry.name)]);
}
for (const file of walk(folder).filter(file => file.endsWith('.md'))) {
  const source = fs.readFileSync(file, 'utf8');
  const relative = path.relative(folder, file).replaceAll('\\', '/');
  if (/^# R-\d{3}/.test(source) && !paths.has(relative)) errors.push(`Незарегистрированное правило: ${relative}`);
  for (const match of source.matchAll(/\]\(([^)]+)\)/g)) {
    if (/^(https?:|#)/.test(match[1])) continue;
    const target = path.resolve(path.dirname(file), match[1].split('#')[0]);
    if (!fs.existsSync(target)) errors.push(`Сломанная ссылка: ${relative} → ${match[1]}`);
  }
}
for (const link of requiredLinks) if (!registry.rules.some(rule => rule.id === link.id && rule.path === link.path)) errors.push(`Обязательный router ссылается на незарегистрированный leaf: ${link.id}`);
if (errors.length) { console.error(errors.join('\n')); process.exitCode = 1; }
else console.log(`Правила согласованы: ${registry.rules.length} leaf, ${registry.groups.length} группы.`);
