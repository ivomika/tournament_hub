# Перенос экранов прототипов

49 состояний mobile/desktop переносятся в 25 независимых Stateless screens. Контракт каждого экрана — immutable presentation data и явно переданные callbacks. Экран не вызывает сервисы, не вычисляет турнирные правила, не владеет editable controllers и не выполняет навигацию. Ветвления ограничены отображением переданного состояния и адаптивной компоновкой по runtime теме. Общие composition/layout widgets находятся в DS. Один экран с вариантами — одна атомарная единица и локальный коммит; данные fixtures общие между Widgetbook/golden. Device status/home indicator и галерейные подписи не входят в приложение. Desktop product brand остаётся в шапке.

Прототипный circular/custom progress заменён согласованным Material3 Expressive wave. TextField и Stepper сохраняют ранее согласованную унификацию. QR генерируется по переданным данным. Production routing/controller wiring в этот перенос не входит.

## Покрытие

Задачи 77–101 завершены: 25 независимых экранов, 50 scoped сценариев, 100 нативных PNG для Mobile 390×844 и Desktop 1440×900. Исходные 49 фигур дополнены раскрытыми правилами About. Каждый экран хранится отдельно: `lib/presentation/screens/<screen>/`; данные preview — `lib/presentation/widgetbook/screens/<screen>/`. Все сценарии доступны в папке **Screens** Widgetbook. Настоящие контролы переиспользуются из DS, а не рисуются заменителями.

| Задача | Экран | Сценарии |
|---|---|---|
| 77 | `utility` | error, loading |
| 78 | `bootstrap` | error, loading, retrying |
| 79 | `home` | active, empty |
| 80 | `profile` | newcomer, view |
| 81 | `profile_edit` | editing, error |
| 82 | `settings` | dark_russian |
| 83 | `about` | collapsed, rules |
| 84 | `contact` | unavailable |
| 85 | `history` | empty, list |
| 86 | `setup` | de, rr, se |
| 87 | `roster` | guests |
| 88 | `participant_access` | code |
| 89 | `guest_remove` | confirmation |
| 90 | `guest_add` | name |
| 91 | `distribution` | ready, working |
| 92 | `spectator_access` | distribution, tournament |
| 93 | `tournament` | de, rr, se, tiebreak |
| 94 | `tie` | equal_points |
| 95 | `withdraw` | confirmation |
| 96 | `result_locked` | dependent_match |
| 97 | `bracket` | de, se |
| 98 | `match_result` | correction, ft1, ft10, ft2, ft3, save_error, technical_de, technical_rr |
| 99 | `forfeit` | confirmation |
| 100 | `champion` | winner |
| 101 | `results` | de, rr, se |

## Контракт

- Stateless screen отображает только переданные данные/состояние. Изменения полей, выбора, раскрытий, сохранение и навигация делегируются callbacks. Редактируемые controllers и controller карты принадлежат вызывающему коду.
- Пары, турнирная геометрия, связи узлов, очки, итоговые места и группировка подаются готовыми. Экраны не вычисляют победителей, FT, сортировку или продвижение по сетке.
- Оформление: primitives → основная Flutter theme/extensions → runtime Screen/Widget theme → Widget. В экранных виджетах нет фиксированных TextStyle/Colors.
- У сценариев отдельные keys, поэтому editable state preview не переносится между вариантами. Preview и golden-тесты используют одни fixture builders.
- Карта и строки итогов имеют отдельные scoped DS previews и собственные native goldens. Панорамирование/масштабирование — визуальное взаимодействие с подготовленным графом.

## Проверка 2026-11-09

В `apps/tournament_app`:

```sh
flutter test --no-pub test/presentation/design_system test/presentation/screens test/widgetbook_bootstrap_test.dart
flutter test --no-pub test/widgetbook_viewport_audit_test.dart
flutter test --no-pub test/widgetbook_viewport_audit_test.dart --dart-define=WIDGETBOOK_AUDIT_TEXT_SCALE=1.6
flutter analyze --no-pub
```

Результат: **152 tests passed**; оба полных viewport audit проходят Mobile/Desktop, включая реальную обвязку Widgetbook; analyzer без замечаний. Аудит подтвердил и помог исправить переполнения Bootstrap, Profile, About, History и Setup. Исправления сохранены отдельными коммитами по экрану.

Из корня репозитория:

```sh
make architecture-check architecture-test
node tools/check_rules.cjs
git diff --check
```

Архитектура: **533 файла без нарушений**. Self-tests: architecture 51, class-owned functions 49, theme boundaries 35 passed. Реестр правил согласован. Нативный Widgetbook собран, запущен, выполнен hot restart; runtime errors не обнаружены.

## Визуальная сверка и пределы проверки

Использованы DOM и итоговые CSS обоих прототипов, а также браузерные снимки всех 49 исходных фигур с загруженными Inter/Roboto Condensed (`tools/serve_prototype.py`). Компоновка проверялась визуально относительно нативных PNG: заголовки, карточки, пары, контролы, футеры, таблицы и связи сетки. Это **структурная визуальная сверка**, не заявление о pixel-diff при одинаковом viewport: HTML-галерея содержит рамки устройства и другие внешние размеры, исключённые из приложения.

Goldens получены на macOS. Windows/Linux в этой среде не проверялись. Оконную проверку после последней сборки ограничила блокировка Mac; это не мешало нативным golden-тестам и автоматическому обходу реального Widgetbook. При разблокировке экраны можно открыть в папке Screens. Production routing, use cases и прикладные controllers намеренно не подключались: это отдельная интеграция, а текущие экраны остаются независимыми. Все коммиты локальные, push не выполнялся.
