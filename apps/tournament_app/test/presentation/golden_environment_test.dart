import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

void main() {
  testWidgets('Visual capture environment is deterministic', _fixedEnvironment);
  test('Cross-platform golden comparison is rejected', _rejectComparison);
  test('Cross-platform golden update is rejected', _rejectUpdate);
  test('Missing platform folder is rejected', _rejectMissingPlatform);
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
  expect(_compare, throwsArgumentError);
}

Future<bool> _compare() => goldenFileComparator.compare(
  Uint8List(0),
  Uri.parse('golden/not-current-platform/unused.png'),
);

void _rejectUpdate() {
  expect(_update, throwsArgumentError);
}

Future<void> _update() => goldenFileComparator.update(
  Uri.parse('golden/not-current-platform/unused.png'),
  Uint8List(0),
);

void _rejectMissingPlatform() {
  expect(_compareWithoutPlatform, throwsArgumentError);
}

Future<bool> _compareWithoutPlatform() =>
    goldenFileComparator.compare(Uint8List(0), Uri.parse('unused.png'));
