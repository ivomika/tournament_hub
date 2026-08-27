# Политика серьёзных решений

## Что считается серьёзным решением

Решение серьёзное, если оно меняет хотя бы одно:

- пользовательское поведение, permission, lifecycle или scope;
- architecture boundary, authority, dependency direction, technology baseline или public API;
- Domain semantics, ruleset, ranking, scoring или correction;
- persisted/wire schema, migration, consistency, security или privacy;
- design-token source, token semantics, accessibility contract или screen navigation model;
- обязательное правило работы, quality gate, supported platform или release policy.

Refactoring без observable/contract impact может не создавать отдельный decision record, но карточка обязана объяснить отсутствие серьёзного решения.

## Обязательный артефакт

| Тип решения | До реализации | Канонический артефакт |
|---|---|---|
| Product/domain behavior | Решение подтверждено, open question закрыт | Owning product/domain doc + запись закрытия open decision при наличии |
| Architecture/technology | Alternatives и migration оценены | ADR со статусом Accepted |
| Data/protocol/security | Compatibility и recovery определены | Versioned contract + ADR, если меняется strategy/boundary |
| Design token/navigation | Semantics, consumers и migration определены | Design manifest/screen map + ADR для смены source/model |
| Project rule/workflow | Rationale и влияние на task lifecycle определены | Rule file + `rule-change-log.md` |
| Release/platform | Support/rollback определены | Operations/release doc + ADR при изменении baseline |

## Обязательные поля решения

- Stable ID и дата.
- Связанная task card и владелец.
- Контекст/проблема и ограничения.
- Выбранное решение и отклонённые существенные альтернативы.
- Последствия и затронутые consumers.
- Migration/compatibility/rollback либо явная причина неприменимости.
- Verification/evidence.
- Ссылки на обновлённый канон/contracts/rules.

## Порядок

1. До кода определить, является ли выбор серьёзным.
2. Если решение неизвестно — добавить open decision и исключить зависимую реализацию.
3. Создать required artifact и получить подтверждение решения.
4. Реализовать и проверить согласно artifact.
5. Перед завершением сверить artifact с итоговым diff и обновить traceability.

## Запреты

- Task card, chat, commit message и code comment не являются единственным хранилищем серьёзного решения.
- Accepted ADR не переписывается задним числом; новое решение supersedes старое.
- Rule нельзя менять без записи причины, влияния и migration workflow.
- Architecture нельзя менять «рефакторингом», если фактически изменились boundaries/authority/contracts.

## Review gate

Reviewer проверяет не только наличие документа, но и соответствие code/design diff решению. Отсутствующий required artifact блокирует `Выполнена`.
