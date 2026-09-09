# Локальные команды

Корневой `Makefile` — единая точка запуска команд для `apps/tournament_app`.

## Основные команды

- `make run` — запуск для desktop-платформы текущего компьютера: macOS, Windows или Linux.
- `make run PLATFORM=web` — запуск Web-версии.
- `make build` — сборка нативной desktop-платформы текущего компьютера.
- `make build-macos` — сборка macOS на macOS.
- `make build-windows` — сборка Windows на Windows.
- `make build-linux` — сборка Linux на Linux.
- `make build PLATFORM=android` — сборка Android-версии.
- `make analyze` — статический анализ Dart-кода.
- `make clean` — очистка артефактов Flutter.
- `make help` — справка по всем командам.

Вместо `android` можно указать `ios`, `linux`, `macos`, `windows` или `web`. Flutter desktop использует нативные платформенные toolchain, поэтому macOS, Windows и Linux собираются на соответствующей ОС. Makefile отклонит попытку собрать desktop target на другой ОС, вместо того чтобы создать вводящий в заблуждение артефакт.
