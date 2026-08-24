import 'package:tournament_app/core/database/app_database.dart';
import 'package:tournament_app/features/profile/data/mappers/local_profile_mapper.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/profile/domain/exceptions/local_profile_storage_exception.dart';
import 'package:tournament_app/features/profile/domain/repositories/local_profile_repository.dart';

final class DriftLocalProfileRepository implements LocalProfileRepository {
  const DriftLocalProfileRepository(this._database);

  final AppDatabase _database;
  final LocalProfileMapper _mapper = const LocalProfileMapper();

  @override
  Future<LocalProfile?> getProfile() async {
    try {
      final row = await (_database.select(
        _database.localProfiles,
      )..limit(1)).getSingleOrNull();
      return row == null ? null : _mapper.toDomain(_mapper.fromRow(row));
    } on Object catch (error) {
      throw LocalProfileStorageException(
        'Не удалось загрузить локальный профиль.',
        error,
      );
    }
  }

  @override
  Future<void> saveProfile(LocalProfile profile) async {
    final data = _mapper.fromDomain(profile);

    try {
      await _database.transaction(() async {
        await _database.delete(_database.localProfiles).go();
        await _database
            .into(_database.localProfiles)
            .insert(_mapper.toCompanion(data));
      });
    } on Object catch (error) {
      throw LocalProfileStorageException(
        'Не удалось сохранить локальный профиль.',
        error,
      );
    }
  }
}
