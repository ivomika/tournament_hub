# Задача 24. Структура, взаимодействия и сценарии в Domain viewer

## Статус

🚧 В работе. Этапы 1–4 реализованы ранее; по запросу от 28.09 этапы 5–7 выполнены подряд без промежуточных остановок. Технические проверки пройдены, пользовательская приёмка и оставшиеся пункты расширенных Gate C/D не отмечены как выполненные.

## Цель

Пользователь понимает, какие объекты существуют в Domain, что они содержат, почему связаны и как выполняются найденные операции. Viewer отдельно показывает Domain operation flow, описанный application-сценарий и границу кода, доступного анализу. Данные воспроизводимо извлекаются скриптом; агент помогает создавать проверяемые описания и контекст.

## Контекст и границы

- Основание: [аудит и целевой подход](../../docs/development/domain-viewer-audit.md).
- Отдельная цель относительно задач 14 и 17: семантика методов и объяснение сценариев, включая контролируемые описания и локальный навык; не очередная правка расположения карточек.
- Входит: extractor, схема, валидатор, viewer, документация и `.codex/skills/domain-viewer/SKILL.md`.
- Рефакторинг бизнес-модели, реализация отсутствующих application-сервисов и изменение правил турниров не входят.
- Primary scope: `apps/tournament_app/lib/domain/**`. Implementation lookup scope: существующие файлы `apps/tournament_app/lib/**` без generated/build-каталогов. Дополнительные roots подключаются явной конфигурацией; отсутствующий каталог не создаётся ради viewer.
- Schema хранит фактически проверенные roots, exclusions, package, версии Dart/analyzer/generator и diagnostics. Формулировка «реализация не найдена» всегда называет проверенный scope; отсутствие application/infrastructure scope показывается отдельно.
- Declaration из implementation lookup scope не становится Domain node: оно доступно как внешний evidence/facet контракта и скрыто из основного Domain layout по умолчанию.
- Карточка сохраняет тип, точное имя и описание; поля и методы находятся в Details. Сохраняются zoom, fit, pan, hotkeys, раздельные порты стрелок и выключенный по умолчанию фокус связей.
- Не возвращать ранее отклонённые drill-down, объединение рёбер и перегруженную цветовую типизацию как обязательный интерфейс. Семантику показывать понятными подписями, фильтрами и деталями связи.
- Файлы и строки допустимы как техническое происхождение данных, но не обязательные подписи карты и не дерево файлов вместо модели.

## Применимые правила

- [x] [R-001 · SOLID](../rules/core/001-solid.md): отдельно извлечение фактов, описательный контекст, проверки и отображение; не создавать интерфейс для каждой функции инструмента.
- [x] [R-002 · Документирование на русском](../rules/core/002-documentation-russian.md): аудит и целевой контракт находятся в docs; карточка хранит план и ход работы.
- Conditional scan: router не содержит conditional rules. При реализации перечитать актуальный router. При создании навыка применить доступный skill-creator.

## Декомпозиция

Работа выполняется малыми этапами. Изначально после каждого этапа предусматривалась пользовательская остановка; прямой запрос от 28.09 «продолжи этапы без остановок» отменил промежуточные паузы для этапов 5–7. Проверяемый результат во viewer по-прежнему обязателен, финальная пользовательская приёмка фиксируется отдельно.

### Этап 1. Зафиксировать фактическую базу

Результат реализации: перед картой отображается generated-отчёт. Генерация и проверка актуальности пройдены; визуальная проверка в браузере и пользовательская приёмка пока не выполнены.

- Сформировать воспроизводимый отчёт о текущем scope, количестве declarations и диагностике.
- Показать во viewer границы анализа, источник данных и предупреждение о текущих эвристических связях.
- **Контрольная точка:** пользователь открывает viewer и видит, что именно проанализировано и чего в проекте пока нет.
- Остановиться для приёмки отчёта и границ.

### Этап 2. Технический вертикальный срез одной операции

Результат: в Details объекта Tournament доступна resolved AST-трасса removeParticipant и два раскрываемых helper. Проверки инструмента и evidence пройдены; пользовательская приёмка ожидается.

