# 115. Создание турнира и его настройки

## Статус и этап

🟣 Запланирована · Mode PLANNING_ONLY · Stage PLAN_READY.
Specification1 / plan1. Текущая работа — постановка/документация, TestGate NOT_REQUIRED. Будущая реализация domain/storage/controller/navigation требует CODE/TestGate REQUIRED и отдельного test-first approval по [workflow](../workflow.md).

## Цель и основания

Создать один локально сохраняемый незапущенный турнир, настроить формат/FT, увидеть его на главной и повторно открыть настройки. Без участников, старта, распределения, сетки, раундов и сетевых подключений.

Источник турнирных правил — [MK11 rules](../../docs/source/mk11_tournament_rules_ru.md), текущая документация — [назначение](../../docs/product/overview.md), [архитектура](../../docs/architecture/layer-boundaries.md). Согласованные решения и предложения реализации: [создание и настройки](../../docs/architecture/tournament-configuration.md).

Исследован актуальный код: domain/tournament содержит только TournamentId; SetupScreen и DE/SE/RR Widgetbook fixtures уже есть, но это presentation без реальных controller/repository/settings use cases. SetupRoute не подключён к реальному состоянию, Home.onCreate отключён. Исторические старые дизайн-документы в текущем docs/source отсутствуют; имеющийся business source не заменяется памятью об удалённых документах.

## Scope и non-goals

- Создание, локальное сохранение, загрузка после перезапуска и изменение названия/формата/FT одного настраиваемого турнира. Существующий ID сохраняется при редактировании; новый создаётся общим IdentifierGenerator/UUID adapter.
- Настройки из source: DE по умолчанию, SE/RR доступны; DE/SE основной FT1, финал наследует основной FT или явно переопределён; Reset DE всегда включён и использует FT Grand Final; RR всегда FT2 без изменяемого FT.
- При сохранении показываем на главной карточку незапущенного турнира и возможность открыть настройки. Участники не нужны для создания: проверка минимума2 относится к будущему start, не к пустому configuration draft.
- Не входят: участники и список/лимиты состава, host-as-player, подключения/QR/room/server, spectator, Local Group/Participant mode, персонажи/раздача, генерация встреч/матрицы/сетки, очки/результаты/чемпион, запуск, удаление турнира, архив/каталог нескольких турниров, выбор/смена ruleset через UI.
- Не создаём пустые domain/infrastructure папки будущих механизмов и не подключаем действия к фиктивным данным.

## Уточнения пользователя

| Дата | Вопрос | Ответ | Решение |
| --- | --- | --- | --- |
| 2026-11-13 | Число сохранённых настраиваемых турниров | Один настраиваемый турнир (Рекомендуется) | Один configuration draft; второй не перезаписывает первый |
| 2026-11-13 | Итог создания/редактирования | Кнопка «Создать/Сохранить» → главная с карточкой турнира (Рекомендуется) | Явная запись, переход только после подтверждения |
| 2026-11-13 | Допустимый FT DE/SE | Любое целое от 1, без продуктового верхнего ограничения (Рекомендуется) | Не вводить искусственный max3/max5/max9; не допускать потери точности/переполнения |
| 2026-11-13 | Back с изменёнными настройками | Подтверждать выход без сохранения (Рекомендуется) | Подтверждение отказа от изменений, без автосохранения |

Последний пределFT — именно ответ пользователя. Source явно задаёт стандарт FT1 и примеры FT1/FT2/FT3, но не отдельный продуктовый max. Ограничение одного draft не утверждает правила количества любых будущих запущенных/завершённых турниров.

## Предлагаемый контракт реализации

