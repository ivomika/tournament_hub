import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/app/host/tournament_hub_app.dart';
import 'package:tournament_hub_app/app/lifecycle/app_state.dart';
import 'package:tournament_hub_app/app/lifecycle/app_state_source.dart';
import 'package:tournament_hub_app/app/lifecycle/app_state_store.dart';
import 'package:tournament_hub_app/app/navigation/app_router.dart';
import 'package:tournament_hub_app/app/navigation/navigation_intent_store.dart';
import 'package:tournament_hub_app/app/navigation/ports/app_route_source.dart';
import 'package:tournament_hub_app/app/navigation/ports/navigation_intent_sink.dart';
import 'package:tournament_hub_app/app/runtime/app_runtime.dart';
import 'package:tournament_hub_app/application/bootstrap/models/app_session_projection.dart';
import 'package:tournament_hub_app/application/bootstrap/models/local_profile_projection.dart';

void main() {
  testWidgets('shell navigation меняет intent, а Back возвращает Main', (
    tester,
  ) async {
    final runtime = _OperationalTestRuntime();

    await tester.pumpWidget(TournamentHubApp(runtime: runtime));
    await tester.pump();
    expect(find.text('Твой турнирный центр'), findsOneWidget);

    await tester.tap(find.text('Профиль'));
    await tester.pump();
    expect(
      find.text('Локальная identity для турниров на этом устройстве.'),
      findsOneWidget,
    );

    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.text('Твой турнирный центр'), findsOneWidget);
  });
}

final class _OperationalTestRuntime implements AppRuntime {
  _OperationalTestRuntime()
    : _stateStore = AppStateStore(
        initialState: const AppOperational(
          AppSessionProjection(
            profile: LocalProfileProjection(id: 'profile-1', nickname: 'Jade'),
          ),
        ),
      ),
      _intentStore = NavigationIntentStore() {
    _router = AppRouter(stateSource: _stateStore, intentStore: _intentStore);
  }

  final AppStateStore _stateStore;
  final NavigationIntentStore _intentStore;
  late final AppRouter _router;

  @override
  AppRouteSource get appRouteSource => _router;

  @override
  AppStateSource get appStateSource => _stateStore;

  @override
  NavigationIntentSink get navigation => _router;

  @override
  Future<void> retry() async {}

  @override
  Future<void> start() async => _router.start();

  @override
  void dispose() {
    unawaited(_router.dispose());
    unawaited(_intentStore.dispose());
    unawaited(_stateStore.dispose());
  }
}
