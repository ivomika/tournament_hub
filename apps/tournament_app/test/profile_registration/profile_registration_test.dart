import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/app/bootstrap/application_bootstrap_plan.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_runner.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_state.dart';
import 'package:tournament_app/app/navigation/app_navigation_session.dart';
import 'package:tournament_app/app/routing/app_routes.dart';
import 'package:tournament_app/app/tournament_app.dart';
import 'package:tournament_app/domain/identifiers/identifier_generator.dart';
import 'package:tournament_app/domain/identifiers/unique_identifier.dart';
import 'package:tournament_app/domain/operations/operation_outcome.dart';
import 'package:tournament_app/domain/operations/operation_request.dart';
import 'package:tournament_app/domain/operations/operation_scope.dart';
import 'package:tournament_app/domain/profile/local_profile.dart';
import 'package:tournament_app/domain/profile/profile_exception.dart';
import 'package:tournament_app/domain/profile/profile_id.dart';
import 'package:tournament_app/domain/profile/profile_name.dart';
import 'package:tournament_app/domain/profile/profile_repository.dart';
import 'package:tournament_app/domain/profile/register_profile_use_case.dart';
import 'package:tournament_app/infrastructure/identifiers/uuid_identifier_generator.dart';
import 'package:tournament_app/infrastructure/profile/stored_profile_repository.dart';
import 'package:tournament_app/infrastructure/storage/key_value_storage.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/navigation/navigation_feedback.dart';
import 'package:tournament_app/presentation/navigation/navigation_intent.dart';
import 'package:tournament_app/presentation/screens/registration/registration_controller.dart';
import 'package:tournament_app/presentation/screens/registration/registration_screen.dart';
import 'package:tournament_app/presentation/screens/registration/registration_screen_state.dart';

void main() {
  _DomainTests.run();
  _StorageTests.run();
  _ControllerTests.run();
  _StartupTests.run();
}

abstract final class _Profiles {
  static const identifierText = '6fa459ea-ee8a-4ca4-894e-db77e160355e';

  static ProfileId get identifier =>
      ProfileId(UniqueIdentifier(identifierText));

  static LocalProfile complete() =>
      LocalProfile(id: identifier, name: ProfileName('Иван'));

  static LocalProfile incomplete() => LocalProfile(id: identifier);
}

abstract final class _DomainTests {
  static void run() {
    test(
      'registration trims the name and saves the generated typed ID',
      () async {
        final repository = _ProfileRepository();
        final identifiers = _Identifiers();
        final useCase = RegisterProfileUseCase(
          repository: repository,
          identifiers: identifiers,
        );
        final profile = await useCase.start('  Иван  ').result;
        expect(profile.name!.value, 'Иван');
        expect(profile.id, _Profiles.identifier);
        expect(repository.stored, same(profile));
        expect(repository.writes, 1);
        expect(identifiers.calls, 1);
      },
    );

    test('blank input never allocates or writes a profile', () async {
      final repository = _ProfileRepository();
      final identifiers = _Identifiers();
      final useCase = RegisterProfileUseCase(
        repository: repository,
        identifiers: identifiers,
      );
      await expectLater(
        Future.sync(() => useCase.start(' \t\n ').result),
        throwsA(
          isA<ProfileException>().having(
            (failure) => failure.reason,
            'reason',
            ProfileFailureReason.invalidName,
          ),
        ),
      );
      expect(repository.writes, 0);
      expect(identifiers.calls, 0);
    });

    test('completing an existing profile preserves its identity', () async {
      final repository = _ProfileRepository()..stored = _Profiles.incomplete();
      final identifiers = _Identifiers();
      final profile = await RegisterProfileUseCase(
        repository: repository,
        identifiers: identifiers,
      ).start('Анна').result;
      expect(profile.id, _Profiles.identifier);
      expect(profile.name!.value, 'Анна');
      expect(identifiers.calls, 0);
    });

    test(
      'a completed profile is returned without replacing its data',
      () async {
        final repository = _ProfileRepository()..stored = _Profiles.complete();
        final identifiers = _Identifiers();
        final profile = await RegisterProfileUseCase(
          repository: repository,
          identifiers: identifiers,
        ).start('Другое имя').result;
        expect(profile.id, _Profiles.identifier);
        expect(profile.name!.value, 'Иван');
        expect(repository.writes, 0);
        expect(identifiers.calls, 0);
      },
    );

    test('read failure is not treated as an absent profile', () async {
      final repository = _ProfileRepository()
        ..readFailure = const ProfileException(ProfileFailureReason.read);
      final identifiers = _Identifiers();
      await expectLater(
        RegisterProfileUseCase(
          repository: repository,
          identifiers: identifiers,
        ).start('Иван').result,
        throwsA(isA<ProfileException>()),
      );
      expect(repository.writes, 0);
      expect(identifiers.calls, 0);
    });

    test(
      'owner cancellation during read prevents subsequent ID and save',
      () async {
        final repository = _ProfileRepository()
          ..readGate = Completer<LocalProfile?>();
        final identifiers = _Identifiers();
        final scope = OperationScope();
        final delivery = _ProfileDelivery();
        final useCase = RegisterProfileUseCase(
          repository: repository,
          identifiers: identifiers,
        );
        final operation = scope.run(
          request: () => useCase.start('Иван'),
          onResult: delivery.accept,
          onError: delivery.fail,
        );
        await scope.close();
        expect(await operation.result, isA<OperationCancelled<LocalProfile>>());
        repository.readGate!.complete(null);
        await Future<void>.delayed(Duration.zero);
        expect(repository.readCancellations, 1);
        expect(identifiers.calls, 0);
        expect(repository.writes, 0);
        expect(delivery.profiles, isEmpty);
        expect(delivery.errors, isEmpty);
      },
    );

    test('the common UUID adapter generates distinct well formed v4 IDs', () {
      final generator = UuidIdentifierGenerator();
      final identifiers = List.generate(64, (_) => generator.generate().value);
      final format = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      );
      expect(identifiers.every(format.hasMatch), isTrue);
      expect(identifiers.toSet(), hasLength(identifiers.length));
    });
  }
}

