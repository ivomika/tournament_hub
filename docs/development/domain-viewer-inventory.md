# Реестр Domain из resolved AST

## Решение и границы

Этап 3 задачи 24 заменяет regex extraction объектов и members на `package:analyzer 8.4.1` в отдельном Dart tool package. Flutter dependencies не изменяются. JS-генератор отвечает за запуск extractor, layout metadata, сериализацию и проверку актуальности. Viewer отображает generated-факты, agent не составляет реестр вручную.

Primary scope — все Dart-файлы `apps/tournament_app/lib/domain`, включая barrel `domain.dart`. Exports не дублируют declarations. Сейчас поддержаны class (modifiers сохраняются в signature) и enum, включая enhanced enum. Поля извлекаются из declarations, getters/setters, operators, constructors и методы — из AST и resolved elements. Наследованные members помещаются в отдельную секцию с declaring type; synthetic не выдаются за объявленные в объекте. Другие виды declarations/member имеют явную диагностику. Parse/resolve errors завершают генерацию ошибкой, устаревший JSON остаётся неизменённым.

Стрелки переведены на resolved relations. Проверка объявленных interfaces вне Domain охватывает существующие Dart-файлы в `apps/tournament_app/lib`, кроме Domain и generated `*.g.dart`; runtime DI и другие roots не проверяются. Полный runtime-сценарий не строится.

## Контракт schema 9

### Capability matrix

| Конструкция Dart | Покрытие | Ограничение |
| --- | --- | --- |
| `class`, `abstract/interface/sealed/final class` | Domain node + declared members | modifier сохраняется в signature; архитектурная роль выводится только из каталога |
| `enum`, enhanced enum | Domain node + values/declared members | inherited members — отдельная секция; synthetic не выдаются за declared |
| constructors/getters/setters/operators, поля, методы | member + exact evidence | объявление без тела помечено отдельно |
| aliases/imports, generics, nullable/collection types | resolved type metadata | внешние символы не становятся Domain nodes |
| `extends`, `implements`, mixin use | relation occurrence | relation не гарантирует runtime dispatch |
| `mixin`, `mixin class`, extension, extension type, typedef, top-level variable/function | diagnostic `UNSUPPORTED_DECLARATION` | не выдаются за class/node |
| `part`/`part of` | analyzer resolution | fixture проверяет identity owning library без дублирования |
| dynamic invocation | unresolved/dynamic relation status | цель не выдумывается |
| классы вне Domain в `apps/tournament_app/lib` | implementation scan | resolved supertypes, включая транзитивные; DI и другие roots не проверяются |

Эта матрица фиксирует текущее покрытие, а не обещание полного анализа Dart. Неподдержанный declaration виден в diagnostics. Неизвестный control flow не реконструируется.

- Node `id` строится из resolved library URI и qualified symbol. Подпись карточки использует точное имя declaration.
- `memberFacts` содержит kind, name, visibility, signature, ID и evidence. Member ID добавляет kind и name; getters/setters и именованные конструкторы не смешиваются. Безымянный constructor использует `new`.
- `type`/`returnType`/parameter type содержит display, nullability, symbol identity, вложенные type arguments и status `resolved`, `dynamic`, `unresolved`. Status означает результат статического разрешения типа, не определённую runtime-реализацию.
- `hasBody` означает наличие function body. Конструктор без блока тела не объявляется абстрактным контрактом: initializer/const constructor может быть реализацией.
- `evidence` содержит относительный source, line/column, offset/length и точный фрагмент исходника. Изменение исходных байтов требует regeneration.
- `roleSource: directory` явно отличает классификацию по расположению от подтверждённого бизнес-назначения. Без doc comment показывается «Назначение не описано» и техническая сводка.

