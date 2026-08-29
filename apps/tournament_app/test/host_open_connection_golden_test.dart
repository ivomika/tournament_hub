import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';
import 'package:tournament_hub_app/presentation/screens/host_open/host_open_screen.dart';

void main() {
  for (final scenario in const [
    (
      name: 'serving_mobile',
      size: Size(390, 844),
      projection: previewHostOpenConnectionViewData,
    ),
    (
      name: 'rebinding_desktop',
      size: Size(1280, 960),
      projection: HostOpenConnectionViewData(
        state: ConnectionQrState.stale,
        connectedSpectators: 2,
        statusLabel: 'Адрес мог измениться',
        detail: 'Обновите адрес перед подключением нового экрана.',
        kind: StatusKind.warning,
        localEndpoint: 'http://192.168.1.77:8080',
      ),
    ),
    (
      name: 'failed_desktop',
      size: Size(1280, 960),
      projection: HostOpenConnectionViewData(
        state: ConnectionQrState.error,
        connectedSpectators: 0,
        statusLabel: 'Не удалось открыть spectator',
        detail: 'Повторите попытку, не прерывая турнир.',
        kind: StatusKind.danger,
      ),
    ),
  ]) {
    testWidgets('Host Open сохраняет ${scenario.name} contract', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = scenario.size;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: TournamentTheme.dark,
          home: HostOpenScreenPreview(spectatorProjection: scenario.projection),
        ),
      );
      await tester.pumpAndSettle();
      if (scenario.name != 'serving_mobile') {
        await tester.tap(find.byTooltip('Дополнительные действия').first);
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('open-spectator-access')));
        await tester.pumpAndSettle();
      }

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/host_open_connection/${scenario.name}.png'),
      );
    });
  }
}
