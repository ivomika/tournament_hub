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
      Size(599, 959),
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

    for (final kind in const [
      ScreenPreviewKind.registration,
      ScreenPreviewKind.main,
      ScreenPreviewKind.profile,
      ScreenPreviewKind.history,
      ScreenPreviewKind.historyDetail,
      ScreenPreviewKind.settings,
      ScreenPreviewKind.hostDraft,
      ScreenPreviewKind.hostOpen,
      ScreenPreviewKind.hostDistribution,
      ScreenPreviewKind.hostRunning,
      ScreenPreviewKind.hostResultEntry,
      ScreenPreviewKind.hostFinished,
      ScreenPreviewKind.hostCancelled,
      ScreenPreviewKind.join,
      ScreenPreviewKind.participantLobby,
      ScreenPreviewKind.participantDistribution,
      ScreenPreviewKind.participantRunning,
      ScreenPreviewKind.participantFinished,
      ScreenPreviewKind.recoverableError,
    ]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: TournamentTheme.dark,
          home: TournamentScreenPreview(kind: kind),
        ),
      );
      await tester.pumpAndSettle();
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
    expect(find.textContaining('обновлено 2 минуты назад'), findsOneWidget);
    expect(find.text('Переподключиться'), findsOneWidget);
  });
}
