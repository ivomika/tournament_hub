import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tournament_app/app/navigation/date_picker_interaction_options.dart';
import 'package:tournament_app/app/navigation/flutter_modal_interaction_adapter.dart';
import 'package:tournament_app/app/navigation/go_router_push_interaction_adapter.dart';
import 'package:tournament_app/app/navigation/interaction_presentation.dart';
import 'package:tournament_app/app/navigation/interaction_result_channel.dart';
import 'package:tournament_app/app/navigation/interaction_route_observer.dart';
import 'package:tournament_app/app/navigation/navigation_context.dart';
import 'package:tournament_app/app/routing/app_routes.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/navigation/interaction_outcome.dart';
import 'package:tournament_app/presentation/navigation/navigation_feedback.dart';

void main() {
  _PushInteractionAdapterTests.run();
  _ModalInteractionAdapterTests.run();
}

abstract final class _PushInteractionAdapterTests {
  static void run() {
    testWidgets(
      'push returns typed data after opening acknowledgement',
      _result,
    );
    testWidgets('native Back dismisses the pushed interaction', _back);
    testWidgets('cancelling a covered push preserves the newer push', _covered);
    testWidgets('cancellation during opening leaves no orphan page', _opening);
    testWidgets('closing adapter settles pending push interactions', _close);
    testWidgets(
      'push without a mounted navigator fails explicitly',
      _unavailable,
    );
    testWidgets('close settles a push after navigator unmount', _unmounted);
  }

  static Future<void> _result(WidgetTester tester) async {
    final host = await InteractionAdapterHarness.mount(tester);
    final presentation = host.pushAdapter.open<String>(
      const ProfileRoute(),
      entryId: const NavigationEntryId(100),
    );
    await tester.pumpAndSettle();
    expect(await presentation.operation.transition, isA<NavigationAccepted>());
    expect(find.text('push-target'), findsOneWidget);
    final completion = presentation.complete('selected');
    await tester.pumpAndSettle();
    expect(await completion, InteractionCompletion.accepted);
    final outcome =
        await presentation.operation.result as InteractionCompleted<String>;
    expect(outcome.value, 'selected');
    expect(find.text('adapter-home'), findsOneWidget);
    expect(tester.takeException(), isNull);
  }

  static Future<void> _back(WidgetTester tester) async {
    final host = await InteractionAdapterHarness.mount(tester);
    final presentation = host.pushAdapter.open<String>(
      const ProfileRoute(),
      entryId: const NavigationEntryId(100),
    );
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    final outcome =
        await presentation.operation.result as InteractionCancelled<String>;
    expect(outcome.reason, InteractionCancellationReason.dismissed);
    expect(find.text('adapter-home'), findsOneWidget);
  }

  static Future<void> _covered(WidgetTester tester) async {
    final host = await InteractionAdapterHarness.mount(tester);
    final first = host.pushAdapter.open<String>(
      const ProfileRoute(),
      entryId: const NavigationEntryId(100),
    );
    await tester.pumpAndSettle();
    final second = host.pushAdapter.open<String>(
      const ProfileRoute(),
      entryId: const NavigationEntryId(101),
    );
    await tester.pumpAndSettle();
    final cancelling = first.operation.cancel();
    await tester.pumpAndSettle();
    await cancelling;
    final cancelled =
        await first.operation.result as InteractionCancelled<String>;
    expect(cancelled.reason, InteractionCancellationReason.requested);
    expect(find.text('push-target'), findsOneWidget);
    final completion = second.complete('second');
    await tester.pumpAndSettle();
    expect(await completion, InteractionCompletion.accepted);
    final outcome =
        await second.operation.result as InteractionCompleted<String>;
    expect(outcome.value, 'second');
    expect(find.text('adapter-home'), findsOneWidget);
    expect(host.router.canPop(), isFalse);
    expect(tester.takeException(), isNull);
  }

  static Future<void> _opening(WidgetTester tester) async {
    final host = await InteractionAdapterHarness.mount(tester);
    final presentation = host.pushAdapter.open<String>(
      const ProfileRoute(),
      entryId: const NavigationEntryId(100),
    );
    final cancelling = presentation.operation.cancel();
    await tester.pumpAndSettle();
    await cancelling;
    expect(
      await presentation.operation.transition,
      anyOf(isA<NavigationAccepted>(), isA<NavigationCancelled>()),
    );
    final outcome =
        await presentation.operation.result as InteractionCancelled<String>;
    expect(outcome.reason, InteractionCancellationReason.requested);
    expect(find.text('adapter-home'), findsOneWidget);
    expect(find.text('push-target'), findsNothing);
    expect(host.router.canPop(), isFalse);
  }

