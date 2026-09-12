import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:tournament_app/domain/game/entities/character.dart';
import 'package:tournament_app/domain/game/value_objects/character_id.dart';
import 'package:tournament_app/domain/game/value_objects/game_id.dart';

final class Game extends Equatable {
  Game({
    required this.id,
    required String displayName,
    required String rosterVersion,
    required Iterable<Character> characters,
  }) : displayName = _requireText(displayName, 'displayName'),
       rosterVersion = _requireText(rosterVersion, 'rosterVersion'),
       _characters = UnmodifiableListView(List.of(characters)) {
    if (_characters.isEmpty) {
      throw ArgumentError.value(
        characters,
        'characters',
        'Roster не может быть пустым.',
      );
    }
    if (_characters.any((character) => character.gameId != id)) {
      throw ArgumentError('Все Character должны принадлежать Game.');
    }
    if (_characters.map((character) => character.id).toSet().length !=
        _characters.length) {
      throw ArgumentError('CharacterId должен быть уникален внутри Game.');
    }
  }

  final GameId id;
  final String displayName;
  final String rosterVersion;
  final UnmodifiableListView<Character> _characters;

  List<Character> get characters => _characters;

  Character? findCharacter(CharacterId id) {
    for (final character in _characters) {
      if (character.id == id) return character;
    }
    return null;
  }

  bool containsCharacter(CharacterId id) => findCharacter(id) != null;

  static String _requireText(String value, String name) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(value, name, '$name не может быть пустым.');
    }
    return normalized;
  }

  @override
  List<Object> get props => [id, displayName, rosterVersion, _characters];
}
