import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/design_system/components/stage_progress/app_stage_progress.dart';

void main() => _StageTests.run();

abstract final class _StageTests {
  static void run() {
    testWidgets('renders supplied highlights', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark(),
          home: const Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: RepaintBoundary(
                key: ValueKey('stage'),
                child: SizedBox(
                  width: 320,
                  child: AppStageProgress(
                    highlights: [false, true, false, false],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('stage')),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/lib/presentation/design_system/components/stage_progress/golden/${Platform.operatingSystem}/current.png',
          ),
        ),
      );
    });
  }
}
