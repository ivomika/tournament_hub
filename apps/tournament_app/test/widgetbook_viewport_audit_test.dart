import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgetbook_app.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/design_system/components/navigation_item/app_navigation_item.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface.dart';
import 'package:tournament_app/presentation/design_system/components/field/app_field.dart';
import 'package:tournament_app/presentation/design_system/components/notice/app_notice.dart';
import 'package:tournament_app/presentation/design_system/components/number_stepper/app_number_stepper.dart';
import 'package:tournament_app/presentation/design_system/components/score/app_score.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/components/progress_indicator/app_progress_indicator.dart';
import 'package:tournament_app/presentation/design_system/components/status_label/app_status_label.dart';
import 'package:tournament_app/presentation/design_system/components/score_choice/app_score_choice.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar.dart';
import 'package:tournament_app/presentation/design_system/components/select/app_select_sheet.dart';
import 'package:tournament_app/presentation/design_system/components/select/app_select.dart';
import 'package:tournament_app/presentation/design_system/components/metric/app_metric.dart';
import 'package:tournament_app/presentation/design_system/components/qr_code/app_qr_code.dart';
import 'package:tournament_app/presentation/design_system/components/segmented_choice/app_segmented_choice.dart';
import 'package:tournament_app/presentation/design_system/widgets/disclosure/app_disclosure.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity.dart';
import 'package:tournament_app/presentation/design_system/widgets/share_link/app_share_link.dart';
import 'package:tournament_app/presentation/design_system/widgets/bracket_node/app_bracket_node.dart';
import 'package:tournament_app/presentation/design_system/widgets/dialog/app_dialog.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/widgets/data_table/app_data_table.dart';
import 'package:tournament_app/presentation/design_system/widgets/roster_row/app_roster_row.dart';

void main() => _ViewportAudit.run();

/// Test-only capture instrumentation: real production appBuilder/addons and
/// registered builders; RepaintBoundary changes paint isolation, not constraints.
abstract final class _ViewportAudit {
  static const output = String.fromEnvironment('WIDGETBOOK_AUDIT_DIR');
  static const filter = String.fromEnvironment('WIDGETBOOK_AUDIT_FILTER');
  static final textScale = double.parse(
    const String.fromEnvironment(
      'WIDGETBOOK_AUDIT_TEXT_SCALE',
      defaultValue: '1',
    ),
  );
  static final shortDesktop = ViewportData(
    name: "Short Desktop 800 × 500",
    width: 800,
    height: 500,
    pixelRatio: 1,
    platform: TargetPlatform.macOS,
  );
  static void run() {
    for (final preset in [
      ...WidgetbookViewports.values.skip(1),
      shortDesktop,
    ]) {
      testWidgets(
        'all previews in ${preset.name}',
        (tester) => _audit(tester, preset),
      );
    }
  }

  static const _insetPaths = {
    'foundation/borders/actual-button-focus',
    'components/navigation-item/focused',
    'components/segmented-choice/focused',
    'components/field/single_line',
    'components/field/multiline',
  };