  static Future<void> _close(WidgetTester tester) async {
    final host = await InteractionAdapterHarness.mount(tester);
    final presentation = host.pushAdapter.open<String>(
      const ProfileRoute(),
      entryId: const NavigationEntryId(100),
    );
    await tester.pumpAndSettle();
    final closing = host.pushAdapter.close();
    await tester.pumpAndSettle();
    await closing;
    final outcome =
        await presentation.operation.result as InteractionCancelled<String>;
    expect(outcome.reason, InteractionCancellationReason.ownerEnded);
    expect(find.text('adapter-home'), findsOneWidget);
  }

  static Future<void> _unavailable(WidgetTester tester) async {
    final observer = InteractionRouteObserver();
    final router = GoRouter(
      navigatorKey: GlobalKey<NavigatorState>(),
      observers: [observer],
      routes: [
        GoRoute(
          path: '/',
          builder: _unmountedHome,
          routes: [GoRoute(path: 'profile', builder: _unmountedHome)],
        ),
      ],
    );
    final adapter = GoRouterPushInteractionAdapter(
      router: router,
      observer: observer,
    );
    addTearDown(router.dispose);
    addTearDown(adapter.close);
    final presentation = adapter.open<String>(
      const ProfileRoute(),
      entryId: const NavigationEntryId(100),
    );
    expect(await presentation.operation.transition, isA<NavigationFailed>());
    final outcome =
        await presentation.operation.result as InteractionFailed<String>;
    expect(outcome.reason, InteractionFailureReason.presentationUnavailable);
    expect(tester.takeException(), isNull);
  }

  static Widget _unmountedHome(BuildContext context, GoRouterState state) =>
      const SizedBox.shrink();

  static Future<void> _unmounted(WidgetTester tester) async {
    final host = await InteractionAdapterHarness.mount(tester);
    final presentation = host.pushAdapter.open<String>(
      const ProfileRoute(),
      entryId: const NavigationEntryId(100),
    );
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox.shrink());
    final closing = host.pushAdapter.close();
    await tester.pumpAndSettle();
    await closing;
    final outcome =
        await presentation.operation.result as InteractionCancelled<String>;
    expect(outcome.reason, InteractionCancellationReason.ownerEnded);
    expect(tester.takeException(), isNull);
  }
}

enum _ModalMechanism { dialog, modalSheet, bottomSheet }

abstract final class _ModalInteractionAdapterTests {
  static void run() {
    for (final mechanism in _ModalMechanism.values) {
      testWidgets(
        '${mechanism.name} returns a typed result',
        (tester) => _result(tester, mechanism),
      );
      testWidgets(
        '${mechanism.name} native Back means dismissed',
        (tester) => _back(tester, mechanism),
      );
      testWidgets(
        '${mechanism.name} close settles owner cancellation',
        (tester) => _close(tester, mechanism),
      );
    }
    for (final mechanism in [
      _ModalMechanism.dialog,
      _ModalMechanism.modalSheet,
    ]) {
      testWidgets(
        '${mechanism.name} cancel preserves a newer overlay',
        (tester) => _covered(tester, mechanism),
      );
    }
    testWidgets('dialog barrier dismisses without a value', _barrier);
    testWidgets('modal bottom sheet drag dismisses without a value', _drag);
    testWidgets(
      'a replaced controller sheet cannot close its successor',
      _replacement,
    );
    testWidgets('date picker returns its selected date', _date);
    testWidgets('date picker Back dismisses without a date', _dateBack);
    testWidgets(
      'unmounted navigator and scaffold produce typed failures',
      _unavailable,
    );
    testWidgets(
      'a local navigator interaction cannot close a root overlay',
      _localNavigator,
    );
    testWidgets(
      'closing adapter cancels all its windows including date picker',
      _closeAll,
    );
    testWidgets(
      'close settles a sheet after scaffold unmount',
      _unmountedSheet,
    );
  }

  static InteractionPresentation<String> _open(
    InteractionAdapterHostState host,
    _ModalMechanism mechanism, {
    NavigationEntryId entryId = const NavigationEntryId(100),
    WidgetBuilder builder = InteractionAdapterHarness.firstPanel,
  }) => switch (mechanism) {
    _ModalMechanism.dialog => host.modalAdapter.dialog<String>(
      entryId: entryId,
      builder: builder,
    ),
    _ModalMechanism.modalSheet => host.modalAdapter.modalBottomSheet<String>(
      entryId: entryId,
      builder: builder,
    ),
    _ModalMechanism.bottomSheet => host.modalAdapter.bottomSheet<String>(
      entryId: entryId,
      builder: builder,
    ),
  };

