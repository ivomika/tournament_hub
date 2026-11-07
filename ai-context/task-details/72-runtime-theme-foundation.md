# Задача72. Runtime FlutterTheme foundation и контроль primitive boundaries

## Статус и этап

✅ Выполнена. Mode CODE. Stage DONE.
Specification:1; plan:1; test set:1, RED_CONFIRMED.
TestGate REQUIRED для AST-checker пройден: RED evidence и явный approval сохранены ниже; visual/theme часть NOT_REQUIRED. Технические regression fixtures расширены в рамках тех же AC, без нового scope.

## Цель и контекст

Перенести исправленную основу UI kit в основную Flutter ThemeData. Все widgets получают оформление через runtime ThemeData/ThemeExtension и собственные WidgetTheme; примитивы не попадают в production widgets напрямую. Текущие AppTypography/AppColors/AppFoundation и существующие catalog themes legacy и могут быть заменены. Новая архитектурная цель самостоятельна относительно palette/typography уточнений задач40–48; существующие foundation scopes переиспользуются.

UI kit уже сохранён отдельным авторизованным коммитом fb0d770; push запрещён. ProgressIndicator приложения штатный Material3, HTML waveform неверен; task66 spec3.

## Scope и non-goals

- Foundation: primitive const → единственный ThemeData builder → ColorScheme/TextTheme/типизированные ThemeExtension → WidgetTheme → Widget.
- Scopes: palette и semantic colors, вся TextTheme, spacing, shapes/borders, elevation, motion/reduced motion, responsive/icon metrics.
- Переиспользовать существующие foundation color/typography catalog consumers; убрать их прямые обращения к constants и const AppFoundation.dark().
- Проверка production lib: imports/exports/part boundaries и AST-использование Flutter Color/TextStyle/Colors из литералов/констант вне primitive/theme assembly. ComponentTheme также не импортирует primitive; только runtime Flutter theme.
- Точечные исключения: primitive definitions и ThemeData assembly; tests — fixtures; единственный tooling primitive-scales use case демонстрирует токены как данные, а не стиль UI. Не исключать весь Widgetbook или весь foundation.
- Не переносить UI components/screens/tasks49–71. Не добавлять app settings/state/theme persistence/light theme. Другой primitive-файл не заменяет ThemeExtension.

## Применимые правила

Core R-001/002/004/007; Flutter R-003.a–f, R-005, R-006.a–d прочитаны. R-003.d уточняется по прямому требованию пользователя. R-003.e требует architecture-check/self-tests. Других conditional rules нет. Canonical workflow: checker logic REQUIRED, tokens/layout themes NOT_REQUIRED; golden coverage изменённых consumers сохраняется. Maintenance rules прочитаны, leaf ID R-003.d сохраняется.

## Уточнения и решения

- UI kit commit fb0d770 создан до Flutter изменений.
- Primitive константы разрешены только как источник сборки основной темы. WidgetTheme строится из текущей Theme.of(context), не из primitive/factory с фиксированной dark theme.
- Стандартные ThemeData.ColorScheme/TextTheme используются в первую очередь; нестандартные шкалы хранятся в ThemeExtension с copyWith/lerp, а не статическом registry.
- Flutter widgets сохраняют const constructors, если возможно; запрет относится к источнику оформления.
- Имена будущих widget classes/API определяются минимальной необходимостью; tests используют существующие публичные catalog builders и inspect API checker.

## Acceptance Criteria

- [x] AC72.1 Foundation значения UI kit доступны через ThemeData/typed ThemeExtensions, primitive paths изолированы.
- [x] AC72.2 Реальные foundation consumers реагируют на ColorScheme/TextTheme/extension changes; нет static dark theme внутри компонента.
- [x] AC72.3 Production Widget и WidgetTheme не импортируют primitive/legacy AppTypography/AppColors constants; raw Color/TextStyle/Colors оформления запрещены.
- [x] AC72.4 AST guard ловит прямые/aliased/re-export обходы, constructor/style constants; comments/strings/const widget constructors не дают false positives.
- [x] AC72.5 Guard подключён к существующему architecture-check/test и документирован; реальные lib чисты.
- [x] AC72.6 targeted tests/analyzer/native goldens/architecture checks выполнены; screenshots сравнения и ограничения записаны.

## Ошибки и крайние случаи

Theme replacement должен менять уже отрисованный consumer, без сброса key/state. Проверить ColorScheme override, TextTheme font/style override и runtime ThemeExtension override. Color/style пользовательские данные не считаются primitive import. Re-export и alias не должны обходить guard; тексты/комментарии с примерами не являются Dart expressions. Missing required ThemeExtension — явная ошибка assembly, без скрытого возврата к const dark defaults.

## Test Scenarios

