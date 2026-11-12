# 112. Первичная регистрация локального профиля

## Статус и этап

✅ Завершена · Mode CODE · TestGate REQUIRED: domain/use cases, хранение, bootstrap, navigation и controller.
Stage DONE. Specification1 / plan1 / test set1. RED_CONFIRMED → approval → GREEN → VERIFYING → DONE.
Процесс: [workflow](../workflow.md).

## Цель и контекст

При запуске приложение читает локальный профиль. Заполненное имя открывает главную без повторной регистрации. Если профиля или имени нет, открывается самостоятельный экран «Регистрация» с вводом имени. UUID выдаётся через общий генератор, а не специальный генератор профилей.

Текущий код: domain содержит только TournamentId и logging; infrastructure — logging. Profile/ProfileEdit — изолированные визуальные экраны с fixtures, без профиля/репозитория/хранения. Bootstrap сразу создаёт AppNavigationSession с HomeRoute. Основания: [bootstrap](../../docs/architecture/bootstrap.md), [границы слоёв](../../docs/architecture/layer-boundaries.md), [навигация](../../docs/architecture/typed-navigation.md), [UI](../../docs/architecture/presentation-ui.md).

## Scope и non-goals

- Входит: типизированные LocalProfile/ProfileId/ProfileName; общий IdentifierGenerator/UniqueIdentifier; UUID v4 adapter; domain repository/use cases; сохраняемый локальный профиль; post-runApp bootstrap чтения; typed RegistrationRoute и completion intent/guard/effect; registration controller/screen/theme, intl, scoped Widgetbook и native Windows goldens.
- Не входит: авторизация, backend/account, вход по QR, синхронизация, удаление аккаунта, редактирование профиля, статистика, миграция несуществующего старого хранилища, выдача UUID всем будущим сущностям.
- Единственный ввод — имя. Непустое после trim; не вводить неподтверждённые ограничения длины/алфавита/уникальности имён. Частично заполненный профиль сохраняет прежний ID.

## Применимые правила

- [R-001](../rules/core/001-solid.md), [R-002](../rules/core/002-documentation-russian.md), [R-004](../rules/core/004-typed-values.md): отдельные ответственности, документированные решения, IDs/status/errors типизированы, UUID package скрыт в adapter.
- [R-007](../rules/core/007-code-testing.md), [R-008.a](../rules/core/008-a-readable-names.md), [R-008.b](../rules/core/008-b-explicit-conditions.md), [R-009](../rules/core/009-cancellable-async.md): test-first gate, понятные имена, явные условия, отменяемые операции с централизованным ownership.
- Flutter R-003.a/b/c: repository port в domain, library adapters в infrastructure, composition в app, use cases из controller. R-003.d/e/f/g/h: themed DS composition, package imports, независимый экран, class-owned methods, intent → guard → effect.
- Flutter R-005: intl. R-006.a/b/c/d: widgets вместо helpers, named callbacks, mobile/desktop Windows goldens, общие preview scenarios Widgetbook/golden.
- Полные обязательные Flutter rules прочитаны через [router](../rules/README.md); conditional scan: других conditional rules нет. Новые правила/исключения не планируются. Все перечисленные ограничения применяются к реализации и тестам.

## Уточнения и решения

- Пользователь требует UUID и общий генератор; выбран v4 без зависимости domain от UUID package.
- Имя нормализуется trim; пустое не сохраняется. Существующий заполненный профиль не перерегистрируется, его ID не генерируется заново.
- Локальное хранение: предлагается SharedPreferencesAsync за собственной минимальной KeyValueStorage абстракцией и StoredProfileRepository. ID/имя сохраняются одной версионированной записью; отдельного флага firstLaunch нет. Это локальные данные установки, не серверная учётная запись и не защищённое хранилище. Ограничение API: успешная запись не гарантирует crash-durability; повреждение/ошибка чтения не трактуется как отсутствие профиля и не приводит к молчаливой замене ID.
- Уже существующие OperationRequest/Scope/Outcome/ManagedOperation — pure Dart, но находятся в presentation. Для domain use cases перенести их в domain/operations без изменения semantics; старые presentation imports временно сохраняют совместимость через точечные exports. Не создавать второй механизм отмены или domain → presentation импорт.
- После чтения профиль передаётся app-сессии; отсутствие/неполнота выбирает регистрацию. Guard закрывает доступ к рабочим экранам до успешного сохранения, включая прямой URL и Back. Completion intent не выполняет GoRouter из UI. Ошибка чтения блокирует bootstrap с retry; ошибка сохранения оставляет введённое имя на регистрации. App не объявляет профиль заполненным до подтверждения repository.

