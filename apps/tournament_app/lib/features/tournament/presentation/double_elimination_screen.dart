import 'package:flutter/material.dart';
import 'package:tournament_app/features/fighters/domain/repositories/fighter_registry.dart';
import 'package:tournament_app/features/fighters/presentation/resolvers/fighter_avatar_resolver.dart';
import 'package:tournament_app/features/tournament/application/double_elimination_conduct_controller.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_match_view.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_tournament.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/bracket_match_status.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/bracket_stage.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';
import 'package:tournament_app/features/tournament/presentation/double_elimination_results_view.dart';

class DoubleEliminationScreen extends StatefulWidget {
  const DoubleEliminationScreen({
    required this.controller,
    required this.fighterRegistry,
    required this.avatarResolver,
    super.key,
  });

  final DoubleEliminationConductController controller;
  final FighterRegistry fighterRegistry;
  final FighterAvatarResolver avatarResolver;

  @override
  State<DoubleEliminationScreen> createState() =>
      _DoubleEliminationScreenState();
}

class _DoubleEliminationScreenState extends State<DoubleEliminationScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.initialize();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final tournament = widget.controller.tournament;
        return Scaffold(
          appBar: AppBar(
            title: Text(tournament?.draft.name.value ?? 'Double Elimination'),
            actions: [
              if ((tournament?.isCompleted ?? false) &&
                  !widget.controller.isFinished)
                TextButton.icon(
                  key: const Key('finish-double-elimination'),
                  onPressed: widget.controller.isSaving
                      ? null
                      : widget.controller.finish,
                  icon: const Icon(Icons.emoji_events_outlined),
                  label: const Text('Завершить'),
                ),
            ],
          ),
          body: SafeArea(child: _buildBody(tournament)),
        );
      },
    );
  }

  Widget _buildBody(DoubleEliminationTournament? tournament) {
    if (widget.controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (tournament == null) {
      return _ErrorState(
        message: widget.controller.errorMessage ?? 'Не удалось открыть турнир.',
        onRetry: widget.controller.initialize,
      );
    }
    if (widget.controller.isFinished) {
      return DoubleEliminationResultsView(
        tournament: tournament,
        fighterRegistry: widget.fighterRegistry,
        avatarResolver: widget.avatarResolver,
      );
    }
    final sections = <Widget>[
      _BracketSection(
        title: 'Верхняя сетка',
        matches: tournament.bracket.matches
            .where((view) => view.definition.stage == BracketStage.winners)
            .toList(),
        tournament: tournament,
        controller: widget.controller,
        fighterRegistry: widget.fighterRegistry,
        avatarResolver: widget.avatarResolver,
      ),
      _BracketSection(
        title: 'Нижняя сетка',
        matches: tournament.bracket.matches
            .where((view) => view.definition.stage == BracketStage.losers)
            .toList(),
        tournament: tournament,
        controller: widget.controller,
        fighterRegistry: widget.fighterRegistry,
        avatarResolver: widget.avatarResolver,
      ),
      _BracketSection(
        title: 'Гранд-финал',
        matches: tournament.bracket.matches
            .where(
              (view) =>
                  view.definition.stage == BracketStage.grandFinal ||
                  view.definition.stage == BracketStage.grandFinalReset,
            )
            .toList(),
        tournament: tournament,
        controller: widget.controller,
        fighterRegistry: widget.fighterRegistry,
        avatarResolver: widget.avatarResolver,
      ),
      _PlacementSection(
        tournament: tournament,
        controller: widget.controller,
        fighterRegistry: widget.fighterRegistry,
      ),
    ];
    final error = widget.controller.errorMessage;
    return Column(
      children: [
        if (error != null) _InlineError(message: error),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final section in sections) ...[
                section,
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _BracketSection extends StatelessWidget {
  const _BracketSection({
    required this.title,
    required this.matches,
    required this.tournament,
    required this.controller,
    required this.fighterRegistry,
    required this.avatarResolver,
  });

  final String title;
  final List<DoubleEliminationMatchView> matches;
  final DoubleEliminationTournament tournament;
  final DoubleEliminationConductController controller;
  final FighterRegistry fighterRegistry;
  final FighterAvatarResolver avatarResolver;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      key: ValueKey(title),
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        for (final match in matches) ...[
          Text(
            match.definition.stage == BracketStage.grandFinalReset
                ? 'Reset'
                : 'Раунд ${match.definition.round} · матч ${match.definition.position + 1}',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 4),
          _BracketMatchCard(
            view: match,
            tournament: tournament,
            controller: controller,
            fighterRegistry: fighterRegistry,
            avatarResolver: avatarResolver,
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _BracketMatchCard extends StatelessWidget {
  const _BracketMatchCard({
    required this.view,
    required this.tournament,
    required this.controller,
    required this.fighterRegistry,
    required this.avatarResolver,
  });

  final DoubleEliminationMatchView view;
  final DoubleEliminationTournament tournament;
  final DoubleEliminationConductController controller;
  final FighterRegistry fighterRegistry;
  final FighterAvatarResolver avatarResolver;

  @override
  Widget build(BuildContext context) {
    if (view.status == BracketMatchStatus.skipped) {
      return const Card(child: ListTile(title: Text('Не требуется')));
    }
    if (view.status == BracketMatchStatus.waiting) {
      return const Card(child: ListTile(title: Text('Ожидает участников')));
    }
    if (view.status == BracketMatchStatus.automatic) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.fast_forward_outlined),
          title: Text(
            '${_participantLabel(view.winnerId!)} проходит автоматически',
          ),
          subtitle: const Text('Bye · результат не требуется'),
        ),
      );
    }
    final result = view.result;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _ParticipantAction(
              participantId: view.firstParticipantId!,
              isWinner: result?.winnerId == view.firstParticipantId,
              enabled:
                  view.status == BracketMatchStatus.ready &&
                  !controller.isSaving,
              onPressed: () => controller.recordBracketResult(
                matchId: view.definition.id,
                winnerId: view.firstParticipantId!,
              ),
              tournament: tournament,
              fighterRegistry: fighterRegistry,
              avatarResolver: avatarResolver,
            ),
            const Divider(),
            _ParticipantAction(
              participantId: view.secondParticipantId!,
              isWinner: result?.winnerId == view.secondParticipantId,
              enabled:
                  view.status == BracketMatchStatus.ready &&
                  !controller.isSaving,
              onPressed: () => controller.recordBracketResult(
                matchId: view.definition.id,
                winnerId: view.secondParticipantId!,
              ),
              tournament: tournament,
              fighterRegistry: fighterRegistry,
              avatarResolver: avatarResolver,
            ),
            if (view.status == BracketMatchStatus.completed)
              TextButton.icon(
                onPressed: controller.isSaving
                    ? null
                    : () => _showCorrectionDialog(context),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Исправить результат'),
              ),
          ],
        ),
      ),
    );
  }

  String _participantLabel(TournamentParticipantId id) {
    final nickname = tournament.draft.participants
        .firstWhere((participant) => participant.id == id)
        .nickname
        .value;
    final assignment = tournament.fighterAssignments.firstWhere(
      (item) => item.participantId == id,
    );
    final fighterName =
        fighterRegistry.findById(assignment.fighterId)?.displayName ??
        'Боец недоступен';
    return '$nickname · $fighterName';
  }

  Future<void> _showCorrectionDialog(BuildContext context) async {
    final winner = await showDialog<TournamentParticipantId>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Исправить результат?'),
        content: const Text(
          'Все зависимые результаты будут удалены, а сетка пересчитана.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          for (final id in [
            view.firstParticipantId!,
            view.secondParticipantId!,
          ])
            FilledButton(
              onPressed: () => Navigator.pop(context, id),
              child: Text('Победил ${_participantLabel(id)}'),
            ),
        ],
      ),
    );
    if (winner != null) {
      await controller.correctBracketResult(
        matchId: view.definition.id,
        winnerId: winner,
      );
    }
  }
}

