# Foundation через runtime Flutter Theme

Решение принято пользователем7 ноября2026. Канонический поток: **primitive const → FlutterTheme → WidgetTheme → Widget**.

Примитивы — исходные числовые/цветовые/типографические значения. Они доступны только definitions и assembly основной ThemeData. FlutterTheme использует ColorScheme, TextTheme, стандартные component themes (включая ProgressIndicatorThemeData) и типизированные ThemeExtension для spacing/shape/motion/responsive/custom semantic roles. Extension является частью ThemeData и поддерживает copyWith/lerp.

WidgetTheme строится из текущей Theme.of(context), читает стандартные роли и extensions. Проектный виджет получает готовые параметры WidgetTheme. Стандартный Text может наследовать TextTheme через context; готовый const TextStyle из primitive registry в него не передаётся. Const widget constructors сохраняются; предметные данные не являются design tokens.

```dart
final theme = MyWidgetTheme.of(context);
return Text(label, style: theme.body);
```

Запрещённый обход:

```dart
return Text(label, style: AppTypography.body);
```

Запрет охватывает ColorPrimitives/Colors и raw const Color/TextStyle в production widgets/themes, primitive imports через aliases/re-export/part, fixed AppFoundation.dark() внутри consumer. Изменение основной темы должно менять уже существующие consumers. Нельзя автоматически брать dark defaults, если required extension не подключён.

Граница файлов: primitive definitions находятся в foundation/primitives; единственная сборка ThemeData — foundation/theme/app_theme.dart; runtime extension types не импортируют primitive defaults. Widgets/components/screens/WidgetTheme используют ThemeData, не assembly. App bootstrap выбирает тему; preview host наследует внешнюю ThemeData либо получает явную тему fixture, не создаёт dark fallback. Golden harness задаёт тему явно. Tests и один primitive-scales tooling case могут использовать primitive data fixtures; оформление самого preview themed.

## Исполняемый контракт

`python3 tools/check_theme_contract.py` запускается из любой директории, без сторонних Python dependencies. `make theme-test` вызывает тот же скрипт; `make theme-check` / `--static-only` пропускает только Flutter runtime tests. DART/FLUTTER позволяют выбрать SDK executable. Первый отказ прекращает проверку с ненулевым кодом.

1. Существующий architecture checker проверяет imports/exports/part и все conditional-ветви; theme guard добавляет findings R-003.d.
2. AST guard закрывает primitive/assembly imports через alias и цепочку re-export; primitive/theme assembly не может содержать Widget subclasses.
3. В production lib запрещены raw Flutter Color/TextStyle/ThemeData/ColorScheme/TextTheme constructors (включая implicit/named/aliased), Colors и style constants. Литеральные style arguments, локальные const/final scalar helpers и литеральные overrides ThemeExtension также отвергаются.
4. Разрешены runtime ColorScheme/TextTheme/ThemeExtension, создание style objects только из значений темы, runtime lerp, const widget constructors и предметные данные. Tests используют raw fixtures. Исключения tooling ограничены одним primitive-scales файлом и viewport fixture; весь Widgetbook не исключается.
5. Regression fixtures включают разрешённые и запрещённые конструкции. Flutter tests меняют тему на уже смонтированных ColorPalette/TypographyCatalog, проверяют layout/status extensions, copyWith/lerp всех extensions и отсутствие fallback при неполной assembly.

Guard использует parse-only AST и граф импортов/экспортов, а не regex по тексту; comments/strings не становятся оформлением. Это структурная защита от известных прямых обходов, не полноценный data-flow/type-resolved анализ произвольного Dart и внешних packages. Семантику вычислений в helpers и динамические источники оформления по-прежнему оценивает review. Проверка не обещает обнаружить все возможные способы скрыть style в исполняемом коде.

Flutter ThemeExtension реализуются с copyWith/lerp по [официальному контракту](https://api.flutter.dev/flutter/material/ThemeExtension-class.html). Текущий вид штатного M3 индикатора включён через [ProgressIndicatorThemeData.year2023](https://api.flutter.dev/flutter/material/ProgressIndicatorThemeData/year2023.html); локальное lint-ignore объясняет требуемый opt-in используемого SDK.

Данное решение отменяет прежние примеры передачи AppTypography/AppColors constants непосредственно WidgetTheme. При переносе scopes40–48 оно приоритетно. ProgressIndicator приложения — штатный Material3; HTML waveform не переносится (task66 spec3).
