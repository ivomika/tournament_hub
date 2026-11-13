# Перенос экранов прототипов

49 состояний mobile/desktop переносятся в 25 независимых Stateless screens. Контракт каждого экрана — immutable presentation data и явно переданные callbacks. Экран не вызывает сервисы, не вычисляет турнирные правила, не владеет editable controllers и не выполняет навигацию. Ветвления ограничены отображением переданного состояния и адаптивной компоновкой по runtime теме. Общие composition/layout widgets находятся в DS. Один экран с вариантами — одна атомарная единица и локальный коммит; данные fixtures общие между Widgetbook/golden. Device status/home indicator и галерейные подписи не входят в приложение. Desktop product brand остаётся в шапке.

Прототипный circular/custom progress заменён согласованным Material3 Expressive wave. TextField и Stepper сохраняют ранее согласованную унификацию. QR генерируется по переданным данным. Production routing/controller wiring в этот перенос не входит.

## Покрытие

Дополнение114: реальные profile/edit bindings, редактирование имени и вычисляемые инициалы; statistics/empty CTA профиля временно скрыты. ProfileEdit имеет editing/error/invalid/saving/navigation-error. Mobile/desktop Windows snapshots профиля/editor обновлены; будущие statistics DTO и общий DS metric остаются. [Контракт профиля](../architecture/local-profile-registration.md#редактирование-и-инициалы--задача114).

Дополнение задачи112: новый production screen `registration`, не входивший в исходные25 прототипов. Состояния empty/editing/invalid/saving/error доступны в Widgetbook, есть native mobile/desktop goldens. Bootstrap дополнен preparing-profile/profile-unavailable. Flow и хранение описаны отдельно: [локальный профиль](../architecture/local-profile-registration.md).

Задачи 77–101 завершены: 25 независимых экранов, 50 scoped сценариев, 102 нативных PNG (включая два hover-снимка профиля) для Mobile 390×844 и Desktop 1440×900. Исходные 49 фигур дополнены раскрытыми правилами About. Каждый экран хранится отдельно: `lib/presentation/screens/<screen>/`; данные preview — `lib/presentation/widgetbook/screens/<screen>/`. Все сценарии доступны в папке **Screens** Widgetbook. Настоящие контролы переиспользуются из DS, а не рисуются заменителями.

| Задача | Экран | Сценарии |
|---|---|---|
| 77 | `utility` | distribution, error, loading |
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
| 91 | `distribution` | ready |
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

Goldens получены на macOS. Windows/Linux в этой среде не проверялись. 9 ноября оконную проверку ограничила блокировка Mac; 10 ноября после разблокировки проверка выполнена (уточнение ниже). Production routing, use cases и прикладные controllers намеренно не подключались: это отдельная интеграция, а текущие экраны остаются независимыми. Все коммиты локальные, push не выполнялся.

## Оконная проверка 2026-11-10

В живом Widgetbook найдено переполнение карточки текущего матча при свободном коротком Desktop viewport. Стандартный preset1440×900 его не воспроизводил. Содержимое карточки теперь центрируется при достаточной высоте и прокручивается при недостаточной; presentation-контракт и данные не изменены.

Регрессионный тест800×500 проверяет все четыре формата и достижимость счёта прокруткой. До исправления воспроизводился overflow117px, после — **5 screen tests passed**, существующие8 native PNG не изменились. Повторный actual Widgetbook audit Mobile/Desktop с textScale1.6: **2 passed**. Analyzer clean, architecture533 files passed.

После свежего native build/hot restart визуально подтверждены: отсутствие overflow в коротком Desktop-окне, доступность счёта прокруткой, корректный Mobile390×844. Для выбора нужного окна использована временная копия сборки `TournamentHub Widgetbook Review` с отдельным bundle id; файлы конфигурации приложения не изменялись.

## Исправления по замечаниям 1–10, 2026-11-10

| Пункты | Результат | Коммит |
|---|---|---|
| 1, 6 | Stepper рисуется по естественной ширине/высоте; технические исходы центрированы на двух строках | `7481304` |
| 2 | Фазы working в Distribution больше нет; общий экран доступен как **Screens → Utility → distribution** | `33e38ff`, `2815197` |
| 3 | У выбора формата есть контрастный контейнер на desktop-карточке | `08cf9cf` |
| 4 | Home empty: CTA с внутренними отступами, увеличенный trophy-декор, подпись под hero как в прототипе | `f3b60d1` |
| 5, 9 | Кнопка Bootstrap закреплена у нижнего края desktop-контейнера / mobile content dock | `b17eab3` |
| 7 | Холст карты заполняет viewport; отступы сохранены только у управляющих элементов | `05cad4e` |
| 8 | Hover рисуется внутри Material карточки; mobile плоский, desktop со скруглением; «место» под цифрой. Есть hover goldens | `ae08061` |
| 10 | Загрузка Bootstrap и Utility выровнена слева | `b17eab3`, `2815197` |

Дополнительно оконная проверка выявила короткий Desktop, которого не было в исходной матрице. Добавлен тестовый viewport800×500 для всех экранов. Общий desktop canvas при необходимости прокручивается, минимальная высота содержимого берётся из основной темы и учитывает text scaler. Панели Setup/Settings учитывают крупный текст, панели Roster/History могут расти по содержимому. Обычные эталоны незатронутых экранов остались прежними; каждое исправление экрана сохранено отдельным локальным коммитом.

Финальные проверки:

- Все screens и затронутые DS-компоненты: **63 tests passed**.
- Реальный Widgetbook bootstrap/открытие каждого зарегистрированного use case: **6 passed**.
- Все50 scoped screen-сценариев в Mobile390×844 / Desktop1440×900 / Short Desktop800×500 при textScale1.0 и1.6: **6 matrix tests passed**, 300 сочетаний scenario/viewport/scale.
- Analyzer: без замечаний; architecture-check:533 файла без нарушений; реестр правил согласован; diff-check чистый.
- Нативные изменённые снимки визуально сверены. В живом окне подтверждено mobile-выравнивание Utility; затем Mac снова заблокировался. Финальная сборка запущена как `TournamentHub Widgetbook Final`, выполнен hot restart через `lib/main_widgetbook.dart`; runtime errors не обнаружены. Проверочные копии в /tmp не изменяют production bundle id.

Команда финальной матрицы из `apps/tournament_app`:

```sh
flutter test --no-pub test/widgetbook_viewport_audit_test.dart --dart-define=WIDGETBOOK_AUDIT_FILTER=screens
flutter test --no-pub test/widgetbook_viewport_audit_test.dart --dart-define=WIDGETBOOK_AUDIT_FILTER=screens --dart-define=WIDGETBOOK_AUDIT_TEXT_SCALE=1.6
```

Все изменения закоммичены локально. Push не выполнялся.
