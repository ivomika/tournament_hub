# Domain architecture checker

Статический локальный viewer Domain-архитектуры TournamentHUB.

## Запуск

Из корня репозитория:

```sh
make domain-check
```

Затем открой адрес, напечатанный сервером, обычно `http://localhost:8090`.

## Состав

- `domain-architecture.json` — единственный источник данных: области, объекты, contracts и связи.
- `index.html`, `styles.css`, `app.js` — интерфейс просмотра без внешних зависимостей.

При изменении публичной Domain-архитектуры обновляй JSON в той же задаче. Viewer не является источником истины и не заменяет исходный Dart-код.
