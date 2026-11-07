import 'dart:io';

import '../bin/check_flutter_architecture.dart' as architecture;

// Regression contract for R-003.d. Runs without a new testing dependency.
void main() {
  const primitive =
      'lib/presentation/design_system/foundation/primitives/palette.dart';
  const assembly =
      'lib/presentation/design_system/foundation/theme/app_theme.dart';
  const widgetTheme =
      'lib/presentation/design_system/components/card/card_theme.dart';
  const widget = 'lib/presentation/screens/home/home_screen.dart';
  const barrel = 'lib/presentation/shared/palette.dart';
  const primitiveImport =
      'package:fixture/presentation/design_system/foundation/primitives/palette.dart';
  const extension =
      'lib/presentation/design_system/foundation/spacing/app_spacing.dart';
  const base = {
    extension:
        "import 'package:flutter/material.dart'; class AppSpacing extends ThemeExtension<AppSpacing> { const AppSpacing({required this.space8}); final double space8; }",
    primitive: '''
import 'package:flutter/material.dart';
abstract final class Palette {
  static const primary = Color(0xFFF1C75B);
  static const body = TextStyle(fontSize: 14);
}
''',
    assembly:
        '''
import 'package:flutter/material.dart';
import '$primitiveImport';
abstract final class AppTheme {
static ThemeData createTheme() => ThemeData(
  colorScheme: ColorScheme.dark(primary: Palette.primary),
  textTheme: const TextTheme(bodySmall: Palette.body),
);
}
''',
    widgetTheme: '''
import 'package:flutter/material.dart';
class CardTheme {
  CardTheme.of(BuildContext context) : body = Theme.of(context).textTheme.bodySmall!;
  final TextStyle body;
}
''',
    widget: '''
import 'package:flutter/material.dart';
import 'package:fixture/presentation/design_system/components/card/card_theme.dart';
class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) => Text('fixture', style: CardTheme.of(context).body);
}
''',
  };
  final scenarios = <({String name, Map<String, String> overrides, String? rejectedFile})>[
    (
      name: 'accepted primitive -> ThemeData -> WidgetTheme -> Widget',
      overrides: {},
      rejectedFile: null,
    ),
    (
      name: 'direct primitive import in widget',
      overrides: {
        widget: "import '$primitiveImport'; final body = Palette.body;",
      },
      rejectedFile: widget,
    ),
    (
      name: 'alias cannot bypass primitive import',
      overrides: {
        widget: "import '$primitiveImport' as p; final body = p.Palette.body;",
      },
      rejectedFile: widget,
    ),
    (
      name: 'WidgetTheme cannot import primitives either',
      overrides: {
        widgetTheme: "import '$primitiveImport'; final body = Palette.body;",
      },
      rejectedFile: widgetTheme,
    ),
    (
      name: 're-export cannot leak primitive into widget',
      overrides: {
        barrel: "export '$primitiveImport';",
        widget:
            "import 'package:fixture/presentation/shared/palette.dart'; final body = Palette.body;",
      },
      rejectedFile: widget,
    ),
    (
      name: 'part library cannot bypass primitive boundary',
      overrides: {
        widget:
            "import '$primitiveImport'; part 'package:fixture/presentation/screens/home/home_part.dart';",
        'lib/presentation/screens/home/home_part.dart':
            "part of 'package:fixture/presentation/screens/home/home_screen.dart'; final body = Palette.body;",
      },
      rejectedFile: widget,
    ),
    (
      name: 'raw const TextStyle in widget',
      overrides: {
        widget:
            "import 'package:flutter/material.dart'; final body = const TextStyle(fontSize: 14);",
      },
      rejectedFile: widget,
    ),
    (
      name: 'implicit TextStyle constructor in widget',
      overrides: {
        widget:
            "import 'package:flutter/material.dart'; final body = TextStyle(fontSize: 14);",
      },
      rejectedFile: widget,
    ),
    (
      name: 'aliased Flutter TextStyle constructor',
      overrides: {
        widget:
            "import 'package:flutter/material.dart' as m; final body = m.TextStyle(fontSize: 14);",
      },
      rejectedFile: widget,
    ),
    (
      name: 'raw Color literal in widget',
      overrides: {
        widget:
            "import 'package:flutter/material.dart'; final color = Color(0xFF123456);",
      },
      rejectedFile: widget,
    ),
    (
      name: 'Colors palette in widget',
      overrides: {
        widget:
            "import 'package:flutter/material.dart'; final color = Colors.red;",
      },
      rejectedFile: widget,
    ),
    (
      name: 'aliased Colors palette in WidgetTheme',
      overrides: {
        widgetTheme:
            "import 'package:flutter/material.dart' as m; final color = m.Colors.red;",
      },
      rejectedFile: widgetTheme,
    ),
    (
      name: 'static styling cannot hide in helper file',
      overrides: {
        'lib/presentation/shared/styles.dart':
            "import 'package:flutter/material.dart'; const body = TextStyle(fontSize: 14);",
      },
      rejectedFile: 'lib/presentation/shared/styles.dart',
    ),
    (
      name: 'standard Flutter runtime theme accepted',
      overrides: {
        widget:
            "import 'package:flutter/material.dart'; abstract final class Styles { static TextStyle? read(BuildContext c) => Theme.of(c).textTheme.bodySmall; }",
      },
      rejectedFile: null,
    ),
    (
      name: 'comments and textual examples are not styling',
      overrides: {
        widget:
            "// const style = TextStyle(fontSize: 14); Colors.red\nconst example = 'Color(0xFF123456) Palette.body';",
      },
      rejectedFile: null,
    ),
    (
      name: 'const widget constructor stays allowed',
      overrides: {
        widget:
            "import 'package:flutter/material.dart'; const child = SizedBox.shrink();",
      },
      rejectedFile: null,
    ),
    (
      name: 'own data class named Color is not Flutter styling',
      overrides: {
        widget:
            'class Color { Color(this.code); final int code; } final data = Color(7);',
      },
      rejectedFile: null,
    ),
    (
      name: 'test primitive fixtures stay allowed',
      overrides: {
        'test/theme_fixture_test.dart':
            "import '$primitiveImport'; final sample = Palette.body;",
      },
      rejectedFile: null,
    ),
    (
      name: "implicit raw color via dart ui",
      overrides: {
        "lib/presentation/screens/home/home_screen.dart":
            "import 'dart:ui' as ui; final c = ui.Color(0xFF112233);",
      },
      rejectedFile: "lib/presentation/screens/home/home_screen.dart",
    ),
    (
      name: "typedef constructor bypass",
      overrides: {
        "lib/presentation/screens/home/home_screen.dart":
            "import 'package:flutter/material.dart'; typedef Style = TextStyle; final body = Style(fontSize: 14);",
      },
      rejectedFile: "lib/presentation/screens/home/home_screen.dart",
    ),
    (
      name: "primitive directory cannot hide widget",
      overrides: {
        "lib/presentation/design_system/foundation/primitives/illegal.dart":
            "import 'package:flutter/material.dart'; class Illegal extends StatelessWidget {}",
      },
      rejectedFile:
          "lib/presentation/design_system/foundation/primitives/illegal.dart",
    ),
    (
      name: "extension literal override",
      overrides: {
        "lib/presentation/screens/home/home_screen.dart":
            "import 'package:flutter/material.dart'; import 'package:fixture/presentation/design_system/foundation/spacing/app_spacing.dart'; AppSpacing changed(AppSpacing base) => base.copyWith(space8: 99);",
      },
      rejectedFile: "lib/presentation/screens/home/home_screen.dart",
    ),
    (
      name: "extension literal construction",
      overrides: {
        "lib/presentation/screens/home/home_screen.dart":
            "import 'package:flutter/material.dart'; import 'package:fixture/presentation/design_system/foundation/spacing/app_spacing.dart'; final spacing = AppSpacing(space8: 99);",
      },
      rejectedFile: "lib/presentation/screens/home/home_screen.dart",
    ),
    (
      name: "extracted scalar constant",
      overrides: {
        "lib/presentation/screens/home/home_screen.dart":
            "import 'package:flutter/material.dart'; const gap = 17.0; final child = SizedBox(width: gap);",
      },
      rejectedFile: "lib/presentation/screens/home/home_screen.dart",
    ),
    (
      name: "inline size literal",
      overrides: {
        "lib/presentation/screens/home/home_screen.dart":
            "import 'package:flutter/material.dart'; final child = SizedBox(width: 17);",
      },
      rejectedFile: "lib/presentation/screens/home/home_screen.dart",
    ),
    (
      name: "runtime extension reference allowed",
      overrides: {
        "lib/presentation/screens/home/home_screen.dart":
            "import 'package:flutter/material.dart'; import 'package:fixture/presentation/design_system/foundation/spacing/app_spacing.dart'; abstract final class Preview { static Widget child(BuildContext c) => SizedBox(width: Theme.of(c).extension<AppSpacing>()!.space8); }",
      },
      rejectedFile: null,
    ),
    (
      name: "fixed theme assembly import",
      overrides: {
        "lib/presentation/screens/home/home_screen.dart":
            "import 'package:fixture/presentation/design_system/foundation/theme/app_theme.dart';",
      },
      rejectedFile: "lib/presentation/screens/home/home_screen.dart",
    ),
    (
      name: 'part inherits Flutter styling namespace',
      overrides: {
        widget:
            "import 'package:flutter/material.dart'; part 'package:fixture/presentation/screens/home/home_part.dart';",
        'lib/presentation/screens/home/home_part.dart':
            "part of 'package:fixture/presentation/screens/home/home_screen.dart'; final style = TextStyle(fontSize: 17);",
      },
      rejectedFile: 'lib/presentation/screens/home/home_part.dart',
    ),
    (
      name: 'final scalar helper cannot freeze style',
      overrides: {
        widget:
            "import 'package:flutter/material.dart'; final fixed = 17.0; final box = SizedBox(width: fixed);",
      },
      rejectedFile: widget,
    ),
    (
      name: 'multi-hop primitive re-export',
      overrides: {
        barrel: "export 'package:fixture/presentation/shared/second.dart';",
        'lib/presentation/shared/second.dart': "export '$primitiveImport';",
        widget: "import 'package:fixture/presentation/shared/palette.dart';",
      },
      rejectedFile: widget,
    ),
    (
      name: 'named Color constructor',
      overrides: {
        widget:
            "import 'package:flutter/material.dart'; final c = Color.fromARGB(255, 1, 2, 3);",
      },
      rejectedFile: widget,
    ),
    (
      name: 'named aliased Color constructor',
      overrides: {
        widget:
            "import 'package:flutter/material.dart' as m; final c = m.Color.fromRGBO(1, 2, 3, 1);",
      },
      rejectedFile: widget,
    ),
    (
      name: 'named ThemeData constructor',
      overrides: {
        widget:
            "import 'package:flutter/material.dart'; final theme = ThemeData.dark();",
      },
      rejectedFile: widget,
    ),
    (
      name: 'named insets constructor',
      overrides: {
        widget:
            "import 'package:flutter/material.dart'; final padding = EdgeInsets.all(14);",
      },
      rejectedFile: widget,
    ),
    (
      name: 'runtime color interpolation allowed',
      overrides: {
        widget:
            "import 'package:flutter/material.dart'; abstract final class ColorsAdapter { static Color? blend(Color a, Color b, double t) => Color.lerp(a, b, t); }",
      },
      rejectedFile: null,
    ),
  ];
  final failures = <String>[];
  for (final scenario in scenarios) {
    final findings = architecture.inspect({
      ...base,
      ...scenario.overrides,
    }, 'fixture');
    final themeFindings = findings
        .where((finding) => finding.contains('R-003.d:'))
        .toList();
    final rejectedFile = scenario.rejectedFile;
    if (rejectedFile == null) {
      if (findings.isNotEmpty)
        failures.add('${scenario.name}: unexpected $findings');
    } else if (!themeFindings.any(
      (finding) => finding.startsWith('$rejectedFile:'),
    )) {
      failures.add(
        '${scenario.name}: expected R-003.d finding in $rejectedFile; actual $findings',
      );
    }
  }
  if (failures.isNotEmpty) {
    stderr.writeln(failures.join('\n'));
    stderr.writeln(
      'Theme boundary tests: ${failures.length}/${scenarios.length} failed.',
    );
    exitCode = 1;
  } else {
    stdout.writeln('Theme boundary tests: ${scenarios.length} passed.');
  }
}
