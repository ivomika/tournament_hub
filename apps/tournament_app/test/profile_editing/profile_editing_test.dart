import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/app/logging/app_loggers.dart';
import 'package:tournament_app/infrastructure/logging/log_sink.dart';
import 'package:tournament_app/app/bootstrap/application_bootstrap_plan.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_runner.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_state.dart';
import 'package:tournament_app/app/navigation/app_navigation_session.dart';
import 'package:tournament_app/app/routing/app_routes.dart';
import 'package:tournament_app/app/tournament_app.dart';
import 'package:tournament_app/domain/identifiers/identifier_generator.dart';
import 'package:tournament_app/domain/identifiers/unique_identifier.dart';
import 'package:tournament_app/domain/logging/logger.dart';
import 'package:tournament_app/domain/logging/log_level.dart';
import 'package:tournament_app/domain/logging/log_record.dart';
import 'package:tournament_app/domain/logging/log_submission_result.dart';
import 'package:tournament_app/domain/logging/profile_log_event.dart';
import 'package:tournament_app/domain/operations/operation_request.dart';
import 'package:tournament_app/domain/profile/local_profile.dart';
import 'package:tournament_app/domain/profile/profile_exception.dart';
import 'package:tournament_app/domain/profile/profile_id.dart';
import 'package:tournament_app/domain/profile/profile_name.dart';
import 'package:tournament_app/domain/profile/profile_repository.dart';
import 'package:tournament_app/domain/profile/update_profile_name_use_case.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar.dart';
import 'package:tournament_app/presentation/design_system/components/metric/app_metric.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/navigation/navigation_feedback.dart';
import 'package:tournament_app/presentation/navigation/navigation_intent.dart';
import 'package:tournament_app/presentation/screens/home/home_screen.dart';
import 'package:tournament_app/presentation/screens/profile/profile_presentation_mapper.dart';
import 'package:tournament_app/presentation/screens/profile/profile_screen.dart';
import 'package:tournament_app/presentation/screens/profile/profile_screen_state.dart';
import 'package:tournament_app/presentation/screens/profile_edit/profile_edit_controller.dart';
import 'package:tournament_app/presentation/screens/profile_edit/profile_edit_screen.dart';
import 'package:tournament_app/presentation/screens/profile_edit/profile_edit_screen_state.dart';

void main() {
  _UpdateTests.run();
  _PresentationTests.run();
  _ControllerTests.run();
  _FlowTests.run();
}

abstract final class _ProfileData {
  static const oldName = 'Иван Михайлов';
  static const newName = 'Мария Петрова';

  static LocalProfile create([String name = oldName]) => LocalProfile(
    id: ProfileId(UniqueIdentifier('6fa459ea-ee8a-4ca4-894e-db77e160355e')),
    name: ProfileName(name),
  );
}