  static Future<void> _result(
    WidgetTester tester,
    _ModalMechanism mechanism,
  ) async {
    final host = await InteractionAdapterHarness.mount(tester);
    final presentation = _open(host, mechanism);
    await tester.pumpAndSettle();
    expect(await presentation.operation.transition, isA<NavigationAccepted>());
    expect(find.text('first-panel'), findsOneWidget);
    final completing = presentation.complete('selected');
    await tester.pumpAndSettle();
    expect(await completing, InteractionCompletion.accepted);
    final outcome =
        await presentation.operation.result as InteractionCompleted<String>;
    expect(outcome.value, 'selected');
    expect(find.text('first-panel'), findsNothing);
    expect(find.text('adapter-home'), findsOneWidget);
    expect(tester.takeException(), isNull);
  }

  static Future<void> _back(
    WidgetTester tester,
    _ModalMechanism mechanism,
  ) async {
    final host = await InteractionAdapterHarness.mount(tester);
    final presentation = _open(host, mechanism);
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    final outcome =
        await presentation.operation.result as InteractionCancelled<String>;
    expect(outcome.reason, InteractionCancellationReason.dismissed);
    expect(find.text('first-panel'), findsNothing);
    expect(find.text('adapter-home'), findsOneWidget);
  }

  static Future<void> _close(
    WidgetTester tester,
    _ModalMechanism mechanism,
  ) async {
    final host = await InteractionAdapterHarness.mount(tester);
    final presentation = _open(host, mechanism);
    await tester.pumpAndSettle();
    final closing = host.modalAdapter.close();
    await tester.pumpAndSettle();
    await closing;
    final outcome =
        await presentation.operation.result as InteractionCancelled<String>;
    expect(outcome.reason, InteractionCancellationReason.ownerEnded);
    expect(find.text('first-panel'), findsNothing);
  }

  static Future<void> _covered(
    WidgetTester tester,
    _ModalMechanism mechanism,
  ) async {
    final host = await InteractionAdapterHarness.mount(tester);
    final first = _open(host, mechanism);
    await tester.pumpAndSettle();
    final second = _open(
      host,
      mechanism,
      entryId: const NavigationEntryId(101),
      builder: InteractionAdapterHarness.secondPanel,
    );
    await tester.pumpAndSettle();
    final cancelling = first.operation.cancel();
    await tester.pumpAndSettle();
    await cancelling;
    final cancelled =
        await first.operation.result as InteractionCancelled<String>;
    expect(cancelled.reason, InteractionCancellationReason.requested);
    expect(find.text('second-panel'), findsOneWidget);
    expect(find.text('first-panel'), findsNothing);
    final completing = second.complete('second');
    await tester.pumpAndSettle();
    expect(await completing, InteractionCompletion.accepted);
    final outcome =
        await second.operation.result as InteractionCompleted<String>;
    expect(outcome.value, 'second');
    expect(find.text('adapter-home'), findsOneWidget);
    expect(tester.takeException(), isNull);
  }

  static Future<void> _barrier(WidgetTester tester) async {
    final host = await InteractionAdapterHarness.mount(tester);
    final presentation = _open(host, _ModalMechanism.dialog);
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    final outcome =
        await presentation.operation.result as InteractionCancelled<String>;
    expect(outcome.reason, InteractionCancellationReason.dismissed);
    expect(find.text('first-panel'), findsNothing);
  }

