// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_hub_database.dart';

// ignore_for_file: type=lint
class $LocalProfilesTable extends LocalProfiles
    with TableInfo<$LocalProfilesTable, LocalProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _singletonIdMeta = const VerificationMeta(
    'singletonId',
  );
  @override
  late final GeneratedColumn<int> singletonId = GeneratedColumn<int>(
    'singleton_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schemaVersionMeta = const VerificationMeta(
    'schemaVersion',
  );
  @override
  late final GeneratedColumn<int> schemaVersion = GeneratedColumn<int>(
    'schema_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    singletonId,
    profileId,
    nickname,
    schemaVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('singleton_id')) {
      context.handle(
        _singletonIdMeta,
        singletonId.isAcceptableOrUnknown(
          data['singleton_id']!,
          _singletonIdMeta,
        ),
      );
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('schema_version')) {
      context.handle(
        _schemaVersionMeta,
        schemaVersion.isAcceptableOrUnknown(
          data['schema_version']!,
          _schemaVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_schemaVersionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {singletonId};
  @override
  LocalProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProfile(
      singletonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}singleton_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      schemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schema_version'],
      )!,
    );
  }

  @override
  $LocalProfilesTable createAlias(String alias) {
    return $LocalProfilesTable(attachedDatabase, alias);
  }
}

