import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';
import 'package:tournament_hub_app/presentation/screens/host_distribution/host_distribution_screen.dart';
import 'package:tournament_hub_app/presentation/screens/host_result_entry/host_result_entry_screen.dart';
import 'package:tournament_hub_app/presentation/screens/host_running/host_running_screen.dart';

void main() {
  testWidgets(
    'ActionDock показывает одно primary и прячет secondary в overflow',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 720);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: TournamentTheme.dark,
          home: Scaffold(
            bottomNavigationBar: ActionDock(
              primary: DsAction(label: 'Продолжить', onPressed: () {}),
              secondary: [ActionDockAction(label: 'Назад', onSelected: () {})],
            ),
          ),
        ),
      );

      expect(find.text('Продолжить'), findsOneWidget);
      expect(find.text('Назад'), findsNothing);
      expect(find.byTooltip('Дополнительные действия'), findsOneWidget);
      expect(
        tester.getSize(find.byType(ActionDock)).height,
        lessThanOrEqualTo(180),
      );

      await tester.tap(find.byTooltip('Дополнительные действия'));
      await tester.pumpAndSettle();
      expect(find.text('Назад'), findsOneWidget);
    },
  );

  testWidgets('destructive overflow требует подтверждения', (tester) async {
    var selected = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: Scaffold(
          bottomNavigationBar: ActionDock(
            primary: DsAction(label: 'Продолжить', onPressed: () {}),
            destructive: ActionDockAction(
              label: 'Отменить турнир',
              kind: ActionDockActionKind.destructive,
              confirmationTitle: 'Отменить турнир?',
              onSelected: () => selected = true,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Дополнительные действия'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Отменить турнир'));
    await tester.pumpAndSettle();
    expect(selected, isFalse);
    expect(find.text('Отменить турнир?'), findsOneWidget);

    await tester.tap(find.text('Отменить турнир').last);
    await tester.pumpAndSettle();
    expect(selected, isTrue);
  });

  testWidgets('confirmation возвращает focus в overflow trigger', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: Scaffold(
          bottomNavigationBar: ActionDock(
            primary: DsAction(label: 'Продолжить', onPressed: () {}),
            destructive: ActionDockAction(
              label: 'Удалить',
              kind: ActionDockActionKind.destructive,
              onSelected: () {},
            ),
          ),
        ),
      ),
    );

    final trigger = tester.widget<IconButton>(find.byType(IconButton));
    trigger.focusNode!.requestFocus();
    await tester.pump();
    expect(trigger.focusNode!.hasFocus, isTrue);

    await tester.tap(find.byTooltip('Дополнительные действия'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Удалить'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Назад'));
    await tester.pumpAndSettle();

    expect(trigger.focusNode!.hasFocus, isTrue);
  });

  testWidgets('fixed mobile region укладывается в 25% viewport', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 720);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: const HostRunningScreenPreview(),
      ),
    );
    await tester.pumpAndSettle();

    final fixedTop = tester.getTopLeft(find.byType(ActionDock)).dy;
    expect(720 - fixedTop, lessThanOrEqualTo(180));
    expect(
      tester.getSize(find.byType(ElevatedButton).last).height,
      greaterThanOrEqualTo(48),
    );
  });

  testWidgets('landscape, keyboard и reduced motion не ломают ActionDock', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(720, 390);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              disableAnimations: true,
              viewInsets: const EdgeInsets.only(bottom: 120),
            ),
            child: Scaffold(
              bottomNavigationBar: ActionDock(
                primary: DsAction(
                  label: 'Подтвердить победителя',
                  onPressed: () {},
                ),
                secondary: [
                  ActionDockAction(label: 'Назад', onSelected: () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      tester.getSize(find.byType(ActionDock)).height,
      lessThanOrEqualTo(78),
    );
    expect(tester.takeException(), isNull);
  });

  for (final entry in <String, Widget>{
    'running': const HostRunningScreenPreview(),
    'result': const HostResultEntryScreenPreview(),
    'distribution': const HostDistributionScreenPreview(),
  }.entries) {
    testWidgets('${entry.key} использует компактный mobile ActionDock', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 720);
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
        tester.platformDispatcher.clearTextScaleFactorTestValue();
      });

      await tester.pumpWidget(
        MaterialApp(theme: TournamentTheme.dark, home: entry.value),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ActionDock), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(ActionDock)).height,
        lessThanOrEqualTo(180),
      );
    });
  }
}
