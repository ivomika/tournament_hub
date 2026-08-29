import 'dart:convert';
import 'dart:io';

final class Violation {
  const Violation(this.rule, this.path, this.message);

  final String rule;
  final String path;
  final String message;

  @override
  String toString() => '[$rule] $path: $message';
}

Future<void> main(List<String> arguments) async {
  final root = File.fromUri(Platform.script).parent.parent;
  final selfTestOnly = arguments.contains('--self-test-only');
  final violations = <Violation>[];

  violations.addAll(await _runFixtureTests(root));
  if (!selfTestOnly) violations.addAll(await _checkProject(root));

  if (violations.isNotEmpty) {
    stderr.writeln('Flutter design-system architecture check failed:');
    for (final violation in violations) {
      stderr.writeln('  $violation');
    }
    exitCode = 1;
    return;
  }

  stdout.writeln('Flutter design-system architecture check passed.');
}

Future<List<Violation>> _runFixtureTests(Directory root) async {
  final file = File(
    _join(
      root.path,
      'tool',
      'architecture_fixtures',
      'flutter_design_system.json',
    ),
  );
  final fixtures = jsonDecode(await file.readAsString()) as List<Object?>;
  final failures = <Violation>[];

  for (final value in fixtures) {
    final fixture = value! as Map<String, Object?>;
    final name = fixture['name']! as String;
    final path = fixture['path']! as String;
    final source = fixture['source']! as String;
    final expectedRule = fixture['expectedRule']! as String;
    final detected = _sourceViolations(path, source);
    if (!detected.any((violation) => violation.rule == expectedRule)) {
      failures.add(
        Violation(
          'fixture-not-detected',
          file.path,
          '$name: expected $expectedRule, got '
              '${detected.map((item) => item.rule).join(', ')}',
        ),
      );
    }
  }
  return failures;
}