class LocalProfile extends DataClass implements Insertable<LocalProfile> {
  final int singletonId;
  final String profileId;
  final String nickname;
  final int schemaVersion;
  const LocalProfile({
    required this.singletonId,
    required this.profileId,
    required this.nickname,
    required this.schemaVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['singleton_id'] = Variable<int>(singletonId);
    map['profile_id'] = Variable<String>(profileId);
    map['nickname'] = Variable<String>(nickname);
    map['schema_version'] = Variable<int>(schemaVersion);
    return map;
  }

  LocalProfilesCompanion toCompanion(bool nullToAbsent) {
    return LocalProfilesCompanion(
      singletonId: Value(singletonId),
      profileId: Value(profileId),
      nickname: Value(nickname),
      schemaVersion: Value(schemaVersion),
    );
  }

  factory LocalProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProfile(
      singletonId: serializer.fromJson<int>(json['singletonId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      nickname: serializer.fromJson<String>(json['nickname']),
      schemaVersion: serializer.fromJson<int>(json['schemaVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'singletonId': serializer.toJson<int>(singletonId),
      'profileId': serializer.toJson<String>(profileId),
      'nickname': serializer.toJson<String>(nickname),
      'schemaVersion': serializer.toJson<int>(schemaVersion),
    };
  }

  LocalProfile copyWith({
    int? singletonId,
    String? profileId,
    String? nickname,
    int? schemaVersion,
  }) => LocalProfile(
    singletonId: singletonId ?? this.singletonId,
    profileId: profileId ?? this.profileId,
    nickname: nickname ?? this.nickname,
    schemaVersion: schemaVersion ?? this.schemaVersion,
  );
  LocalProfile copyWithCompanion(LocalProfilesCompanion data) {
    return LocalProfile(
      singletonId: data.singletonId.present
          ? data.singletonId.value
          : this.singletonId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      schemaVersion: data.schemaVersion.present
          ? data.schemaVersion.value
          : this.schemaVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProfile(')
          ..write('singletonId: $singletonId, ')
          ..write('profileId: $profileId, ')
          ..write('nickname: $nickname, ')
          ..write('schemaVersion: $schemaVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(singletonId, profileId, nickname, schemaVersion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProfile &&
          other.singletonId == this.singletonId &&
          other.profileId == this.profileId &&
          other.nickname == this.nickname &&
          other.schemaVersion == this.schemaVersion);
}

class LocalProfilesCompanion extends UpdateCompanion<LocalProfile> {
  final Value<int> singletonId;
  final Value<String> profileId;
  final Value<String> nickname;
  final Value<int> schemaVersion;
  const LocalProfilesCompanion({
    this.singletonId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.nickname = const Value.absent(),
    this.schemaVersion = const Value.absent(),
  });
  LocalProfilesCompanion.insert({
    this.singletonId = const Value.absent(),
    required String profileId,
    required String nickname,
    required int schemaVersion,
  }) : profileId = Value(profileId),
       nickname = Value(nickname),
       schemaVersion = Value(schemaVersion);
  static Insertable<LocalProfile> custom({
    Expression<int>? singletonId,
    Expression<String>? profileId,
    Expression<String>? nickname,
    Expression<int>? schemaVersion,
  }) {
    return RawValuesInsertable({
      if (singletonId != null) 'singleton_id': singletonId,
      if (profileId != null) 'profile_id': profileId,
      if (nickname != null) 'nickname': nickname,
      if (schemaVersion != null) 'schema_version': schemaVersion,
    });
  }

  LocalProfilesCompanion copyWith({
    Value<int>? singletonId,
    Value<String>? profileId,
    Value<String>? nickname,
    Value<int>? schemaVersion,
  }) {
    return LocalProfilesCompanion(
      singletonId: singletonId ?? this.singletonId,
      profileId: profileId ?? this.profileId,
      nickname: nickname ?? this.nickname,
      schemaVersion: schemaVersion ?? this.schemaVersion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (singletonId.present) {
      map['singleton_id'] = Variable<int>(singletonId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (schemaVersion.present) {
      map['schema_version'] = Variable<int>(schemaVersion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalProfilesCompanion(')
          ..write('singletonId: $singletonId, ')
          ..write('profileId: $profileId, ')
          ..write('nickname: $nickname, ')
          ..write('schemaVersion: $schemaVersion')
          ..write(')'))
        .toString();
  }
}

class $ActiveTournamentSnapshotsTable extends ActiveTournamentSnapshots
    with TableInfo<$ActiveTournamentSnapshotsTable, ActiveTournamentSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActiveTournamentSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _singletonIdMeta = const VerificationMeta(
    'singletonId',
  );
  @override
  late final GeneratedColumn<int> singletonId = GeneratedColumn<int>(
    'singleton_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _tournamentIdMeta = const VerificationMeta(
    'tournamentId',
  );
  @override
  late final GeneratedColumn<String> tournamentId = GeneratedColumn<String>(
    'tournament_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _schemaVersionMeta = const VerificationMeta(
    'schemaVersion',
  );
  @override
  late final GeneratedColumn<int> schemaVersion = GeneratedColumn<int>(
    'schema_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formatIdMeta = const VerificationMeta(
    'formatId',
  );
  @override
  late final GeneratedColumn<String> formatId = GeneratedColumn<String>(
    'format_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rulesetVersionMeta = const VerificationMeta(
    'rulesetVersion',
  );
  @override
  late final GeneratedColumn<int> rulesetVersion = GeneratedColumn<int>(
    'ruleset_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lifecycleMeta = const VerificationMeta(
    'lifecycle',
  );
  @override
  late final GeneratedColumn<String> lifecycle = GeneratedColumn<String>(
    'lifecycle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<String> createdAtUtc = GeneratedColumn<String>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<String> updatedAtUtc = GeneratedColumn<String>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    singletonId,
    tournamentId,
    schemaVersion,
    revision,
    formatId,
    rulesetVersion,
    lifecycle,
    createdAtUtc,
    updatedAtUtc,
    payload,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_tournament_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActiveTournamentSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('singleton_id')) {
      context.handle(
        _singletonIdMeta,
        singletonId.isAcceptableOrUnknown(
          data['singleton_id']!,
          _singletonIdMeta,
        ),
      );
    }
    if (data.containsKey('tournament_id')) {
      context.handle(
        _tournamentIdMeta,
        tournamentId.isAcceptableOrUnknown(
          data['tournament_id']!,
          _tournamentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tournamentIdMeta);
    }
    if (data.containsKey('schema_version')) {
      context.handle(
        _schemaVersionMeta,
        schemaVersion.isAcceptableOrUnknown(
          data['schema_version']!,
          _schemaVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_schemaVersionMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionMeta);
    }
    if (data.containsKey('format_id')) {
      context.handle(
        _formatIdMeta,
        formatId.isAcceptableOrUnknown(data['format_id']!, _formatIdMeta),
      );
    } else if (isInserting) {
      context.missing(_formatIdMeta);
    }
    if (data.containsKey('ruleset_version')) {
      context.handle(
        _rulesetVersionMeta,
        rulesetVersion.isAcceptableOrUnknown(
          data['ruleset_version']!,
          _rulesetVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rulesetVersionMeta);
    }
    if (data.containsKey('lifecycle')) {
      context.handle(
        _lifecycleMeta,
        lifecycle.isAcceptableOrUnknown(data['lifecycle']!, _lifecycleMeta),
      );
    } else if (isInserting) {
      context.missing(_lifecycleMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {singletonId};
  @override
  ActiveTournamentSnapshot map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActiveTournamentSnapshot(
      singletonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}singleton_id'],
      )!,
      tournamentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tournament_id'],
      )!,
      schemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schema_version'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      formatId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}format_id'],
      )!,
      rulesetVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ruleset_version'],
      )!,
      lifecycle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lifecycle'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at_utc'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
    );
  }

  @override
  $ActiveTournamentSnapshotsTable createAlias(String alias) {
    return $ActiveTournamentSnapshotsTable(attachedDatabase, alias);
  }
}

class ActiveTournamentSnapshot extends DataClass
    implements Insertable<ActiveTournamentSnapshot> {
  final int singletonId;
  final String tournamentId;
  final int schemaVersion;
  final int revision;
  final String formatId;
  final int rulesetVersion;
  final String lifecycle;
  final String createdAtUtc;
  final String updatedAtUtc;
  final String payload;
  const ActiveTournamentSnapshot({
    required this.singletonId,
    required this.tournamentId,
    required this.schemaVersion,
    required this.revision,
    required this.formatId,
    required this.rulesetVersion,
    required this.lifecycle,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    required this.payload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['singleton_id'] = Variable<int>(singletonId);
    map['tournament_id'] = Variable<String>(tournamentId);
    map['schema_version'] = Variable<int>(schemaVersion);
    map['revision'] = Variable<int>(revision);
    map['format_id'] = Variable<String>(formatId);
    map['ruleset_version'] = Variable<int>(rulesetVersion);
    map['lifecycle'] = Variable<String>(lifecycle);
    map['created_at_utc'] = Variable<String>(createdAtUtc);
    map['updated_at_utc'] = Variable<String>(updatedAtUtc);
    map['payload'] = Variable<String>(payload);
    return map;
  }

  ActiveTournamentSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return ActiveTournamentSnapshotsCompanion(
      singletonId: Value(singletonId),
      tournamentId: Value(tournamentId),
      schemaVersion: Value(schemaVersion),
      revision: Value(revision),
      formatId: Value(formatId),
      rulesetVersion: Value(rulesetVersion),
      lifecycle: Value(lifecycle),
      createdAtUtc: Value(createdAtUtc),
      updatedAtUtc: Value(updatedAtUtc),
      payload: Value(payload),
    );
  }

  factory ActiveTournamentSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActiveTournamentSnapshot(
      singletonId: serializer.fromJson<int>(json['singletonId']),
      tournamentId: serializer.fromJson<String>(json['tournamentId']),
      schemaVersion: serializer.fromJson<int>(json['schemaVersion']),
      revision: serializer.fromJson<int>(json['revision']),
      formatId: serializer.fromJson<String>(json['formatId']),
      rulesetVersion: serializer.fromJson<int>(json['rulesetVersion']),
      lifecycle: serializer.fromJson<String>(json['lifecycle']),
      createdAtUtc: serializer.fromJson<String>(json['createdAtUtc']),
      updatedAtUtc: serializer.fromJson<String>(json['updatedAtUtc']),
      payload: serializer.fromJson<String>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'singletonId': serializer.toJson<int>(singletonId),
      'tournamentId': serializer.toJson<String>(tournamentId),
      'schemaVersion': serializer.toJson<int>(schemaVersion),
      'revision': serializer.toJson<int>(revision),
      'formatId': serializer.toJson<String>(formatId),
      'rulesetVersion': serializer.toJson<int>(rulesetVersion),
      'lifecycle': serializer.toJson<String>(lifecycle),
      'createdAtUtc': serializer.toJson<String>(createdAtUtc),
      'updatedAtUtc': serializer.toJson<String>(updatedAtUtc),
      'payload': serializer.toJson<String>(payload),
    };
  }

  ActiveTournamentSnapshot copyWith({
    int? singletonId,
    String? tournamentId,
    int? schemaVersion,
    int? revision,
    String? formatId,
    int? rulesetVersion,
    String? lifecycle,
    String? createdAtUtc,
    String? updatedAtUtc,
    String? payload,
  }) => ActiveTournamentSnapshot(
    singletonId: singletonId ?? this.singletonId,
    tournamentId: tournamentId ?? this.tournamentId,
    schemaVersion: schemaVersion ?? this.schemaVersion,
    revision: revision ?? this.revision,
    formatId: formatId ?? this.formatId,
    rulesetVersion: rulesetVersion ?? this.rulesetVersion,
    lifecycle: lifecycle ?? this.lifecycle,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    payload: payload ?? this.payload,
  );
  ActiveTournamentSnapshot copyWithCompanion(
    ActiveTournamentSnapshotsCompanion data,
  ) {
    return ActiveTournamentSnapshot(
      singletonId: data.singletonId.present
          ? data.singletonId.value
          : this.singletonId,
      tournamentId: data.tournamentId.present
          ? data.tournamentId.value
          : this.tournamentId,
      schemaVersion: data.schemaVersion.present
          ? data.schemaVersion.value
          : this.schemaVersion,
      revision: data.revision.present ? data.revision.value : this.revision,
      formatId: data.formatId.present ? data.formatId.value : this.formatId,
      rulesetVersion: data.rulesetVersion.present
          ? data.rulesetVersion.value
          : this.rulesetVersion,
      lifecycle: data.lifecycle.present ? data.lifecycle.value : this.lifecycle,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActiveTournamentSnapshot(')
          ..write('singletonId: $singletonId, ')
          ..write('tournamentId: $tournamentId, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('revision: $revision, ')
          ..write('formatId: $formatId, ')
          ..write('rulesetVersion: $rulesetVersion, ')
          ..write('lifecycle: $lifecycle, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    singletonId,
    tournamentId,
    schemaVersion,
    revision,
    formatId,
    rulesetVersion,
    lifecycle,
    createdAtUtc,
    updatedAtUtc,
    payload,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActiveTournamentSnapshot &&
          other.singletonId == this.singletonId &&
          other.tournamentId == this.tournamentId &&
          other.schemaVersion == this.schemaVersion &&
          other.revision == this.revision &&
          other.formatId == this.formatId &&
          other.rulesetVersion == this.rulesetVersion &&
          other.lifecycle == this.lifecycle &&
          other.createdAtUtc == this.createdAtUtc &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.payload == this.payload);
}

class ActiveTournamentSnapshotsCompanion
    extends UpdateCompanion<ActiveTournamentSnapshot> {
  final Value<int> singletonId;
  final Value<String> tournamentId;
  final Value<int> schemaVersion;
  final Value<int> revision;
  final Value<String> formatId;
  final Value<int> rulesetVersion;
  final Value<String> lifecycle;
  final Value<String> createdAtUtc;
  final Value<String> updatedAtUtc;
  final Value<String> payload;
  const ActiveTournamentSnapshotsCompanion({
    this.singletonId = const Value.absent(),
    this.tournamentId = const Value.absent(),
    this.schemaVersion = const Value.absent(),
    this.revision = const Value.absent(),
    this.formatId = const Value.absent(),
    this.rulesetVersion = const Value.absent(),
    this.lifecycle = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.payload = const Value.absent(),
  });
  ActiveTournamentSnapshotsCompanion.insert({
    this.singletonId = const Value.absent(),
    required String tournamentId,
    required int schemaVersion,
    required int revision,
    required String formatId,
    required int rulesetVersion,
    required String lifecycle,
    required String createdAtUtc,
    required String updatedAtUtc,
    required String payload,
  }) : tournamentId = Value(tournamentId),
       schemaVersion = Value(schemaVersion),
       revision = Value(revision),
       formatId = Value(formatId),
       rulesetVersion = Value(rulesetVersion),
       lifecycle = Value(lifecycle),
       createdAtUtc = Value(createdAtUtc),
       updatedAtUtc = Value(updatedAtUtc),
       payload = Value(payload);
  static Insertable<ActiveTournamentSnapshot> custom({
    Expression<int>? singletonId,
    Expression<String>? tournamentId,
    Expression<int>? schemaVersion,
    Expression<int>? revision,
    Expression<String>? formatId,
    Expression<int>? rulesetVersion,
    Expression<String>? lifecycle,
    Expression<String>? createdAtUtc,
    Expression<String>? updatedAtUtc,
    Expression<String>? payload,
  }) {
    return RawValuesInsertable({
      if (singletonId != null) 'singleton_id': singletonId,
      if (tournamentId != null) 'tournament_id': tournamentId,
      if (schemaVersion != null) 'schema_version': schemaVersion,
      if (revision != null) 'revision': revision,
      if (formatId != null) 'format_id': formatId,
      if (rulesetVersion != null) 'ruleset_version': rulesetVersion,
      if (lifecycle != null) 'lifecycle': lifecycle,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (payload != null) 'payload': payload,
    });
  }

  ActiveTournamentSnapshotsCompanion copyWith({
    Value<int>? singletonId,
    Value<String>? tournamentId,
    Value<int>? schemaVersion,
    Value<int>? revision,
    Value<String>? formatId,
    Value<int>? rulesetVersion,
    Value<String>? lifecycle,
    Value<String>? createdAtUtc,
    Value<String>? updatedAtUtc,
    Value<String>? payload,
  }) {
    return ActiveTournamentSnapshotsCompanion(
      singletonId: singletonId ?? this.singletonId,
      tournamentId: tournamentId ?? this.tournamentId,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      revision: revision ?? this.revision,
      formatId: formatId ?? this.formatId,
      rulesetVersion: rulesetVersion ?? this.rulesetVersion,
      lifecycle: lifecycle ?? this.lifecycle,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      payload: payload ?? this.payload,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (singletonId.present) {
      map['singleton_id'] = Variable<int>(singletonId.value);
    }
    if (tournamentId.present) {
      map['tournament_id'] = Variable<String>(tournamentId.value);
    }
    if (schemaVersion.present) {
      map['schema_version'] = Variable<int>(schemaVersion.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (formatId.present) {
      map['format_id'] = Variable<String>(formatId.value);
    }
    if (rulesetVersion.present) {
      map['ruleset_version'] = Variable<int>(rulesetVersion.value);
    }
    if (lifecycle.present) {
      map['lifecycle'] = Variable<String>(lifecycle.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<String>(createdAtUtc.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<String>(updatedAtUtc.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActiveTournamentSnapshotsCompanion(')
          ..write('singletonId: $singletonId, ')
          ..write('tournamentId: $tournamentId, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('revision: $revision, ')
          ..write('formatId: $formatId, ')
          ..write('rulesetVersion: $rulesetVersion, ')
          ..write('lifecycle: $lifecycle, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }
}

class $ActiveTournamentEventsTable extends ActiveTournamentEvents
    with TableInfo<$ActiveTournamentEventsTable, ActiveTournamentEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActiveTournamentEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tournamentIdMeta = const VerificationMeta(
    'tournamentId',
  );
  @override
  late final GeneratedColumn<String> tournamentId = GeneratedColumn<String>(
    'tournament_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sequenceMeta = const VerificationMeta(
    'sequence',
  );
  @override
  late final GeneratedColumn<int> sequence = GeneratedColumn<int>(
    'sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventVersionMeta = const VerificationMeta(
    'eventVersion',
  );
  @override
  late final GeneratedColumn<int> eventVersion = GeneratedColumn<int>(
    'event_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampUtcMeta = const VerificationMeta(
    'timestampUtc',
  );
  @override
  late final GeneratedColumn<String> timestampUtc = GeneratedColumn<String>(
    'timestamp_utc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    eventId,
    tournamentId,
    sequence,
    revision,
    eventVersion,
    type,
    timestampUtc,
    payload,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_tournament_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActiveTournamentEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('tournament_id')) {
      context.handle(
        _tournamentIdMeta,
        tournamentId.isAcceptableOrUnknown(
          data['tournament_id']!,
          _tournamentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tournamentIdMeta);
    }
    if (data.containsKey('sequence')) {
      context.handle(
        _sequenceMeta,
        sequence.isAcceptableOrUnknown(data['sequence']!, _sequenceMeta),
      );
    } else if (isInserting) {
      context.missing(_sequenceMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionMeta);
    }
    if (data.containsKey('event_version')) {
      context.handle(
        _eventVersionMeta,
        eventVersion.isAcceptableOrUnknown(
          data['event_version']!,
          _eventVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_eventVersionMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('timestamp_utc')) {
      context.handle(
        _timestampUtcMeta,
        timestampUtc.isAcceptableOrUnknown(
          data['timestamp_utc']!,
          _timestampUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timestampUtcMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {tournamentId, sequence},
  ];
  @override
  ActiveTournamentEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActiveTournamentEvent(
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      tournamentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tournament_id'],
      )!,
      sequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      eventVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}event_version'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      timestampUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timestamp_utc'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
    );
  }

  @override
  $ActiveTournamentEventsTable createAlias(String alias) {
    return $ActiveTournamentEventsTable(attachedDatabase, alias);
  }
}

class ActiveTournamentEvent extends DataClass
    implements Insertable<ActiveTournamentEvent> {
  final String eventId;
  final String tournamentId;
  final int sequence;
  final int revision;
  final int eventVersion;
  final String type;
  final String timestampUtc;
  final String payload;
  const ActiveTournamentEvent({
    required this.eventId,
    required this.tournamentId,
    required this.sequence,
    required this.revision,
    required this.eventVersion,
    required this.type,
    required this.timestampUtc,
    required this.payload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_id'] = Variable<String>(eventId);
    map['tournament_id'] = Variable<String>(tournamentId);
    map['sequence'] = Variable<int>(sequence);
    map['revision'] = Variable<int>(revision);
    map['event_version'] = Variable<int>(eventVersion);
    map['type'] = Variable<String>(type);
    map['timestamp_utc'] = Variable<String>(timestampUtc);
    map['payload'] = Variable<String>(payload);
    return map;
  }

  ActiveTournamentEventsCompanion toCompanion(bool nullToAbsent) {
    return ActiveTournamentEventsCompanion(
      eventId: Value(eventId),
      tournamentId: Value(tournamentId),
      sequence: Value(sequence),
      revision: Value(revision),
      eventVersion: Value(eventVersion),
      type: Value(type),
      timestampUtc: Value(timestampUtc),
      payload: Value(payload),
    );
  }

  factory ActiveTournamentEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActiveTournamentEvent(
      eventId: serializer.fromJson<String>(json['eventId']),
      tournamentId: serializer.fromJson<String>(json['tournamentId']),
      sequence: serializer.fromJson<int>(json['sequence']),
      revision: serializer.fromJson<int>(json['revision']),
      eventVersion: serializer.fromJson<int>(json['eventVersion']),
      type: serializer.fromJson<String>(json['type']),
      timestampUtc: serializer.fromJson<String>(json['timestampUtc']),
      payload: serializer.fromJson<String>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventId': serializer.toJson<String>(eventId),
      'tournamentId': serializer.toJson<String>(tournamentId),
      'sequence': serializer.toJson<int>(sequence),
      'revision': serializer.toJson<int>(revision),
      'eventVersion': serializer.toJson<int>(eventVersion),
      'type': serializer.toJson<String>(type),
      'timestampUtc': serializer.toJson<String>(timestampUtc),
      'payload': serializer.toJson<String>(payload),
    };
  }

  ActiveTournamentEvent copyWith({
    String? eventId,
    String? tournamentId,
    int? sequence,
    int? revision,
    int? eventVersion,
    String? type,
    String? timestampUtc,
    String? payload,
  }) => ActiveTournamentEvent(
    eventId: eventId ?? this.eventId,
    tournamentId: tournamentId ?? this.tournamentId,
    sequence: sequence ?? this.sequence,
    revision: revision ?? this.revision,
    eventVersion: eventVersion ?? this.eventVersion,
    type: type ?? this.type,
    timestampUtc: timestampUtc ?? this.timestampUtc,
    payload: payload ?? this.payload,
  );
  ActiveTournamentEvent copyWithCompanion(
    ActiveTournamentEventsCompanion data,
  ) {
    return ActiveTournamentEvent(
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      tournamentId: data.tournamentId.present
          ? data.tournamentId.value
          : this.tournamentId,
      sequence: data.sequence.present ? data.sequence.value : this.sequence,
      revision: data.revision.present ? data.revision.value : this.revision,
      eventVersion: data.eventVersion.present
          ? data.eventVersion.value
          : this.eventVersion,
      type: data.type.present ? data.type.value : this.type,
      timestampUtc: data.timestampUtc.present
          ? data.timestampUtc.value
          : this.timestampUtc,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActiveTournamentEvent(')
          ..write('eventId: $eventId, ')
          ..write('tournamentId: $tournamentId, ')
          ..write('sequence: $sequence, ')
          ..write('revision: $revision, ')
          ..write('eventVersion: $eventVersion, ')
          ..write('type: $type, ')
          ..write('timestampUtc: $timestampUtc, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    eventId,
    tournamentId,
    sequence,
    revision,
    eventVersion,
    type,
    timestampUtc,
    payload,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActiveTournamentEvent &&
          other.eventId == this.eventId &&
          other.tournamentId == this.tournamentId &&
          other.sequence == this.sequence &&
          other.revision == this.revision &&
          other.eventVersion == this.eventVersion &&
          other.type == this.type &&
          other.timestampUtc == this.timestampUtc &&
          other.payload == this.payload);
}

class ActiveTournamentEventsCompanion
    extends UpdateCompanion<ActiveTournamentEvent> {
  final Value<String> eventId;
  final Value<String> tournamentId;
  final Value<int> sequence;
  final Value<int> revision;
  final Value<int> eventVersion;
  final Value<String> type;
  final Value<String> timestampUtc;
  final Value<String> payload;
  final Value<int> rowid;
  const ActiveTournamentEventsCompanion({
    this.eventId = const Value.absent(),
    this.tournamentId = const Value.absent(),
    this.sequence = const Value.absent(),
    this.revision = const Value.absent(),
    this.eventVersion = const Value.absent(),
    this.type = const Value.absent(),
    this.timestampUtc = const Value.absent(),
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActiveTournamentEventsCompanion.insert({
    required String eventId,
    required String tournamentId,
    required int sequence,
    required int revision,
    required int eventVersion,
    required String type,
    required String timestampUtc,
    required String payload,
    this.rowid = const Value.absent(),
  }) : eventId = Value(eventId),
       tournamentId = Value(tournamentId),
       sequence = Value(sequence),
       revision = Value(revision),
       eventVersion = Value(eventVersion),
       type = Value(type),
       timestampUtc = Value(timestampUtc),
       payload = Value(payload);
  static Insertable<ActiveTournamentEvent> custom({
    Expression<String>? eventId,
    Expression<String>? tournamentId,
    Expression<int>? sequence,
    Expression<int>? revision,
    Expression<int>? eventVersion,
    Expression<String>? type,
    Expression<String>? timestampUtc,
    Expression<String>? payload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventId != null) 'event_id': eventId,
      if (tournamentId != null) 'tournament_id': tournamentId,
      if (sequence != null) 'sequence': sequence,
      if (revision != null) 'revision': revision,
      if (eventVersion != null) 'event_version': eventVersion,
      if (type != null) 'type': type,
      if (timestampUtc != null) 'timestamp_utc': timestampUtc,
      if (payload != null) 'payload': payload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActiveTournamentEventsCompanion copyWith({
    Value<String>? eventId,
    Value<String>? tournamentId,
    Value<int>? sequence,
    Value<int>? revision,
    Value<int>? eventVersion,
    Value<String>? type,
    Value<String>? timestampUtc,
    Value<String>? payload,
    Value<int>? rowid,
  }) {
    return ActiveTournamentEventsCompanion(
      eventId: eventId ?? this.eventId,
      tournamentId: tournamentId ?? this.tournamentId,
      sequence: sequence ?? this.sequence,
      revision: revision ?? this.revision,
      eventVersion: eventVersion ?? this.eventVersion,
      type: type ?? this.type,
      timestampUtc: timestampUtc ?? this.timestampUtc,
      payload: payload ?? this.payload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (tournamentId.present) {
      map['tournament_id'] = Variable<String>(tournamentId.value);
    }
    if (sequence.present) {
      map['sequence'] = Variable<int>(sequence.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (eventVersion.present) {
      map['event_version'] = Variable<int>(eventVersion.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (timestampUtc.present) {
      map['timestamp_utc'] = Variable<String>(timestampUtc.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActiveTournamentEventsCompanion(')
          ..write('eventId: $eventId, ')
          ..write('tournamentId: $tournamentId, ')
          ..write('sequence: $sequence, ')
          ..write('revision: $revision, ')
          ..write('eventVersion: $eventVersion, ')
          ..write('type: $type, ')
          ..write('timestampUtc: $timestampUtc, ')
          ..write('payload: $payload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProcessedCommandsTable extends ProcessedCommands
    with TableInfo<$ProcessedCommandsTable, ProcessedCommand> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProcessedCommandsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _commandIdMeta = const VerificationMeta(
    'commandId',
  );
  @override
  late final GeneratedColumn<String> commandId = GeneratedColumn<String>(
    'command_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tournamentIdMeta = const VerificationMeta(
    'tournamentId',
  );
  @override
  late final GeneratedColumn<String> tournamentId = GeneratedColumn<String>(
    'tournament_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resultPayloadMeta = const VerificationMeta(
    'resultPayload',
  );
  @override
  late final GeneratedColumn<String> resultPayload = GeneratedColumn<String>(
    'result_payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    commandId,
    tournamentId,
    revision,
    resultPayload,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'processed_commands';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProcessedCommand> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('command_id')) {
      context.handle(
        _commandIdMeta,
        commandId.isAcceptableOrUnknown(data['command_id']!, _commandIdMeta),
      );
    } else if (isInserting) {
      context.missing(_commandIdMeta);
    }
    if (data.containsKey('tournament_id')) {
      context.handle(
        _tournamentIdMeta,
        tournamentId.isAcceptableOrUnknown(
          data['tournament_id']!,
          _tournamentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tournamentIdMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionMeta);
    }
    if (data.containsKey('result_payload')) {
      context.handle(
        _resultPayloadMeta,
        resultPayload.isAcceptableOrUnknown(
          data['result_payload']!,
          _resultPayloadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_resultPayloadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {commandId};
  @override
  ProcessedCommand map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProcessedCommand(
      commandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}command_id'],
      )!,
      tournamentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tournament_id'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      resultPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result_payload'],
      )!,
    );
  }

  @override
  $ProcessedCommandsTable createAlias(String alias) {
    return $ProcessedCommandsTable(attachedDatabase, alias);
  }
}

class ProcessedCommand extends DataClass
    implements Insertable<ProcessedCommand> {
  final String commandId;
  final String tournamentId;
  final int revision;
  final String resultPayload;
  const ProcessedCommand({
    required this.commandId,
    required this.tournamentId,
    required this.revision,
    required this.resultPayload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['command_id'] = Variable<String>(commandId);
    map['tournament_id'] = Variable<String>(tournamentId);
    map['revision'] = Variable<int>(revision);
    map['result_payload'] = Variable<String>(resultPayload);
    return map;
  }

  ProcessedCommandsCompanion toCompanion(bool nullToAbsent) {
    return ProcessedCommandsCompanion(
      commandId: Value(commandId),
      tournamentId: Value(tournamentId),
      revision: Value(revision),
      resultPayload: Value(resultPayload),
    );
  }

  factory ProcessedCommand.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProcessedCommand(
      commandId: serializer.fromJson<String>(json['commandId']),
      tournamentId: serializer.fromJson<String>(json['tournamentId']),
      revision: serializer.fromJson<int>(json['revision']),
      resultPayload: serializer.fromJson<String>(json['resultPayload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'commandId': serializer.toJson<String>(commandId),
      'tournamentId': serializer.toJson<String>(tournamentId),
      'revision': serializer.toJson<int>(revision),
      'resultPayload': serializer.toJson<String>(resultPayload),
    };
  }

  ProcessedCommand copyWith({
    String? commandId,
    String? tournamentId,
    int? revision,
    String? resultPayload,
  }) => ProcessedCommand(
    commandId: commandId ?? this.commandId,
    tournamentId: tournamentId ?? this.tournamentId,
    revision: revision ?? this.revision,
    resultPayload: resultPayload ?? this.resultPayload,
  );
  ProcessedCommand copyWithCompanion(ProcessedCommandsCompanion data) {
    return ProcessedCommand(
      commandId: data.commandId.present ? data.commandId.value : this.commandId,
      tournamentId: data.tournamentId.present
          ? data.tournamentId.value
          : this.tournamentId,
      revision: data.revision.present ? data.revision.value : this.revision,
      resultPayload: data.resultPayload.present
          ? data.resultPayload.value
          : this.resultPayload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProcessedCommand(')
          ..write('commandId: $commandId, ')
          ..write('tournamentId: $tournamentId, ')
          ..write('revision: $revision, ')
          ..write('resultPayload: $resultPayload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(commandId, tournamentId, revision, resultPayload);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProcessedCommand &&
          other.commandId == this.commandId &&
          other.tournamentId == this.tournamentId &&
          other.revision == this.revision &&
          other.resultPayload == this.resultPayload);
}

class ProcessedCommandsCompanion extends UpdateCompanion<ProcessedCommand> {
  final Value<String> commandId;
  final Value<String> tournamentId;
  final Value<int> revision;
  final Value<String> resultPayload;
  final Value<int> rowid;
  const ProcessedCommandsCompanion({
    this.commandId = const Value.absent(),
    this.tournamentId = const Value.absent(),
    this.revision = const Value.absent(),
    this.resultPayload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProcessedCommandsCompanion.insert({
    required String commandId,
    required String tournamentId,
    required int revision,
    required String resultPayload,
    this.rowid = const Value.absent(),
  }) : commandId = Value(commandId),
       tournamentId = Value(tournamentId),
       revision = Value(revision),
       resultPayload = Value(resultPayload);
  static Insertable<ProcessedCommand> custom({
    Expression<String>? commandId,
    Expression<String>? tournamentId,
    Expression<int>? revision,
    Expression<String>? resultPayload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (commandId != null) 'command_id': commandId,
      if (tournamentId != null) 'tournament_id': tournamentId,
      if (revision != null) 'revision': revision,
      if (resultPayload != null) 'result_payload': resultPayload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProcessedCommandsCompanion copyWith({
    Value<String>? commandId,
    Value<String>? tournamentId,
    Value<int>? revision,
    Value<String>? resultPayload,
    Value<int>? rowid,
  }) {
    return ProcessedCommandsCompanion(
      commandId: commandId ?? this.commandId,
      tournamentId: tournamentId ?? this.tournamentId,
      revision: revision ?? this.revision,
      resultPayload: resultPayload ?? this.resultPayload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (commandId.present) {
      map['command_id'] = Variable<String>(commandId.value);
    }
    if (tournamentId.present) {
      map['tournament_id'] = Variable<String>(tournamentId.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (resultPayload.present) {
      map['result_payload'] = Variable<String>(resultPayload.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProcessedCommandsCompanion(')
          ..write('commandId: $commandId, ')
          ..write('tournamentId: $tournamentId, ')
          ..write('revision: $revision, ')
          ..write('resultPayload: $resultPayload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TournamentHistoryEntriesTable extends TournamentHistoryEntries
    with TableInfo<$TournamentHistoryEntriesTable, TournamentHistoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TournamentHistoryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tournamentIdMeta = const VerificationMeta(
    'tournamentId',
  );
  @override
  late final GeneratedColumn<String> tournamentId = GeneratedColumn<String>(
    'tournament_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schemaVersionMeta = const VerificationMeta(
    'schemaVersion',
  );
  @override
  late final GeneratedColumn<int> schemaVersion = GeneratedColumn<int>(
    'schema_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lifecycleMeta = const VerificationMeta(
    'lifecycle',
  );
  @override
  late final GeneratedColumn<String> lifecycle = GeneratedColumn<String>(
    'lifecycle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finishedAtUtcMeta = const VerificationMeta(
    'finishedAtUtc',
  );
  @override
  late final GeneratedColumn<String> finishedAtUtc = GeneratedColumn<String>(
    'finished_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    tournamentId,
    schemaVersion,
    revision,
    lifecycle,
    finishedAtUtc,
    payload,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tournament_history_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<TournamentHistoryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('tournament_id')) {
      context.handle(
        _tournamentIdMeta,
        tournamentId.isAcceptableOrUnknown(
          data['tournament_id']!,
          _tournamentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tournamentIdMeta);
    }
    if (data.containsKey('schema_version')) {
      context.handle(
        _schemaVersionMeta,
        schemaVersion.isAcceptableOrUnknown(
          data['schema_version']!,
          _schemaVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_schemaVersionMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionMeta);
    }
    if (data.containsKey('lifecycle')) {
      context.handle(
        _lifecycleMeta,
        lifecycle.isAcceptableOrUnknown(data['lifecycle']!, _lifecycleMeta),
      );
    } else if (isInserting) {
      context.missing(_lifecycleMeta);
    }
    if (data.containsKey('finished_at_utc')) {
      context.handle(
        _finishedAtUtcMeta,
        finishedAtUtc.isAcceptableOrUnknown(
          data['finished_at_utc']!,
          _finishedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_finishedAtUtcMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tournamentId};
  @override
  TournamentHistoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TournamentHistoryEntry(
      tournamentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tournament_id'],
      )!,
      schemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schema_version'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      lifecycle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lifecycle'],
      )!,
      finishedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}finished_at_utc'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
    );
  }

  @override
  $TournamentHistoryEntriesTable createAlias(String alias) {
    return $TournamentHistoryEntriesTable(attachedDatabase, alias);
  }
}

class TournamentHistoryEntry extends DataClass
    implements Insertable<TournamentHistoryEntry> {
  final String tournamentId;
  final int schemaVersion;
  final int revision;
  final String lifecycle;
  final String finishedAtUtc;
  final String payload;
  const TournamentHistoryEntry({
    required this.tournamentId,
    required this.schemaVersion,
    required this.revision,
    required this.lifecycle,
    required this.finishedAtUtc,
    required this.payload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tournament_id'] = Variable<String>(tournamentId);
    map['schema_version'] = Variable<int>(schemaVersion);
    map['revision'] = Variable<int>(revision);
    map['lifecycle'] = Variable<String>(lifecycle);
    map['finished_at_utc'] = Variable<String>(finishedAtUtc);
    map['payload'] = Variable<String>(payload);
    return map;
  }

  TournamentHistoryEntriesCompanion toCompanion(bool nullToAbsent) {
    return TournamentHistoryEntriesCompanion(
      tournamentId: Value(tournamentId),
      schemaVersion: Value(schemaVersion),
      revision: Value(revision),
      lifecycle: Value(lifecycle),
      finishedAtUtc: Value(finishedAtUtc),
      payload: Value(payload),
    );
  }

  factory TournamentHistoryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TournamentHistoryEntry(
      tournamentId: serializer.fromJson<String>(json['tournamentId']),
      schemaVersion: serializer.fromJson<int>(json['schemaVersion']),
      revision: serializer.fromJson<int>(json['revision']),
      lifecycle: serializer.fromJson<String>(json['lifecycle']),
      finishedAtUtc: serializer.fromJson<String>(json['finishedAtUtc']),
      payload: serializer.fromJson<String>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tournamentId': serializer.toJson<String>(tournamentId),
      'schemaVersion': serializer.toJson<int>(schemaVersion),
      'revision': serializer.toJson<int>(revision),
      'lifecycle': serializer.toJson<String>(lifecycle),
      'finishedAtUtc': serializer.toJson<String>(finishedAtUtc),
      'payload': serializer.toJson<String>(payload),
    };
  }

  TournamentHistoryEntry copyWith({
    String? tournamentId,
    int? schemaVersion,
    int? revision,
    String? lifecycle,
    String? finishedAtUtc,
    String? payload,
  }) => TournamentHistoryEntry(
    tournamentId: tournamentId ?? this.tournamentId,
    schemaVersion: schemaVersion ?? this.schemaVersion,
    revision: revision ?? this.revision,
    lifecycle: lifecycle ?? this.lifecycle,
    finishedAtUtc: finishedAtUtc ?? this.finishedAtUtc,
    payload: payload ?? this.payload,
  );
  TournamentHistoryEntry copyWithCompanion(
    TournamentHistoryEntriesCompanion data,
  ) {
    return TournamentHistoryEntry(
      tournamentId: data.tournamentId.present
          ? data.tournamentId.value
          : this.tournamentId,
      schemaVersion: data.schemaVersion.present
          ? data.schemaVersion.value
          : this.schemaVersion,
      revision: data.revision.present ? data.revision.value : this.revision,
      lifecycle: data.lifecycle.present ? data.lifecycle.value : this.lifecycle,
      finishedAtUtc: data.finishedAtUtc.present
          ? data.finishedAtUtc.value
          : this.finishedAtUtc,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TournamentHistoryEntry(')
          ..write('tournamentId: $tournamentId, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('revision: $revision, ')
          ..write('lifecycle: $lifecycle, ')
          ..write('finishedAtUtc: $finishedAtUtc, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    tournamentId,
    schemaVersion,
    revision,
    lifecycle,
    finishedAtUtc,
    payload,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TournamentHistoryEntry &&
          other.tournamentId == this.tournamentId &&
          other.schemaVersion == this.schemaVersion &&
          other.revision == this.revision &&
          other.lifecycle == this.lifecycle &&
          other.finishedAtUtc == this.finishedAtUtc &&
          other.payload == this.payload);
}

class TournamentHistoryEntriesCompanion
    extends UpdateCompanion<TournamentHistoryEntry> {
  final Value<String> tournamentId;
  final Value<int> schemaVersion;
  final Value<int> revision;
  final Value<String> lifecycle;
  final Value<String> finishedAtUtc;
  final Value<String> payload;
  final Value<int> rowid;
  const TournamentHistoryEntriesCompanion({
    this.tournamentId = const Value.absent(),
    this.schemaVersion = const Value.absent(),
    this.revision = const Value.absent(),
    this.lifecycle = const Value.absent(),
    this.finishedAtUtc = const Value.absent(),
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TournamentHistoryEntriesCompanion.insert({
    required String tournamentId,
    required int schemaVersion,
    required int revision,
    required String lifecycle,
    required String finishedAtUtc,
    required String payload,
    this.rowid = const Value.absent(),
  }) : tournamentId = Value(tournamentId),
       schemaVersion = Value(schemaVersion),
       revision = Value(revision),
       lifecycle = Value(lifecycle),
       finishedAtUtc = Value(finishedAtUtc),
       payload = Value(payload);
  static Insertable<TournamentHistoryEntry> custom({
    Expression<String>? tournamentId,
    Expression<int>? schemaVersion,
    Expression<int>? revision,
    Expression<String>? lifecycle,
    Expression<String>? finishedAtUtc,
    Expression<String>? payload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tournamentId != null) 'tournament_id': tournamentId,
      if (schemaVersion != null) 'schema_version': schemaVersion,
      if (revision != null) 'revision': revision,
      if (lifecycle != null) 'lifecycle': lifecycle,
      if (finishedAtUtc != null) 'finished_at_utc': finishedAtUtc,
      if (payload != null) 'payload': payload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TournamentHistoryEntriesCompanion copyWith({
    Value<String>? tournamentId,
    Value<int>? schemaVersion,
    Value<int>? revision,
    Value<String>? lifecycle,
    Value<String>? finishedAtUtc,
    Value<String>? payload,
    Value<int>? rowid,
  }) {
    return TournamentHistoryEntriesCompanion(
      tournamentId: tournamentId ?? this.tournamentId,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      revision: revision ?? this.revision,
      lifecycle: lifecycle ?? this.lifecycle,
      finishedAtUtc: finishedAtUtc ?? this.finishedAtUtc,
      payload: payload ?? this.payload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tournamentId.present) {
      map['tournament_id'] = Variable<String>(tournamentId.value);
    }
    if (schemaVersion.present) {
      map['schema_version'] = Variable<int>(schemaVersion.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (lifecycle.present) {
      map['lifecycle'] = Variable<String>(lifecycle.value);
    }
    if (finishedAtUtc.present) {
      map['finished_at_utc'] = Variable<String>(finishedAtUtc.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TournamentHistoryEntriesCompanion(')
          ..write('tournamentId: $tournamentId, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('revision: $revision, ')
          ..write('lifecycle: $lifecycle, ')
          ..write('finishedAtUtc: $finishedAtUtc, ')
          ..write('payload: $payload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$TournamentHubDatabase extends GeneratedDatabase {
  _$TournamentHubDatabase(QueryExecutor e) : super(e);
  $TournamentHubDatabaseManager get managers =>
      $TournamentHubDatabaseManager(this);
  late final $LocalProfilesTable localProfiles = $LocalProfilesTable(this);
  late final $ActiveTournamentSnapshotsTable activeTournamentSnapshots =
      $ActiveTournamentSnapshotsTable(this);
  late final $ActiveTournamentEventsTable activeTournamentEvents =
      $ActiveTournamentEventsTable(this);
  late final $ProcessedCommandsTable processedCommands =
      $ProcessedCommandsTable(this);
  late final $TournamentHistoryEntriesTable tournamentHistoryEntries =
      $TournamentHistoryEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localProfiles,
    activeTournamentSnapshots,
    activeTournamentEvents,
    processedCommands,
    tournamentHistoryEntries,
  ];
}

typedef $$LocalProfilesTableCreateCompanionBuilder =
    LocalProfilesCompanion Function({
      Value<int> singletonId,
      required String profileId,
      required String nickname,
      required int schemaVersion,
    });
typedef $$LocalProfilesTableUpdateCompanionBuilder =
    LocalProfilesCompanion Function({
      Value<int> singletonId,
      Value<String> profileId,
      Value<String> nickname,
      Value<int> schemaVersion,
    });

class $$LocalProfilesTableFilterComposer
    extends Composer<_$TournamentHubDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get singletonId => $composableBuilder(
    column: $table.singletonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalProfilesTableOrderingComposer
    extends Composer<_$TournamentHubDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get singletonId => $composableBuilder(
    column: $table.singletonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalProfilesTableAnnotationComposer
    extends Composer<_$TournamentHubDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get singletonId => $composableBuilder(
    column: $table.singletonId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => column,
  );
}

class $$LocalProfilesTableTableManager
    extends
        RootTableManager<
          _$TournamentHubDatabase,
          $LocalProfilesTable,
          LocalProfile,
          $$LocalProfilesTableFilterComposer,
          $$LocalProfilesTableOrderingComposer,
          $$LocalProfilesTableAnnotationComposer,
          $$LocalProfilesTableCreateCompanionBuilder,
          $$LocalProfilesTableUpdateCompanionBuilder,
          (
            LocalProfile,
            BaseReferences<
              _$TournamentHubDatabase,
              $LocalProfilesTable,
              LocalProfile
            >,
          ),
          LocalProfile,
          PrefetchHooks Function()
        > {
  $$LocalProfilesTableTableManager(
    _$TournamentHubDatabase db,
    $LocalProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> singletonId = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<int> schemaVersion = const Value.absent(),
              }) => LocalProfilesCompanion(
                singletonId: singletonId,
                profileId: profileId,
                nickname: nickname,
                schemaVersion: schemaVersion,
              ),
          createCompanionCallback:
              ({
                Value<int> singletonId = const Value.absent(),
                required String profileId,
                required String nickname,
                required int schemaVersion,
              }) => LocalProfilesCompanion.insert(
                singletonId: singletonId,
                profileId: profileId,
                nickname: nickname,
                schemaVersion: schemaVersion,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$TournamentHubDatabase,
      $LocalProfilesTable,
      LocalProfile,
      $$LocalProfilesTableFilterComposer,
      $$LocalProfilesTableOrderingComposer,
      $$LocalProfilesTableAnnotationComposer,
      $$LocalProfilesTableCreateCompanionBuilder,
      $$LocalProfilesTableUpdateCompanionBuilder,
      (
        LocalProfile,
        BaseReferences<
          _$TournamentHubDatabase,
          $LocalProfilesTable,
          LocalProfile
        >,
      ),
      LocalProfile,
      PrefetchHooks Function()
    >;
typedef $$ActiveTournamentSnapshotsTableCreateCompanionBuilder =
    ActiveTournamentSnapshotsCompanion Function({
      Value<int> singletonId,
      required String tournamentId,
      required int schemaVersion,
      required int revision,
      required String formatId,
      required int rulesetVersion,
      required String lifecycle,
      required String createdAtUtc,
      required String updatedAtUtc,
      required String payload,
    });
typedef $$ActiveTournamentSnapshotsTableUpdateCompanionBuilder =
    ActiveTournamentSnapshotsCompanion Function({
      Value<int> singletonId,
      Value<String> tournamentId,
      Value<int> schemaVersion,
      Value<int> revision,
      Value<String> formatId,
      Value<int> rulesetVersion,
      Value<String> lifecycle,
      Value<String> createdAtUtc,
      Value<String> updatedAtUtc,
      Value<String> payload,
    });

class $$ActiveTournamentSnapshotsTableFilterComposer
    extends Composer<_$TournamentHubDatabase, $ActiveTournamentSnapshotsTable> {
  $$ActiveTournamentSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get singletonId => $composableBuilder(
    column: $table.singletonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tournamentId => $composableBuilder(
    column: $table.tournamentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get formatId => $composableBuilder(
    column: $table.formatId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rulesetVersion => $composableBuilder(
    column: $table.rulesetVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lifecycle => $composableBuilder(
    column: $table.lifecycle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActiveTournamentSnapshotsTableOrderingComposer
    extends Composer<_$TournamentHubDatabase, $ActiveTournamentSnapshotsTable> {
  $$ActiveTournamentSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get singletonId => $composableBuilder(
    column: $table.singletonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tournamentId => $composableBuilder(
    column: $table.tournamentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get formatId => $composableBuilder(
    column: $table.formatId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rulesetVersion => $composableBuilder(
    column: $table.rulesetVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lifecycle => $composableBuilder(
    column: $table.lifecycle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActiveTournamentSnapshotsTableAnnotationComposer
    extends Composer<_$TournamentHubDatabase, $ActiveTournamentSnapshotsTable> {
  $$ActiveTournamentSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get singletonId => $composableBuilder(
    column: $table.singletonId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tournamentId => $composableBuilder(
    column: $table.tournamentId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get formatId =>
      $composableBuilder(column: $table.formatId, builder: (column) => column);

  GeneratedColumn<int> get rulesetVersion => $composableBuilder(
    column: $table.rulesetVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lifecycle =>
      $composableBuilder(column: $table.lifecycle, builder: (column) => column);

  GeneratedColumn<String> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);
}

class $$ActiveTournamentSnapshotsTableTableManager
    extends
        RootTableManager<
          _$TournamentHubDatabase,
          $ActiveTournamentSnapshotsTable,
          ActiveTournamentSnapshot,
          $$ActiveTournamentSnapshotsTableFilterComposer,
          $$ActiveTournamentSnapshotsTableOrderingComposer,
          $$ActiveTournamentSnapshotsTableAnnotationComposer,
          $$ActiveTournamentSnapshotsTableCreateCompanionBuilder,
          $$ActiveTournamentSnapshotsTableUpdateCompanionBuilder,
          (
            ActiveTournamentSnapshot,
            BaseReferences<
              _$TournamentHubDatabase,
              $ActiveTournamentSnapshotsTable,
              ActiveTournamentSnapshot
            >,
          ),
          ActiveTournamentSnapshot,
          PrefetchHooks Function()
        > {
  $$ActiveTournamentSnapshotsTableTableManager(
    _$TournamentHubDatabase db,
    $ActiveTournamentSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActiveTournamentSnapshotsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ActiveTournamentSnapshotsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ActiveTournamentSnapshotsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> singletonId = const Value.absent(),
                Value<String> tournamentId = const Value.absent(),
                Value<int> schemaVersion = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> formatId = const Value.absent(),
                Value<int> rulesetVersion = const Value.absent(),
                Value<String> lifecycle = const Value.absent(),
                Value<String> createdAtUtc = const Value.absent(),
                Value<String> updatedAtUtc = const Value.absent(),
                Value<String> payload = const Value.absent(),
              }) => ActiveTournamentSnapshotsCompanion(
                singletonId: singletonId,
                tournamentId: tournamentId,
                schemaVersion: schemaVersion,
                revision: revision,
                formatId: formatId,
                rulesetVersion: rulesetVersion,
                lifecycle: lifecycle,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                payload: payload,
              ),
          createCompanionCallback:
              ({
                Value<int> singletonId = const Value.absent(),
                required String tournamentId,
                required int schemaVersion,
                required int revision,
                required String formatId,
                required int rulesetVersion,
                required String lifecycle,
                required String createdAtUtc,
                required String updatedAtUtc,
                required String payload,
              }) => ActiveTournamentSnapshotsCompanion.insert(
                singletonId: singletonId,
                tournamentId: tournamentId,
                schemaVersion: schemaVersion,
                revision: revision,
                formatId: formatId,
                rulesetVersion: rulesetVersion,
                lifecycle: lifecycle,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                payload: payload,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActiveTournamentSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$TournamentHubDatabase,
      $ActiveTournamentSnapshotsTable,
      ActiveTournamentSnapshot,
      $$ActiveTournamentSnapshotsTableFilterComposer,
      $$ActiveTournamentSnapshotsTableOrderingComposer,
      $$ActiveTournamentSnapshotsTableAnnotationComposer,
      $$ActiveTournamentSnapshotsTableCreateCompanionBuilder,
      $$ActiveTournamentSnapshotsTableUpdateCompanionBuilder,
      (
        ActiveTournamentSnapshot,
        BaseReferences<
          _$TournamentHubDatabase,
          $ActiveTournamentSnapshotsTable,
          ActiveTournamentSnapshot
        >,
      ),
      ActiveTournamentSnapshot,
      PrefetchHooks Function()
    >;
typedef $$ActiveTournamentEventsTableCreateCompanionBuilder =
    ActiveTournamentEventsCompanion Function({
      required String eventId,
      required String tournamentId,
      required int sequence,
      required int revision,
      required int eventVersion,
      required String type,
      required String timestampUtc,
      required String payload,
      Value<int> rowid,
    });
typedef $$ActiveTournamentEventsTableUpdateCompanionBuilder =
    ActiveTournamentEventsCompanion Function({
      Value<String> eventId,
      Value<String> tournamentId,
      Value<int> sequence,
      Value<int> revision,
      Value<int> eventVersion,
      Value<String> type,
      Value<String> timestampUtc,
      Value<String> payload,
      Value<int> rowid,
    });

class $$ActiveTournamentEventsTableFilterComposer
    extends Composer<_$TournamentHubDatabase, $ActiveTournamentEventsTable> {
  $$ActiveTournamentEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tournamentId => $composableBuilder(
    column: $table.tournamentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get eventVersion => $composableBuilder(
    column: $table.eventVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timestampUtc => $composableBuilder(
    column: $table.timestampUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActiveTournamentEventsTableOrderingComposer
    extends Composer<_$TournamentHubDatabase, $ActiveTournamentEventsTable> {
  $$ActiveTournamentEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tournamentId => $composableBuilder(
    column: $table.tournamentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get eventVersion => $composableBuilder(
    column: $table.eventVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timestampUtc => $composableBuilder(
    column: $table.timestampUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActiveTournamentEventsTableAnnotationComposer
    extends Composer<_$TournamentHubDatabase, $ActiveTournamentEventsTable> {
  $$ActiveTournamentEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get tournamentId => $composableBuilder(
    column: $table.tournamentId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sequence =>
      $composableBuilder(column: $table.sequence, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<int> get eventVersion => $composableBuilder(
    column: $table.eventVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get timestampUtc => $composableBuilder(
    column: $table.timestampUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);
}

class $$ActiveTournamentEventsTableTableManager
    extends
        RootTableManager<
          _$TournamentHubDatabase,
          $ActiveTournamentEventsTable,
          ActiveTournamentEvent,
          $$ActiveTournamentEventsTableFilterComposer,
          $$ActiveTournamentEventsTableOrderingComposer,
          $$ActiveTournamentEventsTableAnnotationComposer,
          $$ActiveTournamentEventsTableCreateCompanionBuilder,
          $$ActiveTournamentEventsTableUpdateCompanionBuilder,
          (
            ActiveTournamentEvent,
            BaseReferences<
              _$TournamentHubDatabase,
              $ActiveTournamentEventsTable,
              ActiveTournamentEvent
            >,
          ),
          ActiveTournamentEvent,
          PrefetchHooks Function()
        > {
  $$ActiveTournamentEventsTableTableManager(
    _$TournamentHubDatabase db,
    $ActiveTournamentEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActiveTournamentEventsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ActiveTournamentEventsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ActiveTournamentEventsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> eventId = const Value.absent(),
                Value<String> tournamentId = const Value.absent(),
                Value<int> sequence = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> eventVersion = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> timestampUtc = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActiveTournamentEventsCompanion(
                eventId: eventId,
                tournamentId: tournamentId,
                sequence: sequence,
                revision: revision,
                eventVersion: eventVersion,
                type: type,
                timestampUtc: timestampUtc,
                payload: payload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String eventId,
                required String tournamentId,
                required int sequence,
                required int revision,
                required int eventVersion,
                required String type,
                required String timestampUtc,
                required String payload,
                Value<int> rowid = const Value.absent(),
              }) => ActiveTournamentEventsCompanion.insert(
                eventId: eventId,
                tournamentId: tournamentId,
                sequence: sequence,
                revision: revision,
                eventVersion: eventVersion,
                type: type,
                timestampUtc: timestampUtc,
                payload: payload,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActiveTournamentEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$TournamentHubDatabase,
      $ActiveTournamentEventsTable,
      ActiveTournamentEvent,
      $$ActiveTournamentEventsTableFilterComposer,
      $$ActiveTournamentEventsTableOrderingComposer,
      $$ActiveTournamentEventsTableAnnotationComposer,
      $$ActiveTournamentEventsTableCreateCompanionBuilder,
      $$ActiveTournamentEventsTableUpdateCompanionBuilder,
      (
        ActiveTournamentEvent,
        BaseReferences<
          _$TournamentHubDatabase,
          $ActiveTournamentEventsTable,
          ActiveTournamentEvent
        >,
      ),
      ActiveTournamentEvent,
      PrefetchHooks Function()
    >;
typedef $$ProcessedCommandsTableCreateCompanionBuilder =
    ProcessedCommandsCompanion Function({
      required String commandId,
      required String tournamentId,
      required int revision,
      required String resultPayload,
      Value<int> rowid,
    });
typedef $$ProcessedCommandsTableUpdateCompanionBuilder =
    ProcessedCommandsCompanion Function({
      Value<String> commandId,
      Value<String> tournamentId,
      Value<int> revision,
      Value<String> resultPayload,
      Value<int> rowid,
    });

class $$ProcessedCommandsTableFilterComposer
    extends Composer<_$TournamentHubDatabase, $ProcessedCommandsTable> {
  $$ProcessedCommandsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get commandId => $composableBuilder(
    column: $table.commandId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tournamentId => $composableBuilder(
    column: $table.tournamentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultPayload => $composableBuilder(
    column: $table.resultPayload,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProcessedCommandsTableOrderingComposer
    extends Composer<_$TournamentHubDatabase, $ProcessedCommandsTable> {
  $$ProcessedCommandsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get commandId => $composableBuilder(
    column: $table.commandId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tournamentId => $composableBuilder(
    column: $table.tournamentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultPayload => $composableBuilder(
    column: $table.resultPayload,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProcessedCommandsTableAnnotationComposer
    extends Composer<_$TournamentHubDatabase, $ProcessedCommandsTable> {
  $$ProcessedCommandsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get commandId =>
      $composableBuilder(column: $table.commandId, builder: (column) => column);

  GeneratedColumn<String> get tournamentId => $composableBuilder(
    column: $table.tournamentId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get resultPayload => $composableBuilder(
    column: $table.resultPayload,
    builder: (column) => column,
  );
}

class $$ProcessedCommandsTableTableManager
    extends
        RootTableManager<
          _$TournamentHubDatabase,
          $ProcessedCommandsTable,
          ProcessedCommand,
          $$ProcessedCommandsTableFilterComposer,
          $$ProcessedCommandsTableOrderingComposer,
          $$ProcessedCommandsTableAnnotationComposer,
          $$ProcessedCommandsTableCreateCompanionBuilder,
          $$ProcessedCommandsTableUpdateCompanionBuilder,
          (
            ProcessedCommand,
            BaseReferences<
              _$TournamentHubDatabase,
              $ProcessedCommandsTable,
              ProcessedCommand
            >,
          ),
          ProcessedCommand,
          PrefetchHooks Function()
        > {
  $$ProcessedCommandsTableTableManager(
    _$TournamentHubDatabase db,
    $ProcessedCommandsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProcessedCommandsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProcessedCommandsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProcessedCommandsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> commandId = const Value.absent(),
                Value<String> tournamentId = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> resultPayload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProcessedCommandsCompanion(
                commandId: commandId,
                tournamentId: tournamentId,
                revision: revision,
                resultPayload: resultPayload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String commandId,
                required String tournamentId,
                required int revision,
                required String resultPayload,
                Value<int> rowid = const Value.absent(),
              }) => ProcessedCommandsCompanion.insert(
                commandId: commandId,
                tournamentId: tournamentId,
                revision: revision,
                resultPayload: resultPayload,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProcessedCommandsTableProcessedTableManager =
    ProcessedTableManager<
      _$TournamentHubDatabase,
      $ProcessedCommandsTable,
      ProcessedCommand,
      $$ProcessedCommandsTableFilterComposer,
      $$ProcessedCommandsTableOrderingComposer,
      $$ProcessedCommandsTableAnnotationComposer,
      $$ProcessedCommandsTableCreateCompanionBuilder,
      $$ProcessedCommandsTableUpdateCompanionBuilder,
      (
        ProcessedCommand,
        BaseReferences<
          _$TournamentHubDatabase,
          $ProcessedCommandsTable,
          ProcessedCommand
        >,
      ),
      ProcessedCommand,
      PrefetchHooks Function()
    >;
typedef $$TournamentHistoryEntriesTableCreateCompanionBuilder =
    TournamentHistoryEntriesCompanion Function({
      required String tournamentId,
      required int schemaVersion,
      required int revision,
      required String lifecycle,
      required String finishedAtUtc,
      required String payload,
      Value<int> rowid,
    });
typedef $$TournamentHistoryEntriesTableUpdateCompanionBuilder =
    TournamentHistoryEntriesCompanion Function({
      Value<String> tournamentId,
      Value<int> schemaVersion,
      Value<int> revision,
      Value<String> lifecycle,
      Value<String> finishedAtUtc,
      Value<String> payload,
      Value<int> rowid,
    });

class $$TournamentHistoryEntriesTableFilterComposer
    extends Composer<_$TournamentHubDatabase, $TournamentHistoryEntriesTable> {
  $$TournamentHistoryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get tournamentId => $composableBuilder(
    column: $table.tournamentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lifecycle => $composableBuilder(
    column: $table.lifecycle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get finishedAtUtc => $composableBuilder(
    column: $table.finishedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TournamentHistoryEntriesTableOrderingComposer
    extends Composer<_$TournamentHubDatabase, $TournamentHistoryEntriesTable> {
  $$TournamentHistoryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get tournamentId => $composableBuilder(
    column: $table.tournamentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lifecycle => $composableBuilder(
    column: $table.lifecycle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get finishedAtUtc => $composableBuilder(
    column: $table.finishedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TournamentHistoryEntriesTableAnnotationComposer
    extends Composer<_$TournamentHubDatabase, $TournamentHistoryEntriesTable> {
  $$TournamentHistoryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tournamentId => $composableBuilder(
    column: $table.tournamentId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get lifecycle =>
      $composableBuilder(column: $table.lifecycle, builder: (column) => column);

  GeneratedColumn<String> get finishedAtUtc => $composableBuilder(
    column: $table.finishedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);
}

class $$TournamentHistoryEntriesTableTableManager
    extends
        RootTableManager<
          _$TournamentHubDatabase,
          $TournamentHistoryEntriesTable,
          TournamentHistoryEntry,
          $$TournamentHistoryEntriesTableFilterComposer,
          $$TournamentHistoryEntriesTableOrderingComposer,
          $$TournamentHistoryEntriesTableAnnotationComposer,
          $$TournamentHistoryEntriesTableCreateCompanionBuilder,
          $$TournamentHistoryEntriesTableUpdateCompanionBuilder,
          (
            TournamentHistoryEntry,
            BaseReferences<
              _$TournamentHubDatabase,
              $TournamentHistoryEntriesTable,
              TournamentHistoryEntry
            >,
          ),
          TournamentHistoryEntry,
          PrefetchHooks Function()
        > {
  $$TournamentHistoryEntriesTableTableManager(
    _$TournamentHubDatabase db,
    $TournamentHistoryEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TournamentHistoryEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$TournamentHistoryEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TournamentHistoryEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> tournamentId = const Value.absent(),
                Value<int> schemaVersion = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> lifecycle = const Value.absent(),
                Value<String> finishedAtUtc = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TournamentHistoryEntriesCompanion(
                tournamentId: tournamentId,
                schemaVersion: schemaVersion,
                revision: revision,
                lifecycle: lifecycle,
                finishedAtUtc: finishedAtUtc,
                payload: payload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tournamentId,
                required int schemaVersion,
                required int revision,
                required String lifecycle,
                required String finishedAtUtc,
                required String payload,
                Value<int> rowid = const Value.absent(),
              }) => TournamentHistoryEntriesCompanion.insert(
                tournamentId: tournamentId,
                schemaVersion: schemaVersion,
                revision: revision,
                lifecycle: lifecycle,
                finishedAtUtc: finishedAtUtc,
                payload: payload,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TournamentHistoryEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$TournamentHubDatabase,
      $TournamentHistoryEntriesTable,
      TournamentHistoryEntry,
      $$TournamentHistoryEntriesTableFilterComposer,
      $$TournamentHistoryEntriesTableOrderingComposer,
      $$TournamentHistoryEntriesTableAnnotationComposer,
      $$TournamentHistoryEntriesTableCreateCompanionBuilder,
      $$TournamentHistoryEntriesTableUpdateCompanionBuilder,
      (
        TournamentHistoryEntry,
        BaseReferences<
          _$TournamentHubDatabase,
          $TournamentHistoryEntriesTable,
          TournamentHistoryEntry
        >,
      ),
      TournamentHistoryEntry,
      PrefetchHooks Function()
    >;

class $TournamentHubDatabaseManager {
  final _$TournamentHubDatabase _db;
  $TournamentHubDatabaseManager(this._db);
  $$LocalProfilesTableTableManager get localProfiles =>
      $$LocalProfilesTableTableManager(_db, _db.localProfiles);
  $$ActiveTournamentSnapshotsTableTableManager get activeTournamentSnapshots =>
      $$ActiveTournamentSnapshotsTableTableManager(
        _db,
        _db.activeTournamentSnapshots,
      );
  $$ActiveTournamentEventsTableTableManager get activeTournamentEvents =>
      $$ActiveTournamentEventsTableTableManager(
        _db,
        _db.activeTournamentEvents,
      );
  $$ProcessedCommandsTableTableManager get processedCommands =>
      $$ProcessedCommandsTableTableManager(_db, _db.processedCommands);
  $$TournamentHistoryEntriesTableTableManager get tournamentHistoryEntries =>
      $$TournamentHistoryEntriesTableTableManager(
        _db,
        _db.tournamentHistoryEntries,
      );
}
