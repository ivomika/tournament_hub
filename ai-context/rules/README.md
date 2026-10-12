# Правила проекта

Перед работой прочитай этот router и все обязательные core rules. Для Flutter scope дополнительно прочитай все обязательные flutter rules. Для смешанной задачи применяются обе группы. Файл правила определяет trigger применения.

## Обязательные правила core: весь код проекта

- [R-001 · SOLID](core/001-solid.md) — ответственности и зависимости кода.
- [R-002 · Документирование на русском](core/002-documentation-russian.md) — требования, поведение, контракты и решения.
- [R-004 · Обязательная типизация](core/004-typed-values.md) — типизированные модели, значения и сравнения.
- [R-007 · Обязательное тестирование](core/007-code-testing.md) — покрытие поведения, фактические запуски и отчёт.

## Обязательные правила flutter: R-003, архитектура Flutter

- [R-003.a · Границы слоёв](flutter/003-a-layer-boundaries.md) — app/domain/infrastructure/presentation.
- [R-003.b · Use cases через state](flutter/003-b-presentation-use-cases.md) — входы пользовательских сценариев.
- [R-003.c · Изоляция библиотек](flutter/003-c-library-isolation.md) — ports и технические адаптеры.
- [R-003.d · Архитектура дизайн-системы](flutter/003-d-tokenized-widget-themes.md) — токены и темы компонентов.
- [R-003.e · Абсолютные Dart-импорты](flutter/003-e-package-imports.md) — package/dart URI и архитектурный тест зависимостей.
- [R-003.f · Детерминированные screens](flutter/003-f-deterministic-screens.md) — presentation-контракты, независимый preview и композиция DS.

## Обязательные правила flutter: локализация

- [R-005 · Локализация intl](flutter/005-intl-localization.md) — UI-текст, semantics и форматирование.

## Обязательные правила flutter: R-006, композиция UI

- [R-006.a · Композиция widgets](flutter/006-a-widget-composition.md) — private widgets вместо helpers.
- [R-006.b · Именованные callbacks](flutter/006-b-named-widget-callbacks.md) — callbacks и builder-исключение.
- [R-006.c · Визуальные goldens](flutter/006-c-visual-goldens.md) — обязательные нативные PNG/тесты по платформам, comparison и обновление.
- [R-006.d · Scoped Widgetbook](flutter/006-d-scoped-widgetbook.md) — независимые use cases и общие deterministic scenarios.

Flutter scope охватывает весь клиент `apps/tournament_app` и его тесты, включая независимый domain внутри этого приложения. R-003 не задаёт архитектуру spectator web, JS-инструментов или других приложений. Для них архитектурные правила определяются отдельно, когда появится соответствующая задача. Core действует во всех scopes. Других conditional rules сейчас нет.

## Идентификаторы и сопровождение

- Самостоятельное правило: `R-NNN`; именованное подправило: `R-NNN.a/b/c`. Группа обозначает ответственность; findings используют точный leaf ID.
- [Реестр](registry.json) содержит действующие группы, ID и пути.
- Root ID образуют последовательность R-001–R-007; подправила группы — последовательность suffix a, b, c… без пропусков. Новый root — R-008, новый suffix — после максимального suffix группы. Действующие ID изменяются только по явному решению с обновлением всех ссылок.
- Перед изменением правила прочитай [порядок сопровождения](maintenance.md). Организация по scope описана в [docs](../../docs/development/rule-organization.md).
- Проверка: `node tools/check_rules.cjs`.

## Порядок работы

1. Прочитать `ai-context/README.md`, этот router и обязательные core rules.
2. Прочитать task-list и связанную карточку; определить scope.
3. Для Flutter scope прочитать все flutter rules; для иных технологий не переносить на них Flutter-архитектуру.
4. Зафиксировать применимые leaf ID и их влияние. При изменении scope дочитать соответствующие правила.
5. Изменения правил проводить через задачу, docs и append-only changelog.

Прямые требования пользователя имеют приоритет над правилами проекта.