- На одном реальном методе `Tournament.removeParticipant` заменить эвристическую связь на проверяемые AST-факты.
- В Details показать условие, throw/return, вызовы, изменения состояния и source evidence.
- Не добавлять бизнес-интерпретации автоматически.
- **Контрольная точка:** пользователь открывает метод во viewer и пошагово видит его фактическую структуру.
- Остановиться для приёмки достоверности и понятности.

### Этап 3. Реестр объектов и содержимое

Результат: schema 7, 87 resolved AST-объектов и declared members, структурированные типы и source evidence в Details, member permalinks. Fixtures и браузерные проверки пройдены; дальнейшее расширение связей остановлено до приёмки.

- Перенести на AST/semantic analysis declarations и members Domain: классы, интерфейсы, enum, поля, конструкторы и методы.
- В карточке оставить type, имя и краткое описание; состав и операции показывать в Details.
- Добавить стабильные ссылки на конкретные members и состояния `resolved/unresolved/dynamic`.
- **Контрольная точка:** пользователь выбирает любой объект и понимает, что находится внутри него и откуда взят каждый факт.
- Остановиться для приёмки инвентаря.

### Этап 4. Связи и обзор областей

Результат: schema 8, resolved relation occurrences, типизированные связи, выбор связи с evidence, обзор областей и межобластных направлений. Проверки analyzer/fixtures/generated spans/browser пройдены. Следующий этап остановлен до приёмки.

- Разделить типы связей: наследование, тип поля, параметр/результат, создание, вызов метода и реализация контракта.
- Ввести обзор областей и агрегированные связи; полный граф оставить отдельным техническим режимом.
- Добавить выбор связи, список occurrences и переход к source evidence.
- **Контрольная точка:** пользователь понимает группы объектов и может проверить любую связь, не читая сырой JSON.
- Остановиться для приёмки навигации и читаемости.

### Этап 5. Описания и сценарий

- Добавить канонический описательный контекст в `docs/architecture/`.
- Связать описания с generated IDs и fingerprints; stale/missing descriptions показывать явно.
- Отдельно показывать generated operation trace и curated business/application scenario.
- **Контрольная точка:** пользователь видит рядом технический факт и подтверждённое смысловое объяснение, не смешивая их.
- Остановиться для приёмки смыслового слоя.

### Этап 6. Навигация и доступность

- Реализовать режимы `Обзор`, `Объект`, `Сценарий`, URL/hash-навигацию, back/breadcrumb и восстановление контекста.
- Добавить keyboard navigation, текстовую альтернативу связям, focus-visible и состояния пустых/частичных данных.
- **Контрольная точка:** пользователь проходит путь от области до шага сценария и обратно на обычном экране и при zoom 200%.
- Остановиться для пользовательской приёмки UI.

### Этап 7. Автоматизация сопровождения

- Вынести analyzer в отдельный Dart tool package с явным bootstrap.
- Добавить validator, deterministic generation, fixture-тесты и локальный skill для обновления фактов и описаний.
- После bootstrap генерация и проверки выполняются локально без агента и сети; агент нужен только для смысловых изменений и архитектурных решений.
- **Контрольная точка:** изменение Domain-файла автоматически обновляет факты, а устаревшее описание обнаруживается проверкой.
- Остановиться для финальной приёмки и только затем закрывать задачу.

### Gate A. Capability spike анализатора и границы

- [x] Проверить текущий генератор, схему, UI и несколько реальных Domain-операций; записать ограничения.
- [ ] Создать отдельный Dart tool package в `tools/domain-check/analyzer/` с собственными `pubspec.yaml`, lock-файлом и зафиксированной совместимой версией `package:analyzer`; не добавлять analyzer в Flutter app dependencies.
- [ ] Добавить явную bootstrap-команду зависимостей. После bootstrap generate/check/test работают локально без агента и сетевого API; первая установка зависимостей может требовать сеть.
- [ ] На versioned fixtures и реальном `Tournament.removeParticipant` проверить symbol resolution, source spans, control-flow AST и поиск implementations. Результаты capability spike документировать до утверждения schema.
- [ ] Зафиксировать capability matrix для class modifiers, class, enum/enhanced enum, mixin/mixin class, extension, extension type, typedef, top-level function/variable: `node`, `member/evidence`, `diagnostic` либо `out of scope` с причиной.
- [ ] Остановиться после Gate A для технической приёмки выбранного toolchain и границ поддержки.

