# Задача 33. Presentation, Widgetbook и golden

## Статус и этап

✅ Завершена

- Mode: CODE (документация и визуальный каркас; перенос bootstrap).
- Stage: DONE.
- TestGate: REQUIRED только для behavior-preserving переноса app-bootstrap; документация, каталог и визуальный test harness не требуют gate.
- Versions: specification 1, plan 1, test set 1.

## Цель и контекст

Закрепить единый порядок разработки детерминированного UI через дизайн-систему, presentation-контракты, scoped Widgetbook и Linux golden. На старте в ветке были только шаблонный main.dart и пустой main_widgetbook.dart; docs/source и проектных компонентов нет. Не считать историческую карту domain текущей реализацией UI.

## Scope и non-goals

- Rules/router/registry, архитектурная документация и визуальный workflow.
- presentation/design_system/{foundation,components,widgets}, screens и widgetbook; минимальная программная обвязка пустого каталога и golden test harness.
- main_widgetbook → app-bootstrap → presentation/widgetbook. Тонкий bootstrap не содержит бизнес-логики. Основное приложение не мигрируется в этой задаче: его прежний Hello World — legacy template, не дизайн-система.
- Без демонстрационных компонентов/экранов, продуктовых controllers/use cases, новой палитры, генератора Widgetbook, production PNG и изменения domain/infrastructure.
- Linux — каноническая golden-среда; не генерировать эталоны на Windows. Нет готового UI — нет ложных PNG и фиктивных product goldens.

## Применимые правила

- R-001/R-002: единая документация решений, минимальная обвязка без абстракций ради будущих продуктов.
- R-004/R-007: типизированные presentation-контракты, baseline для переноса, фиксированная render-среда и честные evidence.
- R-003.a/b/c/e: app связывает entrypoint с presentation; UI не получает DI/infrastructure/use cases напрямую, package imports.
- R-003.d/R-005/R-006.a/b: темы и локализация собственного UI, named callbacks и builder-контракты. Новых UI-примеров/текстов продукта нет.
- Новые правила дополняют существующие группы без изменения ID; maintenance прочитан. Conditional rules отсутствуют.

## Уточнения и решения

- Экран получает presentation controller-контракт через конструктор; preview-реализация задаёт состояние без сети/DI/use cases. Экран не выполняет бизнес-логику.
- Layout-примитивы Flutter разрешены с параметрами из темы экрана. Повторяемая композиция извлекается в design_system/widgets.
- Каждый визуальный компонент/экран имеет PNG рядом в golden/; тесты — в test/presentation с зеркальной структурой.
- Основной вид и значимые состояния; экраны — mobile и desktop. Профили размеров/locale/DPR/шрифтов фиксируются, нельзя использовать случайность/сеть/текущее время.
- Golden обновляет агент и показывает результаты без отдельного approval; golden не заменяет test-first gate логики.
- Linux — единая среда эталонов и CI. Widgetbook/golden используют общие сценарии; knobs дополнительные.
- Widgetbook scopes повторяют foundation/components/widgets/screens, каждый use case имеет собственную папку.
- Принят новый перенос main → app-bootstrap → presentation/widgetbook вместо временного standalone main из задачи 32.

## Acceptance Criteria

- [x] AC-1: rules/docs однозначно задают структуру DS, темы, независимость screens и отсутствие дублирования.
- [x] AC-2: определён контракт общего детерминированного сценария Widgetbook/golden, реализованы общие viewport-профили; Linux-контракт и процесс update/compare документированы. Конкретные product scenarios отсутствуют вместе с самими компонентами.
- [x] AC-3: минимальная обвязка пустого Widgetbook находится в presentation; main обращается к app; новых showcase widgets/screens нет.
- [x] AC-4: test-only golden hook и структура готовы к будущим компонентам, production PNG без компонентов не создаются. Product fonts/Linux CI обязательны перед первым реальным golden, не входят в пустой каркас.
- [x] AC-5: tests/analyzer/architecture-check и rules/links проходят; ограничения Linux проверки отражены честно.

## Ошибки и границы

- PNG без executable comparison не является golden-покрытием.
- Изменение темы общего компонента требует проверки всех затронутых состояний/экранов, а не автоматического принятия любого diff.
- Windows эталоны не заменяют Linux; отсутствие Linux runner явно ограничивает проверку.
- Stateless screen не означает отсутствие controller-контракта: наблюдение состояния допустимо, бизнес-переходы и use cases не принадлежат screen.

