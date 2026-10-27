# Полный набор HTML-макетов

## Статус и назначение

Итерация задачи37 от 27.10.2026: [галерея](prototype/index.html) содержит48 отдельных previews, включая sheets и alerts. Это визуальное предложение для обсуждения экранов приложения, а не принятые бизнес-правила или готовый Flutter UI. После объединения разделов профиля было45 previews; добавлены QR-доступ участников, зрительский QR из готового состава и подтверждение удаления. Ссылки между макетами — HTML-якоря, не routing приложения.

Сохраняем согласованные принципы: mobile-first, графит/тёплое золото, Inter/Roboto Condensed, непрозрачные поверхности, круглые локальные действия и один основной CTA. Без tab bar, glass, поясняющих полотен и повторяющихся заголовков «Профиль»/«Статистика». Эти решения принадлежат проекту, не выдаются за обязательный шаблон Apple. Токены HTML — proposal, не новая каноническая Flutter-тема; базовые значения остаются в [foundation](foundation.md) и [manifest](tokens-manifest.md).

## Порядок просмотра

Основной путь: Bootstrap → главная → настройка турнира → состав гостей → раздача персонажей → текущая схватка → ввод результата → чемпион → полные итоги → главная.

Ответвления: профиль → редактирование/настройки/о приложении/связь; история → завершённый турнир; активный турнир → загрузка/ошибка открытия; турнир → сетка/публичный просмотр; RR → таблица/miniRR; матч → исправление/ошибка/техрезультат; управление → снятие/запрет исправления.

Все состояния доступны одновременно в галерее: неизвестная длительность загрузки не заменяется таймером, а отсутствие backend не маскируется искусственным сохранением.

## Исследование перед реализацией

До добавления новых макетов прочитаны доступные материалы Apple HIG/UIKit и NN/G. Для части HIG полный web-open требует JavaScript; использованы индексируемые выдержки официальных страниц. Таблица фиксирует, какое решение для каждого состояния основано на этих материалах. Это адаптация общих принципов, не сертификация iOS UI или доказательство юзабилити.

### Профиль и внешние разделы

| Preview / назначение | Применённое решение | Apple | NN/G |
|---|---|---|---|
| `profile-new` — новичок | Осмысленное пустое состояние вместо нулевой статистики, путь к первому турниру | [Empty configuration][apple-empty] | [Empty states][nng-empty] |
| `profile-recent` — блок в основном профиле | Место крупнее даты; персонаж, имя и турнир в одном блоке | [Lists][apple-lists] | [Hierarchy][nng-hierarchy] |
| `history-list` — архив | Хронологические строки с результатом; только первая запись открывает соответствующий fixture | [Lists][apple-lists] | [Hierarchy][nng-hierarchy] |
| `history-empty` — пустой архив | Нормальное состояние без ошибки; одно следующее действие | [Empty configuration][apple-empty] | [Empty states][nng-empty] |
| `settings-view` — настройки | Только текущие тема и язык; настройки FT остаются рядом с настройкой турнира | [Settings][apple-settings] | [Progressive disclosure][nng-disclosure] |
| `about-view` — о приложении | Краткое назначение; правила раскрываются отдельно | [UI design tips][apple-tips] | [Progressive disclosure][nng-disclosure] |
| `contact-view` — связь | Канал не определён: форма явно недоступна, нет фиктивной отправки | [Buttons][apple-buttons] | [Forms][nng-forms] |

### Подготовка турнира

