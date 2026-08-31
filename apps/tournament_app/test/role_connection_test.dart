import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';
import 'package:tournament_hub_app/presentation/screens/host_open/host_open_screen.dart';
import 'package:tournament_hub_app/presentation/screens/join/join_screen.dart';

void main() {
  const endpoint = 'http://192.168.1.42:8080';

  testWidgets('Host Open скрывает participant invite без capability', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const HostOpenScreenPreview()));
    await tester.pumpAndSettle();

    expect(find.byType(ParticipantInviteCard), findsNothing);
    expect(find.byKey(const Key('participant-invite-qr')), findsNothing);
    expect(find.byType(SpectatorAccessDialog), findsNothing);
    expect(
      find.descendant(
        of: find.byKey(const Key('page-layout-primary')),
        matching: find.text('Участники'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('page-layout-secondary')),
        matching: find.text('Добавить гостя'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Host Open показывает participant invite по capability', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const HostOpenScreenPreview(
          participantInvite: HostOpenScreenPreview.previewParticipantInvite,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final qr = tester.widget<QrCode>(
      find.byKey(const Key('participant-invite-qr')),
    );
    expect(qr.value, endpoint);
  });

  testWidgets('spectator открывается только по explicit action', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const HostOpenScreenPreview()));
    await tester.pumpAndSettle();

    await _openSpectatorAccess(tester);

    expect(find.byType(SpectatorAccessDialog), findsOneWidget);
    expect(find.text('SPECTATOR · ЭКРАН ДЛЯ ТВ'), findsOneWidget);
    expect(find.byType(ConnectionQrCard), findsOneWidget);

    final spectatorQr = tester.widget<QrCode>(
      find.descendant(
        of: find.byType(SpectatorAccessDialog),
        matching: find.byType(QrCode),
      ),
    );
    expect(spectatorQr.value, endpoint);
    expect(spectatorQr.size, QrCodeSize.large);

    await tester.ensureVisible(find.text('Вернуться к лобби'));
    await tester.tap(find.text('Вернуться к лобби'));
    await tester.pumpAndSettle();
    expect(find.byType(SpectatorAccessDialog), findsNothing);
    expect(find.byType(ParticipantInviteCard), findsNothing);
  });

  testWidgets('participant terminal states не оставляют рабочий QR', (
    tester,
  ) async {
    for (final state in const [
      ParticipantInviteState.stale,
      ParticipantInviteState.unavailable,
      ParticipantInviteState.error,
    ]) {
      await tester.pumpWidget(
        _app(
          ParticipantInviteCard(
            data: ParticipantInviteViewData(
              endpoint: endpoint,
              joinCode: 'FIGHT-24',
              state: state,
            ),
            onRetry: () {},
          ),
        ),
      );
      await tester.pump();

      expect(
        tester.widget<QrCode>(find.byType(QrCode)).state,
        QrCodeState.unavailable,
      );
    }
  });

  testWidgets('Join остаётся scanner и code-first', (tester) async {
    await tester.pumpWidget(_app(const JoinScreenPreview()));
    await tester.pumpAndSettle();

    expect(find.byType(ParticipantJoinPanel), findsOneWidget);
    expect(find.text('СКАНЕР ИЛИ КОД'), findsOneWidget);
    expect(find.text('Сканировать QR'), findsOneWidget);
    expect(find.byKey(const Key('participant-join-value')), findsOneWidget);
    expect(find.text('Подключить зрителей'), findsNothing);
  });

  testWidgets('все mock join states строятся и называются текстом', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    for (final state in ParticipantJoinState.values) {
      await tester.pumpWidget(
        _app(
          ParticipantJoinPanel(
            data: ParticipantJoinViewData(state: state, enteredValue: endpoint),
            onScan: () {},
            onSubmit: (_) {},
            onRetry: () {},
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull, reason: state.name);
      expect(find.byType(StatusBadge), findsOneWidget, reason: state.name);
    }
  });
}

Widget _app(Widget child) => MaterialApp(
  theme: TournamentTheme.dark,
  home: Scaffold(body: child),
);

Future<void> _openSpectatorAccess(WidgetTester tester) async {
  await tester.ensureVisible(find.byKey(const Key('open-spectator-access')));
  await tester.tap(find.byKey(const Key('open-spectator-access')));
  await tester.pumpAndSettle();
}