## Test Scenarios и план

1. Документировать структуру, зависимости и шаги добавления элемента/use case/golden; обновить R-003.d, добавить screens/golden/Widgetbook leaves и связать router/registry.
2. Проверить baseline реального пустого Widgetbook и launcher; gate относится только к переносу bootstrap с сохранением поведения.
3. После baseline-gate: перенести оболочку Widgetbook в presentation, добавить тонкий bootstrap в app, entrypoint вызывает bootstrap. Пакет/каталог/launch env сохранены.
4. Добавить только scoped каркас и test-only render harness, без product UI. Будущие эталоны находятся рядом с элементами, tests в test/presentation.
5. Tests/analyzer/architecture/rules/links; Linux verification отделить от Windows tests.

## Test Evidence

- BASELINE_GREEN, 2026-10-12: `flutter test --no-pub` из apps/tournament_app — 2 passed; `flutter analyze --no-pub` — No issues found.
- `make architecture-test DART=C:/Users/ivomika/Documents/workspace/sdk/flutter/bin/cache/dart-sdk/bin/dart.exe` — 49 self-tests passed, 3 файлов клиента, imports без нарушений.
- `node tools/check_rules.cjs` — 15 leaf, 2 группы. Проверяет добавленные ID/router/registry.
- Markdown links — 77 файлов, все targets существуют; `git diff --check` — успешно, только CRLF warnings.
- Перенос bootstrap/оболочки сохраняет наблюдаемое поведение пустого Widgetbook; existing test вызывает реальный entrypoint и проверяет каталог/исключения/профили. Поэтому gate использует baseline, не искусственный RED.
- Production Dart/Make/CI код пока не менялся. Linux golden generation/comparison не выполнялись: product UI и baselines отсутствуют.
- GREEN после approval: `flutter test --no-pub` — 5 passed (2 baseline + 3 test-only environment/guard); `flutter analyze --no-pub` — No issues found. Последний повтор также прошёл после фиксации/reset DPR и проверки обоих viewport.
- Architecture self-tests — 49 passed, текущие 9 Dart-файлов lib/test без запрещённых imports. Checker не менялся и не ослаблялся.
- Rules checker — 15 leaf/2 группы; Markdown links — 78 файлов без ошибок; diff-check — успешно. main.dart и .vscode/launch.json неизменны.
- DTD найден и подключён, активных Flutter apps нет; hot restart недоступен. Новый build/run не выполнялся. Пустой каталог проверен через настоящий entrypoint widget-тестом, F5 не объявляется проверенным.
- Linux comparison/генерация и реальный font rendering: NOT_RUN/неприменимы к пустому каркасу. Windows guard проверен, PNG не создавались; Linux guard сам по себе не подтверждает готовый CI/image/font loader.

## Approval

- Пользователь, 2026-10-12: «делаем».
- Ответ на baseline GREEN gate переноса main → app-bootstrap → presentation/widgetbook; утверждены specification/plan/test set v1. Approval записан до production Dart diff.
- Golden-обвязка — test-only default flutter_test_config, без нового testing framework: фиксированное окружение и Linux-only comparator. Viewport-профили общие с будущими Widgetbook-сценариями. Product fonts добавляются с первым реальным компонентом, Ahem не выдаётся за его typography.

## Changelog

### Итерация 1 — постановка и уточнения

**Prompt пользователя**

> так давай добавим правила работы с интерфейсом и виджет буком. весь ui хранится в presentation. Внутри должна быть папка design_system описывающая дизайн систему и компоненты. внутри папрки foundation описывающие самые базовые принципы: цвета, текста и тд. Далее components это мелкие компоненты системы. widgets композиционнаые виджеты. каждый из элементов в своей папке с своей темой. так же в папке должен находится golden этого виджета для будущего визуального сравнения изменений. Нужно внести правило что каждый визуальный компонент системы должен обладать своим голденом и затрагивая ui мы обязательно формируем golden. Так же в папке presentation помимо папки design system Должна быть папка screens. Screens не имеет право делать кастомные компоненты, только компоненты design system так же экраны должны быть тоже токенезированы. Еще экраны обязаны быть обособленными и иметь возможность быть вызваны индивидуально без зависимостей. Экраны не наделены логикой и являются независимыми частицами визула и детерменированы. Изменяясь только за счет presentation контракта. Повторно использованные компоненты не должны рисоваться на каждом экране. Все это надо тоже вынести в правило по экранам. так же в презентатион мы должны вынести widgetbook внутри каждый юзкейс в своей папочке своего scope должно быть единое правило ведения widgetbook. Давай уточним подробности и реализуем минимальнуб обвязку в коде, добавим полноценную документацию и правила, но сначала позадавай уточняющие вопросы в интерактивном формате

