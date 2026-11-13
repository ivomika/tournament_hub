# 114. Редактирование имени профиля и инициалы

## Статус и этап

✅ Завершена · Mode CODE · TestGate REQUIRED: update use case, app/navigation binding, controllers, initials mapping и logging; чистый visual — NOT_REQUIRED.
Stage DONE. Specification1 / plan1 / test set1. RED_CONFIRMED → approval → GREEN → VERIFYING → DONE. [Workflow](../workflow.md).

## Цель и контекст

Существующий сохранённый профиль можно открыть, изменить имя, сохранить и сразу увидеть новое имя/инициалы. Профиль сохраняет ID после редактирования и следующего запуска. Статистика пока не отображается.

После112 есть ProfileName, ProfileId, repository/storage, регистрация, app snapshot и типизированные маршруты. ProfileEditRoute пока показывает unbound экран; ProfileRoute передаёт пустой onEdit и только первый grapheme имени как initials. ProfileScreen уже умеет AppAvatar/statistics/recent, но данные не связаны с реальным controller. Основания: [регистрация](../../docs/architecture/local-profile-registration.md), [навигация](../../docs/architecture/typed-navigation.md), [логирование](../../docs/architecture/logging.md), [presentation](../../docs/architecture/presentation-ui.md).

## Scope и решения

- UpdateProfileNameUseCase изменяет только имя существующего профиля через тот же ProfileRepository. ID сохраняется; use case регистрации не превращается в редактирование.
- ProfileName trim/nonempty сохраняется; дополнительные ограничения длины/алфавита не вводятся. Пробельный ввод не сохраняется. При отсутствии профиля typed failure, а не неявная регистрация/новый ID. Сохранение неизменившегося нормализованного имени не выполняет лишнюю запись.
- Инициалы — presentation projection: первые graphemes первого и последнего слова в верхнем регистре; одно слово — один grapheme. Пробелы/переносы разделяют слова; составные Unicode символы не разрезаются. Это предлагаемый формат отображения, включённый в согласуемый plan1, а не новое бизнес-правило имени.
- Реальные profile/edit bindings получают snapshot/use cases от app, вызывают use cases только из controller, имеют централизованное владение отменяемой работой. App snapshot становится наблюдаемым; повторное открытие, возврат и новая сессия показывают сохранённые данные. Не сериализовать controllers через route extra.
- OpenProfileEditIntent из ProfileRoute; ProfileNameSavedIntent после подтверждения сохранения. Guard/effect проверяют origin/state. Обычный push-flow возвращается в исходный профиль, прямой вход editor имеет безопасный возврат к профилю. Back до сохранения отменяет ввод, не пишет данные. Во время сохранения не запускается второй submit/конкурирующий переход; закрытие владельца подавляет late delivery. Неподтверждённая запись не объявляется rollback.
- Статистика скрывается вместе с заменяющим её empty/нулевым блоком и CTA о первых турнирах. Модель статистики и DS metrics не удаляются. Recent tournament не пересчитывается и не выдумывается; при наличии переданных данных может оставаться отдельным блоком. Точная компоновка проверяется golden после реализации.
- R-010: новый typed ProfileLogger/события и независимый sink в AppLoggers. Критический сценарий обновления имеет общий execution context из генератора идентификаторов (только для диагностики, не замена ProfileId), начало/исход, конкретные причины, исходные error/stack и последствия. Имена и сырой profile payload в лог не попадают. Sink failure не меняет исход сохранения. Генерация diagnostic execution ID не означает создание нового профиля.
- Не входит: статистика/история из БД, аватар-фотография, удаление/синхронизация профиля, серверная авторизация, турнирные flows, массовый аудит логов старого кода, иные UI-экраны.

## Применимые правила

