import 'dart:convert';
import 'dart:io';

import 'package:tournament_app/presentation/widgetbook/components/number_stepper/stepper_fixture.dart';

import 'package:tournament_app/presentation/widgetbook/components/segmented_choice/segmented_fixture.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/borders/catalog/catalog_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgetbook_app.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/main_widgetbook.dart' as widgetbook_entrypoint;
import 'package:widgetbook/widgetbook.dart';

void main() => _WidgetbookBootstrapTests.run();

abstract final class _WidgetbookBootstrapTests {
  static void run() {
    testWidgets(
      'stepper preview keeps natural height in mobile and desktop viewport',
      _stepperViewport,
    );
    testWidgets(
      'segmented preview keeps natural height in mobile and desktop viewport',
      _segmentedViewport,
    );
    testWidgets(
      'Widgetbook starts with foundation catalogue',
      _startsFoundationCatalogue,
    );
    testWidgets(
      'every registered use case opens in actual workbench',
      _opensEveryUseCase,
    );
    testWidgets(
      'viewport presets reach actual preview constraints and MediaQuery',
      _viewports,
    );
    test(
      'VS Code launches app and Widgetbook independently',
      _launchesSeparateEntrypoints,
    );
  }

  static Future<void> _startsFoundationCatalogue(WidgetTester tester) async {
    widgetbook_entrypoint.main();
    await tester.pumpAndSettle();

    final rootFinder = find.byType(Widgetbook);
    expect(rootFinder, findsOneWidget);
    final root = tester.widget<Widgetbook>(rootFinder);
    expect(
      root.directories.map((node) => node.name),
      unorderedEquals(['Foundation', 'Components', 'Widgets']),
    );
    final foundation = root.directories.singleWhere(
      (node) => node.name == 'Foundation',
    );
    final components = root.directories.singleWhere(
      (node) => node.name == 'Components',
    );
    final widgets = root.directories.singleWhere(
      (node) => node.name == 'Widgets',
    );
    expect(
      foundation.children!.map((node) => node.name),
      containsAll(['Colors', 'Typography', 'Icons']),
    );
    expect(
      components.children!.map((node) => node.name),
      containsAll(['Avatar', 'Surface', 'Button']),
    );
    expect(
      widgets.children!.map((node) => node.name),
      containsAll(['Identity', 'Roster row']),
    );
    expect(root.addons!.whereType<ViewportAddon>(), hasLength(1));
    expect(root.integrations, anyOf(isNull, isEmpty));
    expect(tester.takeException(), isNull);
  }

  static Future<void> _opensEveryUseCase(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1440, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    widgetbook_entrypoint.main();
    await tester.pumpAndSettle();
    final book = tester.widget<Widgetbook>(find.byType(Widgetbook));
    final cases = WidgetbookRoot(children: book.directories).leaves
        .whereType<WidgetbookUseCase>()
        .toList();
    expect(cases.length, 101);
    for (final useCase in cases) {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(
        TournamentWidgetbookApp(
          theme: AppTheme.dark(),
          initialRoute: Uri(
            path: '/',
            queryParameters: {'path': useCase.path},
          ).toString(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        tester.takeException(),
        isNull,
        reason: 'Use case: ${useCase.path}',
      );
    }
    await tester.pumpWidget(const SizedBox.shrink());
  }

  static Future<void> _viewports(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1600, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    for (final preset in WidgetbookViewports.values.skip(1)) {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(
        TournamentWidgetbookApp(
          theme: AppTheme.dark(),
          initialRoute: Uri(
            path: '/',
            queryParameters: {
              'path': 'foundation/borders/border-roles-/-selected-/-error',
              'viewport': '{name:${Uri.encodeComponent(preset.name)}}',
            },
          ).toString(),
        ),
      );
      await tester.pumpAndSettle();
      final fixture = find.byType(BorderCatalogFixture);
      expect(fixture, findsOneWidget);
      final context = tester.element(fixture);
      expect(MediaQuery.sizeOf(context), preset.size);
      final box = tester.renderObject<RenderBox>(fixture);
      expect(box.constraints.maxWidth, preset.width);
      expect(box.constraints.maxHeight, preset.height);
      expect(tester.takeException(), isNull);
    }
  }

  static Future<void> _segmentedViewport(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1600, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    for (final preset in WidgetbookViewports.values.skip(1)) {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(
        TournamentWidgetbookApp(
          theme: AppTheme.dark(),
          initialRoute: Uri(
            path: '/',
            queryParameters: {
              'path': 'components/segmented-choice/selected',
              'viewport': '{name:${Uri.encodeComponent(preset.name)}}',
            },
          ).toString(),
        ),
      );
      await tester.pumpAndSettle();
      final fixture = find.byType(SegmentedFixture);
      expect(fixture, findsOneWidget);
      expect(MediaQuery.sizeOf(tester.element(fixture)), preset.size);
      expect(tester.getSize(fixture).height, 64);
      expect(tester.takeException(), isNull);
    }
  }

  static Future<void> _stepperViewport(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1600, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    for (final preset in WidgetbookViewports.values.skip(1)) {
      for (final useCase in ['format', 'score']) {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpWidget(
          TournamentWidgetbookApp(
            theme: AppTheme.dark(),
            initialRoute: Uri(
              path: '/',
              queryParameters: {
                'path': 'components/number-stepper/$useCase',
                'viewport': '{name:${Uri.encodeComponent(preset.name)}}',
              },
            ).toString(),
          ),
        );
        await tester.pumpAndSettle();
        final fixture = find.byType(StepperFixture);
        expect(fixture, findsOneWidget);
        expect(MediaQuery.sizeOf(tester.element(fixture)), preset.size);
        expect(
          tester.getSize(fixture).height,
          56,
          reason: '$useCase / ${preset.name}',
        );
        expect(tester.takeException(), isNull);
      }
    }
  }

  static void _launchesSeparateEntrypoints() {
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

  static bool _isWidgetbookLaunch(Map<String, Object?> configuration) =>
      configuration['program'] ==
      r'${workspaceFolder}/apps/tournament_app/lib/main_widgetbook.dart';

  static bool _isApplicationLaunch(Map<String, Object?> configuration) =>
      configuration['program'] ==
      r'${workspaceFolder}/apps/tournament_app/lib/main.dart';
}