abstract final class _UpdateTests {
  static void run() {
    test('profile logging has an independent destination', () {
      final profile = _LogSink();
      final other = _LogSink();
      final loggers = AppLoggers(
        navigationSink: other,
        networkSink: other,
        bootstrapSink: other,
        profileSink: profile,
      );
      loggers.profile.log(ProfileLogEvent.updateStarted);
      expect(profile.records, hasLength(1));
      expect(profile.records.single.event, ProfileLogEvent.updateStarted);
      expect(other.records, isEmpty);
    });
    test(
      'update trims the name and preserves the existing profile ID',
      () async {
        final fixture = _Fixture();
        final originalId = fixture.repository.stored!.id;
        final profile = await fixture.useCase
            .start('  ${_ProfileData.newName}  ')
            .result;
        expect(profile.name!.value, _ProfileData.newName);
        expect(profile.id, originalId);
        expect(fixture.repository.stored, same(profile));
        expect(fixture.repository.writes, 1);
        expect(
          fixture.logger.events,
          containsAllInOrder([
            ProfileLogEvent.updateStarted,
            ProfileLogEvent.updateSucceeded,
          ]),
        );
      },
    );

    test('blank input does not overwrite the saved profile', () async {
      final fixture = _Fixture();
      await expectLater(
        Future.sync(() => fixture.useCase.start(' \n\t ').result),
        throwsA(
          isA<ProfileException>().having(
            (failure) => failure.reason,
            'reason',
            ProfileFailureReason.invalidName,
          ),
        ),
      );
      expect(fixture.repository.writes, 0);
      expect(fixture.repository.stored!.name!.value, _ProfileData.oldName);
      expect(fixture.logger.events, contains(ProfileLogEvent.updateRejected));
      expect(
        fixture.logger.events,
        isNot(contains(ProfileLogEvent.updateSucceeded)),
      );
    });

    test('unchanged normalized name avoids a redundant write', () async {
      final fixture = _Fixture();
      final original = fixture.repository.stored;
      final profile = await fixture.useCase
          .start('  ${_ProfileData.oldName}  ')
          .result;
      expect(profile.id, original!.id);
      expect(fixture.repository.writes, 0);
    });

    test(
      'missing profile is a typed failure rather than registration',
      () async {
        final fixture = _Fixture()..repository.stored = null;
        await expectLater(
          fixture.useCase.start(_ProfileData.newName).result,
          throwsA(
            isA<ProfileException>().having(
              (failure) => failure.reason,
              'reason',
              ProfileFailureReason.notFound,
            ),
          ),
        );
        expect(fixture.repository.writes, 0);
        expect(fixture.repository.stored, isNull);
      },
    );

    test('read failure never begins a write', () async {
      final fixture = _Fixture()
        ..repository.readFailure = const ProfileException(
          ProfileFailureReason.read,
        );
      await expectLater(
        fixture.useCase.start(_ProfileData.newName).result,
        throwsA(same(fixture.repository.readFailure)),
      );
      expect(fixture.repository.writes, 0);
      expect(
        fixture.logger.events,
        isNot(contains(ProfileLogEvent.updateSucceeded)),
      );
    });

    test(
      'failure logs retain cause, stack and execution without personal names',
      () async {
        final fixture = _Fixture();
        final error = ProfileException(
          ProfileFailureReason.write,
          cause: StateError('Native store unavailable'),
        );
        fixture.repository.writeFailure = error;
        await expectLater(
          fixture.useCase.start(_ProfileData.newName).result,
          throwsA(same(error)),
        );
        final failure = fixture.logger.records.singleWhere(
          (record) => record.event == ProfileLogEvent.updateFailed,
        );
        expect(failure.error, same(error));
        expect(failure.stackTrace, same(fixture.repository.failureStack));
        expect(failure.level, LogLevel.error);
        expect(
          failure.message,
          contains(fixture.identifiers.issued.single.value),
        );
        for (final record in fixture.logger.records) {
          expect(record.message, isNot(contains(_ProfileData.oldName)));
          expect(record.message, isNot(contains(_ProfileData.newName)));
        }
        expect(fixture.repository.stored!.name!.value, _ProfileData.oldName);
        expect(
          fixture.logger.events,
          isNot(contains(ProfileLogEvent.updateSucceeded)),
        );
      },
    );

    test(
      'rejected diagnostic output does not break successful saving',
      () async {
        final fixture = _Fixture();
        fixture.logger.result = LogRejected(
          StateError('Sink closed'),
          StackTrace.current,
        );
        final profile = await fixture.useCase
            .start(_ProfileData.newName)
            .result;
        expect(profile.name!.value, _ProfileData.newName);
        expect(fixture.repository.writes, 1);
      },
    );
  }
}

