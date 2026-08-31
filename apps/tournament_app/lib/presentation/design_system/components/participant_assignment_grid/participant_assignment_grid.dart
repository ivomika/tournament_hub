import 'package:flutter/material.dart';

import '../ds_surface/ds_surface.dart';
import '../empty_state/empty_state.dart';
import '../participant_identity/participant_identity.dart';
import 'participant_assignment_grid_theme.dart';

enum ParticipantAssignmentGridState { data, loading, error }

class ParticipantAssignmentGrid extends StatelessWidget {
  const ParticipantAssignmentGrid({
    required this.participants,
    this.state = ParticipantAssignmentGridState.data,
    super.key,
  });

  final List<PreviewParticipant> participants;
  final ParticipantAssignmentGridState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AssignmentGridTheme>()!;
    if (state == ParticipantAssignmentGridState.loading) {
      return const TournamentEmptyState(
        title: 'Назначаем персонажей',
        message: 'Сохраняем уникального бойца для каждого участника.',
      );
    }
    if (state == ParticipantAssignmentGridState.error) {
      return const TournamentEmptyState(
        title: 'Не удалось показать назначения',
        message: 'Повторите раздачу персонажей.',
        isError: true,
      );
    }
    if (participants.isEmpty) {
      return const TournamentEmptyState(
        title: 'Назначений пока нет',
        message: 'Добавьте участников и запустите раздачу персонажей.',
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= theme.expandedBreakpoint
            ? theme.expandedColumns
            : constraints.maxWidth >= theme.mediumBreakpoint
            ? theme.mediumColumns
            : theme.compactColumns;
        final rowCount = (participants.length / columns).ceil();
        return Column(
          children: [
            for (var row = 0; row < rowCount; row++) ...[
              if (row > 0) SizedBox(height: theme.gap),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var column = 0; column < columns; column++) ...[
                      if (column > 0) SizedBox(width: theme.gap),
                      Expanded(child: _assignmentAt(row * columns + column)),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _assignmentAt(int index) {
    if (index >= participants.length) return const SizedBox.shrink();
    final participant = participants[index];
    return DsSurface(
      key: ValueKey('assignment-${participant.nickname}-$index'),
      tone: DsSurfaceTone.elevated,
      child: ParticipantIdentity(participant: participant),
    );
  }
}