### Gate B. Schema, extractor и вертикальный срез

- [ ] После spike описать schema vNext: `scan`, `coverage`, `diagnostics`, declaration, member, relation occurrence, evidence, generated operation trace и curated scenario.
- [ ] Стабильные IDs строить на resolved library URI и qualified symbol. Member ID учитывает kind и identity constructor/getter/setter/operator/method/field; `part/part of` не создаёт двойную identity.
- [ ] Разделить symbol identity, normalized API fingerprint и normalized implementation/evidence fingerprint. Форматирование не создаёт drift; rename создаёт новый ID и orphan diagnostic.
- [ ] Разделить Dart kind и архитектурную роль. Роль из каталога явно помечать как классификацию по расположению, не как доказательство ответственности.
- [ ] Перейти от regex-поиска имён к разрешённому AST/semantic analysis. Извлекать поддерживаемые declarations, modifiers, поля, nullability/collections, параметры, return types, constructors, getters/setters/operators, enum members, inheritance и declaring type inherited members.
- [ ] Различать поле типа, параметр, возвращаемый тип, создание объекта, вызов метода, extends/implements/mixin. Каждая связь указывает исходный member и основание; хранение ID не означает владение или каскадное удаление.
- [ ] Relation occurrence хранит source declaration/member, resolved target, relation kind, source span/expression, resolution status (`resolved-single`, `resolved-candidates`, `unresolved`, `dynamic`) и type metadata. Object edge может агрегировать occurrences только визуально, не теряя основания.
- [ ] Внешние SDK/package symbols сохранять в signatures/evidence, но скрывать из основного graph по умолчанию. `ArgumentError`, `StateError` и другие throws входят в operation trace.
- [ ] Автоматический operation trace ограничить control-flow одного member: conditions, throw/return, assignments, constructor calls, resolved calls и аргументы. Private Domain helper раскрывается по запросу не глубже одного уровня с cycle guard. Mutation, создание/возврат нового объекта и бизнес-интерпретация не смешиваются.
- [ ] Сделать вертикальный срез `Tournament.removeParticipant → schema/validator → UI`: показать `_requireLifecycle`, фильтрацию, условный throw, `assignments.remove` и `_copy`; изменение revision показывать evidence раскрытого `_copy`, а не выводом анализатора о бизнес-состоянии.
- [ ] Добавить JSON schema/validator, отказ UI на несовместимой версии, deterministic ordering и two-run byte-identical check. Parse/resolve error или потеря declaration primary scope делает check неуспешным.
- [ ] Остановиться после Gate B для проверки достоверности и читаемости вертикального среза.

### Gate C. Описательный контекст и UI-прототип

