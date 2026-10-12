import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

enum Layer { app, domain, infrastructure, presentation, entrypoint, test }

const domainSdk = {
  'core',
  'async',
  'collection',
  'convert',
  'math',
  'typed_data',
};
const domainPackages = <String>{};
const allowed = {
  Layer.app: {
    Layer.app,
    Layer.domain,
    Layer.infrastructure,
    Layer.presentation,
  },
  Layer.domain: {Layer.domain},
  Layer.infrastructure: {Layer.infrastructure, Layer.domain},
  Layer.presentation: {Layer.presentation, Layer.domain},
  Layer.entrypoint: {Layer.app},
  Layer.test: {
    Layer.app,
    Layer.domain,
    Layer.infrastructure,
    Layer.presentation,
  },
};

Layer? layerOf(String file) {
  if (file.startsWith('test/')) return Layer.test;
  if (!file.startsWith('lib/')) return null;
  final parts = file.substring(4).split('/');
  if (parts.length == 1 &&
      RegExp(r'^main(?:_[a-z0-9_]+)?\.dart$').hasMatch(parts.first))
    return Layer.entrypoint;
  return switch (parts.first) {
    'app' => Layer.app,
    'domain' => Layer.domain,
    'infrastructure' => Layer.infrastructure,
    'presentation' => Layer.presentation,
    _ => null,
  };
}

List<String> inspect(Map<String, String> sources, String packageName) {
  final problems = <String>[];
  for (final entry in sources.entries) {
    final sourceLayer = layerOf(entry.key);
    void report(int offset, String message) {
      final line = '\n'.allMatches(entry.value.substring(0, offset)).length + 1;
      problems.add('${entry.key}:$line R-003.e: $message');
    }

    if (sourceLayer == null) report(0, 'Неизвестный слой/расположение файла');
    final parsed = parseString(
      content: entry.value,
      path: entry.key,
      throwIfDiagnostics: false,
    );
    if (parsed.errors.isNotEmpty) {
      for (final error in parsed.errors)
        report(error.offset, 'Синтаксическая ошибка: ${error.message}');
      continue;
    }
    void checkUri(String? raw, int offset, {bool isImport = false}) {
      final uri = raw == null ? null : Uri.tryParse(raw);
      if (uri == null ||
          !{'package', 'dart'}.contains(uri.scheme) ||
          uri.hasAuthority ||
          uri.hasQuery ||
          uri.hasFragment ||
          raw!.contains('\\') ||
          uri.pathSegments.any(
            (part) =>
                part.isEmpty ||
                part == '.' ||
                part == '..' ||
                part.contains('/') ||
                part.contains('\\'),
          )) {
        report(offset, 'Запрещённый или относительный URI: $raw');
        return;
      }
      if (uri.scheme == 'dart') {
        if (sourceLayer == Layer.domain && !domainSdk.contains(uri.path))
          report(offset, 'Domain зависит от платформенного SDK: $raw');
        return;
      }
      final segments = uri.pathSegments;
      if (segments.length < 2 || !uri.path.endsWith('.dart')) {
        report(offset, 'Неполный package URI: $raw');
        return;
      }
      if (segments.first != packageName) {
        if (sourceLayer == Layer.domain &&
            !domainPackages.contains(segments.first))
          report(offset, 'Неутверждённый domain-пакет: ${segments.first}');
        return;
      }
      final target = 'lib/${segments.skip(1).join('/')}';
      final targetLayer = layerOf(target);
      final testWidgetbookEntry =
          isImport &&
          sourceLayer == Layer.test &&
          target == 'lib/main_widgetbook.dart';
      if (!sources.containsKey(target))
        report(offset, 'Не существует package-цель: $target');
      if (targetLayer == null)
        report(offset, 'Неизвестный слой package-цели: $target');
      else if (sourceLayer != null &&
          !testWidgetbookEntry &&
          !(allowed[sourceLayer]?.contains(targetLayer) ?? false))
        report(
          offset,
          'Запрещённая зависимость ${sourceLayer.name} → ${targetLayer.name}: $raw',
        );
    }

    for (final directive in parsed.unit.directives) {
      if (directive is UriBasedDirective) {
        checkUri(
          directive.uri.stringValue,
          directive.offset,
          isImport: directive is ImportDirective,
        );
        final configurations = switch (directive) {
          ImportDirective() => directive.configurations,
          ExportDirective() => directive.configurations,
          _ => <Configuration>[],
        };
        for (final configuration in configurations)
          checkUri(
            configuration.uri.stringValue,
            configuration.offset,
            isImport: directive is ImportDirective,
          );
      } else if (directive is PartOfDirective) {
        checkUri(directive.uri?.stringValue, directive.offset);
      }
    }
  }
  return problems;
}

