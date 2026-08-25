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
  static const VerificationMeta _formatMeta = const VerificationMeta('format');
  @override
  late final GeneratedColumn<String> format = GeneratedColumn<String>(
    'format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('roundRobin'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, status, format];
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
    if (data.containsKey('format')) {
      context.handle(
        _formatMeta,
        format.isAcceptableOrUnknown(data['format']!, _formatMeta),
      );
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
      format: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}format'],
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
  final String format;
  const TournamentDraftRow({
    required this.id,
    required this.name,
    required this.status,
    required this.format,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['status'] = Variable<String>(status);
    map['format'] = Variable<String>(format);
    return map;
  }

  TournamentDraftsCompanion toCompanion(bool nullToAbsent) {
    return TournamentDraftsCompanion(
      id: Value(id),
      name: Value(name),
      status: Value(status),
      format: Value(format),
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
      format: serializer.fromJson<String>(json['format']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'status': serializer.toJson<String>(status),
      'format': serializer.toJson<String>(format),
    };
  }

  TournamentDraftRow copyWith({
    String? id,
    String? name,
    String? status,
    String? format,
  }) => TournamentDraftRow(
    id: id ?? this.id,
    name: name ?? this.name,
    status: status ?? this.status,
    format: format ?? this.format,
  );
  TournamentDraftRow copyWithCompanion(TournamentDraftsCompanion data) {
    return TournamentDraftRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      status: data.status.present ? data.status.value : this.status,
      format: data.format.present ? data.format.value : this.format,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TournamentDraftRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('format: $format')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, status, format);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TournamentDraftRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.status == this.status &&
          other.format == this.format);
}

class TournamentDraftsCompanion extends UpdateCompanion<TournamentDraftRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> status;
  final Value<String> format;
  final Value<int> rowid;
  const TournamentDraftsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.status = const Value.absent(),
    this.format = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TournamentDraftsCompanion.insert({
    required String id,
    required String name,
    required String status,
    this.format = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       status = Value(status);
  static Insertable<TournamentDraftRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? status,
    Expression<String>? format,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (status != null) 'status': status,
      if (format != null) 'format': format,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TournamentDraftsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? status,
    Value<String>? format,
    Value<int>? rowid,
  }) {
    return TournamentDraftsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      format: format ?? this.format,
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
    if (format.present) {
      map['format'] = Variable<String>(format.value);
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
          ..write('format: $format, ')
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

class $ActiveTournamentsTable extends ActiveTournaments
    with TableInfo<$ActiveTournamentsTable, ActiveTournamentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActiveTournamentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _rulesetIdMeta = const VerificationMeta(
    'rulesetId',
  );
  @override
  late final GeneratedColumn<String> rulesetId = GeneratedColumn<String>(
    'ruleset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('mvp-round-robin'),
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
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    tournamentId,
    rulesetId,
    rulesetVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_tournaments';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActiveTournamentRow> instance, {
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
    if (data.containsKey('ruleset_id')) {
      context.handle(
        _rulesetIdMeta,
        rulesetId.isAcceptableOrUnknown(data['ruleset_id']!, _rulesetIdMeta),
      );
    }
    if (data.containsKey('ruleset_version')) {
      context.handle(
        _rulesetVersionMeta,
        rulesetVersion.isAcceptableOrUnknown(
          data['ruleset_version']!,
          _rulesetVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tournamentId};
  @override
  ActiveTournamentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActiveTournamentRow(
      tournamentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tournament_id'],
      )!,
      rulesetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ruleset_id'],
      )!,
      rulesetVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ruleset_version'],
      )!,
    );
  }

  @override
  $ActiveTournamentsTable createAlias(String alias) {
    return $ActiveTournamentsTable(attachedDatabase, alias);
  }
}

class ActiveTournamentRow extends DataClass
    implements Insertable<ActiveTournamentRow> {
  final String tournamentId;
  final String rulesetId;
  final int rulesetVersion;
  const ActiveTournamentRow({
    required this.tournamentId,
    required this.rulesetId,
    required this.rulesetVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tournament_id'] = Variable<String>(tournamentId);
    map['ruleset_id'] = Variable<String>(rulesetId);
    map['ruleset_version'] = Variable<int>(rulesetVersion);
    return map;
  }

  ActiveTournamentsCompanion toCompanion(bool nullToAbsent) {
    return ActiveTournamentsCompanion(
      tournamentId: Value(tournamentId),
      rulesetId: Value(rulesetId),
      rulesetVersion: Value(rulesetVersion),
    );
  }

  factory ActiveTournamentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActiveTournamentRow(
      tournamentId: serializer.fromJson<String>(json['tournamentId']),
      rulesetId: serializer.fromJson<String>(json['rulesetId']),
      rulesetVersion: serializer.fromJson<int>(json['rulesetVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tournamentId': serializer.toJson<String>(tournamentId),
      'rulesetId': serializer.toJson<String>(rulesetId),
      'rulesetVersion': serializer.toJson<int>(rulesetVersion),
    };
  }

  ActiveTournamentRow copyWith({
    String? tournamentId,
    String? rulesetId,
    int? rulesetVersion,
  }) => ActiveTournamentRow(
    tournamentId: tournamentId ?? this.tournamentId,
    rulesetId: rulesetId ?? this.rulesetId,
    rulesetVersion: rulesetVersion ?? this.rulesetVersion,
  );
  ActiveTournamentRow copyWithCompanion(ActiveTournamentsCompanion data) {
    return ActiveTournamentRow(
      tournamentId: data.tournamentId.present
          ? data.tournamentId.value
          : this.tournamentId,
      rulesetId: data.rulesetId.present ? data.rulesetId.value : this.rulesetId,
      rulesetVersion: data.rulesetVersion.present
          ? data.rulesetVersion.value
          : this.rulesetVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActiveTournamentRow(')
          ..write('tournamentId: $tournamentId, ')
          ..write('rulesetId: $rulesetId, ')
          ..write('rulesetVersion: $rulesetVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tournamentId, rulesetId, rulesetVersion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActiveTournamentRow &&
          other.tournamentId == this.tournamentId &&
          other.rulesetId == this.rulesetId &&
          other.rulesetVersion == this.rulesetVersion);
}

class ActiveTournamentsCompanion extends UpdateCompanion<ActiveTournamentRow> {
  final Value<String> tournamentId;
  final Value<String> rulesetId;
  final Value<int> rulesetVersion;
  final Value<int> rowid;
  const ActiveTournamentsCompanion({
    this.tournamentId = const Value.absent(),
    this.rulesetId = const Value.absent(),
    this.rulesetVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActiveTournamentsCompanion.insert({
    required String tournamentId,
    this.rulesetId = const Value.absent(),
    this.rulesetVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : tournamentId = Value(tournamentId);
  static Insertable<ActiveTournamentRow> custom({
    Expression<String>? tournamentId,
    Expression<String>? rulesetId,
    Expression<int>? rulesetVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tournamentId != null) 'tournament_id': tournamentId,
      if (rulesetId != null) 'ruleset_id': rulesetId,
      if (rulesetVersion != null) 'ruleset_version': rulesetVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActiveTournamentsCompanion copyWith({
    Value<String>? tournamentId,
    Value<String>? rulesetId,
    Value<int>? rulesetVersion,
    Value<int>? rowid,
  }) {
    return ActiveTournamentsCompanion(
      tournamentId: tournamentId ?? this.tournamentId,
      rulesetId: rulesetId ?? this.rulesetId,
      rulesetVersion: rulesetVersion ?? this.rulesetVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tournamentId.present) {
      map['tournament_id'] = Variable<String>(tournamentId.value);
    }
    if (rulesetId.present) {
      map['ruleset_id'] = Variable<String>(rulesetId.value);
    }
    if (rulesetVersion.present) {
      map['ruleset_version'] = Variable<int>(rulesetVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActiveTournamentsCompanion(')
          ..write('tournamentId: $tournamentId, ')
          ..write('rulesetId: $rulesetId, ')
          ..write('rulesetVersion: $rulesetVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TournamentFighterAssignmentsTable extends TournamentFighterAssignments
    with
        TableInfo<
          $TournamentFighterAssignmentsTable,
          TournamentFighterAssignmentRow
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TournamentFighterAssignmentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _fighterIdMeta = const VerificationMeta(
    'fighterId',
  );
  @override
  late final GeneratedColumn<String> fighterId = GeneratedColumn<String>(
    'fighter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    tournamentId,
    participantId,
    fighterId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tournament_fighter_assignments';
  @override
  VerificationContext validateIntegrity(
    Insertable<TournamentFighterAssignmentRow> instance, {
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
    if (data.containsKey('fighter_id')) {
      context.handle(
        _fighterIdMeta,
        fighterId.isAcceptableOrUnknown(data['fighter_id']!, _fighterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fighterIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tournamentId, participantId};
  @override
  TournamentFighterAssignmentRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TournamentFighterAssignmentRow(
      tournamentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tournament_id'],
      )!,
      participantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}participant_id'],
      )!,
      fighterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fighter_id'],
      )!,
    );
  }

  @override
  $TournamentFighterAssignmentsTable createAlias(String alias) {
    return $TournamentFighterAssignmentsTable(attachedDatabase, alias);
  }
}

class TournamentFighterAssignmentRow extends DataClass
    implements Insertable<TournamentFighterAssignmentRow> {
  final String tournamentId;
  final String participantId;
  final String fighterId;
  const TournamentFighterAssignmentRow({
    required this.tournamentId,
    required this.participantId,
    required this.fighterId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tournament_id'] = Variable<String>(tournamentId);
    map['participant_id'] = Variable<String>(participantId);
    map['fighter_id'] = Variable<String>(fighterId);
    return map;
  }

  TournamentFighterAssignmentsCompanion toCompanion(bool nullToAbsent) {
    return TournamentFighterAssignmentsCompanion(
      tournamentId: Value(tournamentId),
      participantId: Value(participantId),
      fighterId: Value(fighterId),
    );
  }

  factory TournamentFighterAssignmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TournamentFighterAssignmentRow(
      tournamentId: serializer.fromJson<String>(json['tournamentId']),
      participantId: serializer.fromJson<String>(json['participantId']),
      fighterId: serializer.fromJson<String>(json['fighterId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tournamentId': serializer.toJson<String>(tournamentId),
      'participantId': serializer.toJson<String>(participantId),
      'fighterId': serializer.toJson<String>(fighterId),
    };
  }

  TournamentFighterAssignmentRow copyWith({
    String? tournamentId,
    String? participantId,
    String? fighterId,
  }) => TournamentFighterAssignmentRow(
    tournamentId: tournamentId ?? this.tournamentId,
    participantId: participantId ?? this.participantId,
    fighterId: fighterId ?? this.fighterId,
  );
  TournamentFighterAssignmentRow copyWithCompanion(
    TournamentFighterAssignmentsCompanion data,
  ) {
    return TournamentFighterAssignmentRow(
      tournamentId: data.tournamentId.present
          ? data.tournamentId.value
          : this.tournamentId,
      participantId: data.participantId.present
          ? data.participantId.value
          : this.participantId,
      fighterId: data.fighterId.present ? data.fighterId.value : this.fighterId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TournamentFighterAssignmentRow(')
          ..write('tournamentId: $tournamentId, ')
          ..write('participantId: $participantId, ')
          ..write('fighterId: $fighterId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tournamentId, participantId, fighterId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TournamentFighterAssignmentRow &&
          other.tournamentId == this.tournamentId &&
          other.participantId == this.participantId &&
          other.fighterId == this.fighterId);
}

class TournamentFighterAssignmentsCompanion
    extends UpdateCompanion<TournamentFighterAssignmentRow> {
  final Value<String> tournamentId;
  final Value<String> participantId;
  final Value<String> fighterId;
  final Value<int> rowid;
  const TournamentFighterAssignmentsCompanion({
    this.tournamentId = const Value.absent(),
    this.participantId = const Value.absent(),
    this.fighterId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TournamentFighterAssignmentsCompanion.insert({
    required String tournamentId,
    required String participantId,
    required String fighterId,
    this.rowid = const Value.absent(),
  }) : tournamentId = Value(tournamentId),
       participantId = Value(participantId),
       fighterId = Value(fighterId);
  static Insertable<TournamentFighterAssignmentRow> custom({
    Expression<String>? tournamentId,
    Expression<String>? participantId,
    Expression<String>? fighterId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tournamentId != null) 'tournament_id': tournamentId,
      if (participantId != null) 'participant_id': participantId,
      if (fighterId != null) 'fighter_id': fighterId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TournamentFighterAssignmentsCompanion copyWith({
    Value<String>? tournamentId,
    Value<String>? participantId,
    Value<String>? fighterId,
    Value<int>? rowid,
  }) {
    return TournamentFighterAssignmentsCompanion(
      tournamentId: tournamentId ?? this.tournamentId,
      participantId: participantId ?? this.participantId,
      fighterId: fighterId ?? this.fighterId,
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
    if (fighterId.present) {
      map['fighter_id'] = Variable<String>(fighterId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TournamentFighterAssignmentsCompanion(')
          ..write('tournamentId: $tournamentId, ')
          ..write('participantId: $participantId, ')
          ..write('fighterId: $fighterId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TournamentRoundsTable extends TournamentRounds
    with TableInfo<$TournamentRoundsTable, TournamentRoundRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TournamentRoundsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _roundNumberMeta = const VerificationMeta(
    'roundNumber',
  );
  @override
  late final GeneratedColumn<int> roundNumber = GeneratedColumn<int>(
    'round_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _byeParticipantIdMeta = const VerificationMeta(
    'byeParticipantId',
  );
  @override
  late final GeneratedColumn<String> byeParticipantId = GeneratedColumn<String>(
    'bye_participant_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    tournamentId,
    roundNumber,
    byeParticipantId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tournament_rounds';
  @override
  VerificationContext validateIntegrity(
    Insertable<TournamentRoundRow> instance, {
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
    if (data.containsKey('round_number')) {
      context.handle(
        _roundNumberMeta,
        roundNumber.isAcceptableOrUnknown(
          data['round_number']!,
          _roundNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_roundNumberMeta);
    }
    if (data.containsKey('bye_participant_id')) {
      context.handle(
        _byeParticipantIdMeta,
        byeParticipantId.isAcceptableOrUnknown(
          data['bye_participant_id']!,
          _byeParticipantIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tournamentId, roundNumber};
  @override
  TournamentRoundRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TournamentRoundRow(
      tournamentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tournament_id'],
      )!,
      roundNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}round_number'],
      )!,
      byeParticipantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bye_participant_id'],
      ),
    );
  }

  @override
  $TournamentRoundsTable createAlias(String alias) {
    return $TournamentRoundsTable(attachedDatabase, alias);
  }
}

class TournamentRoundRow extends DataClass
    implements Insertable<TournamentRoundRow> {
  final String tournamentId;
  final int roundNumber;
  final String? byeParticipantId;
  const TournamentRoundRow({
    required this.tournamentId,
    required this.roundNumber,
    this.byeParticipantId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tournament_id'] = Variable<String>(tournamentId);
    map['round_number'] = Variable<int>(roundNumber);
    if (!nullToAbsent || byeParticipantId != null) {
      map['bye_participant_id'] = Variable<String>(byeParticipantId);
    }
    return map;
  }

  TournamentRoundsCompanion toCompanion(bool nullToAbsent) {
    return TournamentRoundsCompanion(
      tournamentId: Value(tournamentId),
      roundNumber: Value(roundNumber),
      byeParticipantId: byeParticipantId == null && nullToAbsent
          ? const Value.absent()
          : Value(byeParticipantId),
    );
  }

  factory TournamentRoundRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TournamentRoundRow(
      tournamentId: serializer.fromJson<String>(json['tournamentId']),
      roundNumber: serializer.fromJson<int>(json['roundNumber']),
      byeParticipantId: serializer.fromJson<String?>(json['byeParticipantId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tournamentId': serializer.toJson<String>(tournamentId),
      'roundNumber': serializer.toJson<int>(roundNumber),
      'byeParticipantId': serializer.toJson<String?>(byeParticipantId),
    };
  }

  TournamentRoundRow copyWith({
    String? tournamentId,
    int? roundNumber,
    Value<String?> byeParticipantId = const Value.absent(),
  }) => TournamentRoundRow(
    tournamentId: tournamentId ?? this.tournamentId,
    roundNumber: roundNumber ?? this.roundNumber,
    byeParticipantId: byeParticipantId.present
        ? byeParticipantId.value
        : this.byeParticipantId,
  );
  TournamentRoundRow copyWithCompanion(TournamentRoundsCompanion data) {
    return TournamentRoundRow(
      tournamentId: data.tournamentId.present
          ? data.tournamentId.value
          : this.tournamentId,
      roundNumber: data.roundNumber.present
          ? data.roundNumber.value
          : this.roundNumber,
      byeParticipantId: data.byeParticipantId.present
          ? data.byeParticipantId.value
          : this.byeParticipantId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TournamentRoundRow(')
          ..write('tournamentId: $tournamentId, ')
          ..write('roundNumber: $roundNumber, ')
          ..write('byeParticipantId: $byeParticipantId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tournamentId, roundNumber, byeParticipantId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TournamentRoundRow &&
          other.tournamentId == this.tournamentId &&
          other.roundNumber == this.roundNumber &&
          other.byeParticipantId == this.byeParticipantId);
}

class TournamentRoundsCompanion extends UpdateCompanion<TournamentRoundRow> {
  final Value<String> tournamentId;
  final Value<int> roundNumber;
  final Value<String?> byeParticipantId;
  final Value<int> rowid;
  const TournamentRoundsCompanion({
    this.tournamentId = const Value.absent(),
    this.roundNumber = const Value.absent(),
    this.byeParticipantId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TournamentRoundsCompanion.insert({
    required String tournamentId,
    required int roundNumber,
    this.byeParticipantId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : tournamentId = Value(tournamentId),
       roundNumber = Value(roundNumber);
  static Insertable<TournamentRoundRow> custom({
    Expression<String>? tournamentId,
    Expression<int>? roundNumber,
    Expression<String>? byeParticipantId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tournamentId != null) 'tournament_id': tournamentId,
      if (roundNumber != null) 'round_number': roundNumber,
      if (byeParticipantId != null) 'bye_participant_id': byeParticipantId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TournamentRoundsCompanion copyWith({
    Value<String>? tournamentId,
    Value<int>? roundNumber,
    Value<String?>? byeParticipantId,
    Value<int>? rowid,
  }) {
    return TournamentRoundsCompanion(
      tournamentId: tournamentId ?? this.tournamentId,
      roundNumber: roundNumber ?? this.roundNumber,
      byeParticipantId: byeParticipantId ?? this.byeParticipantId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tournamentId.present) {
      map['tournament_id'] = Variable<String>(tournamentId.value);
    }
    if (roundNumber.present) {
      map['round_number'] = Variable<int>(roundNumber.value);
    }
    if (byeParticipantId.present) {
      map['bye_participant_id'] = Variable<String>(byeParticipantId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TournamentRoundsCompanion(')
          ..write('tournamentId: $tournamentId, ')
          ..write('roundNumber: $roundNumber, ')
          ..write('byeParticipantId: $byeParticipantId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TournamentMatchesTable extends TournamentMatches
    with TableInfo<$TournamentMatchesTable, TournamentMatchRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TournamentMatchesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _matchIdMeta = const VerificationMeta(
    'matchId',
  );
  @override
  late final GeneratedColumn<String> matchId = GeneratedColumn<String>(
    'match_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roundNumberMeta = const VerificationMeta(
    'roundNumber',
  );
  @override
  late final GeneratedColumn<int> roundNumber = GeneratedColumn<int>(
    'round_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _firstParticipantIdMeta =
      const VerificationMeta('firstParticipantId');
  @override
  late final GeneratedColumn<String> firstParticipantId =
      GeneratedColumn<String>(
        'first_participant_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _secondParticipantIdMeta =
      const VerificationMeta('secondParticipantId');
  @override
  late final GeneratedColumn<String> secondParticipantId =
      GeneratedColumn<String>(
        'second_participant_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _technicalWinnerIdMeta = const VerificationMeta(
    'technicalWinnerId',
  );
  @override
  late final GeneratedColumn<String> technicalWinnerId =
      GeneratedColumn<String>(
        'technical_winner_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    tournamentId,
    matchId,
    roundNumber,
    position,
    firstParticipantId,
    secondParticipantId,
    technicalWinnerId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tournament_matches';
  @override
  VerificationContext validateIntegrity(
    Insertable<TournamentMatchRow> instance, {
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
    if (data.containsKey('match_id')) {
      context.handle(
        _matchIdMeta,
        matchId.isAcceptableOrUnknown(data['match_id']!, _matchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_matchIdMeta);
    }
    if (data.containsKey('round_number')) {
      context.handle(
        _roundNumberMeta,
        roundNumber.isAcceptableOrUnknown(
          data['round_number']!,
          _roundNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_roundNumberMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('first_participant_id')) {
      context.handle(
        _firstParticipantIdMeta,
        firstParticipantId.isAcceptableOrUnknown(
          data['first_participant_id']!,
          _firstParticipantIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstParticipantIdMeta);
    }
    if (data.containsKey('second_participant_id')) {
      context.handle(
        _secondParticipantIdMeta,
        secondParticipantId.isAcceptableOrUnknown(
          data['second_participant_id']!,
          _secondParticipantIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_secondParticipantIdMeta);
    }
    if (data.containsKey('technical_winner_id')) {
      context.handle(
        _technicalWinnerIdMeta,
        technicalWinnerId.isAcceptableOrUnknown(
          data['technical_winner_id']!,
          _technicalWinnerIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tournamentId, matchId};
  @override
  TournamentMatchRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TournamentMatchRow(
      tournamentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tournament_id'],
      )!,
      matchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}match_id'],
      )!,
      roundNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}round_number'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      firstParticipantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_participant_id'],
      )!,
      secondParticipantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}second_participant_id'],
      )!,
      technicalWinnerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}technical_winner_id'],
      ),
    );
  }

  @override
  $TournamentMatchesTable createAlias(String alias) {
    return $TournamentMatchesTable(attachedDatabase, alias);
  }
}

class TournamentMatchRow extends DataClass
    implements Insertable<TournamentMatchRow> {
  final String tournamentId;
  final String matchId;
  final int roundNumber;
  final int position;
  final String firstParticipantId;
  final String secondParticipantId;
  final String? technicalWinnerId;
  const TournamentMatchRow({
    required this.tournamentId,
    required this.matchId,
    required this.roundNumber,
    required this.position,
    required this.firstParticipantId,
    required this.secondParticipantId,
    this.technicalWinnerId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tournament_id'] = Variable<String>(tournamentId);
    map['match_id'] = Variable<String>(matchId);
    map['round_number'] = Variable<int>(roundNumber);
    map['position'] = Variable<int>(position);
    map['first_participant_id'] = Variable<String>(firstParticipantId);
    map['second_participant_id'] = Variable<String>(secondParticipantId);
    if (!nullToAbsent || technicalWinnerId != null) {
      map['technical_winner_id'] = Variable<String>(technicalWinnerId);
    }
    return map;
  }

  TournamentMatchesCompanion toCompanion(bool nullToAbsent) {
    return TournamentMatchesCompanion(
      tournamentId: Value(tournamentId),
      matchId: Value(matchId),
      roundNumber: Value(roundNumber),
      position: Value(position),
      firstParticipantId: Value(firstParticipantId),
      secondParticipantId: Value(secondParticipantId),
      technicalWinnerId: technicalWinnerId == null && nullToAbsent
          ? const Value.absent()
          : Value(technicalWinnerId),
    );
  }

  factory TournamentMatchRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TournamentMatchRow(
      tournamentId: serializer.fromJson<String>(json['tournamentId']),
      matchId: serializer.fromJson<String>(json['matchId']),
      roundNumber: serializer.fromJson<int>(json['roundNumber']),
      position: serializer.fromJson<int>(json['position']),
      firstParticipantId: serializer.fromJson<String>(
        json['firstParticipantId'],
      ),
      secondParticipantId: serializer.fromJson<String>(
        json['secondParticipantId'],
      ),
      technicalWinnerId: serializer.fromJson<String?>(
        json['technicalWinnerId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tournamentId': serializer.toJson<String>(tournamentId),
      'matchId': serializer.toJson<String>(matchId),
      'roundNumber': serializer.toJson<int>(roundNumber),
      'position': serializer.toJson<int>(position),
      'firstParticipantId': serializer.toJson<String>(firstParticipantId),
      'secondParticipantId': serializer.toJson<String>(secondParticipantId),
      'technicalWinnerId': serializer.toJson<String?>(technicalWinnerId),
    };
  }

  TournamentMatchRow copyWith({
    String? tournamentId,
    String? matchId,
    int? roundNumber,
    int? position,
    String? firstParticipantId,
    String? secondParticipantId,
    Value<String?> technicalWinnerId = const Value.absent(),
  }) => TournamentMatchRow(
    tournamentId: tournamentId ?? this.tournamentId,
    matchId: matchId ?? this.matchId,
    roundNumber: roundNumber ?? this.roundNumber,
    position: position ?? this.position,
    firstParticipantId: firstParticipantId ?? this.firstParticipantId,
    secondParticipantId: secondParticipantId ?? this.secondParticipantId,
    technicalWinnerId: technicalWinnerId.present
        ? technicalWinnerId.value
        : this.technicalWinnerId,
  );
  TournamentMatchRow copyWithCompanion(TournamentMatchesCompanion data) {
    return TournamentMatchRow(
      tournamentId: data.tournamentId.present
          ? data.tournamentId.value
          : this.tournamentId,
      matchId: data.matchId.present ? data.matchId.value : this.matchId,
      roundNumber: data.roundNumber.present
          ? data.roundNumber.value
          : this.roundNumber,
      position: data.position.present ? data.position.value : this.position,
      firstParticipantId: data.firstParticipantId.present
          ? data.firstParticipantId.value
          : this.firstParticipantId,
      secondParticipantId: data.secondParticipantId.present
          ? data.secondParticipantId.value
          : this.secondParticipantId,
      technicalWinnerId: data.technicalWinnerId.present
          ? data.technicalWinnerId.value
          : this.technicalWinnerId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TournamentMatchRow(')
          ..write('tournamentId: $tournamentId, ')
          ..write('matchId: $matchId, ')
          ..write('roundNumber: $roundNumber, ')
          ..write('position: $position, ')
          ..write('firstParticipantId: $firstParticipantId, ')
          ..write('secondParticipantId: $secondParticipantId, ')
          ..write('technicalWinnerId: $technicalWinnerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    tournamentId,
    matchId,
    roundNumber,
    position,
    firstParticipantId,
    secondParticipantId,
    technicalWinnerId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TournamentMatchRow &&
          other.tournamentId == this.tournamentId &&
          other.matchId == this.matchId &&
          other.roundNumber == this.roundNumber &&
          other.position == this.position &&
          other.firstParticipantId == this.firstParticipantId &&
          other.secondParticipantId == this.secondParticipantId &&
          other.technicalWinnerId == this.technicalWinnerId);
}

class TournamentMatchesCompanion extends UpdateCompanion<TournamentMatchRow> {
  final Value<String> tournamentId;
  final Value<String> matchId;
  final Value<int> roundNumber;
  final Value<int> position;
  final Value<String> firstParticipantId;
  final Value<String> secondParticipantId;
  final Value<String?> technicalWinnerId;
  final Value<int> rowid;
  const TournamentMatchesCompanion({
    this.tournamentId = const Value.absent(),
    this.matchId = const Value.absent(),
    this.roundNumber = const Value.absent(),
    this.position = const Value.absent(),
    this.firstParticipantId = const Value.absent(),
    this.secondParticipantId = const Value.absent(),
    this.technicalWinnerId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TournamentMatchesCompanion.insert({
    required String tournamentId,
    required String matchId,
    required int roundNumber,
    required int position,
    required String firstParticipantId,
    required String secondParticipantId,
    this.technicalWinnerId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : tournamentId = Value(tournamentId),
       matchId = Value(matchId),
       roundNumber = Value(roundNumber),
       position = Value(position),
       firstParticipantId = Value(firstParticipantId),
       secondParticipantId = Value(secondParticipantId);
  static Insertable<TournamentMatchRow> custom({
    Expression<String>? tournamentId,
    Expression<String>? matchId,
    Expression<int>? roundNumber,
    Expression<int>? position,
    Expression<String>? firstParticipantId,
    Expression<String>? secondParticipantId,
    Expression<String>? technicalWinnerId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tournamentId != null) 'tournament_id': tournamentId,
      if (matchId != null) 'match_id': matchId,
      if (roundNumber != null) 'round_number': roundNumber,
      if (position != null) 'position': position,
      if (firstParticipantId != null)
        'first_participant_id': firstParticipantId,
      if (secondParticipantId != null)
        'second_participant_id': secondParticipantId,
      if (technicalWinnerId != null) 'technical_winner_id': technicalWinnerId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TournamentMatchesCompanion copyWith({
    Value<String>? tournamentId,
    Value<String>? matchId,
    Value<int>? roundNumber,
    Value<int>? position,
    Value<String>? firstParticipantId,
    Value<String>? secondParticipantId,
    Value<String?>? technicalWinnerId,
    Value<int>? rowid,
  }) {
    return TournamentMatchesCompanion(
      tournamentId: tournamentId ?? this.tournamentId,
      matchId: matchId ?? this.matchId,
      roundNumber: roundNumber ?? this.roundNumber,
      position: position ?? this.position,
      firstParticipantId: firstParticipantId ?? this.firstParticipantId,
      secondParticipantId: secondParticipantId ?? this.secondParticipantId,
      technicalWinnerId: technicalWinnerId ?? this.technicalWinnerId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tournamentId.present) {
      map['tournament_id'] = Variable<String>(tournamentId.value);
    }
    if (matchId.present) {
      map['match_id'] = Variable<String>(matchId.value);
    }
    if (roundNumber.present) {
      map['round_number'] = Variable<int>(roundNumber.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (firstParticipantId.present) {
      map['first_participant_id'] = Variable<String>(firstParticipantId.value);
    }
    if (secondParticipantId.present) {
      map['second_participant_id'] = Variable<String>(
        secondParticipantId.value,
      );
    }
    if (technicalWinnerId.present) {
      map['technical_winner_id'] = Variable<String>(technicalWinnerId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TournamentMatchesCompanion(')
          ..write('tournamentId: $tournamentId, ')
          ..write('matchId: $matchId, ')
          ..write('roundNumber: $roundNumber, ')
          ..write('position: $position, ')
          ..write('firstParticipantId: $firstParticipantId, ')
          ..write('secondParticipantId: $secondParticipantId, ')
          ..write('technicalWinnerId: $technicalWinnerId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MatchBoutsTable extends MatchBouts
    with TableInfo<$MatchBoutsTable, MatchBoutRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MatchBoutsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _matchIdMeta = const VerificationMeta(
    'matchId',
  );
  @override
  late final GeneratedColumn<String> matchId = GeneratedColumn<String>(
    'match_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _boutNumberMeta = const VerificationMeta(
    'boutNumber',
  );
  @override
  late final GeneratedColumn<int> boutNumber = GeneratedColumn<int>(
    'bout_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _winnerIdMeta = const VerificationMeta(
    'winnerId',
  );
  @override
  late final GeneratedColumn<String> winnerId = GeneratedColumn<String>(
    'winner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    tournamentId,
    matchId,
    boutNumber,
    winnerId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'match_bouts';
  @override
  VerificationContext validateIntegrity(
    Insertable<MatchBoutRow> instance, {
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
    if (data.containsKey('match_id')) {
      context.handle(
        _matchIdMeta,
        matchId.isAcceptableOrUnknown(data['match_id']!, _matchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_matchIdMeta);
    }
    if (data.containsKey('bout_number')) {
      context.handle(
        _boutNumberMeta,
        boutNumber.isAcceptableOrUnknown(data['bout_number']!, _boutNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_boutNumberMeta);
    }
    if (data.containsKey('winner_id')) {
      context.handle(
        _winnerIdMeta,
        winnerId.isAcceptableOrUnknown(data['winner_id']!, _winnerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_winnerIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tournamentId, matchId, boutNumber};
  @override
  MatchBoutRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MatchBoutRow(
      tournamentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tournament_id'],
      )!,
      matchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}match_id'],
      )!,
      boutNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bout_number'],
      )!,
      winnerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}winner_id'],
      )!,
    );
  }

  @override
  $MatchBoutsTable createAlias(String alias) {
    return $MatchBoutsTable(attachedDatabase, alias);
  }
}

class MatchBoutRow extends DataClass implements Insertable<MatchBoutRow> {
  final String tournamentId;
  final String matchId;
  final int boutNumber;
  final String winnerId;
  const MatchBoutRow({
    required this.tournamentId,
    required this.matchId,
    required this.boutNumber,
    required this.winnerId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tournament_id'] = Variable<String>(tournamentId);
    map['match_id'] = Variable<String>(matchId);
    map['bout_number'] = Variable<int>(boutNumber);
    map['winner_id'] = Variable<String>(winnerId);
    return map;
  }

  MatchBoutsCompanion toCompanion(bool nullToAbsent) {
    return MatchBoutsCompanion(
      tournamentId: Value(tournamentId),
      matchId: Value(matchId),
      boutNumber: Value(boutNumber),
      winnerId: Value(winnerId),
    );
  }

  factory MatchBoutRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MatchBoutRow(
      tournamentId: serializer.fromJson<String>(json['tournamentId']),
      matchId: serializer.fromJson<String>(json['matchId']),
      boutNumber: serializer.fromJson<int>(json['boutNumber']),
      winnerId: serializer.fromJson<String>(json['winnerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tournamentId': serializer.toJson<String>(tournamentId),
      'matchId': serializer.toJson<String>(matchId),
      'boutNumber': serializer.toJson<int>(boutNumber),
      'winnerId': serializer.toJson<String>(winnerId),
    };
  }

  MatchBoutRow copyWith({
    String? tournamentId,
    String? matchId,
    int? boutNumber,
    String? winnerId,
  }) => MatchBoutRow(
    tournamentId: tournamentId ?? this.tournamentId,
    matchId: matchId ?? this.matchId,
    boutNumber: boutNumber ?? this.boutNumber,
    winnerId: winnerId ?? this.winnerId,
  );
  MatchBoutRow copyWithCompanion(MatchBoutsCompanion data) {
    return MatchBoutRow(
      tournamentId: data.tournamentId.present
          ? data.tournamentId.value
          : this.tournamentId,
      matchId: data.matchId.present ? data.matchId.value : this.matchId,
      boutNumber: data.boutNumber.present
          ? data.boutNumber.value
          : this.boutNumber,
      winnerId: data.winnerId.present ? data.winnerId.value : this.winnerId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MatchBoutRow(')
          ..write('tournamentId: $tournamentId, ')
          ..write('matchId: $matchId, ')
          ..write('boutNumber: $boutNumber, ')
          ..write('winnerId: $winnerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tournamentId, matchId, boutNumber, winnerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MatchBoutRow &&
          other.tournamentId == this.tournamentId &&
          other.matchId == this.matchId &&
          other.boutNumber == this.boutNumber &&
          other.winnerId == this.winnerId);
}

class MatchBoutsCompanion extends UpdateCompanion<MatchBoutRow> {
  final Value<String> tournamentId;
  final Value<String> matchId;
  final Value<int> boutNumber;
  final Value<String> winnerId;
  final Value<int> rowid;
  const MatchBoutsCompanion({
    this.tournamentId = const Value.absent(),
    this.matchId = const Value.absent(),
    this.boutNumber = const Value.absent(),
    this.winnerId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MatchBoutsCompanion.insert({
    required String tournamentId,
    required String matchId,
    required int boutNumber,
    required String winnerId,
    this.rowid = const Value.absent(),
  }) : tournamentId = Value(tournamentId),
       matchId = Value(matchId),
       boutNumber = Value(boutNumber),
       winnerId = Value(winnerId);
  static Insertable<MatchBoutRow> custom({
    Expression<String>? tournamentId,
    Expression<String>? matchId,
    Expression<int>? boutNumber,
    Expression<String>? winnerId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tournamentId != null) 'tournament_id': tournamentId,
      if (matchId != null) 'match_id': matchId,
      if (boutNumber != null) 'bout_number': boutNumber,
      if (winnerId != null) 'winner_id': winnerId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MatchBoutsCompanion copyWith({
    Value<String>? tournamentId,
    Value<String>? matchId,
    Value<int>? boutNumber,
    Value<String>? winnerId,
    Value<int>? rowid,
  }) {
    return MatchBoutsCompanion(
      tournamentId: tournamentId ?? this.tournamentId,
      matchId: matchId ?? this.matchId,
      boutNumber: boutNumber ?? this.boutNumber,
      winnerId: winnerId ?? this.winnerId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tournamentId.present) {
      map['tournament_id'] = Variable<String>(tournamentId.value);
    }
    if (matchId.present) {
      map['match_id'] = Variable<String>(matchId.value);
    }
    if (boutNumber.present) {
      map['bout_number'] = Variable<int>(boutNumber.value);
    }
    if (winnerId.present) {
      map['winner_id'] = Variable<String>(winnerId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MatchBoutsCompanion(')
          ..write('tournamentId: $tournamentId, ')
          ..write('matchId: $matchId, ')
          ..write('boutNumber: $boutNumber, ')
          ..write('winnerId: $winnerId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MatchUpdatesTable extends MatchUpdates
    with TableInfo<$MatchUpdatesTable, MatchUpdateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MatchUpdatesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _matchIdMeta = const VerificationMeta(
    'matchId',
  );
  @override
  late final GeneratedColumn<String> matchId = GeneratedColumn<String>(
    'match_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updateIdMeta = const VerificationMeta(
    'updateId',
  );
  @override
  late final GeneratedColumn<String> updateId = GeneratedColumn<String>(
    'update_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [tournamentId, matchId, updateId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'match_updates';
  @override
  VerificationContext validateIntegrity(
    Insertable<MatchUpdateRow> instance, {
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
    if (data.containsKey('match_id')) {
      context.handle(
        _matchIdMeta,
        matchId.isAcceptableOrUnknown(data['match_id']!, _matchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_matchIdMeta);
    }
    if (data.containsKey('update_id')) {
      context.handle(
        _updateIdMeta,
        updateId.isAcceptableOrUnknown(data['update_id']!, _updateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_updateIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tournamentId, matchId, updateId};
  @override
  MatchUpdateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MatchUpdateRow(
      tournamentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tournament_id'],
      )!,
      matchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}match_id'],
      )!,
      updateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}update_id'],
      )!,
    );
  }

  @override
  $MatchUpdatesTable createAlias(String alias) {
    return $MatchUpdatesTable(attachedDatabase, alias);
  }
}

class MatchUpdateRow extends DataClass implements Insertable<MatchUpdateRow> {
  final String tournamentId;
  final String matchId;
  final String updateId;
  const MatchUpdateRow({
    required this.tournamentId,
    required this.matchId,
    required this.updateId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tournament_id'] = Variable<String>(tournamentId);
    map['match_id'] = Variable<String>(matchId);
    map['update_id'] = Variable<String>(updateId);
    return map;
  }

  MatchUpdatesCompanion toCompanion(bool nullToAbsent) {
    return MatchUpdatesCompanion(
      tournamentId: Value(tournamentId),
      matchId: Value(matchId),
      updateId: Value(updateId),
    );
  }

  factory MatchUpdateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MatchUpdateRow(
      tournamentId: serializer.fromJson<String>(json['tournamentId']),
      matchId: serializer.fromJson<String>(json['matchId']),
      updateId: serializer.fromJson<String>(json['updateId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tournamentId': serializer.toJson<String>(tournamentId),
      'matchId': serializer.toJson<String>(matchId),
      'updateId': serializer.toJson<String>(updateId),
    };
  }

  MatchUpdateRow copyWith({
    String? tournamentId,
    String? matchId,
    String? updateId,
  }) => MatchUpdateRow(
    tournamentId: tournamentId ?? this.tournamentId,
    matchId: matchId ?? this.matchId,
    updateId: updateId ?? this.updateId,
  );
  MatchUpdateRow copyWithCompanion(MatchUpdatesCompanion data) {
    return MatchUpdateRow(
      tournamentId: data.tournamentId.present
          ? data.tournamentId.value
          : this.tournamentId,
      matchId: data.matchId.present ? data.matchId.value : this.matchId,
      updateId: data.updateId.present ? data.updateId.value : this.updateId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MatchUpdateRow(')
          ..write('tournamentId: $tournamentId, ')
          ..write('matchId: $matchId, ')
          ..write('updateId: $updateId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tournamentId, matchId, updateId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MatchUpdateRow &&
          other.tournamentId == this.tournamentId &&
          other.matchId == this.matchId &&
          other.updateId == this.updateId);
}

class MatchUpdatesCompanion extends UpdateCompanion<MatchUpdateRow> {
  final Value<String> tournamentId;
  final Value<String> matchId;
  final Value<String> updateId;
  final Value<int> rowid;
  const MatchUpdatesCompanion({
    this.tournamentId = const Value.absent(),
    this.matchId = const Value.absent(),
    this.updateId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MatchUpdatesCompanion.insert({
    required String tournamentId,
    required String matchId,
    required String updateId,
    this.rowid = const Value.absent(),
  }) : tournamentId = Value(tournamentId),
       matchId = Value(matchId),
       updateId = Value(updateId);
  static Insertable<MatchUpdateRow> custom({
    Expression<String>? tournamentId,
    Expression<String>? matchId,
    Expression<String>? updateId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tournamentId != null) 'tournament_id': tournamentId,
      if (matchId != null) 'match_id': matchId,
      if (updateId != null) 'update_id': updateId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MatchUpdatesCompanion copyWith({
    Value<String>? tournamentId,
    Value<String>? matchId,
    Value<String>? updateId,
    Value<int>? rowid,
  }) {
    return MatchUpdatesCompanion(
      tournamentId: tournamentId ?? this.tournamentId,
      matchId: matchId ?? this.matchId,
      updateId: updateId ?? this.updateId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tournamentId.present) {
      map['tournament_id'] = Variable<String>(tournamentId.value);
    }
    if (matchId.present) {
      map['match_id'] = Variable<String>(matchId.value);
    }
    if (updateId.present) {
      map['update_id'] = Variable<String>(updateId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MatchUpdatesCompanion(')
          ..write('tournamentId: $tournamentId, ')
          ..write('matchId: $matchId, ')
          ..write('updateId: $updateId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FinishedTournamentsTable extends FinishedTournaments
    with TableInfo<$FinishedTournamentsTable, FinishedTournamentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinishedTournamentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _rulesetIdMeta = const VerificationMeta(
    'rulesetId',
  );
  @override
  late final GeneratedColumn<String> rulesetId = GeneratedColumn<String>(
    'ruleset_id',
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
  static const VerificationMeta _championIdMeta = const VerificationMeta(
    'championId',
  );
  @override
  late final GeneratedColumn<String> championId = GeneratedColumn<String>(
    'champion_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    tournamentId,
    rulesetId,
    rulesetVersion,
    championId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'finished_tournaments';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinishedTournamentRow> instance, {
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
    if (data.containsKey('ruleset_id')) {
      context.handle(
        _rulesetIdMeta,
        rulesetId.isAcceptableOrUnknown(data['ruleset_id']!, _rulesetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rulesetIdMeta);
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
    if (data.containsKey('champion_id')) {
      context.handle(
        _championIdMeta,
        championId.isAcceptableOrUnknown(data['champion_id']!, _championIdMeta),
      );
    } else if (isInserting) {
      context.missing(_championIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tournamentId};
  @override
  FinishedTournamentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinishedTournamentRow(
      tournamentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tournament_id'],
      )!,
      rulesetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ruleset_id'],
      )!,
      rulesetVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ruleset_version'],
      )!,
      championId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}champion_id'],
      )!,
    );
  }

  @override
  $FinishedTournamentsTable createAlias(String alias) {
    return $FinishedTournamentsTable(attachedDatabase, alias);
  }
}

class FinishedTournamentRow extends DataClass
    implements Insertable<FinishedTournamentRow> {
  final String tournamentId;
  final String rulesetId;
  final int rulesetVersion;
  final String championId;
  const FinishedTournamentRow({
    required this.tournamentId,
    required this.rulesetId,
    required this.rulesetVersion,
    required this.championId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tournament_id'] = Variable<String>(tournamentId);
    map['ruleset_id'] = Variable<String>(rulesetId);
    map['ruleset_version'] = Variable<int>(rulesetVersion);
    map['champion_id'] = Variable<String>(championId);
    return map;
  }

  FinishedTournamentsCompanion toCompanion(bool nullToAbsent) {
    return FinishedTournamentsCompanion(
      tournamentId: Value(tournamentId),
      rulesetId: Value(rulesetId),
      rulesetVersion: Value(rulesetVersion),
      championId: Value(championId),
    );
  }

  factory FinishedTournamentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinishedTournamentRow(
      tournamentId: serializer.fromJson<String>(json['tournamentId']),
      rulesetId: serializer.fromJson<String>(json['rulesetId']),
      rulesetVersion: serializer.fromJson<int>(json['rulesetVersion']),
      championId: serializer.fromJson<String>(json['championId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tournamentId': serializer.toJson<String>(tournamentId),
      'rulesetId': serializer.toJson<String>(rulesetId),
      'rulesetVersion': serializer.toJson<int>(rulesetVersion),
      'championId': serializer.toJson<String>(championId),
    };
  }

  FinishedTournamentRow copyWith({
    String? tournamentId,
    String? rulesetId,
    int? rulesetVersion,
    String? championId,
  }) => FinishedTournamentRow(
    tournamentId: tournamentId ?? this.tournamentId,
    rulesetId: rulesetId ?? this.rulesetId,
    rulesetVersion: rulesetVersion ?? this.rulesetVersion,
    championId: championId ?? this.championId,
  );
  FinishedTournamentRow copyWithCompanion(FinishedTournamentsCompanion data) {
    return FinishedTournamentRow(
      tournamentId: data.tournamentId.present
          ? data.tournamentId.value
          : this.tournamentId,
      rulesetId: data.rulesetId.present ? data.rulesetId.value : this.rulesetId,
      rulesetVersion: data.rulesetVersion.present
          ? data.rulesetVersion.value
          : this.rulesetVersion,
      championId: data.championId.present
          ? data.championId.value
          : this.championId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinishedTournamentRow(')
          ..write('tournamentId: $tournamentId, ')
          ..write('rulesetId: $rulesetId, ')
          ..write('rulesetVersion: $rulesetVersion, ')
          ..write('championId: $championId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(tournamentId, rulesetId, rulesetVersion, championId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinishedTournamentRow &&
          other.tournamentId == this.tournamentId &&
          other.rulesetId == this.rulesetId &&
          other.rulesetVersion == this.rulesetVersion &&
          other.championId == this.championId);
}

class FinishedTournamentsCompanion
    extends UpdateCompanion<FinishedTournamentRow> {
  final Value<String> tournamentId;
  final Value<String> rulesetId;
  final Value<int> rulesetVersion;
  final Value<String> championId;
  final Value<int> rowid;
  const FinishedTournamentsCompanion({
    this.tournamentId = const Value.absent(),
    this.rulesetId = const Value.absent(),
    this.rulesetVersion = const Value.absent(),
    this.championId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FinishedTournamentsCompanion.insert({
    required String tournamentId,
    required String rulesetId,
    required int rulesetVersion,
    required String championId,
    this.rowid = const Value.absent(),
  }) : tournamentId = Value(tournamentId),
       rulesetId = Value(rulesetId),
       rulesetVersion = Value(rulesetVersion),
       championId = Value(championId);
  static Insertable<FinishedTournamentRow> custom({
    Expression<String>? tournamentId,
    Expression<String>? rulesetId,
    Expression<int>? rulesetVersion,
    Expression<String>? championId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tournamentId != null) 'tournament_id': tournamentId,
      if (rulesetId != null) 'ruleset_id': rulesetId,
      if (rulesetVersion != null) 'ruleset_version': rulesetVersion,
      if (championId != null) 'champion_id': championId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FinishedTournamentsCompanion copyWith({
    Value<String>? tournamentId,
    Value<String>? rulesetId,
    Value<int>? rulesetVersion,
    Value<String>? championId,
    Value<int>? rowid,
  }) {
    return FinishedTournamentsCompanion(
      tournamentId: tournamentId ?? this.tournamentId,
      rulesetId: rulesetId ?? this.rulesetId,
      rulesetVersion: rulesetVersion ?? this.rulesetVersion,
      championId: championId ?? this.championId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tournamentId.present) {
      map['tournament_id'] = Variable<String>(tournamentId.value);
    }
    if (rulesetId.present) {
      map['ruleset_id'] = Variable<String>(rulesetId.value);
    }
    if (rulesetVersion.present) {
      map['ruleset_version'] = Variable<int>(rulesetVersion.value);
    }
    if (championId.present) {
      map['champion_id'] = Variable<String>(championId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinishedTournamentsCompanion(')
          ..write('tournamentId: $tournamentId, ')
          ..write('rulesetId: $rulesetId, ')
          ..write('rulesetVersion: $rulesetVersion, ')
          ..write('championId: $championId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FinishedStandingsTable extends FinishedStandings
    with TableInfo<$FinishedStandingsTable, FinishedStandingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinishedStandingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _matchesPlayedMeta = const VerificationMeta(
    'matchesPlayed',
  );
  @override
  late final GeneratedColumn<int> matchesPlayed = GeneratedColumn<int>(
    'matches_played',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _winsMeta = const VerificationMeta('wins');
  @override
  late final GeneratedColumn<int> wins = GeneratedColumn<int>(
    'wins',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lossesMeta = const VerificationMeta('losses');
  @override
  late final GeneratedColumn<int> losses = GeneratedColumn<int>(
    'losses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gamesWonMeta = const VerificationMeta(
    'gamesWon',
  );
  @override
  late final GeneratedColumn<int> gamesWon = GeneratedColumn<int>(
    'games_won',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gamesLostMeta = const VerificationMeta(
    'gamesLost',
  );
  @override
  late final GeneratedColumn<int> gamesLost = GeneratedColumn<int>(
    'games_lost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    tournamentId,
    participantId,
    position,
    matchesPlayed,
    wins,
    losses,
    gamesWon,
    gamesLost,
    points,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'finished_standings';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinishedStandingRow> instance, {
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
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('matches_played')) {
      context.handle(
        _matchesPlayedMeta,
        matchesPlayed.isAcceptableOrUnknown(
          data['matches_played']!,
          _matchesPlayedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_matchesPlayedMeta);
    }
    if (data.containsKey('wins')) {
      context.handle(
        _winsMeta,
        wins.isAcceptableOrUnknown(data['wins']!, _winsMeta),
      );
    } else if (isInserting) {
      context.missing(_winsMeta);
    }
    if (data.containsKey('losses')) {
      context.handle(
        _lossesMeta,
        losses.isAcceptableOrUnknown(data['losses']!, _lossesMeta),
      );
    } else if (isInserting) {
      context.missing(_lossesMeta);
    }
    if (data.containsKey('games_won')) {
      context.handle(
        _gamesWonMeta,
        gamesWon.isAcceptableOrUnknown(data['games_won']!, _gamesWonMeta),
      );
    } else if (isInserting) {
      context.missing(_gamesWonMeta);
    }
    if (data.containsKey('games_lost')) {
      context.handle(
        _gamesLostMeta,
        gamesLost.isAcceptableOrUnknown(data['games_lost']!, _gamesLostMeta),
      );
    } else if (isInserting) {
      context.missing(_gamesLostMeta);
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    } else if (isInserting) {
      context.missing(_pointsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tournamentId, participantId};
  @override
  FinishedStandingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinishedStandingRow(
      tournamentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tournament_id'],
      )!,
      participantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}participant_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      matchesPlayed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}matches_played'],
      )!,
      wins: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wins'],
      )!,
      losses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}losses'],
      )!,
      gamesWon: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}games_won'],
      )!,
      gamesLost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}games_lost'],
      )!,
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points'],
      )!,
    );
  }

  @override
  $FinishedStandingsTable createAlias(String alias) {
    return $FinishedStandingsTable(attachedDatabase, alias);
  }
}

class FinishedStandingRow extends DataClass
    implements Insertable<FinishedStandingRow> {
  final String tournamentId;
  final String participantId;
  final int position;
  final int matchesPlayed;
  final int wins;
  final int losses;
  final int gamesWon;
  final int gamesLost;
  final int points;
  const FinishedStandingRow({
    required this.tournamentId,
    required this.participantId,
    required this.position,
    required this.matchesPlayed,
    required this.wins,
    required this.losses,
    required this.gamesWon,
    required this.gamesLost,
    required this.points,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tournament_id'] = Variable<String>(tournamentId);
    map['participant_id'] = Variable<String>(participantId);
    map['position'] = Variable<int>(position);
    map['matches_played'] = Variable<int>(matchesPlayed);
    map['wins'] = Variable<int>(wins);
    map['losses'] = Variable<int>(losses);
    map['games_won'] = Variable<int>(gamesWon);
    map['games_lost'] = Variable<int>(gamesLost);
    map['points'] = Variable<int>(points);
    return map;
  }

  FinishedStandingsCompanion toCompanion(bool nullToAbsent) {
    return FinishedStandingsCompanion(
      tournamentId: Value(tournamentId),
      participantId: Value(participantId),
      position: Value(position),
      matchesPlayed: Value(matchesPlayed),
      wins: Value(wins),
      losses: Value(losses),
      gamesWon: Value(gamesWon),
      gamesLost: Value(gamesLost),
      points: Value(points),
    );
  }

  factory FinishedStandingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinishedStandingRow(
      tournamentId: serializer.fromJson<String>(json['tournamentId']),
      participantId: serializer.fromJson<String>(json['participantId']),
      position: serializer.fromJson<int>(json['position']),
      matchesPlayed: serializer.fromJson<int>(json['matchesPlayed']),
      wins: serializer.fromJson<int>(json['wins']),
      losses: serializer.fromJson<int>(json['losses']),
      gamesWon: serializer.fromJson<int>(json['gamesWon']),
      gamesLost: serializer.fromJson<int>(json['gamesLost']),
      points: serializer.fromJson<int>(json['points']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tournamentId': serializer.toJson<String>(tournamentId),
      'participantId': serializer.toJson<String>(participantId),
      'position': serializer.toJson<int>(position),
      'matchesPlayed': serializer.toJson<int>(matchesPlayed),
      'wins': serializer.toJson<int>(wins),
      'losses': serializer.toJson<int>(losses),
      'gamesWon': serializer.toJson<int>(gamesWon),
      'gamesLost': serializer.toJson<int>(gamesLost),
      'points': serializer.toJson<int>(points),
    };
  }

  FinishedStandingRow copyWith({
    String? tournamentId,
    String? participantId,
    int? position,
    int? matchesPlayed,
    int? wins,
    int? losses,
    int? gamesWon,
    int? gamesLost,
    int? points,
  }) => FinishedStandingRow(
    tournamentId: tournamentId ?? this.tournamentId,
    participantId: participantId ?? this.participantId,
    position: position ?? this.position,
    matchesPlayed: matchesPlayed ?? this.matchesPlayed,
    wins: wins ?? this.wins,
    losses: losses ?? this.losses,
    gamesWon: gamesWon ?? this.gamesWon,
    gamesLost: gamesLost ?? this.gamesLost,
    points: points ?? this.points,
  );
  FinishedStandingRow copyWithCompanion(FinishedStandingsCompanion data) {
    return FinishedStandingRow(
      tournamentId: data.tournamentId.present
          ? data.tournamentId.value
          : this.tournamentId,
      participantId: data.participantId.present
          ? data.participantId.value
          : this.participantId,
      position: data.position.present ? data.position.value : this.position,
      matchesPlayed: data.matchesPlayed.present
          ? data.matchesPlayed.value
          : this.matchesPlayed,
      wins: data.wins.present ? data.wins.value : this.wins,
      losses: data.losses.present ? data.losses.value : this.losses,
      gamesWon: data.gamesWon.present ? data.gamesWon.value : this.gamesWon,
      gamesLost: data.gamesLost.present ? data.gamesLost.value : this.gamesLost,
      points: data.points.present ? data.points.value : this.points,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinishedStandingRow(')
          ..write('tournamentId: $tournamentId, ')
          ..write('participantId: $participantId, ')
          ..write('position: $position, ')
          ..write('matchesPlayed: $matchesPlayed, ')
          ..write('wins: $wins, ')
          ..write('losses: $losses, ')
          ..write('gamesWon: $gamesWon, ')
          ..write('gamesLost: $gamesLost, ')
          ..write('points: $points')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    tournamentId,
    participantId,
    position,
    matchesPlayed,
    wins,
    losses,
    gamesWon,
    gamesLost,
    points,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinishedStandingRow &&
          other.tournamentId == this.tournamentId &&
          other.participantId == this.participantId &&
          other.position == this.position &&
          other.matchesPlayed == this.matchesPlayed &&
          other.wins == this.wins &&
          other.losses == this.losses &&
          other.gamesWon == this.gamesWon &&
          other.gamesLost == this.gamesLost &&
          other.points == this.points);
}

class FinishedStandingsCompanion extends UpdateCompanion<FinishedStandingRow> {
  final Value<String> tournamentId;
  final Value<String> participantId;
  final Value<int> position;
  final Value<int> matchesPlayed;
  final Value<int> wins;
  final Value<int> losses;
  final Value<int> gamesWon;
  final Value<int> gamesLost;
  final Value<int> points;
  final Value<int> rowid;
  const FinishedStandingsCompanion({
    this.tournamentId = const Value.absent(),
    this.participantId = const Value.absent(),
    this.position = const Value.absent(),
    this.matchesPlayed = const Value.absent(),
    this.wins = const Value.absent(),
    this.losses = const Value.absent(),
    this.gamesWon = const Value.absent(),
    this.gamesLost = const Value.absent(),
    this.points = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FinishedStandingsCompanion.insert({
    required String tournamentId,
    required String participantId,
    required int position,
    required int matchesPlayed,
    required int wins,
    required int losses,
    required int gamesWon,
    required int gamesLost,
    required int points,
    this.rowid = const Value.absent(),
  }) : tournamentId = Value(tournamentId),
       participantId = Value(participantId),
       position = Value(position),
       matchesPlayed = Value(matchesPlayed),
       wins = Value(wins),
       losses = Value(losses),
       gamesWon = Value(gamesWon),
       gamesLost = Value(gamesLost),
       points = Value(points);
  static Insertable<FinishedStandingRow> custom({
    Expression<String>? tournamentId,
    Expression<String>? participantId,
    Expression<int>? position,
    Expression<int>? matchesPlayed,
    Expression<int>? wins,
    Expression<int>? losses,
    Expression<int>? gamesWon,
    Expression<int>? gamesLost,
    Expression<int>? points,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tournamentId != null) 'tournament_id': tournamentId,
      if (participantId != null) 'participant_id': participantId,
      if (position != null) 'position': position,
      if (matchesPlayed != null) 'matches_played': matchesPlayed,
      if (wins != null) 'wins': wins,
      if (losses != null) 'losses': losses,
      if (gamesWon != null) 'games_won': gamesWon,
      if (gamesLost != null) 'games_lost': gamesLost,
      if (points != null) 'points': points,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FinishedStandingsCompanion copyWith({
    Value<String>? tournamentId,
    Value<String>? participantId,
    Value<int>? position,
    Value<int>? matchesPlayed,
    Value<int>? wins,
    Value<int>? losses,
    Value<int>? gamesWon,
    Value<int>? gamesLost,
    Value<int>? points,
    Value<int>? rowid,
  }) {
    return FinishedStandingsCompanion(
      tournamentId: tournamentId ?? this.tournamentId,
      participantId: participantId ?? this.participantId,
      position: position ?? this.position,
      matchesPlayed: matchesPlayed ?? this.matchesPlayed,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      gamesWon: gamesWon ?? this.gamesWon,
      gamesLost: gamesLost ?? this.gamesLost,
      points: points ?? this.points,
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
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (matchesPlayed.present) {
      map['matches_played'] = Variable<int>(matchesPlayed.value);
    }
    if (wins.present) {
      map['wins'] = Variable<int>(wins.value);
    }
    if (losses.present) {
      map['losses'] = Variable<int>(losses.value);
    }
    if (gamesWon.present) {
      map['games_won'] = Variable<int>(gamesWon.value);
    }
    if (gamesLost.present) {
      map['games_lost'] = Variable<int>(gamesLost.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinishedStandingsCompanion(')
          ..write('tournamentId: $tournamentId, ')
          ..write('participantId: $participantId, ')
          ..write('position: $position, ')
          ..write('matchesPlayed: $matchesPlayed, ')
          ..write('wins: $wins, ')
          ..write('losses: $losses, ')
          ..write('gamesWon: $gamesWon, ')
          ..write('gamesLost: $gamesLost, ')
          ..write('points: $points, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TournamentHistoryRecordsTable extends TournamentHistoryRecords
    with TableInfo<$TournamentHistoryRecordsTable, TournamentHistoryRecordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TournamentHistoryRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _completionOrderMeta = const VerificationMeta(
    'completionOrder',
  );
  @override
  late final GeneratedColumn<int> completionOrder = GeneratedColumn<int>(
    'completion_order',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _championNicknameMeta = const VerificationMeta(
    'championNickname',
  );
  @override
  late final GeneratedColumn<String> championNickname = GeneratedColumn<String>(
    'champion_nickname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _participantCountMeta = const VerificationMeta(
    'participantCount',
  );
  @override
  late final GeneratedColumn<int> participantCount = GeneratedColumn<int>(
    'participant_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rulesetIdMeta = const VerificationMeta(
    'rulesetId',
  );
  @override
  late final GeneratedColumn<String> rulesetId = GeneratedColumn<String>(
    'ruleset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formatMeta = const VerificationMeta('format');
  @override
  late final GeneratedColumn<String> format = GeneratedColumn<String>(
    'format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('roundRobin'),
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
  static const VerificationMeta _snapshotPayloadMeta = const VerificationMeta(
    'snapshotPayload',
  );
  @override
  late final GeneratedColumn<String> snapshotPayload = GeneratedColumn<String>(
    'snapshot_payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    completionOrder,
    tournamentId,
    name,
    championNickname,
    participantCount,
    rulesetId,
    format,
    rulesetVersion,
    snapshotPayload,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tournament_history_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<TournamentHistoryRecordRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('completion_order')) {
      context.handle(
        _completionOrderMeta,
        completionOrder.isAcceptableOrUnknown(
          data['completion_order']!,
          _completionOrderMeta,
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
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('champion_nickname')) {
      context.handle(
        _championNicknameMeta,
        championNickname.isAcceptableOrUnknown(
          data['champion_nickname']!,
          _championNicknameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_championNicknameMeta);
    }
    if (data.containsKey('participant_count')) {
      context.handle(
        _participantCountMeta,
        participantCount.isAcceptableOrUnknown(
          data['participant_count']!,
          _participantCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_participantCountMeta);
    }
    if (data.containsKey('ruleset_id')) {
      context.handle(
        _rulesetIdMeta,
        rulesetId.isAcceptableOrUnknown(data['ruleset_id']!, _rulesetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rulesetIdMeta);
    }
    if (data.containsKey('format')) {
      context.handle(
        _formatMeta,
        format.isAcceptableOrUnknown(data['format']!, _formatMeta),
      );
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
    if (data.containsKey('snapshot_payload')) {
      context.handle(
        _snapshotPayloadMeta,
        snapshotPayload.isAcceptableOrUnknown(
          data['snapshot_payload']!,
          _snapshotPayloadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_snapshotPayloadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {completionOrder};
  @override
  TournamentHistoryRecordRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TournamentHistoryRecordRow(
      completionOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completion_order'],
      )!,
      tournamentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tournament_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      championNickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}champion_nickname'],
      )!,
      participantCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}participant_count'],
      )!,
      rulesetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ruleset_id'],
      )!,
      format: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}format'],
      )!,
      rulesetVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ruleset_version'],
      )!,
      snapshotPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}snapshot_payload'],
      )!,
    );
  }

  @override
  $TournamentHistoryRecordsTable createAlias(String alias) {
    return $TournamentHistoryRecordsTable(attachedDatabase, alias);
  }
}

class TournamentHistoryRecordRow extends DataClass
    implements Insertable<TournamentHistoryRecordRow> {
  final int completionOrder;
  final String tournamentId;
  final String name;
  final String championNickname;
  final int participantCount;
  final String rulesetId;
  final String format;
  final int rulesetVersion;
  final String snapshotPayload;
  const TournamentHistoryRecordRow({
    required this.completionOrder,
    required this.tournamentId,
    required this.name,
    required this.championNickname,
    required this.participantCount,
    required this.rulesetId,
    required this.format,
    required this.rulesetVersion,
    required this.snapshotPayload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['completion_order'] = Variable<int>(completionOrder);
    map['tournament_id'] = Variable<String>(tournamentId);
    map['name'] = Variable<String>(name);
    map['champion_nickname'] = Variable<String>(championNickname);
    map['participant_count'] = Variable<int>(participantCount);
    map['ruleset_id'] = Variable<String>(rulesetId);
    map['format'] = Variable<String>(format);
    map['ruleset_version'] = Variable<int>(rulesetVersion);
    map['snapshot_payload'] = Variable<String>(snapshotPayload);
    return map;
  }

  TournamentHistoryRecordsCompanion toCompanion(bool nullToAbsent) {
    return TournamentHistoryRecordsCompanion(
      completionOrder: Value(completionOrder),
      tournamentId: Value(tournamentId),
      name: Value(name),
      championNickname: Value(championNickname),
      participantCount: Value(participantCount),
      rulesetId: Value(rulesetId),
      format: Value(format),
      rulesetVersion: Value(rulesetVersion),
      snapshotPayload: Value(snapshotPayload),
    );
  }

  factory TournamentHistoryRecordRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TournamentHistoryRecordRow(
      completionOrder: serializer.fromJson<int>(json['completionOrder']),
      tournamentId: serializer.fromJson<String>(json['tournamentId']),
      name: serializer.fromJson<String>(json['name']),
      championNickname: serializer.fromJson<String>(json['championNickname']),
      participantCount: serializer.fromJson<int>(json['participantCount']),
      rulesetId: serializer.fromJson<String>(json['rulesetId']),
      format: serializer.fromJson<String>(json['format']),
      rulesetVersion: serializer.fromJson<int>(json['rulesetVersion']),
      snapshotPayload: serializer.fromJson<String>(json['snapshotPayload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'completionOrder': serializer.toJson<int>(completionOrder),
      'tournamentId': serializer.toJson<String>(tournamentId),
      'name': serializer.toJson<String>(name),
      'championNickname': serializer.toJson<String>(championNickname),
      'participantCount': serializer.toJson<int>(participantCount),
      'rulesetId': serializer.toJson<String>(rulesetId),
      'format': serializer.toJson<String>(format),
      'rulesetVersion': serializer.toJson<int>(rulesetVersion),
      'snapshotPayload': serializer.toJson<String>(snapshotPayload),
    };
  }

  TournamentHistoryRecordRow copyWith({
    int? completionOrder,
    String? tournamentId,
    String? name,
    String? championNickname,
    int? participantCount,
    String? rulesetId,
    String? format,
    int? rulesetVersion,
    String? snapshotPayload,
  }) => TournamentHistoryRecordRow(
    completionOrder: completionOrder ?? this.completionOrder,
    tournamentId: tournamentId ?? this.tournamentId,
    name: name ?? this.name,
    championNickname: championNickname ?? this.championNickname,
    participantCount: participantCount ?? this.participantCount,
    rulesetId: rulesetId ?? this.rulesetId,
    format: format ?? this.format,
    rulesetVersion: rulesetVersion ?? this.rulesetVersion,
    snapshotPayload: snapshotPayload ?? this.snapshotPayload,
  );
  TournamentHistoryRecordRow copyWithCompanion(
    TournamentHistoryRecordsCompanion data,
  ) {
    return TournamentHistoryRecordRow(
      completionOrder: data.completionOrder.present
          ? data.completionOrder.value
          : this.completionOrder,
      tournamentId: data.tournamentId.present
          ? data.tournamentId.value
          : this.tournamentId,
      name: data.name.present ? data.name.value : this.name,
      championNickname: data.championNickname.present
          ? data.championNickname.value
          : this.championNickname,
      participantCount: data.participantCount.present
          ? data.participantCount.value
          : this.participantCount,
      rulesetId: data.rulesetId.present ? data.rulesetId.value : this.rulesetId,
      format: data.format.present ? data.format.value : this.format,
      rulesetVersion: data.rulesetVersion.present
          ? data.rulesetVersion.value
          : this.rulesetVersion,
      snapshotPayload: data.snapshotPayload.present
          ? data.snapshotPayload.value
          : this.snapshotPayload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TournamentHistoryRecordRow(')
          ..write('completionOrder: $completionOrder, ')
          ..write('tournamentId: $tournamentId, ')
          ..write('name: $name, ')
          ..write('championNickname: $championNickname, ')
          ..write('participantCount: $participantCount, ')
          ..write('rulesetId: $rulesetId, ')
          ..write('format: $format, ')
          ..write('rulesetVersion: $rulesetVersion, ')
          ..write('snapshotPayload: $snapshotPayload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    completionOrder,
    tournamentId,
    name,
    championNickname,
    participantCount,
    rulesetId,
    format,
    rulesetVersion,
    snapshotPayload,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TournamentHistoryRecordRow &&
          other.completionOrder == this.completionOrder &&
          other.tournamentId == this.tournamentId &&
          other.name == this.name &&
          other.championNickname == this.championNickname &&
          other.participantCount == this.participantCount &&
          other.rulesetId == this.rulesetId &&
          other.format == this.format &&
          other.rulesetVersion == this.rulesetVersion &&
          other.snapshotPayload == this.snapshotPayload);
}

class TournamentHistoryRecordsCompanion
    extends UpdateCompanion<TournamentHistoryRecordRow> {
  final Value<int> completionOrder;
  final Value<String> tournamentId;
  final Value<String> name;
  final Value<String> championNickname;
  final Value<int> participantCount;
  final Value<String> rulesetId;
  final Value<String> format;
  final Value<int> rulesetVersion;
  final Value<String> snapshotPayload;
  const TournamentHistoryRecordsCompanion({
    this.completionOrder = const Value.absent(),
    this.tournamentId = const Value.absent(),
    this.name = const Value.absent(),
    this.championNickname = const Value.absent(),
    this.participantCount = const Value.absent(),
    this.rulesetId = const Value.absent(),
    this.format = const Value.absent(),
    this.rulesetVersion = const Value.absent(),
    this.snapshotPayload = const Value.absent(),
  });
  TournamentHistoryRecordsCompanion.insert({
    this.completionOrder = const Value.absent(),
    required String tournamentId,
    required String name,
    required String championNickname,
    required int participantCount,
    required String rulesetId,
    this.format = const Value.absent(),
    required int rulesetVersion,
    required String snapshotPayload,
  }) : tournamentId = Value(tournamentId),
       name = Value(name),
       championNickname = Value(championNickname),
       participantCount = Value(participantCount),
       rulesetId = Value(rulesetId),
       rulesetVersion = Value(rulesetVersion),
       snapshotPayload = Value(snapshotPayload);
  static Insertable<TournamentHistoryRecordRow> custom({
    Expression<int>? completionOrder,
    Expression<String>? tournamentId,
    Expression<String>? name,
    Expression<String>? championNickname,
    Expression<int>? participantCount,
    Expression<String>? rulesetId,
    Expression<String>? format,
    Expression<int>? rulesetVersion,
    Expression<String>? snapshotPayload,
  }) {
    return RawValuesInsertable({
      if (completionOrder != null) 'completion_order': completionOrder,
      if (tournamentId != null) 'tournament_id': tournamentId,
      if (name != null) 'name': name,
      if (championNickname != null) 'champion_nickname': championNickname,
      if (participantCount != null) 'participant_count': participantCount,
      if (rulesetId != null) 'ruleset_id': rulesetId,
      if (format != null) 'format': format,
      if (rulesetVersion != null) 'ruleset_version': rulesetVersion,
      if (snapshotPayload != null) 'snapshot_payload': snapshotPayload,
    });
  }

  TournamentHistoryRecordsCompanion copyWith({
    Value<int>? completionOrder,
    Value<String>? tournamentId,
    Value<String>? name,
    Value<String>? championNickname,
    Value<int>? participantCount,
    Value<String>? rulesetId,
    Value<String>? format,
    Value<int>? rulesetVersion,
    Value<String>? snapshotPayload,
  }) {
    return TournamentHistoryRecordsCompanion(
      completionOrder: completionOrder ?? this.completionOrder,
      tournamentId: tournamentId ?? this.tournamentId,
      name: name ?? this.name,
      championNickname: championNickname ?? this.championNickname,
      participantCount: participantCount ?? this.participantCount,
      rulesetId: rulesetId ?? this.rulesetId,
      format: format ?? this.format,
      rulesetVersion: rulesetVersion ?? this.rulesetVersion,
      snapshotPayload: snapshotPayload ?? this.snapshotPayload,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (completionOrder.present) {
      map['completion_order'] = Variable<int>(completionOrder.value);
    }
    if (tournamentId.present) {
      map['tournament_id'] = Variable<String>(tournamentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (championNickname.present) {
      map['champion_nickname'] = Variable<String>(championNickname.value);
    }
    if (participantCount.present) {
      map['participant_count'] = Variable<int>(participantCount.value);
    }
    if (rulesetId.present) {
      map['ruleset_id'] = Variable<String>(rulesetId.value);
    }
    if (format.present) {
      map['format'] = Variable<String>(format.value);
    }
    if (rulesetVersion.present) {
      map['ruleset_version'] = Variable<int>(rulesetVersion.value);
    }
    if (snapshotPayload.present) {
      map['snapshot_payload'] = Variable<String>(snapshotPayload.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TournamentHistoryRecordsCompanion(')
          ..write('completionOrder: $completionOrder, ')
          ..write('tournamentId: $tournamentId, ')
          ..write('name: $name, ')
          ..write('championNickname: $championNickname, ')
          ..write('participantCount: $participantCount, ')
          ..write('rulesetId: $rulesetId, ')
          ..write('format: $format, ')
          ..write('rulesetVersion: $rulesetVersion, ')
          ..write('snapshotPayload: $snapshotPayload')
          ..write(')'))
        .toString();
  }
}

class $ActiveDoubleEliminationTournamentsTable
    extends ActiveDoubleEliminationTournaments
    with
        TableInfo<
          $ActiveDoubleEliminationTournamentsTable,
          ActiveDoubleEliminationTournamentRow
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActiveDoubleEliminationTournamentsTable(
    this.attachedDatabase, [
    this._alias,
  ]);
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
  List<GeneratedColumn> get $columns => [tournamentId, payload];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_double_elimination_tournaments';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActiveDoubleEliminationTournamentRow> instance, {
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
  ActiveDoubleEliminationTournamentRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActiveDoubleEliminationTournamentRow(
      tournamentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tournament_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
    );
  }

  @override
  $ActiveDoubleEliminationTournamentsTable createAlias(String alias) {
    return $ActiveDoubleEliminationTournamentsTable(attachedDatabase, alias);
  }
}

class ActiveDoubleEliminationTournamentRow extends DataClass
    implements Insertable<ActiveDoubleEliminationTournamentRow> {
  final String tournamentId;
  final String payload;
  const ActiveDoubleEliminationTournamentRow({
    required this.tournamentId,
    required this.payload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tournament_id'] = Variable<String>(tournamentId);
    map['payload'] = Variable<String>(payload);
    return map;
  }

  ActiveDoubleEliminationTournamentsCompanion toCompanion(bool nullToAbsent) {
    return ActiveDoubleEliminationTournamentsCompanion(
      tournamentId: Value(tournamentId),
      payload: Value(payload),
    );
  }

  factory ActiveDoubleEliminationTournamentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActiveDoubleEliminationTournamentRow(
      tournamentId: serializer.fromJson<String>(json['tournamentId']),
      payload: serializer.fromJson<String>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tournamentId': serializer.toJson<String>(tournamentId),
      'payload': serializer.toJson<String>(payload),
    };
  }

  ActiveDoubleEliminationTournamentRow copyWith({
    String? tournamentId,
    String? payload,
  }) => ActiveDoubleEliminationTournamentRow(
    tournamentId: tournamentId ?? this.tournamentId,
    payload: payload ?? this.payload,
  );
  ActiveDoubleEliminationTournamentRow copyWithCompanion(
    ActiveDoubleEliminationTournamentsCompanion data,
  ) {
    return ActiveDoubleEliminationTournamentRow(
      tournamentId: data.tournamentId.present
          ? data.tournamentId.value
          : this.tournamentId,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActiveDoubleEliminationTournamentRow(')
          ..write('tournamentId: $tournamentId, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tournamentId, payload);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActiveDoubleEliminationTournamentRow &&
          other.tournamentId == this.tournamentId &&
          other.payload == this.payload);
}

class ActiveDoubleEliminationTournamentsCompanion
    extends UpdateCompanion<ActiveDoubleEliminationTournamentRow> {
  final Value<String> tournamentId;
  final Value<String> payload;
  final Value<int> rowid;
  const ActiveDoubleEliminationTournamentsCompanion({
    this.tournamentId = const Value.absent(),
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActiveDoubleEliminationTournamentsCompanion.insert({
    required String tournamentId,
    required String payload,
    this.rowid = const Value.absent(),
  }) : tournamentId = Value(tournamentId),
       payload = Value(payload);
  static Insertable<ActiveDoubleEliminationTournamentRow> custom({
    Expression<String>? tournamentId,
    Expression<String>? payload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tournamentId != null) 'tournament_id': tournamentId,
      if (payload != null) 'payload': payload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActiveDoubleEliminationTournamentsCompanion copyWith({
    Value<String>? tournamentId,
    Value<String>? payload,
    Value<int>? rowid,
  }) {
    return ActiveDoubleEliminationTournamentsCompanion(
      tournamentId: tournamentId ?? this.tournamentId,
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
    return (StringBuffer('ActiveDoubleEliminationTournamentsCompanion(')
          ..write('tournamentId: $tournamentId, ')
          ..write('payload: $payload, ')
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
  late final $ActiveTournamentsTable activeTournaments =
      $ActiveTournamentsTable(this);
  late final $TournamentFighterAssignmentsTable tournamentFighterAssignments =
      $TournamentFighterAssignmentsTable(this);
  late final $TournamentRoundsTable tournamentRounds = $TournamentRoundsTable(
    this,
  );
  late final $TournamentMatchesTable tournamentMatches =
      $TournamentMatchesTable(this);
  late final $MatchBoutsTable matchBouts = $MatchBoutsTable(this);
  late final $MatchUpdatesTable matchUpdates = $MatchUpdatesTable(this);
  late final $FinishedTournamentsTable finishedTournaments =
      $FinishedTournamentsTable(this);
  late final $FinishedStandingsTable finishedStandings =
      $FinishedStandingsTable(this);
  late final $TournamentHistoryRecordsTable tournamentHistoryRecords =
      $TournamentHistoryRecordsTable(this);
  late final $ActiveDoubleEliminationTournamentsTable
  activeDoubleEliminationTournaments = $ActiveDoubleEliminationTournamentsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localProfiles,
    tournamentDrafts,
    tournamentParticipants,
    activeTournaments,
    tournamentFighterAssignments,
    tournamentRounds,
    tournamentMatches,
    matchBouts,
    matchUpdates,
    finishedTournaments,
    finishedStandings,
    tournamentHistoryRecords,
    activeDoubleEliminationTournaments,
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tournament_drafts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('active_tournaments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tournament_drafts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('tournament_fighter_assignments', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tournament_drafts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tournament_rounds', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tournament_drafts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tournament_matches', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tournament_drafts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('match_bouts', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tournament_drafts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('match_updates', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tournament_drafts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('finished_tournaments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tournament_drafts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('finished_standings', kind: UpdateKind.delete)],
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
      Value<String> format,
      Value<int> rowid,
    });
typedef $$TournamentDraftsTableUpdateCompanionBuilder =
    TournamentDraftsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> status,
      Value<String> format,
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

  static MultiTypedResultKey<$ActiveTournamentsTable, List<ActiveTournamentRow>>
  _activeTournamentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.activeTournaments,
        aliasName: 'tournament_drafts__id__active_tournaments__tournament_id',
      );

  $$ActiveTournamentsTableProcessedTableManager get activeTournamentsRefs {
    final manager = $$ActiveTournamentsTableTableManager(
      $_db,
      $_db.activeTournaments,
    ).filter((f) => f.tournamentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _activeTournamentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TournamentFighterAssignmentsTable,
    List<TournamentFighterAssignmentRow>
  >
  _tournamentFighterAssignmentsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tournamentFighterAssignments,
    aliasName:
        'tournament_drafts__id__tournament_fighter_assignments__tournament_id',
  );

  $$TournamentFighterAssignmentsTableProcessedTableManager
  get tournamentFighterAssignmentsRefs {
    final manager = $$TournamentFighterAssignmentsTableTableManager(
      $_db,
      $_db.tournamentFighterAssignments,
    ).filter((f) => f.tournamentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _tournamentFighterAssignmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TournamentRoundsTable, List<TournamentRoundRow>>
  _tournamentRoundsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tournamentRounds,
    aliasName: 'tournament_drafts__id__tournament_rounds__tournament_id',
  );

  $$TournamentRoundsTableProcessedTableManager get tournamentRoundsRefs {
    final manager = $$TournamentRoundsTableTableManager(
      $_db,
      $_db.tournamentRounds,
    ).filter((f) => f.tournamentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _tournamentRoundsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TournamentMatchesTable, List<TournamentMatchRow>>
  _tournamentMatchesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.tournamentMatches,
        aliasName: 'tournament_drafts__id__tournament_matches__tournament_id',
      );

  $$TournamentMatchesTableProcessedTableManager get tournamentMatchesRefs {
    final manager = $$TournamentMatchesTableTableManager(
      $_db,
      $_db.tournamentMatches,
    ).filter((f) => f.tournamentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _tournamentMatchesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MatchBoutsTable, List<MatchBoutRow>>
  _matchBoutsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.matchBouts,
    aliasName: 'tournament_drafts__id__match_bouts__tournament_id',
  );

  $$MatchBoutsTableProcessedTableManager get matchBoutsRefs {
    final manager = $$MatchBoutsTableTableManager(
      $_db,
      $_db.matchBouts,
    ).filter((f) => f.tournamentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_matchBoutsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MatchUpdatesTable, List<MatchUpdateRow>>
  _matchUpdatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.matchUpdates,
    aliasName: 'tournament_drafts__id__match_updates__tournament_id',
  );

  $$MatchUpdatesTableProcessedTableManager get matchUpdatesRefs {
    final manager = $$MatchUpdatesTableTableManager(
      $_db,
      $_db.matchUpdates,
    ).filter((f) => f.tournamentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_matchUpdatesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $FinishedTournamentsTable,
    List<FinishedTournamentRow>
  >
  _finishedTournamentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.finishedTournaments,
        aliasName: 'tournament_drafts__id__finished_tournaments__tournament_id',
      );

  $$FinishedTournamentsTableProcessedTableManager get finishedTournamentsRefs {
    final manager = $$FinishedTournamentsTableTableManager(
      $_db,
      $_db.finishedTournaments,
    ).filter((f) => f.tournamentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _finishedTournamentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FinishedStandingsTable, List<FinishedStandingRow>>
  _finishedStandingsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.finishedStandings,
        aliasName: 'tournament_drafts__id__finished_standings__tournament_id',
      );

  $$FinishedStandingsTableProcessedTableManager get finishedStandingsRefs {
    final manager = $$FinishedStandingsTableTableManager(
      $_db,
      $_db.finishedStandings,
    ).filter((f) => f.tournamentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _finishedStandingsRefsTable($_db),
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

  ColumnFilters<String> get format => $composableBuilder(
    column: $table.format,
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

  Expression<bool> activeTournamentsRefs(
    Expression<bool> Function($$ActiveTournamentsTableFilterComposer f) f,
  ) {
    final $$ActiveTournamentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activeTournaments,
      getReferencedColumn: (t) => t.tournamentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActiveTournamentsTableFilterComposer(
            $db: $db,
            $table: $db.activeTournaments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tournamentFighterAssignmentsRefs(
    Expression<bool> Function(
      $$TournamentFighterAssignmentsTableFilterComposer f,
    )
    f,
  ) {
    final $$TournamentFighterAssignmentsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.tournamentFighterAssignments,
          getReferencedColumn: (t) => t.tournamentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TournamentFighterAssignmentsTableFilterComposer(
                $db: $db,
                $table: $db.tournamentFighterAssignments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> tournamentRoundsRefs(
    Expression<bool> Function($$TournamentRoundsTableFilterComposer f) f,
  ) {
    final $$TournamentRoundsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tournamentRounds,
      getReferencedColumn: (t) => t.tournamentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentRoundsTableFilterComposer(
            $db: $db,
            $table: $db.tournamentRounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tournamentMatchesRefs(
    Expression<bool> Function($$TournamentMatchesTableFilterComposer f) f,
  ) {
    final $$TournamentMatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tournamentMatches,
      getReferencedColumn: (t) => t.tournamentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentMatchesTableFilterComposer(
            $db: $db,
            $table: $db.tournamentMatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> matchBoutsRefs(
    Expression<bool> Function($$MatchBoutsTableFilterComposer f) f,
  ) {
    final $$MatchBoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matchBouts,
      getReferencedColumn: (t) => t.tournamentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchBoutsTableFilterComposer(
            $db: $db,
            $table: $db.matchBouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> matchUpdatesRefs(
    Expression<bool> Function($$MatchUpdatesTableFilterComposer f) f,
  ) {
    final $$MatchUpdatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matchUpdates,
      getReferencedColumn: (t) => t.tournamentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchUpdatesTableFilterComposer(
            $db: $db,
            $table: $db.matchUpdates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> finishedTournamentsRefs(
    Expression<bool> Function($$FinishedTournamentsTableFilterComposer f) f,
  ) {
    final $$FinishedTournamentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finishedTournaments,
      getReferencedColumn: (t) => t.tournamentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinishedTournamentsTableFilterComposer(
            $db: $db,
            $table: $db.finishedTournaments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> finishedStandingsRefs(
    Expression<bool> Function($$FinishedStandingsTableFilterComposer f) f,
  ) {
    final $$FinishedStandingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finishedStandings,
      getReferencedColumn: (t) => t.tournamentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinishedStandingsTableFilterComposer(
            $db: $db,
            $table: $db.finishedStandings,
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

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
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

  GeneratedColumn<String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

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

  Expression<T> activeTournamentsRefs<T extends Object>(
    Expression<T> Function($$ActiveTournamentsTableAnnotationComposer a) f,
  ) {
    final $$ActiveTournamentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activeTournaments,
          getReferencedColumn: (t) => t.tournamentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActiveTournamentsTableAnnotationComposer(
                $db: $db,
                $table: $db.activeTournaments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> tournamentFighterAssignmentsRefs<T extends Object>(
    Expression<T> Function(
      $$TournamentFighterAssignmentsTableAnnotationComposer a,
    )
    f,
  ) {
    final $$TournamentFighterAssignmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.tournamentFighterAssignments,
          getReferencedColumn: (t) => t.tournamentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TournamentFighterAssignmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.tournamentFighterAssignments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> tournamentRoundsRefs<T extends Object>(
    Expression<T> Function($$TournamentRoundsTableAnnotationComposer a) f,
  ) {
    final $$TournamentRoundsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tournamentRounds,
      getReferencedColumn: (t) => t.tournamentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentRoundsTableAnnotationComposer(
            $db: $db,
            $table: $db.tournamentRounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tournamentMatchesRefs<T extends Object>(
    Expression<T> Function($$TournamentMatchesTableAnnotationComposer a) f,
  ) {
    final $$TournamentMatchesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.tournamentMatches,
          getReferencedColumn: (t) => t.tournamentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TournamentMatchesTableAnnotationComposer(
                $db: $db,
                $table: $db.tournamentMatches,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> matchBoutsRefs<T extends Object>(
    Expression<T> Function($$MatchBoutsTableAnnotationComposer a) f,
  ) {
    final $$MatchBoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matchBouts,
      getReferencedColumn: (t) => t.tournamentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchBoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.matchBouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> matchUpdatesRefs<T extends Object>(
    Expression<T> Function($$MatchUpdatesTableAnnotationComposer a) f,
  ) {
    final $$MatchUpdatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matchUpdates,
      getReferencedColumn: (t) => t.tournamentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchUpdatesTableAnnotationComposer(
            $db: $db,
            $table: $db.matchUpdates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> finishedTournamentsRefs<T extends Object>(
    Expression<T> Function($$FinishedTournamentsTableAnnotationComposer a) f,
  ) {
    final $$FinishedTournamentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.finishedTournaments,
          getReferencedColumn: (t) => t.tournamentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FinishedTournamentsTableAnnotationComposer(
                $db: $db,
                $table: $db.finishedTournaments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> finishedStandingsRefs<T extends Object>(
    Expression<T> Function($$FinishedStandingsTableAnnotationComposer a) f,
  ) {
    final $$FinishedStandingsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.finishedStandings,
          getReferencedColumn: (t) => t.tournamentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FinishedStandingsTableAnnotationComposer(
                $db: $db,
                $table: $db.finishedStandings,
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
          PrefetchHooks Function({
            bool tournamentParticipantsRefs,
            bool activeTournamentsRefs,
            bool tournamentFighterAssignmentsRefs,
            bool tournamentRoundsRefs,
            bool tournamentMatchesRefs,
            bool matchBoutsRefs,
            bool matchUpdatesRefs,
            bool finishedTournamentsRefs,
            bool finishedStandingsRefs,
          })
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
                Value<String> format = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TournamentDraftsCompanion(
                id: id,
                name: name,
                status: status,
                format: format,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String status,
                Value<String> format = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TournamentDraftsCompanion.insert(
                id: id,
                name: name,
                status: status,
                format: format,
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
          prefetchHooksCallback:
              ({
                tournamentParticipantsRefs = false,
                activeTournamentsRefs = false,
                tournamentFighterAssignmentsRefs = false,
                tournamentRoundsRefs = false,
                tournamentMatchesRefs = false,
                matchBoutsRefs = false,
                matchUpdatesRefs = false,
                finishedTournamentsRefs = false,
                finishedStandingsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (tournamentParticipantsRefs) db.tournamentParticipants,
                    if (activeTournamentsRefs) db.activeTournaments,
                    if (tournamentFighterAssignmentsRefs)
                      db.tournamentFighterAssignments,
                    if (tournamentRoundsRefs) db.tournamentRounds,
                    if (tournamentMatchesRefs) db.tournamentMatches,
                    if (matchBoutsRefs) db.matchBouts,
                    if (matchUpdatesRefs) db.matchUpdates,
                    if (finishedTournamentsRefs) db.finishedTournaments,
                    if (finishedStandingsRefs) db.finishedStandings,
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
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tournamentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (activeTournamentsRefs)
                        await $_getPrefetchedData<
                          TournamentDraftRow,
                          $TournamentDraftsTable,
                          ActiveTournamentRow
                        >(
                          currentTable: table,
                          referencedTable: $$TournamentDraftsTableReferences
                              ._activeTournamentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TournamentDraftsTableReferences(
                                db,
                                table,
                                p0,
                              ).activeTournamentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tournamentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tournamentFighterAssignmentsRefs)
                        await $_getPrefetchedData<
                          TournamentDraftRow,
                          $TournamentDraftsTable,
                          TournamentFighterAssignmentRow
                        >(
                          currentTable: table,
                          referencedTable: $$TournamentDraftsTableReferences
                              ._tournamentFighterAssignmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TournamentDraftsTableReferences(
                                db,
                                table,
                                p0,
                              ).tournamentFighterAssignmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tournamentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tournamentRoundsRefs)
                        await $_getPrefetchedData<
                          TournamentDraftRow,
                          $TournamentDraftsTable,
                          TournamentRoundRow
                        >(
                          currentTable: table,
                          referencedTable: $$TournamentDraftsTableReferences
                              ._tournamentRoundsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TournamentDraftsTableReferences(
                                db,
                                table,
                                p0,
                              ).tournamentRoundsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tournamentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tournamentMatchesRefs)
                        await $_getPrefetchedData<
                          TournamentDraftRow,
                          $TournamentDraftsTable,
                          TournamentMatchRow
                        >(
                          currentTable: table,
                          referencedTable: $$TournamentDraftsTableReferences
                              ._tournamentMatchesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TournamentDraftsTableReferences(
                                db,
                                table,
                                p0,
                              ).tournamentMatchesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tournamentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (matchBoutsRefs)
                        await $_getPrefetchedData<
                          TournamentDraftRow,
                          $TournamentDraftsTable,
                          MatchBoutRow
                        >(
                          currentTable: table,
                          referencedTable: $$TournamentDraftsTableReferences
                              ._matchBoutsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TournamentDraftsTableReferences(
                                db,
                                table,
                                p0,
                              ).matchBoutsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tournamentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (matchUpdatesRefs)
                        await $_getPrefetchedData<
                          TournamentDraftRow,
                          $TournamentDraftsTable,
                          MatchUpdateRow
                        >(
                          currentTable: table,
                          referencedTable: $$TournamentDraftsTableReferences
                              ._matchUpdatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TournamentDraftsTableReferences(
                                db,
                                table,
                                p0,
                              ).matchUpdatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tournamentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (finishedTournamentsRefs)
                        await $_getPrefetchedData<
                          TournamentDraftRow,
                          $TournamentDraftsTable,
                          FinishedTournamentRow
                        >(
                          currentTable: table,
                          referencedTable: $$TournamentDraftsTableReferences
                              ._finishedTournamentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TournamentDraftsTableReferences(
                                db,
                                table,
                                p0,
                              ).finishedTournamentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tournamentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (finishedStandingsRefs)
                        await $_getPrefetchedData<
                          TournamentDraftRow,
                          $TournamentDraftsTable,
                          FinishedStandingRow
                        >(
                          currentTable: table,
                          referencedTable: $$TournamentDraftsTableReferences
                              ._finishedStandingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TournamentDraftsTableReferences(
                                db,
                                table,
                                p0,
                              ).finishedStandingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
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
      PrefetchHooks Function({
        bool tournamentParticipantsRefs,
        bool activeTournamentsRefs,
        bool tournamentFighterAssignmentsRefs,
        bool tournamentRoundsRefs,
        bool tournamentMatchesRefs,
        bool matchBoutsRefs,
        bool matchUpdatesRefs,
        bool finishedTournamentsRefs,
        bool finishedStandingsRefs,
      })
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
typedef $$ActiveTournamentsTableCreateCompanionBuilder =
    ActiveTournamentsCompanion Function({
      required String tournamentId,
      Value<String> rulesetId,
      Value<int> rulesetVersion,
      Value<int> rowid,
    });
typedef $$ActiveTournamentsTableUpdateCompanionBuilder =
    ActiveTournamentsCompanion Function({
      Value<String> tournamentId,
      Value<String> rulesetId,
      Value<int> rulesetVersion,
      Value<int> rowid,
    });

final class $$ActiveTournamentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ActiveTournamentsTable,
          ActiveTournamentRow
        > {
  $$ActiveTournamentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TournamentDraftsTable _tournamentIdTable(_$AppDatabase db) => db
      .tournamentDrafts
      .createAlias('active_tournaments__tournament_id__tournament_drafts__id');

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

class $$ActiveTournamentsTableFilterComposer
    extends Composer<_$AppDatabase, $ActiveTournamentsTable> {
  $$ActiveTournamentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get rulesetId => $composableBuilder(
    column: $table.rulesetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rulesetVersion => $composableBuilder(
    column: $table.rulesetVersion,
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

class $$ActiveTournamentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActiveTournamentsTable> {
  $$ActiveTournamentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get rulesetId => $composableBuilder(
    column: $table.rulesetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rulesetVersion => $composableBuilder(
    column: $table.rulesetVersion,
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

class $$ActiveTournamentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActiveTournamentsTable> {
  $$ActiveTournamentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get rulesetId =>
      $composableBuilder(column: $table.rulesetId, builder: (column) => column);

  GeneratedColumn<int> get rulesetVersion => $composableBuilder(
    column: $table.rulesetVersion,
    builder: (column) => column,
  );

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

class $$ActiveTournamentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActiveTournamentsTable,
          ActiveTournamentRow,
          $$ActiveTournamentsTableFilterComposer,
          $$ActiveTournamentsTableOrderingComposer,
          $$ActiveTournamentsTableAnnotationComposer,
          $$ActiveTournamentsTableCreateCompanionBuilder,
          $$ActiveTournamentsTableUpdateCompanionBuilder,
          (ActiveTournamentRow, $$ActiveTournamentsTableReferences),
          ActiveTournamentRow,
          PrefetchHooks Function({bool tournamentId})
        > {
  $$ActiveTournamentsTableTableManager(
    _$AppDatabase db,
    $ActiveTournamentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActiveTournamentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActiveTournamentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActiveTournamentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> tournamentId = const Value.absent(),
                Value<String> rulesetId = const Value.absent(),
                Value<int> rulesetVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActiveTournamentsCompanion(
                tournamentId: tournamentId,
                rulesetId: rulesetId,
                rulesetVersion: rulesetVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tournamentId,
                Value<String> rulesetId = const Value.absent(),
                Value<int> rulesetVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActiveTournamentsCompanion.insert(
                tournamentId: tournamentId,
                rulesetId: rulesetId,
                rulesetVersion: rulesetVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActiveTournamentsTableReferences(db, table, e),
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
                        referencedTable: $$ActiveTournamentsTableReferences
                            ._tournamentIdTable(db),
                        referencedColumn: $$ActiveTournamentsTableReferences
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

typedef $$ActiveTournamentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActiveTournamentsTable,
      ActiveTournamentRow,
      $$ActiveTournamentsTableFilterComposer,
      $$ActiveTournamentsTableOrderingComposer,
      $$ActiveTournamentsTableAnnotationComposer,
      $$ActiveTournamentsTableCreateCompanionBuilder,
      $$ActiveTournamentsTableUpdateCompanionBuilder,
      (ActiveTournamentRow, $$ActiveTournamentsTableReferences),
      ActiveTournamentRow,
      PrefetchHooks Function({bool tournamentId})
    >;
typedef $$TournamentFighterAssignmentsTableCreateCompanionBuilder =
    TournamentFighterAssignmentsCompanion Function({
      required String tournamentId,
      required String participantId,
      required String fighterId,
      Value<int> rowid,
    });
typedef $$TournamentFighterAssignmentsTableUpdateCompanionBuilder =
    TournamentFighterAssignmentsCompanion Function({
      Value<String> tournamentId,
      Value<String> participantId,
      Value<String> fighterId,
      Value<int> rowid,
    });

final class $$TournamentFighterAssignmentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TournamentFighterAssignmentsTable,
          TournamentFighterAssignmentRow
        > {
  $$TournamentFighterAssignmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TournamentDraftsTable _tournamentIdTable(_$AppDatabase db) =>
      db.tournamentDrafts.createAlias(
        'tournament_fighter_assignments__tournament_id__tournament_drafts__id',
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

class $$TournamentFighterAssignmentsTableFilterComposer
    extends Composer<_$AppDatabase, $TournamentFighterAssignmentsTable> {
  $$TournamentFighterAssignmentsTableFilterComposer({
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

  ColumnFilters<String> get fighterId => $composableBuilder(
    column: $table.fighterId,
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

class $$TournamentFighterAssignmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $TournamentFighterAssignmentsTable> {
  $$TournamentFighterAssignmentsTableOrderingComposer({
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

  ColumnOrderings<String> get fighterId => $composableBuilder(
    column: $table.fighterId,
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

class $$TournamentFighterAssignmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TournamentFighterAssignmentsTable> {
  $$TournamentFighterAssignmentsTableAnnotationComposer({
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

  GeneratedColumn<String> get fighterId =>
      $composableBuilder(column: $table.fighterId, builder: (column) => column);

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

class $$TournamentFighterAssignmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TournamentFighterAssignmentsTable,
          TournamentFighterAssignmentRow,
          $$TournamentFighterAssignmentsTableFilterComposer,
          $$TournamentFighterAssignmentsTableOrderingComposer,
          $$TournamentFighterAssignmentsTableAnnotationComposer,
          $$TournamentFighterAssignmentsTableCreateCompanionBuilder,
          $$TournamentFighterAssignmentsTableUpdateCompanionBuilder,
          (
            TournamentFighterAssignmentRow,
            $$TournamentFighterAssignmentsTableReferences,
          ),
          TournamentFighterAssignmentRow,
          PrefetchHooks Function({bool tournamentId})
        > {
  $$TournamentFighterAssignmentsTableTableManager(
    _$AppDatabase db,
    $TournamentFighterAssignmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TournamentFighterAssignmentsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$TournamentFighterAssignmentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TournamentFighterAssignmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> tournamentId = const Value.absent(),
                Value<String> participantId = const Value.absent(),
                Value<String> fighterId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TournamentFighterAssignmentsCompanion(
                tournamentId: tournamentId,
                participantId: participantId,
                fighterId: fighterId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tournamentId,
                required String participantId,
                required String fighterId,
                Value<int> rowid = const Value.absent(),
              }) => TournamentFighterAssignmentsCompanion.insert(
                tournamentId: tournamentId,
                participantId: participantId,
                fighterId: fighterId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TournamentFighterAssignmentsTableReferences(db, table, e),
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
                        referencedTable:
                            $$TournamentFighterAssignmentsTableReferences
                                ._tournamentIdTable(db),
                        referencedColumn:
                            $$TournamentFighterAssignmentsTableReferences
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

typedef $$TournamentFighterAssignmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TournamentFighterAssignmentsTable,
      TournamentFighterAssignmentRow,
      $$TournamentFighterAssignmentsTableFilterComposer,
      $$TournamentFighterAssignmentsTableOrderingComposer,
      $$TournamentFighterAssignmentsTableAnnotationComposer,
      $$TournamentFighterAssignmentsTableCreateCompanionBuilder,
      $$TournamentFighterAssignmentsTableUpdateCompanionBuilder,
      (
        TournamentFighterAssignmentRow,
        $$TournamentFighterAssignmentsTableReferences,
      ),
      TournamentFighterAssignmentRow,
      PrefetchHooks Function({bool tournamentId})
    >;
typedef $$TournamentRoundsTableCreateCompanionBuilder =
    TournamentRoundsCompanion Function({
      required String tournamentId,
      required int roundNumber,
      Value<String?> byeParticipantId,
      Value<int> rowid,
    });
typedef $$TournamentRoundsTableUpdateCompanionBuilder =
    TournamentRoundsCompanion Function({
      Value<String> tournamentId,
      Value<int> roundNumber,
      Value<String?> byeParticipantId,
      Value<int> rowid,
    });

final class $$TournamentRoundsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TournamentRoundsTable,
          TournamentRoundRow
        > {
  $$TournamentRoundsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TournamentDraftsTable _tournamentIdTable(_$AppDatabase db) => db
      .tournamentDrafts
      .createAlias('tournament_rounds__tournament_id__tournament_drafts__id');

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

class $$TournamentRoundsTableFilterComposer
    extends Composer<_$AppDatabase, $TournamentRoundsTable> {
  $$TournamentRoundsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get roundNumber => $composableBuilder(
    column: $table.roundNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get byeParticipantId => $composableBuilder(
    column: $table.byeParticipantId,
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

class $$TournamentRoundsTableOrderingComposer
    extends Composer<_$AppDatabase, $TournamentRoundsTable> {
  $$TournamentRoundsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get roundNumber => $composableBuilder(
    column: $table.roundNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get byeParticipantId => $composableBuilder(
    column: $table.byeParticipantId,
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

class $$TournamentRoundsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TournamentRoundsTable> {
  $$TournamentRoundsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get roundNumber => $composableBuilder(
    column: $table.roundNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get byeParticipantId => $composableBuilder(
    column: $table.byeParticipantId,
    builder: (column) => column,
  );

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

class $$TournamentRoundsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TournamentRoundsTable,
          TournamentRoundRow,
          $$TournamentRoundsTableFilterComposer,
          $$TournamentRoundsTableOrderingComposer,
          $$TournamentRoundsTableAnnotationComposer,
          $$TournamentRoundsTableCreateCompanionBuilder,
          $$TournamentRoundsTableUpdateCompanionBuilder,
          (TournamentRoundRow, $$TournamentRoundsTableReferences),
          TournamentRoundRow,
          PrefetchHooks Function({bool tournamentId})
        > {
  $$TournamentRoundsTableTableManager(
    _$AppDatabase db,
    $TournamentRoundsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TournamentRoundsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TournamentRoundsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TournamentRoundsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> tournamentId = const Value.absent(),
                Value<int> roundNumber = const Value.absent(),
                Value<String?> byeParticipantId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TournamentRoundsCompanion(
                tournamentId: tournamentId,
                roundNumber: roundNumber,
                byeParticipantId: byeParticipantId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tournamentId,
                required int roundNumber,
                Value<String?> byeParticipantId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TournamentRoundsCompanion.insert(
                tournamentId: tournamentId,
                roundNumber: roundNumber,
                byeParticipantId: byeParticipantId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TournamentRoundsTableReferences(db, table, e),
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
                        referencedTable: $$TournamentRoundsTableReferences
                            ._tournamentIdTable(db),
                        referencedColumn: $$TournamentRoundsTableReferences
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

typedef $$TournamentRoundsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TournamentRoundsTable,
      TournamentRoundRow,
      $$TournamentRoundsTableFilterComposer,
      $$TournamentRoundsTableOrderingComposer,
      $$TournamentRoundsTableAnnotationComposer,
      $$TournamentRoundsTableCreateCompanionBuilder,
      $$TournamentRoundsTableUpdateCompanionBuilder,
      (TournamentRoundRow, $$TournamentRoundsTableReferences),
      TournamentRoundRow,
      PrefetchHooks Function({bool tournamentId})
    >;
typedef $$TournamentMatchesTableCreateCompanionBuilder =
    TournamentMatchesCompanion Function({
      required String tournamentId,
      required String matchId,
      required int roundNumber,
      required int position,
      required String firstParticipantId,
      required String secondParticipantId,
      Value<String?> technicalWinnerId,
      Value<int> rowid,
    });
typedef $$TournamentMatchesTableUpdateCompanionBuilder =
    TournamentMatchesCompanion Function({
      Value<String> tournamentId,
      Value<String> matchId,
      Value<int> roundNumber,
      Value<int> position,
      Value<String> firstParticipantId,
      Value<String> secondParticipantId,
      Value<String?> technicalWinnerId,
      Value<int> rowid,
    });

final class $$TournamentMatchesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TournamentMatchesTable,
          TournamentMatchRow
        > {
  $$TournamentMatchesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TournamentDraftsTable _tournamentIdTable(_$AppDatabase db) => db
      .tournamentDrafts
      .createAlias('tournament_matches__tournament_id__tournament_drafts__id');

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

class $$TournamentMatchesTableFilterComposer
    extends Composer<_$AppDatabase, $TournamentMatchesTable> {
  $$TournamentMatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get matchId => $composableBuilder(
    column: $table.matchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get roundNumber => $composableBuilder(
    column: $table.roundNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstParticipantId => $composableBuilder(
    column: $table.firstParticipantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secondParticipantId => $composableBuilder(
    column: $table.secondParticipantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get technicalWinnerId => $composableBuilder(
    column: $table.technicalWinnerId,
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

class $$TournamentMatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $TournamentMatchesTable> {
  $$TournamentMatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get matchId => $composableBuilder(
    column: $table.matchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get roundNumber => $composableBuilder(
    column: $table.roundNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstParticipantId => $composableBuilder(
    column: $table.firstParticipantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secondParticipantId => $composableBuilder(
    column: $table.secondParticipantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get technicalWinnerId => $composableBuilder(
    column: $table.technicalWinnerId,
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

class $$TournamentMatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TournamentMatchesTable> {
  $$TournamentMatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get matchId =>
      $composableBuilder(column: $table.matchId, builder: (column) => column);

  GeneratedColumn<int> get roundNumber => $composableBuilder(
    column: $table.roundNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get firstParticipantId => $composableBuilder(
    column: $table.firstParticipantId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get secondParticipantId => $composableBuilder(
    column: $table.secondParticipantId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get technicalWinnerId => $composableBuilder(
    column: $table.technicalWinnerId,
    builder: (column) => column,
  );

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

class $$TournamentMatchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TournamentMatchesTable,
          TournamentMatchRow,
          $$TournamentMatchesTableFilterComposer,
          $$TournamentMatchesTableOrderingComposer,
          $$TournamentMatchesTableAnnotationComposer,
          $$TournamentMatchesTableCreateCompanionBuilder,
          $$TournamentMatchesTableUpdateCompanionBuilder,
          (TournamentMatchRow, $$TournamentMatchesTableReferences),
          TournamentMatchRow,
          PrefetchHooks Function({bool tournamentId})
        > {
  $$TournamentMatchesTableTableManager(
    _$AppDatabase db,
    $TournamentMatchesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TournamentMatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TournamentMatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TournamentMatchesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> tournamentId = const Value.absent(),
                Value<String> matchId = const Value.absent(),
                Value<int> roundNumber = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> firstParticipantId = const Value.absent(),
                Value<String> secondParticipantId = const Value.absent(),
                Value<String?> technicalWinnerId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TournamentMatchesCompanion(
                tournamentId: tournamentId,
                matchId: matchId,
                roundNumber: roundNumber,
                position: position,
                firstParticipantId: firstParticipantId,
                secondParticipantId: secondParticipantId,
                technicalWinnerId: technicalWinnerId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tournamentId,
                required String matchId,
                required int roundNumber,
                required int position,
                required String firstParticipantId,
                required String secondParticipantId,
                Value<String?> technicalWinnerId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TournamentMatchesCompanion.insert(
                tournamentId: tournamentId,
                matchId: matchId,
                roundNumber: roundNumber,
                position: position,
                firstParticipantId: firstParticipantId,
                secondParticipantId: secondParticipantId,
                technicalWinnerId: technicalWinnerId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TournamentMatchesTableReferences(db, table, e),
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
                        referencedTable: $$TournamentMatchesTableReferences
                            ._tournamentIdTable(db),
                        referencedColumn: $$TournamentMatchesTableReferences
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

typedef $$TournamentMatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TournamentMatchesTable,
      TournamentMatchRow,
      $$TournamentMatchesTableFilterComposer,
      $$TournamentMatchesTableOrderingComposer,
      $$TournamentMatchesTableAnnotationComposer,
      $$TournamentMatchesTableCreateCompanionBuilder,
      $$TournamentMatchesTableUpdateCompanionBuilder,
      (TournamentMatchRow, $$TournamentMatchesTableReferences),
      TournamentMatchRow,
      PrefetchHooks Function({bool tournamentId})
    >;
typedef $$MatchBoutsTableCreateCompanionBuilder = MatchBoutsCompanion Function({
  required String tournamentId,
  required String matchId,
  required int boutNumber,
  required String winnerId,
  Value<int> rowid,
});
typedef $$MatchBoutsTableUpdateCompanionBuilder = MatchBoutsCompanion Function({
  Value<String> tournamentId,
  Value<String> matchId,
  Value<int> boutNumber,
  Value<String> winnerId,
  Value<int> rowid,
});

final class $$MatchBoutsTableReferences
    extends BaseReferences<_$AppDatabase, $MatchBoutsTable, MatchBoutRow> {
  $$MatchBoutsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TournamentDraftsTable _tournamentIdTable(_$AppDatabase db) => db
      .tournamentDrafts
      .createAlias('match_bouts__tournament_id__tournament_drafts__id');

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

class $$MatchBoutsTableFilterComposer
    extends Composer<_$AppDatabase, $MatchBoutsTable> {
  $$MatchBoutsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get matchId => $composableBuilder(
    column: $table.matchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get boutNumber => $composableBuilder(
    column: $table.boutNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get winnerId => $composableBuilder(
    column: $table.winnerId,
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

class $$MatchBoutsTableOrderingComposer
    extends Composer<_$AppDatabase, $MatchBoutsTable> {
  $$MatchBoutsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get matchId => $composableBuilder(
    column: $table.matchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get boutNumber => $composableBuilder(
    column: $table.boutNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get winnerId => $composableBuilder(
    column: $table.winnerId,
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

class $$MatchBoutsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MatchBoutsTable> {
  $$MatchBoutsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get matchId =>
      $composableBuilder(column: $table.matchId, builder: (column) => column);

  GeneratedColumn<int> get boutNumber => $composableBuilder(
    column: $table.boutNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get winnerId =>
      $composableBuilder(column: $table.winnerId, builder: (column) => column);

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

class $$MatchBoutsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MatchBoutsTable,
          MatchBoutRow,
          $$MatchBoutsTableFilterComposer,
          $$MatchBoutsTableOrderingComposer,
          $$MatchBoutsTableAnnotationComposer,
          $$MatchBoutsTableCreateCompanionBuilder,
          $$MatchBoutsTableUpdateCompanionBuilder,
          (MatchBoutRow, $$MatchBoutsTableReferences),
          MatchBoutRow,
          PrefetchHooks Function({bool tournamentId})
        > {
  $$MatchBoutsTableTableManager(_$AppDatabase db, $MatchBoutsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MatchBoutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MatchBoutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MatchBoutsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> tournamentId = const Value.absent(),
                Value<String> matchId = const Value.absent(),
                Value<int> boutNumber = const Value.absent(),
                Value<String> winnerId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MatchBoutsCompanion(
                tournamentId: tournamentId,
                matchId: matchId,
                boutNumber: boutNumber,
                winnerId: winnerId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tournamentId,
                required String matchId,
                required int boutNumber,
                required String winnerId,
                Value<int> rowid = const Value.absent(),
              }) => MatchBoutsCompanion.insert(
                tournamentId: tournamentId,
                matchId: matchId,
                boutNumber: boutNumber,
                winnerId: winnerId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MatchBoutsTableReferences(db, table, e),
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
                        referencedTable: $$MatchBoutsTableReferences
                            ._tournamentIdTable(db),
                        referencedColumn: $$MatchBoutsTableReferences
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

typedef $$MatchBoutsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MatchBoutsTable,
      MatchBoutRow,
      $$MatchBoutsTableFilterComposer,
      $$MatchBoutsTableOrderingComposer,
      $$MatchBoutsTableAnnotationComposer,
      $$MatchBoutsTableCreateCompanionBuilder,
      $$MatchBoutsTableUpdateCompanionBuilder,
      (MatchBoutRow, $$MatchBoutsTableReferences),
      MatchBoutRow,
      PrefetchHooks Function({bool tournamentId})
    >;
typedef $$MatchUpdatesTableCreateCompanionBuilder =
    MatchUpdatesCompanion Function({
      required String tournamentId,
      required String matchId,
      required String updateId,
      Value<int> rowid,
    });
typedef $$MatchUpdatesTableUpdateCompanionBuilder =
    MatchUpdatesCompanion Function({
      Value<String> tournamentId,
      Value<String> matchId,
      Value<String> updateId,
      Value<int> rowid,
    });

final class $$MatchUpdatesTableReferences
    extends BaseReferences<_$AppDatabase, $MatchUpdatesTable, MatchUpdateRow> {
  $$MatchUpdatesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TournamentDraftsTable _tournamentIdTable(_$AppDatabase db) => db
      .tournamentDrafts
      .createAlias('match_updates__tournament_id__tournament_drafts__id');

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

class $$MatchUpdatesTableFilterComposer
    extends Composer<_$AppDatabase, $MatchUpdatesTable> {
  $$MatchUpdatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get matchId => $composableBuilder(
    column: $table.matchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updateId => $composableBuilder(
    column: $table.updateId,
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

class $$MatchUpdatesTableOrderingComposer
    extends Composer<_$AppDatabase, $MatchUpdatesTable> {
  $$MatchUpdatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get matchId => $composableBuilder(
    column: $table.matchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updateId => $composableBuilder(
    column: $table.updateId,
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

class $$MatchUpdatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MatchUpdatesTable> {
  $$MatchUpdatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get matchId =>
      $composableBuilder(column: $table.matchId, builder: (column) => column);

  GeneratedColumn<String> get updateId =>
      $composableBuilder(column: $table.updateId, builder: (column) => column);

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

class $$MatchUpdatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MatchUpdatesTable,
          MatchUpdateRow,
          $$MatchUpdatesTableFilterComposer,
          $$MatchUpdatesTableOrderingComposer,
          $$MatchUpdatesTableAnnotationComposer,
          $$MatchUpdatesTableCreateCompanionBuilder,
          $$MatchUpdatesTableUpdateCompanionBuilder,
          (MatchUpdateRow, $$MatchUpdatesTableReferences),
          MatchUpdateRow,
          PrefetchHooks Function({bool tournamentId})
        > {
  $$MatchUpdatesTableTableManager(_$AppDatabase db, $MatchUpdatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MatchUpdatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MatchUpdatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MatchUpdatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> tournamentId = const Value.absent(),
                Value<String> matchId = const Value.absent(),
                Value<String> updateId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MatchUpdatesCompanion(
                tournamentId: tournamentId,
                matchId: matchId,
                updateId: updateId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tournamentId,
                required String matchId,
                required String updateId,
                Value<int> rowid = const Value.absent(),
              }) => MatchUpdatesCompanion.insert(
                tournamentId: tournamentId,
                matchId: matchId,
                updateId: updateId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MatchUpdatesTableReferences(db, table, e),
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
                        referencedTable: $$MatchUpdatesTableReferences
                            ._tournamentIdTable(db),
                        referencedColumn: $$MatchUpdatesTableReferences
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

typedef $$MatchUpdatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MatchUpdatesTable,
      MatchUpdateRow,
      $$MatchUpdatesTableFilterComposer,
      $$MatchUpdatesTableOrderingComposer,
      $$MatchUpdatesTableAnnotationComposer,
      $$MatchUpdatesTableCreateCompanionBuilder,
      $$MatchUpdatesTableUpdateCompanionBuilder,
      (MatchUpdateRow, $$MatchUpdatesTableReferences),
      MatchUpdateRow,
      PrefetchHooks Function({bool tournamentId})
    >;
typedef $$FinishedTournamentsTableCreateCompanionBuilder =
    FinishedTournamentsCompanion Function({
      required String tournamentId,
      required String rulesetId,
      required int rulesetVersion,
      required String championId,
      Value<int> rowid,
    });
typedef $$FinishedTournamentsTableUpdateCompanionBuilder =
    FinishedTournamentsCompanion Function({
      Value<String> tournamentId,
      Value<String> rulesetId,
      Value<int> rulesetVersion,
      Value<String> championId,
      Value<int> rowid,
    });

final class $$FinishedTournamentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FinishedTournamentsTable,
          FinishedTournamentRow
        > {
  $$FinishedTournamentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TournamentDraftsTable _tournamentIdTable(_$AppDatabase db) =>
      db.tournamentDrafts.createAlias(
        'finished_tournaments__tournament_id__tournament_drafts__id',
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

class $$FinishedTournamentsTableFilterComposer
    extends Composer<_$AppDatabase, $FinishedTournamentsTable> {
  $$FinishedTournamentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get rulesetId => $composableBuilder(
    column: $table.rulesetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rulesetVersion => $composableBuilder(
    column: $table.rulesetVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get championId => $composableBuilder(
    column: $table.championId,
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

class $$FinishedTournamentsTableOrderingComposer
    extends Composer<_$AppDatabase, $FinishedTournamentsTable> {
  $$FinishedTournamentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get rulesetId => $composableBuilder(
    column: $table.rulesetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rulesetVersion => $composableBuilder(
    column: $table.rulesetVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get championId => $composableBuilder(
    column: $table.championId,
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

class $$FinishedTournamentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinishedTournamentsTable> {
  $$FinishedTournamentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get rulesetId =>
      $composableBuilder(column: $table.rulesetId, builder: (column) => column);

  GeneratedColumn<int> get rulesetVersion => $composableBuilder(
    column: $table.rulesetVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get championId => $composableBuilder(
    column: $table.championId,
    builder: (column) => column,
  );

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

class $$FinishedTournamentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FinishedTournamentsTable,
          FinishedTournamentRow,
          $$FinishedTournamentsTableFilterComposer,
          $$FinishedTournamentsTableOrderingComposer,
          $$FinishedTournamentsTableAnnotationComposer,
          $$FinishedTournamentsTableCreateCompanionBuilder,
          $$FinishedTournamentsTableUpdateCompanionBuilder,
          (FinishedTournamentRow, $$FinishedTournamentsTableReferences),
          FinishedTournamentRow,
          PrefetchHooks Function({bool tournamentId})
        > {
  $$FinishedTournamentsTableTableManager(
    _$AppDatabase db,
    $FinishedTournamentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinishedTournamentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinishedTournamentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FinishedTournamentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> tournamentId = const Value.absent(),
                Value<String> rulesetId = const Value.absent(),
                Value<int> rulesetVersion = const Value.absent(),
                Value<String> championId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FinishedTournamentsCompanion(
                tournamentId: tournamentId,
                rulesetId: rulesetId,
                rulesetVersion: rulesetVersion,
                championId: championId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tournamentId,
                required String rulesetId,
                required int rulesetVersion,
                required String championId,
                Value<int> rowid = const Value.absent(),
              }) => FinishedTournamentsCompanion.insert(
                tournamentId: tournamentId,
                rulesetId: rulesetId,
                rulesetVersion: rulesetVersion,
                championId: championId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FinishedTournamentsTableReferences(db, table, e),
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
                        referencedTable: $$FinishedTournamentsTableReferences
                            ._tournamentIdTable(db),
                        referencedColumn: $$FinishedTournamentsTableReferences
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

typedef $$FinishedTournamentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FinishedTournamentsTable,
      FinishedTournamentRow,
      $$FinishedTournamentsTableFilterComposer,
      $$FinishedTournamentsTableOrderingComposer,
      $$FinishedTournamentsTableAnnotationComposer,
      $$FinishedTournamentsTableCreateCompanionBuilder,
      $$FinishedTournamentsTableUpdateCompanionBuilder,
      (FinishedTournamentRow, $$FinishedTournamentsTableReferences),
      FinishedTournamentRow,
      PrefetchHooks Function({bool tournamentId})
    >;
typedef $$FinishedStandingsTableCreateCompanionBuilder =
    FinishedStandingsCompanion Function({
      required String tournamentId,
      required String participantId,
      required int position,
      required int matchesPlayed,
      required int wins,
      required int losses,
      required int gamesWon,
      required int gamesLost,
      required int points,
      Value<int> rowid,
    });
typedef $$FinishedStandingsTableUpdateCompanionBuilder =
    FinishedStandingsCompanion Function({
      Value<String> tournamentId,
      Value<String> participantId,
      Value<int> position,
      Value<int> matchesPlayed,
      Value<int> wins,
      Value<int> losses,
      Value<int> gamesWon,
      Value<int> gamesLost,
      Value<int> points,
      Value<int> rowid,
    });

final class $$FinishedStandingsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FinishedStandingsTable,
          FinishedStandingRow
        > {
  $$FinishedStandingsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TournamentDraftsTable _tournamentIdTable(_$AppDatabase db) => db
      .tournamentDrafts
      .createAlias('finished_standings__tournament_id__tournament_drafts__id');

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

class $$FinishedStandingsTableFilterComposer
    extends Composer<_$AppDatabase, $FinishedStandingsTable> {
  $$FinishedStandingsTableFilterComposer({
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

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get matchesPlayed => $composableBuilder(
    column: $table.matchesPlayed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wins => $composableBuilder(
    column: $table.wins,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get losses => $composableBuilder(
    column: $table.losses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gamesWon => $composableBuilder(
    column: $table.gamesWon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gamesLost => $composableBuilder(
    column: $table.gamesLost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get points => $composableBuilder(
    column: $table.points,
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

class $$FinishedStandingsTableOrderingComposer
    extends Composer<_$AppDatabase, $FinishedStandingsTable> {
  $$FinishedStandingsTableOrderingComposer({
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

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get matchesPlayed => $composableBuilder(
    column: $table.matchesPlayed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wins => $composableBuilder(
    column: $table.wins,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get losses => $composableBuilder(
    column: $table.losses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gamesWon => $composableBuilder(
    column: $table.gamesWon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gamesLost => $composableBuilder(
    column: $table.gamesLost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get points => $composableBuilder(
    column: $table.points,
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

class $$FinishedStandingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinishedStandingsTable> {
  $$FinishedStandingsTableAnnotationComposer({
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

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get matchesPlayed => $composableBuilder(
    column: $table.matchesPlayed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wins =>
      $composableBuilder(column: $table.wins, builder: (column) => column);

  GeneratedColumn<int> get losses =>
      $composableBuilder(column: $table.losses, builder: (column) => column);

  GeneratedColumn<int> get gamesWon =>
      $composableBuilder(column: $table.gamesWon, builder: (column) => column);

  GeneratedColumn<int> get gamesLost =>
      $composableBuilder(column: $table.gamesLost, builder: (column) => column);

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

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

class $$FinishedStandingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FinishedStandingsTable,
          FinishedStandingRow,
          $$FinishedStandingsTableFilterComposer,
          $$FinishedStandingsTableOrderingComposer,
          $$FinishedStandingsTableAnnotationComposer,
          $$FinishedStandingsTableCreateCompanionBuilder,
          $$FinishedStandingsTableUpdateCompanionBuilder,
          (FinishedStandingRow, $$FinishedStandingsTableReferences),
          FinishedStandingRow,
          PrefetchHooks Function({bool tournamentId})
        > {
  $$FinishedStandingsTableTableManager(
    _$AppDatabase db,
    $FinishedStandingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinishedStandingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinishedStandingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinishedStandingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> tournamentId = const Value.absent(),
                Value<String> participantId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> matchesPlayed = const Value.absent(),
                Value<int> wins = const Value.absent(),
                Value<int> losses = const Value.absent(),
                Value<int> gamesWon = const Value.absent(),
                Value<int> gamesLost = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FinishedStandingsCompanion(
                tournamentId: tournamentId,
                participantId: participantId,
                position: position,
                matchesPlayed: matchesPlayed,
                wins: wins,
                losses: losses,
                gamesWon: gamesWon,
                gamesLost: gamesLost,
                points: points,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tournamentId,
                required String participantId,
                required int position,
                required int matchesPlayed,
                required int wins,
                required int losses,
                required int gamesWon,
                required int gamesLost,
                required int points,
                Value<int> rowid = const Value.absent(),
              }) => FinishedStandingsCompanion.insert(
                tournamentId: tournamentId,
                participantId: participantId,
                position: position,
                matchesPlayed: matchesPlayed,
                wins: wins,
                losses: losses,
                gamesWon: gamesWon,
                gamesLost: gamesLost,
                points: points,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FinishedStandingsTableReferences(db, table, e),
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
                        referencedTable: $$FinishedStandingsTableReferences
                            ._tournamentIdTable(db),
                        referencedColumn: $$FinishedStandingsTableReferences
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

typedef $$FinishedStandingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FinishedStandingsTable,
      FinishedStandingRow,
      $$FinishedStandingsTableFilterComposer,
      $$FinishedStandingsTableOrderingComposer,
      $$FinishedStandingsTableAnnotationComposer,
      $$FinishedStandingsTableCreateCompanionBuilder,
      $$FinishedStandingsTableUpdateCompanionBuilder,
      (FinishedStandingRow, $$FinishedStandingsTableReferences),
      FinishedStandingRow,
      PrefetchHooks Function({bool tournamentId})
    >;
typedef $$TournamentHistoryRecordsTableCreateCompanionBuilder =
    TournamentHistoryRecordsCompanion Function({
      Value<int> completionOrder,
      required String tournamentId,
      required String name,
      required String championNickname,
      required int participantCount,
      required String rulesetId,
      Value<String> format,
      required int rulesetVersion,
      required String snapshotPayload,
    });
typedef $$TournamentHistoryRecordsTableUpdateCompanionBuilder =
    TournamentHistoryRecordsCompanion Function({
      Value<int> completionOrder,
      Value<String> tournamentId,
      Value<String> name,
      Value<String> championNickname,
      Value<int> participantCount,
      Value<String> rulesetId,
      Value<String> format,
      Value<int> rulesetVersion,
      Value<String> snapshotPayload,
    });

class $$TournamentHistoryRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $TournamentHistoryRecordsTable> {
  $$TournamentHistoryRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get completionOrder => $composableBuilder(
    column: $table.completionOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tournamentId => $composableBuilder(
    column: $table.tournamentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get championNickname => $composableBuilder(
    column: $table.championNickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get participantCount => $composableBuilder(
    column: $table.participantCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rulesetId => $composableBuilder(
    column: $table.rulesetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rulesetVersion => $composableBuilder(
    column: $table.rulesetVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get snapshotPayload => $composableBuilder(
    column: $table.snapshotPayload,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TournamentHistoryRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $TournamentHistoryRecordsTable> {
  $$TournamentHistoryRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get completionOrder => $composableBuilder(
    column: $table.completionOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tournamentId => $composableBuilder(
    column: $table.tournamentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get championNickname => $composableBuilder(
    column: $table.championNickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get participantCount => $composableBuilder(
    column: $table.participantCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rulesetId => $composableBuilder(
    column: $table.rulesetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rulesetVersion => $composableBuilder(
    column: $table.rulesetVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get snapshotPayload => $composableBuilder(
    column: $table.snapshotPayload,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TournamentHistoryRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TournamentHistoryRecordsTable> {
  $$TournamentHistoryRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get completionOrder => $composableBuilder(
    column: $table.completionOrder,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tournamentId => $composableBuilder(
    column: $table.tournamentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get championNickname => $composableBuilder(
    column: $table.championNickname,
    builder: (column) => column,
  );

  GeneratedColumn<int> get participantCount => $composableBuilder(
    column: $table.participantCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rulesetId =>
      $composableBuilder(column: $table.rulesetId, builder: (column) => column);

  GeneratedColumn<String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumn<int> get rulesetVersion => $composableBuilder(
    column: $table.rulesetVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get snapshotPayload => $composableBuilder(
    column: $table.snapshotPayload,
    builder: (column) => column,
  );
}

class $$TournamentHistoryRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TournamentHistoryRecordsTable,
          TournamentHistoryRecordRow,
          $$TournamentHistoryRecordsTableFilterComposer,
          $$TournamentHistoryRecordsTableOrderingComposer,
          $$TournamentHistoryRecordsTableAnnotationComposer,
          $$TournamentHistoryRecordsTableCreateCompanionBuilder,
          $$TournamentHistoryRecordsTableUpdateCompanionBuilder,
          (
            TournamentHistoryRecordRow,
            BaseReferences<
              _$AppDatabase,
              $TournamentHistoryRecordsTable,
              TournamentHistoryRecordRow
            >,
          ),
          TournamentHistoryRecordRow,
          PrefetchHooks Function()
        > {
  $$TournamentHistoryRecordsTableTableManager(
    _$AppDatabase db,
    $TournamentHistoryRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TournamentHistoryRecordsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$TournamentHistoryRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TournamentHistoryRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> completionOrder = const Value.absent(),
                Value<String> tournamentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> championNickname = const Value.absent(),
                Value<int> participantCount = const Value.absent(),
                Value<String> rulesetId = const Value.absent(),
                Value<String> format = const Value.absent(),
                Value<int> rulesetVersion = const Value.absent(),
                Value<String> snapshotPayload = const Value.absent(),
              }) => TournamentHistoryRecordsCompanion(
                completionOrder: completionOrder,
                tournamentId: tournamentId,
                name: name,
                championNickname: championNickname,
                participantCount: participantCount,
                rulesetId: rulesetId,
                format: format,
                rulesetVersion: rulesetVersion,
                snapshotPayload: snapshotPayload,
              ),
          createCompanionCallback:
              ({
                Value<int> completionOrder = const Value.absent(),
                required String tournamentId,
                required String name,
                required String championNickname,
                required int participantCount,
                required String rulesetId,
                Value<String> format = const Value.absent(),
                required int rulesetVersion,
                required String snapshotPayload,
              }) => TournamentHistoryRecordsCompanion.insert(
                completionOrder: completionOrder,
                tournamentId: tournamentId,
                name: name,
                championNickname: championNickname,
                participantCount: participantCount,
                rulesetId: rulesetId,
                format: format,
                rulesetVersion: rulesetVersion,
                snapshotPayload: snapshotPayload,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TournamentHistoryRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TournamentHistoryRecordsTable,
      TournamentHistoryRecordRow,
      $$TournamentHistoryRecordsTableFilterComposer,
      $$TournamentHistoryRecordsTableOrderingComposer,
      $$TournamentHistoryRecordsTableAnnotationComposer,
      $$TournamentHistoryRecordsTableCreateCompanionBuilder,
      $$TournamentHistoryRecordsTableUpdateCompanionBuilder,
      (
        TournamentHistoryRecordRow,
        BaseReferences<
          _$AppDatabase,
          $TournamentHistoryRecordsTable,
          TournamentHistoryRecordRow
        >,
      ),
      TournamentHistoryRecordRow,
      PrefetchHooks Function()
    >;
typedef $$ActiveDoubleEliminationTournamentsTableCreateCompanionBuilder =
    ActiveDoubleEliminationTournamentsCompanion Function({
      required String tournamentId,
      required String payload,
      Value<int> rowid,
    });
typedef $$ActiveDoubleEliminationTournamentsTableUpdateCompanionBuilder =
    ActiveDoubleEliminationTournamentsCompanion Function({
      Value<String> tournamentId,
      Value<String> payload,
      Value<int> rowid,
    });

class $$ActiveDoubleEliminationTournamentsTableFilterComposer
    extends Composer<_$AppDatabase, $ActiveDoubleEliminationTournamentsTable> {
  $$ActiveDoubleEliminationTournamentsTableFilterComposer({
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

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActiveDoubleEliminationTournamentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActiveDoubleEliminationTournamentsTable> {
  $$ActiveDoubleEliminationTournamentsTableOrderingComposer({
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

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActiveDoubleEliminationTournamentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActiveDoubleEliminationTournamentsTable> {
  $$ActiveDoubleEliminationTournamentsTableAnnotationComposer({
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

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);
}

class $$ActiveDoubleEliminationTournamentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActiveDoubleEliminationTournamentsTable,
          ActiveDoubleEliminationTournamentRow,
          $$ActiveDoubleEliminationTournamentsTableFilterComposer,
          $$ActiveDoubleEliminationTournamentsTableOrderingComposer,
          $$ActiveDoubleEliminationTournamentsTableAnnotationComposer,
          $$ActiveDoubleEliminationTournamentsTableCreateCompanionBuilder,
          $$ActiveDoubleEliminationTournamentsTableUpdateCompanionBuilder,
          (
            ActiveDoubleEliminationTournamentRow,
            BaseReferences<
              _$AppDatabase,
              $ActiveDoubleEliminationTournamentsTable,
              ActiveDoubleEliminationTournamentRow
            >,
          ),
          ActiveDoubleEliminationTournamentRow,
          PrefetchHooks Function()
        > {
  $$ActiveDoubleEliminationTournamentsTableTableManager(
    _$AppDatabase db,
    $ActiveDoubleEliminationTournamentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActiveDoubleEliminationTournamentsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ActiveDoubleEliminationTournamentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ActiveDoubleEliminationTournamentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> tournamentId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActiveDoubleEliminationTournamentsCompanion(
                tournamentId: tournamentId,
                payload: payload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tournamentId,
                required String payload,
                Value<int> rowid = const Value.absent(),
              }) => ActiveDoubleEliminationTournamentsCompanion.insert(
                tournamentId: tournamentId,
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

typedef $$ActiveDoubleEliminationTournamentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActiveDoubleEliminationTournamentsTable,
      ActiveDoubleEliminationTournamentRow,
      $$ActiveDoubleEliminationTournamentsTableFilterComposer,
      $$ActiveDoubleEliminationTournamentsTableOrderingComposer,
      $$ActiveDoubleEliminationTournamentsTableAnnotationComposer,
      $$ActiveDoubleEliminationTournamentsTableCreateCompanionBuilder,
      $$ActiveDoubleEliminationTournamentsTableUpdateCompanionBuilder,
      (
        ActiveDoubleEliminationTournamentRow,
        BaseReferences<
          _$AppDatabase,
          $ActiveDoubleEliminationTournamentsTable,
          ActiveDoubleEliminationTournamentRow
        >,
      ),
      ActiveDoubleEliminationTournamentRow,
      PrefetchHooks Function()
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
  $$ActiveTournamentsTableTableManager get activeTournaments =>
      $$ActiveTournamentsTableTableManager(_db, _db.activeTournaments);
  $$TournamentFighterAssignmentsTableTableManager
  get tournamentFighterAssignments =>
      $$TournamentFighterAssignmentsTableTableManager(
        _db,
        _db.tournamentFighterAssignments,
      );
  $$TournamentRoundsTableTableManager get tournamentRounds =>
      $$TournamentRoundsTableTableManager(_db, _db.tournamentRounds);
  $$TournamentMatchesTableTableManager get tournamentMatches =>
      $$TournamentMatchesTableTableManager(_db, _db.tournamentMatches);
  $$MatchBoutsTableTableManager get matchBouts =>
      $$MatchBoutsTableTableManager(_db, _db.matchBouts);
  $$MatchUpdatesTableTableManager get matchUpdates =>
      $$MatchUpdatesTableTableManager(_db, _db.matchUpdates);
  $$FinishedTournamentsTableTableManager get finishedTournaments =>
      $$FinishedTournamentsTableTableManager(_db, _db.finishedTournaments);
  $$FinishedStandingsTableTableManager get finishedStandings =>
      $$FinishedStandingsTableTableManager(_db, _db.finishedStandings);
  $$TournamentHistoryRecordsTableTableManager get tournamentHistoryRecords =>
      $$TournamentHistoryRecordsTableTableManager(
        _db,
        _db.tournamentHistoryRecords,
      );
  $$ActiveDoubleEliminationTournamentsTableTableManager
  get activeDoubleEliminationTournaments =>
      $$ActiveDoubleEliminationTournamentsTableTableManager(
        _db,
        _db.activeDoubleEliminationTournaments,
      );
}