abstract final class _PresentationTests {
  static void run() {
    test('initials use the first and last complete Unicode graphemes', () {
      for (final sample in [
        (name: 'иван', initials: 'И'),
        (name: '  иван   михайлов  ', initials: 'ИМ'),
        (name: 'Иван Сергеевич Михайлов', initials: 'ИМ'),
        (name: 'Анна\nПетрова', initials: 'АП'),
        (name: '👩‍💻 Мария', initials: '👩‍💻М'),
        (name: 'е\u0308лена Петрова', initials: 'Е\u0308П'),
      ]) {
        final state = ProfilePresentationMapper.map(
          _ProfileData.create(sample.name),
        );
        expect(state.initials, sample.initials, reason: sample.name);
      }
    });

    testWidgets('profile hides statistics and their empty replacement', (
      tester,
    ) async {
      for (final statistics in [
        const ProfileStatistics(wins: '3', tournaments: '12', matches: '28'),
        null,
      ]) {
        await tester.pumpWidget(
          _ProfilePreview(
            state: ProfileScreenState(
              name: _ProfileData.oldName,
              initials: 'ИМ',
              statistics: statistics,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(AppMetric), findsNothing);
        final context = tester.element(find.byType(ProfileScreen));
        expect(
          find.text(FoundationLocalizations.of(context).screenAhead),
          findsNothing,
        );
        final avatar = tester.widget<AppAvatar>(find.byType(AppAvatar));
        expect(avatar.initials, 'ИМ');
        expect(tester.takeException(), isNull);
      }
    });
  }
}

abstract final class _ControllerTests {
  static void run() {
    test(
      'closing during read prevents write and observes the late error',
      () async {
        final fixture = _Fixture()
          ..repository.readGate = Completer<LocalProfile?>();
        final navigation = _NavigationSink();
        final controller = fixture.controller(navigation);
        controller.nameChanged(_ProfileData.newName);
        final saving = controller.save();
        await Future<void>.delayed(Duration.zero);
        await controller.close();
        await saving;
        fixture.repository.readGate!.completeError(
          StateError('late read failure'),
        );
        await Future<void>.delayed(Duration.zero);
        expect(fixture.repository.writes, 0);
        expect(navigation.intents, isEmpty);
        expect(
          fixture.logger.events.where(
            (event) => event == ProfileLogEvent.updateCancelled,
          ),
          hasLength(1),
        );
        expect(
          fixture.logger.events,
          isNot(contains(ProfileLogEvent.updateFailed)),
        );
      },
    );
    test(
      'double save has one write and one completion intent after confirmation',
      () async {
        final fixture = _Fixture()..repository.writeGate = Completer<void>();
        final navigation = _NavigationSink();
        final controller = fixture.controller(navigation);
        controller.nameChanged(_ProfileData.newName);
        final Future<void> first = controller.save();
        final Future<void> second = controller.save();
        await Future<void>.delayed(Duration.zero);
        expect(controller.state.phase, ProfileEditPhase.saving);
        expect(fixture.repository.writes, 1);
        expect(navigation.intents, isEmpty);
        expect(
          fixture.logger.events,
          isNot(contains(ProfileLogEvent.updateSucceeded)),
        );
        fixture.repository.writeGate!.complete();
        await Future.wait([first, second]);
        expect(navigation.intents, hasLength(1));
        expect(navigation.intents.single, isA<ProfileNameSavedIntent>());
        await controller.close();
      },
    );

    test('save failure preserves input and allows retry', () async {
      final fixture = _Fixture()
        ..repository.writeFailure = const ProfileException(
          ProfileFailureReason.write,
        );
      final navigation = _NavigationSink();
      final controller = fixture.controller(navigation);
      controller.nameChanged(_ProfileData.newName);
      await controller.save();
      expect(controller.state.phase, ProfileEditPhase.saveError);
      expect(controller.state.name, _ProfileData.newName);
      expect(navigation.intents, isEmpty);
      fixture.repository.writeFailure = null;
      await controller.save();
      expect(fixture.repository.stored!.name!.value, _ProfileData.newName);
      final starts = fixture.logger.records
          .where((record) => record.event == ProfileLogEvent.updateStarted)
          .toList();
      expect(starts, hasLength(2));
      expect(starts.last.message, contains('Попытка: 2'));
      expect(
        starts.last.message,
        contains(fixture.identifiers.issued.last.value),
      );
      expect(navigation.intents, hasLength(1));
      await controller.close();
    });

    test(
      'closing during save suppresses late completion and navigation',
      () async {
        final fixture = _Fixture()..repository.writeGate = Completer<void>();
        final navigation = _NavigationSink();
        final controller = fixture.controller(navigation);
        controller.nameChanged(_ProfileData.newName);
        final Future<void> saving = controller.save();
        await Future<void>.delayed(Duration.zero);
        await controller.close();
        await controller.close();
        await saving;
        fixture.repository.writeGate!.complete();
        await Future<void>.delayed(Duration.zero);
        expect(fixture.repository.writeCancellations, 1);
        expect(navigation.intents, isEmpty);
        expect(
          fixture.logger.events.where(
            (event) => event == ProfileLogEvent.updateCancelled,
          ),
          hasLength(1),
        );
        expect(
          fixture.logger.events,
          isNot(contains(ProfileLogEvent.updateSucceeded)),
        );
        expect(
          fixture.logger.events,
          isNot(contains(ProfileLogEvent.updateFailed)),
        );
      },
    );
  }
}

abstract final class _FlowTests {
  static void run() {
    testWidgets(
      'saving blocks Back and direct navigation until confirmation',
      _savingGuard,
    );
    testWidgets(
      'a stale editor callback cannot save after leaving the entry',
      _staleSave,
    );
    testWidgets(
      'native Back from a direct editor entry returns to profile',
      _directBack,
    );
    testWidgets(
      'closing app ownership suppresses late saved profile delivery',
      _closeApp,
    );
    testWidgets(
      'profile edit saves name and initials, keeps ID across restart',
      _roundTrip,
    );
    testWidgets(
      'Back discards unsaved input and keeps the saved profile',
      _cancel,
    );
    testWidgets(
      'saving a direct editor entry returns to the profile',
      _directEntry,
    );
  }

  static Future<void> _roundTrip(WidgetTester tester) async {
    final fixture = _Fixture();
    final originalId = fixture.repository.stored!.id;
    final ready = await _launch(tester, fixture);
    final navigation = ready.session.value;
    tester.widget<HomeScreen>(find.byType(HomeScreen)).onProfile!.call();
    await tester.pumpAndSettle();
    final profile = tester.widget<ProfileScreen>(find.byType(ProfileScreen));
    expect(profile.state.initials, 'ИМ');
    profile.onEdit!.call();
    await tester.pumpAndSettle();
    expect(navigation.currentRoute, isA<ProfileEditRoute>());
    final editor = tester.widget<ProfileEditScreen>(
      find.byType(ProfileEditScreen),
    );
    expect(editor.nameController.text, _ProfileData.oldName);
    await tester.enterText(find.byType(TextField), _ProfileData.newName);
    tester
        .widget<ProfileEditScreen>(find.byType(ProfileEditScreen))
        .onSave!
        .call();
    await tester.pumpAndSettle();
    expect(navigation.currentRoute, isA<ProfileRoute>());
    final updated = tester.widget<ProfileScreen>(find.byType(ProfileScreen));
    expect(updated.state.name, _ProfileData.newName);
    expect(updated.state.initials, 'МП');
    expect(tester.widget<AppAvatar>(find.byType(AppAvatar)).initials, 'МП');
    expect(find.byType(AppMetric), findsNothing);
    expect(fixture.repository.stored!.id, originalId);
    await tester.pumpWidget(const SizedBox.shrink());
    await ready.session.close();

    final reopened = await _launch(tester, fixture);
    tester.widget<HomeScreen>(find.byType(HomeScreen)).onProfile!.call();
    await tester.pumpAndSettle();
    final restored = tester.widget<ProfileScreen>(find.byType(ProfileScreen));
    expect(restored.state.name, _ProfileData.newName);
    expect(restored.state.initials, 'МП');
    expect(fixture.repository.stored!.id, originalId);
    await tester.pumpWidget(const SizedBox.shrink());
    await reopened.session.close();
  }

  static Future<void> _savingGuard(WidgetTester tester) async {
    final fixture = _Fixture()..repository.writeGate = Completer<void>();
    final ready = await _launch(tester, fixture);
    final navigation = ready.session.value;
    tester.widget<HomeScreen>(find.byType(HomeScreen)).onProfile!.call();
    await tester.pumpAndSettle();
    tester.widget<ProfileScreen>(find.byType(ProfileScreen)).onEdit!.call();
    await tester.pumpAndSettle();
    final forged = await navigation.coordinator.submit(
      const ProfileNameSavedIntent(),
    );
    expect(forged, isA<NavigationRejected>());
    await tester.enterText(find.byType(TextField), _ProfileData.newName);
    tester
        .widget<ProfileEditScreen>(find.byType(ProfileEditScreen))
        .onSave!
        .call();
    await tester.pumpAndSettle();
    expect(fixture.repository.writes, 1);
    expect(
      tester.widget<AppSectionHeader>(find.byType(AppSectionHeader)).onBack,
      isNull,
    );
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(navigation.currentRoute, isA<ProfileEditRoute>());
    navigation.router.go(const HomeRoute().location);
    await tester.pumpAndSettle();
    expect(navigation.currentRoute, isA<ProfileEditRoute>());
    fixture.repository.writeGate!.complete();
    await tester.pumpAndSettle();
    expect(navigation.currentRoute, isA<ProfileRoute>());
    expect(fixture.repository.writes, 1);
    await tester.pumpWidget(const SizedBox.shrink());
    await ready.session.close();
  }

  static Future<void> _staleSave(WidgetTester tester) async {
    final fixture = _Fixture();
    final ready = await _launch(tester, fixture);
    tester.widget<HomeScreen>(find.byType(HomeScreen)).onProfile!.call();
    await tester.pumpAndSettle();
    tester.widget<ProfileScreen>(find.byType(ProfileScreen)).onEdit!.call();
    await tester.pumpAndSettle();
    final oldSave = tester
        .widget<ProfileEditScreen>(find.byType(ProfileEditScreen))
        .onSave!;
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    oldSave();
    await tester.pumpAndSettle();
    expect(ready.session.value.currentRoute, isA<ProfileRoute>());
    expect(fixture.repository.writes, 0);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await ready.session.close();
  }

  static Future<void> _directBack(WidgetTester tester) async {
    final fixture = _Fixture();
    final ready = await _launch(tester, fixture);
    ready.session.value.router.go(const ProfileEditRoute().location);
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(ready.session.value.currentRoute, isA<ProfileRoute>());
    expect(fixture.repository.writes, 0);
    await tester.pumpWidget(const SizedBox.shrink());
    await ready.session.close();
  }

  static Future<void> _closeApp(WidgetTester tester) async {
    final fixture = _Fixture()..repository.writeGate = Completer<void>();
    final ready = await _launch(tester, fixture);
    tester.widget<HomeScreen>(find.byType(HomeScreen)).onProfile!.call();
    await tester.pumpAndSettle();
    tester.widget<ProfileScreen>(find.byType(ProfileScreen)).onEdit!.call();
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), _ProfileData.newName);
    tester
        .widget<ProfileEditScreen>(find.byType(ProfileEditScreen))
        .onSave!
        .call();
    await tester.pumpAndSettle();
    expect(fixture.repository.writes, 1);
    await tester.pumpWidget(const SizedBox.shrink());
    await ready.session.close();
    fixture.repository.writeGate!.complete();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  static Future<void> _cancel(WidgetTester tester) async {
    final fixture = _Fixture();
    final ready = await _launch(tester, fixture);
    tester.widget<HomeScreen>(find.byType(HomeScreen)).onProfile!.call();
    await tester.pumpAndSettle();
    tester.widget<ProfileScreen>(find.byType(ProfileScreen)).onEdit!.call();
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), _ProfileData.newName);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(ready.session.value.currentRoute, isA<ProfileRoute>());
    expect(fixture.repository.writes, 0);
    expect(
      tester.widget<ProfileScreen>(find.byType(ProfileScreen)).state.name,
      _ProfileData.oldName,
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await ready.session.close();
  }