## Acceptance Criteria

- [x] AC1: отсутствие/неполное имя → регистрация; заполненный сохранённый профиль → Home при каждом новом запуске, без генерации ID.
- [x] AC2: валидное имя сохраняется с ProfileId из общего генератора и открывает Home через guard/effect; повторный запуск сохраняет ID/имя.
- [x] AC3: пробельное имя отклоняется без записи/генерации; неполный существующий профиль дополняется с прежним ID.
- [x] AC4: ошибка чтения/повреждение дают retryable typed failure; ошибка записи не переводит на Home, сохраняет ввод и допускает retry.
- [x] AC5: двойной submit не создаёт две записи/ID/навигации; disposal во время read/save прекращает доставку и следующую работу, поздние результаты наблюдаются без утечки. Уже завершённая запись не выдаётся за отменённую.
- [x] AC6: до заполнения нельзя обойти регистрацию прямым рабочим URL/Back; после заполнения регистрацию не открываем повторно.
- [x] AC7: UUID v4 adapter выдаёт корректные разные ID; uuid импортирован только адаптером, инфраструктурные типы не выходят в domain/presentation.
- [x] AC8: registration изолирован, mobile first, intl/theme, Widgetbook основные/значимые состояния и native mobile/desktop goldens. Документация/архитектурные проверки актуальны.

## Test Scenarios

| Сценарии | Критерии | Проверяемая граница |
| --- | --- | --- |
| Нет/есть/неполный профиль при старте | AC1, AC6 | Реальный bootstrap + router с fake repository |
| Регистрация и новый use case/repository после сохранения | AC2, AC3 | Реальные domain models/use cases и codec, fake внешнее storage |
| Ошибка чтения/записи, повреждённый payload, retry | AC4 | Typed failures, bootstrap/controller, реальные repository/use cases |
| Double submit, закрытие во время ожидания, late result | AC5 | Реальный controller/OperationScope; управляемые внешние Future |
| Формат v4, разные значения | AC7 | Реальный UUID adapter; проверка не доказывает математическую невозможность коллизий |
| Регистрация mobile/desktop, editing/invalid/saving/error | AC8 | Shared Widgetbook/golden fixtures, checks |

## Implementation Plan

1. Baseline bootstrap/navigation/operations, затем executable tests отсутствующих capability; подтвердить compile RED и остановиться на approval.
2. После approval: общие pure-Dart operation contracts, identifier port/value/adapter, profile models/use cases, storage adapter/codec/repository. Подключить uuid и shared_preferences только после gate.
3. Post-app InitializeProfileStep; типизированный bootstrap context и app composition. RegistrationRoute, session state и guard/effect; сохранить прочие navigation contracts.
4. Registration controller с OperationScope и защитой от повторного submit; отдельный deterministic screen с темой и DS без бизнес-логики. Подключить реальные callbacks в app binding, не во widgets.
5. Intl/Widgetbook/Windows golden capture, просмотр и comparison; docs архитектуры регистрации и dependencies, manifest при новых токенах. Проверить выбранную регрессию, analyze, architecture-check/test, формат, links/rules. Без build/run/commit/push.

## Test Evidence

Все Flutter-команды выполнены из apps/tournament_app, дата2026-11-11. Production/dependencies/runtime-конфигурация не менялись.

| Проверка | Команда | Результат и смысл |
| --- | --- | --- |
| Baseline | flutter test --no-pub test/app/bootstrap test/app/navigation test/presentation/operations --reporter compact | exit0,126 PASS. Регрессия bootstrap/navigation/lifecycle до добавления тестов112 |
| Test set1 | flutter test --no-pub test/profile_registration/profile_registration_test.dart --reporter expanded | exit1, compile RED. Отсутствуют domain identifiers/profile/operations, infrastructure storage/profile/UUID adapter, registration controller/screen, RegistrationRoute/ProfileRegisteredIntent/intl getter и profileRepository/identifierGenerator injection в ApplicationBootstrapPlan. Ошибки соответствуют отсутствующему capability; продуктовые заглушки для компиляции не добавлены |
| Format | dart format test/profile_registration/profile_registration_test.dart | exit0;1 файл отформатирован |
| Whitespace | git diff --check | exit0 |

