import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/features/guest_profile/domain/entities/guest_profile.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_participant.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_name.dart';

void main() {
  final owner = LocalProfile.create(id: 'local-1', nickname: 'Владелец');
  final guest = GuestProfile.create(id: 'guest-1', nickname: 'Гость');

  test('создаёт draft из local profile и гостя', () {
    final draft = TournamentDraft(
      id: TournamentId('tournament-1'),
      name: TournamentName('Вечерний турнир'),
      participants: [
        TournamentParticipant.fromLocalProfile(owner),
        TournamentParticipant.fromGuestProfile(guest),
      ],
    );

    expect(draft.participants, hasLength(2));
    expect(() => draft.participants.clear(), throwsUnsupportedError);
  });

  test('отклоняет состав менее двух участников', () {
    expect(
      () => TournamentDraft(
        id: TournamentId('tournament-1'),
        name: TournamentName('Турнир'),
        participants: [TournamentParticipant.fromLocalProfile(owner)],
      ),
      throwsA(isA<TournamentValidationException>()),
    );
  });

  test('требует ровно один local profile', () {
    expect(
      () => TournamentDraft(
        id: TournamentId('tournament-1'),
        name: TournamentName('Турнир'),
        participants: [
          TournamentParticipant.fromGuestProfile(guest),
          TournamentParticipant.fromGuestProfile(
            GuestProfile.create(id: 'guest-2', nickname: 'Второй'),
          ),
        ],
      ),
      throwsA(isA<TournamentValidationException>()),
    );
  });

  test('participant остаётся snapshot после переименования профилей', () {
    final localSnapshot = TournamentParticipant.fromLocalProfile(owner);
    final guestSnapshot = TournamentParticipant.fromGuestProfile(guest);

    owner.rename('Новое имя');
    guest.rename('Новое имя гостя');

    expect(localSnapshot.nickname.value, 'Владелец');
    expect(guestSnapshot.nickname.value, 'Гость');
  });
}
