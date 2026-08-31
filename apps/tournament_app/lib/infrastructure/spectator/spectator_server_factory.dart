import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../../application/spectator/ports/spectator_server.dart';
import 'spectator_lan_server.dart';

SpectatorServer createProductionSpectatorServer() {
  return SpectatorLanServer(
    staticDirectory: '../spectator_web/dist',
    bundleResolver: _resolveSpectatorBundle,
  );
}

Future<Directory?> _resolveSpectatorBundle() async {
  final candidates = [
    Directory('../spectator_web/dist'),
    Directory('apps/spectator_web/dist'),
    Directory('assets/spectator'),
  ];
  for (final directory in candidates) {
    if (File('${directory.path}${Platform.pathSeparator}index.html')
        .existsSync()) {
      return directory;
    }
  }

  final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
  final assets = manifest
      .listAssets()
      .where((value) => value.startsWith('assets/spectator/'))
      .toList();
  if (!assets.contains('assets/spectator/index.html')) return null;

  final cacheRoot = await getTemporaryDirectory();
  final directory = Directory(
    '${cacheRoot.path}${Platform.pathSeparator}tournament_hub_spectator',
  );
  await directory.create(recursive: true);
  for (final asset in assets) {
    final relative = asset.substring('assets/spectator/'.length);
    final file = File('${directory.path}${Platform.pathSeparator}$relative');
    await file.parent.create(recursive: true);
    final data = await rootBundle.load(asset);
    await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
  }
  return directory;
}
