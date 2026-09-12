# Domain architecture checker

`tools/domain-check` — локальное Web mini app для просмотра Domain-архитектуры TournamentHUB.

Инструмент читает `domain-architecture.json` и показывает области, объекты, ports, repositories и основные связи. JSON намеренно описывает архитектуру кратко: имена, важные поля, доступные операции и зависимости, без копирования исходного Dart-кода.

Запуск из корня репозитория:

```sh
make domain-check
```

На Windows команда использует Python launcher `py -3`, на macOS/Linux —
`python3`. При нестандартной установке интерпретатор можно задать явно:

```sh
make domain-check PYTHON=python
```

При изменении публичной Domain-архитектуры обновляется и JSON-инвентарь в той же задаче.