  static Future<void> _drag(WidgetTester tester) async {
    final host = await InteractionAdapterHarness.mount(tester);
    final presentation = _open(host, _ModalMechanism.modalSheet);
    await tester.pumpAndSettle();
    final sheet = find.byType(BottomSheet);
    await tester.drag(sheet, Offset(0, tester.getSize(sheet).height));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing);
    final outcome =
        await presentation.operation.result as InteractionCancelled<String>;
    expect(outcome.reason, InteractionCancellationReason.dismissed);
    expect(find.text('first-panel'), findsNothing);
  }

  static Future<void> _replacement(WidgetTester tester) async {
    final host = await InteractionAdapterHarness.mount(tester);
    final first = _open(host, _ModalMechanism.bottomSheet);
    await tester.pumpAndSettle();
    final second = _open(
      host,
      _ModalMechanism.bottomSheet,
      entryId: const NavigationEntryId(101),
      builder: InteractionAdapterHarness.secondPanel,
    );
    await tester.pumpAndSettle();
    expect(await first.operation.result, isA<InteractionCancelled<String>>());
    final late = first.complete('late');
    await tester.pumpAndSettle();
    expect(await late, InteractionCompletion.alreadyCompleted);
    expect(find.text('second-panel'), findsOneWidget);
    final completing = second.complete('second');
    await tester.pumpAndSettle();
    expect(await completing, InteractionCompletion.accepted);
  }

  static DatePickerInteractionOptions _dates() => DatePickerInteractionOptions(
    initialDate: DateTime(2026, 11, 10),
    currentDate: DateTime(2026, 11, 10),
    firstDate: DateTime(2026),
    lastDate: DateTime(2026, 12, 31),
  );

  static Future<void> _date(WidgetTester tester) async {
    final host = await InteractionAdapterHarness.mount(tester);
    final presentation = host.modalAdapter.datePicker(
      entryId: const NavigationEntryId(100),
      options: _dates(),
    );
    await tester.pumpAndSettle();
    expect(await presentation.operation.transition, isA<NavigationAccepted>());
    final context = tester.element(find.byType(DatePickerDialog));
    final confirmLabel = MaterialLocalizations.of(context).okButtonLabel;
    await tester.tap(find.text(confirmLabel));
    await tester.pumpAndSettle();
    final outcome =
        await presentation.operation.result as InteractionCompleted<DateTime>;
    expect(outcome.value, DateTime(2026, 11, 10));
    expect(find.byType(DatePickerDialog), findsNothing);
  }

  static Future<void> _dateBack(WidgetTester tester) async {
    final host = await InteractionAdapterHarness.mount(tester);
    final presentation = host.modalAdapter.datePicker(
      entryId: const NavigationEntryId(100),
      options: _dates(),
    );
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    final outcome =
        await presentation.operation.result as InteractionCancelled<DateTime>;
    expect(outcome.reason, InteractionCancellationReason.dismissed);
  }

  static Future<void> _unavailable(WidgetTester tester) async {
    final adapter = FlutterModalInteractionAdapter(
      navigatorKey: GlobalKey<NavigatorState>(),
      scaffoldKey: GlobalKey<ScaffoldState>(),
    );
    addTearDown(adapter.close);
    final presentations = <InteractionPresentation<String>>[
      adapter.dialog<String>(
        entryId: const NavigationEntryId(100),
        builder: InteractionAdapterHarness.firstPanel,
      ),
      adapter.modalBottomSheet<String>(
        entryId: const NavigationEntryId(101),
        builder: InteractionAdapterHarness.firstPanel,
      ),
      adapter.bottomSheet<String>(
        entryId: const NavigationEntryId(102),
        builder: InteractionAdapterHarness.firstPanel,
      ),
    ];
    for (final presentation in presentations) {
      expect(await presentation.operation.transition, isA<NavigationFailed>());
      final outcome =
          await presentation.operation.result as InteractionFailed<String>;
      expect(outcome.reason, InteractionFailureReason.presentationUnavailable);
    }
    final date = adapter.datePicker(
      entryId: const NavigationEntryId(103),
      options: _dates(),
    );
    expect(await date.operation.transition, isA<NavigationFailed>());
    expect(await date.operation.result, isA<InteractionFailed<DateTime>>());
    expect(tester.takeException(), isNull);
  }

  static Future<void> _localNavigator(WidgetTester tester) async {
    final host = await InteractionAdapterHarness.mount(tester);
    final local = FlutterModalInteractionAdapter(
      navigatorKey: host.localNavigatorKey,
      scaffoldKey: host.scaffoldKey,
    );
    addTearDown(local.close);
    final first = local.dialog<String>(
      entryId: const NavigationEntryId(100),
      builder: InteractionAdapterHarness.firstPanel,
    );
    await tester.pumpAndSettle();
    final root = host.modalAdapter.dialog<String>(
      entryId: const NavigationEntryId(101),
      builder: InteractionAdapterHarness.secondPanel,
    );
    await tester.pumpAndSettle();
    final cancelling = first.operation.cancel();
    await tester.pumpAndSettle();
    await cancelling;
    final cancelled =
        await first.operation.result as InteractionCancelled<String>;
    expect(cancelled.reason, InteractionCancellationReason.requested);
    expect(find.text('second-panel'), findsOneWidget);
    final completing = root.complete('root');
    await tester.pumpAndSettle();
    expect(await completing, InteractionCompletion.accepted);
    final outcome = await root.operation.result as InteractionCompleted<String>;
    expect(outcome.value, 'root');
    expect(find.text('adapter-home'), findsOneWidget);
  }

  static Future<void> _closeAll(WidgetTester tester) async {
    final host = await InteractionAdapterHarness.mount(tester);
    final dialog = _open(host, _ModalMechanism.dialog);
    await tester.pumpAndSettle();
    final sheet = _open(
      host,
      _ModalMechanism.modalSheet,
      entryId: const NavigationEntryId(101),
      builder: InteractionAdapterHarness.secondPanel,
    );
    await tester.pumpAndSettle();
    final date = host.modalAdapter.datePicker(
      entryId: const NavigationEntryId(102),
      options: _dates(),
    );
    await tester.pumpAndSettle();
    final closing = host.modalAdapter.close();
    await tester.pumpAndSettle();
    await closing;
    final dialogOutcome =
        await dialog.operation.result as InteractionCancelled<String>;
    final sheetOutcome =
        await sheet.operation.result as InteractionCancelled<String>;
    final dateOutcome =
        await date.operation.result as InteractionCancelled<DateTime>;
    expect(dialogOutcome.reason, InteractionCancellationReason.ownerEnded);
    expect(sheetOutcome.reason, InteractionCancellationReason.ownerEnded);
    expect(dateOutcome.reason, InteractionCancellationReason.ownerEnded);
    expect(find.text('first-panel'), findsNothing);
    expect(find.text('second-panel'), findsNothing);
    expect(find.byType(DatePickerDialog), findsNothing);
    expect(find.text('adapter-home'), findsOneWidget);
    expect(tester.takeException(), isNull);
  }

  static Future<void> _unmountedSheet(WidgetTester tester) async {
    final host = await InteractionAdapterHarness.mount(tester);
    final presentation = _open(host, _ModalMechanism.bottomSheet);
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox.shrink());
    final closing = host.modalAdapter.close();
    await tester.pumpAndSettle();
    await closing;
    final outcome =
        await presentation.operation.result as InteractionCancelled<String>;
    expect(outcome.reason, InteractionCancellationReason.ownerEnded);
    expect(tester.takeException(), isNull);
  }
}