  static Future<void> _audit(WidgetTester tester, ViewportData preset) async {
    tester.binding.platformDispatcher.textScaleFactorTestValue = textScale;
    await tester.binding.setSurfaceSize(const Size(1600, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(TournamentWidgetbookApp(theme: AppTheme.dark()));
    await tester.pumpAndSettle();
    final config = tester.widget<Widgetbook>(find.byType(Widgetbook));
    final sources = WidgetbookRoot(children: config.directories).leaves
        .whereType<WidgetbookUseCase>()
        .toList();
    expect(sources, isNotEmpty);
    final records = <Map<String, Object?>>[];
    final allErrors = <String>[];
    final oldHandler = FlutterError.onError;
    final currentErrors = <String>[];
    FlutterError.onError = (details) =>
        currentErrors.add(details.exceptionAsString());
    try {
      for (final (index, source) in sources.indexed) {
        if (preset == shortDesktop && !source.path.startsWith("screens/")) {
          continue;
        }
        if (filter.isNotEmpty && !source.path.contains(filter)) continue;
        currentErrors.clear();
        await tester.pumpWidget(const SizedBox.shrink());
        final capture = GlobalKey();
        final builder = _CaptureBuilder(source: source, capture: capture);
        await tester.pumpWidget(
          Widgetbook.material(
            appBuilder: config.appBuilder,
            addons: preset == shortDesktop
                ? [
                    ...config.addons!.where((addon) => addon is! ViewportAddon),
                    ViewportAddon([
                      ...WidgetbookViewports.values,
                      shortDesktop,
                    ]),
                  ]
                : config.addons,
            themeMode: config.themeMode,
            darkTheme: config.darkTheme,
            directories: [
              WidgetbookFolder(
                name: 'Audit',
                children: [
                  WidgetbookComponent(
                    name: 'Component',
                    useCases: [
                      WidgetbookUseCase(name: 'Case', builder: builder.build),
                    ],
                  ),
                ],
              ),
            ],
            initialRoute: Uri(
              path: '/',
              queryParameters: {
                'path': 'audit/component/case',
                'viewport': '{name:${Uri.encodeComponent(preset.name)}}',
              },
            ).toString(),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        final boundary = capture.currentContext?.findRenderObject();
        final geometry = <Map<String, Object?>>[];
        if (boundary is RenderRepaintBoundary && boundary.hasSize) {
          _collect(capture.currentContext! as Element, boundary, geometry);
          if (_insetPaths.contains(source.path)) {
            final first = geometry.first;
            if ((first['x']! as double) < 16 ||
                (first['y']! as double) < 16 ||
                (first['x']! as double) + (first['width']! as double) >
                    preset.width - 16) {
              currentErrors.add(
                'Preview focus outline lacks safe inset: $first',
              );
            }
          }
          if (output.isNotEmpty) {
            await tester.runAsync(
              () => _capture(
                boundary,
                '$output/${preset.width.toInt()}/${index.toString().padLeft(3, '0')}.png',
                preset.size,
              ),
            );
          }
        } else {
          currentErrors.add('Missing preview boundary');
        }
        allErrors.addAll(
          currentErrors.map((error) => '${source.path}: $error'),
        );
        records.add({
          'path': source.path,
          'width': preset.width,
          'height': preset.height,
          'image':
              '${preset.width.toInt()}/${index.toString().padLeft(3, '0')}.png',
          'widgets': geometry,
          'errors': List<String>.of(currentErrors),
        });
      }
      await tester.pumpWidget(const SizedBox.shrink());
    } finally {
      FlutterError.onError = oldHandler;
      if (output.isNotEmpty) {
        final file = File('$output/${preset.width.toInt()}.json');
        file.parent.createSync(recursive: true);
        file.writeAsStringSync(
          const JsonEncoder.withIndent('  ').convert(records),
        );
      }
    }
    expect(allErrors, isEmpty, reason: '${preset.name}: preview layout errors');
  }

  static Future<void> _capture(
    RenderRepaintBoundary boundary,
    String path,
    Size viewport,
  ) async {
    // Test-only full viewport capture keeps the preview's natural constraints.
    // ignore: invalid_use_of_protected_member
    final image = await (boundary.layer! as OffsetLayer).toImage(
      Offset.zero & viewport,
      pixelRatio: 1,
    );
    try {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final file = File(path);
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes!.buffer.asUint8List());
    } finally {
      image.dispose();
    }
  }

  static bool _isComponent(Widget widget) =>
      widget is AppNavigationItem ||
      widget is AppSurface ||
      widget is AppField ||
      widget is AppNotice ||
      widget is AppNumberStepper ||
      widget is AppScore ||
      widget is AppButton ||
      widget is AppProgressIndicator ||
      widget is AppStatusLabel ||
      widget is AppScoreChoice<Object> ||
      widget is AppAvatar ||
      widget is AppSelectSheet<Object> ||
      widget is AppSelect<Object> ||
      widget is AppMetric ||
      widget is AppQrCode ||
      widget is AppSegmentedChoice<Object> ||
      widget is AppDisclosure ||
      widget is AppIdentity ||
      widget is AppShareLink ||
      widget is AppBracketNode ||
      widget is AppDialog ||
      widget is AppSectionHeader ||
      widget is AppDataTable ||
      widget is AppRosterRow;

  static void _collect(
    Element element,
    RenderObject root,
    List<Map<String, Object?>> result,
  ) {
    final box = element.findRenderObject();
    if (_isComponent(element.widget) && box is RenderBox && box.hasSize) {
      final rect = MatrixUtils.transformRect(
        box.getTransformTo(root),
        Offset.zero & box.size,
      );
      result.add({
        'type': element.widget.runtimeType.toString(),
        'x': rect.left,
        'y': rect.top,
        'width': rect.width,
        'height': rect.height,
      });
    }
    element.visitChildren((child) => _collect(child, root, result));
  }
}

class _CaptureBuilder {
  const _CaptureBuilder({required this.source, required this.capture});
  final WidgetbookUseCase source;
  final GlobalKey capture;
  Widget build(BuildContext context) =>
      RepaintBoundary(key: capture, child: source.builder(context));
}
