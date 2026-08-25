import 'package:flutter/material.dart';
import 'package:tournament_app/app/presentation/layout/app_breakpoints.dart';
import 'package:tournament_app/features/fighters/domain/repositories/fighter_registry.dart';
import 'package:tournament_app/features/fighters/presentation/resolvers/fighter_avatar_resolver.dart';
import 'package:tournament_app/features/history/application/tournament_history_controller.dart';
import 'package:tournament_app/features/history/domain/entities/tournament_history_summary.dart';
import 'package:tournament_app/features/history/presentation/double_elimination_history_detail.dart';
import 'package:tournament_app/features/history/presentation/tournament_history_detail.dart';

class TournamentHistoryScreen extends StatefulWidget {
  const TournamentHistoryScreen({
    required this.controller,
    required this.fighterRegistry,
    required this.avatarResolver,
    super.key,
  });

  final TournamentHistoryController controller;
  final FighterRegistry fighterRegistry;
  final FighterAvatarResolver avatarResolver;

  @override
  State<TournamentHistoryScreen> createState() =>
      _TournamentHistoryScreenState();
}

class _TournamentHistoryScreenState extends State<TournamentHistoryScreen> {
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
    return Scaffold(
      appBar: AppBar(title: const Text('История турниров')),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.controller,
          builder: (context, _) => LayoutBuilder(
            builder: (context, constraints) {
              final content = _buildContent(context);
              if (constraints.maxWidth < AppBreakpoints.wide) return content;
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppBreakpoints.maxContentWidth,
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 360, child: content),
                      const VerticalDivider(width: 1),
                      Expanded(child: _buildSelectedDetail()),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return switch (widget.controller.status) {
      TournamentHistoryStatus.loading => const Center(
        child: CircularProgressIndicator(),
      ),
      TournamentHistoryStatus.failure => _HistoryMessage(
        icon: Icons.cloud_off_outlined,
        message: widget.controller.errorMessage!,
        actionLabel: 'Повторить',
        onAction: widget.controller.initialize,
      ),
      TournamentHistoryStatus.ready when widget.controller.items.isEmpty =>
        const _HistoryMessage(
          icon: Icons.history_outlined,
          message: 'Завершённых турниров пока нет.',
        ),
      TournamentHistoryStatus.ready => ListView.builder(
        key: const Key('tournament-history-list'),
        padding: const EdgeInsets.all(16),
        itemCount: widget.controller.items.length,
        itemBuilder: (context, index) {
          final item = widget.controller.items[index];
          return Card(
            child: ListTile(
              selected: widget.controller.selectedId == item.tournamentId,
              leading: const Icon(Icons.emoji_events_outlined),
              title: Text(item.name),
              subtitle: Text(
                'Чемпион: ${item.championNickname} · '
                '${item.championFighterName}\n'
                '${item.participantCount} участников · ${item.format.displayName}',
              ),
              isThreeLine: true,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _open(item),
            ),
          );
        },
      ),
    };
  }

  Widget _buildSelectedDetail() {
    if (widget.controller.isLoadingDetail) {
      return const Center(child: CircularProgressIndicator());
    }
    if (widget.controller.detailErrorMessage case final message?) {
      return _HistoryMessage(
        icon: Icons.error_outline,
        message: message,
        actionLabel: 'Повторить',
        onAction: widget.controller.selectedSummary == null
            ? null
            : () =>
                  widget.controller.select(widget.controller.selectedSummary!),
      );
    }
    final doubleElimination =
        widget.controller.selectedDoubleEliminationTournament;
    if (doubleElimination != null) {
      return DoubleEliminationHistoryDetail(snapshot: doubleElimination);
    }
    final snapshot = widget.controller.selectedTournament;
    if (snapshot == null) {
      return const _HistoryMessage(
        icon: Icons.touch_app_outlined,
        message: 'Выберите турнир слева.',
      );
    }
    return TournamentHistoryDetail(
      snapshot: snapshot,
      fighterRegistry: widget.fighterRegistry,
      avatarResolver: widget.avatarResolver,
    );
  }

  Future<void> _open(TournamentHistorySummary item) async {
    final isWide = MediaQuery.sizeOf(context).width >= AppBreakpoints.wide;
    final loaded = await widget.controller.select(item);
    if (!mounted || isWide || !loaded) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(item.name)),
          body: widget.controller.selectedDoubleEliminationTournament != null
              ? DoubleEliminationHistoryDetail(
                  snapshot:
                      widget.controller.selectedDoubleEliminationTournament!,
                )
              : TournamentHistoryDetail(
                  snapshot: widget.controller.selectedTournament!,
                  fighterRegistry: widget.fighterRegistry,
                  avatarResolver: widget.avatarResolver,
                ),
        ),
      ),
    );
  }
}

class _HistoryMessage extends StatelessWidget {
  const _HistoryMessage({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            if (actionLabel case final label?) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(label)),
            ],
          ],
        ),
      ),
    );
  }
}