abstract final class _StorageTests {
  static void run() {
    test(
      'a fresh repository restores a saved typed profile from storage',
      () async {
        final storage = _TextStorage();
        final first = StoredProfileRepository(storage: storage);
        expect(await first.read().result, isNull);
        await first.save(_Profiles.complete()).result;
        final restored = await StoredProfileRepository(storage: storage)
            .read()
            .result;
        expect(restored!.id, _Profiles.identifier);
        expect(restored.name!.value, 'Иван');
      },
    );

    test(
      'a persisted incomplete profile retains its ID across reload',
      () async {
        final storage = _TextStorage();
        await StoredProfileRepository(storage: storage)
            .save(_Profiles.incomplete())
            .result;
        final restored = await StoredProfileRepository(storage: storage)
            .read()
            .result;
        expect(restored!.id, _Profiles.identifier);
        expect(restored.name, isNull);
      },
    );

    test(
      'corrupt persisted data is a typed error and is never overwritten',
      () async {
        final storage = _TextStorage()..payload = '{broken-json';
        await expectLater(
          StoredProfileRepository(storage: storage).read().result,
          throwsA(
            isA<ProfileException>().having(
              (failure) => failure.reason,
              'reason',
              ProfileFailureReason.corrupt,
            ),
          ),
        );
        expect(storage.payload, '{broken-json');
        expect(storage.writes, 0);
      },
    );

    test(
      'storage write failure does not claim registration succeeded',
      () async {
        final storage = _TextStorage()
          ..writeFailure = StateError('disk unavailable');
        await expectLater(
          StoredProfileRepository(storage: storage)
              .save(_Profiles.complete())
              .result,
          throwsA(
            isA<ProfileException>().having(
              (failure) => failure.reason,
              'reason',
              ProfileFailureReason.write,
            ),
          ),
        );
        expect(
          await StoredProfileRepository(storage: storage).read().result,
          isNull,
        );
      },
    );
  }
}

