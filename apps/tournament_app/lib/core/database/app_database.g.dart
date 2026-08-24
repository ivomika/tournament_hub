// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalProfilesTable extends LocalProfiles
    with TableInfo<$LocalProfilesTable, LocalProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [id, nickname];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
    );
  }

  @override
  $LocalProfilesTable createAlias(String alias) {
    return $LocalProfilesTable(attachedDatabase, alias);
  }
}

class LocalProfileRow extends DataClass implements Insertable<LocalProfileRow> {
  final String id;
  final String nickname;
  const LocalProfileRow({required this.id, required this.nickname});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nickname'] = Variable<String>(nickname);
    return map;
  }

  LocalProfilesCompanion toCompanion(bool nullToAbsent) {
    return LocalProfilesCompanion(id: Value(id), nickname: Value(nickname));
  }

  factory LocalProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProfileRow(
      id: serializer.fromJson<String>(json['id']),
      nickname: serializer.fromJson<String>(json['nickname']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nickname': serializer.toJson<String>(nickname),
    };
  }

  LocalProfileRow copyWith({String? id, String? nickname}) =>
      LocalProfileRow(id: id ?? this.id, nickname: nickname ?? this.nickname);
  LocalProfileRow copyWithCompanion(LocalProfilesCompanion data) {
    return LocalProfileRow(
      id: data.id.present ? data.id.value : this.id,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProfileRow(')
          ..write('id: $id, ')
          ..write('nickname: $nickname')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nickname);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProfileRow &&
          other.id == this.id &&
          other.nickname == this.nickname);
}

