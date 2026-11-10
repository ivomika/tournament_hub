# Графический backend macOS

## Решение

В macOS Runner установлен `FLTEnableImpeller=false` в `Info.plist`. Flutter3.47.0 выбирает **Skia/Metal**, сохраняя аппаратное ускорение. Это конфигурация macOS-сборки, общая для `lib/main.dart` и `lib/main_widgetbook.dart`, debug/profile/release. Она также применяется при открытии готового `.app`, а не только к одной IDE-команде. iOS/Android и Dart UI не изменены.

Основание: на Intel Mac (Intel UHD630 + AMD Radeon Pro5300M) при Impeller/MetalSDF наблюдались зависания перерисовки и пропадающие элементы/артефакты. Во временной копии той же сборки с opt-out лог подтвердил Skia/Metal; проверенные переходы и overlay отрисовались без пропадания элементов. Это совместимый обход проблемы renderer/драйвера, а не изменение layout. Текущий короткий baseline Impeller также мог отрисовать экран корректно: дефект интермиттирующий. FPS-улучшение в процентах не измерялось, длительный нагрузочный прогон не заявляется.

[Официальная документация Flutter](https://docs.flutter.dev/perf/impeller#macos) описывает этот opt-out. Локальные `FlutterDartProject.mm` и `FlutterEngine.mm` SDK подтверждают чтение plist и выбор backend. Применяется ко всему macOS Runner, в том числе ARM64; отдельная проверка Apple Silicon не выполнена. При обновлении Flutter необходимо перепроверить поддержку opt-out и возможность возврата Impeller.

## Запуск

```sh
cd apps/tournament_app
flutter run -d macos -t lib/main.dart
flutter run -d macos -t lib/main_widgetbook.dart
```

Специальные флаги не нужны. Для диагностического явного выбора можно добавить `--no-enable-impeller`; `--enable-impeller` намеренно переопределит plist. Не добавляйте их в общие iOS/Android launch profiles.

После изменения renderer нужен полный stop/start приложения или новая сборка: hot reload/hot restart внутри уже созданного engine не переключает backend. Ожидаемая строка native startup:

```text
Using the Skia rendering backend (Metal).
```

Наличие только успешного `flutter test` не подтверждает renderer `.app`: тестовый rasterizer и native launch проверяются отдельно.

## Проверки задачи102

Проверено 2026-11-10 на macOS15.8.2 (24H232), x86_64, Flutter3.47.0/Dart3.13.0:

- `plutil -lint macos/Runner/Info.plist` — OK.
- `flutter build macos --debug -t lib/main_widgetbook.dart --no-pub` — PASS.
- `plutil -extract FLTEnableImpeller raw build/macos/Build/Products/Debug/tournament_app.app/Contents/Info.plist` — `false`.
- Обычный запуск bundle executable без renderer-флагов подтвердил `Using the Skia rendering backend (Metal).`
- Оконная проверка: welcome → каталог → Results DE, dropdown Viewport, Mobile390×844; на готовой пересобранной сборке дополнительно MatchResult FT3 и dropdown. В проверенных переходах пропавших элементов/артефактов не наблюдалось.
- `flutter test --no-pub test/widgetbook_bootstrap_test.dart` — **6 passed**, включая открытие всех зарегистрированных use cases.
- `make architecture-check` —533 файла без нарушений; `node tools/check_rules.cjs` и `git diff --check` — PASS.
- Debug/Profile/Release в Xcode ссылаются на общий `Runner/Info.plist`; выполнена именно Debug-сборка. В IDE/project settings принудительного Impeller override не найдено.

Dart UI не менялся, новые golden baselines не создавались. GPU performance benchmark, длительный stress run, отдельная Release-сборка и Apple Silicon не проверялись.
