import 'dart:io';

import '../bin/check_flutter_architecture.dart' as architecture;

void main() => _ReadabilityTests.run();

abstract final class _ReadabilityTests {
  static void run() {
    final cases =
        <
          ({String name, String source, String? rule, String path, int? line})
        >[];
    void add(
      String name,
      String source,
      String? rule, {
      String path = 'lib/domain/example.dart',
      int? line,
    }) {
      cases.add((
        name: name,
        source: source,
        rule: rule,
        path: path,
        line: line,
      ));
    }

    for (final name in [
      't',
      'i',
      'x',
      '_t',
      'ctx',
      'cfg',
      'args',
      'themeCtx',
      'appCfg',
    ]) {
      add(
        'reject local $name',
        'class Example { void run() { final $name = 1; } }',
        'R-008.a',
      );
    }
    add('field', 'class Example { final t = 1; }', 'R-008.a');
    add('parameter', 'class Example { void run(int t) {} }', 'R-008.a');
    add(
      'named parameter',
      'class Example { void run({required int t}) {} }',
      'R-008.a',
    );
    add(
      'closure parameter',
      'class Example { final callback = (int t) => t; }',
      'R-008.a',
    );
    add(
      'loop variable',
      'class Example { void run() { for (var i = 0; i < 3; i++) {} } }',
      'R-008.a',
    );
    add(
      'catch parameter',
      'class Example { void run() { try {} catch (e) {} } }',
      'R-008.a',
    );
    add(
      'multiple declarations',
      'class Example { void run() { final count = 1, t = 2; } }',
      'R-008.a',
    );
    add(
      'pattern variable',
      'class Example { void run() { final (t, count) = (1, 2); } }',
      'R-008.a',
    );
    add(
      'test scope',
      'void main() { final t = 1; }',
      'R-008.a',
      path: 'test/example_test.dart',
    );
    add(
      'diagnostic line',
      'class Example {\n void run() {\n final t = 1;\n }\n}',
      'R-008.a',
      line: 3,
    );
    add(
      'ignore cannot bypass',
      'class Example {\n // ignore: readable_names\n final t = 1;\n}',
      'R-008.a',
    );
    add(
      'descriptive names and standard identifiers',
      'class Example { void run(int participantCount, String id, String url, String uri) { final theme = participantCount; } }',
      null,
    );
    add(
      'wildcard is not a variable',
      'class Example { void run() { final _ = 1; } }',
      null,
    );
    add(
      'generic type parameter is not variable',
      'class Example<T> { T run(T value) => value; }',
      null,
    );
    add(
      'substrings are not abbreviations',
      'class Example { final context = 1, configuration = 2, arguments = 3, texture = 4; }',
      null,
    );
    add(
      'comments and strings',
      'class Example { final description = "t ctx cfg a ? b : c ? d : e"; /* final t = 1; */ }',
      null,
    );

    const painterImport = "import 'package:flutter/rendering.dart';\n";
    const painterPath =
        'lib/presentation/design_system/foundation/example_painter.dart';
    add(
      'numeric coordinates in paint',
      '${painterImport}class ExamplePainter extends CustomPainter { @override void paint(Canvas canvas, Size size) { final double x = 1; final num y = 2; } @override bool shouldRepaint(covariant ExamplePainter oldDelegate) => false; }',
      null,
      path: painterPath,
    );
    add(
      'capsule subclass name cannot allow t',
      '${painterImport}class ExamplePainter extends CustomPainter { @override void paint(Canvas canvas, Size size) { final t = 1; } }',
      'R-008.a',
      path: painterPath,
    );
    add(
      'x outside paint',
      '${painterImport}class ExamplePainter extends CustomPainter { final double x = 1; void paint(Canvas canvas, Size size) {} }',
      'R-008.a',
      path: painterPath,
    );
    add(
      'x is not a numeric coordinate',
      '${painterImport}class ExamplePainter extends CustomPainter { void paint(Canvas canvas, Size size) { final String x = "wrong"; } }',
      'R-008.a',
      path: painterPath,
    );
    add(
      'Painter suffix alone not exemption',
      'class ExamplePainter { void paint() { final double x = 1; } }',
      'R-008.a',
      path: painterPath,
    );
    add(
      'nested closure not paint scope',
      '${painterImport}class ExamplePainter extends CustomPainter { void paint(Canvas canvas, Size size) { final callback = () { final double x = 1; }; } }',
      'R-008.a',
      path: painterPath,
    );

    const declaration =
        'class Example { bool get enabled => true; bool get selected => false; int run() => ';
    add('simple conditional', '${declaration}enabled ? 1 : 2; }', null);
    add(
      'else branch nested',
      '${declaration}enabled ? 1 : selected ? 2 : 3; }',
      'R-008.b',
    );
    add(
      'then branch nested',
      '${declaration}enabled ? (selected ? 1 : 2) : 3; }',
      'R-008.b',
    );
    add(
      'condition nested',
      '${declaration}(enabled ? selected : false) ? 1 : 2; }',
      'R-008.b',
    );
    add(
      'nested expression inside argument',
      '${declaration}enabled ? identity(selected ? 1 : 2) : 3; int identity(int value) => value; }',
      'R-008.b',
    );
    add(
      'method extraction cannot hide nesting',
      '${declaration}resolve(); int resolve() => enabled ? 1 : (selected ? 2 : 3); }',
      'R-008.b',
    );
    add(
      'independent conditionals',
      'class Example { int run(bool enabled, bool selected) { final first = enabled ? 1 : 2; final second = selected ? 3 : 4; return first + second; } }',
      null,
    );
    add(
      'named explicit branches',
      'class Example { int resolve(bool enabled, bool selected) { if (enabled) return 1; if (selected) return 2; return 3; } }',
      null,
    );
    add(
      'null coalescing is not conditional',
      'class Example { int run(int? value) => value ?? 1; }',
      null,
    );
    add(
      'all rules in tests',
      'void main() { final result = true ? 1 : (false ? 2 : 3); }',
      'R-008.b',
      path: 'test/example_test.dart',
    );

    final failures = <String>[];
    for (final item in cases) {
      final findings = architecture.inspect({
        item.path: item.source,
      }, 'fixture');
      if (item.rule == null) {
        if (findings.isNotEmpty)
          failures.add('${item.name}: unexpected $findings');
      } else {
        final prefix = item.line == null
            ? '${item.path}:'
            : '${item.path}:${item.line} ';
        if (!findings.any(
          (finding) =>
              finding.startsWith(prefix) && finding.contains('${item.rule}:'),
        )) {
          failures.add('${item.name}: expected ${item.rule}, actual $findings');
        }
      }
    }
    if (failures.isNotEmpty) {
      stderr.writeln(failures.join('\n'));
      stderr.writeln(
        'Readability tests: ${failures.length}/${cases.length} failed.',
      );
      exitCode = 1;
    } else {
      stdout.writeln('Readability tests: ${cases.length} passed.');
    }
  }
}
