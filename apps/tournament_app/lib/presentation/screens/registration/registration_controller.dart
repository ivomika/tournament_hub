import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tournament_app/domain/operations/managed_operation.dart';
import 'package:tournament_app/domain/operations/operation_outcome.dart';
import 'package:tournament_app/domain/operations/operation_request.dart';
import 'package:tournament_app/domain/operations/operation_scope.dart';
import 'package:tournament_app/domain/profile/local_profile.dart';
import 'package:tournament_app/domain/profile/profile_exception.dart';
import 'package:tournament_app/domain/profile/register_profile_use_case.dart';
import 'package:tournament_app/presentation/navigation/navigation_feedback.dart';
import 'package:tournament_app/presentation/navigation/navigation_intent.dart';
import 'package:tournament_app/presentation/screens/registration/registration_screen_state.dart';

final class RegistrationController implements Listenable {
  RegistrationController({
    required this.registerProfile,
    required this.navigation,
  });

  final RegisterProfileUseCase registerProfile;
  final NavigationIntentSink navigation;
  final OperationScope _operations = OperationScope();
  final ValueNotifier<RegistrationScreenState> _state = ValueNotifier(
    const RegistrationScreenState(),
  );
  Future<void>? _submitting;
  Future<void>? _closing;
  ManagedOperation<NavigationFeedback>? _transition;

  RegistrationScreenState get state => _state.value;

  @override
  void addListener(VoidCallback listener) => _state.addListener(listener);

  @override
  void removeListener(VoidCallback listener) => _state.removeListener(listener);

  void nameChanged(String name) {
    _operations.run<void>(
      request: () => OperationRequest(
        result: Future.sync(() {
          if (!state.busy) _state.value = RegistrationScreenState(name: name);
        }),
        onCancel: _release,
      ),
      onResult: _ignore,
      onError: _report,
    );
  }

  Future<void> submit() {
    final submitting = _submitting;
    if (submitting != null) return submitting;
    final completion = Completer<void>();
    _submitting = completion.future;
    completion.complete(_submit());
    return completion.future;
  }

  Future<void> _submit() async {
    try {
      final operation = _operations.run<LocalProfile>(
        request: _registrationRequest,
        onResult: _registered,
        onError: _failed,
      );
      final result = await operation.result;
      if (result is OperationCompleted<LocalProfile>) {
        await _transition?.result;
      }
    } finally {
      _submitting = null;
    }
  }

  OperationRequest<LocalProfile> _registrationRequest() {
    _state.value = RegistrationScreenState(
      name: state.name,
      phase: RegistrationPhase.saving,
    );
    return registerProfile.start(state.name);
  }

  void _registered(LocalProfile profile) {
    _state.value = RegistrationScreenState(
      name: profile.name!.value,
      phase: RegistrationPhase.completed,
    );
    _transition = _operations.run(
      request: _navigationRequest,
      onResult: _navigationResult,
      onError: _failed,
    );
  }

  OperationRequest<NavigationFeedback> _navigationRequest() => OperationRequest(
    result: navigation.submit(const ProfileRegisteredIntent()),
    onCancel: _release,
  );

  void _navigationResult(NavigationFeedback feedback) {
    if (feedback is! NavigationAccepted) {
      _state.value = RegistrationScreenState(
        name: state.name,
        phase: RegistrationPhase.saveError,
      );
    }
  }

  void _failed(Object error, StackTrace stackTrace) {
    final invalidName =
        error is ProfileException &&
        error.reason == ProfileFailureReason.invalidName;
    _state.value = RegistrationScreenState(
      name: state.name,
      phase: invalidName
          ? RegistrationPhase.invalidName
          : RegistrationPhase.saveError,
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

  static void _ignore(void result) {}

  static void _report(Object error, StackTrace stackTrace) =>
      Zone.current.handleUncaughtError(error, stackTrace);
}