| Preview / назначение | Применённое решение | Apple | NN/G |
|---|---|---|---|
| `tournament-loading` — открытие | Indeterminate progress, без вымышленных процентов | [Progress][apple-progress] | [System status][nng-status] |
| `tournament-open-error` — ошибка открытия | Краткая причина состояния и повтор, не сломанный пустой экран | [Alerts][apple-alerts] | [Errors][nng-errors] |
| `setup-de` — DE | Связанные параметры FT сгруппированы; reset не переключатель | [Settings][apple-settings] | [Forms][nng-forms] |
| `setup-se` — SE | Финал отдельно от основной сетки, минимум полей | [Settings][apple-settings] | [Form grouping][nng-grouping] |
| `setup-rr` — RR | Фиксированные FT/очки представлены как данные, не настройки | [Settings][apple-settings] | [Forms][nng-forms] |
| `lobby-roster` — состав гостей | Инициалы, Inter18/600, одно пояснение; без divider/корзин, удаление раскрывается свайпом/hover/focus; QR слева от primary | [Lists][apple-lists], [Toolbars](https://developer.apple.com/design/human-interface-guidelines/toolbars) | [Hierarchy][nng-hierarchy] |
| `participant-access` — подключение с устройств | Цельный скруглённый SVG QR и код сессии внутри светлой карточки, quiet zone4; фиктивный localhost-адрес, транспорт не реализован | [Buttons][apple-buttons], [QR margins](https://www.qrcode.com/en/howto/code.html) | [System status][nng-status] |
| `guest-remove` — подтверждение удаления | Отдельная отмена, destructive не primary; реальное удаление недоступно в макете | [Alerts][apple-alerts] | [Errors][nng-errors] |
| `guest-add` — новый гость | Подписанное поле имени, не placeholder вместо label | [UI design tips][apple-tips] | [Forms][nng-forms] |
| `distribution-working` — раздача | Ожидание отличается от пустоты; неизвестный progress | [Progress][apple-progress] | [System status][nng-status] |
| `distribution-ready` — разданные персонажи | Персонаж крупнее имени гостя; результат раздачи виден списком | [Designing for games][apple-games] | [Hierarchy][nng-hierarchy] |
| `distribution-share` — QR spectator до старта | Круглая QR-кнопка справа в готовом составе; отдельный зрительский payload, возврат к составу, только просмотр | [Buttons][apple-buttons] | [System status][nng-status] |

### Турнир и результат схватки

Переработка27.10.2026: [отдельное исследование09–12](research-screens-09-12.md), Apple/NNG и практики Challonge/Toornament. Источники задают UX-паттерны, не турнирные правила. Внешний вид16 существующих previews изменён без добавления новых бизнес-сценариев.

| Preview / назначение | Применённое решение | Apple | NN/G |
|---|---|---|---|
| `tournament-live` — DE | Одна крупная текущая пара/счёт, короткий контекст, следующая пара спокойнее; управление раскрывается | [Designing for games][apple-games] | [Hierarchy][nng-hierarchy] |
| `tournament-rr` — RR | Очки текущих игроков рядом с ними; полная таблица, правила начисления и исправление доступны через disclosure | [Lists][apple-lists] | [Progressive disclosure][nng-disclosure] |
| `rr-tie` — равенство | Отдельный этап, без произвольного выбора чемпиона | [UI design tips][apple-tips] | [System status][nng-status] |
| `rr-tiebreak-live` — miniRR | Явная подпись переигровки; основной счёт не подменяется | [Designing for games][apple-games] | [System status][nng-status] |
| `bracket-de` — двойная сетка | Верхняя ветка с линиями/горизонтальным scroll; нижняя/Grand Final раскрываются; будущие участники названы источниками | [Scroll views][apple-scroll] | [Hierarchy][nng-hierarchy] |
| `bracket-se` — одиночная сетка | Та же визуальная грамматика, без нижней сетки и матча за3-е | [Scroll views][apple-scroll] | [Hierarchy][nng-hierarchy] |
| `match-result-de` — результат FT1 | Большой sheet над контекстом; результаты1:0/0:1 | [Sheets][apple-sheets] | [Forms][nng-forms] |
| `match-result` — результат RR FT2 | Одна пара в sheet,4 исхода, check/aria-pressed выбора; отмена слева, одно сохранение справа; без ничьей | [Sheets][apple-sheets] | [Forms][nng-forms] |
| `match-correct` — исправление | Та же форма и сохранённый контекст вместо нового паттерна | [Sheets][apple-sheets] | [Forms][nng-forms] |
| `match-save-error` — ошибка записи | Введённый результат остаётся, ошибка у действия | [Sheets][apple-sheets] | [Errors][nng-errors] |
| `match-technical` — технический RR | Отдельный вид результата, без искусственного2:0 | [Sheets][apple-sheets] | [Forms][nng-forms] |
| `match-technical-de` — технический DE | Тот же паттерн, возврат в DE-контекст | [Sheets][apple-sheets] | [Forms][nng-forms] |

### Завершение, подтверждения и зритель

| Preview / назначение | Применённое решение | Apple | NN/G |
|---|---|---|---|
| `tournament-champion` — чемпион | Персонаж/имя доминируют над короткой меткой «Чемпион»; один переход к полным итогам | [Designing for games][apple-games] | [Hierarchy][nng-hierarchy] |
| `tournament-results` — рейтинг DE | Полный список мест, возвращение домой | [Lists][apple-lists] | [Hierarchy][nng-hierarchy] |
| `tournament-results-se` — рейтинг SE | Совместные3–4 вместо вымышленного отдельного победителя | [Lists][apple-lists] | [Hierarchy][nng-hierarchy] |
| `tournament-results-rr` — рейтинг RR | Места с очками, отдельный завершённый fixture | [Lists][apple-lists] | [Hierarchy][nng-hierarchy] |
| `withdraw-player` — снятие | Называем человека и последствия; отмена отделена от destructive-действия | [Alerts][apple-alerts] | [Errors][nng-errors] |
| `result-locked` — запрещённое исправление | Объяснение причины блокировки вместо неработающей формы | [Alerts][apple-alerts] | [Errors][nng-errors] |
| `forfeit-confirm` — сдача схватки | Отличаем сдачу текущего матча от снятия с турнира | [Alerts][apple-alerts] | [Errors][nng-errors] |
| `tournament-share` — доступ зрителя | Один адрес и переход к read-only preview, без обещания работающей сети | [UI design tips][apple-tips] | [System status][nng-status] |
| `spectator-live` — публичный экран | Матч и ближайшая пара без административных контролов, адаптивная композиция | [Designing for games][apple-games] | [Hierarchy][nng-hierarchy] |
| `spectator-offline` — потеря связи | Последние данные сохраняются, явно помечены как неактуальные | [UI design tips][apple-tips] | [System status][nng-status] |

Первые8 previews Bootstrap/главной/основного профиля и их ранее прочитанные источники описаны в [истории дизайна](html-prototype.md); повторно не перерисовывались. На очень узкой ширине активная главная допускает перенос верхних действий и уменьшает внутренний padding карточки, не меняя принятую композицию390px.

## Предметные ограничения

Источник — [правила MK11](../source/mk11_tournament_rules_ru.md), а не дизайн-рекомендации:

- DE: основной FT1 по умолчанию, отдельный FT финала, reset обязателен по условию победы игрока нижней сетки; не пользовательская настройка on/off.
- SE: нет матча за3-е, проигравшие полуфиналов делят3–4.
- RR: FT2 неизменяем; в макете показаны очки3/2/1/0. Технический результат — не игровой2:0. В незавершённой таблице у Ивана2, Марии1 после их2:1; у Алексея пока0 матчей. Финальный fixture другой: Иван6, Алексей3, Мария0, по2 матча.
- При равенстве RR показан отдельный miniRR FT2, рейтинг переигровки определяется победами; основные очки не переписываются. Повторный tie-break использует тот же вид, не ручное назначение чемпиона.
- Исправление блокируется после сыгранного зависимого матча. Снятие необратимо, прошлые результаты остаются; сдача одного матча не равна снятию.
- Никаких Draw/Cancelled или назначения победителя голосованием.
- Только Host и гости, плюс read-only Spectator; participant-коннекта нет. Ограничение количества зрителей не вводится.

## Что намеренно не реализовано

1. Состояния независимы. Принятая главная с8 участниками, новые DE/SE с4 и RR с3 — разные визуальные fixtures, не единый сериализованный турнир. Первые итоги истории открываются; остальные записи иллюстрируют список без подмены чужим результатом. Переход «Настроить» не сохраняет выбранный формат, общий roster иллюстрирует DE. Загрузка и раздача не завершаются автоматически.
2. Поля имени и сообщения readonly; FT-степперы локально переключают демонстрационные FT1/FT2/FT3, но не обновляют другие previews и не сохраняются. Кнопки счёта, сохранения и подтверждения показывают внешний вид, не обработчики. Нет проверки валидности, генератора сетки, вычислений, persistence, реального удаления или отправки.
3. Буквенные SZ/SC/KT/RD — временные avatar-placeholders, не финальная идентификация персонажей. Имя персонажа и игрока уже присутствуют; реальные портреты нужно подставить до принятия production UI. Широкий Spectator также адаптируется в одну колонку.
4. Сетка — предложение композиции и линий на4 участниках, не полный граф переходов DE/Bye/reset для всех размеров. Ссылка из итогов ведёт к общему макету сетки, не к восстановленному архивному состоянию. Reset пока обозначен пояснением. Полный сценарий Bye не нарисован отдельно.
5. `host.local/spectator` — демонстрационный адрес, не утверждённый URL/протокол. Статичные QR-fixtures существуют, но не создают сетевую сессию. Нет WebSocket-соединения, copy или работающей формы обратной связи. Канал поддержки и версия не утверждены.
6. Не проверены native safe areas, Dynamic Type, screen-reader поведение нативных sheets или масштабируемость реального турнира. HTML QA не заменяет Flutter goldens.

Эти ограничения запрещают воспринимать галерею как готовое приложение; конкретный Flutter screen будет реализовываться и проверяться отдельно после согласования дизайна.

[apple-empty]: https://developer.apple.com/documentation/uikit/uicontentunavailableconfiguration-swift.struct
[apple-lists]: https://developer.apple.com/design/human-interface-guidelines/lists-and-tables
[apple-settings]: https://developer.apple.com/design/human-interface-guidelines/settings
[apple-progress]: https://developer.apple.com/design/human-interface-guidelines/progress-indicators
[apple-alerts]: https://developer.apple.com/design/human-interface-guidelines/alerts
[apple-buttons]: https://developer.apple.com/design/human-interface-guidelines/buttons
[apple-sheets]: https://developer.apple.com/design/human-interface-guidelines/sheets
[apple-scroll]: https://developer.apple.com/design/human-interface-guidelines/scroll-views
[apple-games]: https://developer.apple.com/design/human-interface-guidelines/designing-for-games/
[apple-tips]: https://developer.apple.com/design/tips/
[nng-empty]: https://www.nngroup.com/articles/empty-state-interface-design/
[nng-hierarchy]: https://www.nngroup.com/articles/visual-hierarchy-ux-definition/
[nng-disclosure]: https://www.nngroup.com/articles/progressive-disclosure/
[nng-forms]: https://www.nngroup.com/articles/web-form-design/
[nng-grouping]: https://www.nngroup.com/articles/form-design-white-space/
[nng-status]: https://www.nngroup.com/articles/visibility-system-status/
[nng-errors]: https://www.nngroup.com/articles/error-message-guidelines/
