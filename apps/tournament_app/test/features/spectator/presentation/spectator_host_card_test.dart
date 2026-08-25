import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tournament_app/core/server/spectator_server.dart';
import 'package:tournament_app/features/fighters/data/repositories/mk11_ultimate_fighter_registry.dart';
import 'package:tournament_app/features/spectator/application/spectator_host_controller.dart';
import 'package:tournament_app/features/spectator/data/mappers/spectator_snapshot_mapper.dart';
import 'package:tournament_app/features/spectator/presentation/spectator_host_card.dart';

void main() {
  testWidgets('показывает LAN URL, QR и копирование адреса', (tester) async {
    final server = _FakeSpectatorServer();
    final controller = SpectatorHostController(
      server,
      SpectatorSnapshotMapper(Mk11UltimateFighterRegistry()),
    );
    addTearDown(controller.dispose);
    await controller.start();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SpectatorHostCard(controller: controller)),
      ),
    );

    expect(find.text('http://192.168.1.20:8080'), findsOneWidget);
    expect(find.byType(QrImageView), findsOneWidget);
    expect(find.byKey(const Key('copy-spectator-url')), findsOneWidget);
    expect(find.text('Подключено зрителей: 0'), findsOneWidget);
  });
}

final class _FakeSpectatorServer implements SpectatorServer {
  @override
  int get clientCount => 0;

  @override
  Stream<int> get clientCountChanges => const Stream.empty();

  @override
  Future<void> publish(String message) async {}

  @override
  Future<Uri> start() async => Uri.parse('http://192.168.1.20:8080');

  @override
  Future<void> stop() async {}
}
