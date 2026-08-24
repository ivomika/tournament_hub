import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/features/fighters/data/repositories/mk11_ultimate_fighter_registry.dart';
import 'package:tournament_app/features/fighters/presentation/resolvers/bundled_fighter_avatar_resolver.dart';

void main() {
  test('manifest и PNG полностью соответствуют registry', () async {
    final registry = Mk11UltimateFighterRegistry();
    const resolver = BundledFighterAvatarResolver();
    final manifestFile = File('assets/fighters/manifest.json');
    final manifest = jsonDecode(await manifestFile.readAsString());
    final records = (manifest['avatars'] as List<Object?>)
        .cast<Map<String, Object?>>();

    expect(manifest['width'], 512);
    expect(manifest['height'], 512);
    expect(manifest['background'], 'transparent');
    expect(records, hasLength(registry.fighters.length));

    final manifestIds = records.map((record) => record['id']).toSet();
    final registryIds = registry.fighters
        .map((fighter) => fighter.id.value)
        .toSet();
    expect(manifestIds, registryIds);

    final expectedAssets = <String>{};
    for (final fighter in registry.fighters) {
      final asset = resolver.resolve(fighter.avatarId);
      expectedAssets.add(asset);
      final file = File(asset);
      expect(await file.exists(), isTrue, reason: 'Отсутствует $asset');

      final bytes = await file.readAsBytes();
      expect(bytes.take(8), [137, 80, 78, 71, 13, 10, 26, 10]);
      final data = ByteData.sublistView(bytes);
      expect(data.getUint32(16), 512, reason: 'Неверная ширина $asset');
      expect(data.getUint32(20), 512, reason: 'Неверная высота $asset');
      expect(bytes[25], 6, reason: '$asset должен быть PNG с alpha-каналом');
    }

    final actualAssets = Directory('assets/fighters')
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.png'))
        .map((file) => file.path)
        .toSet();
    expect(actualAssets, expectedAssets);
  });
}
