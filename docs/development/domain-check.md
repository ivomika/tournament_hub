# Domain architecture checker

`tools/domain-check` — локальное Web mini app для просмотра Domain-архитектуры TournamentHUB.

Инструмент читает `domain-architecture.json` и показывает области, объекты, ports, repositories и основные связи. JSON намеренно описывает архитектуру кратко: имена, важные поля, доступные операции и зависимости, без копирования исходного Dart-кода.

Запуск из корня репозитория:

```sh
make domain-check
```

При изменении публичной Domain-архитектуры обновляется и JSON-инвентарь в той же задаче.
