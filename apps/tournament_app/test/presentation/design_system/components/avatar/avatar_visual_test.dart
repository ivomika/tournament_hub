import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_size.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_avatar_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/components/avatar/avatar_fixture.dart';

void main() => _AvatarVisualTests.run();

abstract final class _AvatarVisualTests {
  static const _captureKey = ValueKey('avatar-capture');
  static final _output = Directory(
    '../../docs/design/prototype/comparison/avatar',
  );

  static void run() {
    testWidgets(
      'Avatar matches web anatomy at both viewports and native goldens',
      _sourceComparison,
    );
    testWidgets(
      'Avatar reads replacement main theme and extensions',
      _themeReplacement,
    );
    testWidgets(
      'Avatar empty and two-letter data preserve size and decorative semantics',
      _content,
    );
  }

  static Future<void> _pump(
    WidgetTester tester,
    AppAvatarSize size,
    AppAvatarShape shape, {
    ThemeData? theme,
    String initials = 'И',
    Color? foreground,
  }) async {
    final current = theme ?? AppTheme.dark();
    await tester.pumpWidget(
      MaterialApp(
        theme: current,
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: RepaintBoundary(
              key: _captureKey,
              child: ColoredBox(
                color: current.scaffoldBackgroundColor,
                child: AvatarFixture(
                  size: size,
                  shape: shape,
                  initials: initials,
                  foreground: foreground,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  static Future<void> _sourceComparison(WidgetTester tester) async {
    addTearDown(tester.view.reset);
    final json = jsonDecode(
      File('${_output.path}/web-metrics.json').readAsStringSync(),
    ) as Map<String, Object?>;
    final samples = (json['scenarios']! as List<Object?>)
        .cast<Map<String, Object?>>();
    expect(
      samples,
      hasLength(28),
      reason: 'Capture both complete web viewports first',
    );
    final results = <Map<String, Object?>>[];
    for (final sample in samples) {
      final id = sample['id']! as String;
      final extent = (sample['size']! as num).toDouble();
      final size = AppAvatarSize
          .values[[28, 40, 48, 64, 96, 112, 128].indexOf(extent.toInt())];
      final shape = AppAvatarShape.values.byName(sample['shape']! as String);
      tester.view.physicalSize = Size(
        sample['viewport'] == 'mobile' ? 390 : 1440,
        900,
      );
      await _pump(tester, size, shape);
      final bounds = tester.getRect(find.byType(AppAvatar));
      final text = tester.widget<Text>(find.text('И'));
      final textRect = tester.getRect(find.text('И'));
      expect(bounds.size, Size(extent, extent));
      expect(text.style!.fontSize, sample['fontSize']);
      expect(text.style!.height, 1);
      expect(text.style!.letterSpacing, 0);
      expect(textRect.center.dx - bounds.left, closeTo(extent / 2, 0.01));
      expect(textRect.center.dy - bounds.top, closeTo(extent / 2, 0.01));
      final decoration =
          tester
                  .widget<DecoratedBox>(
                    find.descendant(
                      of: find.byType(AppAvatar),
                      matching: find.byType(DecoratedBox),
                    ),
                  )
                  .decoration
              as BoxDecoration;
      expect(decoration.border, isNull);
      expect(text.style!.color, _cssColor(sample['color']! as String));
      expect(decoration.color, _cssColor(sample['background']! as String));
      expect(text.style!.fontWeight!.value.toString(), sample['fontWeight']);
      if (shape == AppAvatarShape.tile) {
        expect(
          decoration.borderRadius!.resolve(TextDirection.ltr).topLeft.x,
          double.parse((sample['radius']! as String).replaceAll('px', '')),
        );
      }

      final golden = Uri.file(
        '${Directory.current.path}/lib/presentation/design_system/components/avatar/golden/${Platform.operatingSystem}/${sample['size']}_${shape.name}.png',
      );
      await expectLater(find.byKey(_captureKey), matchesGoldenFile(golden));
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(_captureKey),
      );
      final result = await tester.runAsync(
        () => _compare(boundary, id, id, text.style!.color!, {
          'viewport': sample['viewport'],
          'size': extent,
          'shape': shape.name,
          'fontSize': text.style!.fontSize,
          'color': _hex(text.style!.color!),
          'background': _hex(decoration.color!),
          'radius': shape == AppAvatarShape.round
              ? extent / 2
              : decoration.borderRadius!.resolve(TextDirection.ltr).topLeft.x,
          'baseline': textRect.top - bounds.top + _baseline(tester),
          'textBox': {
            'x': textRect.left - bounds.left,
            'y': textRect.top - bounds.top,
            'width': textRect.width,
            'height': textRect.height,
          },
        }),
      );
      expect(
        result!['baseline']! as double,
        closeTo((sample['baseline']! as num).toDouble(), 0.5),
        reason: 'Browser font metrics are rounded to integer CSS pixels',
      );
      final webInk = result['webInk']! as Map<String, int>;
      final flutterInk = result['flutterInk']! as Map<String, int>;
      for (final edge in webInk.keys) {
        expect(
          flutterInk[edge],
          closeTo(webInk[edge]!, 1),
          reason:
              'Glyph raster edge must stay within one physical pixel of web',
        );
      }
      results.add(result);
    }
    // A real component with a deliberately wrong theme: shape is unchanged,
    // while only the inner text moves. The report must expose that difference.
    final base = AppTheme.dark();
    final shifted = base.copyWith(
      extensions: [
        ...base.extensions.values.where((e) => e is! AppAvatarMetrics),
        base.extension<AppAvatarMetrics>()!.copyWith(
          contentAlignment: const Alignment(0, 0.25),
        ),
      ],
    );
    tester.view.physicalSize = const Size(390, 900);
    await _pump(
      tester,
      AppAvatarSize.large,
      AppAvatarShape.tile,
      theme: shifted,
    );
    final bad = await tester.runAsync(
      () => _compare(
        tester.renderObject<RenderRepaintBoundary>(find.byKey(_captureKey)),
        'control-text-shift',
        'mobile-64-tile',
        base.colorScheme.onSurfaceVariant,
        {'control': true, 'size': 64, 'shape': 'tile'},
      ),
    );
    final healthy = results.firstWhere((r) => r['id'] == 'mobile-64-tile');
    final healthyInk = healthy['flutterInk']! as Map<String, int>;
    final shiftedInk = bad!['flutterInk']! as Map<String, int>;
    expect(
      shiftedInk['top']! - healthyInk['top']!,
      greaterThanOrEqualTo(4),
      reason: 'Control must detect inner composition error',
    );
    expect(
      bad['changedPixels']! as int,
      greaterThan(healthy['changedPixels']! as int),
    );
    results.add(bad);
    File('${_output.path}/flutter-metrics.json').writeAsStringSync(
      const JsonEncoder.withIndent(
        '  ',
      ).convert({'nativeOS': Platform.operatingSystem, 'scenarios': results}),
    );
  }

  static Future<Map<String, Object?>> _compare(
    RenderRepaintBoundary boundary,
    String id,
    String reference,
    Color foreground,
    Map<String, Object?> metrics,
  ) async {
    for (final dir in ['flutter', 'overlay', 'diff']) {
      Directory('${_output.path}/$dir').createSync(recursive: true);
    }
    final image = await boundary.toImage(pixelRatio: 1);
    final png = (await image.toByteData(format: ui.ImageByteFormat.png))!;
    File('${_output.path}/flutter/$id.png')
        .writeAsBytesSync(png.buffer.asUint8List());
    final actual = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!
        .buffer
        .asUint8List();
    final codec = await ui.instantiateImageCodec(
      File('${_output.path}/web/$reference.png').readAsBytesSync(),
    );
    final expectedImage = (await codec.getNextFrame()).image;
    expect(image.width, expectedImage.width);
    expect(image.height, expectedImage.height);
    final expected = (await expectedImage.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    ))!.buffer.asUint8List();
    final overlay = Uint8List(actual.length);
    final difference = Uint8List(actual.length);
    var changed = 0;
    var totalDelta = 0;
    for (var i = 0; i < actual.length; i += 4) {
      var delta = 0;
      for (var c = 0; c < 3; c++) {
        final d = (actual[i + c] - expected[i + c]).abs();
        delta += d;
        overlay[i + c] = ((actual[i + c] + expected[i + c]) / 2).round();
        difference[i + c] = math.min(255, d * 4);
      }
      overlay[i + 3] = 255;
      difference[i + 3] = 255;
      if (delta > 12) changed++;
      totalDelta += delta;
    }
    await _saveRgba(overlay, image.width, image.height, 'overlay/$id.png');
    await _saveRgba(difference, image.width, image.height, 'diff/$id.png');
    final result = <String, Object?>{
      'id': id,
      'reference': reference,
      ...metrics,
      'changedPixels': changed,
      'meanChannelDelta': totalDelta / (image.width * image.height * 3),
      'webInk': _ink(expected, image.width, image.height, foreground),
      'flutterInk': _ink(actual, image.width, image.height, foreground),
    };
    image.dispose();
    expectedImage.dispose();
    codec.dispose();
    return result;
  }

  static Map<String, int> _ink(
    Uint8List bytes,
    int width,
    int height,
    Color color,
  ) {
    final rgb = [
      (color.toARGB32() >> 16) & 255,
      (color.toARGB32() >> 8) & 255,
      color.toARGB32() & 255,
    ];
    var left = width, top = height, right = -1, bottom = -1;
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final i = (y * width + x) * 4;
        final distance =
            (bytes[i] - rgb[0]).abs() +
            (bytes[i + 1] - rgb[1]).abs() +
            (bytes[i + 2] - rgb[2]).abs();
        if (distance < 90) {
          left = math.min(left, x);
          top = math.min(top, y);
          right = math.max(right, x);
          bottom = math.max(bottom, y);
        }
      }
    }
    return {'left': left, 'top': top, 'right': right, 'bottom': bottom};
  }

  static Future<void> _saveRgba(
    Uint8List bytes,
    int width,
    int height,
    String file,
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
    File('${_output.path}/$file').writeAsBytesSync(png.buffer.asUint8List());
    image.dispose();
  }

  static double _baseline(WidgetTester tester) {
    final paragraph = tester.renderObject<RenderParagraph>(find.text('И'));
    final widget = tester.widget<Text>(find.text('И'));
    final painter = TextPainter(
      text: paragraph.text,
      textDirection: TextDirection.ltr,
      textHeightBehavior: widget.textHeightBehavior,
    )..layout();
    final baseline = painter.computeLineMetrics().first.baseline;
    painter.dispose();
    return baseline;
  }

  static Color _cssColor(String value) {
    final values = RegExp(r'\d+')
        .allMatches(value)
        .map((m) => int.parse(m.group(0)!))
        .toList();
    return Color.fromARGB(255, values[0], values[1], values[2]);
  }

  static String _hex(Color color) =>
      '#${color.toARGB32().toRadixString(16).substring(2)}';

  static Future<void> _themeReplacement(WidgetTester tester) async {
    await _pump(tester, AppAvatarSize.large, AppAvatarShape.tile);
    final base = AppTheme.dark();
    final theme = base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        onSurfaceVariant: Colors.cyan,
        surfaceContainerHigh: Colors.indigo,
      ),
      extensions: [
        ...base.extensions.values.where(
          (e) => e is! AppResponsive && e is! AppAvatarMetrics,
        ),
        base.extension<AppResponsive>()!.copyWith(avatarLarge: 80),
        base.extension<AppAvatarMetrics>()!.copyWith(
          avatarFont64: 30,
          avatarRadius64: 20,
        ),
      ],
    );
    await _pump(tester, AppAvatarSize.large, AppAvatarShape.tile, theme: theme);
    expect(tester.getSize(find.byType(AppAvatar)), const Size(80, 80));
    expect(tester.widget<Text>(find.text('И')).style!.fontSize, 30);
    expect(tester.widget<Text>(find.text('И')).style!.color, Colors.cyan);
    final box =
        tester
                .widget<DecoratedBox>(
                  find.descendant(
                    of: find.byType(AppAvatar),
                    matching: find.byType(DecoratedBox),
                  ),
                )
                .decoration
            as BoxDecoration;
    expect(box.color, Colors.indigo);
    expect(box.borderRadius, BorderRadius.circular(20));
  }