- [ ] Хранить канонический machine-readable контекст в `docs/architecture/`, рядом с архитектурными фактами: назначения, curated scenarios и ссылки на generated IDs/evidence. Generated-файл viewer не становится вторым источником бизнес-правил.
- [ ] Разделить generated `operation trace` и curated `business/application scenario`. Scenario ссылается на generated members/step evidence, хранит provenance/status шага и не превращает static trace в гарантированный runtime flow.
- [ ] Разделить реализованное поведение, документированный замысел и неподтверждённую интерпретацию. Не дорисовывать реализацию interface-метода.
- [ ] Назначение объекта зависит от identity/API fingerprint, описание поведения — от implementation/evidence fingerprint. Битая ссылка на symbol/step является validation error; изменённый fingerprint — stale diagnostic; отсутствующий descriptions-файл — warning/empty state.
- [ ] Базовый технический inventory работает без описаний, показывая «Назначение не описано». Готовность требует semantic baseline для всех areas, public entities/models/ports/repositories и контрольных flows; UI показывает coverage и список пробелов.
- [ ] Переработать информационную архитектуру в три явных режима `Обзор`, `Объект`, `Сценарий`. Полный canvas со всеми object edges остаётся отдельным техническим представлением, а не стартовым объяснением архитектуры.
- [ ] В `Обзоре` показать areas, подтверждённые описания ответственности, категории объектов, public operations и contracts/найденные implementations. Public member считается business entry point только при curated-признаке с источником.
- [ ] Сделать прототип на полном актуальном generated dataset (на момент аудита 87 declarations) и versioned fixture; проверить общую картину и `removeParticipant` до массовой реализации UI.
- [ ] Ввести navigation contract и URL hash: `Обзор → объект → member/relation → scenario step`, back/breadcrumb восстанавливает filters, zoom, scroll и selection; фильтрация выбранного элемента имеет явно определённое поведение.
- [ ] Переработать Details и использование пространства: читаемые длинные имена, регулируемая/раскрываемая панель состава, различимые уровни area/folder/object, пустые состояния и доступные клавиатурные действия. Высота карты и zoom сохраняют согласованность.
- [ ] Дать поиск/фильтры по имени, роли, Dart kind и операции; сохранить реальные объекты и существующую группировку.
- [ ] В Details структурировать declared state, constructors, public operations, internal helpers и enum values. Inherited members находятся в отдельной секции с declaring type/override flags. Library/helper calls свёрнуты и раскрываются по запросу.
- [ ] Ввести `selectedRelationId`. Основной доступный способ выбора — семантический список у member/object; кликабельная линия дополнительна. Панель показывает source/member, kind, target, все occurrences, evidence и resolution status.
- [ ] В Scenario показать operation trace либо curated scenario с переходом к объектам/members. Контракты без implementation и неизвестные участки видны в потоке вместе с проверенными scopes.
- [ ] Визуально различать факт из кода, описание и устаревшее/неизвестное; не заставлять пользователя разбирать сырой JSON.
- [ ] Обработать состояния incompatible schema, partial analysis, unresolved symbols, stale/missing descriptions, empty filters, отсутствующий implementation scope и load error на всём viewer.
- [ ] Обеспечить доступный семантический список как альтернативу graph, keyboard navigation без canvas pan, `:focus-visible`, компактный live-region, предсказуемый фокус после выбора, Details как tab/drawer на узком окне, 200% zoom и `prefers-reduced-motion`.
- [ ] Остановиться после Gate C для пользовательской приёмки UI-прототипа.

### Gate D. Расширение покрытия, навык и документация

- [ ] Создать `.codex/skills/domain-viewer/SKILL.md`: когда запускать, что читать, как генерировать/проверять данные, как добавлять и актуализировать описания и сценарии.
- [ ] Запретить навыку ручное изменение generated-фактов, создание выдуманных объектов/связей и подмену отсутствующей реализации рассказом о будущем поведении.
- [ ] Навык собирает контекст из кода и docs, редактирует только канонический контекст в `docs/architecture/`, указывает основания и неопределённости; generator/validator проверяет ссылки и актуальность.
- [ ] Добавить инструкции для задач изменения Domain: обновление фактов автоматическое, описания пересматриваются только при выявленном drift или изменении сценария. Описать обнаружение навыка и ручной запуск.

- [ ] Fixture-тесты extractor по утверждённой capability matrix: imports/aliases, одинаковые имена, локальное имя как имя типа, generics, nullable/collections, constructors, enhanced enum, `part`, supported/unsupported declarations, resolution/parse errors и dynamic dispatch.
- [ ] Проверить повторяемость генерации и диагностику недостоверных/устаревших данных, включая удалённый member и отсутствующий описательный файл.
- [ ] Проверить performance: initial render не строит все occurrence edges; overview использует aggregates, локальное окружение строится по выбору, полный актуальный dataset не зависает.
- [ ] Проверить UI на реальных сценариях ниже, регрессии навигации и чтение длинных сигнатур. Обновить руководство и Make-команды; Flutter-билды не запускать.

## Критерии готовности