| ID | Критерии | Проверка |
| --- | --- | --- |
| TS72.1 | AC72.2 | Реальный TypographyCatalog обновляет sample после замены ThemeData.textTheme и colorScheme |
| TS72.2 | AC72.2 | Реальный ColorPalette обновляет background после замены ThemeData |
| TS72.3 | AC72.3/4 | Dart checker fixtures: прямой import, alias, export-chain, WidgetTheme import, raw Colors/TextStyle/Color |
| TS72.4 | AC72.4 | Accepted pipeline, framework theme access, comments/strings, const Widget, tests/primitive/builder |
| TS72.5 | AC72.1/2 | После реализации: runtime extensions copyWith/lerp и real consumers, без static defaults |
| TS72.6 | AC72.5/6 | Existing architecture regression/self-tests + changed foundation render/goldens |

## Implementation plan

1. Зафиксировать правило/долговременное решение; baseline architecture49 cases.
2. Добавить независимые executable fixtures guard и consumer theme propagation tests. Подтвердить RED. До production checker пройти AWAITING_APPROVAL по canonical workflow.
3. После approval изолировать primitive definitions; собрать ThemeData и необходимые runtime extensions; заменить legacy fixed-theme catalogs.
4. Реализовать AST guard в существующем checker и подключить tests к Make; без regex-only анализа Dart source.
5. Native golden update только затронутых consumers, просмотр/повтор comparison; tests/analyze/architecture, docs/task status.

## Test Evidence до implementation и Approval

- Baseline: existing `dart run bin/check_flutter_architecture.dart --self-test` вне sandbox — PASS49. В sandbox Dart VM падает до запуска в cpuinfo_macos.cc:42; это environment, не RED.
- Baseline Flutter: `flutter test --no-pub test/presentation/foundation_preview_test.dart --name 'render and scroll'` — PASS6 (Mobile/Desktop colors/scales/typography), production код неизменён.
- `dart run test/theme_boundaries_test.dart` (cwd tools/domain-check, вне sandbox) — exit1, ожидаемый RED:12/18 сценариев отвергнуты тестами, т.к. текущий checker возвращает [] и пропускает direct primitive/alias/re-export/part library, Color/TextStyle/Colors в production.6 разрешённых случаев проходят; синтаксических/runner ошибок нет.
- `flutter test --no-pub test/presentation/design_system/foundation/theme_propagation_test.dart` — exit1, ожидаемый RED2: реальный TypographyCatalog остаётся font18 вместо новой ThemeData font31; ColorPalette остаётся legacy background вместо нового scaffoldBackgroundColor.
- Новые тесты отформатированы; `node tools/check_rules.cjs` / `git diff --check` PASS. Native golden не обновлялись, т.к. runtime UI не изменён.
- Тесты вызывают существующие inspect API/реальные catalog builders, production API/заглушки/реализация не добавлялись ради RED.
- RED_CONFIRMED → AWAITING_APPROVAL. Gate approval ещё не получен. По workflow новая проверка checker требует отдельной явной реплики после evidence; production Flutter/checker implementation ожидает её.

## Changelog

### Итерация1 —7 ноября2026

Prompt пользователя (дословно):

> еще одно уточнение. ProgressIndicator в html не верный и кастомный. А в приложении должен использоваться material3 прогресс индикатор.
Второе давай закомитим изменения ui kit и перенесем foundation в flutter проект. Главное условие переноса foundation, будущие виджеты не должны использовать константы, а должны использовать стандартную тему или свою тему. Использовать в виджетах заготовленные константы тупиковая ветвь. Все должно реагировать на изменения основной темы. Поэтому флоу такой: promitive const -> FlutterTheme -> WidgetTheme -> Widget. я запрещаю использовать константные TextStyle или Colors внутри итоговых виджетах (Text( style: const bodySmall)). Это решение необходимо занести в тему и необходимо добавить проверку чтобы примитивы не попадали в production код

Постановка и уточнение R-003.d следуют прямой авторизации пользователя. Production Flutter/checker пока не изменены. UI kit зафиксирован ранее в fb0d770. Добавлены2 теста реальных theme consumers и18 fixture-сценариев архитектурной границы, запуски подтвердили ожидаемый RED. R-003.d и связанные canonical docs уточнены; новые правила checker/Flutter runtime ещё не реализованы.

## Final Verification

- [x] Runtime theme pipeline, guard и consumer tests GREEN.
- [x] Docs/goldens/architecture checks подтверждены.

## Итог

Runtime foundation перенесён в ThemeData/10 typed ThemeExtension. Каталоги и Widgetbook use cases читают текущую тему; direct primitives/raw styling закрыты AST guard. Единый исполняемый скрипт проверяет границы и runtime propagation. UI kit сохранён в fb0d770; итоговый foundation-коммит создаётся после final verification, без push.


### Approval и продолжение,7 ноября2026

Prompt пользователя (дословно):

