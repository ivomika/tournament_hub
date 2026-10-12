import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

void main() {
  testWidgets('Visual capture environment is deterministic', _fixedEnvironment);
  test(
    'Non-Linux golden comparison is rejected',
    _rejectComparison,
    skip: Platform.isLinux,
  );
  test(
    'Non-Linux golden update is rejected',
    _rejectUpdate,
    skip: Platform.isLinux,
  );
}

Future<void> _fixedEnvironment(WidgetTester tester) async {
  addTearDown(tester.view.reset);
  for (final viewport in VisualViewport.values) {
    tester.view.physicalSize = viewport.size;
    // Test fixture only: не showcase и не компонент продукта.
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox.shrink(),
      ),
    );
    expect(tester.platformDispatcher.locale, const Locale('ru'));
    expect(tester.platformDispatcher.textScaleFactor, 1);
    expect(tester.view.devicePixelRatio, 1);
    expect(tester.view.physicalSize, viewport.size);
    expect(tester.takeException(), isNull);
  }
}

void _rejectComparison() {
  expect(_compare, throwsUnsupportedError);
}

Future<bool> _compare() =>
    goldenFileComparator.compare(Uint8List(0), Uri.parse('unused.png'));

void _rejectUpdate() {
  expect(_update, throwsUnsupportedError);
}

Future<void> _update() =>
    goldenFileComparator.update(Uri.parse('unused.png'), Uint8List(0));