- Минимальная immutable сущность TournamentDraft: TournamentId, типизированное название и настройки; ссылка на применяемый ruleset фиксирована, не является полем формы. Не добавлять roster/matches/results пустыми коллекциями ради будущего.
- DE/SE разделяют конфигурацию FT; RR — вариант без изменяемого FT. Наследование финального FT хранится как намерение, а не как однажды скопированное число. UI projection не определяет бизнес-правила.
- Небольшой domain-интерфейс правил конфигурации задаёт defaults/validation, реализация соответствует источнику MK11. Это не полный tournament engine и не плагинная система всех будущих правил. Смена ruleset/version для уже созданного draft не входит; неизвестная persisted version даёт typed failure, не silent upgrade.
- Один repository/port — источник сохранённого draft; минимальные use cases загрузки/создания/обновления. Create должен отказать при занятом слоте, update сохраняет ID. Atomicity/idempotency контракта проверяется тестами, не заменяется блокировкой одной кнопки. Конкретный persistent adapter выбирается перед кодом по этим гарантиям; наличие SharedPreferencesAsync в проекте не доказывает атомарность/долговечность будущей записи турнира.
- Предлагается требовать непустое название после trim, без произвольных ограничений длины/алфавита; это предложение plan1, не отдельное подтверждённое business rule. Первичная форма без сохранения не становится persisted draft. Изменения в уже открытой форме живут в presentation buffer до Save.
- Экран использует существующий SetupScreen/DS: название, DE/SE/RR, FT steppers; наследование/отдельный финал обозначено явно. RR показывает FT2 read-only, без регулирующих FT-кнопок. Предлагается удерживать общие DE/SE поля в рабочем буфере при переключениях, но не сериализовать неактуальные elimination поля в RR. Детальная визуальная компоновка — при реализации/golden.
- После явного save навигация через intent → guard → effect возвращает на главную. Draft-карточка открывает настройки, а не roster/tournament-live. Dirty Back подтверждается общим modal adapter; чистый Back не показывает лишнего вопроса. В confirmation есть «Остаться»/«Выйти без сохранения», отмена/Back самого modal оставляет форму. Во время save конкурирующий уход блокируется; lifecycle close отменяет delivery по scope.
- Ошибка read/schema/version не трактуется как «нет турнира»; ошибка save сохраняет ввод, не даёт ложного success. Retry/double submit не создают второй турнир/новый ID и не заменяют другую сохранённую запись. Cancelled native write не объявляется rollback; следующий read определяет фактический слот.
- R-010: typed tournament/configuration события, execution context, шаги load/validation/create/update, причина/исход/retry/cancellation/cleanup. Не печатать сырые названия/полный payload. Сбой sink не ломает сохранение.

## Применимые правила

- Прочитаны обязательные core из [router](../rules/README.md): R-001 — малый scope и отдельные ответственности; R-002 — канонические решения в docs; R-004 — типизированные IDs/settings/formats/results; R-007 — planning проверяется структурно, CODE требует test-first gate; R-008.a/b — ясные имена/условия; R-009 — отмена/ownership; R-010 — конкретные логи критических фаз.
- Прочитаны Flutter R-003.a–h: domain независим, use cases только из controllers, library adapters infrastructure/app wiring, runtime DS themes, package imports, deterministic screens, class methods и typed intention/guard/effect. R-005 — intl; R-006.a–d — DS/named callbacks/native goldens/scoped Widgetbook.
- Conditional scan: других conditional rules нет. Существующие незакоммиченные114 изменения сохраняются; в этой задаче implementation не меняется. Новые rules/architecture exemptions не предлагаются.

## Acceptance Criteria будущего CODE

- [ ] AC1: Create открывает настройки без persisted турнира; сохранение создаёт один draft с UUID и возвращает на главную с его карточкой. Повторный запуск восстанавливает данные.
- [ ] AC2: карточка открывает существующий draft; Save меняет настройки/название без смены ID. Второй Create не перезаписывает существующий турнир.
- [ ] AC3: DE/SE/RR и FT соответствуют source/подтверждённым ответам; наследование финала не теряется, RR остаётся FT2, Reset DE не выключается; продуктового max FT нет.
- [ ] AC4: создание не требует участников и не запускает ни один механизм участников/сетки/спектатора/подключений.
- [ ] AC5: dirty Back требует подтверждения, stay/dismiss сохраняет форму, discard не пишет изменения; clean Back без лишнего confirmation; save блокирует competing exit.
- [ ] AC6: read/invalid settings/schema/version/write failures типизированы; ввод/сохранённые данные не теряются. Retry/concurrent create/double save/cancellation/late completion не создают дубликат и не дают ложный success/rollback.
- [ ] AC7: boundaries/типизация/intl/themes/logging/DI и intent pipeline соблюдены, current profile flow не ломается.
- [ ] AC8: Widgetbook DE/SE/RR/create/edit/error/saving/discard и карточка главной имеют общие fixtures и native mobile/desktop goldens; релевантные tests/analyze/architecture/docs актуальны.

## Декомпозиция реализации

1. Перевести задачу в CODE/🚧 по отдельному запросу; оформить executable tests по AC, baseline profile/navigation/operations/setup/home; подтвердить RED и пройти human gate до production.
2. Domain draft/settings/value objects + минимальная policy defaults/validation, reuse TournamentId/общего генератора, repository contract. Tests на min/defaults/inherit/override/RR и большие FT.
3. Persistent adapter/codec: один слот, versioned запись, create conflict/update identity, retry/cancellation и конкуренция. Зафиксировать реальные гарантии выбранного storage; packages изолировать при необходимости.
4. Use cases load/create/update, controller/bindings и typed routes/intents. Draft на Home, восстановление после перезапуска; никаких переходов в неподключённые roster/live.
5. Setup UI в режимах create/edit, inherited/custom final, read-only RR; подтверждение dirty exit через существующий modal mechanism, named callbacks/темы/intl.
6. Контекстное логирование, Widgetbook/native goldens, regression/analyze/architecture/format/links и документы. Без build/run/commit/push без соответствующего запроса.

