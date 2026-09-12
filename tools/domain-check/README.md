# Domain architecture checker

Статический локальный viewer Domain-архитектуры TournamentHUB.

## Запуск

Из корня репозитория:

```sh
make domain-check
```

Затем открой адрес, напечатанный сервером, обычно `http://localhost:8090`.

На Windows Makefile запускает `py -3`; на macOS/Linux — `python3`. Если
Python расположен нестандартно, передай команду интерпретатора через
`PYTHON`, например `make domain-check PYTHON=python`.

## Состав

- `domain-architecture.json` — единственный источник данных: области, объекты, contracts и связи.
- `index.html`, `styles.css`, `app.js` — интерфейс просмотра без внешних зависимостей.

При изменении публичной Domain-архитектуры обновляй JSON в той же задаче. Viewer не является источником истины и не заменяет исходный Dart-код.
