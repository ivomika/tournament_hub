import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';
import 'package:tournament_hub_app/presentation/screens/screen_registry.dart';
import 'package:tournament_hub_app/presentation/widgetbook/widgetbook_catalog.dart';
import 'package:widgetbook/widgetbook.dart';

void main() {
  test('catalog содержит каждый Flutter screen preview', () {
    final useCaseNames = <String>{};

    void collect(Iterable<WidgetbookNode> nodes) {
      for (final node in nodes) {
        if (node is WidgetbookUseCase) useCaseNames.add(node.name);
        collect(node.children ?? const []);
      }
    }

    collect(buildTournamentCatalog());

    expect(
      useCaseNames,
      containsAll(ScreenPreviewKind.values.map((screen) => screen.catalogName)),
    );
  });

  test('catalog содержит обязательные stress-сценарии', () {
    final useCaseNames = <String>{};

    void collect(Iterable<WidgetbookNode> nodes) {
      for (final node in nodes) {
        if (node is WidgetbookUseCase) useCaseNames.add(node.name);
        collect(node.children ?? const []);
      }
    }

    collect(buildTournamentCatalog());

    expect(
      useCaseNames,
      containsAll(const ['Long Russian copy', 'Error loading empty']),
    );
  });

  test('catalog содержит полную матрицу ConnectionQrCard', () {
    final useCaseNames = <String>{};

    void collect(Iterable<WidgetbookNode> nodes) {
      for (final node in nodes) {
        if (node is WidgetbookUseCase) useCaseNames.add(node.name);
        collect(node.children ?? const []);
      }
    }

    collect(buildTournamentCatalog());

    expect(
      useCaseNames,
      containsAll(const [
        'Starting',
        'Ready',
        'Reconnecting',
        'Unavailable',
        'Expired',
        'Error',
        'Stale',
        'Copied',
        'Long address / Narrow',
      ]),
    );
  });

  test('catalog содержит переиспользуемые QR primitives', () {
    final useCaseNames = <String>{};

    void collect(Iterable<WidgetbookNode> nodes) {
      for (final node in nodes) {
        if (node is WidgetbookUseCase) useCaseNames.add(node.name);
        collect(node.children ?? const []);
      }
    }

    collect(buildTournamentCatalog());

    expect(
      useCaseNames,
      containsAll(const [
        'QR / Compact',
        'QR / Standard IPv6',
        'QR / Large Participant',
        'QR / Unavailable',
      ]),
    );
  });

  testWidgets('Widgetbook запускается отдельным entry tree', (tester) async {
    await tester.pumpWidget(const TournamentWidgetbook());
    await tester.pump();

    expect(find.byType(Widgetbook), findsOneWidget);
  });

  testWidgets('все screen previews строятся на mobile и desktop', (
    tester,
  ) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.devicePixelRatio = 1;

    for (final size in const [
      Size(320, 720),
      Size(375, 812),
      Size(599, 959),
      Size(768, 1024),
      Size(1024, 768),
      Size(1280, 960),
    ]) {
      tester.view.physicalSize = size;
      for (final kind in ScreenPreviewKind.values) {
        await tester.pumpWidget(
          MaterialApp(
            theme: TournamentTheme.dark,
            home: TournamentScreenPreview(kind: kind),
          ),
        );
        await tester.pump();
        expect(tester.takeException(), isNull, reason: '${kind.name} at $size');
      }
    }
  });

  testWidgets('page actions закреплены над mobile navigation', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 812);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: const TournamentScreenPreview(
          kind: ScreenPreviewKind.hostRunning,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final action = find.text('Определить победителя');
    final navigation = find.byType(NavigationBar);
    expect(action, findsOneWidget);
    expect(navigation, findsOneWidget);
    expect(
      tester.getBottomLeft(action).dy,
      lessThan(tester.getTopLeft(navigation).dy),
    );
  });

  testWidgets('responsive actions сохраняют одну primary action', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: Scaffold(
          body: ResponsiveActions(
            primary: DsAction(label: 'Продолжить', onPressed: () {}),
            secondary: [
              DsAction(
                label: 'Назад',
                kind: DsActionKind.secondary,
                onPressed: () {},
              ),
            ],
            destructive: DsAction(
              label: 'Удалить',
              kind: DsActionKind.danger,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(OutlinedButton), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('field отображает focus, helper и локальную ошибку', (
    tester,
  ) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: Scaffold(
          body: DsTextField(
            label: 'Код лобби',
            helperText: 'Например, FIGHT-24',
            errorText: 'Проверь код и попробуй снова',
            focusNode: focusNode,
            autofocus: true,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(focusNode.hasFocus, isTrue);
    expect(find.text('Проверь код и попробуй снова'), findsOneWidget);
    expect(find.text('Например, FIGHT-24'), findsNothing);
  });

  testWidgets('field передаёт ввод наружу без business validation', (
    tester,
  ) async {
    String? changed;
    String? submitted;
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: Scaffold(
          body: DsTextField(
            label: 'Никнейм',
            onChanged: (value) => changed = value,
            onSubmitted: (value) => submitted = value,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '  player  ');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(changed, '  player  ');
    expect(submitted, '  player  ');
  });

  testWidgets('loading action недоступна и объявляет состояние', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var presses = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: Scaffold(
          body: DsAction(
            label: 'Подключиться',
            status: DsActionStatus.loading,
            onPressed: () => presses++,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    expect(presses, 0);
    expect(find.bySemanticsLabel('Подключиться. Выполняется'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('identity показывает персонажа и участника', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: Scaffold(
          body: ParticipantIdentity(participant: previewParticipants.first),
        ),
      ),
    );

    expect(find.text('Scorpion'), findsOneWidget);
    expect(find.text('Иван'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('fighter artwork variants задают визуальную иерархию', (
    tester,
  ) async {
    const compactKey = Key('compact-artwork');
    const heroKey = Key('hero-artwork');
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: const Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                FighterAvatar(
                  key: compactKey,
                  fighterId: 'scorpion',
                  fighterName: 'Scorpion',
                  variant: FighterArtworkVariant.compact,
                ),
                FighterAvatar(
                  key: heroKey,
                  fighterId: 'scorpion',
                  fighterName: 'Scorpion',
                  variant: FighterArtworkVariant.hero,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsNWidgets(2));
    expect(
      tester.getSize(find.byKey(heroKey)).width,
      greaterThan(tester.getSize(find.byKey(compactKey)).width),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('missing fighter artwork показывает fallback', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: const Scaffold(
          body: FighterAvatar(
            fighterId: 'missing-fighter',
            fighterName: 'Unknown Fighter',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.sports_martial_arts), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('current match artwork крупнее bracket representation', (
    tester,
  ) async {
    const currentKey = Key('current-match');
    const bracketKey = Key('bracket-match');
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                TournamentMatchCard(
                  key: currentKey,
                  title: 'Current',
                  first: previewParticipants.first,
                  second: previewParticipants[1],
                  isCurrent: true,
                ),
                TournamentMatchCard(
                  key: bracketKey,
                  title: 'Bracket',
                  first: previewParticipants.first,
                  second: previewParticipants[1],
                  identityVariant: FighterArtworkVariant.compact,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final currentArtwork = find
        .descendant(
          of: find.byKey(currentKey),
          matching: find.byType(FighterAvatar),
        )
        .first;
    final bracketArtwork = find
        .descendant(
          of: find.byKey(bracketKey),
          matching: find.byType(FighterAvatar),
        )
        .first;
    expect(
      tester.getSize(currentArtwork).width,
      greaterThan(tester.getSize(bracketArtwork).width),
    );
  });

  testWidgets('token showcase не переполняет compact viewport', (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 480);

    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: const Scaffold(body: TokenShowcase()),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  testWidgets('prominent matchup меняет композицию между mobile и desktop', (
    tester,
  ) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.devicePixelRatio = 1;

    Future<List<Offset>> artworkOffsets(Size size) async {
      tester.view.physicalSize = size;
      await tester.pumpWidget(
        MaterialApp(
          theme: TournamentTheme.dark,
          home: Scaffold(
            body: SingleChildScrollView(
              child: TournamentMatchCard(
                title: 'Текущая схватка',
                first: previewParticipants.first,
                second: previewParticipants[1],
                isCurrent: true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return find
          .byType(FighterAvatar)
          .evaluate()
          .map((element) => tester.getTopLeft(find.byWidget(element.widget)))
          .toList();
    }

    final mobile = await artworkOffsets(const Size(390, 844));
    final desktop = await artworkOffsets(const Size(1280, 960));

    expect(mobile[1].dy, greaterThan(mobile[0].dy));
    expect(desktop[1].dx, greaterThan(desktop[0].dx));
    expect(tester.takeException(), isNull);
  });

  testWidgets('ключевые экраны выдерживают 200% text scale', (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    tester.platformDispatcher.textScaleFactorTestValue = 2;

    for (final kind in ScreenPreviewKind.values) {
      await tester.pumpWidget(
        MaterialApp(
          theme: TournamentTheme.dark,
          home: TournamentScreenPreview(kind: kind),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull, reason: kind.name);
    }
  });

  testWidgets('profile summary выдерживает длинный nickname при 200%', (
    tester,
  ) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    tester.platformDispatcher.textScaleFactorTestValue = 2;

    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: const Scaffold(
          body: SingleChildScrollView(
            child: ProfileSummary(
              nickname: 'Очень длинный никнейм локального игрока',
              tournaments: 128,
              victories: 42,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(
      find.text('Очень длинный никнейм локального игрока'),
      findsOneWidget,
    );
  });

  testWidgets('profile не раскрывает редактирование nickname по умолчанию', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: const TournamentScreenPreview(kind: ScreenPreviewKind.profile),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Новый никнейм'), findsNothing);
    expect(find.text('Сохранить изменения'), findsNothing);
    expect(find.text('Редактировать профиль'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('shell выбирает актуальный раздел навигации', (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.devicePixelRatio = 1;

    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: const TournamentScreenPreview(kind: ScreenPreviewKind.profile),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      2,
    );

    tester.view.physicalSize = const Size(1280, 960);
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: const TournamentScreenPreview(kind: ScreenPreviewKind.history),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<NavigationRail>(find.byType(NavigationRail)).selectedIndex,
      1,
    );
  });

  testWidgets('result picker называет fighter и не использует счёт', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: Scaffold(
          body: SingleChildScrollView(
            child: OutcomePicker(
              first: previewParticipants.first,
              second: previewParticipants[1],
              onFirstSelected: () {},
              onSecondSelected: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Победил Scorpion'), findsOneWidget);
    expect(find.text('Победил Sub-Zero'), findsOneWidget);
    expect(find.textContaining('2:'), findsNothing);
  });

  testWidgets('DE structure содержит обе сетки, Grand Final и Reset', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: const Scaffold(
          body: SingleChildScrollView(child: TournamentBracketPreview()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Верхняя сетка'), findsOneWidget);
    expect(find.text('Нижняя сетка'), findsOneWidget);
    expect(find.text('Grand Final'), findsNWidgets(2));
    expect(find.textContaining('Bracket Reset'), findsOneWidget);
    expect(find.textContaining('Результат:'), findsNothing);
  });

  testWidgets('DE использует список на mobile и связный граф на desktop', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    tester.view.physicalSize = const Size(375, 812);
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: const Scaffold(
          body: SingleChildScrollView(child: TournamentBracketPreview()),
        ),
      ),
    );
    expect(find.byType(MatchList), findsOneWidget);
    expect(find.byType(DoubleEliminationBracket), findsNothing);

    tester.view.physicalSize = const Size(1280, 960);
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: const Scaffold(
          body: SingleChildScrollView(child: TournamentBracketPreview()),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(DoubleEliminationBracket), findsOneWidget);
    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp('Победитель Матча 01.*верхней сетки')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('match list различает все match states без вычисления', (
    tester,
  ) async {
    final states = BracketMatchState.values;
    final matches = [
      for (final (index, state) in states.indexed)
        BracketMatchViewData(
          id: 'state-$index',
          title: 'Очень длинное название матча номер $index',
          lane: BracketLane.stage,
          round: index,
          order: index,
          first: previewParticipants.first,
          second: previewParticipants[1],
          state: state,
          conditionLabel: state == BracketMatchState.reset
              ? 'Условие Reset приходит готовым из authoritative projection'
              : null,
        ),
    ];
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 1600);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: Scaffold(
          body: SingleChildScrollView(
            child: MatchList(
              data: BracketViewData(
                format: TournamentStructureFormat.doubleElimination,
                matches: matches,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    for (final state in states) {
      expect(find.text(bracketMatchStateLabel(state)), findsWidgets);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('standings отображает готовые places без demo-очков', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    for (final size in const [Size(320, 1000), Size(1024, 768)]) {
      tester.view.physicalSize = size;
      await tester.pumpWidget(
        MaterialApp(
          theme: TournamentTheme.dark,
          home: const Scaffold(
            body: SingleChildScrollView(child: TournamentStandings()),
          ),
        ),
      );
      await tester.pump();
      expect(find.textContaining('очк.'), findsNothing);
      expect(find.text('3–4'), findsOneWidget);
      expect(find.text('—'), findsWidgets);
      expect(find.text('Переигровка'), findsOneWidget);
      expect(find.text('Scorpion'), findsOneWidget);
      expect(find.text('Иван'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: '$size');
    }
    expect(find.text('УЧАСТНИК'), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp('Место 3–4.*Kitana.*Гость 1.*Переигровка')),
      findsOneWidget,
    );
  });

  testWidgets('standings различает loading и empty', (tester) async {
    for (final state in const [
      TournamentStandingsState.loading,
      TournamentStandingsState.empty,
    ]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: TournamentTheme.dark,
          home: Scaffold(body: TournamentStandings(state: state)),
        ),
      );
      await tester.pump();
      if (state == TournamentStandingsState.loading) {
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      } else {
        expect(find.text('Итоги ещё не определены'), findsOneWidget);
      }
      expect(tester.takeException(), isNull, reason: state.name);
    }
  });

  testWidgets('SE и RR structure имеют собственную семантику', (tester) async {
    for (final format in const [
      TournamentStructureFormat.singleElimination,
      TournamentStructureFormat.roundRobin,
    ]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: TournamentTheme.dark,
          home: Scaffold(
            body: SingleChildScrollView(
              child: TournamentBracketPreview(format: format),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: format.name);
    }

    expect(find.text('Общий этап'), findsOneWidget);
    expect(find.text('Каждая пара встречается один раз'), findsOneWidget);
  });

  testWidgets(
    'history snapshot показывает fighter identity и read-only state',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: TournamentTheme.dark,
          home: const TournamentScreenPreview(kind: ScreenPreviewKind.history),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('ТОЛЬКО ЧТЕНИЕ'), findsOneWidget);
      expect(find.text('Scorpion'), findsOneWidget);
      expect(find.text('Иван'), findsOneWidget);
      expect(find.text('Sub-Zero'), findsOneWidget);
      expect(find.text('Мира'), findsOneWidget);
    },
  );

  testWidgets('participant projection не содержит Host mutation controls', (
    tester,
  ) async {
    for (final kind in const [
      ScreenPreviewKind.participantLobby,
      ScreenPreviewKind.participantDistribution,
      ScreenPreviewKind.participantRunning,
      ScreenPreviewKind.participantFinished,
    ]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: TournamentTheme.dark,
          home: TournamentScreenPreview(kind: kind),
        ),
      );
      await tester.pumpAndSettle();

      for (final forbidden in const [
        'Добавить гостя',
        'Перераздать всех',
        'Начать турнир',
        'Записать результат',
        'Отменить турнир',
      ]) {
        expect(find.text(forbidden), findsNothing, reason: kind.name);
      }
    }
  });

  testWidgets('stale projection явно показывает возраст данных и recovery', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: const TournamentScreenPreview(
          kind: ScreenPreviewKind.participantRunning,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ДАННЫЕ УСТАРЕЛИ'), findsOneWidget);
    expect(find.text('Обновлено: 2 минуты назад'), findsOneWidget);
    expect(find.text('Переподключиться'), findsOneWidget);
  });

  testWidgets('connection contract различает все состояния текстом', (
    tester,
  ) async {
    const labels = {
      TournamentConnectionState.connected: 'Подключено',
      TournamentConnectionState.reconnecting: 'Восстанавливаем связь',
      TournamentConnectionState.stale: 'Данные устарели',
      TournamentConnectionState.disconnected: 'Нет подключения',
      TournamentConnectionState.incompatible: 'Версия приложения несовместима',
      TournamentConnectionState.retrying: 'Повторяем подключение',
    };

    for (final entry in labels.entries) {
      await tester.pumpWidget(
        MaterialApp(
          theme: TournamentTheme.dark,
          home: Scaffold(
            body: ConnectionBanner(
              state: entry.key,
              detail: 'Без технических данных',
              synchronizedAtLabel: '2 минуты назад',
              onAction: () {},
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text(entry.value), findsOneWidget, reason: entry.key.name);
      expect(find.textContaining('stack'), findsNothing);
      expect(tester.takeException(), isNull, reason: entry.key.name);
    }
  });

  testWidgets('status и guest identity имеют русские semantics labels', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: const Scaffold(
          body: Column(
            children: [
              StatusBadge(label: 'Данные устарели', kind: StatusKind.warning),
              ParticipantIdentity(participant: previewGuest),
            ],
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Статус: Данные устарели'), findsOneWidget);
    expect(find.bySemanticsLabel('Kitana, Гость 1, Гость'), findsOneWidget);
    expect(find.text('Guest'), findsNothing);
  });

  testWidgets('confirmation возвращает focus инициатору', (tester) async {
    final triggerFocus = FocusNode();
    addTearDown(triggerFocus.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: Scaffold(
          body: Builder(
            builder: (context) => DsAction(
              label: 'Открыть подтверждение',
              focusNode: triggerFocus,
              autofocus: true,
              onPressed: () {
                showTournamentConfirmationDialog<void>(
                  context: context,
                  builder: (dialogContext) => Dialog(
                    child: DsAction(
                      label: 'Вернуться',
                      autofocus: true,
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(triggerFocus.hasFocus, isTrue);

    await tester.tap(find.text('Открыть подтверждение'));
    await tester.pumpAndSettle();
    expect(find.text('Вернуться'), findsOneWidget);
    expect(triggerFocus.hasFocus, isFalse);

    await tester.tap(find.text('Вернуться'));
    await tester.pumpAndSettle();
    expect(triggerFocus.hasFocus, isTrue);
  });

  testWidgets('critical state читается при reduced motion и 200% scale', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 720);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: const TournamentScreenPreview(
              kind: ScreenPreviewKind.participantRunning,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Данные устарели'), findsOneWidget);
    expect(find.text('Переподключиться'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('основные text/background пары проходят contrast gate', () {
    final theme = TournamentTheme.dark;
    double contrast(Color first, Color second) {
      final lighter = first.computeLuminance() > second.computeLuminance()
          ? first
          : second;
      final darker = identical(lighter, first) ? second : first;
      return (lighter.computeLuminance() + 0.05) /
          (darker.computeLuminance() + 0.05);
    }

    expect(
      contrast(
        theme.textTheme.bodyLarge!.color!,
        theme.scaffoldBackgroundColor,
      ),
      greaterThanOrEqualTo(4.5),
    );
    expect(
      contrast(theme.textTheme.bodyMedium!.color!, theme.colorScheme.surface),
      greaterThanOrEqualTo(4.5),
    );
  });
}