- [ ] Capability matrix утверждена; все declarations primary scope либо представлены по её правилам, либо имеют явную диагностику. Scan metadata перечисляет реально проверенные roots и версии toolchain.
- [ ] Пользователь различает класс, entity/model, repository/port и контракт/реализацию, понимая основание такой классификации.
- [ ] `CharacterAssignment.participantId` виден как ссылка по ID; viewer не заявляет прямую связь с Profile или автоматическое удаление Profile.
- [ ] Для `Tournament.removeParticipant` generated operation trace показывает AST-факты: вызов lifecycle guard, фильтрацию, condition/throw, `assignments.remove`, `_copy` и evidence изменения revision при раскрытии helper. Бизнес-подписи поступают из curated-контекста.
- [ ] Для `ProfileManagementPort.delete` видно объявление контракта, отсутствие тела и результат поиска implementation с точным перечнем scopes; каскад, soft delete и anonymization не выдумываются.
- [ ] Для `RandomPort` показан фактический метод `shuffled<T>`, а не предполагаемый `nextInt`.
- [ ] Наследование, type usage, хранение поля, создание объекта и вызов метода различимы; все occurrences доступны с source evidence, а dynamic dispatch не привязан к одной реализации без основания.
- [ ] После явного bootstrap генерация и запуск не требуют агента, сети или платного API. Агент нужен только для описаний и curated-сценариев.
- [ ] API/implementation fingerprints независимо помечают связанный контекст устаревшим; удалённый symbol/step вызывает понятную validation error.
- [ ] Локальный навык создан и проверен на добавлении одного описания и его актуализации после изменения fixture.
- [ ] Выполнена визуальная проверка карты, Details и сценария; недоступность браузера фиксируется как невыполненная проверка, а не заменяется HTTP smoke.
- [ ] На окнах 1366×768 и 1920×1080 можно найти Profile/Participant, открыть состав, объяснить выбранную связь и пройти `removeParticipant` без чтения исходников и без уменьшения всей карты до нечитаемых подписей.
- [ ] По обзору различимы области ответственности и доступные операции, а не только папки. Выбранные объект/сценарий и путь возврата очевидны; пользовательская приёмка UI зафиксирована отдельно от проверки генератора.
- [ ] На стартовом экране явно видны границы анализа, description coverage, unresolved/partial diagnostics и отсутствие найденного application layer; это не выдаётся за полную логику приложения.
- [ ] Полный пользовательский маршрут проходит с клавиатуры и при browser zoom 200%; relation имеет текстовую альтернативу, а Details остаётся достижимым на узком окне.

## Открытые вопросы и ограничения

- Версию analyzer и точные APIs выбрать в Gate A после capability spike на установленном Dart 3.13.1; сейчас `analyzer` отсутствует в package config и зависимости не устанавливались.
- Полное runtime-поведение из статического анализа не гарантируется. Dynamic dispatch и неизвестные реализации отображаются как ограничения.
- Сложные бизнес-инварианты требуют описательного контекста с источниками; автоматическое доказательство произвольной бизнес-логики не является целью.
- В репозитории сейчас нет application-layer declarations или implementations Port/Repository в `apps/tournament_app/lib`; viewer показывает этот факт и не обещает start-to-end application flow до появления соответствующего кода.

## Changelog

### Итерация 1 — исследование и планирование

**Prompt пользователя**

> Исследуй инструмент для просмотра domain сущьностей. И заведи задачу на его исправление. Этот инструмент должен однозначно и просто доносить до пользователя какие сущьност, модели, классы, репозитории и тд есть в domain слое, как они взаимодействуют, что находится внутри этих элементов. С помощью этого инструмента я как пользователь должен увидеть не только структуру папок, но и как работает бизнес логика и логика приложения. Для формирования данных в этот инструмент хотелось бы обойтись минимальным вмешательством агентов, но оно допустимо, например для описательной работы или сбора контекста. Но тогда нужно будет в задаче указать дополнительное создание локал репо скилла для формирования и работы с этим инструментом

**Изменения**

- Исследованы extractor, generated schema, viewer и Domain-контракты; создан аудит и декомпозиция исправления.
- Создание локального навыка включено обязательным этапом будущей реализации.

**Проверки**

- `node tools/domain-check/domain-structure.mjs --check`: 87 объектов, 167 связей; текущая схема актуальна.
- Исследование исходников, без запуска UI: 143 references, 24 extends; семантических связей методов и сценариев нет.

