# R-003.h. Навигация через intentions, guard и effect

## Применение

Flutter-клиент: app routing и любой presentation/controller, который запрашивает переход.

## Ограничения

- Presentation передаёт типизированный NavigationIntent через scoped NavigationIntentSink. Screen/controller не импортирует go_router, app routes/DI и не выбирает push/go/pop. Конкретная запись-источник закрепляется в app при binding; rebuild её не меняет, удалённый entry не переиспользуется.
- App guard проверяет source/state и выдаёт typed decision. Только app effect executor выполняет переход. URL и сериализация параметров находятся в app/routing; строки не используются как модель намерений или route constants.
- Дубли сравниваются по origin, виду и значениям payload. Конкурирующие данные из одного source дают typed conflict; старые callbacks не управляют новыми записями. Одновременно выполняется один effect.
- GoRouteData и generated helpers используются только внутри app. Бизнес-правила не переносятся в guard; UI не получает infrastructure или domain ports через навигацию.
- Локальный modal pop select и Widgetbook dialog — не переход приложения. Точные действующие исключения: _SelectModalState._choose/_close в components/select/app_select.dart и _DialogOverlayState._close в widgetbook/widgets/dialog/overlay/overlay_use_case.dart; разрешено только Navigator.of(...).pop. Push и другие классы/методы не разрешены.
- Сгенерированные helpers в app/routing/app_routes.g.dart не вызываются presentation. Не добавлять blanket-ignore других generated файлов.
- Для общих app adapters SDK-вызовы разрешены точно: GoRouterPushInteractionAdapter._open — push, _close — pop/restore в app/navigation/go_router_push_interaction_adapter.dart; FlutterModalInteractionAdapter._openRoute — push, _closeRoute — removeRoute, _openSheet — showBottomSheet в app/navigation/flutter_modal_interaction_adapter.dart. Другое имя класса/метода или путь не получает это разрешение. Adapters вызываются только app effect после guard; их наличие не разрешает прямые вызовы из widgets.
- Возврат данных экрана и подтверждение открытия — разные типизированные события. Ожидание результата не удерживает очередь переходов. Результат связан с конкретным child entry и доставляется ровно один раз; child не получает произвольный generic pop или app result publisher.
- Modal как шаг сценария открывается через state intent → guard → app effect и имеет собственный route/controller handle. Закрытие чужого верхнего окна запрещено. Native dismiss/Back/drag и программное закрытие завершают одну операцию, различая значение, отмену и технический отказ.
- Локальный picker/dropdown живёт в изолированном DS-компоненте и отдаёт значение callback, не вызывает бизнес-use case и не создаёт app route. Screens не вызывают showDialog/showDatePicker/showModalBottomSheet/showBottomSheet; state не получает BuildContext для их показа. Новые SDK-исключения local adapter добавляются точечно с tests; blanket exception по имени файла запрещён.

## Проверка

make architecture-test/check: import/export go_router вне app, перечисленные app navigation calls вне точных adapters/generated helper и Navigator calls из presentation проверяются AST. Прямые/префиксные showDialog/showDatePicker/showModalBottomSheet/showBottomSheet вне известных owner также запрещены. Сохранены лишь существующие local open: _AppSelectState._open/showModalBottomSheet в components/select/app_select.dart и _DialogOverlayState._open/showDialog в widgetbook/widgets/dialog/overlay/overlay_use_case.dart. Проверка основана на синтаксисе, не на полной resolved модели внешних extension API; review публичных контрактов, скрытых alias/callbacks и runtime guards остаётся обязательным. Tests: tools/domain-check/test/navigation_boundaries_test.dart и test/app/navigation. Типизированность не заменяет policy guard.

Контракт и пределы текущего этапа: [Типизированная навигация](../../../docs/architecture/typed-navigation.md).

Typed results, локальные picker и app modal: [Архитектура взаимодействий](../../../docs/architecture/navigation-interactions.md). Общие adapters проверяются runtime tests/AST; конкретные screen bindings и business flow подключаются отдельно при реализации экранов.
