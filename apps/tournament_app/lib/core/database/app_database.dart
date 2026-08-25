import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:tournament_app/features/profile/data/database/tables/local_profiles_table.dart';
import 'package:tournament_app/features/history/data/database/tables/tournament_history_records_table.dart';
import 'package:tournament_app/features/tournament/data/database/tables/tournament_drafts_table.dart';
import 'package:tournament_app/features/tournament/data/database/tables/active_tournaments_table.dart';
import 'package:tournament_app/features/tournament/data/database/tables/active_double_elimination_tournaments_table.dart';
import 'package:tournament_app/features/tournament/data/database/tables/finished_standings_table.dart';
import 'package:tournament_app/features/tournament/data/database/tables/finished_tournaments_table.dart';
import 'package:tournament_app/features/tournament/data/database/tables/match_bouts_table.dart';
import 'package:tournament_app/features/tournament/data/database/tables/match_updates_table.dart';
import 'package:tournament_app/features/tournament/data/database/tables/tournament_fighter_assignments_table.dart';
import 'package:tournament_app/features/tournament/data/database/tables/tournament_matches_table.dart';
import 'package:tournament_app/features/tournament/data/database/tables/tournament_participants_table.dart';
import 'package:tournament_app/features/tournament/data/database/tables/tournament_rounds_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    LocalProfiles,
    TournamentDrafts,
    TournamentParticipants,
    ActiveTournaments,
    TournamentFighterAssignments,
    TournamentRounds,
    TournamentMatches,
    MatchBouts,
    MatchUpdates,
    FinishedTournaments,
    FinishedStandings,
    TournamentHistoryRecords,
    ActiveDoubleEliminationTournaments,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor? executor})
    : super(executor ?? driftDatabase(name: 'tournament_hub'));

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(tournamentDrafts);
        await migrator.createTable(tournamentParticipants);
      }
      if (from < 3) {
        await migrator.createTable(activeTournaments);
        await migrator.createTable(tournamentFighterAssignments);
        await migrator.createTable(tournamentRounds);
        await migrator.createTable(tournamentMatches);
        await migrator.createTable(matchBouts);
        await migrator.createTable(matchUpdates);
        await migrator.createTable(finishedTournaments);
        await migrator.createTable(finishedStandings);
      }
      if (from == 3) {
        await migrator.addColumn(
          activeTournaments,
          activeTournaments.rulesetId,
        );
        await migrator.addColumn(
          activeTournaments,
          activeTournaments.rulesetVersion,
        );
        await migrator.createTable(finishedTournaments);
        await migrator.createTable(finishedStandings);
      }
      if (from < 5) {
        if (!await _hasTable('tournament_history_records')) {
          await migrator.createTable(tournamentHistoryRecords);
        }
      }
      if (from < 6) {
        if (from >= 2 && !await _hasColumn('tournament_drafts', 'format')) {
          await migrator.addColumn(tournamentDrafts, tournamentDrafts.format);
        }
        if (from >= 5 &&
            !await _hasColumn('tournament_history_records', 'format')) {
          await migrator.addColumn(
            tournamentHistoryRecords,
            tournamentHistoryRecords.format,
          );
        }
        if (!await _hasTable('active_double_elimination_tournaments')) {
          await migrator.createTable(activeDoubleEliminationTournaments);
        }
      }
    },
  );

  Future<bool> _hasTable(String name) async {
    final row = await customSelect(
      'SELECT 1 FROM sqlite_master WHERE type = ? AND name = ? LIMIT 1',
      variables: [Variable('table'), Variable(name)],
    ).getSingleOrNull();
    return row != null;
  }

  Future<bool> _hasColumn(String table, String column) async {
    final rows = await customSelect('PRAGMA table_info($table)').get();
    return rows.any((row) => row.read<String>('name') == column);
  }
}
