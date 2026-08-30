import 'dart:convert';

import '../../domain/game/fighter.dart';
import '../../domain/game/game_definition.dart';

final class Mk11RosterManifestParser {
  const Mk11RosterManifestParser();

  static const _names = <String, String>{
    'baraka': 'Baraka',
    'cassie-cage': 'Cassie Cage',
    'cetrion': 'Cetrion',
    'dvorah': "D'Vorah",
    'erron-black': 'Erron Black',
    'frost': 'Frost',
    'geras': 'Geras',
    'jacqui-briggs': 'Jacqui Briggs',
    'jade': 'Jade',
    'jax-briggs': 'Jax Briggs',
    'johnny-cage': 'Johnny Cage',
    'kabal': 'Kabal',
    'kano': 'Kano',
    'kitana': 'Kitana',
    'kollector': 'Kollector',
    'kotal-kahn': 'Kotal Kahn',
    'kung-lao': 'Kung Lao',
    'liu-kang': 'Liu Kang',
    'noob-saibot': 'Noob Saibot',
    'raiden': 'Raiden',
    'scorpion': 'Scorpion',
    'shao-kahn': 'Shao Kahn',
    'skarlet': 'Skarlet',
    'sonya-blade': 'Sonya Blade',
    'sub-zero': 'Sub-Zero',
    'shang-tsung': 'Shang Tsung',
    'nightwolf': 'Nightwolf',
    'sindel': 'Sindel',
    'terminator-t800': 'Terminator T-800',
    'joker': 'The Joker',
    'spawn': 'Spawn',
    'fujin': 'Fujin',
    'sheeva': 'Sheeva',
    'robocop': 'RoboCop',
    'mileena': 'Mileena',
    'rain': 'Rain',
    'rambo': 'Rambo',
  };

  GameDefinition parse(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, Object?> ||
        decoded['schemaVersion'] != 1 ||
        decoded['roster'] != 'Mortal Kombat 11 Ultimate' ||
        decoded['format'] != 'png' ||
        decoded['width'] != 512 ||
        decoded['height'] != 512 ||
        decoded['background'] != 'transparent') {
      throw const FormatException('Unsupported MK11 roster manifest.');
    }
    final avatars = decoded['avatars'];
    if (avatars is! List<Object?> || avatars.length != _names.length) {
      throw const FormatException(
        'MK11 roster must contain exactly 37 fighters.',
      );
    }
    final fighters = avatars
        .map((entry) {
          if (entry is! Map<String, Object?>) {
            throw const FormatException('Invalid fighter manifest entry.');
          }
          final id = entry['id'];
          final asset = entry['asset'];
          if (id is! String ||
              asset != 'assets/fighters/$id.png' ||
              !_names.containsKey(id)) {
            throw const FormatException(
              'Unknown fighter or unsafe asset path.',
            );
          }
          return Fighter(
            id: FighterId(id),
            displayName: _names[id]!,
            assetPath: asset as String,
          );
        })
        .toList(growable: false);
    if (fighters.map((fighter) => fighter.id).toSet().length != _names.length ||
        !fighters
            .map((fighter) => fighter.id.value)
            .toSet()
            .containsAll(_names.keys)) {
      throw const FormatException(
        'MK11 roster IDs are incomplete or duplicated.',
      );
    }
    return GameDefinition(
      gameId: 'mk11-ultimate',
      rosterName: 'Mortal Kombat 11 Ultimate',
      fighters: fighters,
    );
  }
}