  static Future<void> _directEntry(WidgetTester tester) async {
    final fixture = _Fixture();
    final ready = await _launch(tester, fixture);
    ready.session.value.router.go(const ProfileEditRoute().location);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), _ProfileData.newName);
    tester
        .widget<ProfileEditScreen>(find.byType(ProfileEditScreen))
        .onSave!
        .call();
    await tester.pumpAndSettle();
    expect(ready.session.value.currentRoute, isA<ProfileRoute>());
    expect(
      tester.widget<ProfileScreen>(find.byType(ProfileScreen)).state.initials,
      'МП',
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await ready.session.close();
  }

  static Future<BootstrapReady<AppNavigationSession>> _launch(
    WidgetTester tester,
    _Fixture fixture,
  ) async {
    final runner = BootstrapRunner(
      plan: ApplicationBootstrapPlan.create(
        profileRepository: fixture.repository,
        identifierGenerator: fixture.identifiers,
      ),
    );
    await runner.runBeforeApp();
    final ready =
        await runner.runAfterApp() as BootstrapReady<AppNavigationSession>;
    await runner.close();
    await tester.pumpWidget(
      TournamentApp(theme: AppTheme.dark(), navigation: ready.session.value),
    );
    await tester.pumpAndSettle();
    return ready;
  }
}