> продолжи к реализации и после закрепи сриптом и checker`ом чтобы в дальнейшем не проникал запрет примитивов в код и тестом можно было найти нарушение контракта, а не только просмотром кода

Пользователь явно одобрил implementation после RED evidence task72 spec1/plan1/test set1. Реализуются runtime theme pipeline и AST guard с интеграцией Make/скрипта, регрессиями обходов и runtime propagation. Stage IMPLEMENTING.

### Завершение реализации —7 ноября2026

Продолжение prompt пользователя (дословно):

> продолжи

Реализованы runtime ThemeData/10 ThemeExtension, миграция реальных catalogs/WidgetThemes, AST guard и единый Python runner/Make targets. Тестовый набор технически расширен с18 до35 fixtures (те же утверждённые критерии): named constructors, typedef, transitive exports, parts, inline/const/final scalar styles, literal extension overrides и разрешённый runtime lerp. Реальные consumer tests расширены до5: extensions replacement, interpolation всех extensions, missing-extension error. Первый extension override с width250 создавал overflow из-за тестового ограничения; ширина изменена на350 при сохранении проверки runtime replacement.

После успешной проверки непосредственных consumers тесты проведены через полные Widgetbook use cases. Это воспроизвело скрытый fixed-theme fallback preview host: padding оставался24 вместо37, background/типографика не обновлялись. Fixture finder уточнён для вложенного Scaffold; semantic RED подтверждён повторно. Host переведён на Theme.of(context), golden harness явно задаёт AppTheme.dark; tooling больше не исключён из запрета factory imports. Это устранение обхода в исходном scope, не новое поведение.

Штатный gen-l10n повторно создаёт relative sibling imports и не имеет package-import опции. R-003.e уточнён для ровно двух foundation generated файлов и только import; checker нормализует и проверяет цель. Добавлены positive/negative self-tests (51 всего); остальные generated файлы и директивы не исключаются.

Скрипт проверен на реальном временном production probe: raw TextStyle дал exit1 и `theme_contract_violation_probe.dart:2 R-003.d`; finally удалил fixture. Первый запуск Widgetbook отклонён автоматической проверкой разрешений из-за service usage limit; после явного «продолжи» повторный штатный запуск успешен, DTD hot restart выполнен. Никакого обхода approval не использовалось.

## Итоговые проверки —7 ноября2026

- `python3 tools/check_theme_contract.py` из корня — PASS: architecture51, theme fixtures35, реальные lib/test43, Flutter propagation5. Последний прогон включает полные Widgetbook wrappers без fixed dark fallback.
- Negative production integration: временный raw TextStyle в lib → script exit1 и точный finding R-003.d. Probe удалён в finally; clean production повторно проверяется architecture-test.
- `flutter analyze --no-pub` в apps/tournament_app — PASS, no issues. `dart analyze lib/theme_boundaries.dart test/theme_boundaries_test.dart bin/check_flutter_architecture.dart` в tools/domain-check — PASS, no issues (единственный unnecessary ! исправлен).
- `flutter test --no-pub --update-goldens test/presentation/foundation_preview_test.dart` — PASS14; созданы18 native macOS PNG для top/middle/bottom mobile390×844/desktop1440×900 трёх catalogs. Просмотрены palette mobile top/desktop middle, typography mobile bottom/desktop top; overflow не найден, локальные TTF/новые роли видны. После уточнения typographyDescription обновление повторено. Windows PNG не изменялись.
- Повтор без update: `flutter test --no-pub test/presentation/foundation_preview_test.dart test/widgetbook_bootstrap_test.dart test/presentation/golden_environment_test.dart test/presentation/design_system/foundation/theme_propagation_test.dart` — PASS25, включая нативное golden comparison и проверку запрета cross-platform baselines.
- `flutter run -d macos -t lib/main_widgetbook.dart --no-pub` — debug build/run успешен; DTD hot restart успешен после финальных Flutter правок. Автоматическое foreground окна не сработало; запуск и restart подтверждены VM/DTD, визуальная проверка сделана по native goldens.
- `node tools/check_rules.cjs` — PASS15 leaf/2 группы; `git diff --check` — PASS; Python runner компилируется.

Ограничения: checker — parse-only AST/import graph для известных конструкций, не полный interprocedural data-flow анализ произвольного Dart или внешних packages. Windows/Linux native comparison в этой сессии не запускался; macOS набор не заменяет эти baselines. Продуктовые компоненты49–71 не реализовывались. Существующий Hello World сохранён, только wiring/локализация перенесены в app/presentation для подключения основной темы.

- Обязательный `make architecture-test` — PASS:51 architecture,35 theme fixtures и43 реальных файлов без findings. После hot restart DTD runtime errors отсутствуют. Все AC72.1–72.6 подтверждены; Stage DONE.