abstract final class InteractionAdapterHarness {
  static Future<InteractionAdapterHostState> mount(WidgetTester tester) async {
    final key = GlobalKey<InteractionAdapterHostState>();
    await tester.pumpWidget(_InteractionAdapterHost(key: key));
    await tester.pumpAndSettle();
    final host = key.currentState!;
    addTearDown(() => host.shutdown(tester));
    return host;
  }

  static Widget firstPanel(BuildContext context) => const Dialog(
    child: SizedBox(height: 120, child: Center(child: Text('first-panel'))),
  );

  static Widget secondPanel(BuildContext context) => const Dialog(
    child: SizedBox(height: 120, child: Center(child: Text('second-panel'))),
  );
}

class _InteractionAdapterHost extends StatefulWidget {
  const _InteractionAdapterHost({super.key});

  @override
  State<_InteractionAdapterHost> createState() => InteractionAdapterHostState();
}

class InteractionAdapterHostState extends State<_InteractionAdapterHost> {
  final navigatorKey = GlobalKey<NavigatorState>();
  final localNavigatorKey = GlobalKey<NavigatorState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final routeObserver = InteractionRouteObserver();
  late final GoRouter router;
  late final GoRouterPushInteractionAdapter pushAdapter;
  late final FlutterModalInteractionAdapter modalAdapter;

  @override
  void initState() {
    super.initState();
    router = GoRouter(
      navigatorKey: navigatorKey,
      observers: [routeObserver],
      routes: [
        GoRoute(
          path: '/',
          builder: _home,
          routes: [GoRoute(path: 'profile', builder: _target)],
        ),
      ],
    );
    pushAdapter = GoRouterPushInteractionAdapter(
      router: router,
      observer: routeObserver,
    );
    modalAdapter = FlutterModalInteractionAdapter(
      navigatorKey: navigatorKey,
      scaffoldKey: scaffoldKey,
    );
  }

  Widget _home(BuildContext context, GoRouterState state) => Scaffold(
    key: scaffoldKey,
    body: Navigator(key: localNavigatorKey, onGenerateRoute: _localPage),
  );

  Route<void> _localPage(RouteSettings settings) =>
      MaterialPageRoute<void>(settings: settings, builder: _localHome);

  Widget _localHome(BuildContext context) =>
      const Center(child: Text('adapter-home'));

  Widget _target(BuildContext context, GoRouterState state) =>
      const Scaffold(body: Center(child: Text('push-target')));

  Future<void> shutdown(WidgetTester tester) async {
    final closing = Future.wait<void>([
      modalAdapter.close(),
      pushAdapter.close(),
    ]);
    await tester.pumpAndSettle();
    await closing;
    await tester.pumpWidget(const SizedBox.shrink());
  }

  @override
  void dispose() {
    router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      MaterialApp.router(theme: AppTheme.dark(), routerConfig: router);
}
