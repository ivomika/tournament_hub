import 'package:flutter/material.dart';

import '../ds_surface/ds_surface.dart';
import '../ds_text/ds_text.dart';
import '../fighter_avatar/fighter_avatar.dart';
import '../match_card/match_card.dart';
import '../participant_identity/participant_identity.dart';
import '../status_badge/status_badge.dart';
import 'bracket_theme.dart';

enum TournamentStructureFormat {
  doubleElimination,
  singleElimination,
  roundRobin,
}

class TournamentBracketPreview extends StatelessWidget {
  const TournamentBracketPreview({
    this.format = TournamentStructureFormat.doubleElimination,
    super.key,
  });

  final TournamentStructureFormat format;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<BracketTheme>()!;
    final sections = switch (format) {
      TournamentStructureFormat.doubleElimination => const [
        _StructureSection(
          title: 'Верхняя сетка',
          description: 'Без поражений',
          matches: [
            _StructureMatch('Матч 07 · Раунд 2', 0, 1, current: true),
            _StructureMatch('Финал верхней сетки', 2, 3),
          ],
        ),
        _StructureSection(
          title: 'Нижняя сетка',
          description: 'Одно поражение',
          matches: [
            _StructureMatch('Матч 09 · Раунд 2', 2, 0),
            _StructureMatch('Финал нижней сетки', 1, 3),
          ],
        ),
        _StructureSection(
          title: 'Grand Final',
          description: 'Победители верхней и нижней сеток',
          matches: [
            _StructureMatch('Grand Final', 0, 1),
            _StructureMatch('Bracket Reset · если потребуется', 0, 1),
          ],
        ),
      ],
      TournamentStructureFormat.singleElimination => const [
        _StructureSection(
          title: 'Раунд 1',
          description: 'Первое поражение завершает участие',
          matches: [
            _StructureMatch('Матч 01', 0, 1, current: true),
            _StructureMatch('Матч 02', 2, 3),
          ],
        ),
        _StructureSection(
          title: 'Финал',
          description: 'Победители полуфиналов',
          matches: [_StructureMatch('Финальный матч', 0, 2)],
        ),
      ],
      TournamentStructureFormat.roundRobin => const [
        _StructureSection(
          title: 'Общий этап',
          description: 'Каждая пара встречается один раз',
          matches: [
            _StructureMatch('Матч 01', 0, 1, current: true),
            _StructureMatch('Матч 02', 2, 3),
            _StructureMatch('Матч 03', 0, 2),
          ],
        ),
      ],
    };

    return DsSurface(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: theme.gap,
            runSpacing: theme.gap,
            children: [
              const DsText('Структура турнира', variant: DsTextVariant.title),
              StatusBadge(label: _formatLabel(format), kind: StatusKind.info),
            ],
          ),
          SizedBox(height: theme.gap),
          for (final (index, section) in sections.indexed) ...[
            if (index > 0) SizedBox(height: theme.gap),
            _StructureSectionView(section: section),
          ],
        ],
      ),
    );
  }
}

String _formatLabel(TournamentStructureFormat format) => switch (format) {
  TournamentStructureFormat.doubleElimination => 'DOUBLE ELIMINATION',
  TournamentStructureFormat.singleElimination => 'SINGLE ELIMINATION',
  TournamentStructureFormat.roundRobin => 'ROUND ROBIN',
};

class _StructureSection {
  const _StructureSection({
    required this.title,
    required this.description,
    required this.matches,
  });

  final String title;
  final String description;
  final List<_StructureMatch> matches;
}

class _StructureMatch {
  const _StructureMatch(
    this.title,
    this.firstIndex,
    this.secondIndex, {
    this.current = false,
  });

  final String title;
  final int firstIndex;
  final int secondIndex;
  final bool current;
}

class _StructureSectionView extends StatelessWidget {
  const _StructureSectionView({required this.section});

  final _StructureSection section;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<BracketTheme>()!;
    return Semantics(
      container: true,
      label: '${section.title}. ${section.description}',
      child: DsSurface(
        tone: DsSurfaceTone.elevated,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DsText(section.title, variant: DsTextVariant.title),
            DsText(section.description, variant: DsTextVariant.secondary),
            SizedBox(height: theme.gap),
            for (final (index, match) in section.matches.indexed) ...[
              if (index > 0) SizedBox(height: theme.gap),
              TournamentMatchCard(
                title: match.title,
                first: previewParticipants[match.firstIndex],
                second: previewParticipants[match.secondIndex],
                identityVariant: FighterArtworkVariant.compact,
                isCurrent: match.current,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