### Итерация 2 — явная переработка UI

**Prompt пользователя**

> так же задача должна включать ui изменения инструмента, так как сейчас я не могу понять всю кортину по той схеме которая есть

**Изменения**

- Расширен этап UI: информационная архитектура, прототип на реальных данных, обзор Domain, состав объекта и сценарий с сохранением контекста навигации.
- Добавлены критерии читаемости на двух размерах окна и отдельная пользовательская приёмка. Изменение JSON без изменения UI не считается выполнением задачи.

**Проверки**

- Проверено наличие этапов прототипирования, UI-реализации и визуальной приёмки; выполнение этих этапов остаётся запланированным.

### Итерация 3 — независимая проверка аудита и задачи

**Prompt пользователя**

> запусти несколько независимых суб агентов для проверки аудита по инструменту просмотра архитектуры и 24 задачи. Пусть найдут недочеты, ошибки логики, и ложные или неправильные решения. После сам проверь все их findings и дополни или исправь задачу

**Изменения**

- Три независимых аудита проверили extractor/schema, UI/UX и качество task/skill workflow; их findings перепроверены по исходникам и toolchain.
- Scope анализа зафиксирован; Domain operation trace отделён от curated application scenario. План автоматического вывода бизнес-смысла заменён на ограниченные AST-факты с evidence.
- Analyzer вынесен в отдельный Dart tool package с bootstrap; schema дополнена scan/coverage/diagnostics, occurrence-relations, stable IDs и раздельными fingerprints.
- UI уточнён до режимов `Обзор`/`Объект`/`Сценарий`, доступной relation-навигации, сохранения контекста, diagnostic states и accessibility criteria.
- Работа разделена на четыре gates с обязательной остановкой после analyzer spike, вертикального среза и UI-прототипа.

**Проверки**

- Подтверждены schema v6: 87 nodes, 33 folders, 167 эвристических identifier co-occurrences (`143 references`, `24 extends`).
- Подтверждены отсутствие `package:analyzer`, Domain doc comments, application-layer каталогов и implementations Port/Repository в текущем `apps/tournament_app/lib`.
- Подтверждены UI-проблемы: SVG edges не интерактивны/скрыты от accessibility tree, Details целиком является live-region, selection сбрасывается фильтром без navigation history.
- Подтверждены примеры `Tournament.removeParticipant`, `ProfileManagementPort.delete` и `RandomPort.shuffled<T>`.

## Ключевые решения

- Факты извлекает инструмент, описания имеют независимое происхождение и проверяемые привязки.
- Отсутствующая реализация — полезный результат анализа, а не пробел, который следует заполнять догадками.
- Generated operation trace ограничен доказуемыми AST/code facts; бизнес-смысл и межоперационный сценарий являются curated-контекстом с provenance.
- Канонический описательный контекст живёт в `docs/architecture/`; generated tool data не становится вторым источником проектных фактов.
- Full graph является техническим представлением; стартовый UI объясняет области и операции без одновременного отображения всех edges.
- Реализация проходит пользовательские этапы с остановкой после каждого результата. Gate A–D задают технические требования; bootstrap analyzer нужен уже для этапа 2. Полная capability matrix ещё не утверждена.

## Итог

Этапы 1–3 приняты. Этап 4 реализован: resolved связи, обзор областей и основания доступны во viewer. Пользовательская приёмка ожидается; этапы 5–7 и локальный навык не реализованы.

### Итерация 4 — декомпозиция на проверяемые этапы

**Prompt пользователя**

> отлично, давай разабьем 24 задачу внутри на мелкие более проверяемые как ты предлогал. Если есть результат который можно пощупать во вьювере мы останавливаем и показываем его

**Изменения**

- Добавлены семь последовательных этапов: фактическая база, вертикальный срез операции, реестр объектов, связи и обзор, описания и сценарий, навигация/доступность, автоматизация сопровождения.
- Для каждого этапа зафиксированы отдельный пользовательский результат, обязательная контрольная точка и остановка до приёмки.
- Существующие Gate A–D сохранены как технические контрольные ворота внутри общего плана; они больше не заменяют пользовательские остановки.