- Все обязательные core из [router](../rules/README.md) прочитаны: R-001 — отдельный update use case; R-002 — docs решений; R-004 — IDs/intents/errors/events; R-007 — test-first gate; R-008.a/b — ясные имена/условия; R-009 — scope/cancellation и честное сохранение; [R-010](../rules/core/010-diagnostic-logging.md) — контекст критических фаз, error/cause/stack и безопасные данные.
- Прочитаны обязательные Flutter rules: R-003.a/b/c — wiring app, ports domain, use cases только из state; R-003.d/e/f/g/h — runtime tokens, package imports, изолированные screens, class-owned methods, intent/guard/effect. R-005 — intl. R-006.a/b/c/d — DS composition/named callbacks, native goldens и shared Widgetbook scenarios.
- Conditional scan: дополнительных conditional rules нет. Правила/архитектурные исключения не меняются; новые пакеты по умолчанию не требуются.

## Acceptance Criteria

- [x] AC1: edit открывает реальный экран с текущим именем; save обновляет имя, сохраняя ProfileId, возвращает к профилю; новая сессия читает то же сохранённое имя/ID.
- [x] AC2: профиль и реальный AppAvatar показывают правильные Unicode-инициалы по выбранному формату и обновляются после save.
- [x] AC3: статистические metrics/пустая статистика не отображаются даже при переданных statistics; модель и компоненты сохранены.
- [x] AC4: пустое имя/нет профиля/ошибка read или write — typed failure без ложного success/потери ID. Ввод не теряется при save error, retry работает. Unchanged name не переписывается.
- [x] AC5: Back без save не пишет данные; double submit выполняет одну запись и один итоговый переход; dispose отменяет ожидания/доставку без позднего UI/navigation и дополнительных операций.
- [x] AC6: typed guard/origin сохраняются; completed save возвращает к ProfileRoute и для прямого editor entry. Навигация/DI не появляются в screen. Профиль без имени по-прежнему защищён регистрацией.
- [x] AC7: logs различают success/rejection/failure/cancellation, сохраняют execution context и доступную причину/stack; нет личных имён, ложного success и поломки операции при LogRejected.
- [x] AC8: Widgetbook состояния profile/edit, mobile/desktop Windows goldens просмотрены/сравнены; relevant regression/analyze/architecture и docs актуальны.

## Test Scenarios и plan

1. Baseline: test/profile_registration, test/app/bootstrap, test/app/navigation, test/presentation/operations, profile/profile_edit screen tests и logging tests. Проверяет сохранённый profile flow, новый DI, nav/lifecycle, прежний рендер и logger contract.
2. До production — executable test set1: реальный update use case с fake external repository/logger, initials mapper на Unicode/пробелах, controller double save/dispose/retry, реальный router/UI profile→edit→profile и fresh session, no-statistics rendering. Подтвердить ожидаемый RED отсутствующих capability, остановиться на human approval.
3. После approval — domain update/typed error + profile logging и app wiring, наблюдаемый profile snapshot, controllers/bindings и intentions/guard/effect. Сохранить registration contracts и обработку отмены/ошибок. Add characterization tests при уточнении реализации, без ослабления утверждённых результатов.
4. Presentation initials mapper, edit state/validation/saving/error, DS composition скрытого statistics блока. Widgetbook/goldens всех затронутых mobile/desktop состояний; код экрана не вызывает use case напрямую.
5. Документировать профиль/edit/initials/logging и navigation policy, выполнить relevant tests, analyze, architecture-check/test, format/links/rules. Native приложение/сборки/commit/push новой задачи без отдельного запроса не запускать.

## Test Evidence

Все Flutter-команды из apps/tournament_app, дата2026-11-12. Baseline на be2242b/94e6b5b, до новых тестов.

