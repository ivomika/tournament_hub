import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/main_widgetbook.dart' as widgetbook_entrypoint;
import 'package:widgetbook/widgetbook.dart';

void main() {
  testWidgets(
    'Widgetbook starts with an empty catalogue',
    _startsEmptyCatalogue,
  );
  test(
    'VS Code launches app and Widgetbook independently',
    _launchesSeparateEntrypoints,
  );
}

Future<void> _startsEmptyCatalogue(WidgetTester tester) async {
  widgetbook_entrypoint.main();
  await tester.pumpAndSettle();

  final rootFinder = find.byType(Widgetbook);
  expect(rootFinder, findsOneWidget);
  final root = tester.widget<Widgetbook>(rootFinder);
  expect(root.directories, isEmpty);
  expect(root.addons, anyOf(isNull, isEmpty));
  expect(root.integrations, anyOf(isNull, isEmpty));
  expect(tester.takeException(), isNull);
}

void _launchesSeparateEntrypoints() {
  final source = File('../../.vscode/launch.json').readAsStringSync();
  final payload = jsonDecode(source);
  if (payload is! Map<String, Object?>) {
    throw const FormatException('Invalid launch payload');
  }
  final entries = payload['configurations'];
  if (entries is! List<Object?>) {
    throw const FormatException('Missing launch configurations');
  }
  final configurations = <Map<String, Object?>>[];
  for (final entry in entries) {
    if (entry is! Map<String, Object?>) {
      throw const FormatException('Invalid launch entry');
    }
    configurations.add(entry);
  }
  final widgetbook = configurations.singleWhere(_isWidgetbookLaunch);
  final application = configurations.singleWhere(_isApplicationLaunch);
  for (final configuration in [widgetbook, application]) {
    expect(configuration['type'], 'dart');
    expect(configuration['request'], 'launch');
    expect(configuration['cwd'], r'${workspaceFolder}/apps/tournament_app');
    expect(configuration.containsKey('deviceId'), isFalse);
  }
  expect(File('lib/main_widgetbook.dart').existsSync(), isTrue);
  expect(File('lib/main.dart').existsSync(), isTrue);
}

bool _isWidgetbookLaunch(Map<String, Object?> configuration) =>
    configuration['program'] ==
    r'${workspaceFolder}/apps/tournament_app/lib/main_widgetbook.dart';

bool _isApplicationLaunch(Map<String, Object?> configuration) =>
    configuration['program'] ==
    r'${workspaceFolder}/apps/tournament_app/lib/main.dart';