ID сохраняется при изменении тела или форматирования; переименование symbol/library меняет identity. Node API fingerprint включает declaration signature и публичные member signatures. Member implementation fingerprint включает токены evidence без форматных пробелов; комментарии внутри evidence могут изменить fingerprint. Курируемый контекст в `docs/architecture/domain-viewer-context.json` сравнивается по fingerprint и ID: изменённый код даёт stale, битая ссылка — error, отсутствие описания — warning. `--check` падает для stale/error. `--stamp-context` используется только после смысловой проверки изменения.

## Отображение и проверка

Карточки сохраняют type, имя и краткое описание. В Details отдельные группы для полей, constructors, public/private operations и enum values. Каждый member раскрывает типы, параметры, объявление без тела и source evidence. URL hash адресует режим, объект, member, связь, фильтры и масштаб; back возвращает предыдущий режим/объект. Текстовое представление связей доступно без canvas.

В технической карте Details ограничен высотой карты и прокручивается независимо. На узком экране доступны переключаемые панели «Карта»/«Детали»; в режиме «Объект» Details занимает всю ширину. Размеры карточек, zoom, fit, pan и существующая группировка сохраняются. Viewer отвергает другую schema version и предлагает regeneration.

`tools/domain-check/domain-architecture.schema.json` фиксирует обязательную структуру schema 9, `validate.mjs` проверяет форму и целостность ID/relation evidence. `context-drift.test.mjs` проверяет stale API, orphan member и отсутствующий файл, а `determinism.test.mjs` — байтовую идентичность двух сборок. Эти проверки не доказывают runtime-поведение.

## Связи и обзор областей

`relationOccurrences` хранит source declaration/member, kind, статическую target identity и member, resolution status и точный source span/expression. Поддержаны явные extends/implements/mixin types, типы fields/parameters/returns (включая generic arguments), явные MethodInvocation, InstanceCreation и super/redirecting constructor calls. Generic-аргумент в иерархии имеет kind `type-use`: `extends Base<Item>` не создаёт наследование от Item. `resolved-single` означает одно статически разрешённое объявление; runtime dispatch может выбрать другую реализацию. `dynamic`/`unresolved` не получают выдуманный target. FunctionExpressionInvocation, property read/write, implicit calls, локальные type-use expressions и полный control flow не включены в набор связей этого этапа. Generic type parameter не выдаётся за зависимость на объявивший его объект.

`relations` объединяет occurrences по source/target/kind, сохраняя все основания и source members. `edges` агрегирует Domain-связи только для рисования одной линии между объектами. Внешние SDK/package symbols и неизвестные targets скрыты из основного graph, но доступны отдельной секцией Details. Собственные вызовы объекта остаются в Details, self-arrows не рисуются. Occurrence ID зависит от span и не гарантирует стабильность после редактирования; node/member identities сохраняют описанный выше контракт.

Выбор связи через доступный список задаёт selectedRelationId и открывает панель с occurrences, исходными members, типами/параметрами, статическими целями и evidence. Линия на canvas выделяется; непосредственный клик по линии не обязателен. Ссылка на source member раскрывает соответствующий элемент. `implements` означает объявленное отношение к интерфейсу и не доказывает наличие инфраструктурной реализации или конкретный путь application-сценария.

Стартовый обзор показывает все области, число объектов по категориям, public operations/accessors и курируемые описания ответственности. Области определены расположением; описания находятся в отдельном каноническом документе. Межобластные направления раскрываются в список связей с evidence. Режим «Объект» показывает состав и связи, «Сценарий» — отдельно курируемое объяснение и статическую трассу, а canvas остаётся отдельным техническим представлением. Counts формируются из generated-фактов и текущих фильтров.

`make domain-check-analyzer-bootstrap` устанавливает зависимости; `make domain-check-generate` и `make domain-check-validate` запускают extractor автоматически. Fixtures проверяют aliased duplicate names, nullable/generic/dynamic types, named constructors, getters/setters, enhanced enums, declaration diagnostics и evidence. Browser QA проверяет загрузку реестра, permalink reload и доступность трассы операции на двух размерах экрана. Инструкции запуска находятся в [руководстве инструмента](../../tools/domain-check/README.md).
