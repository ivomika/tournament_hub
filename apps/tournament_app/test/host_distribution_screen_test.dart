import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';
import 'package:tournament_hub_app/presentation/screens/host_distribution/host_distribution_screen.dart';

void main() {
  testWidgets('reroll блокирует duplicate tap и показывает success', (
    tester,
  ) async {
    final pending = Completer<void>();
    var calls = 0;
    await _pump(
      tester,
      HostDistributionScreenPreview(
        onReroll: () {
          calls++;
          return pending.future;
        },
      ),
    );

    await _openActions(tester);
    final action = find.byKey(const Key('reroll-all-fighters'));
    await tester.tap(action);
    await tester.tap(action, warnIfMissed: false);
    await tester.pump();
    expect(calls, 1);

    pending.complete();
    await tester.pumpAndSettle();
    expect(
      find.text('Персонажи перераспределены и сохранены.'),
      findsOneWidget,
    );
  });

  testWidgets('reroll показывает безопасную ошибку', (tester) async {
    await _pump(
      tester,
      HostDistributionScreenPreview(
        onReroll: () async => throw StateError('raw assignment failure'),
      ),
    );

    await _openActions(tester);
    await tester.tap(find.byKey(const Key('reroll-all-fighters')));
    await tester.pumpAndSettle();

    expect(
      find.text('Не удалось перераспределить персонажей. Повторите попытку.'),
      findsOneWidget,
    );
    expect(find.textContaining('raw assignment'), findsNothing);
  });
}

Future<void> _pump(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = const Size(1280, 960);
  tester.view.devicePixelRatio = 1;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await tester.pumpWidget(
    MaterialApp(theme: TournamentTheme.dark, home: child),
  );
  await tester.pumpAndSettle();
}

Future<void> _openActions(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Дополнительные действия').first);
  await tester.pumpAndSettle();
}
