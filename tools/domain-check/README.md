# Domain architecture checker

Статический локальный viewer Domain-архитектуры TournamentHUB.

Контракт extractor и schema: [реестр из resolved AST](../../docs/development/domain-viewer-inventory.md).

## Запуск

Из корня репозитория:

```sh
make domain-check
```

Затем открой адрес, напечатанный сервером, обычно `http://localhost:8090`.

На Windows Makefile запускает `py -3`; на macOS/Linux — `python3`. Если
Python расположен нестандартно, передай команду интерпретатора через
`PYTHON`, например `make domain-check PYTHON=python`.

## Состав

### Техническая трасса операции

Выбери `Tournament`: после состава в Details отображается `removeParticipant`, извлечённый через resolved AST `package:analyzer 8.4.1`. Условия, вызовы, именованные аргументы, return и throw имеют точное code evidence и номер строки. `_requireLifecycle` и `_copy` раскрываются отдельно на один уровень. Список отражает обход AST; вычисление аргументов и callbacks не выдаётся за последовательный runtime-сценарий. Targets означают статически разрешённые объявления, а не доказанную runtime-реализацию.

Подготовка: `make domain-check-analyzer-bootstrap` (первый запуск скачивает зависимости). Обновление: `make domain-check-operation-generate`. Проверка: `make domain-check-operation-validate` и `node tools/domain-check/operation-trace.test.mjs`. Analyzer имеет отдельные pubspec/lock и не входит в зависимости Flutter. Generated `operation-trace.json` не редактируется вручную; несовместимая версия или отсутствие файла отображаются в Details. Сейчас трасса покрывает только один метод и два helpers, не весь Domain.

Перед картой показан generated-отчёт «Границы и достоверность карты»: Domain root, число Dart-файлов и извлечённых объектов, версия analyzer/Dart, coverage описаний и наличие каталогов application/infrastructure. Barrel `domain.dart` тоже анализируется; exports не создают повторных объектов. Отдельно перечислены реально проверенные внешние Dart-файлы в `apps/tournament_app/lib` и найденные объявления `implements` для Domain-контрактов; отсутствие runtime-реализаций за пределами этого scope не утверждается.

Реестр schema 9 извлекается из resolved AST: class/enum, declared fields, constructors, methods, getters/setters/operators и enhanced enum values. Типы хранят generics, nullability и status `resolved`, `dynamic`, `unresolved`. Parse/resolve errors прерывают генерацию; неизвестные declarations дают диагностику. Inherited members показаны отдельно с declaring type и отметкой переопределения; synthetic не выдаются за declared. Роль определяется расположением и не считается доказательством ответственности.

Стартовый экран — обзор областей с числом объектов, категорий и публичных операций. Межобластные связи представлены направлениями с количеством связей/оснований; их можно раскрыть и выбрать конкретную связь. Режимы «Объект» и «Сценарий» отделяют смысловой сценарий от AST-трассы; «Техническая карта» открывает canvas.

Связи теперь извлечены analyzer: `field-type`, `parameter-type`, `return-type`, `extends`, `implements`, `mixin`, `call`, `create`, `constructor-call`, `type-use` для generic-аргумента в иерархии. В Details выбери связь: панель покажет все occurrences, исходный member, статическую цель и точное code evidence. SDK/внешние/неизвестные цели доступны отдельно. В graph Domain-рёбра агрегированы только по паре объектов; типы и основания сохраняются. Это не доказывает runtime dispatch, владение или каскадное удаление. Проверка generated-оснований: `node tools/domain-check/relations.test.mjs`.

Node ID = resolved library URI + qualified symbol. Member ID добавляет kind и name (отдельные getter/setter и named constructors). На member есть permalink в URL hash; после загрузки открываются владелец и выбранный member. Перемещение/переименование library или symbol меняет ID. API fingerprint объекта включает публичные signatures; implementation fingerprint member — токены объявления без форматных пробелов. Точное source evidence раскрывается в Details; карточки содержат только тип, имя, описание. В технической карте Details имеет свой вертикальный скролл.

Проверки extractor fixtures: `cd tools/domain-check/analyzer` и `dart run test/inventory_test.dart`. Полный локальный набор — `make domain-check-test`: проверка generated files, JSON schema/structure, source spans, context drift, Dart analyzer fixtures и две байтово одинаковые генерации. Browser QA: установи Playwright отдельно, задай `VIEWER_PLAYWRIGHT_PATH` при нестандартном расположении, запусти локальный сервер на 8091 и `node tools/domain-check/viewer.test.mjs`. Используется headless Edge; screenshots сохраняются в OS temp. Playwright не является зависимостью viewer или Flutter.

- `domain-architecture.json` — generated-карта реальных Dart declarations и ссылок между ними.
- `analyzer/lib/inventory.dart` — реестр, `relations.dart` — сбор связей, `symbols.dart` — идентичность и типы; `domain-structure.mjs` запускает extractor, агрегирует данные и проверяет актуальность JSON.
- `index.html`, `styles.css`, `app.js`, `relations-ui.js` — интерфейс просмотра без внешних runtime dependencies.

После изменения Domain declarations выполни `make domain-check-all-generate`, затем `make domain-check-test`. Проверка без перезаписи: `make domain-check-all-validate`. Generated JSON вручную не редактируется: источником фактов остаётся Dart-код. Описания находятся в [docs/architecture/domain-viewer-context.json](../../docs/architecture/domain-viewer-context.json), локальный навык — [.codex/skills/domain-viewer/SKILL.md](../../.codex/skills/domain-viewer/SKILL.md). Fingerprints обновляются `node tools/domain-check/domain-structure.mjs --stamp-context` только после проверки смысла изменений.

Карточки собраны в подписанные кластеры Domain areas, а внутри area — в generated-контейнеры фактических каталогов (`entities`, `failures`, `ports` и других). Folder membership формирует скрипт из расположения Dart declaration; viewer не содержит ручной классификации. Фильтры скрывают пустые folders и пересчитывают оба уровня счётчиков. Стрелка направлена от использующего объекта к его зависимости. Выбор карточки показывает входящие и исходящие прямые связи; «Фокус связей» приглушает остальную карту, не скрывая её.

Каждый node соответствует одному declaration и использует его точное имя. Карта не показывает дерево папок или file paths и не объединяет типы в придуманные группы. Обзорная карточка содержит только kind, имя и описание. Поля, методы, конструкторы и enum values показываются исключительно в detail panel, но остаются доступны поиску. Описание берётся из `///`, а без doc comment остаётся нейтральным фактом о kind и количестве членов.

Размер карточки генерируется из структурной роли: корневые entities `Tournament`, `Profile`, `Game` имеют `prominent` высотой `176px`, value objects/failures/enums — `compact` высотой `118px`, остальные declarations — `standard` высотой `142px`. Viewer не хранит ручной список размеров.

Масштаб карты регулируется кнопками `−`/`+`, range control и командами `100%`/`Вписать`. Масштабируется весь graph canvas, а ручное значение сохраняется локально в браузере. Минимальная высота graph viewport равна высоте окна за вычетом собственного header карты; ширина viewer и постоянная колонка Details сохраняют исходную компоновку.

Горячие клавиши: `+`/`−` меняют масштаб, `0` возвращает `100%`, `F` переключает фокус связей. Shortcuts не срабатывают во время ввода в controls и не перехватывают системные сочетания с modifiers.
