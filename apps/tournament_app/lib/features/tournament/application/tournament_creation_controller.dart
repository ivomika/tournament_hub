import 'package:flutter/foundation.dart';
import 'package:tournament_app/features/guest_profile/application/guest_profile_manager.dart';
import 'package:tournament_app/features/guest_profile/domain/entities/guest_profile.dart';
import 'package:tournament_app/features/guest_profile/domain/exceptions/guest_profile_validation_exception.dart';
import 'package:tournament_app/features/guest_profile/domain/value_objects/guest_profile_id.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/tournament/application/create_tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_storage_exception.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';

enum TournamentCreationStatus { editing, saving, saved }

final class TournamentCreationController extends ChangeNotifier {
  TournamentCreationController(
    this._guestManager,
    this._createDraft, {
    required this.owner,
  });

  final LocalProfile owner;
  final GuestProfileManager _guestManager;
  final CreateTournamentDraft _createDraft;

  TournamentCreationStatus _status = TournamentCreationStatus.editing;
  String? _errorMessage;
  TournamentDraft? _savedDraft;

  TournamentCreationStatus get status => _status;
  String? get errorMessage => _errorMessage;
  TournamentDraft? get savedDraft => _savedDraft;
  List<GuestProfile> get guests => _guestManager.profiles;
  bool get canSubmit =>
      guests.isNotEmpty && _status == TournamentCreationStatus.editing;

  bool addGuest(String nickname) {
    try {
      _guestManager.add(nickname);
      _errorMessage = null;
      notifyListeners();
      return true;
    } on GuestProfileValidationException catch (error) {
      _errorMessage = error.message;
      notifyListeners();
      return false;
    }
  }

  bool renameGuest(GuestProfileId id, String nickname) {
    try {
      _guestManager.rename(id, nickname);
      _errorMessage = null;
      notifyListeners();
      return true;
    } on GuestProfileValidationException catch (error) {
      _errorMessage = error.message;
      notifyListeners();
      return false;
    }
  }

  void removeGuest(GuestProfileId id) {
    _guestManager.remove(id);
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> create(String name) async {
    if (_status == TournamentCreationStatus.saving) return false;

    _status = TournamentCreationStatus.saving;
    _errorMessage = null;
    notifyListeners();
    try {
      _savedDraft = await _createDraft.execute(
        name: name,
        owner: owner,
        guests: guests,
      );
      _status = TournamentCreationStatus.saved;
      return true;
    } on TournamentValidationException catch (error) {
      _errorMessage = error.message;
      _status = TournamentCreationStatus.editing;
      return false;
    } on TournamentStorageException catch (error) {
      _errorMessage = error.message;
      _status = TournamentCreationStatus.editing;
      return false;
    } on Object {
      _errorMessage = 'Не удалось сохранить черновик турнира.';
      _status = TournamentCreationStatus.editing;
      return false;
    } finally {
      notifyListeners();
    }
  }
}