**Проверки**

- Проверено, что каждый этап содержит наблюдаемый результат либо явно обозначенную техническую границу.
- Проверено, что порядок не смешивает AST-факты, curated-описания и UI-приёмку.
- Реализация кода и запуск Flutter/build не выполнялись.

### Итерация 5 — фактическая база во viewer

**Prompt пользователя**

> начни выполнять задачк 24

**Изменения**

- Этап 1: генератор сохраняет scope, исключения, количество файлов/объектов, coverage doc comments, наличие каталогов application/infrastructure и явные ограничения regex extraction.
- Viewer отображает отчёт перед картой; связи обозначены эвристическими. Поиск implementations явно помечен невыполненным, отсутствие каталога не подменяется утверждением об отсутствии логики.
- Руководство `tools/domain-check/README.md` обновлено согласно R-002. R-001: сбор метаданных находится в генераторе, отображение — в viewer. Conditional rules отсутствуют в router.

**Проверки**

- Генерация и `--check`: 87 объектов, 167 эвристических связей.
- `node --check tools/domain-check/app.js` и `git diff --check` пройдены.
- Визуальная проверка браузером не выполнена: доступный browser tool отсутствует. Пользовательская приёмка ожидается; этап 2 не начат.
- Flutter-билды и коммиты не выполнялись.

### Итерация 6 — resolved AST одной операции

**Prompt пользователя**

> продолжи выполнение

**Изменения**

- Этап 1 принят; реализован этап 2: отдельный Dart tool package с analyzer 8.4.1, закреплённой версией и lock. Bootstrap перенесён из этапа 7 как техническая предпосылка этапа 2.
- Generated operation-trace содержит реальные AST condition/call/throw/return/local/argument facts, точные spans и статические targets. Viewer показывает trace и раскрываемые helpers у Tournament.
- Обход AST явно отделён от runtime-порядка и бизнес-интерпретации. Общая карта остаётся эвристической; полный schema vNext, поиск implementations и capability matrix ещё не реализованы.
- R-001: extractor отделён от UI, новая зависимость отсутствует во Flutter. R-002: обновлено руководство инструмента; conditional scan не выявил дополнительных правил.

**Проверки**

- dart analyze отдельного инструмента, генерация и --check; semantic evidence тест с точным сравнением spans и targets.
- Пользовательская и визуальная браузерная приёмка ожидаются; следующий этап не начат.
- Flutter-билды и коммиты не выполнялись.

### Итерация 7 — реестр и members из analyzer

**Prompt пользователя**

> давай к следующему этапу

**Изменения**

- Этап 2 принят. Реестр переведён на analyzer 8.4.1: class/enum, declared fields, methods, constructors, getter/setter/operator и enum values. Barrel включён; 68 Dart-файлов и 87 объектов.
- Schema 7 содержит library-qualified IDs, member identity, resolved types, parameters и точные source spans. AST errors блокируют генерацию, unsupported declarations диагностируются.
- Details разбит на группы состава, имеет самостоятельный скролл, evidence и member permalinks с восстановлением после reload. Карточки остаются компактными; роль помечена классификацией по каталогу.
- R-001: Dart extractor отвечает за факты, JS orchestration — за layout/serialization, UI — за отображение. R-002: создан docs/development/domain-viewer-inventory.md, обновлены audit и руководство. Conditional rules в router отсутствуют.
- Inherited members, semantic edges, API fingerprints и поиск implementations остаются последующими этапами, что видно в diagnostics.

**Проверки**

- dart analyze и fixtures aliases/duplicate names/generics/nullability/dynamic/constructors/accessors/enhanced enum/unsupported declarations пройдены.
- Генерация и проверка schema 7: 87 resolved объектов, 167 временных эвристических стрелок. Проверка operation evidence сохраняется.
- Headless Edge: 1366×768 и 1920×1080, загрузка реестра, permalink reload, состав и operation trace; screenshots проверены визуально. Playwright установлен в OS temp, без новых runtime dependencies проекта.
- Пользовательская приёмка ожидается; этап 4 не начат. Flutter-билды и коммиты не выполнялись.

