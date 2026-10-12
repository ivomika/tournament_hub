# Задача 36. Foundation: цвета и типографика

## Статус и этап

✅ Завершена

- Mode: CODE.
- TestGate: NOT_REQUIRED — визуальные foundation tokens/themes и showcase, без бизнес-логики. Mandatory golden по R-006.c сохраняется.
- Stage: DONE.
- Versions: specification/plan 3 — const-примитивы, готовые TextStyle и расширенные шкалы.

## Цель и scope

Выбрать шрифты и базовую семантическую палитру приложения; реализовать foundation в presentation/design_system, типизированную общую тему и scoped Widgetbook-сценарии текстов/цветов. Документировать токены и происхождение font assets/лицензий. Shared fixtures и PNG текущей ОС в отдельных platform folders.

Без продуктовых screens, бизнес-поведения, нового MVP/roadmap и изменения правил турнира. Новые используемые visual параметры принадлежат темам; не резервировать коллекции будущих компонентов.

## Применимые правила

- R-001/R-002 — единые tokens и документирование выбора без копий значений в widgets.
- R-004 — типизированные роли цвета/текста; R-007 — visual checks без логического gate.
- R-003.a/b/c/e/f — presentation-only UI, package imports; никакого DI/use cases в showcase.
- R-003.d — foundation scopes, темы и все visual параметры из токенов.
- R-005 — intl для авторских UI-примеров/semantics.
- R-006.a/b — компоненты вместо Widget helpers, named callbacks/builders.
- R-006.c/d — общий scenario в Widgetbook/golden, PNG рядом в golden/<native-os>, fonts/render profiles, scope каждого use case.
- Conditional rules отсутствуют.

## Уточнения

- Выбор пользователя: графит + тёплое золото; Inter для интерфейса + Roboto Condensed для крупных заголовков; только тёмная базовая схема.
- Visual foundation не получает логического gate; palette/typography/showcases и generation resources реализуются в согласованном scope. Golden обязательны, нативно на Windows; платформы не смешиваются по новому решению пользователя.

## Критерии и план

- [x] Выбор пользователя сохранён; палитра/типографика и token manifest документированы.
- [x] Font assets с кириллицей и лицензиями подключены локально, без runtime network.
- [x] Цвета/typography представлены foundation-сценариями Widgetbook; каждый showcase использует свою theme.
- [x] Сценарии общие с нативными golden, PNG рядом по платформам; contrast/overflow/fonts и tests/analyzer/architecture проверены.

План v2: сохранить согласованные foundation/fonts/showcases; заменить Linux guard проверкой native platform path, обновить правила/docs, сгенерировать Windows PNG и повторить comparison без update; показать результат. Не менять Docker/system settings; Linux job остановлен по просьбе пользователя.

## Discovery

- Каталог пока пуст, у foundation есть только README. Канонические docs: architecture/presentation-ui.md и development/visual-workflow.md.
- Первичные источники font-кандидатов: https://rsms.me/inter/ ; https://github.com/google/fonts/blob/main/ofl/robotocondensed/METADATA.pb ; https://github.com/google/fonts/blob/main/ofl/manrope/METADATA.pb . Поддержка кириллицы/лицензия проверяются для фактически выбранного asset, не только по названию семейства.
- В среде доступны wsl.exe и docker.exe; WSL сообщает docker-desktop, Docker context — desktop-linux. Доступность engine/образа и Linux Flutter пока не подтверждена. Пакеты/образы/шрифты не скачивались.

## Changelog

### Итерация 1

**Prompt пользователя**

> Так давай первую задачу по дизайну. Выберем шрифты для приложение и цветовую схему. Это будем базовая цветовая схема приложения. Нужен так же widgetbook сценарии foundation для текстов и цветов

**Изменения и проверки**

- Прочитаны context/rules и текущий пустой foundation/catalog; проверены первичные font-источники и наличие локального Linux-контекста. Зарегистрирована задача, выбор дизайна ещё не утверждён; runtime UI не менялся.

## Итог

Foundation выполнен: графит/золото, Inter/Roboto Condensed, типизированные роли и темы, два scoped Widgetbook-сценария, ru intl/ARB и 10 Windows PNG. Generate и повторное compare успешны; 16 tests без skips, analyzer clean, 49 architecture cases прошли. Native golden-процесс закреплён в правилах/docs, Linux/macOS verification не заявляется. Коммит и build приложения не выполнялись.

## Проверки и среда

- 2026-10-12: Windows x64 (NT 10.0.26200), Flutter 3.47.1 / Dart 3.13.1. Local asset SHA и revisions в docs/design/foundation.md; OFL рядом с TTF.
- Linux fc-query реальных TTF подтвердил glyph ranges русского алфавита/Ё/ё; FontLoader загружает assets до screenshot, не Ahem.
- Нативный update: `flutter test --no-pub --update-goldens test/presentation/foundation_preview_test.dart` из apps/tournament_app — 10 tests passed, создано 10 PNG в golden/windows.
- Затем `flutter test --no-pub` — 16 passed, без skips; включает contrast >=4.5:1, families/tabular score, render/scroll обоих viewport, native PNG comparison, isolation guard и launcher.
- `flutter analyze --no-pub` — No issues found. Два doc-comment info по angle brackets исправлены; это не visual diff.
- `make architecture-test DART=C:/Users/ivomika/Documents/workspace/sdk/flutter/bin/cache/dart-sdk/bin/dart.exe` — 49 self-tests passed, 23 Dart-файла без import violations. Правила — 15 leaf/2 группы; Markdown links — 85 файлов; diff-check прошёл.
- Просмотрены Windows palette desktop и typography mobile top/bottom: читаемая кириллица, ожидаемые семейства/размеры, без overflow/tofu. Скролл/capture проверяют также middle.
- DTD подключён, активных apps нет; hot restart недоступен. Новый app run/build не запускался; каталог/рендер проверены через настоящие entrypoint/builders и golden.
- Docker контейнер tournament-hub-golden-36 остановлен по запросу; другие containers/volumes не менялись. Выделенный SDK-cache volume и временный stopped container сохранены, не удалены. Linux/macOS PNG не импортированы в Windows набор.