**Ответы пользователя (дословно)**

- Зависимости screen: «Экран может получать state/controller».
- Golden update: «Агент обновляет эталон сам и показывает результат».
- Минимальная обвязка: «Только каркас и инфраструктуру, без примеров UI».
- Presentation-контракт и независимый preview: «Да, контракт и preview-реализация».
- Layout: «Да, layout-примитивы разрешены».
- Golden coverage: «Основной вид + значимые состояния; для экранов mobile и desktop».
- Хранение: «Да, PNG рядом; тесты в test/presentation».
- Каноническая среда: «Linux — единая среда CI».
- Сценарии: «Да, общие сценарии для Widgetbook и golden».
- Перенос оболочки: «Да, main → app-bootstrap → presentation/widgetbook».

**Изменения**

- Исследованы действующие rules/workflow и минимальный Flutter-клиент. Scope и ответы сохранены, без создания UI-примеров. Реализация разделена на документы/визуальную обвязку и механический app-refactor.
- Добавлены docs/architecture/presentation-ui.md и docs/development/visual-workflow.md; связанные docs/workflow обновлены. R-003.d уточнён, добавлены R-003.f, R-006.c/d, router и registry. R-007 отделяет обязательные Flutter goldens от логического TestGate.
- Созданы только явно запрошенные верхнеуровневые presentation scopes с указателями на docs. Папок конкретных элементов/use cases и PNG нет. Полноценные продуктовые темы/шрифты не выдумываются.
- Baseline переноса подтверждён; Stage PLAN_READY → BASELINE_GREEN → AWAITING_APPROVAL. App-refactor ждёт контекстного approval, остальные документы не блокировались этим gate.

### Итерация 2 — кодовая обвязка

**Prompt пользователя**

> делаем

**Изменения и проверки**

- Approval v1 сохранён до code diff. main_widgetbook вызывает app bootstrap; оболочка и registry находятся в presentation/widgetbook. Каталог без компонентов/use cases/addons; основной app/launcher сохранён.
- Общие VisualViewport mobile/desktop — тестовый контекст, не произвольные product design tokens. Конкретные сценарии/контракты появятся с соответствующим UI, не создана универсальная фабрика controllers.
- Test-only flutter_test_config устанавливает/reset locale ru, text scale/DPR 1. Linux comparator делегирует штатному Flutter comparator и versioned URI; запрещает compare и update вне Linux. Дополнительный testing package не нужен, test imports не обходят R-003.e.
- Добавлены три проверки обвязки без production PNG/шрифтов или демонстрационного UI. Все результаты и ограничения выше. Docs Widgetbook и visual workflow отражают фактические файлы и пределы каркаса.
- Stage IMPLEMENTING → VERIFYING → DONE. Новых зависимостей/CI jobs, билдов, коммитов и push нет.

## Ключевые решения

- Документы архитектуры и процесса отделены от исполняемых constraints rules; links/registry/router согласованы.
- Golden — отдельное UI scope-требование, не TestGate каждой визуальной правки. Agent update + показ результата, без автоматического принятия unrelated diffs.
- Test configuration живёт вне lib и автоматически подхватывается Flutter; отсутствие компонентов не маскируется fake baselines.

## Итог

Минимальная обвязка выполнена: presentation scopes, пустой Widgetbook через app-bootstrap, общий viewport и защищённый Linux-only test hook. 5 тестов, analyzer, 49 архитектурных cases и structural checks прошли. Правила и документация готовы к первым компонентам. Это не реализация продуктового UI, font loader или удалённого Linux CI; их отсутствие явно отражено, PNG не создавались.
