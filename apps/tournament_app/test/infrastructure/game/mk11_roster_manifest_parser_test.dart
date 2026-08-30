import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/infrastructure/game/mk11_roster_manifest_parser.dart';

void main() {
  test('runtime manifest parses exact 37-fighter roster', () async {
    final manifest = await File('assets/fighters/manifest.json').readAsString();
    final game = const Mk11RosterManifestParser().parse(manifest);
    expect(game.gameId, 'mk11-ultimate');
    expect(game.fighters, hasLength(37));
    expect(game.fighters.map((fighter) => fighter.id).toSet(), hasLength(37));
    expect(
      game.fighters
          .singleWhere((fighter) => fighter.id.value == 'sub-zero')
          .displayName,
      'Sub-Zero',
    );
  });

  test('unknown or duplicate roster entry is rejected', () async {
    final manifest = await File('assets/fighters/manifest.json').readAsString();
    final corrupted = manifest.replaceFirst(
      '"id": "baraka"',
      '"id": "unknown"',
    );
    expect(
      () => const Mk11RosterManifestParser().parse(corrupted),
      throwsFormatException,
    );
  });
}
