# Tools

`tools/` — утилитарная папка TournamentHUB.

Здесь хранятся скрипты, генераторы, проверки и иные вспомогательные инструменты, которые обслуживают разработку проекта, но не входят в runtime-код приложений из `apps/`.

Каждый добавленный инструмент должен иметь одну понятную ответственность и краткое описание способа запуска.


## Preview HTML-прототипа

`python3 tools/serve_prototype.py` запускает loopback preview на8094: desktop/mobile HTML и assets из `docs/design/prototype`, а также два явно перечисленных шрифта приложения. Остальные файлы репозитория не обслуживаются; directory listing отключён. Порт можно задать через `--port`.

## Контракт Flutter темы

`python3 tools/check_theme_contract.py` выполняет архитектурные self-tests, regression fixtures R-003.g (функции классов) и запрета primitives/raw styles, проверку реальных lib/test и Flutter theme propagation tests. `--static-only` выполняет первые три шага без Flutter. Скрипт запускается из любой директории; DART и FLUTTER задают SDK executable. Make shortcuts: `make theme-check` и `make theme-test`. Любой отказ возвращает ненулевой код. Контракт и исключения описаны в [runtime foundation](../docs/architecture/runtime-theme-foundation.md).
