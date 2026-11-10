# 103. Общий focus ring

✅ Завершена · Stage DONE · CODE · TestGate NOT_REQUIRED: только отрисовка UI.

## Цель и критерии

Один painter вместо восьми копий. Все четыре угла, включая эллиптические радиусы, сохраняются; capsule остаётся адаптивной к размеру. Компоненты передают оформление из своих runtime тем. Фокус и callbacks не меняются. Не меняем бизнес-логику, библиотеки или маршруты.

## Правила и план

Core R-001/002/004/007; Flutter R-003.a–g, R-005, R-006.a–d: общий primitive в foundation, typed theme без зависимостей от компонентов, package imports, без Widget helpers. Conditional отсутствуют. Workflow: визуальный scope без gate. Извлечь painter/theme, заменить восемь consumers, проверить геометрию/перерисовку, analyzer/architecture и доступные native goldens. Отсутствующие platform baselines не копировать.

## Changelog

### 2026-11-10

> делаем и мы должны поддерживать полный border radius

- Пользователь разрешил реализацию общего painter с полным BorderRadius. Проверки и итог дополняются после запуска.

## Результат и evidence

- Восемь painters заменены AppFocusRingPainter + AppFocusRingTheme в foundation/borders. Полный BorderRadius с независимыми эллиптическими углами, адаптивная capsule; repaint по оформлению. Решение документировано в docs/architecture/presentation-ui.md. Новые токены/значения не вводились.
- flutter test --no-pub для восьми каталогов компонентов и нового теста:30 PASS; после добавления asymmetric golden новый файл отдельно4 PASS. Геометрия сравнивает все углы, внешние bounds, стиль/толщину/цвет, capsule и repaint. Первоначальное прямое сравнение Color выявило float round-trip Paint; assertion исправлен на ARGB32 без изменения production.
- Нативный update-goldens и повторный comparison без update PASS. Windows baselines впервые созданы отдельно, не скопированы из macOS; это не доказательство отсутствия пиксельной регрессии относительно macOS. Просмотрены field и asymmetric-focus PNG. macOS не запускалась. Отдельный Widgetbook для drawing primitive не добавлен: используется через существующие компоненты.
- flutter analyze --no-pub PASS. Architecture checker536 файлов без нарушений; self-test51, top-level49 и theme35 PASS. Найденные raw BorderRadius.zero в capsule consumers устранены: nullable radius, проверка constructor-инварианта. node tools/check_rules.cjs PASS16 leaf/2 группы. Форматирование выполнено.
- SDK-команды в sandbox зависали/отказывали на telemetry; успешные проверки выполнены с escalation. Pub восстановил локальный cache, tracked pubspec.lock не изменён. DTD подключён к VS Code, но работающих приложений нет: hot reload недоступен, приложение не запускали из-за запрета сборок. Без build/commit/push.

### 2026-11-10 · фиксация

> Сделай коммит изменений по стилю проекта, после чего давай добавим правило и архитектурную проверки
> 1) Запрет сокращенний в написании переменных. Перменная t - это антипатерн, который на уровне проверки должен отклоняться. Разработчик не должен догадываться что означает переменная по сокращению и искать это в коде.
> 2) запрет больших вложенных тернарных операций, если потребывалось сделать больше чем 1 тернарную операцию, это должно быть вынесено в именованный метод который укажит явные условия,
>
> После запусти проверку кода на соответсвия архитектуре и этим новым правилам

- Разрешён коммит результатов103; отдельная цель правил/checker оформляется следующим номером. Последний стиль fix(macos)/docs(screens): выбран refactor(design-system): unify focus ring painters. Новая реализация в103 не добавляется. Без push.
