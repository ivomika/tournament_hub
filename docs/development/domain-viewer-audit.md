# Domain viewer: аудит и направление исправления

## Статус и основание

Исследование от 22 сентября 2026 года по исходникам `tools/domain-check`, текущей schema v6 и Domain-коду. Исправление запланировано в [задаче 24](../../ai-context/task-details/24-domain-viewer-semantics.md); описанный ниже целевой интерфейс ещё не реализован. Интерактивная визуальная проверка в рамках исследования не проводилась.

## Что работает сейчас

`domain-structure.mjs` строит 87 объектов, 33 folder-группы и 167 эвристических identifier co-occurrences. Проверка `--check` подтверждает соответствие JSON текущему алгоритму, но не семантическую правильность targets. Карта сохраняет точные имена declarations; поля, методы и enum values доступны в Details. Есть поиск, фильтры area/kind, масштабирование, перемещение и фокус прямых связей.

## Выявленные ограничения

1. `buildEdges` ищет совпадения имён известных типов в тексте declaration. 143 связи помечены `references`, 24 — `extends`. Упоминание в параметре, поле, вызове или создании объекта выглядит одинаково. Разрешения символов по imports и области видимости нет; совпадение identifier не доказывает зависимость на конкретный тип.
2. `extractDeclarations` использует регулярное выражение для class/enum. Extensions, mixins, typedefs и top-level functions не являются самостоятельными nodes. Members хранятся строками; enhanced enum не получает анализ полей и методов. Проверка drift проверяет повторяемость текущего алгоритма, а не полноту его понимания Dart.
3. `role` выводится из папки, `importance` — из role/kind и совпадения имени с area. Это соглашения о расположении и визуальном размере, а не доказательство владения данными или бизнес-значимости.
4. В просмотренных Domain-источниках поиск `///` не нашёл описаний. Fallback «класс: N полей, M методов» не объясняет назначение объекта. Например, такая подпись не помогает понять границу Profile и Participant.
5. `Tournament.removeParticipant` проверяет lifecycle, удаляет участника и его assignment, затем возвращает новый Tournament. Viewer показывает сигнатуру и общие type references, но не эту последовательность и её условия.
6. `ProfileManagementPort.delete` объявлен без тела. Поиск реализаций Port/Repository в текущем `lib` не выявил реализаций этих контрактов. Показывать каскадное удаление или деактивацию как существующее поведение нельзя. Проверенный scope и отсутствие найденной реализации должны быть видны пользователю.
7. UI строит общую карту по папкам, Details показывает линейные списки строк. Нет отдельного представления сценария, перехода от операции к вызываемому member и объяснения основания связи. Наличие всех узлов на одном canvas само по себе не даёт общей картины поведения.
8. SVG edges имеют `pointer-events: none` и скрыты от accessibility tree. Отдельного selection state для relation нет. Details целиком объявлен `aria-live`, а при узком окне располагается после viewport высотой около экрана.
9. Проверенный `apps/tournament_app/lib` содержит только `domain/` и `main.dart`; implementations Port/Repository не найдены. Поэтому viewer пока может показать Domain operation flow и отсутствие orchestration, но не полный start-to-end application flow.

Показательный риск описаний без проверки: реальный `RandomPort` объявляет `shuffled<T>(Iterable<T>)`; обсуждавшийся ранее `nextInt` не является его текущим контрактом.

## Целевой принцип данных

Факты формируются отдельным локальным Dart tool package с зафиксированной версией `package:analyzer`: declarations, структурированные members, разрешённые ссылки, relation occurrences, control-flow одного member, наследование и найденные implementations. Каждый факт хранит source evidence и границы применимости. Primary scope — `apps/tournament_app/lib/domain/**`; implementation lookup выполняется в существующем `apps/tournament_app/lib/**` и дополнительных явно настроенных roots. Schema сообщает фактически проверенные scopes и отсутствующие каталоги.

