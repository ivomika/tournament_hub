import 'package:flutter/foundation.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/profile/domain/exceptions/local_profile_storage_exception.dart';
import 'package:tournament_app/features/profile/domain/exceptions/local_profile_validation_exception.dart';
import 'package:tournament_app/features/profile/domain/repositories/local_profile_repository.dart';
import 'package:uuid/uuid.dart';

enum LocalProfileStatus { loading, requiresProfile, authenticated, failure }

final class LocalProfileController extends ChangeNotifier {
  LocalProfileController(this._repository, {String Function()? createId})
    : _createId = createId ?? const Uuid().v4;

  final LocalProfileRepository _repository;
  final String Function() _createId;

  LocalProfileStatus _status = LocalProfileStatus.loading;
  LocalProfile? _profile;
  String? _errorMessage;
  bool _isSaving = false;

  LocalProfileStatus get status => _status;
  LocalProfile? get profile => _profile;
  String? get errorMessage => _errorMessage;
  bool get isSaving => _isSaving;

  Future<void> initialize() async {
    _status = LocalProfileStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _repository.getProfile();
      _status = _profile == null
          ? LocalProfileStatus.requiresProfile
          : LocalProfileStatus.authenticated;
    } on LocalProfileStorageException catch (error) {
      _status = LocalProfileStatus.failure;
      _errorMessage = error.message;
    } on Object {
      _status = LocalProfileStatus.failure;
      _errorMessage = 'Не удалось загрузить локальный профиль.';
    }

    notifyListeners();
  }

  Future<bool> createProfile(String nickname) async {
    if (_isSaving) return false;

    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final profile = LocalProfile.create(id: _createId(), nickname: nickname);
      await _repository.saveProfile(profile);
      _profile = profile;
      _status = LocalProfileStatus.authenticated;
      return true;
    } on LocalProfileValidationException catch (error) {
      _errorMessage = error.message;
      return false;
    } on LocalProfileStorageException catch (error) {
      _errorMessage = error.message;
      return false;
    } on Object {
      _errorMessage = 'Не удалось сохранить локальный профиль.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> updateNickname(String nickname) async {
    final currentProfile = _profile;
    if (_isSaving || currentProfile == null) return false;

    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedProfile = currentProfile.rename(nickname);
      if (updatedProfile == currentProfile) {
        _errorMessage = 'Nickname не изменился.';
        return false;
      }

      await _repository.saveProfile(updatedProfile);
      _profile = updatedProfile;
      return true;
    } on LocalProfileValidationException catch (error) {
      _errorMessage = error.message;
      return false;
    } on LocalProfileStorageException catch (error) {
      _errorMessage = error.message;
      return false;
    } on Object {
      _errorMessage = 'Не удалось сохранить nickname.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void clearError() {
    if (_errorMessage == null) return;
    _errorMessage = null;
    notifyListeners();
  }
}