## Test Scenarios

| Группа | Сценарии | AC |
| --- | --- | --- |
| Правила | DE defaultFT1; SE final inheritance/override; DE Reset follows final; RR forbids customFT; positive FT и большие значения без потери точности | 3 |
| Создание | Нет турнира → форма → Save → один draft/карточка; второй запрос/повтор не перезаписывает запись | 1,2,6 |
| Редактирование | load saved; name/format/FT change; ID/ruleset прежние; новая app-сессия читает сохранённое | 1,2,3 |
| Выход | clean Back; dirty stay/discard/modal Back; pending save/old origin/duplicate click | 5,6,7 |
| Отказы | отсутствующая запись против corrupt/schema/ruleset; read/write error/retry; late native success/error после close | 6 |
| UI | create/edit, три формата, обе политики финала, empty/invalid/loading/saving/error/confirmation; карточка без participants/QR/Start | 4,8 |
| Границы | Реальные use cases/policy/controller/router + fakes только внешних dependencies; logs не подменяют результат | 6,7 |

## Changelog

### 2026-11-13 · Постановка

**Prompt пользователя**

> Теперь давай продумаем создание турнира. Пока только само создание турнира и его настройки без участников запуска спектатор мода и подключения участников. Просто создание и настройка турнира

**Интерактивные уточнения**

> Сколько сохранённых турниров в состоянии настройки можно хранить одновременно? Участников и запуск в этой задаче не реализуем.
>
> Один настраиваемый турнир (Рекомендуется)

> Как заканчивается создание и редактирование настроек турнира?
>
> Кнопка «Создать/Сохранить» → главная с карточкой турнира (Рекомендуется)

> Какие значения FT разрешаем для основной сетки и финала DE/SE? В документе задан минимум FT1 и примеры FT1/FT2/FT3, но верхняя граница не указана.
>
> Любое целое от 1, без продуктового верхнего ограничения (Рекомендуется)

> Если настройки изменены и пользователь нажимает «Назад», как поступаем? Запись в хранилище по-прежнему происходит только по кнопке «Создать/Сохранить».
>
> Подтверждать выход без сохранения (Рекомендуется)

- Подтверждённые ответы отделены от source rules и предлагаемых технических решений. Текст вопроса про FT сохранён дословно; нормативный факт source — defaultFT1, а положительность/отсутствие продуктового max подтверждены ответом пользователя.
- Прочитаны context/router/core/Flutter/workflow, MK11 source, SetupScreen/state/fixtures и актуальный domain/tournament. Созданы план115 и документация, без тестов/реализации. Planning-only сохраняет 🟣.

## Проверка планирования

- [x] Цель ограничена созданием/настройками, исключён запуск/участники/spectator/network.
- [x] Ответы пользователя сохранены, source facts отделены от предложений, current code не выдан за реализацию.
- [x] Структура/ссылки/registry checks завершены.

## Итог

Specification1/plan1 подготовлены к обсуждению и последующему CODE/test-first этапу. Будущие AC1–8 не выполнены; tests/production/build/run/commit/push115 не запускались.

### Проверки планирования · 2026-11-13

- Созданы эта карточка и docs/architecture/tournament-configuration.md; добавлены ссылки в task-list/docs index. Статус115 остаётся 🟣/PLAN_READY, реализация не начата.
- Сценарная сверка source: RR толькоFT2, DE/SE defaultFT1 и наследуемый/override финал, DE Reset обязателен. Min2 относится к start, а не к созданию configuration draft без состава. Утверждённые четыре ответа отражены отдельно от предложенных технических решений.
- Все локальные ссылки новых документов/index проверены, node tools/check_rules.cjs — exit0/21 leaf/3 группы; git diff --check — exit0. Runtime/голдены не запускались для planning-only без изменений UI/кода; наличие новых моделей/repository не заявляется. Незакоммиченные114 изменения сохранены.

### Changelog · 2026-11-13 · Коммит плана

> закомить diff

- Пользователь разрешил коммит текущих изменений. Постановка115 и документ проектирования коммитятся отдельно от реализации114, без push. Статус остаётся 🟣/PLAN_READY; разрешения на реализацию создания турнира этот коммит не даёт. Rules/whitespace проверяются повторно.