Analyzer dependency не является частью Dart SDK; на момент первоначального аудита она отсутствовала в проекте. В этапах 2–3 создан отдельный tool package с analyzer 8.4.1, resolved operation trace и inventory. Текущий контракт описан в [реестре из resolved AST](domain-viewer-inventory.md). Первая bootstrap-команда может требовать сеть; после bootstrap штатные generate/check/test работают локально. Полная capability matrix и semantic relation occurrences ещё не завершены.

Автоматический `operation trace` содержит только доказуемые code facts: condition, throw/return, assignment, constructor/resolved call и аргументы. Private helper можно раскрыть ограниченно с cycle guard. Интерпретация вроде «удаляет участника» и межоперационный business/application scenario не выводятся автоматически.

Канонический machine-readable контекст хранится в `docs/architecture/` и связывает назначения объектов и curated scenarios с generated symbol/member/step IDs. Его может готовить агент через локальный репозиторный навык. Описания не меняют generated-факты. Identity, API fingerprint и implementation/evidence fingerprint проверяются раздельно; устаревшие пояснения и битые ссылки диагностируются.

Штатная генерация и запуск обходятся без агента и сетевого API после bootstrap. Отсутствие описаний не блокирует технический inventory и отображается как пробел. Приёмочный semantic baseline покрывает все areas и public entities/models/ports/repositories; viewer показывает coverage. Сценарий без реализации отображается как контракт или документированный замысел с видимыми пробелами и перечнем проверенных scopes.

## Целевой UI

UI использует три явных режима верхнего уровня и сохраняет общий выбор, URL state и понятный возврат:

- **Обзор:** какие области и подтверждённые ответственности существуют; какие категории объектов, public operations, contracts и найденные implementations доступны. Обзор не рисует все relation occurrences одновременно. Полный canvas остаётся дополнительным техническим представлением.
- **Объект:** назначение, Dart kind и роль с указанием происхождения; структурированные поля, операции, наследование и связанные объекты. Выбор конкретного поля или метода объясняет его зависимости.
- **Сценарий:** generated operation trace либо curated business/application scenario. Шаг связан с реальным member/evidence; ветвления, неизвестные участки, dynamic dispatch и отсутствие implementation явно обозначены.

Фактические папки остаются доступной группировкой. Основной обзор не превращается в дерево файлов. Карточки остаются компактными, полный состав — в Details. Relation выбирается через доступный семантический список у member/object; линия может быть дополнительным target. Details связи показывает все occurrences и source evidence. Breadcrumb/back stack восстанавливает filters, zoom, scroll и selection.

Семантические списки являются доступной альтернативой graph. Viewer поддерживает keyboard navigation без canvas pan, явный `focus-visible`, компактный live-region, Details как tab/drawer на узком окне, browser zoom 200% и reduced motion. Incompatible schema, partial analysis, unresolved symbols, stale/missing descriptions и отсутствующий implementation scope имеют отдельные состояния.

Конкретная компоновка выбирается по прототипу на реальных данных. Предыдущие отклонённые решения (обязательный drill-down и объединение межкластерных рёбер) не возвращаются автоматически. Приёмка проверяет способность найти объект, объяснить связь и проследить операцию при читаемом масштабе.

## Последствия и границы

Потребуются изменение схемы, отдельный Dart analyzer package, UI и проверки описаний. Работа проходит через capability spike, вертикальный срез `removeParticipant`, UI-прототип и только затем расширение покрытия. Бизнес-модель приложения не рефакторится ради карты. Поддержка неизвестных конструкций и dynamic dispatch проявляется диагностикой, а не придуманными фактами.

## Независимая проверка

Три независимых read-only аудита проверили extractor/schema, UI/UX и task/skill workflow. Я повторно проверил их ключевые findings по исходникам, package config и schema. Подтверждены фактические числа, отсутствие analyzer и application implementations, ограничения relation UI и риск смешения Domain operation с application scenario. План задачи 24 исправлен по подтверждённым findings; предложение автоматически выводить бизнес-изменения состояния отклонено как недостоверное.