| Проверка | Команда | Фактический результат |
| --- | --- | --- |
| Baseline | flutter test --no-pub test/profile_registration test/app/bootstrap test/app/navigation test/presentation/operations test/presentation/screens/profile test/presentation/screens/profile_edit test/infrastructure/logging test/app/logging --reporter compact | exit0,175 PASS |
| Test set1 | flutter test --no-pub test/profile_editing/profile_editing_test.dart --reporter expanded | exit1, ожидаемый compile RED: отсутствуют ProfileLogEvent, UpdateProfileNameUseCase, ProfilePresentationMapper, ProfileEditController, ProfileNameSavedIntent, ProfileFailureReason.notFound, ProfileEditPhase.saving и ProfileEditScreenState.name |
| Format | dart format test/profile_editing/profile_editing_test.dart | exit0,1 файл отформатирован |
| Metadata | node tools/check_rules.cjs; git diff --check | exit0,21 leaf/3 группы согласованы; whitespace чистый |

Test set1 содержит15 зарегистрированных сценариев. Пока compile RED, они не объявляются прошедшими. Проверяются реальные будущие use case/mapper/controller/bootstrap/router/screens; только внешние repository/diagnostic logger/ID generator/navigation sink подменены test fakes. Новая UI-проверка отсутствия stats — поведенческая, не assertion константы. Продуктовых заглушек ради компиляции нет; Dart lib/pubspec и dependencies после коммитов не менялись.

## Approval

2026-11-12 · Пользователь: «делаем». Подтверждение относится к114 specification1/plan1/test set1 после baseline175 GREEN и ожидаемого compile RED. Production разрешён с этой записи.

## Changelog

### 2026-11-12 · Постановка

> делаем коммит и приступаем к задаче работы с профилем. Нужен чтобы его можно было редактировать имя и чтобы в аватаре профиля отображались инициалы профиля. Статистику пока скрываем.

- Завершённые изменения закоммичены отдельно: be2242b (112 registration),94e6b5b (113 logging rule), английский Conventional Commits, без push. Worktree перед новой задачей чист.
- Зарегистрирована114; прочитаны router/core/Flutter/workflow и актуальные profile/edit/routes/session/repository/logger. Экран edit ещё не подключён, полные initials не вычисляются.
- План выбранного формата инициалов сообщён пользователю до тестов; это часть specification1/plan1 и может быть уточнено при approval. Production/новые dependencies не менялись.

## Проверки и итог

### Changelog · 2026-11-12 · Реализация

> делаем

- Approval specification1/plan1/test set1 записан до production. Реализованы UpdateProfileNameUseCase и notFound, отдельные ProfileLogEvent/ProfileLogger/LogScope.profile и profileSink. Use case сохраняет ID, не перезаписывает unchanged name, отказывает при blank/missing profile и сохраняет причины/stack. Diagnostic execution ID генерируется общим портом и не становится ProfileId; retry отражает реальный номер попытки формы. ProfileException.toString и unknown diagnostic wrapper не печатают payload/имена; исходная cause сохраняется.
- AppProfileSession стал Listenable, хранит подтверждённый snapshot; observer-repository использует принадлежащий сессии OperationScope. InitializeProfileStep владеет session.close через resource, Late native reply после закрытия не вызывает notifier. ProfileBinding слушает snapshot; отдельный ProfileEditBinding владеет controller и TextEditingController. Screens не вызывают use cases/SDK navigation.
- ProfileEditController: validation/saving/error/navigation-error/completed, один in-flight save, scope cancellation без bool dispose, ввод сохраняется при ошибке. Добавлены intentions edit/saved и typed previousRoute/profileEditStatus в app guard; Back/direct URI заблокированы во время saving. Обычный возврат — pop в прежний профиль, direct entry — go(ProfileRoute), включая Native Back. Forged completion до записи отклоняется; stale callback после unmount не выполняет save.
- ProfilePresentationMapper использует полные Unicode graphemes первого/последнего слова; исходные15 scenarios подтвердили имя/ID/инициалы после возврата и новой сессии. Статистика и её empty CTA не компонуются в ProfileScreen даже с переданным DTO; модели/DS metrics сохранены, отдельный recent DTO не выдумывается. Desktop identity центрирован существующими theme/layout tokens.
- Добавлены6 регрессий внутри прежнего scope: independent profile sink, cancellation read/late error, Back/URL и forged completion до save, stale save callback, Native Back direct entry, закрытие app-сессии при write. Все21 behavioral scenarios прошли; assertions исходного test set1 не ослаблялись. Механический curly-braces lint в test fake исправлен; отдельного approval это не требует.
- Widgetbook profile fixtures показывают двухбуквенные инициалы; editor дополнен invalid/saving/navigation-error в отдельных папках. Shared fixtures/golden builders: обновлены10 прежних Windows PNG, добавлены6 новых; capture8 scenarios PASS. Просмотрены/показаны390-newcomer,1440-newcomer и390-invalid. Затем полный suite сравнил baselines без update; macOS/Linux PNG не подменены.
- Полный suite после реализации:388 PASS/1 штатный skip внешнего CLI visual comparison. После добавления фактического retry counter и его проверки повторён финальный suite:388 PASS/1 тот же skip; все registered Widgetbook use cases открываются в настоящем workbench. flutter analyze --no-pub: No issues found. Architecture scan670 файлов —0 findings; fixtures navigation32/readability41/top-level49/theme35/self-test51 PASS. Новых checker exceptions/dependencies нет; правила/runtime SDK не менялись.
- Docs обновлены: local-profile-registration, typed-navigation, logging, tokens-manifest, prototype-screens и index. Rules registry21 leaf/3 группы согласован, diff whitespace чистый; ссылки/формат проверяются перед закрытием. Редактор относится к новому scope, новые логирование/инициалы не выдаются за полный аудит старого кода.
- DTD обнаружил только VS Code daemon без подключённых running apps. Hot restart вызван и вернул No active app connection; live-проверка недоступна. Новый app process/сборки/commit/push114 не выполнялись. Code/test/golden verification завершены независимо от отсутствия live debug.