Future<List<Violation>> _checkProject(Directory root) async {
  final presentation = Directory(
    _join(root.path, 'apps', 'tournament_app', 'lib', 'presentation'),
  );
  final designSystem = Directory(_join(presentation.path, 'design_system'));
  final components = Directory(_join(designSystem.path, 'components'));
  final screens = Directory(_join(presentation.path, 'screens'));
  final violations = <Violation>[];

  for (final required in [designSystem, components, screens]) {
    if (!required.existsSync()) {
      violations.add(
        Violation(
          'missing-boundary',
          _relative(root, required.path),
          'directory is required',
        ),
      );
    }
  }
  if (violations.isNotEmpty) return violations;

  final obsolete = [
    Directory(
      _join(root.path, 'apps', 'tournament_app', 'lib', 'design_system'),
    ),
    Directory(_join(presentation.path, 'components')),
  ];
  for (final directory in obsolete) {
    if (directory.existsSync()) {
      violations.add(
        Violation(
          'obsolete-presentation-boundary',
          _relative(root, directory.path),
          'move UI into presentation/design_system',
        ),
      );
    }
  }

  await for (final entity in presentation.list(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final relative = _relative(root, entity.path);
    violations.addAll(_sourceViolations(relative, await entity.readAsString()));
  }

  await for (final entity in components.list()) {
    if (entity is! Directory) {
      violations.add(
        Violation(
          'component-folder-contract',
          _relative(root, entity.path),
          'component root may contain directories only',
        ),
      );
      continue;
    }
    final name = _basename(entity.path);
    final widget = File(_join(entity.path, '$name.dart'));
    final theme = File(_join(entity.path, '${name}_theme.dart'));
    if (!widget.existsSync() || !theme.existsSync()) {
      violations.add(
        Violation(
          'component-folder-contract',
          _relative(root, entity.path),
          'expected $name.dart and ${name}_theme.dart',
        ),
      );
      continue;
    }
    final widgetSource = await widget.readAsString();
    final themeSource = await theme.readAsString();
    if (!widgetSource.contains("import '${name}_theme.dart';")) {
      violations.add(
        Violation(
          'component-theme-contract',
          _relative(root, widget.path),
          'component must import its own theme',
        ),
      );
    }
    if (!widgetSource.contains('Theme.of(context).extension<')) {
      violations.add(
        Violation(
          'component-theme-contract',
          _relative(root, widget.path),
          'component must read its typed ThemeExtension',
        ),
      );
    }
    if (!themeSource.contains('extends ThemeExtension<')) {
      violations.add(
        Violation(
          'component-theme-contract',
          _relative(root, theme.path),
          'component theme must extend ThemeExtension',
        ),
      );
    }
  }

  await for (final entity in screens.list(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('_screen.dart')) continue;
    final parentName = _basename(entity.parent.path);
    final expectedName = '${parentName}_screen.dart';
    final screenClasses = RegExp(r'class\s+\w+ScreenPreview\b')
        .allMatches(await entity.readAsString())
        .length;
    if (_basename(entity.path) != expectedName || screenClasses != 1) {
      violations.add(
        Violation(
          'screen-file-contract',
          _relative(root, entity.path),
          'one screen per screens/<screen>/<screen>_screen.dart file is required',
        ),
      );
    }
  }

  return violations;
}

List<Violation> _sourceViolations(String path, String source) {
  final normalized = path.replaceAll('\\', '/');
  final isGenerated = normalized.endsWith('/tokens/tokens.g.dart');
  final isCompositionTheme = normalized.endsWith(
    '/design_system/theme/tournament_theme.dart',
  );
  final isComponent = normalized.contains('design_system/components/');
  final isQrCodeAdapter = normalized.contains(
    'design_system/components/qr_code/',
  );
  final isScreen =
      normalized.endsWith('_screen.dart') &&
      normalized.contains('presentation/screens/');
  final violations = <Violation>[];

  if (source.contains("package:pretty_qr_code/") && !isQrCodeAdapter) {
    violations.add(
      Violation(
        'qr-renderer-boundary',
        path,
        'pretty_qr_code may be imported only by QrCode adapter',
      ),
    );
  }

  if (!isGenerated && !isCompositionTheme) {
    if (RegExp(
      r'\b(?:Colors|CupertinoColors)\.|\bColor(?:\.from(?:ARGB|RGBO)|\s*\(\s*0x)|'
      r'#[0-9A-Fa-f]{6,8}',
    ).hasMatch(source)) {
      violations.add(
        Violation('raw-color', path, 'raw Color/Colors value is forbidden'),
      );
    }
    final rawVisualPatterns = <RegExp>[
      RegExp(r'EdgeInsets\.[A-Za-z]+\s*\([^)]*\d'),
      RegExp(r'BorderRadius\.circular\s*\(\s*\d'),
      RegExp(
        r'SizedBox(?:\.square)?\s*\([^)]*(?:width|height|dimension)\s*:\s*\d',
      ),
      RegExp(r'Duration\s*\([^)]*\d'),
      RegExp(r'TextStyle\s*\([^)]*(?:fontSize|height)\s*:\s*\d'),
      RegExp(r'withValues\s*\([^)]*alpha\s*:\s*\d'),
      RegExp(r'Opacity\s*\([^)]*opacity\s*:\s*\d'),
      RegExp(r'Border\.all\s*\([^)]*width\s*:\s*\d'),
    ];
    if (rawVisualPatterns.any((pattern) => pattern.hasMatch(source))) {
      violations.add(
        Violation(
          'raw-visual-value',
          path,
          'visual dimensions, typography and motion must come from a theme',
        ),
      );
    }
  }

  if (isComponent &&
      (source.contains('tokens.g.dart') ||
          source.contains('TournamentTokens'))) {
    violations.add(
      Violation(
        'component-token-import',
        path,
        'runtime components may read only their own component theme',
      ),
    );
  }

  if (isScreen) {
    for (final match in RegExp(r"import\s+'([^']+)';").allMatches(source)) {
      final import = match.group(1)!;
      if (import != 'package:flutter/widgets.dart' &&
          import != '../../design_system/design_system.dart') {
        violations.add(
          Violation(
            'screen-import-boundary',
            path,
            'screen import $import bypasses the public design-system API',
          ),
        );
      }
    }
    final forbiddenWidgets = RegExp(
      r'\b(?:Scaffold|Card|Text|Icon|TextField|ElevatedButton|OutlinedButton|'
      r'TextButton|ListTile|SwitchListTile|NavigationBar|NavigationRail|'
      r'CircularProgressIndicator|Dialog|Container|DecoratedBox|Padding|SizedBox)\s*\(',
    );
    if (forbiddenWidgets.hasMatch(source)) {
      violations.add(
        Violation(
          'screen-visual-primitive',
          path,
          'screen must compose public design-system components only',
        ),
      );
    }
  }

  return violations;
}

String _join(
  String first, [
  String? second,
  String? third,
  String? fourth,
  String? fifth,
]) => [
  first,
  second,
  third,
  fourth,
  fifth,
].whereType<String>().join(Platform.pathSeparator);

String _relative(Directory root, String path) =>
    path.substring(root.path.length + 1).replaceAll('\\', '/');

String _basename(String path) => path.split(RegExp(r'[/\\]')).last;