abstract final class _ControllerTests {
  static void run() {
    test(
      'double submit has one write, one ID and one completion intent',
      () async {
        final repository = _ProfileRepository()..saveGate = Completer<void>();
        final identifiers = _Identifiers();
        final navigation = _NavigationSink();
        final controller = RegistrationController(
          registerProfile: RegisterProfileUseCase(
            repository: repository,
            identifiers: identifiers,
          ),
          navigation: navigation,
        );
        controller.nameChanged('Иван');
        final first = controller.submit();
        final second = controller.submit();
        await Future<void>.delayed(Duration.zero);
        expect(controller.state.phase, RegistrationPhase.saving);
        expect(repository.writes, 1);
        expect(identifiers.calls, 1);
        expect(navigation.intents, isEmpty);
        repository.saveGate!.complete();
        await Future.wait([first, second]);
        expect(navigation.intents, hasLength(1));
        expect(navigation.intents.single, isA<ProfileRegisteredIntent>());
        await controller.close();
      },
    );

    test(
      'failed save preserves input, stays on registration and can retry',
      () async {
        final repository = _ProfileRepository()
          ..saveFailure = const ProfileException(ProfileFailureReason.write);
        final navigation = _NavigationSink();
        final controller = RegistrationController(
          registerProfile: RegisterProfileUseCase(
            repository: repository,
            identifiers: _Identifiers(),
          ),
          navigation: navigation,
        );
        controller.nameChanged('Иван');
        await controller.submit();
        expect(controller.state.phase, RegistrationPhase.saveError);
        expect(controller.state.name, 'Иван');
        expect(navigation.intents, isEmpty);
        repository.saveFailure = null;
        await controller.submit();
        expect(repository.stored!.name!.value, 'Иван');
        expect(navigation.intents, hasLength(1));
        await controller.close();
      },
    );

    test('closing the owner during save suppresses late navigation', () async {
      final repository = _ProfileRepository()..saveGate = Completer<void>();
      final navigation = _NavigationSink();
      final controller = RegistrationController(
        registerProfile: RegisterProfileUseCase(
          repository: repository,
          identifiers: _Identifiers(),
        ),
        navigation: navigation,
      );
      controller.nameChanged('Иван');
      final submitting = controller.submit();
      await Future<void>.delayed(Duration.zero);
      await controller.close();
      await controller.close();
      await submitting;
      repository.saveGate!.complete();
      await Future<void>.delayed(Duration.zero);
      expect(repository.saveCancellations, 1);
      expect(navigation.intents, isEmpty);
    });
  }
}

abstract final class _StartupTests {
  static void run() {
    testWidgets(
      'missing profile opens registration; saving and restarting opens home',
      _firstLaunch,
    );
    testWidgets(
      'incomplete profile opens registration without allocating another ID',
      _incomplete,
    );
    testWidgets(
      'read failure blocks startup; retry restores the completed profile',
      _readRetry,
    );
  }