### Changelog · 2026-11-12 · Test-first gate

- Baseline175 PASS до добавления тестов. Подготовлены15 scenarios:7 domain/logging,2 presentation,3 controller/lifecycle,3 реальные router/UI flows. Ошибки read/write сохраняют ID/ввод; sink rejection не меняет успешное сохранение; fake execution identifiers проверяют связь лога без персональных имён и точного сравнения строки оформления.
- Подтверждён compile RED отсутствующего capability, exit1. Каскадный List<dynamic> в Future.wait устранён явным Future<void> у будущих controller.save, без изменения ожиданий; повторный RED соответствует отсутствующим production API.
- Формат и metadata checks прошли. Stage DISCOVERY → SPEC_READY → PLAN_READY → RED_CONFIRMED → AWAITING_APPROVAL. Изменены только карточка/реестр и тесты. Production новой задачи до подтверждения не меняется; новые коммиты114 не выполнялись.

- [x] Критерии/тесты/архитектура/docs подтверждены.
- [x] Golden затронутого UI сформированы/показаны/сравнены.
- [x] Все limitations отражены; unrelated изменений нет.

Итог: AC1–8 выполнены. Имя редактируется с сохранением ID, Unicode-инициалы обновляются в реальном аватаре, статистика скрыта. Контекстное логирование/отмена/защищённые переходы покрыты тестами. Финальный suite388 PASS/1 штатный skip, analyze/architecture/fixtures GREEN;16 Windows snapshots затронутого UI (10 обновлённых/6 новых) просмотрены выборочно и сравнены без update. Format32 файлов —0 изменений;53 локальные ссылки валидны, rules21 leaf/3 группы согласован, whitespace чистый. Без новых dependencies/checker exemptions, сборок/нового app run/коммита/push114. Live hot restart недоступен из-за отсутствия подключённого приложения; работоспособность нового flow проверена реальными Flutter/router/controller тестами и Widgetbook workbench, не нативным запущенным процессом.

### Changelog · 2026-11-13 · Коммит

> закомить diff

- Пользователь разрешил коммит текущих изменений. Реализация114 выделена отдельно от planning-only115; английский Conventional Commits, без push. С последней успешной проверки runtime не менялся; перед коммитом проверяется staged whitespace. Записи о прежнем отсутствии коммита сохранены как история.