class _ParticipantAction extends StatelessWidget {
  const _ParticipantAction({
    required this.participantId,
    required this.isWinner,
    required this.enabled,
    required this.onPressed,
    required this.tournament,
    required this.fighterRegistry,
    required this.avatarResolver,
  });

  final TournamentParticipantId participantId;
  final bool isWinner;
  final bool enabled;
  final VoidCallback onPressed;
  final DoubleEliminationTournament tournament;
  final FighterRegistry fighterRegistry;
  final FighterAvatarResolver avatarResolver;

  @override
  Widget build(BuildContext context) {
    final participant = tournament.draft.participants.firstWhere(
      (item) => item.id == participantId,
    );
    final assignment = tournament.fighterAssignments.firstWhere(
      (item) => item.participantId == participantId,
    );
    final fighter = fighterRegistry.findById(assignment.fighterId);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundImage: fighter == null
            ? null
            : AssetImage(avatarResolver.resolve(fighter.avatarId)),
        child: fighter == null ? const Icon(Icons.person_outline) : null,
      ),
      title: Text(participant.nickname.value),
      subtitle: Text(fighter?.displayName ?? 'Боец недоступен'),
      trailing: viewResult(context),
    );
  }

  Widget viewResult(BuildContext context) {
    if (enabled) {
      return FilledButton(onPressed: onPressed, child: const Text('Победил'));
    }
    return isWinner
        ? const Chip(
            avatar: Icon(Icons.check, size: 18),
            label: Text('Победитель'),
          )
        : const SizedBox.shrink();
  }
}

