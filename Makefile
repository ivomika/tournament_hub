SHELL := /bin/sh

FLUTTER_DIR := apps/tournament_app
WEB_DIR := apps/spectator_web
FLUTTER_DEVICE ?= macos
FLUTTER_BUILD_TARGET ?= apk

.PHONY: help bootstrap install flutter-get web-install generate run run-flutter run-web \
	format format-check lint test test-flutter test-web check build \
	build-flutter build-web bundle-spectator clean

help: ## Показать доступные команды
	@awk 'BEGIN {FS = ":.*## "} /^[a-zA-Z0-9_-]+:.*## / {printf "%-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

bootstrap: install ## Установить зависимости всех приложений

install: flutter-get web-install ## Установить зависимости всех приложений

flutter-get:
	cd $(FLUTTER_DIR) && flutter pub get

web-install:
	cd $(WEB_DIR) && npm install

generate: ## Сгенерировать код Drift и Freezed
	cd $(FLUTTER_DIR) && dart run build_runner build

run: bundle-spectator ## Встроить Spectator Web и запустить Flutter Host
	cd $(FLUTTER_DIR) && flutter run -d $(FLUTTER_DEVICE)

run-flutter: ## Запустить Flutter-приложение (устройство задаётся через FLUTTER_DEVICE)
	cd $(FLUTTER_DIR) && flutter run -d $(FLUTTER_DEVICE)

run-web: ## Запустить только dev-сервер React Spectator для UI-разработки
	cd $(WEB_DIR) && npm run dev

format: ## Отформатировать исходный код Dart и web
	cd $(FLUTTER_DIR) && dart format lib test
	cd $(WEB_DIR) && npm run format

format-check: ## Проверить форматирование без изменения файлов
	cd $(FLUTTER_DIR) && dart format --output=none --set-exit-if-changed lib test
	cd $(WEB_DIR) && npm run format:check

lint: ## Запустить статический анализ обоих приложений
	cd $(FLUTTER_DIR) && flutter analyze
	cd $(WEB_DIR) && npm run lint

test: test-flutter test-web ## Запустить все тесты

test-flutter:
	cd $(FLUTTER_DIR) && flutter test

test-web:
	cd $(WEB_DIR) && npm test

check: format-check lint test ## Запустить проверку форматирования, анализ и тесты

build: build-web bundle-spectator build-flutter ## Собрать web, встроить его и собрать Flutter

build-web: ## Собрать production bundle Spectator
	cd $(WEB_DIR) && npm run build

bundle-spectator: build-web ## Скопировать spectator bundle в ресурсы Flutter
	mkdir -p $(FLUTTER_DIR)/assets/spectator
	cp -R $(WEB_DIR)/dist/. $(FLUTTER_DIR)/assets/spectator/

build-flutter: ## Собрать Flutter (по умолчанию APK; цель задаётся через FLUTTER_BUILD_TARGET)
	cd $(FLUTTER_DIR) && flutter build $(FLUTTER_BUILD_TARGET)

clean: ## Удалить результаты сборки штатными командами фреймворков
	cd $(FLUTTER_DIR) && flutter clean
	cd $(WEB_DIR) && npm run clean