final class _Fixture {
  final _Repository repository = _Repository();
  final _ProfileLogger logger = _ProfileLogger();
  final _ExecutionIds identifiers = _ExecutionIds();

  UpdateProfileNameUseCase get useCase => UpdateProfileNameUseCase(
    repository: repository,
    logger: logger,
    identifiers: identifiers,
  );

  ProfileEditController controller(NavigationIntentSink navigation) =>
      ProfileEditController(
        initialName: repository.stored!.name!.value,
        updateProfile: useCase,
        navigation: navigation,
      );
}

final class _Repository implements ProfileRepository {
  LocalProfile? stored = _ProfileData.create();
  ProfileException? readFailure, writeFailure;
  Completer<void>? writeGate;
  Completer<LocalProfile?>? readGate;
  final StackTrace failureStack = StackTrace.current;
  int writes = 0, writeCancellations = 0;

  @override
  OperationRequest<LocalProfile?> read() => OperationRequest(
    result: Future.sync(() {
      final failure = readFailure;
      if (failure != null) {
        return Future<LocalProfile?>.error(failure, failureStack);
      }
      return readGate?.future ?? Future.value(stored);
    }),
    onCancel: _cancelRead,
  );

  @override
  OperationRequest<void> save(LocalProfile profile) {
    writes++;
    return OperationRequest(result: _write(profile), onCancel: _cancelWrite);
  }

