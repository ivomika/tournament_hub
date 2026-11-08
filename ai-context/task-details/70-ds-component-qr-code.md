# Задача 70. QrCode — добавить отображение QR и кода доступа

## Статус и этап

✅ Выполнена

- Mode: CODE; динамическая генерация и themed renderer реализованы.
- TestGate: REQUIRED для encoder/data; RED и approval пользователя получены8 ноября2026. Visual scope NOT_REQUIRED.
- Stage: DONE.
- Specification:1; plan:1; encoder/raster/source/native проверки выполнены.
- Encoder и векторная отрисовка реализованы после approval; push запрещён до ревью.

## Цель и контекст

Один результат задачи: **AppQrCode**, scope `components/qr_code`. Добавление/расширение именно одного элемента вместе с его темой, scoped Widgetbook и проверками; не набор новых компонентов экранов.

UI kit содержит исходный демонстрационный QR; participant/spectator — разные назначения доступа.

Эталон: [UI kit](../../docs/design/prototype/ui-kit.html#c-qr), [описание и ограничения](../../docs/design/ui-kit.md), [mapping источников](../../docs/design/prototype/ui-kit-mapping.json). Уже реализованная основа: [foundation](../../docs/design/foundation.md), [manifest](../../docs/design/tokens-manifest.md). Рабочий порядок: [добавление DS-компонента](../../docs/development/design-system-component-workflow.md), [visual workflow](../../docs/development/visual-workflow.md).

## Scope и non-goals

- Входит: Один визуальный QR-компонент, получающий готовую локальную graphic/matrix/image presentation-модель, доступное описание и optional code slot. Theme управляет contrast/quiet zone/size. Не добавлять зависимость без обоснования.
- Входит: собственная типизированная тема, trace к foundation tokens и обновление manifest/docs по затронутым решениям.
- Входит: реальные use cases в Widgetbook, shared deterministic scenarios и executable native golden visual samples; meaningful interaction/semantics tests по риску.
- Не входит: перенос экранов, изменение HTML UI kit/прототипов, бизнес-правила, use cases, DI/сеть/БД, новая локаль, новая светлая тема, Widgetbook Cloud/generator или обновление SDK.
- Не создавать будущие runtime/Widgetbook-папки сейчас; эта карточка — постановка.

## Применимые правила

- Core: R-001 — одна ответственность и композиция; R-002 — русские owning docs; R-004 — enum/sealed/value objects для вариантов/состояний, без строковых lookup; R-007 — соразмерные фактические проверки, честный NOT_RUN.
- Flutter: R-003.a/b — presentation boundaries и делегирование без use cases в widget; R-003.c — внешние механики/пакеты изолированы и обоснованы; R-003.d — отдельная папка и типизированная тема, всё оформление (включая0) из токенов; R-003.e — только package/dart directives.
- R-003.f — screen не реализуется, но DS не импортирует screens/controllers/Widgetbook; будущие screens используют этот элемент.
- R-005 — UI/semantics/formatted text через intl; пользовательские данные не переводятся; metadata Widgetbook не подменяют локализацию.
- R-006.a/b — private widgets вместо Widget helpers; именованные callbacks, недоступный callback=null.
- R-006.c/d — scoped use cases, общие fixtures/builders, свой comparison golden текущей native ОС; knobs не заменяют fixed scenarios.
- Conditional scan: иных conditional rules в router нет. Перед будущей реализацией перечитать актуальные правила и зависимости.

## Зависимости и архитектурные границы

- Depends on: [40](40-ds-foundation-colors.md), [41](41-ds-foundation-typography.md), [42](42-ds-foundation-spacing.md), [43](43-ds-foundation-shape.md), [47](47-ds-foundation-responsive.md).
- Product: `lib/presentation/design_system/components/qr_code/`; собственная тема рядом с визуальным элементом. Чистые tokens не требуют PNG сами по себе.
- Widgetbook: `lib/presentation/widgetbook/components/qr_code/<named_use_case>/`; каждый именованный use case в своей папке, registry только агрегирует регистрации.
- Tests: `test/presentation/design_system/components/qr_code/`; PNG — `golden/<native-os>/` рядом с визуальным элементом/showcase в lib. Harness/matcher/flutter_test — только test.
- Никакой независимой копии компонента в showcase/golden. Использовать текущую оболочку/registry и existing FoundationScenarioHost там, где он подходит; не создавать новый entrypoint.

## Уточнения и решения

- Пользователь1 ноября2026 запросил постановку: одна задача — один компонент, начиная с foundation.
- Имена Dart API выше — ориентир для постановки; финальный узкий контракт фиксируется по задаче без добавления несвязанных сущностей.
- Статус source/CSS/restored/proposed из UI kit сохраняется. Отметка «предложено» не превращается в утверждённое product state автоматически.
- Смысловые варианты общие для Desktop/Mobile; менять только подтверждённые constraints/density/layout через theme. Текст и выбор конкретной иконки — данные, не новый компонент.

## Acceptance Criteria

- [x] AC-70.1: AppQrCode реализован/расширен в указанном scope; нет параллельной копии уже существующей сущности, ссылку на HTML-эталон можно проследить.
- [x] AC-70.2: все визуальные параметры приходят из собственной темы и общих токенов, API типизирован; raw styling/строковые discriminators/бизнес-правила отсутствуют.
- [x] AC-70.3: именованные Widgetbook use cases показывают реальный элемент: QR с/без текстового кода; participant/spectator данные; узкие constraints; доступное описание; статичный asset для capture.
- [x] AC-70.4: Widgetbook и golden используют одинаковые fixtures/именованные builders/темы; native baselines созданы/сверены, diffs просмотрены, comparison после update выполнен без update.
- [x] AC-70.5: проверены constraints, значимые states, локализованные labels/semantics и content limits; совпадение visual identity Desktop/Mobile подтверждено, отклонения записаны.
- [x] AC-70.6: manifest/owning docs/scenario registrations актуальны; analyze/tests/architecture checks по impact PASS либо честный blocker с NOT_RUN. Результат показан пользователю.

## Ошибки и крайние случаи

Не создавать сессии, не генерировать протокол/URL и не выдавать демонстрационный QR за рабочий. Encoding/декодирование/валидация — вне этой визуальной задачи и потребуют отдельного TestGate при добавлении.

Для любой интерактивности отдельно проверить доступный/недоступный callback, pointer/keyboard и focus; требования применяются только к реально поддерживаемому контракту. Не создавать декартов продукт всех props/knobs.

## Test Scenarios

| Сценарий | Критерии | Уровень | Ожидаемый результат |
| --- | --- | --- | --- |
| TS-70.1 Основной вид и перечисленные варианты | AC-70.1, AC-70.2, AC-70.3, AC-70.4 | Реальный Widgetbook + shared golden | Source-анатомия/тема сохранена; собственная папка use case; нет UI-копии |
| TS-70.2 Значимые states и делегирование | AC-70.2, AC-70.3, AC-70.5 | Widget/semantics по контракту | Именованные callbacks и ожидаемая доступность; без domain/infrastructure |
| TS-70.3 Длинный контент/ограничения | AC-70.3, AC-70.5 | Render390×844,1440×900 и обоснованные boundary widths | Нет неожиданных overflow/clipping; прокрутка там, где она часть контракта |
| TS-70.4 Изменение темы/общего токена | AC-70.2, AC-70.4 | Golden затронутых потребителей | Оформление обновляется через theme; source/proposed различия задокументированы |
| TS-70.5 Native comparison | AC-70.4, AC-70.6 | Flutter comparison текущей ОС | Bundled fonts, DPR1, ru/direction/text scale/animation phase фиксированы; missing baseline — ошибка |

## Предварительная последовательность

Это набросок постановки, а не начатый implementation plan.

1. Перечитать текущие rules/зависимости, сверить UI kit с Flutter baseline; разрешить отмеченные неоднозначности и зафиксировать узкий контракт/сценарии.
2. Дополнить существующий foundation либо собственную theme; реализовать один элемент из согласованных частей, без screen/business wiring.
3. Подключить scoped Widgetbook use cases и shared scenarios; добавить соответствующие comparison tests и native PNG.
4. Выполнить релевантные checks, посмотреть рендер/diff, повторить comparison без update; обновить manifest/docs и карточку.

## Проверки при реализации

Из `apps/tournament_app`: `flutter analyze --no-pub`, targeted `flutter test --no-pub` для затронутого элемента/потребителей. `--update-goldens` — только намеренное обновление затронутого native set с последующим обычным comparison. Из корня: `make architecture-check` / `make architecture-test` при новых Dart-directives/структуре. Bundled Inter/RobotoCondensed и существующие VisualViewport — baseline.

Невизуальным token/value objects не создавать фиктивный golden: сравниваются реальные visual showcase/потребители. Наборы windows/linux/macos не копировать друг в друга; фиксировать фактическую среду и NOT_RUN других ОС. Новые SDK/packages/генератор не подразумеваются этой задачей.

## Test Evidence и Approval

- NOT_RUN: runtime-код, tests и baselines не изменялись; задача только поставлена.
- Для visual scope TestGate approval не требуется; запуск реализации — отдельный запрос. Если появится логическая часть, пройти workflow REQUIRED для неё до production изменения.
- Обязательная golden-проверка R-006.c сохраняется независимо от отсутствия логического gate.

## Открытые решения

Финальные имена API и способы передачи темы уточняются при реализации. Если обнаружится неоднозначность поведения, не угадывать её: записать вопрос и остановить только зависимую часть по workflow.

## Changelog

### Итерация1 — постановка,1 ноября2026

**Prompt пользователя (дословно)**

> выглядит лучше. Добавь задачи на добавление каждого копонента в дизайн систему приложения. Перед добавлением прочитай правила проекта и как правильно добовлять компоненты в дизайн систему и widgetbook. Одна задача - один компонент начиная с foundation

**Изменения и проверки**

- Прочитаны core/Flutter rules, canonical workflow, проектные документы о DS/Widgetbook/golden, существующие AppFoundation/AppColors/AppTypography/FoundationLayout/registry/fixtures; изучены официальные Widgetbook Use-cases/Knobs/Golden и Flutter theming.
- Создана отдельная карточка одного элемента; отмечены зависимости, source anchor, significant states, границы и условия приёмки. Только metadata/docs; runtime-папки не созданы, Flutter tests не запускались.
- Проверка постановки: сквозной реестр1–71 без повторов;32 карточки покрывают9 foundation scopes и все23 семейства UI kit; зависимости без циклов;412 локальных ссылок существуют; обязательные секции и AC refs присутствуют. `node tools/check_rules.cjs` и `git diff --check` — PASS. Это проверки metadata, а не запуск будущих Flutter tests.

## Final Verification

- [x] Все AC подтверждены при реализации; тесты фактически запущены.
- [x] Theme/scenarios/goldens/docs согласованы, визуальный результат показан.
- [x] Нет бизнес-логики/запрещённых dependencies/raw styling.

## Итог

Компонент реализован; текущий контракт — динамическая генерация из data с сохранением оформления и проверкой считывания. См. завершающую итерацию ниже.

### Новая очередь переноса после RosterRow

Prompt пользователя (дословно):

> выглядит хорошо. Обнови задачи по реализации компонентов, посмотри что уже выполнено, а что еще требует реализации и реализуй каждый компонент по новому flow делая коммит для каждого компонента без push

Обязательный flow текущей итерации: сверить существующий runtime и итоговый CSS UI kit → определить реальные состояния/адаптацию и контрольные узлы → typed runtime WidgetTheme без primitives в consumers → scoped Widgetbook/shared fixture → декларация общего comparison pipeline → source/native/overlay/diff и native goldens → осмотр и исправление внутренних различий → повтор без update, tests/analyzer/architecture → отдельный локальный коммит компонента без push. Существующая реализация не дублируется. Наличие tokens в72 не равно выполнению всех старых AC foundation.
Факт сверки: отдельного production компонента и comparison declaration пока нет; задача остаётся в очереди реализации.

### План70

AppQrCode получает готовую AppQrGraphic alpha-mask ImageProvider, semanticLabel и optional code. Только display, без QR encoding/session/network. Fixture mask экспортируется из исходного SVG с quiet zone и finder geometry, это данные графики, не снимок всего компонента. Runtime colors/background/size/code typography/fit. Source code/no-code×2, native theme/scaled/semantics. Visual NOT_REQUIRED.

### Реализация70 —8 ноября2026

Prompt пользователя (дословно):

> продолжи

AppQrCode display получает готовую AppQrGraphic alpha-mask/semanticLabel/optional code, без encoder/session/network. Fixture mask экспортирована из исходного SVG880px; hash/происхождение в manifest. Runtime цвета перекрашивают mask, code — Flutter Text. Source4/4 PASS после update и обычного comparison, overlay просмотрен. Первый baseline не содержал decoded graphic: ordinary golden обнаружил31% diff, baseline исправлен, повтор прошёл. Driver ждёт precacheImage и проверяет RawImage.image!=null. Native theme/semantics/scaled test PASS без update; analyzer no issues, architecture307 files PASS, engine37 PASS. MacOS hot restart выполнен, другие ОС NOT_RUN. Итог: выполнено.

### Динамическая генерация QR —8 ноября2026

Prompt пользователя (дословно):
> давай сделаем чтобы он генерировался, но визуально должен сохранить свой вид

> не пуш до моего ревью

Stage: TESTS_PREPARING; Mode CODE; TestGate REQUIRED для кодирования/контракта данных QR. Визуальная отрисовка NOT_REQUIRED; encoder требует RED и approval по canonical workflow. Push запрещён.

Specification1 / Plan1: ввод — произвольный текст ссылки; изолированный QR encoder возвращает собственную immutable матрицу bool без library types. Компонент рисует реальные модули; скругления модулей и finder patterns, quiet zone4, текущие цвета и typography/radius остаются. При другой ссылке узор меняется, а не остаётся PNG. Без генерации самой spectator-ссылки/сервера/сети. QR library кодирует стандарт, CustomPainter воспроизводит существующую форму; не заменять стандарт случайной псевдосеткой.

План: независимые decode roundtrip tests для короткой/длинной/UTF8 ссылки, determinism/изменения payload, immutable square matrix; RED. После approval — изолированный encoder, themed vector renderer, замена fixture asset на текст ссылки, scanning rendered PNG через независимый decoder, intentional baselines и source comparison (узор может отличаться от старого fixture, геометрия и стиль сохраняются), analyze/architecture/runtime preview. Собственные API на границе: AppQrMatrixEncoder.encode(String) → AppQrMatrix.modules (deep immutable List<List<bool>>).

### Test gate1
Stage AWAITING_APPROVAL. `flutter pub get --offline` —PASS, добавлен только dev decoder zxing2 0.2.4 (cached). `flutter test --no-pub test/presentation/design_system/components/qr_code/qr_matrix_encoder_test.dart` —ожидаемый compile RED: отсутствует AppQrMatrixEncoder/production API; остальные decoder imports/API компилируются. Пять сценариев:3 roundtrip, determinism/change, deep immutability. Production QR не изменён. Specification/plan: docs/design/qr-generation.md. После approval реализовать encoding/rendering, выполнить независимое декодирование PNG и визуальные сравнения. Коммит с failing tests не создавался; push отсутствует.

Approval пользователя (дословно):
> Подтверждаю, реализуй генерацию QR с сохранением текущего оформления и проверкой считывания. Без push до моего ревью.

Stage IMPLEMENTING; approved specification1/plan1/test set1.

### Завершение динамической генерации —8 ноября2026

Stage DONE. AppQrCode.data кодируется через qr4.0.1 → собственную deep immutable матрицу → themed vector painter. PNG-mask и asset registration удалены. Preserved: версия минимум4 (33×33), finder7/5/3 с радиусами1/.65/.5, module radius.32, quiet zone4, surface radius/colors/code text/padding. Большие данные увеличивают version; превышение ёмкости40 оборачивается ArgumentError. Payload не обрезается.

-8 QR tests PASS без update:3 независимых matrix roundtrip (short/long/UTF8), determinism/change, immutable rows, oversized error, themed/scaled native goldens, raster decode6 реальных изображений220/320px. zxing signed Int8List→Utf8Codec bug документирован: сравниваются независимо декодированные byteSegments, нормализованные unsigned, без hints.
- Web/native4 source сценария PASS после обновления и обычного запуска, отдельные web/native картинки просмотрены. Исправлены antialias seams единым compound Path. Raster узор намеренно другой при сохранённой геометрии; нет утверждения побитового совпадения с картинкой.
- Widgetbook/foundation regression18 PASS, включая98 use cases. QR payload knob в access/graphic позволяет менять ссылку. analyze PASS; architecture49+51+35 fixture tests PASS, checker318 файлов без нарушений; rules/diff PASS. Native macOS runtime запущен, hot reload1/1330 libraries330ms выполнен. Другие ОС NOT_RUN; физическая камера не проверялась.
- Отчёт docs/design/prototype/comparison/qr-code/index.html; docs/design/qr-generation.md и manifest актуальны. Сохранение оформления проверяется source controls/native goldens, считывание — независимым raster decoder. Локальный коммит, без push до ревью.

### Именованные QR payload use cases
Prompt пользователя (дословно):
> покажи в widgetbook usecase несколько вариантов данных в qr

Stage IMPLEMENTING; TestGate NOT_REQUIRED: fixed visual scenarios без нового encoding/данных приложения. План: короткая/длинная/Unicode ссылка в отдельных scoped use cases, общий typed sample для Widgetbook/native goldens; проверить каталог и previews.

Stage DONE. Добавлены три scoped use cases: Short link, Long link, Unicode link; typed QrPayloadSample общий с6 mobile/desktop goldens. Каждый показывает реальный QrFixture и предоставляет QR payload knob. Новые native baselines созданы намеренно, затем обычный suite13 PASS (включая все101 use case каталога, QR scans и goldens без update). Analyzer PASS, architecture322 файлов PASS, rules/diff PASS. Production encoder/painter не менялись. Локальный коммит без push.