class _PlacementSection extends StatelessWidget {
  const _PlacementSection({
    required this.tournament,
    required this.controller,
    required this.fighterRegistry,
  });

  final DoubleEliminationTournament tournament;
  final DoubleEliminationConductController controller;
  final FighterRegistry fighterRegistry;

  @override
  Widget build(BuildContext context) {
    if (!tournament.bracket.isCompleted) {
      return const Text('Переигровки появятся после основной сетки.');
    }
    if (tournament.placementReplays.isEmpty) {
      return const Text('Все итоговые места определены.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Переигровка мест',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        for (final replays in tournament.placementReplays.values) ...[
          for (final replay in replays) ...[
            Text('Этап ${replay.replayNumber} · все со всеми'),
            for (final match in replay.matches)
              Card(
                child: ListTile(
                  title: Text(
                    '${_participantLabel(match.scheduledMatch.firstParticipantId)} — '
                    '${_participantLabel(match.scheduledMatch.secondParticipantId)}',
                  ),
                  subtitle: match.isCompleted
                      ? Text(
                          'Победил: '
                          '${_participantLabel(match.result!.winnerId)}',
                        )
                      : null,
                  trailing: match.isCompleted
                      ? const Icon(Icons.check)
                      : Wrap(
                          spacing: 4,
                          children: [
                            for (final id in [
                              match.scheduledMatch.firstParticipantId,
                              match.scheduledMatch.secondParticipantId,
                            ])
                              IconButton(
                                tooltip: 'Победил ${_participantLabel(id)}',
                                onPressed: controller.isSaving
                                    ? null
                                    : () => controller.recordPlacementResult(
                                        group: replay.participantIds,
                                        matchId: match.scheduledMatch.id,
                                        winnerId: id,
                                      ),
                                icon: const Icon(Icons.sports_martial_arts),
                              ),
                          ],
                        ),
                ),
              ),
          ],
        ],
      ],
    );
  }

  String _participantLabel(TournamentParticipantId id) {
    final nickname = tournament.draft.participants
        .firstWhere((participant) => participant.id == id)
        .nickname
        .value;
    final assignment = tournament.fighterAssignments.firstWhere(
      (item) => item.participantId == id,
    );
    final fighterName =
        fighterRegistry.findById(assignment.fighterId)?.displayName ??
        'Боец недоступен';
    return '$nickname · $fighterName';
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => MaterialBanner(
    content: Text(message),
    actions: [TextButton(onPressed: () {}, child: const Text('Закрыть'))],
  );
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message),
        const SizedBox(height: 12),
        FilledButton(onPressed: onRetry, child: const Text('Повторить')),
      ],
    ),
  );
}
