# Журнал изменений обязательных правил

Этот журнал фиксирует серьёзные изменения enforcement workflow. Он не копирует текст rules, а объясняет причину, влияние и переход.

## RC-001 — Введение модульных правил и applicability evidence

- Дата: 2026-08-26/27.
- Задачи: `TH-20260826-041`, `TH-20260827-042`.
- Решение: правила разделены на тематические файлы; карточка обязана связывать применимые правила и evidence.
- Причина: единый большой текст плохо маршрутизируется и допускает формальное соблюдение.
- Последствия: task template, `AGENTS.md`, AI-context и `$task` стали enforcement points.
- Migration: завершённые старые карточки не переписываются; новые/переоткрытые используют новый template.
- Verification: links/rules structure/task skill validation.

## RC-002 — Docs владеет facts; core/conditional rule routing

- Дата: 2026-08-27.
- Задача: `TH-20260827-043`.
- Решение: project facts удалены из rules; пять core rules читаются всегда, семь conditional rules маршрутизируются по trigger. Rules используют формат `Trigger/Обязательно/Запрещено/Канон/Evidence`.
- Причина: lifecycle, token values, breakpoints и exclusions дублировали `docs`, создавали drift и матрицу формальных `Не применимо`.
- Последствия: `docs` становится единственным владельцем фактов; task template и `$task` переходят на core evidence + conditional trigger scan.
- Migration: завершённые карточки сохраняют старую матрицу; новые/переоткрытые используют новый профиль.
- Rollback: вернуть старый router/template/skill одной связанной задачей и новой записью журнала; копирование facts обратно в rules не допускается.
- Verification: duplicate-fact scan, links, task-template routing и skill validation.

## RC-003 — Обязательная tokenization и Flutter design-system boundaries

- Дата: 2026-08-27.
- Задача: `TH-20260827-046`.
- Решение: rule 06 требует `presentation/design_system`, per-component folders/themes, screen composition только через DS API и обязательный source architecture check.
- Причина: прямое использование tokens и Material widgets не обеспечивало component ownership и допускало bypass дизайн-системы.
- Последствия: новый component обязан иметь typed theme; raw visual values и direct token imports ломают `make check`.
- Migration: presentation задачи `045` переносятся на ADR-0003 без изменения product behavior; новые UI-задачи сразу используют новый contract.
- Rollback: только новым ADR и rule-change entry с эквивалентной автоматической fitness function.
- Verification: positive scan, negative fixtures, analyzer и adaptive widget tests.

## Шаблон следующей записи

```markdown
## RC-NNN — Название
- Дата и задача
- Решение
- Причина
- Последствия
- Migration/rollback
- Verification
```
