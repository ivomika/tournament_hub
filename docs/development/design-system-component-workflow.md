# Добавление компонента из UI kit в Flutter DS и Widgetbook

Это рабочая памятка для переноса [UI kit](../design/prototype/ui-kit.html#components) в приложение. Она применяет существующие правила, не заменяет [router](../../ai-context/rules/README.md), [workflow](../../ai-context/workflow.md) и [visual workflow](visual-workflow.md). Статусы и номера задач находятся только в [едином реестре](../../ai-context/task-list.md).

## Проверить существующую реализацию

Сначала проверить `presentation/design_system`, `presentation/widgetbook`, соответствующие tests и [manifest](../design/tokens-manifest.md). Colors, Typography, `AppFoundation`, foundation scenario host и native golden harness уже существуют после задачи36. Их расширяют и сверяют с UI kit; параллельный foundation не создают. Текущий `FoundationLayout` обслуживает showcases и не является полным набором product layout tokens.

UI kit хранит исходные, CSS, восстановленные и предложенные образцы. Перед переносом уточняют статус конкретного состояния и записывают решение о расхождениях. Уже обнаружены разные hover/disabled роли Colors и типографика Score/line-height. Видимость образца в HTML не разрешает молча изменить ранее закреплённый Flutter token.

## Определить одну ответственность

Foundation — именованные primitive и semantic решения. Малый самостоятельный элемент размещается в `design_system/components/<element>/`; подтверждённая переиспользуемая композиция — в `design_system/widgets/<element>/`. Внутри элемента находятся widget и его типизированная тема. Папки создают только при реализации, без пустых заготовок всех будущих компонентов.

Один компонент имеет общий контракт для Desktop/Mobile. Constraints/density/варианты задаются типизированной темой; текст и замена иконки — данные/slots. Имена экранов не становятся вариантами. ListRow не превращается в switch всех экранов, Dialog — в редактор результата, BracketNode — в генератор сетки. Screens собирают DS и собственную layout theme, но эта серия задач экраны не переносит.

Публичные варианты и состояния выражаются enum/sealed/value objects, данные имеют конкретные типы. Primitive токены доступны через именованные const поля, а не enum/string lookup. Пользовательский текст остаётся текстом. DS не импортирует screens, Widgetbook, controllers, app/infrastructure или бизнес-use cases.

## Провести оформление через тему

Каждый цвет, TextStyle, padding/gap, shape/border, shadow/opacity, icon size, motion и responsive параметр прослеживается до component theme и foundation. В widget нет raw literals оформления, включая0, и неописанных Material defaults. Theme использует готовые color-neutral AppTypography TextStyle и semantic AppColors. Изменение значения обновляет manifest и затронутые потребители.

Сначала дополняют нужную тему/токен, затем используют его в widget. В UI нет свободного `copyWith(fontSize:...)` из локального литерала. Общая [Flutter theming-модель](https://docs.flutter.dev/cookbook/design/themes) объясняет переиспользование оформления; проект дополнительно требует собственные типизированные component themes по R-003.d. Пример Flutter с google_fonts не означает разрешение заменить закреплённые bundled fonts проекта.

Продуктовый текст, доступные имена, ошибки и locale formatting проходят через intl. Метаданные навигации Widgetbook — tooling; текст внутри авторского preview также локализуется. Helper, возвращающий Widget, заменяется private widget; callbacks именованы, недоступное действие получает null. Конкретные библиотечные механики не проникают в публичный API компонента.

## Подготовить сценарии Widgetbook

Каждый основной вид и значимое поддерживаемое состояние получает именованный use case в своей папке:

```text
lib/presentation/design_system/<scope>/<element>/
  <element>.dart
  <element>_theme.dart
  golden/<native-os>/
lib/presentation/widgetbook/<scope>/<element>/<use_case>/
  registration / fixture / named builder or preview widget
test/presentation/design_system/<scope>/<element>/
```

Для foundation сохраняется его существующая вложенная структура catalog/palette там, где она уже реализована. Scopes Widgetbook зеркалят foundation/components/widgets/screens; registry агрегирует регистрации, не хранит весь код примеров в одном файле. Основной main и отдельный Widgetbook entrypoint уже настроены; новый entrypoint не нужен.

Use case строит реальный widget с его темой, без копии HTML или независимой картинки. Fixtures/preview contracts/именованные builders общие с golden tests. Нет live DI, сети, БД, текущего времени или бизнес-use cases. Named callback может показать факт действия; он не сохраняет турнир и не подменяет domain правила.

Официальный [Widgetbook use case](https://docs.widgetbook.io/use-cases/overview) представляет конкретное состояние/вариант. [Knobs](https://docs.widgetbook.io/knobs/overview) помогают менять входы для исследования, но в проекте не заменяют фиксированные scenarios и comparison PNG. Не создавать декартов продукт всех props: выбрать основной вид, семантически важные states и реальные content/constraint boundaries. Не переносить annotation/generator из документационного примера автоматически: текущая версия проекта3.25.0 использует ручной registry.

## Проверить визуально и по контракту

Значимые сценарии покрываются executable golden test, не только PNG. Тесты находятся в `test/`, PNG — рядом с визуальным элементом в `golden/<native-os>/`. Чистый token/value object не требует своего PNG; его visual showcase и затронутые потребители сравниваются по R-006.c.

Использовать общие `VisualViewport`390×844 и1440×900, DPR1; дополнительно проверять обоснованные boundary constraints. Viewport capture — тестовый профиль, не размер компонента. Зафиксировать native OS/SDK, bundled Inter/RobotoCondensed, locale/direction/text scale, тему и фазу анимации. Нет Ahem fallback, случайности или сети. [Golden guidance Widgetbook](https://docs.widgetbook.io/glossary/golden-tests) описывает визуальную регрессию; Cloud из этой статьи не подключается, локальный pipeline проекта сохраняется.

Сначала сравнить затронутые baselines, затем намеренно обновить только нужный native set, просмотреть изменения и повторить comparison без `--update-goldens`. Не копировать Windows PNG в macOS/Linux и не использовать чужой набор как fallback. Отсутствующий baseline должен приводить к ошибке. Показать пользователю результат и существенные diffs, записать фактические команды и ограничения проверки.

Для интерактивного контракта по риску проверить keyboard/focus/semantics, доступный и null callback, корректное делегирование и длинные данные. Изменение foundation проверяет всех затронутых потребителей. Проверки: `flutter analyze --no-pub`, targeted `flutter test --no-pub`; при новых Dart-directives/структуре — `make architecture-check` и `make architecture-test`.

## Сохранить границу визуальной задачи

Для pure visual/theme/layout и визуальных взаимодействий TestGate NOT_REQUIRED по текущему workflow; обязательные native goldens остаются. NumberStepper не рассчитывает FT/результат, Table не сортирует RR, QR не создаёт сессию, ShareLink не ходит в Clipboard/service, Dialog не запускает удаление/навигацию приложения.

Если scope расширяется на вычисления, валидацию, state/controller, сохранение, протокол или app routing, сначала пересмотреть specification/TestGate и выполнить REQUIRED процесс для логической части. Постановка задач не является разрешением на такой implementation. Сейчас все новые карточки остаются 🟣; выполнение начинается отдельным запросом.
