# tournament_app

Кроссплатформенное Flutter-приложение TournamentHUB.

## Архитектура

- `lib/domain` содержит предметные правила и application business logic contracts без Flutter и Infrastructure dependencies.
- `lib/app` будет отвечать за bootstrap, composition, DI, routing и configuration.
- `lib/presentation` будет содержать UI и его state.
- Infrastructure-реализации Domain ports появятся отдельно от `domain`.

Подробные границы описаны в [`docs/architecture/domain-layer.md`](../../docs/architecture/domain-layer.md).
