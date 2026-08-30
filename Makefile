DART ?= dart
DEVICE ?=
TARGET ?=

.PHONY: help setup generate-tokens sync-fighter-assets run run-widgetbook run-spectator build build-flutter build-spectator format lint test architecture check clean

help:
	$(DART) run tool/project.dart help

setup:
	$(DART) run tool/project.dart setup

generate-tokens:
	$(DART) run tool/project.dart generate-tokens

sync-fighter-assets:
	$(DART) tool/project.dart sync-fighter-assets

run:
	$(DART) run tool/project.dart run --device "$(DEVICE)"

run-widgetbook:
	$(DART) run tool/project.dart run-widgetbook --device "$(DEVICE)"

run-spectator:
	$(DART) run tool/project.dart run-spectator

build:
	$(DART) run tool/project.dart build --target "$(TARGET)"

build-flutter:
	$(DART) run tool/project.dart build-flutter --target "$(TARGET)"

build-spectator:
	$(DART) run tool/project.dart build-spectator

format:
	$(DART) run tool/project.dart format

lint:
	$(DART) run tool/project.dart lint

test:
	$(DART) run tool/project.dart test

architecture:
	$(DART) run tool/project.dart architecture

check:
	$(DART) run tool/project.dart check

clean:
	$(DART) run tool/project.dart clean
