import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tournament_app/domain/operations/managed_operation.dart';
import 'package:tournament_app/domain/operations/operation_outcome.dart';
import 'package:tournament_app/domain/operations/operation_request.dart';
import 'package:tournament_app/domain/operations/operation_scope.dart';
import 'package:tournament_app/domain/profile/local_profile.dart';
import 'package:tournament_app/domain/profile/profile_exception.dart';
import 'package:tournament_app/domain/profile/update_profile_name_use_case.dart';
import 'package:tournament_app/presentation/navigation/navigation_feedback.dart';
import 'package:tournament_app/presentation/navigation/navigation_intent.dart';
import 'package:tournament_app/presentation/screens/profile_edit/profile_edit_screen_state.dart';

final class ProfileEditController implements Listenable {
  ProfileEditController({
    required String initialName,
    required this.updateProfile,
    required this.navigation,
  }) : _state = ValueNotifier(
         ProfileEditScreenState(
           name: initialName,
           phase: ProfileEditPhase.editing,
         ),
       );

  final UpdateProfileNameUseCase updateProfile;
  final NavigationIntentSink navigation;
  final ValueNotifier<ProfileEditScreenState> _state;
  final OperationScope _operations = OperationScope();
  Future<void>? _saving;
  int _attempt = 0;
  Future<void>? _closing;
  ManagedOperation<NavigationFeedback>? _transition;

  ProfileEditScreenState get state => _state.value;

  @override
  void addListener(VoidCallback listener) => _state.addListener(listener);

  @override
  void removeListener(VoidCallback listener) => _state.removeListener(listener);

  void nameChanged(String name) {
    _operations.run<void>(
      request: () => OperationRequest(
        result: Future.sync(() {
          if (!state.busy) {
            _state.value = ProfileEditScreenState(
              name: name,
              phase: ProfileEditPhase.editing,
            );
          }
        }),
        onCancel: _release,
      ),
      onResult: _ignore,
      onError: _report,
    );
  }

  Future<void> save() {
    final saving = _saving;
    if (saving != null) return saving;
    final completion = Completer<void>();
    _saving = completion.future;
    completion.complete(_save());
    return completion.future;
  }

  Future<void> _save() async {
    try {
      final operation = _operations.run<LocalProfile>(
        request: _updateRequest,
        onResult: _saved,
        onError: _failed,
      );
      if (await operation.result is OperationCompleted<LocalProfile>) {
        await _transition?.result;
      }
    } finally {
      _saving = null;
    }
  }

  OperationRequest<LocalProfile> _updateRequest() {
    _state.value = ProfileEditScreenState(
      name: state.name,
      phase: ProfileEditPhase.saving,
    );
    return updateProfile.start(state.name, attempt: ++_attempt);
  }

  void _saved(LocalProfile profile) {
    _state.value = ProfileEditScreenState(
      name: profile.name!.value,
      phase: ProfileEditPhase.completed,
    );
    _transition = _operations.run(
      request: _savedNavigation,
      onResult: _navigationResult,
      onError: _navigationFailed,
    );
  }

  OperationRequest<NavigationFeedback> _savedNavigation() => OperationRequest(
    result: navigation.submit(const ProfileNameSavedIntent()),
    onCancel: _release,
  );

  Future<void> back() async {
    final operation = _operations.run<NavigationFeedback>(
      request: _backNavigation,
      onResult: _ignoreFeedback,
      onError: _report,
    );
    await operation.result;
  }

  OperationRequest<NavigationFeedback> _backNavigation() => OperationRequest(
    result: navigation.submit(const BackRequestedIntent()),
    onCancel: _release,
  );

  void _navigationResult(NavigationFeedback feedback) {
    if (feedback is! NavigationAccepted) _showNavigationError();
  }

  void _navigationFailed(Object error, StackTrace stackTrace) {
    _showNavigationError();
  }

  void _showNavigationError() {
    _state.value = ProfileEditScreenState(
      name: state.name,
      phase: ProfileEditPhase.navigationError,
    );
  }

  void _failed(Object error, StackTrace stackTrace) {
    final invalid =
        error is ProfileException &&
        error.reason == ProfileFailureReason.invalidName;
    _state.value = ProfileEditScreenState(
      name: state.name,
      phase: invalid
          ? ProfileEditPhase.invalidName
          : ProfileEditPhase.saveError,
    );
  }

  Future<void> close() => _closing ??= _close();

  Future<void> _close() async {
    try {
      await _operations.close();
    } finally {
      _state.dispose();
    }
  }

  static Future<void> _release() => Future<void>.value();

  static void _ignore(void value) {}

  static void _ignoreFeedback(NavigationFeedback feedback) {}

  static void _report(Object error, StackTrace stackTrace) =>
      Zone.current.handleUncaughtError(error, stackTrace);
}