class LocalProfilesCompanion extends UpdateCompanion<LocalProfileRow> {
  final Value<String> id;
  final Value<String> nickname;
  final Value<int> rowid;
  const LocalProfilesCompanion({
    this.id = const Value.absent(),
    this.nickname = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalProfilesCompanion.insert({
    required String id,
    required String nickname,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nickname = Value(nickname);
  static Insertable<LocalProfileRow> custom({
    Expression<String>? id,
    Expression<String>? nickname,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nickname != null) 'nickname': nickname,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? nickname,
    Value<int>? rowid,
  }) {
    return LocalProfilesCompanion(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalProfilesCompanion(')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TournamentDraftsTable extends TournamentDrafts
    with TableInfo<$TournamentDraftsTable, TournamentDraftRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TournamentDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tournament_drafts';
  @override
  VerificationContext validateIntegrity(
    Insertable<TournamentDraftRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TournamentDraftRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TournamentDraftRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $TournamentDraftsTable createAlias(String alias) {
    return $TournamentDraftsTable(attachedDatabase, alias);
  }
}

class TournamentDraftRow extends DataClass
    implements Insertable<TournamentDraftRow> {
  final String id;
  final String name;
  final String status;
  const TournamentDraftRow({
    required this.id,
    required this.name,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['status'] = Variable<String>(status);
    return map;
  }

  TournamentDraftsCompanion toCompanion(bool nullToAbsent) {
    return TournamentDraftsCompanion(
      id: Value(id),
      name: Value(name),
      status: Value(status),
    );
  }

  factory TournamentDraftRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TournamentDraftRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'status': serializer.toJson<String>(status),
    };
  }

  TournamentDraftRow copyWith({String? id, String? name, String? status}) =>
      TournamentDraftRow(
        id: id ?? this.id,
        name: name ?? this.name,
        status: status ?? this.status,
      );
  TournamentDraftRow copyWithCompanion(TournamentDraftsCompanion data) {
    return TournamentDraftRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TournamentDraftRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TournamentDraftRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.status == this.status);
}

class TournamentDraftsCompanion extends UpdateCompanion<TournamentDraftRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> status;
  final Value<int> rowid;
  const TournamentDraftsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TournamentDraftsCompanion.insert({
    required String id,
    required String name,
    required String status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       status = Value(status);
  static Insertable<TournamentDraftRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TournamentDraftsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return TournamentDraftsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TournamentDraftsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TournamentParticipantsTable extends TournamentParticipants
    with TableInfo<$TournamentParticipantsTable, TournamentParticipantRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TournamentParticipantsTable(this.attachedDatabase, [this._alias]);
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tournament_drafts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _participantIdMeta = const VerificationMeta(
    'participantId',
  );
  @override
  late final GeneratedColumn<String> participantId = GeneratedColumn<String>(
    'participant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    tournamentId,
    participantId,
    nickname,
    source,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tournament_participants';
  @override
  VerificationContext validateIntegrity(
    Insertable<TournamentParticipantRow> instance, {
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
    if (data.containsKey('participant_id')) {
      context.handle(
        _participantIdMeta,
        participantId.isAcceptableOrUnknown(
          data['participant_id']!,
          _participantIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_participantIdMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tournamentId, participantId, source};
  @override
  TournamentParticipantRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TournamentParticipantRow(
      tournamentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tournament_id'],
      )!,
      participantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}participant_id'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $TournamentParticipantsTable createAlias(String alias) {
    return $TournamentParticipantsTable(attachedDatabase, alias);
  }
}

class TournamentParticipantRow extends DataClass
    implements Insertable<TournamentParticipantRow> {
  final String tournamentId;
  final String participantId;
  final String nickname;
  final String source;
  final int position;
  const TournamentParticipantRow({
    required this.tournamentId,
    required this.participantId,
    required this.nickname,
    required this.source,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tournament_id'] = Variable<String>(tournamentId);
    map['participant_id'] = Variable<String>(participantId);
    map['nickname'] = Variable<String>(nickname);
    map['source'] = Variable<String>(source);
    map['position'] = Variable<int>(position);
    return map;
  }

  TournamentParticipantsCompanion toCompanion(bool nullToAbsent) {
    return TournamentParticipantsCompanion(
      tournamentId: Value(tournamentId),
      participantId: Value(participantId),
      nickname: Value(nickname),
      source: Value(source),
      position: Value(position),
    );
  }

  factory TournamentParticipantRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TournamentParticipantRow(
      tournamentId: serializer.fromJson<String>(json['tournamentId']),
      participantId: serializer.fromJson<String>(json['participantId']),
      nickname: serializer.fromJson<String>(json['nickname']),
      source: serializer.fromJson<String>(json['source']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tournamentId': serializer.toJson<String>(tournamentId),
      'participantId': serializer.toJson<String>(participantId),
      'nickname': serializer.toJson<String>(nickname),
      'source': serializer.toJson<String>(source),
      'position': serializer.toJson<int>(position),
    };
  }

  TournamentParticipantRow copyWith({
    String? tournamentId,
    String? participantId,
    String? nickname,
    String? source,
    int? position,
  }) => TournamentParticipantRow(
    tournamentId: tournamentId ?? this.tournamentId,
    participantId: participantId ?? this.participantId,
    nickname: nickname ?? this.nickname,
    source: source ?? this.source,
    position: position ?? this.position,
  );
  TournamentParticipantRow copyWithCompanion(
    TournamentParticipantsCompanion data,
  ) {
    return TournamentParticipantRow(
      tournamentId: data.tournamentId.present
          ? data.tournamentId.value
          : this.tournamentId,
      participantId: data.participantId.present
          ? data.participantId.value
          : this.participantId,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      source: data.source.present ? data.source.value : this.source,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TournamentParticipantRow(')
          ..write('tournamentId: $tournamentId, ')
          ..write('participantId: $participantId, ')
          ..write('nickname: $nickname, ')
          ..write('source: $source, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(tournamentId, participantId, nickname, source, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TournamentParticipantRow &&
          other.tournamentId == this.tournamentId &&
          other.participantId == this.participantId &&
          other.nickname == this.nickname &&
          other.source == this.source &&
          other.position == this.position);
}

class TournamentParticipantsCompanion
    extends UpdateCompanion<TournamentParticipantRow> {
  final Value<String> tournamentId;
  final Value<String> participantId;
  final Value<String> nickname;
  final Value<String> source;
  final Value<int> position;
  final Value<int> rowid;
  const TournamentParticipantsCompanion({
    this.tournamentId = const Value.absent(),
    this.participantId = const Value.absent(),
    this.nickname = const Value.absent(),
    this.source = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TournamentParticipantsCompanion.insert({
    required String tournamentId,
    required String participantId,
    required String nickname,
    required String source,
    required int position,
    this.rowid = const Value.absent(),
  }) : tournamentId = Value(tournamentId),
       participantId = Value(participantId),
       nickname = Value(nickname),
       source = Value(source),
       position = Value(position);
  static Insertable<TournamentParticipantRow> custom({
    Expression<String>? tournamentId,
    Expression<String>? participantId,
    Expression<String>? nickname,
    Expression<String>? source,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tournamentId != null) 'tournament_id': tournamentId,
      if (participantId != null) 'participant_id': participantId,
      if (nickname != null) 'nickname': nickname,
      if (source != null) 'source': source,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TournamentParticipantsCompanion copyWith({
    Value<String>? tournamentId,
    Value<String>? participantId,
    Value<String>? nickname,
    Value<String>? source,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return TournamentParticipantsCompanion(
      tournamentId: tournamentId ?? this.tournamentId,
      participantId: participantId ?? this.participantId,
      nickname: nickname ?? this.nickname,
      source: source ?? this.source,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tournamentId.present) {
      map['tournament_id'] = Variable<String>(tournamentId.value);
    }
    if (participantId.present) {
      map['participant_id'] = Variable<String>(participantId.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TournamentParticipantsCompanion(')
          ..write('tournamentId: $tournamentId, ')
          ..write('participantId: $participantId, ')
          ..write('nickname: $nickname, ')
          ..write('source: $source, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalProfilesTable localProfiles = $LocalProfilesTable(this);
  late final $TournamentDraftsTable tournamentDrafts = $TournamentDraftsTable(
    this,
  );
  late final $TournamentParticipantsTable tournamentParticipants =
      $TournamentParticipantsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localProfiles,
    tournamentDrafts,
    tournamentParticipants,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tournament_drafts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tournament_participants', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$LocalProfilesTableCreateCompanionBuilder =
    LocalProfilesCompanion Function({
      required String id,
      required String nickname,
      Value<int> rowid,
    });
typedef $$LocalProfilesTableUpdateCompanionBuilder =
    LocalProfilesCompanion Function({
      Value<String> id,
      Value<String> nickname,
      Value<int> rowid,
    });

class $$LocalProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);
}

class $$LocalProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalProfilesTable,
          LocalProfileRow,
          $$LocalProfilesTableFilterComposer,
          $$LocalProfilesTableOrderingComposer,
          $$LocalProfilesTableAnnotationComposer,
          $$LocalProfilesTableCreateCompanionBuilder,
          $$LocalProfilesTableUpdateCompanionBuilder,
          (
            LocalProfileRow,
            BaseReferences<_$AppDatabase, $LocalProfilesTable, LocalProfileRow>,
          ),
          LocalProfileRow,
          PrefetchHooks Function()
        > {
  $$LocalProfilesTableTableManager(_$AppDatabase db, $LocalProfilesTable table)
    : super(
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
                Value<String> id = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalProfilesCompanion(
                id: id,
                nickname: nickname,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nickname,
                Value<int> rowid = const Value.absent(),
              }) => LocalProfilesCompanion.insert(
                id: id,
                nickname: nickname,
                rowid: rowid,
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
      _$AppDatabase,
      $LocalProfilesTable,
      LocalProfileRow,
      $$LocalProfilesTableFilterComposer,
      $$LocalProfilesTableOrderingComposer,
      $$LocalProfilesTableAnnotationComposer,
      $$LocalProfilesTableCreateCompanionBuilder,
      $$LocalProfilesTableUpdateCompanionBuilder,
      (
        LocalProfileRow,
        BaseReferences<_$AppDatabase, $LocalProfilesTable, LocalProfileRow>,
      ),
      LocalProfileRow,
      PrefetchHooks Function()
    >;
typedef $$TournamentDraftsTableCreateCompanionBuilder =
    TournamentDraftsCompanion Function({
      required String id,
      required String name,
      required String status,
      Value<int> rowid,
    });
typedef $$TournamentDraftsTableUpdateCompanionBuilder =
    TournamentDraftsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> status,
      Value<int> rowid,
    });

final class $$TournamentDraftsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TournamentDraftsTable,
          TournamentDraftRow
        > {
  $$TournamentDraftsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $TournamentParticipantsTable,
    List<TournamentParticipantRow>
  >
  _tournamentParticipantsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.tournamentParticipants,
        aliasName:
            'tournament_drafts__id__tournament_participants__tournament_id',
      );

  $$TournamentParticipantsTableProcessedTableManager
  get tournamentParticipantsRefs {
    final manager = $$TournamentParticipantsTableTableManager(
      $_db,
      $_db.tournamentParticipants,
    ).filter((f) => f.tournamentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _tournamentParticipantsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TournamentDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $TournamentDraftsTable> {
  $$TournamentDraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tournamentParticipantsRefs(
    Expression<bool> Function($$TournamentParticipantsTableFilterComposer f) f,
  ) {
    final $$TournamentParticipantsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.tournamentParticipants,
          getReferencedColumn: (t) => t.tournamentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TournamentParticipantsTableFilterComposer(
                $db: $db,
                $table: $db.tournamentParticipants,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TournamentDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $TournamentDraftsTable> {
  $$TournamentDraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TournamentDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TournamentDraftsTable> {
  $$TournamentDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  Expression<T> tournamentParticipantsRefs<T extends Object>(
    Expression<T> Function($$TournamentParticipantsTableAnnotationComposer a) f,
  ) {
    final $$TournamentParticipantsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.tournamentParticipants,
          getReferencedColumn: (t) => t.tournamentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TournamentParticipantsTableAnnotationComposer(
                $db: $db,
                $table: $db.tournamentParticipants,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TournamentDraftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TournamentDraftsTable,
          TournamentDraftRow,
          $$TournamentDraftsTableFilterComposer,
          $$TournamentDraftsTableOrderingComposer,
          $$TournamentDraftsTableAnnotationComposer,
          $$TournamentDraftsTableCreateCompanionBuilder,
          $$TournamentDraftsTableUpdateCompanionBuilder,
          (TournamentDraftRow, $$TournamentDraftsTableReferences),
          TournamentDraftRow,
          PrefetchHooks Function({bool tournamentParticipantsRefs})
        > {
  $$TournamentDraftsTableTableManager(
    _$AppDatabase db,
    $TournamentDraftsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TournamentDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TournamentDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TournamentDraftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TournamentDraftsCompanion(
                id: id,
                name: name,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => TournamentDraftsCompanion.insert(
                id: id,
                name: name,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TournamentDraftsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tournamentParticipantsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (tournamentParticipantsRefs) db.tournamentParticipants,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tournamentParticipantsRefs)
                    await $_getPrefetchedData<
                      TournamentDraftRow,
                      $TournamentDraftsTable,
                      TournamentParticipantRow
                    >(
                      currentTable: table,
                      referencedTable: $$TournamentDraftsTableReferences
                          ._tournamentParticipantsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TournamentDraftsTableReferences(
                            db,
                            table,
                            p0,
                          ).tournamentParticipantsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.tournamentId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TournamentDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TournamentDraftsTable,
      TournamentDraftRow,
      $$TournamentDraftsTableFilterComposer,
      $$TournamentDraftsTableOrderingComposer,
      $$TournamentDraftsTableAnnotationComposer,
      $$TournamentDraftsTableCreateCompanionBuilder,
      $$TournamentDraftsTableUpdateCompanionBuilder,
      (TournamentDraftRow, $$TournamentDraftsTableReferences),
      TournamentDraftRow,
      PrefetchHooks Function({bool tournamentParticipantsRefs})
    >;
typedef $$TournamentParticipantsTableCreateCompanionBuilder =
    TournamentParticipantsCompanion Function({
      required String tournamentId,
      required String participantId,
      required String nickname,
      required String source,
      required int position,
      Value<int> rowid,
    });
typedef $$TournamentParticipantsTableUpdateCompanionBuilder =
    TournamentParticipantsCompanion Function({
      Value<String> tournamentId,
      Value<String> participantId,
      Value<String> nickname,
      Value<String> source,
      Value<int> position,
      Value<int> rowid,
    });

final class $$TournamentParticipantsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TournamentParticipantsTable,
          TournamentParticipantRow
        > {
  $$TournamentParticipantsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TournamentDraftsTable _tournamentIdTable(_$AppDatabase db) =>
      db.tournamentDrafts.createAlias(
        'tournament_participants__tournament_id__tournament_drafts__id',
      );

  $$TournamentDraftsTableProcessedTableManager get tournamentId {
    final $_column = $_itemColumn<String>('tournament_id')!;

    final manager = $$TournamentDraftsTableTableManager(
      $_db,
      $_db.tournamentDrafts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tournamentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TournamentParticipantsTableFilterComposer
    extends Composer<_$AppDatabase, $TournamentParticipantsTable> {
  $$TournamentParticipantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get participantId => $composableBuilder(
    column: $table.participantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$TournamentDraftsTableFilterComposer get tournamentId {
    final $$TournamentDraftsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tournamentId,
      referencedTable: $db.tournamentDrafts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentDraftsTableFilterComposer(
            $db: $db,
            $table: $db.tournamentDrafts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TournamentParticipantsTableOrderingComposer
    extends Composer<_$AppDatabase, $TournamentParticipantsTable> {
  $$TournamentParticipantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get participantId => $composableBuilder(
    column: $table.participantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$TournamentDraftsTableOrderingComposer get tournamentId {
    final $$TournamentDraftsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tournamentId,
      referencedTable: $db.tournamentDrafts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentDraftsTableOrderingComposer(
            $db: $db,
            $table: $db.tournamentDrafts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TournamentParticipantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TournamentParticipantsTable> {
  $$TournamentParticipantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get participantId => $composableBuilder(
    column: $table.participantId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$TournamentDraftsTableAnnotationComposer get tournamentId {
    final $$TournamentDraftsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tournamentId,
      referencedTable: $db.tournamentDrafts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentDraftsTableAnnotationComposer(
            $db: $db,
            $table: $db.tournamentDrafts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TournamentParticipantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TournamentParticipantsTable,
          TournamentParticipantRow,
          $$TournamentParticipantsTableFilterComposer,
          $$TournamentParticipantsTableOrderingComposer,
          $$TournamentParticipantsTableAnnotationComposer,
          $$TournamentParticipantsTableCreateCompanionBuilder,
          $$TournamentParticipantsTableUpdateCompanionBuilder,
          (TournamentParticipantRow, $$TournamentParticipantsTableReferences),
          TournamentParticipantRow,
          PrefetchHooks Function({bool tournamentId})
        > {
  $$TournamentParticipantsTableTableManager(
    _$AppDatabase db,
    $TournamentParticipantsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TournamentParticipantsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$TournamentParticipantsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TournamentParticipantsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> tournamentId = const Value.absent(),
                Value<String> participantId = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TournamentParticipantsCompanion(
                tournamentId: tournamentId,
                participantId: participantId,
                nickname: nickname,
                source: source,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tournamentId,
                required String participantId,
                required String nickname,
                required String source,
                required int position,
                Value<int> rowid = const Value.absent(),
              }) => TournamentParticipantsCompanion.insert(
                tournamentId: tournamentId,
                participantId: participantId,
                nickname: nickname,
                source: source,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TournamentParticipantsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tournamentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tournamentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.tournamentId,
                        referencedTable: $$TournamentParticipantsTableReferences
                            ._tournamentIdTable(db),
                        referencedColumn:
                            $$TournamentParticipantsTableReferences
                                ._tournamentIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TournamentParticipantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TournamentParticipantsTable,
      TournamentParticipantRow,
      $$TournamentParticipantsTableFilterComposer,
      $$TournamentParticipantsTableOrderingComposer,
      $$TournamentParticipantsTableAnnotationComposer,
      $$TournamentParticipantsTableCreateCompanionBuilder,
      $$TournamentParticipantsTableUpdateCompanionBuilder,
      (TournamentParticipantRow, $$TournamentParticipantsTableReferences),
      TournamentParticipantRow,
      PrefetchHooks Function({bool tournamentId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalProfilesTableTableManager get localProfiles =>
      $$LocalProfilesTableTableManager(_db, _db.localProfiles);
  $$TournamentDraftsTableTableManager get tournamentDrafts =>
      $$TournamentDraftsTableTableManager(_db, _db.tournamentDrafts);
  $$TournamentParticipantsTableTableManager get tournamentParticipants =>
      $$TournamentParticipantsTableTableManager(
        _db,
        _db.tournamentParticipants,
      );
}
