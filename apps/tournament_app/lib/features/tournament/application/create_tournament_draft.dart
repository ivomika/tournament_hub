import 'package:tournament_app/core/common/domain/id_generator.dart';
import 'package:tournament_app/features/guest_profile/domain/entities/guest_profile.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_participant.dart';
import 'package:tournament_app/features/tournament/domain/repositories/tournament_repository.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_name.dart';

final class CreateTournamentDraft {
  const CreateTournamentDraft(this._repository, this._idGenerator);

  final TournamentRepository _repository;
  final IdGenerator _idGenerator;

  Future<TournamentDraft> execute({
    required String name,
    required LocalProfile owner,
    required Iterable<GuestProfile> guests,
  }) async {
    final participants = <TournamentParticipant>[
      TournamentParticipant.fromLocalProfile(owner),
      ...guests.map(TournamentParticipant.fromGuestProfile),
    ];
    final draft = TournamentDraft(
      id: TournamentId(_idGenerator.nextId()),
      name: TournamentName(name),
      participants: participants,
    );
    await _repository.saveActiveDraft(draft);
    return draft;
  }
}