void selfTest() {
  const base = {
    'lib/app/bootstrap.dart': '',
    'lib/domain/model.dart': '',
    'lib/infrastructure/store.dart': '',
    'lib/presentation/screen.dart': '',
  };
  final cases = <({String name, Map<String, String> source, bool pass})>[
    (
      name: 'allowed matrix',
      source: {
        'lib/app/bootstrap.dart':
            "import 'package:fixture/infrastructure/store.dart'; import 'package:fixture/presentation/screen.dart';",
        'lib/infrastructure/store.dart':
            "import 'package:fixture/domain/model.dart';",
        'lib/presentation/screen.dart':
            "import 'package:fixture/domain/model.dart';",
        'lib/main.dart': "import 'package:fixture/app/bootstrap.dart';",
        'test/model_test.dart': "import 'package:fixture/domain/model.dart';",
      },
      pass: true,
    ),
    (
      name: 'comments and string data',
      source: {
        'lib/domain/model.dart':
            "// import 'x.dart';\nconst data = \"import 'x.dart';\";",
      },
      pass: true,
    ),
    (
      name: 'pure SDK',
      source: {'lib/domain/model.dart': "import 'dart:math';"},
      pass: true,
    ),
    (
      name: 'relative import',
      source: {'lib/domain/model.dart': "import 'model.dart';"},
      pass: false,
    ),
    (
      name: 'presentation to infrastructure',
      source: {
        'lib/presentation/screen.dart':
            "import 'package:fixture/infrastructure/store.dart';",
      },
      pass: false,
    ),
    (
      name: 'infrastructure to presentation',
      source: {
        'lib/infrastructure/store.dart':
            "import 'package:fixture/presentation/screen.dart';",
      },
      pass: false,
    ),
    (
      name: 'domain to app',
      source: {
        'lib/domain/model.dart': "import 'package:fixture/app/bootstrap.dart';",
      },
      pass: false,
    ),
    (
      name: 'domain to Flutter',
      source: {
        'lib/domain/model.dart': "import 'package:flutter/widgets.dart';",
      },
      pass: false,
    ),
    (
      name: 'domain to IO',
      source: {'lib/domain/model.dart': "import 'dart:io';"},
      pass: false,
    ),
    (
      name: 're-export bypass',
      source: {
        'lib/domain/model.dart':
            "export 'package:fixture/infrastructure/store.dart';",
      },
      pass: false,
    ),
    (
      name: 'conditional import',
      source: {
        'lib/domain/model.dart':
            "import 'dart:math' if (dart.library.io) 'dart:io';",
      },
      pass: false,
    ),
    (
      name: 'conditional export',
      source: {
        'lib/presentation/screen.dart':
            "export 'package:fixture/domain/model.dart' if (dart.library.io) 'package:fixture/app/bootstrap.dart';",
      },
      pass: false,
    ),
    (
      name: 'relative part',
      source: {'lib/domain/model.dart': "part 'model.g.dart';"},
      pass: false,
    ),
    (
      name: 'part layer bypass',
      source: {
        'lib/domain/model.dart':
            "part 'package:fixture/presentation/screen.dart';",
      },
      pass: false,
    ),
    (
      name: 'part of relative',
      source: {'lib/domain/model.dart': "part of 'model.dart';"},
      pass: false,
    ),
    (
      name: 'named part of',
      source: {'lib/domain/model.dart': 'part of model;'},
      pass: false,
    ),
    (
      name: 'unknown directory',
      source: {'lib/presentaton/screen.dart': ''},
      pass: false,
    ),
    (
      name: 'missing target',
      source: {
        'lib/app/bootstrap.dart':
            "import 'package:fixture/domain/missing.dart';",
      },
      pass: false,
    ),
    (
      name: 'root barrel',
      source: {
        'lib/barrel.dart': "export 'package:fixture/domain/model.dart';",
      },
      pass: false,
    ),
    (
      name: 'entrypoint bypass',
      source: {
        'lib/main.dart': "import 'package:fixture/infrastructure/store.dart';",
      },
      pass: false,
    ),
    (
      name: 'encoded traversal',
      source: {
        'lib/presentation/screen.dart':
            "import 'package:fixture/domain/%2e%2e/infrastructure/store.dart';",
      },
      pass: false,
    ),
    (
      name: 'test relative',
      source: {'test/model_test.dart': "import '../lib/domain/model.dart';"},
      pass: false,
    ),
    (
      name: 'invalid Dart',
      source: {'lib/domain/model.dart': 'class {'},
      pass: false,
    ),
    (
      name: 'test imports Widgetbook entry',
      source: {
        'lib/main_widgetbook.dart': 'void main() {}',
        'test/widgetbook_test.dart':
            "import 'package:fixture/main_widgetbook.dart';",
      },
      pass: true,
    ),
    (
      name: 'conditional test imports Widgetbook entry',
      source: {
        'lib/main_widgetbook.dart': 'void main() {}',
        'test/widgetbook_test.dart':
            "import 'dart:math' if (dart.library.io) 'package:fixture/main_widgetbook.dart';",
      },
      pass: true,
    ),
    (
      name: 'test cannot import other entry',
      source: {
        'lib/main.dart': 'void main() {}',
        'test/main_test.dart': "import 'package:fixture/main.dart';",
      },
      pass: false,
    ),
    (
      name: 'test cannot export Widgetbook entry',
      source: {
        'lib/main_widgetbook.dart': 'void main() {}',
        'test/widgetbook_test.dart':
            "export 'package:fixture/main_widgetbook.dart';",
      },
      pass: false,
    ),
    (
      name: 'test cannot part Widgetbook entry',
      source: {
        'lib/main_widgetbook.dart': 'void main() {}',
        'test/widgetbook_test.dart':
            "part 'package:fixture/main_widgetbook.dart';",
      },
      pass: false,
    ),
    (
      name: 'test cannot use missing Widgetbook entry',
      source: {
        'test/widgetbook_test.dart':
            "import 'package:fixture/main_widgetbook.dart';",
      },
      pass: false,
    ),
  ];
  for (final layer in [
    Layer.app,
    Layer.domain,
    Layer.infrastructure,
    Layer.presentation,
  ]) {
    final file = base.keys.singleWhere(
      (file) => file.startsWith('lib/${layer.name}/'),
    );
    cases.add((
      name: '${layer.name} cannot import Widgetbook entry',
      source: {
        'lib/main_widgetbook.dart': 'void main() {}',
        file: "import 'package:fixture/main_widgetbook.dart';",
      },
      pass: false,
    ));
  }
  for (final scenario in cases) {
    final findings = inspect({...base, ...scenario.source}, 'fixture');
    if (findings.isEmpty != scenario.pass)
      throw StateError('Failed ${scenario.name}: $findings');
  }
  const runtimeLayers = [
    Layer.app,
    Layer.domain,
    Layer.infrastructure,
    Layer.presentation,
  ];
  const forbiddenPairs = {
    (Layer.domain, Layer.app),
    (Layer.domain, Layer.infrastructure),
    (Layer.domain, Layer.presentation),
    (Layer.infrastructure, Layer.app),
    (Layer.infrastructure, Layer.presentation),
    (Layer.presentation, Layer.app),
    (Layer.presentation, Layer.infrastructure),
  };
  for (final from in runtimeLayers) {
    for (final to in runtimeLayers) {
      final files = {
        for (final layer in runtimeLayers) 'lib/${layer.name}/entry.dart': '',
      };
      files['lib/${from.name}/entry.dart'] =
          "import 'package:fixture/${to.name}/entry.dart';";
      final findings = inspect(files, 'fixture');
      if (findings.isEmpty == forbiddenPairs.contains((from, to)))
        throw StateError('Matrix failure: $from → $to');
    }
  }
  stdout.writeln('Architecture self-tests: ${cases.length + 16} passed.');
}

void main(List<String> arguments) {
  if (arguments.contains('--self-test')) {
    selfTest();
    return;
  }
  final root = Directory('../../apps/tournament_app');
  final pubspec = File('${root.path}/pubspec.yaml');
  final name = RegExp(
    r'^name:\s*([a-z][a-z0-9_]*)\s*$',
    multiLine: true,
  ).firstMatch(pubspec.readAsStringSync())?.group(1);
  if (name == null || !Directory('${root.path}/lib').existsSync())
    throw StateError('Не найден Flutter-клиент');
  final sources = <String, String>{};
  for (final subfolder in ['lib', 'test']) {
    final directory = Directory('${root.path}/$subfolder');
    if (!directory.existsSync()) continue;
    for (final file
        in directory
            .listSync(recursive: true, followLinks: false)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))) {
      final relative = file.path
          .substring(root.path.length + 1)
          .replaceAll('\\', '/');
      sources[relative] = file.readAsStringSync();
    }
  }
  final problems = inspect(sources, name);
  if (problems.isNotEmpty) {
    stderr.writeln(problems.join('\n'));
    exitCode = 1;
  } else
    stdout.writeln(
      'Архитектура Flutter: ${sources.length} файлов, нарушений импортов нет.',
    );
}