Test set1:17 зарегистрированных сценариев в test/profile_registration/profile_registration_test.dart. Из-за compile RED ни один из них ещё не считается выполненным/прошедшим. Четыре группы: реальные domain use cases, repository/codec с fake техническим storage, controller с реальными use case/scope, реальные bootstrap/router/UI с fake внешним repository. Baseline операции импорта presentation сохранена для проверки будущего совместимого переноса pure-Dart механизма. Runtime/analyzer/architecture GREEN нового кода и PNG — после approval/implementation; не объявляются пройденными сейчас.

## Approval

2026-11-11 · Пользователь: «делаем». Относится к задаче112, specification1/plan1/test set1, baseline126 GREEN и подтверждённому compile RED. Реализация разрешена после test-first gate.

## Changelog

### 2026-11-11 · Постановка

> Так новая задача. При первом запуске нужно открывать экран "Регистарции" в котором необходимо ввести имя профиля. Каждый раз открывать экран регистрации не нужно, только если профиль не заполнен. Выдаем ему уникальный индитификатор. Будем использовать uuid. Для генератора идентификаторов будем использовать общий генератор идентификаторов.

- Зарегистрирована112; прочитаны router/core/flutter/workflow, исследованы действующие bootstrap/navigation/profile previews. Существующего profile repository нет.
- Изучены первичные package docs: [uuid](https://pub.dev/packages/uuid) — v4 generation; [shared_preferences](https://pub.dev/packages/shared_preferences) — Async API, platforms и отсутствие гарантии crash-durability. Версии и SDK-совместимость проверить resolver после approval, пакет пока не устанавливается.
- Зафиксированы scope/spec/plan1; выполняется только тестовая подготовка до human gate.

### 2026-11-11 · Test-first gate

- До новых тестов выбранная baseline126 PASS. Добавлен только test/profile_registration/profile_registration_test.dart с17 сценариями и явно тестовыми fakes внешнего repository/storage/generator/navigation sink. В бизнес-проверках register use case/codec/controller/runner/router не подменяются. Отдельный реальный UUID adapter проверяется форматом и различием выборки, без заявления о доказанной уникальности всех будущих ID.
- Прогон test set1 дал ожидаемый compile RED отсутствующих API, exit1; разбор диагностики не обнаружил постороннюю причину отказа. Production/pubspec/lock не менялись. Формат применён; diff whitespace чистый.
- Stage DISCOVERY → SPEC_READY → PLAN_READY → RED_CONFIRMED → AWAITING_APPROVAL. Запрашивается approval spec1/plan1/test set1 перед реализацией по каноническому workflow.

### 2026-11-11 · Реализация после approval

> делаем

- Approval пользователя получен до production: specification1/plan1/test set1, контекст предыдущего ответа с baseline126 GREEN и compile RED.
- Реализованы domain UniqueIdentifier/IdentifierGenerator, LocalProfile/ProfileId/ProfileName, repository/use cases. UUID4.6.0 скрыт в infrastructure adapter; SharedPreferencesAsync2.5.6 скрыт за KeyValueStorage. Resolver успешно установил версии; platform_interface2.4.2 добавлен только в dev_dependencies для подмены native API в тесте реального адаптера. Автогенерированные platform registrants/ffi plugin lists обновлены pub get; приложение не собиралось.
- Четыре исходных pure-Dart operation реализации перенесены в domain/operations; прежние пути — compatibility exports тех же типов. Сравнение с HEAD подтверждает отсутствие изменений реализации4/4 кроме import paths. OperationSequence добавляет владение последовательными request; cancellation между read/save не запускает следующий factory.
- InitializeProfileStep выполняется после runApp, получает профиль через use case и передаёт ProfileBootstrapContext в InitializeNavigationStep. AppProfileSession отражает только успешные read/save. BootstrapStepException получил optional cause для сохранения исходной ProfileException; retry/lifecycle не ослаблены. Во время чтения отдельная intl-подпись, при отказе — ошибка профиля с retry.
- RegistrationRoute, ProfileRegisteredIntent, profileStatus в context/guard, origin/effect и отдельный RegistrationBinding. До завершения нельзя уйти Back/прямым рабочим URL; после завершения нельзя повторно открыть регистрацию. Binding владеет controller/TextEditingController, Screen только компонует DS и принимает состояние/callbacks. ProfileRoute отображает реально сохранённое имя вместо пустого макета. Другие бизнес-флоу не подключались.
- RegistrationController использует OperationScope, сохраняет ввод при ошибке, разделяет concurrent submit и подавляет late navigation после закрытия. Нет isDisposed/isClosed. Экран/собственная theme используют существующие runtime DS tokens; новых primitives нет. Все тексты intl.
- Widgetbook:5 Registration states (empty/editing/invalid/saving/error),2 новых Bootstrap states (preparing-profile/profile-unavailable). Shared fixtures/golden builders;14 новых Windows PNG mobile390/desktop1440. Старые baselines не изменились. Просмотрены и показаны390-empty,1440-editing,390-error. Capture18 scenarios PASS, затем comparison без update в полном suite PASS; другие ОС не заявляются проверенными.
- Исходные17 test-first сценариев прошли без ослабления ожиданий. Первичная regression124 PASS/2 failures выявила отсутствие native plugin в старых bootstrap tests; передан fake сохранённый профиль только на внешней repository-границе, lifecycle assertions сохранены. После адаптации baseline126 + новые17 =143 PASS. Route catalog дополнен RegistrationRoute и ожидаемым числом26.
- Дополнены6 регрессионных проверок без изменения утверждённого поведения: реальный Preferences adapter/SharedPreferencesAsync с official in-memory platform backend, fresh adapter/no-cache, native read error, late committed native write без доставки, missing/blank name и некорректная schema/ID. Codec допускает отсутствие имени как неполноту, но не потерю ID. Все6 PASS в полном suite. Это не физический тест диска/OS durability.
- Full flutter test --no-pub --reporter compact:364 PASS,1 штатный skip внешнего CLI visual comparison. Все зарегистрированные Widgetbook cases открываются настоящим workbench, native goldens сравнены. flutter analyze --no-pub — No issues found. Локальные промежуточные lint infos prefer_initializing_formals/curly_braces исправлены без ignore.
- Архитектура658 файлов —0 findings. Fixtures navigation32/readability41/top-level49/theme35/self-test51 PASS. dart format применён; rules registry20 leaf/3 группы согласован; git diff --check без ошибок. Создан docs/architecture/local-profile-registration.md, обновлены bootstrap/navigation/lifecycle/manifest/экранная документация и docs index; локальные ссылки проверяются перед закрытием.
- Hot restart существующего Edge app запрошен через DTD; итог runtime проверки дописывается ниже. Build/new app run/commit/push не выполнялись.

## Final Verification

- [x] Критерии подтверждены; тесты/архитектура/analyze прошли.
- [x] Сохранение/повторный запуск и guard проверены; визуал показан, golden comparison выполнен.
- [x] Docs и история актуальны; ограничения честно отражены.

## Итог

### Changelog · 2026-11-12 · Коммит

> делаем коммит и приступаем к задаче работы с профилем. Нужен чтобы его можно было редактировать имя и чтобы в аватаре профиля отображались инициалы профиля. Статистику пока скрываем.

- Пользователь разрешил коммит завершённой регистрации. Изменения112 выделяются отдельно от правила113; английский Conventional Commits, без push. Подтверждённые проверки364 PASS/1 штатный skip, analyzer/architecture GREEN остаются применимы: runtime с момента проверки не менялся. Редактирование профиля — независимая новая задача.

Регистрация локального профиля реализована; ID генерируется общим UUID-адаптером, запись сохраняется, заполненный профиль не регистрируется повторно. Ошибки/отмена/защита маршрутов покрыты реальными use cases/controller/bootstrap/router с внешними fakes. Full suite364 PASS/1 штатный skip, analyze/architecture/fixtures GREEN,14 новых Windows PNG показаны выборочно и сравнены без update. Локальные ссылки30/30 валидны,4/4 прежних operation реализаций сохранены. Stage DONE, без коммита/push/сборок.

Ограничение runtime-проверки: DTD видит существующий Edge app; до запроса restart и при повторном чтении ошибок сообщает No runtime errors found. Запрошенный hot restart и инспектор не вернули подтверждения; ожидания прекращены после длительного отсутствия ответа. Поэтому live-обновление/новый flow в текущем браузере не объявляются проверенными. Автоматические тесты/Widgetbook/golden comparison завершились успешно; новый процесс приложения не запускался.