### Итерация 8 — связи и обзор областей

**Prompt пользователя**

> давай дальше

**Изменения**

- Этап 3 принят. Schema 8 заменяет эвристические стрелки на resolved типы/наследование/создание/вызовы с occurrences, source members, статическими targets и точным evidence.
- Новый overview показывает области, categories/public operations и межобластные направления; canvas остаётся отдельным техническим представлением. Выбор связи открывает все основания в Details, SDK/unknown доступны отдельно.
- Generic bindings, совпадения локальных имён и dynamic calls не превращаются в выдуманные зависимости. Области/роли определены по расположению, их бизнес-смысл ещё не описан.
- R-001: extractor relations, identities/types и отображение разделены без циклических imports. R-002: контракт schema 8 и ограничения обновлены в docs/development/domain-viewer-inventory.md и README. Conditional rules в router отсутствуют.

**Проверки**

- dart analyze и fixtures: aliases, local-name collision, dynamic, extends/implements, явный super constructor и точные spans.
- Generated validation: 87 объектов, 166 object edges, 1016 occurrences; все source IDs/member IDs/targets, группировки и code spans проверены. ParticipantId не создаёт зависимости на Profile.
- Headless Edge на 1366×768 и 1920×1080: overview, межобластные направления, выбранная связь, source evidence, permalink reload и regression operation trace; screenshots проверены.
- Пользовательская приёмка ожидается; этап 5 не начат. Flutter-билды и коммиты не выполнялись.

### Итерация 9 — этапы 5–7 без остановок

**Prompt пользователя**

> продолжи этапы без остановок

**Изменения**

- Этап 5: канонический контекст в `docs/architecture/domain-viewer-context.json` для всех семи областей и 32 ключевых объектов. Цели адресованы generated IDs; API/implementation fingerprints, curated сценарий `removeParticipant` и ссылки на конкретные AST steps проверяются генератором. Битые ссылки, drift и отсутствующий файл различаются диагностикой. Generated факты не редактируются вручную.
- Этап 6: режимы «Обзор», «Объект», «Сценарий», «Техническая карта», смысловые подписи, раскрываемые доказательства, hash/back/breadcrumb, текстовые связи, live-region, focus-visible и reduced-motion. Выбор не теряется от фильтра. Статические факты и curated текст разделены.
- Этап 7: отдельный локальный навык `.codex/skills/domain-viewer`, команды генерации/проверки, fixtures для `part` и parse errors, проверки stale/orphan/missing context и двух последовательных byte-identical генераций. Ограниченный implementation scan перечисляет только фактически проверенные внешние Dart-файлы; отсутствие DI или реализаций в иных roots не утверждается.
- При проверке найден и исправлен дефект: незакрытый Dart class не останавливал extraction; теперь выполняется явная синтаксическая проверка.
- R-001: факты и relation/trace отделены от курируемого контекста и отображения. R-002: контракт schema 9 и workflow описаны в docs; conditional scan не выявил дополнительных правил.

**Проверки**

- `make domain-check-test`: generated `--check`, operation trace, relation evidence, context/stale/orphan/missing diagnostics, `dart analyze`, analyzer fixtures, two-run byte-identical generation — пройдено.
- Headless Edge на 1366×768, 1920×1080 и узком окне с CSS zoom 200%: обзор, сценарий с AST evidence, объект/member, связь, back/permalink и карта — пройдено. Скриншоты просмотрены. Настоящий browser zoom 200% и ручная accessibility-приёмка отдельно не заявляются.
- Локальный skill прошёл `quick_validate.py` (PyYAML установлен только во временный QA-каталог). `git diff --check` — без ошибок. Flutter-билды и коммиты не выполнялись.

**Остаётся до закрытия задачи**

- JSON schema/structure validator и узкая панель «Карта»/«Детали» добавлены после первой записи этой итерации. Остаются ручной accessibility-аудит при настоящем browser zoom 200%, утверждение capability matrix и пользовательская приёмка UI. Implementation scan покрывает resolved supertypes в указанном scope, но не доказывает runtime DI. Статус задачи не переведён в ✅.
