import 'dart:io';

import '../../application/spectator/ports/spectator_server.dart';
import 'spectator_lan_server.dart';

SpectatorServer createProductionSpectatorServer() {
  final candidates = [
    Directory('../spectator_web/dist'),
    Directory('apps/spectator_web/dist'),
  ];
  final directory = candidates.firstWhere(
    (value) => value.existsSync(),
    orElse: () => candidates.first,
  );
  return SpectatorLanServer(staticDirectory: directory.path);
}
