APP_DIR := apps/tournament_app
FLUTTER ?= flutter
SUPPORTED_PLATFORMS := android ios linux macos web windows
DESKTOP_PLATFORMS := linux macos windows

ifeq ($(OS),Windows_NT)
HOST_PLATFORM := windows
else
HOST_OS := $(shell uname -s)
ifeq ($(HOST_OS),Darwin)
HOST_PLATFORM := macos
else ifeq ($(HOST_OS),Linux)
HOST_PLATFORM := linux
else
HOST_PLATFORM := unknown
endif
endif

PLATFORM ?= $(HOST_PLATFORM)
DOMAIN_CHECK_PORT ?= 8090

.DEFAULT_GOAL := help

.PHONY: help bootstrap check-platform check-desktop-host run build build-host \
	build-macos build-windows build-linux analyze clean domain-check

help:
	@printf '%s\n' \
		'Команды TournamentHUB:' \
		'  make bootstrap                Получить зависимости Flutter.' \
		'  make run [PLATFORM=$(HOST_PLATFORM)] Запустить приложение на выбранной платформе.' \
		'  make build                    Собрать приложение для платформы текущего компьютера.' \
		'  make build PLATFORM=web       Собрать Web-версию.' \
		'  make build-macos              Собрать macOS-версию на macOS.' \
		'  make build-windows            Собрать Windows-версию на Windows.' \
		'  make build-linux              Собрать Linux-версию на Linux.' \
		'  make analyze                  Запустить Flutter analyzer.' \
		'  make domain-check             Запустить Web viewer Domain-архитектуры.' \
		'  make clean                    Очистить Flutter-артефакты.' \
		'' \
		'Поддерживаемые PLATFORM: android, ios, linux, macos, web, windows.'

bootstrap:
	cd $(APP_DIR) && $(FLUTTER) pub get

check-platform:
	@case " $(SUPPORTED_PLATFORMS) " in *" $(PLATFORM) "*) ;; *) \
		echo "Неподдерживаемая PLATFORM: $(PLATFORM)"; exit 2 ;; \
	esac

check-desktop-host:
	@case " $(DESKTOP_PLATFORMS) " in *" $(PLATFORM) "*) \
		if [ "$(HOST_PLATFORM)" != "$(PLATFORM)" ]; then \
			echo "Сборка $(PLATFORM) требует нативный $(PLATFORM) toolchain. Текущий host: $(HOST_PLATFORM)."; \
			exit 2; \
		fi ;; \
	*) ;; \
	esac

run: check-platform check-desktop-host
	cd $(APP_DIR) && $(FLUTTER) run -d $(PLATFORM)

build: check-platform check-desktop-host
	cd $(APP_DIR) && $(FLUTTER) build $(PLATFORM)

build-host:
	$(MAKE) build PLATFORM=$(HOST_PLATFORM)

build-macos:
	$(MAKE) build PLATFORM=macos

build-windows:
	$(MAKE) build PLATFORM=windows

build-linux:
	$(MAKE) build PLATFORM=linux

analyze:
	cd $(APP_DIR) && $(FLUTTER) analyze

clean:
	cd $(APP_DIR) && $(FLUTTER) clean

domain-check:
	python3 -m http.server $(DOMAIN_CHECK_PORT) --directory tools/domain-check