  static Future<void> _firstLaunch(WidgetTester tester) async {
    final repository = _ProfileRepository();
    final identifiers = _Identifiers();
    final runner = _runner(repository, identifiers);
    await runner.runBeforeApp();
    final ready =
        await runner.runAfterApp() as BootstrapReady<AppNavigationSession>;
    final navigation = ready.session.value;
    await tester.pumpWidget(
      TournamentApp(theme: AppTheme.dark(), navigation: navigation),
    );
    await tester.pumpAndSettle();
    expect(navigation.currentRoute, isA<RegistrationRoute>());
    expect(find.byType(RegistrationScreen), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(navigation.currentRoute, isA<RegistrationRoute>());
    // A real direct URL cannot bypass the profile guard.
    navigation.router.go(const ProfileRoute().location);
    await tester.pumpAndSettle();
    expect(navigation.currentRoute, isA<RegistrationRoute>());
    await tester.enterText(find.byType(TextField), '  Иван  ');
    final context = tester.element(find.byType(RegistrationScreen));
    await tester.tap(
      find.text(FoundationLocalizations.of(context).screenRegistrationContinue),
    );
    await tester.pumpAndSettle();
    expect(navigation.currentRoute, isA<HomeRoute>());
    expect(repository.stored!.name!.value, 'Иван');
    expect(identifiers.calls, 1);
    // Registration is no longer a destination for a complete profile.
    navigation.router.go(const RegistrationRoute().location);
    await tester.pumpAndSettle();
    expect(navigation.currentRoute, isA<HomeRoute>());
    await tester.pumpWidget(const SizedBox.shrink());
    await ready.session.close();
    await runner.close();

    final restarted = _runner(repository, identifiers);
    await restarted.runBeforeApp();
    final next =
        await restarted.runAfterApp() as BootstrapReady<AppNavigationSession>;
    expect(next.session.value.currentRoute, isA<HomeRoute>());
    expect(repository.stored!.id, _Profiles.identifier);
    expect(identifiers.calls, 1);
    await next.session.close();
    await restarted.close();
  }

  static Future<void> _incomplete(WidgetTester tester) async {
    final repository = _ProfileRepository()..stored = _Profiles.incomplete();
    final identifiers = _Identifiers();
    final runner = _runner(repository, identifiers);
    await runner.runBeforeApp();
    final ready =
        await runner.runAfterApp() as BootstrapReady<AppNavigationSession>;
    expect(ready.session.value.currentRoute, isA<RegistrationRoute>());
    expect(identifiers.calls, 0);
    await ready.session.close();
    await runner.close();
  }

  static Future<void> _readRetry(WidgetTester tester) async {
    final repository = _ProfileRepository()
      ..readFailure = const ProfileException(ProfileFailureReason.read);
    final identifiers = _Identifiers();
    final runner = _runner(repository, identifiers);
    await runner.runBeforeApp();
    final failed = await runner.runAfterApp();
    expect(failed, isA<BootstrapFailed<AppNavigationSession>>());
    expect((failed as BootstrapFailed<AppNavigationSession>).canRetry, isTrue);
    expect(repository.writes, 0);
    expect(identifiers.calls, 0);
    repository.readFailure = null;
    repository.stored = _Profiles.complete();
    final ready = await runner.retry() as BootstrapReady<AppNavigationSession>;
    expect(ready.session.value.currentRoute, isA<HomeRoute>());
    expect(identifiers.calls, 0);
    await ready.session.close();
    await runner.close();
  }

  static BootstrapRunner<AppNavigationSession> _runner(
    ProfileRepository repository,
    IdentifierGenerator identifiers,
  ) => BootstrapRunner(
    plan: ApplicationBootstrapPlan.create(
      profileRepository: repository,
      identifierGenerator: identifiers,
    ),
  );
}

final class _Identifiers implements IdentifierGenerator {
  int calls = 0;

  @override
  UniqueIdentifier generate() {
    calls++;
    return UniqueIdentifier(_Profiles.identifierText);
  }
}

final class _ProfileRepository implements ProfileRepository {
  LocalProfile? stored;
  ProfileException? readFailure, saveFailure;
  Completer<LocalProfile?>? readGate;
  Completer<void>? saveGate;
  int writes = 0, readCancellations = 0, saveCancellations = 0;

  @override
  OperationRequest<LocalProfile?> read() => OperationRequest(
    result: Future.sync(() {
      final failure = readFailure;
      if (failure != null) throw failure;
      return readGate?.future ?? Future.value(stored);
    }),
    onCancel: _cancelRead,
  );

  @override
  OperationRequest<void> save(LocalProfile profile) {
    writes++;
    return OperationRequest(result: _save(profile), onCancel: _cancelSave);
  }

  Future<void> _save(LocalProfile profile) async {
    final failure = saveFailure;
    if (failure != null) throw failure;
    final pending = saveGate;
    if (pending != null) await pending.future;
    stored = profile;
  }

  Future<void> _cancelRead() async {
    readCancellations++;
  }

  Future<void> _cancelSave() async {
    saveCancellations++;
  }
}

final class _TextStorage implements KeyValueStorage {
  String? payload;
  Object? writeFailure;
  int writes = 0;

  @override
  OperationRequest<String?> read(StorageKey key) =>
      OperationRequest(result: Future.value(payload), onCancel: _cancel);

  @override
  OperationRequest<void> write(StorageKey key, String value) =>
      OperationRequest(
        result: Future.sync(() {
          final failure = writeFailure;
          if (failure != null) throw failure;
          writes++;
          payload = value;
        }),
        onCancel: _cancel,
      );

  Future<void> _cancel() async {}
}

final class _ProfileDelivery {
  final List<LocalProfile> profiles = [];
  final List<Object> errors = [];

  void accept(LocalProfile profile) => profiles.add(profile);

  void fail(Object error, StackTrace stackTrace) => errors.add(error);
}

final class _NavigationSink implements NavigationIntentSink {
  final List<NavigationIntent> intents = [];

  @override
  Future<NavigationFeedback> submit(NavigationIntent intent) async {
    intents.add(intent);
    return const NavigationAccepted();
  }
}