  Future<void> _write(LocalProfile profile) async {
    final failure = writeFailure;
    if (failure != null) Error.throwWithStackTrace(failure, failureStack);
    final pending = writeGate;
    if (pending != null) await pending.future;
    stored = profile;
  }

  Future<void> _cancelRead() => Future<void>.value();

  Future<void> _cancelWrite() async {
    writeCancellations++;
  }
}

final class _ExecutionIds implements IdentifierGenerator {
  final List<UniqueIdentifier> issued = [];

  @override
  UniqueIdentifier generate() {
    final identifier = UniqueIdentifier('edit-execution-${issued.length + 1}');
    issued.add(identifier);
    return identifier;
  }
}

final class _ProfileLogger implements Logger<ProfileLogEvent> {
  final List<LogRecord> records = [];
  LogSubmissionResult result = const LogAccepted();

  Iterable<ProfileLogEvent> get events =>
      records.map((record) => record.event as ProfileLogEvent);

  @override
  LogSubmissionResult log(
    ProfileLogEvent event, {
    LogLevel level = LogLevel.info,
    String? message,
    Object? error,
    StackTrace? stackTrace,
  }) {
    records.add(
      LogRecord(
        event: event,
        timestamp: DateTime.utc(2026, 11, 12),
        level: level,
        message: message,
        error: error,
        stackTrace: stackTrace,
      ),
    );
    return result;
  }
}

final class _NavigationSink implements NavigationIntentSink {
  final List<NavigationIntent> intents = [];

  @override
  Future<NavigationFeedback> submit(NavigationIntent intent) async {
    intents.add(intent);
    return const NavigationAccepted();
  }
}

class _ProfilePreview extends StatelessWidget {
  const _ProfilePreview({required this.state});

  final ProfileScreenState state;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: AppTheme.dark(),
    localizationsDelegates: FoundationLocalizations.localizationsDelegates,
    supportedLocales: FoundationLocalizations.supportedLocales,
    home: ProfileScreen(
      state: state,
      onBack: null,
      onEdit: null,
      onCreate: null,
      onRecent: null,
      onSettings: null,
      onAbout: null,
      onContact: null,
    ),
  );
}

final class _LogSink implements LogSink {
  final List<LogRecord> records = [];

  @override
  void write(LogRecord record) => records.add(record);
}
