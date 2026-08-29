import 'package:flutter/material.dart';

import '../bracket/bracket_view_data.dart';
import '../ds_surface/ds_surface.dart';
import '../ds_text/ds_text.dart';
import '../fighter_avatar/fighter_avatar.dart';
import '../match_list/match_list.dart';
import '../participant_identity/participant_identity.dart';
import '../status_badge/status_badge.dart';
import 'double_elimination_bracket_theme.dart';

class DoubleEliminationBracket extends StatelessWidget {
  const DoubleEliminationBracket({required this.data, super.key});

  final BracketViewData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DoubleEliminationBracketTheme>()!;
    final positions = <String, Rect>{
      for (final match in data.matches) match.id: _matchRect(match, theme),
    };
    return Semantics(
      container: true,
      label:
          'Каноническая сетка Double Elimination. ${data.links.map((link) => link.label).join('. ')}',
      child: DsSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DsText(
              'Каноническая сетка Double Elimination',
              variant: DsTextVariant.title,
            ),
            const DsText(
              'Перетаскивайте поле или масштабируйте. Полный список боёв доступен в компактном представлении.',
              variant: DsTextVariant.secondary,
            ),
            SizedBox(height: theme.padding),
            SizedBox(
              height: theme.viewportHeight,
              child: InteractiveViewer(
                constrained: false,
                minScale: theme.minScale,
                maxScale: theme.maxScale,
                boundaryMargin: EdgeInsets.all(theme.padding),
                child: SizedBox(
                  width: theme.canvasWidth,
                  height: theme.canvasHeight,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _BracketConnectorPainter(
                            links: data.links,
                            matches: data.matches,
                            positions: positions,
                            theme: theme,
                          ),
                        ),
                      ),
                      Positioned(
                        left: theme.padding,
                        top: theme.padding,
                        child: const DsText(
                          'Верхняя сетка',
                          variant: DsTextVariant.label,
                        ),
                      ),
                      Positioned(
                        left: theme.padding,
                        top: theme.losersOffset - theme.padding,
                        child: const DsText(
                          'Нижняя сетка',
                          variant: DsTextVariant.label,
                        ),
                      ),
                      for (final match in data.matches)
                        Positioned.fromRect(
                          rect: positions[match.id]!,
                          child: _BracketNode(match: match),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Rect _matchRect(
  BracketMatchViewData match,
  DoubleEliminationBracketTheme theme,
) {
  final laneOffset = switch (match.lane) {
    BracketLane.winners => theme.padding * 2,
    BracketLane.losers => theme.losersOffset,
    BracketLane.finals => theme.padding * 2,
    BracketLane.stage => theme.padding * 2,
  };
  final finalsRoundOffset = match.lane == BracketLane.finals ? 1 : 0;
  final x =
      theme.padding +
      (match.round + finalsRoundOffset) * (theme.nodeWidth + theme.columnGap);
  final y = laneOffset + match.order * (theme.nodeHeight + theme.rowGap);
  return Rect.fromLTWH(x, y, theme.nodeWidth, theme.nodeHeight);
}

class _BracketNode extends StatelessWidget {
  const _BracketNode({required this.match});

  final BracketMatchViewData match;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DoubleEliminationBracketTheme>()!;
    return Semantics(
      container: true,
      label: [
        match.title,
        bracketMatchStateLabel(match.state),
        if (match.first != null)
          '${match.first!.fighterName}, ${match.first!.nickname}',
        if (match.second != null)
          '${match.second!.fighterName}, ${match.second!.nickname}',
        ?match.conditionLabel,
      ].join('. '),
      child: DsSurface(
        tone: match.state == BracketMatchState.current
            ? DsSurfaceTone.accent
            : DsSurfaceTone.elevated,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DsText(match.title, variant: DsTextVariant.label, maxLines: 2),
            SizedBox(height: theme.padding),
            StatusBadge(
              label: bracketMatchStateLabel(match.state),
              kind: bracketMatchStateKind(match.state),
            ),
            SizedBox(height: theme.padding),
            if (match.first != null)
              ParticipantIdentity(
                participant: match.first!,
                artworkVariant: FighterArtworkVariant.compact,
              ),
            if (match.second != null) ...[
              SizedBox(height: theme.padding),
              ParticipantIdentity(
                participant: match.second!,
                artworkVariant: FighterArtworkVariant.compact,
              ),
            ],
            if (match.conditionLabel != null) ...[
              SizedBox(height: theme.padding),
              DsText(
                match.conditionLabel!,
                variant: DsTextVariant.secondary,
                maxLines: 2,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BracketConnectorPainter extends CustomPainter {
  const _BracketConnectorPainter({
    required this.links,
    required this.matches,
    required this.positions,
    required this.theme,
  });

  final List<BracketLinkViewData> links;
  final List<BracketMatchViewData> matches;
  final Map<String, Rect> positions;
  final DoubleEliminationBracketTheme theme;

  @override
  void paint(Canvas canvas, Size size) {
    final byId = {for (final match in matches) match.id: match};
    for (final link in links) {
      final from = positions[link.fromMatchId];
      final to = positions[link.toMatchId];
      if (from == null || to == null) continue;
      final targetMatch = byId[link.toMatchId];
      final color = switch (targetMatch?.lane) {
        BracketLane.winners => theme.winnerConnector,
        BracketLane.losers => theme.loserConnector,
        _ => theme.connector,
      };
      final paint = Paint()
        ..color = color
        ..strokeWidth = theme.lineWidth
        ..style = PaintingStyle.stroke;
      final start = from.centerRight;
      final end = to.centerLeft;
      final middleX = start.dx + (end.dx - start.dx) / 2;
      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..lineTo(middleX, start.dy)
        ..lineTo(middleX, end.dy)
        ..lineTo(end.dx, end.dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BracketConnectorPainter oldDelegate) =>
      oldDelegate.links != links ||
      oldDelegate.positions != positions ||
      oldDelegate.theme != theme;
}