  static Future<void> _content(WidgetTester tester) async {
    for (final initials in ['', 'SZ']) {
      await _pump(
        tester,
        AppAvatarSize.large,
        AppAvatarShape.tile,
        initials: initials,
      );
      expect(tester.getSize(find.byType(AppAvatar)), const Size(64, 64));
      expect(find.text(initials), findsOneWidget);
      expect(tester.takeException(), isNull);
      final suffix = initials.isEmpty ? 'empty' : 'two_letters';
      await expectLater(
        find.byKey(_captureKey),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/lib/presentation/design_system/components/avatar/golden/${Platform.operatingSystem}/64_tile_$suffix.png',
          ),
        ),
      );
    }
    final color = AppTheme.dark().colorScheme.secondary;
    await _pump(
      tester,
      AppAvatarSize.large,
      AppAvatarShape.tile,
      initials: 'SZ',
      foreground: color,
    );
    expect(tester.widget<Text>(find.text('SZ')).style!.color, color);
    await expectLater(
      find.byKey(_captureKey),
      matchesGoldenFile(
        Uri.file(
          '${Directory.current.path}/lib/presentation/design_system/components/avatar/golden/${Platform.operatingSystem}/64_tile_color_data.png',
        ),
      ),
    );
    expect(find.bySemanticsLabel('SZ'), findsNothing);
  }
}
