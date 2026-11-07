import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_catalog.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';

void main() => _ComparisonDriver.run();

abstract final class _ComparisonDriver {
  static const component = String.fromEnvironment(
    'VC_COMPONENT',
    defaultValue: 'avatar',
  );
  static const mode = String.fromEnvironment(
    'VC_MODE',
    defaultValue: 'capture',
  );
  static const directory = String.fromEnvironment('VC_RUN_DIR');
  static const boundaryKey = ValueKey('comparison-capture');
  static void run() {
    if (directory.isEmpty) {
      test(
        'comparison runs through the CLI',
        () {},
        skip: 'Run node tools/visual-comparison/compare.mjs <component>',
      );
      return;
    }
    final spec = ComparisonCatalog.component(component);
    if (mode == 'manifest') {
      test('export comparison declaration', () {
        Directory(directory).createSync(recursive: true);
        File('$directory/spec.json')
            .writeAsStringSync(jsonEncode(spec.toJson()));
      });
      return;
    }
    testWidgets(
      'capture declared component scenarios',
      (tester) => _capture(tester, spec),
    );
  }

  static Future<void> _capture(WidgetTester tester, ComparisonSpec spec) async {
    expect(
      debugDisableShadows,
      isFalse,
      reason: 'Comparison requires real native shadow rendering',
    );
    addTearDown(tester.view.reset);
    final web = (jsonDecode(
      File('$directory/web.json').readAsStringSync(),
    ) as List<Object?>).cast<Map<String, Object?>>();
    final frames = <Map<String, Object?>>[];
    for (final scenario in spec.scenarios) {
      final reference = web.singleWhere((f) => f['id'] == scenario.id);
      final sourceRoot = reference['root']! as Map<String, Object?>;
      final width = (sourceRoot['width']! as num).toDouble();
      tester.view.physicalSize = scenario.size;
      Widget? actualRoot;
      final base = AppTheme.dark();
      final theme = scenario.theme?.call(base) ?? base;
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          locale: const Locale('ru'),
          localizationsDelegates:
              FoundationLocalizations.localizationsDelegates,
          supportedLocales: FoundationLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: Align(
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: RepaintBoundary(
                    key: boundaryKey,
                    child: ColoredBox(
                      color: theme.scaffoldBackgroundColor,
                      child: Padding(
                        padding: EdgeInsets.all(scenario.capturePadding),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: width),
                          child: Builder(
                            builder: (context) {
                              actualRoot = scenario.builder(context);
                              return actualRoot!;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(
        const Duration(milliseconds: 50),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 5),
      );
      expect(tester.takeException(), isNull);
      final rootFinder = find.byWidget(actualRoot!);
      final rootRect = tester.getRect(rootFinder);
      final controls = <String, Object?>{};
      for (final control in scenario.controls) {
        final matching = control.widgetType != null
            ? find.byType(control.widgetType!)
            : find.text(control.text!);
        final scope = control.withinType == null
            ? rootFinder
            : find.descendant(
                of: rootFinder,
                matching: find.byType(control.withinType!),
                matchRoot: true,
              );
        final targets = find.descendant(
          of: scope,
          matching: matching,
          matchRoot: true,
        );
        if (targets.evaluate().length <= control.index) continue;
        final finder = targets.at(control.index);
        final rect = tester.getRect(finder).shift(-rootRect.topLeft);
        final widget = tester.widget<Widget>(finder);
        final values = <String, Object?>{
          'rect': _rect(rect),
          'width': rect.width,
          'height': rect.height,
        };
        if (widget is Text) {
          final effective = DefaultTextStyle.of(tester.element(finder)).style
              .merge(widget.style);
          final paragraph = tester.renderObject<RenderParagraph>(
            find
                .descendant(
                  of: finder,
                  matching: find.byType(RichText),
                  matchRoot: true,
                )
                .first,
          );
          final painter = TextPainter(
            text: paragraph.text,
            textDirection: TextDirection.ltr,
            textHeightBehavior: widget.textHeightBehavior,
          )..layout(maxWidth: rect.width);
          values.addAll({
            'fontSize': effective.fontSize,
            'fontWeight': effective.fontWeight?.value,
            'lineHeight': effective.height,
            'color': effective.color == null ? null : _color(effective.color!),
            'baseline': rect.top + painter.computeLineMetrics().first.baseline,
          });
          painter.dispose();
        }
        if (widget is ClipRRect) {
          values['radius'] = widget.borderRadius
              .resolve(TextDirection.ltr)
              .topLeft
              .x;
        }
        if (widget is DecoratedBox && widget.decoration is BoxDecoration) {
          final box = widget.decoration as BoxDecoration;
          values.addAll({
            'background': box.color == null ? '#00000000' : _color(box.color!),
            'radius': box.shape == BoxShape.circle
                ? math.min(rect.width, rect.height) / 2
                : math.min(
                    box.borderRadius?.resolve(TextDirection.ltr).topLeft.x ?? 0,
                    math.min(rect.width, rect.height) / 2,
                  ),
            'borderWidth': box.border?.top.width ?? 0,
          });
        }
        controls[control.id] = values;
      }
      final image = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(boundaryKey),
      );
      final raster = await tester.runAsync(
        () => _images(image, scenario.id, theme.scaffoldBackgroundColor),
      );
      frames.add({
        'id': scenario.id,
        'root': {
          'x': 0,
          'y': 0,
          'width': rootRect.width,
          'height': rootRect.height,
        },
        'controls': controls,
        'raster': raster,
        'artifacts': {'image': 'flutter/${scenario.id}.png'},
      });
      File('$directory/native.json').writeAsStringSync(jsonEncode(frames));
      if (scenario.expectedFailure != null) continue;
      final goldenDirectory =
          spec.goldenDirectory ??
          'lib/presentation/design_system/components/${spec.component}/golden';
      final golden = Uri.file(
        '${Directory.current.path}/$goldenDirectory/${Platform.operatingSystem}/${scenario.goldenId ?? scenario.id}.png',
      );
      await expectLater(find.byKey(boundaryKey), matchesGoldenFile(golden));
    }
  }

  static Map<String, double> _rect(Rect rect) => {
    'x': rect.left,
    'y': rect.top,
    'width': rect.width,
    'height': rect.height,
  };
  static String _color(Color color) {
    final argb = color.toARGB32();
    return '#${(argb & 0xffffff).toRadixString(16).padLeft(6, '0')}${(argb >> 24).toRadixString(16).padLeft(2, '0')}';
  }

  static Future<Map<String, Object?>> _images(
    RenderRepaintBoundary boundary,
    String id,
    Color canvas,
  ) async {
    final image = await boundary.toImage(pixelRatio: 1);
    final png = (await image.toByteData(format: ui.ImageByteFormat.png))!;
    File('$directory/flutter/$id.png')
        .writeAsBytesSync(png.buffer.asUint8List());
    final codec = await ui.instantiateImageCodec(
      File('$directory/web/$id.png').readAsBytesSync(),
    );
    final expected = (await codec.getNextFrame()).image;
    final actualBytes = (await image.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    ))!.buffer.asUint8List();
    final expectedBytes = (await expected.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    ))!.buffer.asUint8List();
    final width = math.max(image.width, expected.width),
        height = math.max(image.height, expected.height);
    final overlay = Uint8List(width * height * 4),
        diff = Uint8List(width * height * 4);
    var changed = 0, total = 0;
    final bg = canvas.toARGB32();
    final background = [(bg >> 16) & 255, (bg >> 8) & 255, bg & 255];
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final i = (y * width + x) * 4;
        var delta = 0;
        for (var c = 0; c < 3; c++) {
          final a = x < image.width && y < image.height
              ? actualBytes[(y * image.width + x) * 4 + c]
              : background[c];
          final b = x < expected.width && y < expected.height
              ? expectedBytes[(y * expected.width + x) * 4 + c]
              : background[c];
          final d = (a - b).abs();
          delta += d;
          overlay[i + c] = ((a + b) / 2).round();
          diff[i + c] = math.min(255, d * 4);
        }
        overlay[i + 3] = 255;
        diff[i + 3] = 255;
        if (delta > 12) changed++;
        total += delta;
      }
    }
    await _save(overlay, width, height, 'overlay/$id.png');
    await _save(diff, width, height, 'diff/$id.png');
    image.dispose();
    expected.dispose();
    codec.dispose();
    return {
      'changedPixels': changed,
      'meanChannelDelta': total / (width * height * 3),
    };
  }

  static Future<void> _save(
    Uint8List bytes,
    int width,
    int height,
    String name,
  ) async {
    final complete = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      bytes,
      width,
      height,
      ui.PixelFormat.rgba8888,
      complete.complete,
    );
    final image = await complete.future;
    final png = (await image.toByteData(format: ui.ImageByteFormat.png))!;
    File('$directory/$name').writeAsBytesSync(png.buffer.asUint8List());
    image.dispose();
  }
}
