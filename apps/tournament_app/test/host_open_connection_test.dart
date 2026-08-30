import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';
import 'package:tournament_hub_app/presentation/screens/host_open/host_open_screen.dart';

void main() {
  const endpoint = 'http://192.168.1.42:8080';

  test('view projection сохраняет все Host connection states', () {
    for (final state in _hostStates) {
      final projection = _projection(state, endpoint: endpoint);

      expect(projection.spectatorAccess.state, state);
      expect(projection.spectatorAccess.endpoint, projection.localEndpoint);
      expect(projection.statusLabel, isNotEmpty);
      expect(projection.detail, isNotEmpty);
    }
  });

  testWidgets('Host Open передаёт projection в ConnectionQrCard', (
    tester,
  ) async {
    await _setViewport(tester, const Size(1280, 960));

    for (final state in _hostStates) {
      final projection = _projection(state, endpoint: endpoint);

      await tester.pumpWidget(
        _app(HostOpenScreenPreview(spectatorProjection: projection)),
      );
      await tester.pumpAndSettle();
      expect(find.text(projection.statusLabel), findsOneWidget);
      expect(find.text('Начать раздачу'), findsOneWidget);

      await _openSpectatorAccess(tester);

      final card = tester.widget<ConnectionQrCard>(
        find.byType(ConnectionQrCard),
      );
      expect(card.state, projection.spectatorAccess.state, reason: state.name);
      expect(card.encodedValue, projection.localEndpoint ?? '');
      expect(
        card.displayAddress,
        projection.localEndpoint ?? 'Адрес ещё недоступен',
      );

      await tester.ensureVisible(find.text('Вернуться к лобби'));
      await tester.tap(find.text('Вернуться к лобби'));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('copy вызывает adapter и показывает локальный feedback', (
    tester,
  ) async {
    await _setViewport(tester, const Size(1280, 960));
    var copyCalls = 0;
    var shareCalls = 0;
    await tester.pumpWidget(
      _app(
        HostOpenScreenPreview(
          onCopySpectatorAddress: () => copyCalls += 1,
          onShareSpectatorAddress: () => shareCalls += 1,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await _openSpectatorAccess(tester);
    final copyAction = find.descendant(
      of: find.byType(SpectatorAccessDialog),
      matching: find.text('Копировать адрес'),
    );
    await tester.ensureVisible(copyAction);
    await tester.tap(copyAction);
    await tester.pump();

    expect(copyCalls, 1);
    expect(
      tester.widget<ConnectionQrCard>(find.byType(ConnectionQrCard)).state,
      ConnectionQrState.copied,
    );
    expect(find.text('Адрес скопирован'), findsWidgets);

    await tester.ensureVisible(find.text('Поделиться'));
    await tester.tap(find.text('Поделиться'));
    expect(shareCalls, 1);
  });

  testWidgets('failed state вызывает retry adapter без блокировки лобби', (
    tester,
  ) async {
    await _setViewport(tester, const Size(1280, 960));
    var retryCalls = 0;
    await tester.pumpWidget(
      _app(
        HostOpenScreenPreview(
          spectatorProjection: const HostOpenConnectionViewData(
            state: ConnectionQrState.error,
            connectedSpectators: 0,
            statusLabel: 'Не удалось открыть spectator',
            detail: 'Повторите попытку, не прерывая турнир.',
            kind: StatusKind.danger,
          ),
          onRetrySpectator: () => retryCalls += 1,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Начать раздачу'), findsOneWidget);
    await _openSpectatorAccess(tester);
    await tester.ensureVisible(find.text('Попробовать снова'));
    await tester.tap(find.text('Попробовать снова'));
    await tester.pump();

    expect(retryCalls, 1);
    expect(find.text('Ошибка подключения'), findsOneWidget);
  });

  testWidgets('Guest можно удалить из открытого лобби', (tester) async {
    await _setViewport(tester, const Size(1280, 960));
    String? removedId;
    await tester.pumpWidget(
      _app(
        HostOpenScreenPreview(
          participants: const [
            HostLobbyParticipantViewData(
              id: 'host',
              nickname: 'Организатор',
              isGuest: false,
            ),
            HostLobbyParticipantViewData(
              id: 'guest-1',
              nickname: 'Соня',
              isGuest: true,
            ),
          ],
          onRemoveParticipant: (value) => removedId = value,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Удалить гостя'));
    await tester.tap(find.text('Удалить гостя'));

    expect(removedId, 'guest-1');
  });
}

Future<void> _openSpectatorAccess(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Дополнительные действия').first);
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('open-spectator-access')));
  await tester.pumpAndSettle();
}

const _hostStates = [
  ConnectionQrState.starting,
  ConnectionQrState.ready,
  ConnectionQrState.reconnecting,
  ConnectionQrState.stale,
  ConnectionQrState.unavailable,
  ConnectionQrState.error,
  ConnectionQrState.expired,
];

HostOpenConnectionViewData _projection(
  ConnectionQrState state, {
  required String endpoint,
}) => HostOpenConnectionViewData(
  state: state,
  connectedSpectators: 3,
  statusLabel: 'Состояние ${state.name}',
  detail: 'Готовая presentation projection для ${state.name}.',
  kind: switch (state) {
    ConnectionQrState.ready => StatusKind.success,
    ConnectionQrState.stale || ConnectionQrState.expired => StatusKind.warning,
    ConnectionQrState.error => StatusKind.danger,
    ConnectionQrState.starting ||
    ConnectionQrState.reconnecting => StatusKind.info,
    ConnectionQrState.unavailable ||
    ConnectionQrState.copied => StatusKind.neutral,
  },
  localEndpoint:
      state == ConnectionQrState.unavailable || state == ConnectionQrState.error
      ? null
      : endpoint,
);

Future<void> _setViewport(WidgetTester tester, Size size) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

Widget _app(Widget child) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: TournamentTheme.dark,
  home: child,
);
