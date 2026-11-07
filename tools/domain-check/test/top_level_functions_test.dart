import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

import '../bin/check_flutter_architecture.dart' as architecture;

void main(List<String> arguments) {
  if (arguments.contains('--inventory')) {
    inventory();
    return;
  }
  const source = 'lib/domain/example.dart';
  const lookup =
      'lib/presentation/l10n/generated/foundation_localizations.dart';
  const hook = 'test/flutter_test_config.dart';
  final cases =
      <
        ({String name, Map<String, String> files, String? rejected, int? line})
      >[];
  void reject(String name, String content, {String file = source, int? line}) {
    cases.add((name: name, files: {file: content}, rejected: file, line: line));
  }

  void accept(String name, String content, {String file = source}) {
    cases.add((name: name, files: {file: content}, rejected: null, line: null));
  }

  reject('public function', 'int sum(int a, int b) => a + b;');
  reject('private function', 'void _work() {}');
  reject('implicit return type', 'work() {}');
  reject('generic function', 'T identity<T>(T value) => value;');
  reject('async function', 'Future<void> work() async {}');
  reject('sync generator', 'Iterable<int> values() sync* { yield 1; }');
  reject('async generator', 'Stream<int> values() async* { yield 1; }');
  reject('block body', 'int work() { return 1; }');
  reject('getter', 'int get count => 1;');
  reject('setter', 'set count(int value) {}');
  reject('external function', 'external void work();');
  reject('lambda variable', 'final callback = () {};');
  reject('parenthesized lambda', 'final callback = ((() => 1));');
  reject('typed lambda variable', 'void Function() callback = () {};');
  reject(
    'test helpers are not exempt',
    'void helper() {}',
    file: 'test/example_test.dart',
  );
  reject(
    'builder name is not exempt',
    'Object buildPreview(Object context) => context;',
    file: 'lib/presentation/widgetbook/preview.dart',
  );
  reject('main in domain is not entrypoint', 'void main() {}');
  reject(
    'main in test helper is not entrypoint',
    'void main() {}',
    file: 'test/support.dart',
  );
  reject('fake main getter', 'int get main => 1;', file: 'lib/main.dart');
  reject('fake hook getter', 'int get testExecutable => 1;', file: hook);
  reject(
    'hook in wrong file',
    'void testExecutable() {}',
    file: 'test/support.dart',
  );
  reject(
    'helper next to hook',
    'void testExecutable() {}\nvoid helper() {}',
    file: hook,
    line: 2,
  );
  reject(
    'helper next to app main',
    'void main() {}\nvoid helper() {}',
    file: 'lib/main.dart',
    line: 2,
  );
  reject(
    'helper next to test main',
    'void main() {}\nvoid helper() {}',
    file: 'test/example_test.dart',
    line: 2,
  );
  reject(
    'generated directory is not exempt',
    'void helper() {}',
    file: 'lib/presentation/l10n/generated/other.dart',
  );
  reject(
    'helper next to generated lookup',
    'Object lookupFoundationLocalizations(Object locale) => locale;\nvoid helper() {}',
    file: lookup,
    line: 2,
  );
  reject(
    'lookup in wrong file',
    'Object lookupFoundationLocalizations(Object locale) => locale;',
  );
  reject(
    'ignore cannot bypass rule',
    '// ignore: top_level_functions\nvoid helper() {}',
    line: 2,
  );
  reject('exact diagnostic line', '// fixture\n\nvoid helper() {}', line: 3);
  cases.add((
    name: 'part cannot bypass rule',
    files: {
      source: "part 'package:fixture/domain/example_part.dart';",
      'lib/domain/example_part.dart':
          "part of 'package:fixture/domain/example.dart';\nvoid helper() {}",
    },
    rejected: 'lib/domain/example_part.dart',
    line: 2,
  ));

  accept('class instance method', 'class Work { int run() => 1; }');
  accept(
    'class static method',
    'abstract final class Work { static void run() {} }',
  );
  accept(
    'class accessors',
    'class Work { int get count => 1; set count(int value) {} }',
  );
  accept('enum methods', 'enum Work { one; void run() {} }');
  accept('mixin method', 'mixin Work { void run() {} }');
  accept(
    'extension method',
    'extension Work on int { int twice() => this * 2; }',
  );
  accept('typedef is a type', 'typedef Handler = void Function();');
  accept(
    'data and method tear-off',
    'abstract final class Work { static void run() {} } final callback = Work.run; const count = 1;',
  );
  accept('lambda as class field', 'class Work { final callback = () {}; }');
  accept(
    'local function is not top-level',
    'class Work { void run() { void local() {} local(); } }',
  );
  accept(
    'comments and strings',
    "// void helper() {}\nconst example = 'void helper() {}';",
  );
  accept('app main', 'void main() {}', file: 'lib/main.dart');
  accept(
    'alternate entrypoint',
    'Future<void> main() async {}',
    file: 'lib/main_widgetbook.dart',
  );
  accept(
    'test runner main',
    'void main() {}',
    file: 'test/domain/example_test.dart',
  );
  accept(
    'Flutter test hook',
    'Future<void> testExecutable(Future<void> Function() run) async { await run(); }',
    file: hook,
  );
  accept(
    'SDK generated lookup',
    'Object lookupFoundationLocalizations(Object locale) => locale;',
    file: lookup,
  );

  reject(
    'annotated diagnostic points to declaration',
    '@deprecated\nvoid helper() {}',
    line: 2,
  );
  reject(
    'multiple variables cannot hide lambda',
    'final data = 1, callback = () => 2;',
  );
  cases.add((
    name: 'part cannot masquerade as test entrypoint',
    files: {
      source: "part 'package:fixture/domain/unused.dart';",
      'lib/domain/unused.dart': '',
      'test/part_test.dart':
          "part of 'package:fixture/domain/example.dart';\nvoid main() {}",
    },
    rejected: 'test/part_test.dart',
    line: 2,
  ));

  final failures = <String>[];
  for (final item in cases) {
    final findings = architecture.inspect(item.files, 'fixture');
    final ruleFindings = findings.where((f) => f.contains('R-003.g:')).toList();
    final rejected = item.rejected;
    if (rejected == null) {
      if (findings.isNotEmpty)
        failures.add('${item.name}: unexpected $findings');
    } else {
      final prefix = item.line == null
          ? '$rejected:'
          : '$rejected:${item.line} R-003.g:';
      if (!ruleFindings.any((finding) => finding.startsWith(prefix))) {
        failures.add(
          '${item.name}: expected R-003.g in $prefix; actual $findings',
        );
      }
    }
  }
  if (failures.isNotEmpty) {
    stderr.writeln(failures.join('\n'));
    stderr.writeln(
      'Top-level function tests: ${failures.length}/${cases.length} failed.',
    );
    exitCode = 1;
  } else {
    stdout.writeln('Top-level function tests: ${cases.length} passed.');
  }
}

// Read-only test harness inventory, not a production checker implementation.
void inventory() {
  final root = Directory('../../apps/tournament_app');
  var count = 0;
  for (final folder in ['lib', 'test']) {
    for (final file
        in Directory('${root.path}/$folder')
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))) {
      final unit = parseString(
        content: file.readAsStringSync(),
        throwIfDiagnostics: false,
      ).unit;
      for (final declaration
          in unit.declarations.whereType<FunctionDeclaration>()) {
        stdout.writeln(
          '${file.path.substring(root.path.length + 1)}: ${declaration.name.lexeme}',
        );
        count++;
      }
    }
  }
  stdout.writeln('Top-level declarations inventory: $count');
}