## Changelog — продолжение

### Итерация 4 — const foundation

**Prompts пользователя (дословно)**

> я смотрю на foundation и складывается два оущения. как будто примитивы должны быть константами, а не enum и его сопастовлением. Шрифты хочется видеть уже готовыми текст стайлом. и цветов как будто мало, а точнее их вариаций

> меняем

**Решение и plan v3**

- Сохранить выбранную тёмную схему и font assets; разделить const primitive color scales, именованные semantic ссылки и готовые color-neutral TextStyle. Удалить AppColorRole/AppTextRole и forRole, без замены строковым lookup.
- Дополнить semantic состояния акцента/границ и container/onContainer для статусов. Widgetbook отдельно показывает scales и semantics; typography использует реальные готовые стили.
- Обновить manifest, component themes, fixtures/tests и Windows PNG; compare без update, contrast/overflow/analyzer/architecture. Это UI scope без TestGate; исходная задача переоткрыта, новый номер не создаётся.

**Изменения и проверки v3**

- ColorPrimitives: 66 static const цветов в 6 шкалах 50–950. AppColors.dark — 29 именованных semantic ссылок, включая hover/pressed/focus, disabled и container/onContainer; enum/forRole удалены, строкового lookup нет.
- AppTypography содержит восемь готовых static const TextStyle без цвета; темы назначают цвет. Материальная тема и preview-data используют прямые именованные значения, без enum-сопоставлений.
- Добавлен отдельный Primitive scales use case. Представление палитры переиспользовано с immutable preview records; семантические подписи локализованы через ARB, primitive labels — технические имена токенов.
- Первая проверка расширенных подписей выявила overflow 19 px. Токен colorTileHeight изменён 112 → 136; assertion не ослаблялся. Повторный update — 14 tests passed; `flutter test --no-pub` — 20 passed, без skips. Теперь 18 Windows PNG для трёх сценариев/двух viewport.
- Contrast >=4.5:1 проверен для original текстов/поверхностей, accent hover/pressed и всех container/onContainer пар. Цвет стилей проверяется как null до применения component theme.
- Analyzer — No issues found; architecture self-tests — 49 passed, 25 Dart-файлов без import violations. Rules checker — 15 leaf/2 группы, links — 85 файлов, diff-check успешен. В коде нет AppColorRole/AppTextRole/forRole.
- Просмотрены новые primitive scales desktop и semantic mobile bottom PNG: подписи и значения читаемы, длинный текст помещается. Foundation/docs/manifest/R-003.d синхронизированы.
- Активный Widgetbook Edge найден через DTD. Hot restart запрошен, но подтверждения не вернул; ожидание прекращено, runtime-success не заявляется. Golden/render проверки выполнены независимо. При необходимости пользователь перезапускает текущий VS Code профиль.
- Stage IMPLEMENTING → VERIFYING → DONE. Build/commit/push не выполнялись.

**Текущий итог v3**

Foundation исправлен по запросу: const primitives → semantic palette → component theme, плюс готовые color-neutral TextStyle. Отдельные Widgetbook scales/semantics/typography и Windows baselines обновлены; проверки прошли. История v1/v2 ниже сохранена, не описывает текущий API.

### Итерация 2 — выбор и реализация

**Ответы пользователя (дословно)**

- Палитра: «Графит + тёплое золото — сдержанный турнирный стиль».
- Шрифты: «Inter для интерфейса + Roboto Condensed для крупных заголовков».
- Схемы: «Только тёмную базовую схему».
- Docker: «Я восстановлю Docker Desktop, затем продолжим golden».

**Prompt пользователя**

> я востановил engine

**Изменения и проверки**

- Добавлены семантические colors/text roles, общий foundation и две component themes; оформление widgets исходит из тем, подписи из ARB/generated intl API. Generator imports нормализованы в package URI без исключений checker.
- Bundled TTF/OFL получены из закреплённых Google Fonts revisions, подключены без runtime network. Добавлены showcase builders и scoped registry; tests используют те же сценарии.
- Первоначальный Windows suite — 11 passed/4 Linux golden skips; Docker startup был заблокирован ошибкой dockerInference. После восстановления engine использован отдельный read-only source mount и закреплённая Ubuntu-основа; скачивание официального Linux SDK отменено/прогон остановлен по новому решению ниже. Linux успех не объявляется.

### Итерация 3 — нативные platform-specific golden

**Prompt пользователя**

> блин может для скорости будм билдить проект на том окружении на котором он запущен?

**Ответ пользователя (дословно)**

> Да, нативно на текущей ОС с отдельными эталонами по платформам

**Изменения и проверки**

- Spec/plan v2: обязательный Linux-only процесс заменён нативным. Решение меняет среду проверки, не палитру/шрифты; отдельный логический TestGate не требуется.
- Установлена схема golden/<native-os> и guard compare/update для текущей ОС. Нет fallback другой платформы и silent skip отсутствующего baseline; обычный comparison не пишет PNG.
- R-006.c/router/workflow, docs visual workflow/testing/foundation и test README обновлены; исторические карточки прошлых решений не переписаны.
- Созданы/просмотрены Windows goldens и выполнен обычный comparison. Все evidence выше; Stage IMPLEMENTING → VERIFYING → DONE. При подключении другой ОС её PNG создаются и проверяются отдельно, Windows набор не копируется.
