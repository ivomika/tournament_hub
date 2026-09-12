import 'package:tournament_app/domain/character_assignment/ports/random_port.dart';
import 'package:tournament_app/domain/character_assignment/value_objects/character_assignment_set.dart';
import 'package:tournament_app/domain/game/entities/character.dart';
import 'package:tournament_app/domain/tournament/entities/participant.dart';
import 'package:tournament_app/domain/tournament/value_objects/participant_id.dart';

abstract interface class CharacterDistributionPort {
  CharacterAssignmentSet distribute({
    required Iterable<Participant> participants,
    required Iterable<Character> roster,
    required RandomPort random,
  });

  CharacterAssignmentSet redistributeOne({
    required CharacterAssignmentSet assignments,
    required ParticipantId participantId,
    required Iterable<Character> roster,
    required RandomPort random,
  });
}
