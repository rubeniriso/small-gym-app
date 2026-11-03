// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $RoutinesTable extends Routines with TableInfo<$RoutinesTable, Routine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _anchorMondayMeta = const VerificationMeta(
    'anchorMonday',
  );
  @override
  late final GeneratedColumn<String> anchorMonday = GeneratedColumn<String>(
    'anchor_monday',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('static'),
  );
  static const VerificationMeta _incrementsEnabledMeta = const VerificationMeta(
    'incrementsEnabled',
  );
  @override
  late final GeneratedColumn<bool> incrementsEnabled = GeneratedColumn<bool>(
    'increments_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("increments_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _incrementAmountMeta = const VerificationMeta(
    'incrementAmount',
  );
  @override
  late final GeneratedColumn<double> incrementAmount = GeneratedColumn<double>(
    'increment_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.5),
  );
  static const VerificationMeta _incrementUnitMeta = const VerificationMeta(
    'incrementUnit',
  );
  @override
  late final GeneratedColumn<String> incrementUnit = GeneratedColumn<String>(
    'increment_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('kg'),
  );
  static const VerificationMeta _restSecondsMeta = const VerificationMeta(
    'restSeconds',
  );
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
    'rest_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(90),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    createdAt,
    anchorMonday,
    kind,
    incrementsEnabled,
    incrementAmount,
    incrementUnit,
    restSeconds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Routine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('anchor_monday')) {
      context.handle(
        _anchorMondayMeta,
        anchorMonday.isAcceptableOrUnknown(
          data['anchor_monday']!,
          _anchorMondayMeta,
        ),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('increments_enabled')) {
      context.handle(
        _incrementsEnabledMeta,
        incrementsEnabled.isAcceptableOrUnknown(
          data['increments_enabled']!,
          _incrementsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('increment_amount')) {
      context.handle(
        _incrementAmountMeta,
        incrementAmount.isAcceptableOrUnknown(
          data['increment_amount']!,
          _incrementAmountMeta,
        ),
      );
    }
    if (data.containsKey('increment_unit')) {
      context.handle(
        _incrementUnitMeta,
        incrementUnit.isAcceptableOrUnknown(
          data['increment_unit']!,
          _incrementUnitMeta,
        ),
      );
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
        _restSecondsMeta,
        restSeconds.isAcceptableOrUnknown(
          data['rest_seconds']!,
          _restSecondsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Routine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Routine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      anchorMonday: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anchor_monday'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      incrementsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}increments_enabled'],
      )!,
      incrementAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}increment_amount'],
      )!,
      incrementUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}increment_unit'],
      )!,
      restSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_seconds'],
      )!,
    );
  }

  @override
  $RoutinesTable createAlias(String alias) {
    return $RoutinesTable(attachedDatabase, alias);
  }
}

class Routine extends DataClass implements Insertable<Routine> {
  final int id;
  final String name;
  final DateTime createdAt;
  final String? anchorMonday;

  /// `static` follows the week. `dynamic` is chosen each day.
  final String kind;
  final bool incrementsEnabled;

  /// Added after a finished session. Zero adds nothing.
  final double incrementAmount;

  /// `kg` adds that many kilograms. `percent` adds that share of the weight.
  final String incrementUnit;

  /// Default rest between strength sets, in seconds.
  final int restSeconds;
  const Routine({
    required this.id,
    required this.name,
    required this.createdAt,
    this.anchorMonday,
    required this.kind,
    required this.incrementsEnabled,
    required this.incrementAmount,
    required this.incrementUnit,
    required this.restSeconds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || anchorMonday != null) {
      map['anchor_monday'] = Variable<String>(anchorMonday);
    }
    map['kind'] = Variable<String>(kind);
    map['increments_enabled'] = Variable<bool>(incrementsEnabled);
    map['increment_amount'] = Variable<double>(incrementAmount);
    map['increment_unit'] = Variable<String>(incrementUnit);
    map['rest_seconds'] = Variable<int>(restSeconds);
    return map;
  }

  RoutinesCompanion toCompanion(bool nullToAbsent) {
    return RoutinesCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      anchorMonday: anchorMonday == null && nullToAbsent
          ? const Value.absent()
          : Value(anchorMonday),
      kind: Value(kind),
      incrementsEnabled: Value(incrementsEnabled),
      incrementAmount: Value(incrementAmount),
      incrementUnit: Value(incrementUnit),
      restSeconds: Value(restSeconds),
    );
  }

  factory Routine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Routine(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      anchorMonday: serializer.fromJson<String?>(json['anchorMonday']),
      kind: serializer.fromJson<String>(json['kind']),
      incrementsEnabled: serializer.fromJson<bool>(json['incrementsEnabled']),
      incrementAmount: serializer.fromJson<double>(json['incrementAmount']),
      incrementUnit: serializer.fromJson<String>(json['incrementUnit']),
      restSeconds: serializer.fromJson<int>(json['restSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'anchorMonday': serializer.toJson<String?>(anchorMonday),
      'kind': serializer.toJson<String>(kind),
      'incrementsEnabled': serializer.toJson<bool>(incrementsEnabled),
      'incrementAmount': serializer.toJson<double>(incrementAmount),
      'incrementUnit': serializer.toJson<String>(incrementUnit),
      'restSeconds': serializer.toJson<int>(restSeconds),
    };
  }

  Routine copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    Value<String?> anchorMonday = const Value.absent(),
    String? kind,
    bool? incrementsEnabled,
    double? incrementAmount,
    String? incrementUnit,
    int? restSeconds,
  }) => Routine(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    anchorMonday: anchorMonday.present ? anchorMonday.value : this.anchorMonday,
    kind: kind ?? this.kind,
    incrementsEnabled: incrementsEnabled ?? this.incrementsEnabled,
    incrementAmount: incrementAmount ?? this.incrementAmount,
    incrementUnit: incrementUnit ?? this.incrementUnit,
    restSeconds: restSeconds ?? this.restSeconds,
  );
  Routine copyWithCompanion(RoutinesCompanion data) {
    return Routine(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      anchorMonday: data.anchorMonday.present
          ? data.anchorMonday.value
          : this.anchorMonday,
      kind: data.kind.present ? data.kind.value : this.kind,
      incrementsEnabled: data.incrementsEnabled.present
          ? data.incrementsEnabled.value
          : this.incrementsEnabled,
      incrementAmount: data.incrementAmount.present
          ? data.incrementAmount.value
          : this.incrementAmount,
      incrementUnit: data.incrementUnit.present
          ? data.incrementUnit.value
          : this.incrementUnit,
      restSeconds: data.restSeconds.present
          ? data.restSeconds.value
          : this.restSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Routine(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('anchorMonday: $anchorMonday, ')
          ..write('kind: $kind, ')
          ..write('incrementsEnabled: $incrementsEnabled, ')
          ..write('incrementAmount: $incrementAmount, ')
          ..write('incrementUnit: $incrementUnit, ')
          ..write('restSeconds: $restSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    createdAt,
    anchorMonday,
    kind,
    incrementsEnabled,
    incrementAmount,
    incrementUnit,
    restSeconds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Routine &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.anchorMonday == this.anchorMonday &&
          other.kind == this.kind &&
          other.incrementsEnabled == this.incrementsEnabled &&
          other.incrementAmount == this.incrementAmount &&
          other.incrementUnit == this.incrementUnit &&
          other.restSeconds == this.restSeconds);
}

class RoutinesCompanion extends UpdateCompanion<Routine> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<String?> anchorMonday;
  final Value<String> kind;
  final Value<bool> incrementsEnabled;
  final Value<double> incrementAmount;
  final Value<String> incrementUnit;
  final Value<int> restSeconds;
  const RoutinesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.anchorMonday = const Value.absent(),
    this.kind = const Value.absent(),
    this.incrementsEnabled = const Value.absent(),
    this.incrementAmount = const Value.absent(),
    this.incrementUnit = const Value.absent(),
    this.restSeconds = const Value.absent(),
  });
  RoutinesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
    this.anchorMonday = const Value.absent(),
    this.kind = const Value.absent(),
    this.incrementsEnabled = const Value.absent(),
    this.incrementAmount = const Value.absent(),
    this.incrementUnit = const Value.absent(),
    this.restSeconds = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Routine> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<String>? anchorMonday,
    Expression<String>? kind,
    Expression<bool>? incrementsEnabled,
    Expression<double>? incrementAmount,
    Expression<String>? incrementUnit,
    Expression<int>? restSeconds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (anchorMonday != null) 'anchor_monday': anchorMonday,
      if (kind != null) 'kind': kind,
      if (incrementsEnabled != null) 'increments_enabled': incrementsEnabled,
      if (incrementAmount != null) 'increment_amount': incrementAmount,
      if (incrementUnit != null) 'increment_unit': incrementUnit,
      if (restSeconds != null) 'rest_seconds': restSeconds,
    });
  }

  RoutinesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<String?>? anchorMonday,
    Value<String>? kind,
    Value<bool>? incrementsEnabled,
    Value<double>? incrementAmount,
    Value<String>? incrementUnit,
    Value<int>? restSeconds,
  }) {
    return RoutinesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      anchorMonday: anchorMonday ?? this.anchorMonday,
      kind: kind ?? this.kind,
      incrementsEnabled: incrementsEnabled ?? this.incrementsEnabled,
      incrementAmount: incrementAmount ?? this.incrementAmount,
      incrementUnit: incrementUnit ?? this.incrementUnit,
      restSeconds: restSeconds ?? this.restSeconds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (anchorMonday.present) {
      map['anchor_monday'] = Variable<String>(anchorMonday.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (incrementsEnabled.present) {
      map['increments_enabled'] = Variable<bool>(incrementsEnabled.value);
    }
    if (incrementAmount.present) {
      map['increment_amount'] = Variable<double>(incrementAmount.value);
    }
    if (incrementUnit.present) {
      map['increment_unit'] = Variable<String>(incrementUnit.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutinesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('anchorMonday: $anchorMonday, ')
          ..write('kind: $kind, ')
          ..write('incrementsEnabled: $incrementsEnabled, ')
          ..write('incrementAmount: $incrementAmount, ')
          ..write('incrementUnit: $incrementUnit, ')
          ..write('restSeconds: $restSeconds')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentRoutineIdMeta = const VerificationMeta(
    'currentRoutineId',
  );
  @override
  late final GeneratedColumn<int> currentRoutineId = GeneratedColumn<int>(
    'current_routine_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routines (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, currentRoutineId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('current_routine_id')) {
      context.handle(
        _currentRoutineIdMeta,
        currentRoutineId.isAcceptableOrUnknown(
          data['current_routine_id']!,
          _currentRoutineIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      currentRoutineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_routine_id'],
      ),
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final int? currentRoutineId;
  const AppSetting({required this.id, this.currentRoutineId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || currentRoutineId != null) {
      map['current_routine_id'] = Variable<int>(currentRoutineId);
    }
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      currentRoutineId: currentRoutineId == null && nullToAbsent
          ? const Value.absent()
          : Value(currentRoutineId),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      currentRoutineId: serializer.fromJson<int?>(json['currentRoutineId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currentRoutineId': serializer.toJson<int?>(currentRoutineId),
    };
  }

  AppSetting copyWith({
    int? id,
    Value<int?> currentRoutineId = const Value.absent(),
  }) => AppSetting(
    id: id ?? this.id,
    currentRoutineId: currentRoutineId.present
        ? currentRoutineId.value
        : this.currentRoutineId,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      currentRoutineId: data.currentRoutineId.present
          ? data.currentRoutineId.value
          : this.currentRoutineId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('currentRoutineId: $currentRoutineId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, currentRoutineId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.currentRoutineId == this.currentRoutineId);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<int?> currentRoutineId;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.currentRoutineId = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.currentRoutineId = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<int>? currentRoutineId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currentRoutineId != null) 'current_routine_id': currentRoutineId,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<int?>? currentRoutineId,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      currentRoutineId: currentRoutineId ?? this.currentRoutineId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currentRoutineId.present) {
      map['current_routine_id'] = Variable<int>(currentRoutineId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('currentRoutineId: $currentRoutineId')
          ..write(')'))
        .toString();
  }
}

class $WorkoutsTable extends Workouts with TableInfo<$WorkoutsTable, Workout> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<int> routineId = GeneratedColumn<int>(
    'routine_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routines (id)',
    ),
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
  List<GeneratedColumn> get $columns => [id, routineId, name, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workouts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Workout> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Workout map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Workout(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}routine_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $WorkoutsTable createAlias(String alias) {
    return $WorkoutsTable(attachedDatabase, alias);
  }
}

class Workout extends DataClass implements Insertable<Workout> {
  final int id;
  final int routineId;
  final String name;
  final int position;
  const Workout({
    required this.id,
    required this.routineId,
    required this.name,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['routine_id'] = Variable<int>(routineId);
    map['name'] = Variable<String>(name);
    map['position'] = Variable<int>(position);
    return map;
  }

  WorkoutsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutsCompanion(
      id: Value(id),
      routineId: Value(routineId),
      name: Value(name),
      position: Value(position),
    );
  }

  factory Workout.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Workout(
      id: serializer.fromJson<int>(json['id']),
      routineId: serializer.fromJson<int>(json['routineId']),
      name: serializer.fromJson<String>(json['name']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'routineId': serializer.toJson<int>(routineId),
      'name': serializer.toJson<String>(name),
      'position': serializer.toJson<int>(position),
    };
  }

  Workout copyWith({int? id, int? routineId, String? name, int? position}) =>
      Workout(
        id: id ?? this.id,
        routineId: routineId ?? this.routineId,
        name: name ?? this.name,
        position: position ?? this.position,
      );
  Workout copyWithCompanion(WorkoutsCompanion data) {
    return Workout(
      id: data.id.present ? data.id.value : this.id,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      name: data.name.present ? data.name.value : this.name,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Workout(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('name: $name, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, routineId, name, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Workout &&
          other.id == this.id &&
          other.routineId == this.routineId &&
          other.name == this.name &&
          other.position == this.position);
}

class WorkoutsCompanion extends UpdateCompanion<Workout> {
  final Value<int> id;
  final Value<int> routineId;
  final Value<String> name;
  final Value<int> position;
  const WorkoutsCompanion({
    this.id = const Value.absent(),
    this.routineId = const Value.absent(),
    this.name = const Value.absent(),
    this.position = const Value.absent(),
  });
  WorkoutsCompanion.insert({
    this.id = const Value.absent(),
    required int routineId,
    required String name,
    required int position,
  }) : routineId = Value(routineId),
       name = Value(name),
       position = Value(position);
  static Insertable<Workout> custom({
    Expression<int>? id,
    Expression<int>? routineId,
    Expression<String>? name,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineId != null) 'routine_id': routineId,
      if (name != null) 'name': name,
      if (position != null) 'position': position,
    });
  }

  WorkoutsCompanion copyWith({
    Value<int>? id,
    Value<int>? routineId,
    Value<String>? name,
    Value<int>? position,
  }) {
    return WorkoutsCompanion(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      name: name ?? this.name,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (routineId.present) {
      map['routine_id'] = Variable<int>(routineId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('name: $name, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $WorkoutExercisesTable extends WorkoutExercises
    with TableInfo<$WorkoutExercisesTable, WorkoutExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<int> workoutId = GeneratedColumn<int>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workouts (id)',
    ),
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
  static const VerificationMeta _setsMeta = const VerificationMeta('sets');
  @override
  late final GeneratedColumn<int> sets = GeneratedColumn<int>(
    'sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Exercise, String> exercise =
      GeneratedColumn<String>(
        'exercise',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Exercise>($WorkoutExercisesTable.$converterexercise);
  static const VerificationMeta _targetWeightKgMeta = const VerificationMeta(
    'targetWeightKg',
  );
  @override
  late final GeneratedColumn<double> targetWeightKg = GeneratedColumn<double>(
    'target_weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetMinutesMeta = const VerificationMeta(
    'targetMinutes',
  );
  @override
  late final GeneratedColumn<int> targetMinutes = GeneratedColumn<int>(
    'target_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetSpeedKmhMeta = const VerificationMeta(
    'targetSpeedKmh',
  );
  @override
  late final GeneratedColumn<double> targetSpeedKmh = GeneratedColumn<double>(
    'target_speed_kmh',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restSecondsMeta = const VerificationMeta(
    'restSeconds',
  );
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
    'rest_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _incrementAmountMeta = const VerificationMeta(
    'incrementAmount',
  );
  @override
  late final GeneratedColumn<double> incrementAmount = GeneratedColumn<double>(
    'increment_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _incrementUnitMeta = const VerificationMeta(
    'incrementUnit',
  );
  @override
  late final GeneratedColumn<String> incrementUnit = GeneratedColumn<String>(
    'increment_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutId,
    position,
    sets,
    reps,
    exercise,
    targetWeightKg,
    targetMinutes,
    targetSpeedKmh,
    restSeconds,
    incrementAmount,
    incrementUnit,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('sets')) {
      context.handle(
        _setsMeta,
        sets.isAcceptableOrUnknown(data['sets']!, _setsMeta),
      );
    } else if (isInserting) {
      context.missing(_setsMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('target_weight_kg')) {
      context.handle(
        _targetWeightKgMeta,
        targetWeightKg.isAcceptableOrUnknown(
          data['target_weight_kg']!,
          _targetWeightKgMeta,
        ),
      );
    }
    if (data.containsKey('target_minutes')) {
      context.handle(
        _targetMinutesMeta,
        targetMinutes.isAcceptableOrUnknown(
          data['target_minutes']!,
          _targetMinutesMeta,
        ),
      );
    }
    if (data.containsKey('target_speed_kmh')) {
      context.handle(
        _targetSpeedKmhMeta,
        targetSpeedKmh.isAcceptableOrUnknown(
          data['target_speed_kmh']!,
          _targetSpeedKmhMeta,
        ),
      );
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
        _restSecondsMeta,
        restSeconds.isAcceptableOrUnknown(
          data['rest_seconds']!,
          _restSecondsMeta,
        ),
      );
    }
    if (data.containsKey('increment_amount')) {
      context.handle(
        _incrementAmountMeta,
        incrementAmount.isAcceptableOrUnknown(
          data['increment_amount']!,
          _incrementAmountMeta,
        ),
      );
    }
    if (data.containsKey('increment_unit')) {
      context.handle(
        _incrementUnitMeta,
        incrementUnit.isAcceptableOrUnknown(
          data['increment_unit']!,
          _incrementUnitMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {workoutId, exercise},
  ];
  @override
  WorkoutExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      sets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sets'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      exercise: $WorkoutExercisesTable.$converterexercise.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}exercise'],
        )!,
      ),
      targetWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_weight_kg'],
      ),
      targetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_minutes'],
      ),
      targetSpeedKmh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_speed_kmh'],
      ),
      restSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_seconds'],
      ),
      incrementAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}increment_amount'],
      ),
      incrementUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}increment_unit'],
      ),
    );
  }

  @override
  $WorkoutExercisesTable createAlias(String alias) {
    return $WorkoutExercisesTable(attachedDatabase, alias);
  }

  static TypeConverter<Exercise, String> $converterexercise =
      const ExerciseConverter();
}

class WorkoutExercise extends DataClass implements Insertable<WorkoutExercise> {
  final int id;
  final int workoutId;
  final int position;
  final int sets;
  final int reps;
  final Exercise exercise;
  final double? targetWeightKg;

  /// Jogging length in seconds.
  ///
  /// Databases created before schema 7 stored whole minutes. That upgrade
  /// multiplies the stored value by 60.
  final int? targetMinutes;
  final double? targetSpeedKmh;

  /// Overrides the routine rest. Null uses the routine default.
  final int? restSeconds;

  /// Overrides the routine increment. Null uses the routine default.
  final double? incrementAmount;
  final String? incrementUnit;
  const WorkoutExercise({
    required this.id,
    required this.workoutId,
    required this.position,
    required this.sets,
    required this.reps,
    required this.exercise,
    this.targetWeightKg,
    this.targetMinutes,
    this.targetSpeedKmh,
    this.restSeconds,
    this.incrementAmount,
    this.incrementUnit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['workout_id'] = Variable<int>(workoutId);
    map['position'] = Variable<int>(position);
    map['sets'] = Variable<int>(sets);
    map['reps'] = Variable<int>(reps);
    {
      map['exercise'] = Variable<String>(
        $WorkoutExercisesTable.$converterexercise.toSql(exercise),
      );
    }
    if (!nullToAbsent || targetWeightKg != null) {
      map['target_weight_kg'] = Variable<double>(targetWeightKg);
    }
    if (!nullToAbsent || targetMinutes != null) {
      map['target_minutes'] = Variable<int>(targetMinutes);
    }
    if (!nullToAbsent || targetSpeedKmh != null) {
      map['target_speed_kmh'] = Variable<double>(targetSpeedKmh);
    }
    if (!nullToAbsent || restSeconds != null) {
      map['rest_seconds'] = Variable<int>(restSeconds);
    }
    if (!nullToAbsent || incrementAmount != null) {
      map['increment_amount'] = Variable<double>(incrementAmount);
    }
    if (!nullToAbsent || incrementUnit != null) {
      map['increment_unit'] = Variable<String>(incrementUnit);
    }
    return map;
  }

  WorkoutExercisesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutExercisesCompanion(
      id: Value(id),
      workoutId: Value(workoutId),
      position: Value(position),
      sets: Value(sets),
      reps: Value(reps),
      exercise: Value(exercise),
      targetWeightKg: targetWeightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(targetWeightKg),
      targetMinutes: targetMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(targetMinutes),
      targetSpeedKmh: targetSpeedKmh == null && nullToAbsent
          ? const Value.absent()
          : Value(targetSpeedKmh),
      restSeconds: restSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(restSeconds),
      incrementAmount: incrementAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(incrementAmount),
      incrementUnit: incrementUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(incrementUnit),
    );
  }

  factory WorkoutExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutExercise(
      id: serializer.fromJson<int>(json['id']),
      workoutId: serializer.fromJson<int>(json['workoutId']),
      position: serializer.fromJson<int>(json['position']),
      sets: serializer.fromJson<int>(json['sets']),
      reps: serializer.fromJson<int>(json['reps']),
      exercise: serializer.fromJson<Exercise>(json['exercise']),
      targetWeightKg: serializer.fromJson<double?>(json['targetWeightKg']),
      targetMinutes: serializer.fromJson<int?>(json['targetMinutes']),
      targetSpeedKmh: serializer.fromJson<double?>(json['targetSpeedKmh']),
      restSeconds: serializer.fromJson<int?>(json['restSeconds']),
      incrementAmount: serializer.fromJson<double?>(json['incrementAmount']),
      incrementUnit: serializer.fromJson<String?>(json['incrementUnit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workoutId': serializer.toJson<int>(workoutId),
      'position': serializer.toJson<int>(position),
      'sets': serializer.toJson<int>(sets),
      'reps': serializer.toJson<int>(reps),
      'exercise': serializer.toJson<Exercise>(exercise),
      'targetWeightKg': serializer.toJson<double?>(targetWeightKg),
      'targetMinutes': serializer.toJson<int?>(targetMinutes),
      'targetSpeedKmh': serializer.toJson<double?>(targetSpeedKmh),
      'restSeconds': serializer.toJson<int?>(restSeconds),
      'incrementAmount': serializer.toJson<double?>(incrementAmount),
      'incrementUnit': serializer.toJson<String?>(incrementUnit),
    };
  }

  WorkoutExercise copyWith({
    int? id,
    int? workoutId,
    int? position,
    int? sets,
    int? reps,
    Exercise? exercise,
    Value<double?> targetWeightKg = const Value.absent(),
    Value<int?> targetMinutes = const Value.absent(),
    Value<double?> targetSpeedKmh = const Value.absent(),
    Value<int?> restSeconds = const Value.absent(),
    Value<double?> incrementAmount = const Value.absent(),
    Value<String?> incrementUnit = const Value.absent(),
  }) => WorkoutExercise(
    id: id ?? this.id,
    workoutId: workoutId ?? this.workoutId,
    position: position ?? this.position,
    sets: sets ?? this.sets,
    reps: reps ?? this.reps,
    exercise: exercise ?? this.exercise,
    targetWeightKg: targetWeightKg.present
        ? targetWeightKg.value
        : this.targetWeightKg,
    targetMinutes: targetMinutes.present
        ? targetMinutes.value
        : this.targetMinutes,
    targetSpeedKmh: targetSpeedKmh.present
        ? targetSpeedKmh.value
        : this.targetSpeedKmh,
    restSeconds: restSeconds.present ? restSeconds.value : this.restSeconds,
    incrementAmount: incrementAmount.present
        ? incrementAmount.value
        : this.incrementAmount,
    incrementUnit: incrementUnit.present
        ? incrementUnit.value
        : this.incrementUnit,
  );
  WorkoutExercise copyWithCompanion(WorkoutExercisesCompanion data) {
    return WorkoutExercise(
      id: data.id.present ? data.id.value : this.id,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      position: data.position.present ? data.position.value : this.position,
      sets: data.sets.present ? data.sets.value : this.sets,
      reps: data.reps.present ? data.reps.value : this.reps,
      exercise: data.exercise.present ? data.exercise.value : this.exercise,
      targetWeightKg: data.targetWeightKg.present
          ? data.targetWeightKg.value
          : this.targetWeightKg,
      targetMinutes: data.targetMinutes.present
          ? data.targetMinutes.value
          : this.targetMinutes,
      targetSpeedKmh: data.targetSpeedKmh.present
          ? data.targetSpeedKmh.value
          : this.targetSpeedKmh,
      restSeconds: data.restSeconds.present
          ? data.restSeconds.value
          : this.restSeconds,
      incrementAmount: data.incrementAmount.present
          ? data.incrementAmount.value
          : this.incrementAmount,
      incrementUnit: data.incrementUnit.present
          ? data.incrementUnit.value
          : this.incrementUnit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExercise(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('position: $position, ')
          ..write('sets: $sets, ')
          ..write('reps: $reps, ')
          ..write('exercise: $exercise, ')
          ..write('targetWeightKg: $targetWeightKg, ')
          ..write('targetMinutes: $targetMinutes, ')
          ..write('targetSpeedKmh: $targetSpeedKmh, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('incrementAmount: $incrementAmount, ')
          ..write('incrementUnit: $incrementUnit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workoutId,
    position,
    sets,
    reps,
    exercise,
    targetWeightKg,
    targetMinutes,
    targetSpeedKmh,
    restSeconds,
    incrementAmount,
    incrementUnit,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutExercise &&
          other.id == this.id &&
          other.workoutId == this.workoutId &&
          other.position == this.position &&
          other.sets == this.sets &&
          other.reps == this.reps &&
          other.exercise == this.exercise &&
          other.targetWeightKg == this.targetWeightKg &&
          other.targetMinutes == this.targetMinutes &&
          other.targetSpeedKmh == this.targetSpeedKmh &&
          other.restSeconds == this.restSeconds &&
          other.incrementAmount == this.incrementAmount &&
          other.incrementUnit == this.incrementUnit);
}

class WorkoutExercisesCompanion extends UpdateCompanion<WorkoutExercise> {
  final Value<int> id;
  final Value<int> workoutId;
  final Value<int> position;
  final Value<int> sets;
  final Value<int> reps;
  final Value<Exercise> exercise;
  final Value<double?> targetWeightKg;
  final Value<int?> targetMinutes;
  final Value<double?> targetSpeedKmh;
  final Value<int?> restSeconds;
  final Value<double?> incrementAmount;
  final Value<String?> incrementUnit;
  const WorkoutExercisesCompanion({
    this.id = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.position = const Value.absent(),
    this.sets = const Value.absent(),
    this.reps = const Value.absent(),
    this.exercise = const Value.absent(),
    this.targetWeightKg = const Value.absent(),
    this.targetMinutes = const Value.absent(),
    this.targetSpeedKmh = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.incrementAmount = const Value.absent(),
    this.incrementUnit = const Value.absent(),
  });
  WorkoutExercisesCompanion.insert({
    this.id = const Value.absent(),
    required int workoutId,
    required int position,
    required int sets,
    required int reps,
    required Exercise exercise,
    this.targetWeightKg = const Value.absent(),
    this.targetMinutes = const Value.absent(),
    this.targetSpeedKmh = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.incrementAmount = const Value.absent(),
    this.incrementUnit = const Value.absent(),
  }) : workoutId = Value(workoutId),
       position = Value(position),
       sets = Value(sets),
       reps = Value(reps),
       exercise = Value(exercise);
  static Insertable<WorkoutExercise> custom({
    Expression<int>? id,
    Expression<int>? workoutId,
    Expression<int>? position,
    Expression<int>? sets,
    Expression<int>? reps,
    Expression<String>? exercise,
    Expression<double>? targetWeightKg,
    Expression<int>? targetMinutes,
    Expression<double>? targetSpeedKmh,
    Expression<int>? restSeconds,
    Expression<double>? incrementAmount,
    Expression<String>? incrementUnit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutId != null) 'workout_id': workoutId,
      if (position != null) 'position': position,
      if (sets != null) 'sets': sets,
      if (reps != null) 'reps': reps,
      if (exercise != null) 'exercise': exercise,
      if (targetWeightKg != null) 'target_weight_kg': targetWeightKg,
      if (targetMinutes != null) 'target_minutes': targetMinutes,
      if (targetSpeedKmh != null) 'target_speed_kmh': targetSpeedKmh,
      if (restSeconds != null) 'rest_seconds': restSeconds,
      if (incrementAmount != null) 'increment_amount': incrementAmount,
      if (incrementUnit != null) 'increment_unit': incrementUnit,
    });
  }

  WorkoutExercisesCompanion copyWith({
    Value<int>? id,
    Value<int>? workoutId,
    Value<int>? position,
    Value<int>? sets,
    Value<int>? reps,
    Value<Exercise>? exercise,
    Value<double?>? targetWeightKg,
    Value<int?>? targetMinutes,
    Value<double?>? targetSpeedKmh,
    Value<int?>? restSeconds,
    Value<double?>? incrementAmount,
    Value<String?>? incrementUnit,
  }) {
    return WorkoutExercisesCompanion(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      position: position ?? this.position,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      exercise: exercise ?? this.exercise,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      targetMinutes: targetMinutes ?? this.targetMinutes,
      targetSpeedKmh: targetSpeedKmh ?? this.targetSpeedKmh,
      restSeconds: restSeconds ?? this.restSeconds,
      incrementAmount: incrementAmount ?? this.incrementAmount,
      incrementUnit: incrementUnit ?? this.incrementUnit,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<int>(workoutId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (sets.present) {
      map['sets'] = Variable<int>(sets.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (exercise.present) {
      map['exercise'] = Variable<String>(
        $WorkoutExercisesTable.$converterexercise.toSql(exercise.value),
      );
    }
    if (targetWeightKg.present) {
      map['target_weight_kg'] = Variable<double>(targetWeightKg.value);
    }
    if (targetMinutes.present) {
      map['target_minutes'] = Variable<int>(targetMinutes.value);
    }
    if (targetSpeedKmh.present) {
      map['target_speed_kmh'] = Variable<double>(targetSpeedKmh.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    if (incrementAmount.present) {
      map['increment_amount'] = Variable<double>(incrementAmount.value);
    }
    if (incrementUnit.present) {
      map['increment_unit'] = Variable<String>(incrementUnit.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExercisesCompanion(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('position: $position, ')
          ..write('sets: $sets, ')
          ..write('reps: $reps, ')
          ..write('exercise: $exercise, ')
          ..write('targetWeightKg: $targetWeightKg, ')
          ..write('targetMinutes: $targetMinutes, ')
          ..write('targetSpeedKmh: $targetSpeedKmh, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('incrementAmount: $incrementAmount, ')
          ..write('incrementUnit: $incrementUnit')
          ..write(')'))
        .toString();
  }
}

class $RoutineWeekdaysTable extends RoutineWeekdays
    with TableInfo<$RoutineWeekdaysTable, RoutineWeekday> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineWeekdaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<int> routineId = GeneratedColumn<int>(
    'routine_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routines (id)',
    ),
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isRestMeta = const VerificationMeta('isRest');
  @override
  late final GeneratedColumn<bool> isRest = GeneratedColumn<bool>(
    'is_rest',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_rest" IN (0, 1))',
    ),
  );
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<int> workoutId = GeneratedColumn<int>(
    'workout_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workouts (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [routineId, weekday, isRest, workoutId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_weekdays';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineWeekday> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('is_rest')) {
      context.handle(
        _isRestMeta,
        isRest.isAcceptableOrUnknown(data['is_rest']!, _isRestMeta),
      );
    } else if (isInserting) {
      context.missing(_isRestMeta);
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {routineId, weekday};
  @override
  RoutineWeekday map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineWeekday(
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}routine_id'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      isRest: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_rest'],
      )!,
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout_id'],
      ),
    );
  }

  @override
  $RoutineWeekdaysTable createAlias(String alias) {
    return $RoutineWeekdaysTable(attachedDatabase, alias);
  }
}

class RoutineWeekday extends DataClass implements Insertable<RoutineWeekday> {
  final int routineId;
  final int weekday;
  final bool isRest;
  final int? workoutId;
  const RoutineWeekday({
    required this.routineId,
    required this.weekday,
    required this.isRest,
    this.workoutId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['routine_id'] = Variable<int>(routineId);
    map['weekday'] = Variable<int>(weekday);
    map['is_rest'] = Variable<bool>(isRest);
    if (!nullToAbsent || workoutId != null) {
      map['workout_id'] = Variable<int>(workoutId);
    }
    return map;
  }

  RoutineWeekdaysCompanion toCompanion(bool nullToAbsent) {
    return RoutineWeekdaysCompanion(
      routineId: Value(routineId),
      weekday: Value(weekday),
      isRest: Value(isRest),
      workoutId: workoutId == null && nullToAbsent
          ? const Value.absent()
          : Value(workoutId),
    );
  }

  factory RoutineWeekday.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineWeekday(
      routineId: serializer.fromJson<int>(json['routineId']),
      weekday: serializer.fromJson<int>(json['weekday']),
      isRest: serializer.fromJson<bool>(json['isRest']),
      workoutId: serializer.fromJson<int?>(json['workoutId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'routineId': serializer.toJson<int>(routineId),
      'weekday': serializer.toJson<int>(weekday),
      'isRest': serializer.toJson<bool>(isRest),
      'workoutId': serializer.toJson<int?>(workoutId),
    };
  }

  RoutineWeekday copyWith({
    int? routineId,
    int? weekday,
    bool? isRest,
    Value<int?> workoutId = const Value.absent(),
  }) => RoutineWeekday(
    routineId: routineId ?? this.routineId,
    weekday: weekday ?? this.weekday,
    isRest: isRest ?? this.isRest,
    workoutId: workoutId.present ? workoutId.value : this.workoutId,
  );
  RoutineWeekday copyWithCompanion(RoutineWeekdaysCompanion data) {
    return RoutineWeekday(
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      isRest: data.isRest.present ? data.isRest.value : this.isRest,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineWeekday(')
          ..write('routineId: $routineId, ')
          ..write('weekday: $weekday, ')
          ..write('isRest: $isRest, ')
          ..write('workoutId: $workoutId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(routineId, weekday, isRest, workoutId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineWeekday &&
          other.routineId == this.routineId &&
          other.weekday == this.weekday &&
          other.isRest == this.isRest &&
          other.workoutId == this.workoutId);
}

class RoutineWeekdaysCompanion extends UpdateCompanion<RoutineWeekday> {
  final Value<int> routineId;
  final Value<int> weekday;
  final Value<bool> isRest;
  final Value<int?> workoutId;
  final Value<int> rowid;
  const RoutineWeekdaysCompanion({
    this.routineId = const Value.absent(),
    this.weekday = const Value.absent(),
    this.isRest = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineWeekdaysCompanion.insert({
    required int routineId,
    required int weekday,
    required bool isRest,
    this.workoutId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : routineId = Value(routineId),
       weekday = Value(weekday),
       isRest = Value(isRest);
  static Insertable<RoutineWeekday> custom({
    Expression<int>? routineId,
    Expression<int>? weekday,
    Expression<bool>? isRest,
    Expression<int>? workoutId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (routineId != null) 'routine_id': routineId,
      if (weekday != null) 'weekday': weekday,
      if (isRest != null) 'is_rest': isRest,
      if (workoutId != null) 'workout_id': workoutId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineWeekdaysCompanion copyWith({
    Value<int>? routineId,
    Value<int>? weekday,
    Value<bool>? isRest,
    Value<int?>? workoutId,
    Value<int>? rowid,
  }) {
    return RoutineWeekdaysCompanion(
      routineId: routineId ?? this.routineId,
      weekday: weekday ?? this.weekday,
      isRest: isRest ?? this.isRest,
      workoutId: workoutId ?? this.workoutId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (routineId.present) {
      map['routine_id'] = Variable<int>(routineId.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (isRest.present) {
      map['is_rest'] = Variable<bool>(isRest.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<int>(workoutId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineWeekdaysCompanion(')
          ..write('routineId: $routineId, ')
          ..write('weekday: $weekday, ')
          ..write('isRest: $isRest, ')
          ..write('workoutId: $workoutId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrainingSlotsTable extends TrainingSlots
    with TableInfo<$TrainingSlotsTable, TrainingSlot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrainingSlotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<int> routineId = GeneratedColumn<int>(
    'routine_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routines (id)',
    ),
  );
  static const VerificationMeta _sequenceIndexMeta = const VerificationMeta(
    'sequenceIndex',
  );
  @override
  late final GeneratedColumn<int> sequenceIndex = GeneratedColumn<int>(
    'sequence_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<int> workoutId = GeneratedColumn<int>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workouts (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    routineId,
    sequenceIndex,
    workoutId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'training_slots';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrainingSlot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('sequence_index')) {
      context.handle(
        _sequenceIndexMeta,
        sequenceIndex.isAcceptableOrUnknown(
          data['sequence_index']!,
          _sequenceIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sequenceIndexMeta);
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {routineId, sequenceIndex},
  ];
  @override
  TrainingSlot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrainingSlot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}routine_id'],
      )!,
      sequenceIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence_index'],
      )!,
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout_id'],
      )!,
    );
  }

  @override
  $TrainingSlotsTable createAlias(String alias) {
    return $TrainingSlotsTable(attachedDatabase, alias);
  }
}

class TrainingSlot extends DataClass implements Insertable<TrainingSlot> {
  final int id;
  final int routineId;
  final int sequenceIndex;
  final int workoutId;
  const TrainingSlot({
    required this.id,
    required this.routineId,
    required this.sequenceIndex,
    required this.workoutId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['routine_id'] = Variable<int>(routineId);
    map['sequence_index'] = Variable<int>(sequenceIndex);
    map['workout_id'] = Variable<int>(workoutId);
    return map;
  }

  TrainingSlotsCompanion toCompanion(bool nullToAbsent) {
    return TrainingSlotsCompanion(
      id: Value(id),
      routineId: Value(routineId),
      sequenceIndex: Value(sequenceIndex),
      workoutId: Value(workoutId),
    );
  }

  factory TrainingSlot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrainingSlot(
      id: serializer.fromJson<int>(json['id']),
      routineId: serializer.fromJson<int>(json['routineId']),
      sequenceIndex: serializer.fromJson<int>(json['sequenceIndex']),
      workoutId: serializer.fromJson<int>(json['workoutId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'routineId': serializer.toJson<int>(routineId),
      'sequenceIndex': serializer.toJson<int>(sequenceIndex),
      'workoutId': serializer.toJson<int>(workoutId),
    };
  }

  TrainingSlot copyWith({
    int? id,
    int? routineId,
    int? sequenceIndex,
    int? workoutId,
  }) => TrainingSlot(
    id: id ?? this.id,
    routineId: routineId ?? this.routineId,
    sequenceIndex: sequenceIndex ?? this.sequenceIndex,
    workoutId: workoutId ?? this.workoutId,
  );
  TrainingSlot copyWithCompanion(TrainingSlotsCompanion data) {
    return TrainingSlot(
      id: data.id.present ? data.id.value : this.id,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      sequenceIndex: data.sequenceIndex.present
          ? data.sequenceIndex.value
          : this.sequenceIndex,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrainingSlot(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('sequenceIndex: $sequenceIndex, ')
          ..write('workoutId: $workoutId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, routineId, sequenceIndex, workoutId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrainingSlot &&
          other.id == this.id &&
          other.routineId == this.routineId &&
          other.sequenceIndex == this.sequenceIndex &&
          other.workoutId == this.workoutId);
}

class TrainingSlotsCompanion extends UpdateCompanion<TrainingSlot> {
  final Value<int> id;
  final Value<int> routineId;
  final Value<int> sequenceIndex;
  final Value<int> workoutId;
  const TrainingSlotsCompanion({
    this.id = const Value.absent(),
    this.routineId = const Value.absent(),
    this.sequenceIndex = const Value.absent(),
    this.workoutId = const Value.absent(),
  });
  TrainingSlotsCompanion.insert({
    this.id = const Value.absent(),
    required int routineId,
    required int sequenceIndex,
    required int workoutId,
  }) : routineId = Value(routineId),
       sequenceIndex = Value(sequenceIndex),
       workoutId = Value(workoutId);
  static Insertable<TrainingSlot> custom({
    Expression<int>? id,
    Expression<int>? routineId,
    Expression<int>? sequenceIndex,
    Expression<int>? workoutId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineId != null) 'routine_id': routineId,
      if (sequenceIndex != null) 'sequence_index': sequenceIndex,
      if (workoutId != null) 'workout_id': workoutId,
    });
  }

  TrainingSlotsCompanion copyWith({
    Value<int>? id,
    Value<int>? routineId,
    Value<int>? sequenceIndex,
    Value<int>? workoutId,
  }) {
    return TrainingSlotsCompanion(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      sequenceIndex: sequenceIndex ?? this.sequenceIndex,
      workoutId: workoutId ?? this.workoutId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (routineId.present) {
      map['routine_id'] = Variable<int>(routineId.value);
    }
    if (sequenceIndex.present) {
      map['sequence_index'] = Variable<int>(sequenceIndex.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<int>(workoutId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrainingSlotsCompanion(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('sequenceIndex: $sequenceIndex, ')
          ..write('workoutId: $workoutId')
          ..write(')'))
        .toString();
  }
}

class $ExerciseStartsTable extends ExerciseStarts
    with TableInfo<$ExerciseStartsTable, ExerciseStart> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseStartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<int> routineId = GeneratedColumn<int>(
    'routine_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routines (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Exercise, String> exercise =
      GeneratedColumn<String>(
        'exercise',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Exercise>($ExerciseStartsTable.$converterexercise);
  static const VerificationMeta _startWeightKgMeta = const VerificationMeta(
    'startWeightKg',
  );
  @override
  late final GeneratedColumn<double> startWeightKg = GeneratedColumn<double>(
    'start_weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [routineId, exercise, startWeightKg];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_starts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseStart> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('start_weight_kg')) {
      context.handle(
        _startWeightKgMeta,
        startWeightKg.isAcceptableOrUnknown(
          data['start_weight_kg']!,
          _startWeightKgMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startWeightKgMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {routineId, exercise};
  @override
  ExerciseStart map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseStart(
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}routine_id'],
      )!,
      exercise: $ExerciseStartsTable.$converterexercise.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}exercise'],
        )!,
      ),
      startWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}start_weight_kg'],
      )!,
    );
  }

  @override
  $ExerciseStartsTable createAlias(String alias) {
    return $ExerciseStartsTable(attachedDatabase, alias);
  }

  static TypeConverter<Exercise, String> $converterexercise =
      const ExerciseConverter();
}

class ExerciseStart extends DataClass implements Insertable<ExerciseStart> {
  final int routineId;
  final Exercise exercise;
  final double startWeightKg;
  const ExerciseStart({
    required this.routineId,
    required this.exercise,
    required this.startWeightKg,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['routine_id'] = Variable<int>(routineId);
    {
      map['exercise'] = Variable<String>(
        $ExerciseStartsTable.$converterexercise.toSql(exercise),
      );
    }
    map['start_weight_kg'] = Variable<double>(startWeightKg);
    return map;
  }

  ExerciseStartsCompanion toCompanion(bool nullToAbsent) {
    return ExerciseStartsCompanion(
      routineId: Value(routineId),
      exercise: Value(exercise),
      startWeightKg: Value(startWeightKg),
    );
  }

  factory ExerciseStart.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseStart(
      routineId: serializer.fromJson<int>(json['routineId']),
      exercise: serializer.fromJson<Exercise>(json['exercise']),
      startWeightKg: serializer.fromJson<double>(json['startWeightKg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'routineId': serializer.toJson<int>(routineId),
      'exercise': serializer.toJson<Exercise>(exercise),
      'startWeightKg': serializer.toJson<double>(startWeightKg),
    };
  }

  ExerciseStart copyWith({
    int? routineId,
    Exercise? exercise,
    double? startWeightKg,
  }) => ExerciseStart(
    routineId: routineId ?? this.routineId,
    exercise: exercise ?? this.exercise,
    startWeightKg: startWeightKg ?? this.startWeightKg,
  );
  ExerciseStart copyWithCompanion(ExerciseStartsCompanion data) {
    return ExerciseStart(
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      exercise: data.exercise.present ? data.exercise.value : this.exercise,
      startWeightKg: data.startWeightKg.present
          ? data.startWeightKg.value
          : this.startWeightKg,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseStart(')
          ..write('routineId: $routineId, ')
          ..write('exercise: $exercise, ')
          ..write('startWeightKg: $startWeightKg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(routineId, exercise, startWeightKg);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseStart &&
          other.routineId == this.routineId &&
          other.exercise == this.exercise &&
          other.startWeightKg == this.startWeightKg);
}

class ExerciseStartsCompanion extends UpdateCompanion<ExerciseStart> {
  final Value<int> routineId;
  final Value<Exercise> exercise;
  final Value<double> startWeightKg;
  final Value<int> rowid;
  const ExerciseStartsCompanion({
    this.routineId = const Value.absent(),
    this.exercise = const Value.absent(),
    this.startWeightKg = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExerciseStartsCompanion.insert({
    required int routineId,
    required Exercise exercise,
    required double startWeightKg,
    this.rowid = const Value.absent(),
  }) : routineId = Value(routineId),
       exercise = Value(exercise),
       startWeightKg = Value(startWeightKg);
  static Insertable<ExerciseStart> custom({
    Expression<int>? routineId,
    Expression<String>? exercise,
    Expression<double>? startWeightKg,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (routineId != null) 'routine_id': routineId,
      if (exercise != null) 'exercise': exercise,
      if (startWeightKg != null) 'start_weight_kg': startWeightKg,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExerciseStartsCompanion copyWith({
    Value<int>? routineId,
    Value<Exercise>? exercise,
    Value<double>? startWeightKg,
    Value<int>? rowid,
  }) {
    return ExerciseStartsCompanion(
      routineId: routineId ?? this.routineId,
      exercise: exercise ?? this.exercise,
      startWeightKg: startWeightKg ?? this.startWeightKg,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (routineId.present) {
      map['routine_id'] = Variable<int>(routineId.value);
    }
    if (exercise.present) {
      map['exercise'] = Variable<String>(
        $ExerciseStartsTable.$converterexercise.toSql(exercise.value),
      );
    }
    if (startWeightKg.present) {
      map['start_weight_kg'] = Variable<double>(startWeightKg.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseStartsCompanion(')
          ..write('routineId: $routineId, ')
          ..write('exercise: $exercise, ')
          ..write('startWeightKg: $startWeightKg, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<int> routineId = GeneratedColumn<int>(
    'routine_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routines (id)',
    ),
  );
  static const VerificationMeta _loggedOnMeta = const VerificationMeta(
    'loggedOn',
  );
  @override
  late final GeneratedColumn<String> loggedOn = GeneratedColumn<String>(
    'logged_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trainingSlotIdMeta = const VerificationMeta(
    'trainingSlotId',
  );
  @override
  late final GeneratedColumn<int> trainingSlotId = GeneratedColumn<int>(
    'training_slot_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES training_slots (id)',
    ),
  );
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<int> workoutId = GeneratedColumn<int>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workouts (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    routineId,
    loggedOn,
    trainingSlotId,
    workoutId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('logged_on')) {
      context.handle(
        _loggedOnMeta,
        loggedOn.isAcceptableOrUnknown(data['logged_on']!, _loggedOnMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedOnMeta);
    }
    if (data.containsKey('training_slot_id')) {
      context.handle(
        _trainingSlotIdMeta,
        trainingSlotId.isAcceptableOrUnknown(
          data['training_slot_id']!,
          _trainingSlotIdMeta,
        ),
      );
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {routineId, loggedOn},
  ];
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}routine_id'],
      )!,
      loggedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logged_on'],
      )!,
      trainingSlotId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}training_slot_id'],
      ),
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout_id'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final int routineId;
  final String loggedOn;
  final int? trainingSlotId;
  final int workoutId;
  const Session({
    required this.id,
    required this.routineId,
    required this.loggedOn,
    this.trainingSlotId,
    required this.workoutId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['routine_id'] = Variable<int>(routineId);
    map['logged_on'] = Variable<String>(loggedOn);
    if (!nullToAbsent || trainingSlotId != null) {
      map['training_slot_id'] = Variable<int>(trainingSlotId);
    }
    map['workout_id'] = Variable<int>(workoutId);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      routineId: Value(routineId),
      loggedOn: Value(loggedOn),
      trainingSlotId: trainingSlotId == null && nullToAbsent
          ? const Value.absent()
          : Value(trainingSlotId),
      workoutId: Value(workoutId),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      routineId: serializer.fromJson<int>(json['routineId']),
      loggedOn: serializer.fromJson<String>(json['loggedOn']),
      trainingSlotId: serializer.fromJson<int?>(json['trainingSlotId']),
      workoutId: serializer.fromJson<int>(json['workoutId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'routineId': serializer.toJson<int>(routineId),
      'loggedOn': serializer.toJson<String>(loggedOn),
      'trainingSlotId': serializer.toJson<int?>(trainingSlotId),
      'workoutId': serializer.toJson<int>(workoutId),
    };
  }

  Session copyWith({
    int? id,
    int? routineId,
    String? loggedOn,
    Value<int?> trainingSlotId = const Value.absent(),
    int? workoutId,
  }) => Session(
    id: id ?? this.id,
    routineId: routineId ?? this.routineId,
    loggedOn: loggedOn ?? this.loggedOn,
    trainingSlotId: trainingSlotId.present
        ? trainingSlotId.value
        : this.trainingSlotId,
    workoutId: workoutId ?? this.workoutId,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      loggedOn: data.loggedOn.present ? data.loggedOn.value : this.loggedOn,
      trainingSlotId: data.trainingSlotId.present
          ? data.trainingSlotId.value
          : this.trainingSlotId,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('loggedOn: $loggedOn, ')
          ..write('trainingSlotId: $trainingSlotId, ')
          ..write('workoutId: $workoutId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, routineId, loggedOn, trainingSlotId, workoutId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.routineId == this.routineId &&
          other.loggedOn == this.loggedOn &&
          other.trainingSlotId == this.trainingSlotId &&
          other.workoutId == this.workoutId);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<int> routineId;
  final Value<String> loggedOn;
  final Value<int?> trainingSlotId;
  final Value<int> workoutId;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.routineId = const Value.absent(),
    this.loggedOn = const Value.absent(),
    this.trainingSlotId = const Value.absent(),
    this.workoutId = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required int routineId,
    required String loggedOn,
    this.trainingSlotId = const Value.absent(),
    required int workoutId,
  }) : routineId = Value(routineId),
       loggedOn = Value(loggedOn),
       workoutId = Value(workoutId);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<int>? routineId,
    Expression<String>? loggedOn,
    Expression<int>? trainingSlotId,
    Expression<int>? workoutId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineId != null) 'routine_id': routineId,
      if (loggedOn != null) 'logged_on': loggedOn,
      if (trainingSlotId != null) 'training_slot_id': trainingSlotId,
      if (workoutId != null) 'workout_id': workoutId,
    });
  }

  SessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? routineId,
    Value<String>? loggedOn,
    Value<int?>? trainingSlotId,
    Value<int>? workoutId,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      loggedOn: loggedOn ?? this.loggedOn,
      trainingSlotId: trainingSlotId ?? this.trainingSlotId,
      workoutId: workoutId ?? this.workoutId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (routineId.present) {
      map['routine_id'] = Variable<int>(routineId.value);
    }
    if (loggedOn.present) {
      map['logged_on'] = Variable<String>(loggedOn.value);
    }
    if (trainingSlotId.present) {
      map['training_slot_id'] = Variable<int>(trainingSlotId.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<int>(workoutId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('loggedOn: $loggedOn, ')
          ..write('trainingSlotId: $trainingSlotId, ')
          ..write('workoutId: $workoutId')
          ..write(')'))
        .toString();
  }
}

class $ExerciseLogsTable extends ExerciseLogs
    with TableInfo<$ExerciseLogsTable, ExerciseLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Exercise, String> exercise =
      GeneratedColumn<String>(
        'exercise',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Exercise>($ExerciseLogsTable.$converterexercise);
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetRepsMeta = const VerificationMeta(
    'targetReps',
  );
  @override
  late final GeneratedColumn<int> targetReps = GeneratedColumn<int>(
    'target_reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    exercise,
    weightKg,
    targetReps,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('target_reps')) {
      context.handle(
        _targetRepsMeta,
        targetReps.isAcceptableOrUnknown(data['target_reps']!, _targetRepsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      exercise: $ExerciseLogsTable.$converterexercise.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}exercise'],
        )!,
      ),
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      targetReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_reps'],
      ),
    );
  }

  @override
  $ExerciseLogsTable createAlias(String alias) {
    return $ExerciseLogsTable(attachedDatabase, alias);
  }

  static TypeConverter<Exercise, String> $converterexercise =
      const ExerciseConverter();
}

class ExerciseLog extends DataClass implements Insertable<ExerciseLog> {
  final int id;
  final int sessionId;
  final Exercise exercise;
  final double weightKg;

  /// Reps this log belongs to, so 4-rep and 8-rep bench stay separate.
  final int? targetReps;
  const ExerciseLog({
    required this.id,
    required this.sessionId,
    required this.exercise,
    required this.weightKg,
    this.targetReps,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    {
      map['exercise'] = Variable<String>(
        $ExerciseLogsTable.$converterexercise.toSql(exercise),
      );
    }
    map['weight_kg'] = Variable<double>(weightKg);
    if (!nullToAbsent || targetReps != null) {
      map['target_reps'] = Variable<int>(targetReps);
    }
    return map;
  }

  ExerciseLogsCompanion toCompanion(bool nullToAbsent) {
    return ExerciseLogsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      exercise: Value(exercise),
      weightKg: Value(weightKg),
      targetReps: targetReps == null && nullToAbsent
          ? const Value.absent()
          : Value(targetReps),
    );
  }

  factory ExerciseLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseLog(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      exercise: serializer.fromJson<Exercise>(json['exercise']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      targetReps: serializer.fromJson<int?>(json['targetReps']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'exercise': serializer.toJson<Exercise>(exercise),
      'weightKg': serializer.toJson<double>(weightKg),
      'targetReps': serializer.toJson<int?>(targetReps),
    };
  }

  ExerciseLog copyWith({
    int? id,
    int? sessionId,
    Exercise? exercise,
    double? weightKg,
    Value<int?> targetReps = const Value.absent(),
  }) => ExerciseLog(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    exercise: exercise ?? this.exercise,
    weightKg: weightKg ?? this.weightKg,
    targetReps: targetReps.present ? targetReps.value : this.targetReps,
  );
  ExerciseLog copyWithCompanion(ExerciseLogsCompanion data) {
    return ExerciseLog(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exercise: data.exercise.present ? data.exercise.value : this.exercise,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      targetReps: data.targetReps.present
          ? data.targetReps.value
          : this.targetReps,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseLog(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exercise: $exercise, ')
          ..write('weightKg: $weightKg, ')
          ..write('targetReps: $targetReps')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionId, exercise, weightKg, targetReps);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseLog &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.exercise == this.exercise &&
          other.weightKg == this.weightKg &&
          other.targetReps == this.targetReps);
}

class ExerciseLogsCompanion extends UpdateCompanion<ExerciseLog> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<Exercise> exercise;
  final Value<double> weightKg;
  final Value<int?> targetReps;
  const ExerciseLogsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exercise = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.targetReps = const Value.absent(),
  });
  ExerciseLogsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required Exercise exercise,
    required double weightKg,
    this.targetReps = const Value.absent(),
  }) : sessionId = Value(sessionId),
       exercise = Value(exercise),
       weightKg = Value(weightKg);
  static Insertable<ExerciseLog> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<String>? exercise,
    Expression<double>? weightKg,
    Expression<int>? targetReps,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (exercise != null) 'exercise': exercise,
      if (weightKg != null) 'weight_kg': weightKg,
      if (targetReps != null) 'target_reps': targetReps,
    });
  }

  ExerciseLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<Exercise>? exercise,
    Value<double>? weightKg,
    Value<int?>? targetReps,
  }) {
    return ExerciseLogsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exercise: exercise ?? this.exercise,
      weightKg: weightKg ?? this.weightKg,
      targetReps: targetReps ?? this.targetReps,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (exercise.present) {
      map['exercise'] = Variable<String>(
        $ExerciseLogsTable.$converterexercise.toSql(exercise.value),
      );
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (targetReps.present) {
      map['target_reps'] = Variable<int>(targetReps.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseLogsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exercise: $exercise, ')
          ..write('weightKg: $weightKg, ')
          ..write('targetReps: $targetReps')
          ..write(')'))
        .toString();
  }
}

class $SetLogsTable extends SetLogs with TableInfo<$SetLogsTable, SetLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _exerciseLogIdMeta = const VerificationMeta(
    'exerciseLogId',
  );
  @override
  late final GeneratedColumn<int> exerciseLogId = GeneratedColumn<int>(
    'exercise_log_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercise_logs (id)',
    ),
  );
  static const VerificationMeta _setIndexMeta = const VerificationMeta(
    'setIndex',
  );
  @override
  late final GeneratedColumn<int> setIndex = GeneratedColumn<int>(
    'set_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _speedKmhMeta = const VerificationMeta(
    'speedKmh',
  );
  @override
  late final GeneratedColumn<double> speedKmh = GeneratedColumn<double>(
    'speed_kmh',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationUnitMeta = const VerificationMeta(
    'durationUnit',
  );
  @override
  late final GeneratedColumn<String> durationUnit = GeneratedColumn<String>(
    'duration_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    exerciseLogId,
    setIndex,
    reps,
    weightKg,
    speedKmh,
    durationSeconds,
    durationUnit,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'set_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SetLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exercise_log_id')) {
      context.handle(
        _exerciseLogIdMeta,
        exerciseLogId.isAcceptableOrUnknown(
          data['exercise_log_id']!,
          _exerciseLogIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseLogIdMeta);
    }
    if (data.containsKey('set_index')) {
      context.handle(
        _setIndexMeta,
        setIndex.isAcceptableOrUnknown(data['set_index']!, _setIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_setIndexMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('speed_kmh')) {
      context.handle(
        _speedKmhMeta,
        speedKmh.isAcceptableOrUnknown(data['speed_kmh']!, _speedKmhMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('duration_unit')) {
      context.handle(
        _durationUnitMeta,
        durationUnit.isAcceptableOrUnknown(
          data['duration_unit']!,
          _durationUnitMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      exerciseLogId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_log_id'],
      )!,
      setIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_index'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      speedKmh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed_kmh'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
      durationUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}duration_unit'],
      ),
    );
  }

  @override
  $SetLogsTable createAlias(String alias) {
    return $SetLogsTable(attachedDatabase, alias);
  }
}

class SetLog extends DataClass implements Insertable<SetLog> {
  final int id;
  final int exerciseLogId;
  final int setIndex;
  final int reps;

  /// Strength sets keep their own weight. Cardio leaves this empty.
  final double? weightKg;

  /// Jogging and sprinting. Strength leaves these empty.
  final double? speedKmh;
  final int? durationSeconds;
  final String? durationUnit;
  const SetLog({
    required this.id,
    required this.exerciseLogId,
    required this.setIndex,
    required this.reps,
    this.weightKg,
    this.speedKmh,
    this.durationSeconds,
    this.durationUnit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exercise_log_id'] = Variable<int>(exerciseLogId);
    map['set_index'] = Variable<int>(setIndex);
    map['reps'] = Variable<int>(reps);
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || speedKmh != null) {
      map['speed_kmh'] = Variable<double>(speedKmh);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    if (!nullToAbsent || durationUnit != null) {
      map['duration_unit'] = Variable<String>(durationUnit);
    }
    return map;
  }

  SetLogsCompanion toCompanion(bool nullToAbsent) {
    return SetLogsCompanion(
      id: Value(id),
      exerciseLogId: Value(exerciseLogId),
      setIndex: Value(setIndex),
      reps: Value(reps),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      speedKmh: speedKmh == null && nullToAbsent
          ? const Value.absent()
          : Value(speedKmh),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      durationUnit: durationUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(durationUnit),
    );
  }

  factory SetLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetLog(
      id: serializer.fromJson<int>(json['id']),
      exerciseLogId: serializer.fromJson<int>(json['exerciseLogId']),
      setIndex: serializer.fromJson<int>(json['setIndex']),
      reps: serializer.fromJson<int>(json['reps']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      speedKmh: serializer.fromJson<double?>(json['speedKmh']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      durationUnit: serializer.fromJson<String?>(json['durationUnit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exerciseLogId': serializer.toJson<int>(exerciseLogId),
      'setIndex': serializer.toJson<int>(setIndex),
      'reps': serializer.toJson<int>(reps),
      'weightKg': serializer.toJson<double?>(weightKg),
      'speedKmh': serializer.toJson<double?>(speedKmh),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'durationUnit': serializer.toJson<String?>(durationUnit),
    };
  }

  SetLog copyWith({
    int? id,
    int? exerciseLogId,
    int? setIndex,
    int? reps,
    Value<double?> weightKg = const Value.absent(),
    Value<double?> speedKmh = const Value.absent(),
    Value<int?> durationSeconds = const Value.absent(),
    Value<String?> durationUnit = const Value.absent(),
  }) => SetLog(
    id: id ?? this.id,
    exerciseLogId: exerciseLogId ?? this.exerciseLogId,
    setIndex: setIndex ?? this.setIndex,
    reps: reps ?? this.reps,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    speedKmh: speedKmh.present ? speedKmh.value : this.speedKmh,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
    durationUnit: durationUnit.present ? durationUnit.value : this.durationUnit,
  );
  SetLog copyWithCompanion(SetLogsCompanion data) {
    return SetLog(
      id: data.id.present ? data.id.value : this.id,
      exerciseLogId: data.exerciseLogId.present
          ? data.exerciseLogId.value
          : this.exerciseLogId,
      setIndex: data.setIndex.present ? data.setIndex.value : this.setIndex,
      reps: data.reps.present ? data.reps.value : this.reps,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      speedKmh: data.speedKmh.present ? data.speedKmh.value : this.speedKmh,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      durationUnit: data.durationUnit.present
          ? data.durationUnit.value
          : this.durationUnit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetLog(')
          ..write('id: $id, ')
          ..write('exerciseLogId: $exerciseLogId, ')
          ..write('setIndex: $setIndex, ')
          ..write('reps: $reps, ')
          ..write('weightKg: $weightKg, ')
          ..write('speedKmh: $speedKmh, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('durationUnit: $durationUnit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    exerciseLogId,
    setIndex,
    reps,
    weightKg,
    speedKmh,
    durationSeconds,
    durationUnit,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetLog &&
          other.id == this.id &&
          other.exerciseLogId == this.exerciseLogId &&
          other.setIndex == this.setIndex &&
          other.reps == this.reps &&
          other.weightKg == this.weightKg &&
          other.speedKmh == this.speedKmh &&
          other.durationSeconds == this.durationSeconds &&
          other.durationUnit == this.durationUnit);
}

class SetLogsCompanion extends UpdateCompanion<SetLog> {
  final Value<int> id;
  final Value<int> exerciseLogId;
  final Value<int> setIndex;
  final Value<int> reps;
  final Value<double?> weightKg;
  final Value<double?> speedKmh;
  final Value<int?> durationSeconds;
  final Value<String?> durationUnit;
  const SetLogsCompanion({
    this.id = const Value.absent(),
    this.exerciseLogId = const Value.absent(),
    this.setIndex = const Value.absent(),
    this.reps = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.speedKmh = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.durationUnit = const Value.absent(),
  });
  SetLogsCompanion.insert({
    this.id = const Value.absent(),
    required int exerciseLogId,
    required int setIndex,
    required int reps,
    this.weightKg = const Value.absent(),
    this.speedKmh = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.durationUnit = const Value.absent(),
  }) : exerciseLogId = Value(exerciseLogId),
       setIndex = Value(setIndex),
       reps = Value(reps);
  static Insertable<SetLog> custom({
    Expression<int>? id,
    Expression<int>? exerciseLogId,
    Expression<int>? setIndex,
    Expression<int>? reps,
    Expression<double>? weightKg,
    Expression<double>? speedKmh,
    Expression<int>? durationSeconds,
    Expression<String>? durationUnit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseLogId != null) 'exercise_log_id': exerciseLogId,
      if (setIndex != null) 'set_index': setIndex,
      if (reps != null) 'reps': reps,
      if (weightKg != null) 'weight_kg': weightKg,
      if (speedKmh != null) 'speed_kmh': speedKmh,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (durationUnit != null) 'duration_unit': durationUnit,
    });
  }

  SetLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? exerciseLogId,
    Value<int>? setIndex,
    Value<int>? reps,
    Value<double?>? weightKg,
    Value<double?>? speedKmh,
    Value<int?>? durationSeconds,
    Value<String?>? durationUnit,
  }) {
    return SetLogsCompanion(
      id: id ?? this.id,
      exerciseLogId: exerciseLogId ?? this.exerciseLogId,
      setIndex: setIndex ?? this.setIndex,
      reps: reps ?? this.reps,
      weightKg: weightKg ?? this.weightKg,
      speedKmh: speedKmh ?? this.speedKmh,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      durationUnit: durationUnit ?? this.durationUnit,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exerciseLogId.present) {
      map['exercise_log_id'] = Variable<int>(exerciseLogId.value);
    }
    if (setIndex.present) {
      map['set_index'] = Variable<int>(setIndex.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (speedKmh.present) {
      map['speed_kmh'] = Variable<double>(speedKmh.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (durationUnit.present) {
      map['duration_unit'] = Variable<String>(durationUnit.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetLogsCompanion(')
          ..write('id: $id, ')
          ..write('exerciseLogId: $exerciseLogId, ')
          ..write('setIndex: $setIndex, ')
          ..write('reps: $reps, ')
          ..write('weightKg: $weightKg, ')
          ..write('speedKmh: $speedKmh, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('durationUnit: $durationUnit')
          ..write(')'))
        .toString();
  }
}

class $SprintIntervalTargetsTable extends SprintIntervalTargets
    with TableInfo<$SprintIntervalTargetsTable, SprintIntervalTarget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SprintIntervalTargetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _workoutExerciseIdMeta = const VerificationMeta(
    'workoutExerciseId',
  );
  @override
  late final GeneratedColumn<int> workoutExerciseId = GeneratedColumn<int>(
    'workout_exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_exercises (id)',
    ),
  );
  static const VerificationMeta _intervalIndexMeta = const VerificationMeta(
    'intervalIndex',
  );
  @override
  late final GeneratedColumn<int> intervalIndex = GeneratedColumn<int>(
    'interval_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speedKmhMeta = const VerificationMeta(
    'speedKmh',
  );
  @override
  late final GeneratedColumn<double> speedKmh = GeneratedColumn<double>(
    'speed_kmh',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationUnitMeta = const VerificationMeta(
    'durationUnit',
  );
  @override
  late final GeneratedColumn<String> durationUnit = GeneratedColumn<String>(
    'duration_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutExerciseId,
    intervalIndex,
    speedKmh,
    durationSeconds,
    durationUnit,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sprint_interval_targets';
  @override
  VerificationContext validateIntegrity(
    Insertable<SprintIntervalTarget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('workout_exercise_id')) {
      context.handle(
        _workoutExerciseIdMeta,
        workoutExerciseId.isAcceptableOrUnknown(
          data['workout_exercise_id']!,
          _workoutExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutExerciseIdMeta);
    }
    if (data.containsKey('interval_index')) {
      context.handle(
        _intervalIndexMeta,
        intervalIndex.isAcceptableOrUnknown(
          data['interval_index']!,
          _intervalIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_intervalIndexMeta);
    }
    if (data.containsKey('speed_kmh')) {
      context.handle(
        _speedKmhMeta,
        speedKmh.isAcceptableOrUnknown(data['speed_kmh']!, _speedKmhMeta),
      );
    } else if (isInserting) {
      context.missing(_speedKmhMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('duration_unit')) {
      context.handle(
        _durationUnitMeta,
        durationUnit.isAcceptableOrUnknown(
          data['duration_unit']!,
          _durationUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationUnitMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {workoutExerciseId, intervalIndex},
  ];
  @override
  SprintIntervalTarget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SprintIntervalTarget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      workoutExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout_exercise_id'],
      )!,
      intervalIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_index'],
      )!,
      speedKmh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed_kmh'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      durationUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}duration_unit'],
      )!,
    );
  }

  @override
  $SprintIntervalTargetsTable createAlias(String alias) {
    return $SprintIntervalTargetsTable(attachedDatabase, alias);
  }
}

class SprintIntervalTarget extends DataClass
    implements Insertable<SprintIntervalTarget> {
  final int id;
  final int workoutExerciseId;
  final int intervalIndex;
  final double speedKmh;
  final int durationSeconds;
  final String durationUnit;
  const SprintIntervalTarget({
    required this.id,
    required this.workoutExerciseId,
    required this.intervalIndex,
    required this.speedKmh,
    required this.durationSeconds,
    required this.durationUnit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['workout_exercise_id'] = Variable<int>(workoutExerciseId);
    map['interval_index'] = Variable<int>(intervalIndex);
    map['speed_kmh'] = Variable<double>(speedKmh);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['duration_unit'] = Variable<String>(durationUnit);
    return map;
  }

  SprintIntervalTargetsCompanion toCompanion(bool nullToAbsent) {
    return SprintIntervalTargetsCompanion(
      id: Value(id),
      workoutExerciseId: Value(workoutExerciseId),
      intervalIndex: Value(intervalIndex),
      speedKmh: Value(speedKmh),
      durationSeconds: Value(durationSeconds),
      durationUnit: Value(durationUnit),
    );
  }

  factory SprintIntervalTarget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SprintIntervalTarget(
      id: serializer.fromJson<int>(json['id']),
      workoutExerciseId: serializer.fromJson<int>(json['workoutExerciseId']),
      intervalIndex: serializer.fromJson<int>(json['intervalIndex']),
      speedKmh: serializer.fromJson<double>(json['speedKmh']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      durationUnit: serializer.fromJson<String>(json['durationUnit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workoutExerciseId': serializer.toJson<int>(workoutExerciseId),
      'intervalIndex': serializer.toJson<int>(intervalIndex),
      'speedKmh': serializer.toJson<double>(speedKmh),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'durationUnit': serializer.toJson<String>(durationUnit),
    };
  }

  SprintIntervalTarget copyWith({
    int? id,
    int? workoutExerciseId,
    int? intervalIndex,
    double? speedKmh,
    int? durationSeconds,
    String? durationUnit,
  }) => SprintIntervalTarget(
    id: id ?? this.id,
    workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
    intervalIndex: intervalIndex ?? this.intervalIndex,
    speedKmh: speedKmh ?? this.speedKmh,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    durationUnit: durationUnit ?? this.durationUnit,
  );
  SprintIntervalTarget copyWithCompanion(SprintIntervalTargetsCompanion data) {
    return SprintIntervalTarget(
      id: data.id.present ? data.id.value : this.id,
      workoutExerciseId: data.workoutExerciseId.present
          ? data.workoutExerciseId.value
          : this.workoutExerciseId,
      intervalIndex: data.intervalIndex.present
          ? data.intervalIndex.value
          : this.intervalIndex,
      speedKmh: data.speedKmh.present ? data.speedKmh.value : this.speedKmh,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      durationUnit: data.durationUnit.present
          ? data.durationUnit.value
          : this.durationUnit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SprintIntervalTarget(')
          ..write('id: $id, ')
          ..write('workoutExerciseId: $workoutExerciseId, ')
          ..write('intervalIndex: $intervalIndex, ')
          ..write('speedKmh: $speedKmh, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('durationUnit: $durationUnit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workoutExerciseId,
    intervalIndex,
    speedKmh,
    durationSeconds,
    durationUnit,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SprintIntervalTarget &&
          other.id == this.id &&
          other.workoutExerciseId == this.workoutExerciseId &&
          other.intervalIndex == this.intervalIndex &&
          other.speedKmh == this.speedKmh &&
          other.durationSeconds == this.durationSeconds &&
          other.durationUnit == this.durationUnit);
}

class SprintIntervalTargetsCompanion
    extends UpdateCompanion<SprintIntervalTarget> {
  final Value<int> id;
  final Value<int> workoutExerciseId;
  final Value<int> intervalIndex;
  final Value<double> speedKmh;
  final Value<int> durationSeconds;
  final Value<String> durationUnit;
  const SprintIntervalTargetsCompanion({
    this.id = const Value.absent(),
    this.workoutExerciseId = const Value.absent(),
    this.intervalIndex = const Value.absent(),
    this.speedKmh = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.durationUnit = const Value.absent(),
  });
  SprintIntervalTargetsCompanion.insert({
    this.id = const Value.absent(),
    required int workoutExerciseId,
    required int intervalIndex,
    required double speedKmh,
    required int durationSeconds,
    required String durationUnit,
  }) : workoutExerciseId = Value(workoutExerciseId),
       intervalIndex = Value(intervalIndex),
       speedKmh = Value(speedKmh),
       durationSeconds = Value(durationSeconds),
       durationUnit = Value(durationUnit);
  static Insertable<SprintIntervalTarget> custom({
    Expression<int>? id,
    Expression<int>? workoutExerciseId,
    Expression<int>? intervalIndex,
    Expression<double>? speedKmh,
    Expression<int>? durationSeconds,
    Expression<String>? durationUnit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutExerciseId != null) 'workout_exercise_id': workoutExerciseId,
      if (intervalIndex != null) 'interval_index': intervalIndex,
      if (speedKmh != null) 'speed_kmh': speedKmh,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (durationUnit != null) 'duration_unit': durationUnit,
    });
  }

  SprintIntervalTargetsCompanion copyWith({
    Value<int>? id,
    Value<int>? workoutExerciseId,
    Value<int>? intervalIndex,
    Value<double>? speedKmh,
    Value<int>? durationSeconds,
    Value<String>? durationUnit,
  }) {
    return SprintIntervalTargetsCompanion(
      id: id ?? this.id,
      workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
      intervalIndex: intervalIndex ?? this.intervalIndex,
      speedKmh: speedKmh ?? this.speedKmh,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      durationUnit: durationUnit ?? this.durationUnit,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workoutExerciseId.present) {
      map['workout_exercise_id'] = Variable<int>(workoutExerciseId.value);
    }
    if (intervalIndex.present) {
      map['interval_index'] = Variable<int>(intervalIndex.value);
    }
    if (speedKmh.present) {
      map['speed_kmh'] = Variable<double>(speedKmh.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (durationUnit.present) {
      map['duration_unit'] = Variable<String>(durationUnit.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SprintIntervalTargetsCompanion(')
          ..write('id: $id, ')
          ..write('workoutExerciseId: $workoutExerciseId, ')
          ..write('intervalIndex: $intervalIndex, ')
          ..write('speedKmh: $speedKmh, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('durationUnit: $durationUnit')
          ..write(')'))
        .toString();
  }
}

class $DayPicksTable extends DayPicks with TableInfo<$DayPicksTable, DayPick> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayPicksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<int> routineId = GeneratedColumn<int>(
    'routine_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routines (id)',
    ),
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<int> workoutId = GeneratedColumn<int>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workouts (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [routineId, day, workoutId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_picks';
  @override
  VerificationContext validateIntegrity(
    Insertable<DayPick> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {routineId, day};
  @override
  DayPick map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayPick(
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}routine_id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout_id'],
      )!,
    );
  }

  @override
  $DayPicksTable createAlias(String alias) {
    return $DayPicksTable(attachedDatabase, alias);
  }
}

class DayPick extends DataClass implements Insertable<DayPick> {
  final int routineId;
  final String day;
  final int workoutId;
  const DayPick({
    required this.routineId,
    required this.day,
    required this.workoutId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['routine_id'] = Variable<int>(routineId);
    map['day'] = Variable<String>(day);
    map['workout_id'] = Variable<int>(workoutId);
    return map;
  }

  DayPicksCompanion toCompanion(bool nullToAbsent) {
    return DayPicksCompanion(
      routineId: Value(routineId),
      day: Value(day),
      workoutId: Value(workoutId),
    );
  }

  factory DayPick.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayPick(
      routineId: serializer.fromJson<int>(json['routineId']),
      day: serializer.fromJson<String>(json['day']),
      workoutId: serializer.fromJson<int>(json['workoutId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'routineId': serializer.toJson<int>(routineId),
      'day': serializer.toJson<String>(day),
      'workoutId': serializer.toJson<int>(workoutId),
    };
  }

  DayPick copyWith({int? routineId, String? day, int? workoutId}) => DayPick(
    routineId: routineId ?? this.routineId,
    day: day ?? this.day,
    workoutId: workoutId ?? this.workoutId,
  );
  DayPick copyWithCompanion(DayPicksCompanion data) {
    return DayPick(
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      day: data.day.present ? data.day.value : this.day,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayPick(')
          ..write('routineId: $routineId, ')
          ..write('day: $day, ')
          ..write('workoutId: $workoutId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(routineId, day, workoutId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayPick &&
          other.routineId == this.routineId &&
          other.day == this.day &&
          other.workoutId == this.workoutId);
}

class DayPicksCompanion extends UpdateCompanion<DayPick> {
  final Value<int> routineId;
  final Value<String> day;
  final Value<int> workoutId;
  final Value<int> rowid;
  const DayPicksCompanion({
    this.routineId = const Value.absent(),
    this.day = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DayPicksCompanion.insert({
    required int routineId,
    required String day,
    required int workoutId,
    this.rowid = const Value.absent(),
  }) : routineId = Value(routineId),
       day = Value(day),
       workoutId = Value(workoutId);
  static Insertable<DayPick> custom({
    Expression<int>? routineId,
    Expression<String>? day,
    Expression<int>? workoutId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (routineId != null) 'routine_id': routineId,
      if (day != null) 'day': day,
      if (workoutId != null) 'workout_id': workoutId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DayPicksCompanion copyWith({
    Value<int>? routineId,
    Value<String>? day,
    Value<int>? workoutId,
    Value<int>? rowid,
  }) {
    return DayPicksCompanion(
      routineId: routineId ?? this.routineId,
      day: day ?? this.day,
      workoutId: workoutId ?? this.workoutId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (routineId.present) {
      map['routine_id'] = Variable<int>(routineId.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<int>(workoutId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayPicksCompanion(')
          ..write('routineId: $routineId, ')
          ..write('day: $day, ')
          ..write('workoutId: $workoutId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomExercisesTable extends CustomExercises
    with TableInfo<$CustomExercisesTable, CustomExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _storageKeyMeta = const VerificationMeta(
    'storageKey',
  );
  @override
  late final GeneratedColumn<String> storageKey = GeneratedColumn<String>(
    'storage_key',
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
  static const VerificationMeta _muscleGroupMeta = const VerificationMeta(
    'muscleGroup',
  );
  @override
  late final GeneratedColumn<String> muscleGroup = GeneratedColumn<String>(
    'muscle_group',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _equipmentMeta = const VerificationMeta(
    'equipment',
  );
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
    'equipment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('strength'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    storageKey,
    name,
    muscleGroup,
    equipment,
    kind,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('storage_key')) {
      context.handle(
        _storageKeyMeta,
        storageKey.isAcceptableOrUnknown(data['storage_key']!, _storageKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_storageKeyMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('muscle_group')) {
      context.handle(
        _muscleGroupMeta,
        muscleGroup.isAcceptableOrUnknown(
          data['muscle_group']!,
          _muscleGroupMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_muscleGroupMeta);
    }
    if (data.containsKey('equipment')) {
      context.handle(
        _equipmentMeta,
        equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta),
      );
    } else if (isInserting) {
      context.missing(_equipmentMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {storageKey};
  @override
  CustomExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomExercise(
      storageKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}storage_key'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      muscleGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}muscle_group'],
      )!,
      equipment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
    );
  }

  @override
  $CustomExercisesTable createAlias(String alias) {
    return $CustomExercisesTable(attachedDatabase, alias);
  }
}

class CustomExercise extends DataClass implements Insertable<CustomExercise> {
  final String storageKey;
  final String name;
  final String muscleGroup;
  final String equipment;
  final String kind;
  const CustomExercise({
    required this.storageKey,
    required this.name,
    required this.muscleGroup,
    required this.equipment,
    required this.kind,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['storage_key'] = Variable<String>(storageKey);
    map['name'] = Variable<String>(name);
    map['muscle_group'] = Variable<String>(muscleGroup);
    map['equipment'] = Variable<String>(equipment);
    map['kind'] = Variable<String>(kind);
    return map;
  }

  CustomExercisesCompanion toCompanion(bool nullToAbsent) {
    return CustomExercisesCompanion(
      storageKey: Value(storageKey),
      name: Value(name),
      muscleGroup: Value(muscleGroup),
      equipment: Value(equipment),
      kind: Value(kind),
    );
  }

  factory CustomExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomExercise(
      storageKey: serializer.fromJson<String>(json['storageKey']),
      name: serializer.fromJson<String>(json['name']),
      muscleGroup: serializer.fromJson<String>(json['muscleGroup']),
      equipment: serializer.fromJson<String>(json['equipment']),
      kind: serializer.fromJson<String>(json['kind']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'storageKey': serializer.toJson<String>(storageKey),
      'name': serializer.toJson<String>(name),
      'muscleGroup': serializer.toJson<String>(muscleGroup),
      'equipment': serializer.toJson<String>(equipment),
      'kind': serializer.toJson<String>(kind),
    };
  }

  CustomExercise copyWith({
    String? storageKey,
    String? name,
    String? muscleGroup,
    String? equipment,
    String? kind,
  }) => CustomExercise(
    storageKey: storageKey ?? this.storageKey,
    name: name ?? this.name,
    muscleGroup: muscleGroup ?? this.muscleGroup,
    equipment: equipment ?? this.equipment,
    kind: kind ?? this.kind,
  );
  CustomExercise copyWithCompanion(CustomExercisesCompanion data) {
    return CustomExercise(
      storageKey: data.storageKey.present
          ? data.storageKey.value
          : this.storageKey,
      name: data.name.present ? data.name.value : this.name,
      muscleGroup: data.muscleGroup.present
          ? data.muscleGroup.value
          : this.muscleGroup,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      kind: data.kind.present ? data.kind.value : this.kind,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomExercise(')
          ..write('storageKey: $storageKey, ')
          ..write('name: $name, ')
          ..write('muscleGroup: $muscleGroup, ')
          ..write('equipment: $equipment, ')
          ..write('kind: $kind')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(storageKey, name, muscleGroup, equipment, kind);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomExercise &&
          other.storageKey == this.storageKey &&
          other.name == this.name &&
          other.muscleGroup == this.muscleGroup &&
          other.equipment == this.equipment &&
          other.kind == this.kind);
}

class CustomExercisesCompanion extends UpdateCompanion<CustomExercise> {
  final Value<String> storageKey;
  final Value<String> name;
  final Value<String> muscleGroup;
  final Value<String> equipment;
  final Value<String> kind;
  final Value<int> rowid;
  const CustomExercisesCompanion({
    this.storageKey = const Value.absent(),
    this.name = const Value.absent(),
    this.muscleGroup = const Value.absent(),
    this.equipment = const Value.absent(),
    this.kind = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomExercisesCompanion.insert({
    required String storageKey,
    required String name,
    required String muscleGroup,
    required String equipment,
    this.kind = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : storageKey = Value(storageKey),
       name = Value(name),
       muscleGroup = Value(muscleGroup),
       equipment = Value(equipment);
  static Insertable<CustomExercise> custom({
    Expression<String>? storageKey,
    Expression<String>? name,
    Expression<String>? muscleGroup,
    Expression<String>? equipment,
    Expression<String>? kind,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (storageKey != null) 'storage_key': storageKey,
      if (name != null) 'name': name,
      if (muscleGroup != null) 'muscle_group': muscleGroup,
      if (equipment != null) 'equipment': equipment,
      if (kind != null) 'kind': kind,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomExercisesCompanion copyWith({
    Value<String>? storageKey,
    Value<String>? name,
    Value<String>? muscleGroup,
    Value<String>? equipment,
    Value<String>? kind,
    Value<int>? rowid,
  }) {
    return CustomExercisesCompanion(
      storageKey: storageKey ?? this.storageKey,
      name: name ?? this.name,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      equipment: equipment ?? this.equipment,
      kind: kind ?? this.kind,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (storageKey.present) {
      map['storage_key'] = Variable<String>(storageKey.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (muscleGroup.present) {
      map['muscle_group'] = Variable<String>(muscleGroup.value);
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomExercisesCompanion(')
          ..write('storageKey: $storageKey, ')
          ..write('name: $name, ')
          ..write('muscleGroup: $muscleGroup, ')
          ..write('equipment: $equipment, ')
          ..write('kind: $kind, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RoutinesTable routines = $RoutinesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $WorkoutsTable workouts = $WorkoutsTable(this);
  late final $WorkoutExercisesTable workoutExercises = $WorkoutExercisesTable(
    this,
  );
  late final $RoutineWeekdaysTable routineWeekdays = $RoutineWeekdaysTable(
    this,
  );
  late final $TrainingSlotsTable trainingSlots = $TrainingSlotsTable(this);
  late final $ExerciseStartsTable exerciseStarts = $ExerciseStartsTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $ExerciseLogsTable exerciseLogs = $ExerciseLogsTable(this);
  late final $SetLogsTable setLogs = $SetLogsTable(this);
  late final $SprintIntervalTargetsTable sprintIntervalTargets =
      $SprintIntervalTargetsTable(this);
  late final $DayPicksTable dayPicks = $DayPicksTable(this);
  late final $CustomExercisesTable customExercises = $CustomExercisesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    routines,
    appSettings,
    workouts,
    workoutExercises,
    routineWeekdays,
    trainingSlots,
    exerciseStarts,
    sessions,
    exerciseLogs,
    setLogs,
    sprintIntervalTargets,
    dayPicks,
    customExercises,
  ];
}

typedef $$RoutinesTableCreateCompanionBuilder = RoutinesCompanion Function({
  Value<int> id,
  required String name,
  Value<DateTime> createdAt,
  Value<String?> anchorMonday,
  Value<String> kind,
  Value<bool> incrementsEnabled,
  Value<double> incrementAmount,
  Value<String> incrementUnit,
  Value<int> restSeconds,
});
typedef $$RoutinesTableUpdateCompanionBuilder = RoutinesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<DateTime> createdAt,
  Value<String?> anchorMonday,
  Value<String> kind,
  Value<bool> incrementsEnabled,
  Value<double> incrementAmount,
  Value<String> incrementUnit,
  Value<int> restSeconds,
});

final class $$RoutinesTableReferences
    extends BaseReferences<_$AppDatabase, $RoutinesTable, Routine> {
  $$RoutinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AppSettingsTable, List<AppSetting>>
  _appSettingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.appSettings,
    aliasName: 'routines__id__app_settings__current_routine_id',
  );

  $$AppSettingsTableProcessedTableManager get appSettingsRefs {
    final manager = $$AppSettingsTableTableManager(
      $_db,
      $_db.appSettings,
    ).filter((f) => f.currentRoutineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_appSettingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WorkoutsTable, List<Workout>> _workoutsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.workouts,
    aliasName: 'routines__id__workouts__routine_id',
  );

  $$WorkoutsTableProcessedTableManager get workoutsRefs {
    final manager = $$WorkoutsTableTableManager(
      $_db,
      $_db.workouts,
    ).filter((f) => f.routineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RoutineWeekdaysTable, List<RoutineWeekday>>
  _routineWeekdaysRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.routineWeekdays,
    aliasName: 'routines__id__routine_weekdays__routine_id',
  );

  $$RoutineWeekdaysTableProcessedTableManager get routineWeekdaysRefs {
    final manager = $$RoutineWeekdaysTableTableManager(
      $_db,
      $_db.routineWeekdays,
    ).filter((f) => f.routineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _routineWeekdaysRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TrainingSlotsTable, List<TrainingSlot>>
  _trainingSlotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.trainingSlots,
    aliasName: 'routines__id__training_slots__routine_id',
  );

  $$TrainingSlotsTableProcessedTableManager get trainingSlotsRefs {
    final manager = $$TrainingSlotsTableTableManager(
      $_db,
      $_db.trainingSlots,
    ).filter((f) => f.routineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_trainingSlotsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExerciseStartsTable, List<ExerciseStart>>
  _exerciseStartsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.exerciseStarts,
    aliasName: 'routines__id__exercise_starts__routine_id',
  );

  $$ExerciseStartsTableProcessedTableManager get exerciseStartsRefs {
    final manager = $$ExerciseStartsTableTableManager(
      $_db,
      $_db.exerciseStarts,
    ).filter((f) => f.routineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_exerciseStartsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SessionsTable, List<Session>> _sessionsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sessions,
    aliasName: 'routines__id__sessions__routine_id',
  );

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.routineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DayPicksTable, List<DayPick>> _dayPicksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.dayPicks,
    aliasName: 'routines__id__day_picks__routine_id',
  );

  $$DayPicksTableProcessedTableManager get dayPicksRefs {
    final manager = $$DayPicksTableTableManager(
      $_db,
      $_db.dayPicks,
    ).filter((f) => f.routineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dayPicksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoutinesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get anchorMonday => $composableBuilder(
    column: $table.anchorMonday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get incrementsEnabled => $composableBuilder(
    column: $table.incrementsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get incrementAmount => $composableBuilder(
    column: $table.incrementAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get incrementUnit => $composableBuilder(
    column: $table.incrementUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> appSettingsRefs(
    Expression<bool> Function($$AppSettingsTableFilterComposer f) f,
  ) {
    final $$AppSettingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appSettings,
      getReferencedColumn: (t) => t.currentRoutineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppSettingsTableFilterComposer(
            $db: $db,
            $table: $db.appSettings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> workoutsRefs(
    Expression<bool> Function($$WorkoutsTableFilterComposer f) f,
  ) {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableFilterComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> routineWeekdaysRefs(
    Expression<bool> Function($$RoutineWeekdaysTableFilterComposer f) f,
  ) {
    final $$RoutineWeekdaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineWeekdays,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineWeekdaysTableFilterComposer(
            $db: $db,
            $table: $db.routineWeekdays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> trainingSlotsRefs(
    Expression<bool> Function($$TrainingSlotsTableFilterComposer f) f,
  ) {
    final $$TrainingSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trainingSlots,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingSlotsTableFilterComposer(
            $db: $db,
            $table: $db.trainingSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> exerciseStartsRefs(
    Expression<bool> Function($$ExerciseStartsTableFilterComposer f) f,
  ) {
    final $$ExerciseStartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exerciseStarts,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciseStartsTableFilterComposer(
            $db: $db,
            $table: $db.exerciseStarts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionsRefs(
    Expression<bool> Function($$SessionsTableFilterComposer f) f,
  ) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dayPicksRefs(
    Expression<bool> Function($$DayPicksTableFilterComposer f) f,
  ) {
    final $$DayPicksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dayPicks,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPicksTableFilterComposer(
            $db: $db,
            $table: $db.dayPicks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutinesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get anchorMonday => $composableBuilder(
    column: $table.anchorMonday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get incrementsEnabled => $composableBuilder(
    column: $table.incrementsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get incrementAmount => $composableBuilder(
    column: $table.incrementAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get incrementUnit => $composableBuilder(
    column: $table.incrementUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoutinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get anchorMonday => $composableBuilder(
    column: $table.anchorMonday,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<bool> get incrementsEnabled => $composableBuilder(
    column: $table.incrementsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<double> get incrementAmount => $composableBuilder(
    column: $table.incrementAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get incrementUnit => $composableBuilder(
    column: $table.incrementUnit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => column,
  );

  Expression<T> appSettingsRefs<T extends Object>(
    Expression<T> Function($$AppSettingsTableAnnotationComposer a) f,
  ) {
    final $$AppSettingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appSettings,
      getReferencedColumn: (t) => t.currentRoutineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppSettingsTableAnnotationComposer(
            $db: $db,
            $table: $db.appSettings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> workoutsRefs<T extends Object>(
    Expression<T> Function($$WorkoutsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> routineWeekdaysRefs<T extends Object>(
    Expression<T> Function($$RoutineWeekdaysTableAnnotationComposer a) f,
  ) {
    final $$RoutineWeekdaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineWeekdays,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineWeekdaysTableAnnotationComposer(
            $db: $db,
            $table: $db.routineWeekdays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> trainingSlotsRefs<T extends Object>(
    Expression<T> Function($$TrainingSlotsTableAnnotationComposer a) f,
  ) {
    final $$TrainingSlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trainingSlots,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingSlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.trainingSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> exerciseStartsRefs<T extends Object>(
    Expression<T> Function($$ExerciseStartsTableAnnotationComposer a) f,
  ) {
    final $$ExerciseStartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exerciseStarts,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciseStartsTableAnnotationComposer(
            $db: $db,
            $table: $db.exerciseStarts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sessionsRefs<T extends Object>(
    Expression<T> Function($$SessionsTableAnnotationComposer a) f,
  ) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> dayPicksRefs<T extends Object>(
    Expression<T> Function($$DayPicksTableAnnotationComposer a) f,
  ) {
    final $$DayPicksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dayPicks,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPicksTableAnnotationComposer(
            $db: $db,
            $table: $db.dayPicks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutinesTable,
          Routine,
          $$RoutinesTableFilterComposer,
          $$RoutinesTableOrderingComposer,
          $$RoutinesTableAnnotationComposer,
          $$RoutinesTableCreateCompanionBuilder,
          $$RoutinesTableUpdateCompanionBuilder,
          (Routine, $$RoutinesTableReferences),
          Routine,
          PrefetchHooks Function({
            bool appSettingsRefs,
            bool workoutsRefs,
            bool routineWeekdaysRefs,
            bool trainingSlotsRefs,
            bool exerciseStartsRefs,
            bool sessionsRefs,
            bool dayPicksRefs,
          })
        > {
  $$RoutinesTableTableManager(_$AppDatabase db, $RoutinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> anchorMonday = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<bool> incrementsEnabled = const Value.absent(),
                Value<double> incrementAmount = const Value.absent(),
                Value<String> incrementUnit = const Value.absent(),
                Value<int> restSeconds = const Value.absent(),
              }) => RoutinesCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                anchorMonday: anchorMonday,
                kind: kind,
                incrementsEnabled: incrementsEnabled,
                incrementAmount: incrementAmount,
                incrementUnit: incrementUnit,
                restSeconds: restSeconds,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> anchorMonday = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<bool> incrementsEnabled = const Value.absent(),
                Value<double> incrementAmount = const Value.absent(),
                Value<String> incrementUnit = const Value.absent(),
                Value<int> restSeconds = const Value.absent(),
              }) => RoutinesCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                anchorMonday: anchorMonday,
                kind: kind,
                incrementsEnabled: incrementsEnabled,
                incrementAmount: incrementAmount,
                incrementUnit: incrementUnit,
                restSeconds: restSeconds,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoutinesTable, Routine>(table),
                  $$RoutinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                appSettingsRefs = false,
                workoutsRefs = false,
                routineWeekdaysRefs = false,
                trainingSlotsRefs = false,
                exerciseStartsRefs = false,
                sessionsRefs = false,
                dayPicksRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (appSettingsRefs) db.appSettings,
                    if (workoutsRefs) db.workouts,
                    if (routineWeekdaysRefs) db.routineWeekdays,
                    if (trainingSlotsRefs) db.trainingSlots,
                    if (exerciseStartsRefs) db.exerciseStarts,
                    if (sessionsRefs) db.sessions,
                    if (dayPicksRefs) db.dayPicks,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (appSettingsRefs)
                        await $_getPrefetchedDataByColumns<
                          Routine,
                          $RoutinesTable,
                          AppSetting,
                          $AppSettingsTable
                        >(
                          currentTable: table,
                          referencedTable: $$RoutinesTableReferences
                              ._appSettingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutinesTableReferences(
                                db,
                                table,
                                p0,
                              ).appSettingsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'current_routine_id',
                          typedResults: items,
                        ),
                      if (workoutsRefs)
                        await $_getPrefetchedDataByColumns<
                          Routine,
                          $RoutinesTable,
                          Workout,
                          $WorkoutsTable
                        >(
                          currentTable: table,
                          referencedTable: $$RoutinesTableReferences
                              ._workoutsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutinesTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'routine_id',
                          typedResults: items,
                        ),
                      if (routineWeekdaysRefs)
                        await $_getPrefetchedDataByColumns<
                          Routine,
                          $RoutinesTable,
                          RoutineWeekday,
                          $RoutineWeekdaysTable
                        >(
                          currentTable: table,
                          referencedTable: $$RoutinesTableReferences
                              ._routineWeekdaysRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutinesTableReferences(
                                db,
                                table,
                                p0,
                              ).routineWeekdaysRefs,
                          currentColumn: 'id',
                          referencedColumn: 'routine_id',
                          typedResults: items,
                        ),
                      if (trainingSlotsRefs)
                        await $_getPrefetchedDataByColumns<
                          Routine,
                          $RoutinesTable,
                          TrainingSlot,
                          $TrainingSlotsTable
                        >(
                          currentTable: table,
                          referencedTable: $$RoutinesTableReferences
                              ._trainingSlotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutinesTableReferences(
                                db,
                                table,
                                p0,
                              ).trainingSlotsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'routine_id',
                          typedResults: items,
                        ),
                      if (exerciseStartsRefs)
                        await $_getPrefetchedDataByColumns<
                          Routine,
                          $RoutinesTable,
                          ExerciseStart,
                          $ExerciseStartsTable
                        >(
                          currentTable: table,
                          referencedTable: $$RoutinesTableReferences
                              ._exerciseStartsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutinesTableReferences(
                                db,
                                table,
                                p0,
                              ).exerciseStartsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'routine_id',
                          typedResults: items,
                        ),
                      if (sessionsRefs)
                        await $_getPrefetchedDataByColumns<
                          Routine,
                          $RoutinesTable,
                          Session,
                          $SessionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$RoutinesTableReferences
                              ._sessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutinesTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'routine_id',
                          typedResults: items,
                        ),
                      if (dayPicksRefs)
                        await $_getPrefetchedDataByColumns<
                          Routine,
                          $RoutinesTable,
                          DayPick,
                          $DayPicksTable
                        >(
                          currentTable: table,
                          referencedTable: $$RoutinesTableReferences
                              ._dayPicksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutinesTableReferences(
                                db,
                                table,
                                p0,
                              ).dayPicksRefs,
                          currentColumn: 'id',
                          referencedColumn: 'routine_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RoutinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutinesTable,
      Routine,
      $$RoutinesTableFilterComposer,
      $$RoutinesTableOrderingComposer,
      $$RoutinesTableAnnotationComposer,
      $$RoutinesTableCreateCompanionBuilder,
      $$RoutinesTableUpdateCompanionBuilder,
      (Routine, $$RoutinesTableReferences),
      Routine,
      PrefetchHooks Function({
        bool appSettingsRefs,
        bool workoutsRefs,
        bool routineWeekdaysRefs,
        bool trainingSlotsRefs,
        bool exerciseStartsRefs,
        bool sessionsRefs,
        bool dayPicksRefs,
      })
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<int?> currentRoutineId,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<int?> currentRoutineId,
    });

final class $$AppSettingsTableReferences
    extends BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting> {
  $$AppSettingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoutinesTable _currentRoutineIdTable(_$AppDatabase db) =>
      db.routines.createAlias('app_settings__current_routine_id__routines__id');

  $$RoutinesTableProcessedTableManager? get currentRoutineId {
    final $_column = $_itemColumn<int>('current_routine_id');
    if ($_column == null) return null;
    final manager = $$RoutinesTableTableManager(
      $_db,
      $_db.routines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_currentRoutineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutinesTableFilterComposer get currentRoutineId {
    final $$RoutinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currentRoutineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableFilterComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutinesTableOrderingComposer get currentRoutineId {
    final $$RoutinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currentRoutineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableOrderingComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$RoutinesTableAnnotationComposer get currentRoutineId {
    final $$RoutinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currentRoutineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableAnnotationComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (AppSetting, $$AppSettingsTableReferences),
          AppSetting,
          PrefetchHooks Function({bool currentRoutineId})
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> currentRoutineId = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                currentRoutineId: currentRoutineId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> currentRoutineId = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                currentRoutineId: currentRoutineId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  $$AppSettingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({currentRoutineId = false}) {
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
                    if (currentRoutineId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.currentRoutineId,
                        referencedTable: $$AppSettingsTableReferences
                            ._currentRoutineIdTable(db),
                        referencedColumn: $$AppSettingsTableReferences
                            ._currentRoutineIdTable(db)
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

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (AppSetting, $$AppSettingsTableReferences),
      AppSetting,
      PrefetchHooks Function({bool currentRoutineId})
    >;
typedef $$WorkoutsTableCreateCompanionBuilder = WorkoutsCompanion Function({
  Value<int> id,
  required int routineId,
  required String name,
  required int position,
});
typedef $$WorkoutsTableUpdateCompanionBuilder = WorkoutsCompanion Function({
  Value<int> id,
  Value<int> routineId,
  Value<String> name,
  Value<int> position,
});

final class $$WorkoutsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutsTable, Workout> {
  $$WorkoutsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoutinesTable _routineIdTable(_$AppDatabase db) =>
      db.routines.createAlias('workouts__routine_id__routines__id');

  $$RoutinesTableProcessedTableManager get routineId {
    final $_column = $_itemColumn<int>('routine_id')!;

    final manager = $$RoutinesTableTableManager(
      $_db,
      $_db.routines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WorkoutExercisesTable, List<WorkoutExercise>>
  _workoutExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutExercises,
    aliasName: 'workouts__id__workout_exercises__workout_id',
  );

  $$WorkoutExercisesTableProcessedTableManager get workoutExercisesRefs {
    final manager = $$WorkoutExercisesTableTableManager(
      $_db,
      $_db.workoutExercises,
    ).filter((f) => f.workoutId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RoutineWeekdaysTable, List<RoutineWeekday>>
  _routineWeekdaysRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.routineWeekdays,
    aliasName: 'workouts__id__routine_weekdays__workout_id',
  );

  $$RoutineWeekdaysTableProcessedTableManager get routineWeekdaysRefs {
    final manager = $$RoutineWeekdaysTableTableManager(
      $_db,
      $_db.routineWeekdays,
    ).filter((f) => f.workoutId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _routineWeekdaysRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TrainingSlotsTable, List<TrainingSlot>>
  _trainingSlotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.trainingSlots,
    aliasName: 'workouts__id__training_slots__workout_id',
  );

  $$TrainingSlotsTableProcessedTableManager get trainingSlotsRefs {
    final manager = $$TrainingSlotsTableTableManager(
      $_db,
      $_db.trainingSlots,
    ).filter((f) => f.workoutId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_trainingSlotsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SessionsTable, List<Session>> _sessionsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sessions,
    aliasName: 'workouts__id__sessions__workout_id',
  );

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.workoutId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DayPicksTable, List<DayPick>> _dayPicksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.dayPicks,
    aliasName: 'workouts__id__day_picks__workout_id',
  );

  $$DayPicksTableProcessedTableManager get dayPicksRefs {
    final manager = $$DayPicksTableTableManager(
      $_db,
      $_db.dayPicks,
    ).filter((f) => f.workoutId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dayPicksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutinesTableFilterComposer get routineId {
    final $$RoutinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableFilterComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutExercisesRefs(
    Expression<bool> Function($$WorkoutExercisesTableFilterComposer f) f,
  ) {
    final $$WorkoutExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableFilterComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> routineWeekdaysRefs(
    Expression<bool> Function($$RoutineWeekdaysTableFilterComposer f) f,
  ) {
    final $$RoutineWeekdaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineWeekdays,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineWeekdaysTableFilterComposer(
            $db: $db,
            $table: $db.routineWeekdays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> trainingSlotsRefs(
    Expression<bool> Function($$TrainingSlotsTableFilterComposer f) f,
  ) {
    final $$TrainingSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trainingSlots,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingSlotsTableFilterComposer(
            $db: $db,
            $table: $db.trainingSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionsRefs(
    Expression<bool> Function($$SessionsTableFilterComposer f) f,
  ) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dayPicksRefs(
    Expression<bool> Function($$DayPicksTableFilterComposer f) f,
  ) {
    final $$DayPicksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dayPicks,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPicksTableFilterComposer(
            $db: $db,
            $table: $db.dayPicks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutinesTableOrderingComposer get routineId {
    final $$RoutinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableOrderingComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$RoutinesTableAnnotationComposer get routineId {
    final $$RoutinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableAnnotationComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutExercisesRefs<T extends Object>(
    Expression<T> Function($$WorkoutExercisesTableAnnotationComposer a) f,
  ) {
    final $$WorkoutExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> routineWeekdaysRefs<T extends Object>(
    Expression<T> Function($$RoutineWeekdaysTableAnnotationComposer a) f,
  ) {
    final $$RoutineWeekdaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineWeekdays,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineWeekdaysTableAnnotationComposer(
            $db: $db,
            $table: $db.routineWeekdays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> trainingSlotsRefs<T extends Object>(
    Expression<T> Function($$TrainingSlotsTableAnnotationComposer a) f,
  ) {
    final $$TrainingSlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trainingSlots,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingSlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.trainingSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sessionsRefs<T extends Object>(
    Expression<T> Function($$SessionsTableAnnotationComposer a) f,
  ) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> dayPicksRefs<T extends Object>(
    Expression<T> Function($$DayPicksTableAnnotationComposer a) f,
  ) {
    final $$DayPicksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dayPicks,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPicksTableAnnotationComposer(
            $db: $db,
            $table: $db.dayPicks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutsTable,
          Workout,
          $$WorkoutsTableFilterComposer,
          $$WorkoutsTableOrderingComposer,
          $$WorkoutsTableAnnotationComposer,
          $$WorkoutsTableCreateCompanionBuilder,
          $$WorkoutsTableUpdateCompanionBuilder,
          (Workout, $$WorkoutsTableReferences),
          Workout,
          PrefetchHooks Function({
            bool routineId,
            bool workoutExercisesRefs,
            bool routineWeekdaysRefs,
            bool trainingSlotsRefs,
            bool sessionsRefs,
            bool dayPicksRefs,
          })
        > {
  $$WorkoutsTableTableManager(_$AppDatabase db, $WorkoutsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> routineId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => WorkoutsCompanion(
                id: id,
                routineId: routineId,
                name: name,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int routineId,
                required String name,
                required int position,
              }) => WorkoutsCompanion.insert(
                id: id,
                routineId: routineId,
                name: name,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutsTable, Workout>(table),
                  $$WorkoutsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                routineId = false,
                workoutExercisesRefs = false,
                routineWeekdaysRefs = false,
                trainingSlotsRefs = false,
                sessionsRefs = false,
                dayPicksRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutExercisesRefs) db.workoutExercises,
                    if (routineWeekdaysRefs) db.routineWeekdays,
                    if (trainingSlotsRefs) db.trainingSlots,
                    if (sessionsRefs) db.sessions,
                    if (dayPicksRefs) db.dayPicks,
                  ],
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
                        if (routineId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.routineId,
                            referencedTable: $$WorkoutsTableReferences
                                ._routineIdTable(db),
                            referencedColumn: $$WorkoutsTableReferences
                                ._routineIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutExercisesRefs)
                        await $_getPrefetchedDataByColumns<
                          Workout,
                          $WorkoutsTable,
                          WorkoutExercise,
                          $WorkoutExercisesTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutsTableReferences
                              ._workoutExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutsTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutExercisesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'workout_id',
                          typedResults: items,
                        ),
                      if (routineWeekdaysRefs)
                        await $_getPrefetchedDataByColumns<
                          Workout,
                          $WorkoutsTable,
                          RoutineWeekday,
                          $RoutineWeekdaysTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutsTableReferences
                              ._routineWeekdaysRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutsTableReferences(
                                db,
                                table,
                                p0,
                              ).routineWeekdaysRefs,
                          currentColumn: 'id',
                          referencedColumn: 'workout_id',
                          typedResults: items,
                        ),
                      if (trainingSlotsRefs)
                        await $_getPrefetchedDataByColumns<
                          Workout,
                          $WorkoutsTable,
                          TrainingSlot,
                          $TrainingSlotsTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutsTableReferences
                              ._trainingSlotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutsTableReferences(
                                db,
                                table,
                                p0,
                              ).trainingSlotsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'workout_id',
                          typedResults: items,
                        ),
                      if (sessionsRefs)
                        await $_getPrefetchedDataByColumns<
                          Workout,
                          $WorkoutsTable,
                          Session,
                          $SessionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutsTableReferences
                              ._sessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutsTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'workout_id',
                          typedResults: items,
                        ),
                      if (dayPicksRefs)
                        await $_getPrefetchedDataByColumns<
                          Workout,
                          $WorkoutsTable,
                          DayPick,
                          $DayPicksTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutsTableReferences
                              ._dayPicksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutsTableReferences(
                                db,
                                table,
                                p0,
                              ).dayPicksRefs,
                          currentColumn: 'id',
                          referencedColumn: 'workout_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutsTable,
      Workout,
      $$WorkoutsTableFilterComposer,
      $$WorkoutsTableOrderingComposer,
      $$WorkoutsTableAnnotationComposer,
      $$WorkoutsTableCreateCompanionBuilder,
      $$WorkoutsTableUpdateCompanionBuilder,
      (Workout, $$WorkoutsTableReferences),
      Workout,
      PrefetchHooks Function({
        bool routineId,
        bool workoutExercisesRefs,
        bool routineWeekdaysRefs,
        bool trainingSlotsRefs,
        bool sessionsRefs,
        bool dayPicksRefs,
      })
    >;
typedef $$WorkoutExercisesTableCreateCompanionBuilder =
    WorkoutExercisesCompanion Function({
      Value<int> id,
      required int workoutId,
      required int position,
      required int sets,
      required int reps,
      required Exercise exercise,
      Value<double?> targetWeightKg,
      Value<int?> targetMinutes,
      Value<double?> targetSpeedKmh,
      Value<int?> restSeconds,
      Value<double?> incrementAmount,
      Value<String?> incrementUnit,
    });
typedef $$WorkoutExercisesTableUpdateCompanionBuilder =
    WorkoutExercisesCompanion Function({
      Value<int> id,
      Value<int> workoutId,
      Value<int> position,
      Value<int> sets,
      Value<int> reps,
      Value<Exercise> exercise,
      Value<double?> targetWeightKg,
      Value<int?> targetMinutes,
      Value<double?> targetSpeedKmh,
      Value<int?> restSeconds,
      Value<double?> incrementAmount,
      Value<String?> incrementUnit,
    });

final class $$WorkoutExercisesTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutExercisesTable, WorkoutExercise> {
  $$WorkoutExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutsTable _workoutIdTable(_$AppDatabase db) =>
      db.workouts.createAlias('workout_exercises__workout_id__workouts__id');

  $$WorkoutsTableProcessedTableManager get workoutId {
    final $_column = $_itemColumn<int>('workout_id')!;

    final manager = $$WorkoutsTableTableManager(
      $_db,
      $_db.workouts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $SprintIntervalTargetsTable,
    List<SprintIntervalTarget>
  >
  _sprintIntervalTargetsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sprintIntervalTargets,
    aliasName:
        'workout_exercises__id__sprint_interval_targets__workout_exercise_id',
  );

  $$SprintIntervalTargetsTableProcessedTableManager
  get sprintIntervalTargetsRefs {
    final manager = $$SprintIntervalTargetsTableTableManager(
      $_db,
      $_db.sprintIntervalTargets,
    ).filter((f) => f.workoutExerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sprintIntervalTargetsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sets => $composableBuilder(
    column: $table.sets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Exercise, Exercise, String> get exercise =>
      $composableBuilder(
        column: $table.exercise,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetMinutes => $composableBuilder(
    column: $table.targetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetSpeedKmh => $composableBuilder(
    column: $table.targetSpeedKmh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get incrementAmount => $composableBuilder(
    column: $table.incrementAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get incrementUnit => $composableBuilder(
    column: $table.incrementUnit,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutsTableFilterComposer get workoutId {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableFilterComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> sprintIntervalTargetsRefs(
    Expression<bool> Function($$SprintIntervalTargetsTableFilterComposer f) f,
  ) {
    final $$SprintIntervalTargetsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.sprintIntervalTargets,
          getReferencedColumn: (t) => t.workoutExerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SprintIntervalTargetsTableFilterComposer(
                $db: $db,
                $table: $db.sprintIntervalTargets,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sets => $composableBuilder(
    column: $table.sets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exercise => $composableBuilder(
    column: $table.exercise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetMinutes => $composableBuilder(
    column: $table.targetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetSpeedKmh => $composableBuilder(
    column: $table.targetSpeedKmh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get incrementAmount => $composableBuilder(
    column: $table.incrementAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get incrementUnit => $composableBuilder(
    column: $table.incrementUnit,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutsTableOrderingComposer get workoutId {
    final $$WorkoutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableOrderingComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get sets =>
      $composableBuilder(column: $table.sets, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Exercise, String> get exercise =>
      $composableBuilder(column: $table.exercise, builder: (column) => column);

  GeneratedColumn<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetMinutes => $composableBuilder(
    column: $table.targetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get targetSpeedKmh => $composableBuilder(
    column: $table.targetSpeedKmh,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get incrementAmount => $composableBuilder(
    column: $table.incrementAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get incrementUnit => $composableBuilder(
    column: $table.incrementUnit,
    builder: (column) => column,
  );

  $$WorkoutsTableAnnotationComposer get workoutId {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> sprintIntervalTargetsRefs<T extends Object>(
    Expression<T> Function($$SprintIntervalTargetsTableAnnotationComposer a) f,
  ) {
    final $$SprintIntervalTargetsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.sprintIntervalTargets,
          getReferencedColumn: (t) => t.workoutExerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SprintIntervalTargetsTableAnnotationComposer(
                $db: $db,
                $table: $db.sprintIntervalTargets,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutExercisesTable,
          WorkoutExercise,
          $$WorkoutExercisesTableFilterComposer,
          $$WorkoutExercisesTableOrderingComposer,
          $$WorkoutExercisesTableAnnotationComposer,
          $$WorkoutExercisesTableCreateCompanionBuilder,
          $$WorkoutExercisesTableUpdateCompanionBuilder,
          (WorkoutExercise, $$WorkoutExercisesTableReferences),
          WorkoutExercise,
          PrefetchHooks Function({
            bool workoutId,
            bool sprintIntervalTargetsRefs,
          })
        > {
  $$WorkoutExercisesTableTableManager(
    _$AppDatabase db,
    $WorkoutExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> workoutId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> sets = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<Exercise> exercise = const Value.absent(),
                Value<double?> targetWeightKg = const Value.absent(),
                Value<int?> targetMinutes = const Value.absent(),
                Value<double?> targetSpeedKmh = const Value.absent(),
                Value<int?> restSeconds = const Value.absent(),
                Value<double?> incrementAmount = const Value.absent(),
                Value<String?> incrementUnit = const Value.absent(),
              }) => WorkoutExercisesCompanion(
                id: id,
                workoutId: workoutId,
                position: position,
                sets: sets,
                reps: reps,
                exercise: exercise,
                targetWeightKg: targetWeightKg,
                targetMinutes: targetMinutes,
                targetSpeedKmh: targetSpeedKmh,
                restSeconds: restSeconds,
                incrementAmount: incrementAmount,
                incrementUnit: incrementUnit,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int workoutId,
                required int position,
                required int sets,
                required int reps,
                required Exercise exercise,
                Value<double?> targetWeightKg = const Value.absent(),
                Value<int?> targetMinutes = const Value.absent(),
                Value<double?> targetSpeedKmh = const Value.absent(),
                Value<int?> restSeconds = const Value.absent(),
                Value<double?> incrementAmount = const Value.absent(),
                Value<String?> incrementUnit = const Value.absent(),
              }) => WorkoutExercisesCompanion.insert(
                id: id,
                workoutId: workoutId,
                position: position,
                sets: sets,
                reps: reps,
                exercise: exercise,
                targetWeightKg: targetWeightKg,
                targetMinutes: targetMinutes,
                targetSpeedKmh: targetSpeedKmh,
                restSeconds: restSeconds,
                incrementAmount: incrementAmount,
                incrementUnit: incrementUnit,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutExercisesTable, WorkoutExercise>(table),
                  $$WorkoutExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({workoutId = false, sprintIntervalTargetsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sprintIntervalTargetsRefs) db.sprintIntervalTargets,
                  ],
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
                        if (workoutId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.workoutId,
                            referencedTable: $$WorkoutExercisesTableReferences
                                ._workoutIdTable(db),
                            referencedColumn: $$WorkoutExercisesTableReferences
                                ._workoutIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sprintIntervalTargetsRefs)
                        await $_getPrefetchedDataByColumns<
                          WorkoutExercise,
                          $WorkoutExercisesTable,
                          SprintIntervalTarget,
                          $SprintIntervalTargetsTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutExercisesTableReferences
                              ._sprintIntervalTargetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).sprintIntervalTargetsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'workout_exercise_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutExercisesTable,
      WorkoutExercise,
      $$WorkoutExercisesTableFilterComposer,
      $$WorkoutExercisesTableOrderingComposer,
      $$WorkoutExercisesTableAnnotationComposer,
      $$WorkoutExercisesTableCreateCompanionBuilder,
      $$WorkoutExercisesTableUpdateCompanionBuilder,
      (WorkoutExercise, $$WorkoutExercisesTableReferences),
      WorkoutExercise,
      PrefetchHooks Function({bool workoutId, bool sprintIntervalTargetsRefs})
    >;
typedef $$RoutineWeekdaysTableCreateCompanionBuilder =
    RoutineWeekdaysCompanion Function({
      required int routineId,
      required int weekday,
      required bool isRest,
      Value<int?> workoutId,
      Value<int> rowid,
    });
typedef $$RoutineWeekdaysTableUpdateCompanionBuilder =
    RoutineWeekdaysCompanion Function({
      Value<int> routineId,
      Value<int> weekday,
      Value<bool> isRest,
      Value<int?> workoutId,
      Value<int> rowid,
    });

final class $$RoutineWeekdaysTableReferences
    extends
        BaseReferences<_$AppDatabase, $RoutineWeekdaysTable, RoutineWeekday> {
  $$RoutineWeekdaysTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoutinesTable _routineIdTable(_$AppDatabase db) =>
      db.routines.createAlias('routine_weekdays__routine_id__routines__id');

  $$RoutinesTableProcessedTableManager get routineId {
    final $_column = $_itemColumn<int>('routine_id')!;

    final manager = $$RoutinesTableTableManager(
      $_db,
      $_db.routines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WorkoutsTable _workoutIdTable(_$AppDatabase db) =>
      db.workouts.createAlias('routine_weekdays__workout_id__workouts__id');

  $$WorkoutsTableProcessedTableManager? get workoutId {
    final $_column = $_itemColumn<int>('workout_id');
    if ($_column == null) return null;
    final manager = $$WorkoutsTableTableManager(
      $_db,
      $_db.workouts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RoutineWeekdaysTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineWeekdaysTable> {
  $$RoutineWeekdaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRest => $composableBuilder(
    column: $table.isRest,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutinesTableFilterComposer get routineId {
    final $$RoutinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableFilterComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutsTableFilterComposer get workoutId {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableFilterComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineWeekdaysTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineWeekdaysTable> {
  $$RoutineWeekdaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRest => $composableBuilder(
    column: $table.isRest,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutinesTableOrderingComposer get routineId {
    final $$RoutinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableOrderingComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutsTableOrderingComposer get workoutId {
    final $$WorkoutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableOrderingComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineWeekdaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineWeekdaysTable> {
  $$RoutineWeekdaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<bool> get isRest =>
      $composableBuilder(column: $table.isRest, builder: (column) => column);

  $$RoutinesTableAnnotationComposer get routineId {
    final $$RoutinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableAnnotationComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutsTableAnnotationComposer get workoutId {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineWeekdaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutineWeekdaysTable,
          RoutineWeekday,
          $$RoutineWeekdaysTableFilterComposer,
          $$RoutineWeekdaysTableOrderingComposer,
          $$RoutineWeekdaysTableAnnotationComposer,
          $$RoutineWeekdaysTableCreateCompanionBuilder,
          $$RoutineWeekdaysTableUpdateCompanionBuilder,
          (RoutineWeekday, $$RoutineWeekdaysTableReferences),
          RoutineWeekday,
          PrefetchHooks Function({bool routineId, bool workoutId})
        > {
  $$RoutineWeekdaysTableTableManager(
    _$AppDatabase db,
    $RoutineWeekdaysTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineWeekdaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineWeekdaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineWeekdaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> routineId = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<bool> isRest = const Value.absent(),
                Value<int?> workoutId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineWeekdaysCompanion(
                routineId: routineId,
                weekday: weekday,
                isRest: isRest,
                workoutId: workoutId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int routineId,
                required int weekday,
                required bool isRest,
                Value<int?> workoutId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineWeekdaysCompanion.insert(
                routineId: routineId,
                weekday: weekday,
                isRest: isRest,
                workoutId: workoutId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoutineWeekdaysTable, RoutineWeekday>(table),
                  $$RoutineWeekdaysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routineId = false, workoutId = false}) {
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
                    if (routineId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.routineId,
                        referencedTable: $$RoutineWeekdaysTableReferences
                            ._routineIdTable(db),
                        referencedColumn: $$RoutineWeekdaysTableReferences
                            ._routineIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (workoutId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.workoutId,
                        referencedTable: $$RoutineWeekdaysTableReferences
                            ._workoutIdTable(db),
                        referencedColumn: $$RoutineWeekdaysTableReferences
                            ._workoutIdTable(db)
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

typedef $$RoutineWeekdaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutineWeekdaysTable,
      RoutineWeekday,
      $$RoutineWeekdaysTableFilterComposer,
      $$RoutineWeekdaysTableOrderingComposer,
      $$RoutineWeekdaysTableAnnotationComposer,
      $$RoutineWeekdaysTableCreateCompanionBuilder,
      $$RoutineWeekdaysTableUpdateCompanionBuilder,
      (RoutineWeekday, $$RoutineWeekdaysTableReferences),
      RoutineWeekday,
      PrefetchHooks Function({bool routineId, bool workoutId})
    >;
typedef $$TrainingSlotsTableCreateCompanionBuilder =
    TrainingSlotsCompanion Function({
      Value<int> id,
      required int routineId,
      required int sequenceIndex,
      required int workoutId,
    });
typedef $$TrainingSlotsTableUpdateCompanionBuilder =
    TrainingSlotsCompanion Function({
      Value<int> id,
      Value<int> routineId,
      Value<int> sequenceIndex,
      Value<int> workoutId,
    });

final class $$TrainingSlotsTableReferences
    extends BaseReferences<_$AppDatabase, $TrainingSlotsTable, TrainingSlot> {
  $$TrainingSlotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoutinesTable _routineIdTable(_$AppDatabase db) =>
      db.routines.createAlias('training_slots__routine_id__routines__id');

  $$RoutinesTableProcessedTableManager get routineId {
    final $_column = $_itemColumn<int>('routine_id')!;

    final manager = $$RoutinesTableTableManager(
      $_db,
      $_db.routines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WorkoutsTable _workoutIdTable(_$AppDatabase db) =>
      db.workouts.createAlias('training_slots__workout_id__workouts__id');

  $$WorkoutsTableProcessedTableManager get workoutId {
    final $_column = $_itemColumn<int>('workout_id')!;

    final manager = $$WorkoutsTableTableManager(
      $_db,
      $_db.workouts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SessionsTable, List<Session>> _sessionsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sessions,
    aliasName: 'training_slots__id__sessions__training_slot_id',
  );

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.trainingSlotId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TrainingSlotsTableFilterComposer
    extends Composer<_$AppDatabase, $TrainingSlotsTable> {
  $$TrainingSlotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequenceIndex => $composableBuilder(
    column: $table.sequenceIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutinesTableFilterComposer get routineId {
    final $$RoutinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableFilterComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutsTableFilterComposer get workoutId {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableFilterComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> sessionsRefs(
    Expression<bool> Function($$SessionsTableFilterComposer f) f,
  ) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.trainingSlotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TrainingSlotsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrainingSlotsTable> {
  $$TrainingSlotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequenceIndex => $composableBuilder(
    column: $table.sequenceIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutinesTableOrderingComposer get routineId {
    final $$RoutinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableOrderingComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutsTableOrderingComposer get workoutId {
    final $$WorkoutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableOrderingComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrainingSlotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrainingSlotsTable> {
  $$TrainingSlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sequenceIndex => $composableBuilder(
    column: $table.sequenceIndex,
    builder: (column) => column,
  );

  $$RoutinesTableAnnotationComposer get routineId {
    final $$RoutinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableAnnotationComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutsTableAnnotationComposer get workoutId {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> sessionsRefs<T extends Object>(
    Expression<T> Function($$SessionsTableAnnotationComposer a) f,
  ) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.trainingSlotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TrainingSlotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrainingSlotsTable,
          TrainingSlot,
          $$TrainingSlotsTableFilterComposer,
          $$TrainingSlotsTableOrderingComposer,
          $$TrainingSlotsTableAnnotationComposer,
          $$TrainingSlotsTableCreateCompanionBuilder,
          $$TrainingSlotsTableUpdateCompanionBuilder,
          (TrainingSlot, $$TrainingSlotsTableReferences),
          TrainingSlot,
          PrefetchHooks Function({
            bool routineId,
            bool workoutId,
            bool sessionsRefs,
          })
        > {
  $$TrainingSlotsTableTableManager(_$AppDatabase db, $TrainingSlotsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrainingSlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrainingSlotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrainingSlotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> routineId = const Value.absent(),
                Value<int> sequenceIndex = const Value.absent(),
                Value<int> workoutId = const Value.absent(),
              }) => TrainingSlotsCompanion(
                id: id,
                routineId: routineId,
                sequenceIndex: sequenceIndex,
                workoutId: workoutId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int routineId,
                required int sequenceIndex,
                required int workoutId,
              }) => TrainingSlotsCompanion.insert(
                id: id,
                routineId: routineId,
                sequenceIndex: sequenceIndex,
                workoutId: workoutId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TrainingSlotsTable, TrainingSlot>(table),
                  $$TrainingSlotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({routineId = false, workoutId = false, sessionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (sessionsRefs) db.sessions],
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
                        if (routineId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.routineId,
                            referencedTable: $$TrainingSlotsTableReferences
                                ._routineIdTable(db),
                            referencedColumn: $$TrainingSlotsTableReferences
                                ._routineIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (workoutId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.workoutId,
                            referencedTable: $$TrainingSlotsTableReferences
                                ._workoutIdTable(db),
                            referencedColumn: $$TrainingSlotsTableReferences
                                ._workoutIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sessionsRefs)
                        await $_getPrefetchedDataByColumns<
                          TrainingSlot,
                          $TrainingSlotsTable,
                          Session,
                          $SessionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$TrainingSlotsTableReferences
                              ._sessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TrainingSlotsTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'training_slot_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TrainingSlotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrainingSlotsTable,
      TrainingSlot,
      $$TrainingSlotsTableFilterComposer,
      $$TrainingSlotsTableOrderingComposer,
      $$TrainingSlotsTableAnnotationComposer,
      $$TrainingSlotsTableCreateCompanionBuilder,
      $$TrainingSlotsTableUpdateCompanionBuilder,
      (TrainingSlot, $$TrainingSlotsTableReferences),
      TrainingSlot,
      PrefetchHooks Function({
        bool routineId,
        bool workoutId,
        bool sessionsRefs,
      })
    >;
typedef $$ExerciseStartsTableCreateCompanionBuilder =
    ExerciseStartsCompanion Function({
      required int routineId,
      required Exercise exercise,
      required double startWeightKg,
      Value<int> rowid,
    });
typedef $$ExerciseStartsTableUpdateCompanionBuilder =
    ExerciseStartsCompanion Function({
      Value<int> routineId,
      Value<Exercise> exercise,
      Value<double> startWeightKg,
      Value<int> rowid,
    });

final class $$ExerciseStartsTableReferences
    extends BaseReferences<_$AppDatabase, $ExerciseStartsTable, ExerciseStart> {
  $$ExerciseStartsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoutinesTable _routineIdTable(_$AppDatabase db) =>
      db.routines.createAlias('exercise_starts__routine_id__routines__id');

  $$RoutinesTableProcessedTableManager get routineId {
    final $_column = $_itemColumn<int>('routine_id')!;

    final manager = $$RoutinesTableTableManager(
      $_db,
      $_db.routines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExerciseStartsTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseStartsTable> {
  $$ExerciseStartsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<Exercise, Exercise, String> get exercise =>
      $composableBuilder(
        column: $table.exercise,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get startWeightKg => $composableBuilder(
    column: $table.startWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutinesTableFilterComposer get routineId {
    final $$RoutinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableFilterComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseStartsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseStartsTable> {
  $$ExerciseStartsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get exercise => $composableBuilder(
    column: $table.exercise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get startWeightKg => $composableBuilder(
    column: $table.startWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutinesTableOrderingComposer get routineId {
    final $$RoutinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableOrderingComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseStartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseStartsTable> {
  $$ExerciseStartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<Exercise, String> get exercise =>
      $composableBuilder(column: $table.exercise, builder: (column) => column);

  GeneratedColumn<double> get startWeightKg => $composableBuilder(
    column: $table.startWeightKg,
    builder: (column) => column,
  );

  $$RoutinesTableAnnotationComposer get routineId {
    final $$RoutinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableAnnotationComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseStartsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseStartsTable,
          ExerciseStart,
          $$ExerciseStartsTableFilterComposer,
          $$ExerciseStartsTableOrderingComposer,
          $$ExerciseStartsTableAnnotationComposer,
          $$ExerciseStartsTableCreateCompanionBuilder,
          $$ExerciseStartsTableUpdateCompanionBuilder,
          (ExerciseStart, $$ExerciseStartsTableReferences),
          ExerciseStart,
          PrefetchHooks Function({bool routineId})
        > {
  $$ExerciseStartsTableTableManager(
    _$AppDatabase db,
    $ExerciseStartsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseStartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseStartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseStartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> routineId = const Value.absent(),
                Value<Exercise> exercise = const Value.absent(),
                Value<double> startWeightKg = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseStartsCompanion(
                routineId: routineId,
                exercise: exercise,
                startWeightKg: startWeightKg,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int routineId,
                required Exercise exercise,
                required double startWeightKg,
                Value<int> rowid = const Value.absent(),
              }) => ExerciseStartsCompanion.insert(
                routineId: routineId,
                exercise: exercise,
                startWeightKg: startWeightKg,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExerciseStartsTable, ExerciseStart>(table),
                  $$ExerciseStartsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routineId = false}) {
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
                    if (routineId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.routineId,
                        referencedTable: $$ExerciseStartsTableReferences
                            ._routineIdTable(db),
                        referencedColumn: $$ExerciseStartsTableReferences
                            ._routineIdTable(db)
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

typedef $$ExerciseStartsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseStartsTable,
      ExerciseStart,
      $$ExerciseStartsTableFilterComposer,
      $$ExerciseStartsTableOrderingComposer,
      $$ExerciseStartsTableAnnotationComposer,
      $$ExerciseStartsTableCreateCompanionBuilder,
      $$ExerciseStartsTableUpdateCompanionBuilder,
      (ExerciseStart, $$ExerciseStartsTableReferences),
      ExerciseStart,
      PrefetchHooks Function({bool routineId})
    >;
typedef $$SessionsTableCreateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  required int routineId,
  required String loggedOn,
  Value<int?> trainingSlotId,
  required int workoutId,
});
typedef $$SessionsTableUpdateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  Value<int> routineId,
  Value<String> loggedOn,
  Value<int?> trainingSlotId,
  Value<int> workoutId,
});

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, Session> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoutinesTable _routineIdTable(_$AppDatabase db) =>
      db.routines.createAlias('sessions__routine_id__routines__id');

  $$RoutinesTableProcessedTableManager get routineId {
    final $_column = $_itemColumn<int>('routine_id')!;

    final manager = $$RoutinesTableTableManager(
      $_db,
      $_db.routines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TrainingSlotsTable _trainingSlotIdTable(_$AppDatabase db) => db
      .trainingSlots
      .createAlias('sessions__training_slot_id__training_slots__id');

  $$TrainingSlotsTableProcessedTableManager? get trainingSlotId {
    final $_column = $_itemColumn<int>('training_slot_id');
    if ($_column == null) return null;
    final manager = $$TrainingSlotsTableTableManager(
      $_db,
      $_db.trainingSlots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trainingSlotIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WorkoutsTable _workoutIdTable(_$AppDatabase db) =>
      db.workouts.createAlias('sessions__workout_id__workouts__id');

  $$WorkoutsTableProcessedTableManager get workoutId {
    final $_column = $_itemColumn<int>('workout_id')!;

    final manager = $$WorkoutsTableTableManager(
      $_db,
      $_db.workouts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ExerciseLogsTable, List<ExerciseLog>>
  _exerciseLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.exerciseLogs,
    aliasName: 'sessions__id__exercise_logs__session_id',
  );

  $$ExerciseLogsTableProcessedTableManager get exerciseLogsRefs {
    final manager = $$ExerciseLogsTableTableManager(
      $_db,
      $_db.exerciseLogs,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_exerciseLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loggedOn => $composableBuilder(
    column: $table.loggedOn,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutinesTableFilterComposer get routineId {
    final $$RoutinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableFilterComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TrainingSlotsTableFilterComposer get trainingSlotId {
    final $$TrainingSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trainingSlotId,
      referencedTable: $db.trainingSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingSlotsTableFilterComposer(
            $db: $db,
            $table: $db.trainingSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutsTableFilterComposer get workoutId {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableFilterComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> exerciseLogsRefs(
    Expression<bool> Function($$ExerciseLogsTableFilterComposer f) f,
  ) {
    final $$ExerciseLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exerciseLogs,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciseLogsTableFilterComposer(
            $db: $db,
            $table: $db.exerciseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loggedOn => $composableBuilder(
    column: $table.loggedOn,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutinesTableOrderingComposer get routineId {
    final $$RoutinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableOrderingComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TrainingSlotsTableOrderingComposer get trainingSlotId {
    final $$TrainingSlotsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trainingSlotId,
      referencedTable: $db.trainingSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingSlotsTableOrderingComposer(
            $db: $db,
            $table: $db.trainingSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutsTableOrderingComposer get workoutId {
    final $$WorkoutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableOrderingComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get loggedOn =>
      $composableBuilder(column: $table.loggedOn, builder: (column) => column);

  $$RoutinesTableAnnotationComposer get routineId {
    final $$RoutinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableAnnotationComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TrainingSlotsTableAnnotationComposer get trainingSlotId {
    final $$TrainingSlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trainingSlotId,
      referencedTable: $db.trainingSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingSlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.trainingSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutsTableAnnotationComposer get workoutId {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> exerciseLogsRefs<T extends Object>(
    Expression<T> Function($$ExerciseLogsTableAnnotationComposer a) f,
  ) {
    final $$ExerciseLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exerciseLogs,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciseLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.exerciseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, $$SessionsTableReferences),
          Session,
          PrefetchHooks Function({
            bool routineId,
            bool trainingSlotId,
            bool workoutId,
            bool exerciseLogsRefs,
          })
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> routineId = const Value.absent(),
                Value<String> loggedOn = const Value.absent(),
                Value<int?> trainingSlotId = const Value.absent(),
                Value<int> workoutId = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                routineId: routineId,
                loggedOn: loggedOn,
                trainingSlotId: trainingSlotId,
                workoutId: workoutId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int routineId,
                required String loggedOn,
                Value<int?> trainingSlotId = const Value.absent(),
                required int workoutId,
              }) => SessionsCompanion.insert(
                id: id,
                routineId: routineId,
                loggedOn: loggedOn,
                trainingSlotId: trainingSlotId,
                workoutId: workoutId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessionsTable, Session>(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                routineId = false,
                trainingSlotId = false,
                workoutId = false,
                exerciseLogsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (exerciseLogsRefs) db.exerciseLogs,
                  ],
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
                        if (routineId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.routineId,
                            referencedTable: $$SessionsTableReferences
                                ._routineIdTable(db),
                            referencedColumn: $$SessionsTableReferences
                                ._routineIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (trainingSlotId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.trainingSlotId,
                            referencedTable: $$SessionsTableReferences
                                ._trainingSlotIdTable(db),
                            referencedColumn: $$SessionsTableReferences
                                ._trainingSlotIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (workoutId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.workoutId,
                            referencedTable: $$SessionsTableReferences
                                ._workoutIdTable(db),
                            referencedColumn: $$SessionsTableReferences
                                ._workoutIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (exerciseLogsRefs)
                        await $_getPrefetchedDataByColumns<
                          Session,
                          $SessionsTable,
                          ExerciseLog,
                          $ExerciseLogsTable
                        >(
                          currentTable: table,
                          referencedTable: $$SessionsTableReferences
                              ._exerciseLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).exerciseLogsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'session_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, $$SessionsTableReferences),
      Session,
      PrefetchHooks Function({
        bool routineId,
        bool trainingSlotId,
        bool workoutId,
        bool exerciseLogsRefs,
      })
    >;
typedef $$ExerciseLogsTableCreateCompanionBuilder =
    ExerciseLogsCompanion Function({
      Value<int> id,
      required int sessionId,
      required Exercise exercise,
      required double weightKg,
      Value<int?> targetReps,
    });
typedef $$ExerciseLogsTableUpdateCompanionBuilder =
    ExerciseLogsCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<Exercise> exercise,
      Value<double> weightKg,
      Value<int?> targetReps,
    });

final class $$ExerciseLogsTableReferences
    extends BaseReferences<_$AppDatabase, $ExerciseLogsTable, ExerciseLog> {
  $$ExerciseLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('exercise_logs__session_id__sessions__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SetLogsTable, List<SetLog>> _setLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.setLogs,
    aliasName: 'exercise_logs__id__set_logs__exercise_log_id',
  );

  $$SetLogsTableProcessedTableManager get setLogsRefs {
    final manager = $$SetLogsTableTableManager(
      $_db,
      $_db.setLogs,
    ).filter((f) => f.exerciseLogId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_setLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExerciseLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseLogsTable> {
  $$ExerciseLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Exercise, Exercise, String> get exercise =>
      $composableBuilder(
        column: $table.exercise,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> setLogsRefs(
    Expression<bool> Function($$SetLogsTableFilterComposer f) f,
  ) {
    final $$SetLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.exerciseLogId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetLogsTableFilterComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExerciseLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseLogsTable> {
  $$ExerciseLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exercise => $composableBuilder(
    column: $table.exercise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseLogsTable> {
  $$ExerciseLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Exercise, String> get exercise =>
      $composableBuilder(column: $table.exercise, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => column,
  );

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> setLogsRefs<T extends Object>(
    Expression<T> Function($$SetLogsTableAnnotationComposer a) f,
  ) {
    final $$SetLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.exerciseLogId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExerciseLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseLogsTable,
          ExerciseLog,
          $$ExerciseLogsTableFilterComposer,
          $$ExerciseLogsTableOrderingComposer,
          $$ExerciseLogsTableAnnotationComposer,
          $$ExerciseLogsTableCreateCompanionBuilder,
          $$ExerciseLogsTableUpdateCompanionBuilder,
          (ExerciseLog, $$ExerciseLogsTableReferences),
          ExerciseLog,
          PrefetchHooks Function({bool sessionId, bool setLogsRefs})
        > {
  $$ExerciseLogsTableTableManager(_$AppDatabase db, $ExerciseLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<Exercise> exercise = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<int?> targetReps = const Value.absent(),
              }) => ExerciseLogsCompanion(
                id: id,
                sessionId: sessionId,
                exercise: exercise,
                weightKg: weightKg,
                targetReps: targetReps,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required Exercise exercise,
                required double weightKg,
                Value<int?> targetReps = const Value.absent(),
              }) => ExerciseLogsCompanion.insert(
                id: id,
                sessionId: sessionId,
                exercise: exercise,
                weightKg: weightKg,
                targetReps: targetReps,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExerciseLogsTable, ExerciseLog>(table),
                  $$ExerciseLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false, setLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (setLogsRefs) db.setLogs],
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
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$ExerciseLogsTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$ExerciseLogsTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (setLogsRefs)
                    await $_getPrefetchedDataByColumns<
                      ExerciseLog,
                      $ExerciseLogsTable,
                      SetLog,
                      $SetLogsTable
                    >(
                      currentTable: table,
                      referencedTable: $$ExerciseLogsTableReferences
                          ._setLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ExerciseLogsTableReferences(
                            db,
                            table,
                            p0,
                          ).setLogsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'exercise_log_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ExerciseLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseLogsTable,
      ExerciseLog,
      $$ExerciseLogsTableFilterComposer,
      $$ExerciseLogsTableOrderingComposer,
      $$ExerciseLogsTableAnnotationComposer,
      $$ExerciseLogsTableCreateCompanionBuilder,
      $$ExerciseLogsTableUpdateCompanionBuilder,
      (ExerciseLog, $$ExerciseLogsTableReferences),
      ExerciseLog,
      PrefetchHooks Function({bool sessionId, bool setLogsRefs})
    >;
typedef $$SetLogsTableCreateCompanionBuilder = SetLogsCompanion Function({
  Value<int> id,
  required int exerciseLogId,
  required int setIndex,
  required int reps,
  Value<double?> weightKg,
  Value<double?> speedKmh,
  Value<int?> durationSeconds,
  Value<String?> durationUnit,
});
typedef $$SetLogsTableUpdateCompanionBuilder = SetLogsCompanion Function({
  Value<int> id,
  Value<int> exerciseLogId,
  Value<int> setIndex,
  Value<int> reps,
  Value<double?> weightKg,
  Value<double?> speedKmh,
  Value<int?> durationSeconds,
  Value<String?> durationUnit,
});

final class $$SetLogsTableReferences
    extends BaseReferences<_$AppDatabase, $SetLogsTable, SetLog> {
  $$SetLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExerciseLogsTable _exerciseLogIdTable(_$AppDatabase db) => db
      .exerciseLogs
      .createAlias('set_logs__exercise_log_id__exercise_logs__id');

  $$ExerciseLogsTableProcessedTableManager get exerciseLogId {
    final $_column = $_itemColumn<int>('exercise_log_id')!;

    final manager = $$ExerciseLogsTableTableManager(
      $_db,
      $_db.exerciseLogs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseLogIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SetLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setIndex => $composableBuilder(
    column: $table.setIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speedKmh => $composableBuilder(
    column: $table.speedKmh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get durationUnit => $composableBuilder(
    column: $table.durationUnit,
    builder: (column) => ColumnFilters(column),
  );

  $$ExerciseLogsTableFilterComposer get exerciseLogId {
    final $$ExerciseLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseLogId,
      referencedTable: $db.exerciseLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciseLogsTableFilterComposer(
            $db: $db,
            $table: $db.exerciseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setIndex => $composableBuilder(
    column: $table.setIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speedKmh => $composableBuilder(
    column: $table.speedKmh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get durationUnit => $composableBuilder(
    column: $table.durationUnit,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExerciseLogsTableOrderingComposer get exerciseLogId {
    final $$ExerciseLogsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseLogId,
      referencedTable: $db.exerciseLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciseLogsTableOrderingComposer(
            $db: $db,
            $table: $db.exerciseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get setIndex =>
      $composableBuilder(column: $table.setIndex, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get speedKmh =>
      $composableBuilder(column: $table.speedKmh, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get durationUnit => $composableBuilder(
    column: $table.durationUnit,
    builder: (column) => column,
  );

  $$ExerciseLogsTableAnnotationComposer get exerciseLogId {
    final $$ExerciseLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseLogId,
      referencedTable: $db.exerciseLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciseLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.exerciseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SetLogsTable,
          SetLog,
          $$SetLogsTableFilterComposer,
          $$SetLogsTableOrderingComposer,
          $$SetLogsTableAnnotationComposer,
          $$SetLogsTableCreateCompanionBuilder,
          $$SetLogsTableUpdateCompanionBuilder,
          (SetLog, $$SetLogsTableReferences),
          SetLog,
          PrefetchHooks Function({bool exerciseLogId})
        > {
  $$SetLogsTableTableManager(_$AppDatabase db, $SetLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SetLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SetLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SetLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> exerciseLogId = const Value.absent(),
                Value<int> setIndex = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<double?> speedKmh = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<String?> durationUnit = const Value.absent(),
              }) => SetLogsCompanion(
                id: id,
                exerciseLogId: exerciseLogId,
                setIndex: setIndex,
                reps: reps,
                weightKg: weightKg,
                speedKmh: speedKmh,
                durationSeconds: durationSeconds,
                durationUnit: durationUnit,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int exerciseLogId,
                required int setIndex,
                required int reps,
                Value<double?> weightKg = const Value.absent(),
                Value<double?> speedKmh = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<String?> durationUnit = const Value.absent(),
              }) => SetLogsCompanion.insert(
                id: id,
                exerciseLogId: exerciseLogId,
                setIndex: setIndex,
                reps: reps,
                weightKg: weightKg,
                speedKmh: speedKmh,
                durationSeconds: durationSeconds,
                durationUnit: durationUnit,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SetLogsTable, SetLog>(table),
                  $$SetLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({exerciseLogId = false}) {
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
                    if (exerciseLogId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.exerciseLogId,
                        referencedTable: $$SetLogsTableReferences
                            ._exerciseLogIdTable(db),
                        referencedColumn: $$SetLogsTableReferences
                            ._exerciseLogIdTable(db)
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

typedef $$SetLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SetLogsTable,
      SetLog,
      $$SetLogsTableFilterComposer,
      $$SetLogsTableOrderingComposer,
      $$SetLogsTableAnnotationComposer,
      $$SetLogsTableCreateCompanionBuilder,
      $$SetLogsTableUpdateCompanionBuilder,
      (SetLog, $$SetLogsTableReferences),
      SetLog,
      PrefetchHooks Function({bool exerciseLogId})
    >;
typedef $$SprintIntervalTargetsTableCreateCompanionBuilder =
    SprintIntervalTargetsCompanion Function({
      Value<int> id,
      required int workoutExerciseId,
      required int intervalIndex,
      required double speedKmh,
      required int durationSeconds,
      required String durationUnit,
    });
typedef $$SprintIntervalTargetsTableUpdateCompanionBuilder =
    SprintIntervalTargetsCompanion Function({
      Value<int> id,
      Value<int> workoutExerciseId,
      Value<int> intervalIndex,
      Value<double> speedKmh,
      Value<int> durationSeconds,
      Value<String> durationUnit,
    });

final class $$SprintIntervalTargetsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SprintIntervalTargetsTable,
          SprintIntervalTarget
        > {
  $$SprintIntervalTargetsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutExercisesTable _workoutExerciseIdTable(_$AppDatabase db) =>
      db.workoutExercises.createAlias(
        'sprint_interval_targets__workout_exercise_id__workout_exercises__id',
      );

  $$WorkoutExercisesTableProcessedTableManager get workoutExerciseId {
    final $_column = $_itemColumn<int>('workout_exercise_id')!;

    final manager = $$WorkoutExercisesTableTableManager(
      $_db,
      $_db.workoutExercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SprintIntervalTargetsTableFilterComposer
    extends Composer<_$AppDatabase, $SprintIntervalTargetsTable> {
  $$SprintIntervalTargetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalIndex => $composableBuilder(
    column: $table.intervalIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speedKmh => $composableBuilder(
    column: $table.speedKmh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get durationUnit => $composableBuilder(
    column: $table.durationUnit,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutExercisesTableFilterComposer get workoutExerciseId {
    final $$WorkoutExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutExerciseId,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableFilterComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SprintIntervalTargetsTableOrderingComposer
    extends Composer<_$AppDatabase, $SprintIntervalTargetsTable> {
  $$SprintIntervalTargetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalIndex => $composableBuilder(
    column: $table.intervalIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speedKmh => $composableBuilder(
    column: $table.speedKmh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get durationUnit => $composableBuilder(
    column: $table.durationUnit,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutExercisesTableOrderingComposer get workoutExerciseId {
    final $$WorkoutExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutExerciseId,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SprintIntervalTargetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SprintIntervalTargetsTable> {
  $$SprintIntervalTargetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get intervalIndex => $composableBuilder(
    column: $table.intervalIndex,
    builder: (column) => column,
  );

  GeneratedColumn<double> get speedKmh =>
      $composableBuilder(column: $table.speedKmh, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get durationUnit => $composableBuilder(
    column: $table.durationUnit,
    builder: (column) => column,
  );

  $$WorkoutExercisesTableAnnotationComposer get workoutExerciseId {
    final $$WorkoutExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutExerciseId,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SprintIntervalTargetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SprintIntervalTargetsTable,
          SprintIntervalTarget,
          $$SprintIntervalTargetsTableFilterComposer,
          $$SprintIntervalTargetsTableOrderingComposer,
          $$SprintIntervalTargetsTableAnnotationComposer,
          $$SprintIntervalTargetsTableCreateCompanionBuilder,
          $$SprintIntervalTargetsTableUpdateCompanionBuilder,
          (SprintIntervalTarget, $$SprintIntervalTargetsTableReferences),
          SprintIntervalTarget,
          PrefetchHooks Function({bool workoutExerciseId})
        > {
  $$SprintIntervalTargetsTableTableManager(
    _$AppDatabase db,
    $SprintIntervalTargetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SprintIntervalTargetsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$SprintIntervalTargetsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SprintIntervalTargetsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> workoutExerciseId = const Value.absent(),
                Value<int> intervalIndex = const Value.absent(),
                Value<double> speedKmh = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<String> durationUnit = const Value.absent(),
              }) => SprintIntervalTargetsCompanion(
                id: id,
                workoutExerciseId: workoutExerciseId,
                intervalIndex: intervalIndex,
                speedKmh: speedKmh,
                durationSeconds: durationSeconds,
                durationUnit: durationUnit,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int workoutExerciseId,
                required int intervalIndex,
                required double speedKmh,
                required int durationSeconds,
                required String durationUnit,
              }) => SprintIntervalTargetsCompanion.insert(
                id: id,
                workoutExerciseId: workoutExerciseId,
                intervalIndex: intervalIndex,
                speedKmh: speedKmh,
                durationSeconds: durationSeconds,
                durationUnit: durationUnit,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $SprintIntervalTargetsTable,
                    SprintIntervalTarget
                  >(table),
                  $$SprintIntervalTargetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutExerciseId = false}) {
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
                    if (workoutExerciseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.workoutExerciseId,
                        referencedTable: $$SprintIntervalTargetsTableReferences
                            ._workoutExerciseIdTable(db),
                        referencedColumn: $$SprintIntervalTargetsTableReferences
                            ._workoutExerciseIdTable(db)
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

typedef $$SprintIntervalTargetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SprintIntervalTargetsTable,
      SprintIntervalTarget,
      $$SprintIntervalTargetsTableFilterComposer,
      $$SprintIntervalTargetsTableOrderingComposer,
      $$SprintIntervalTargetsTableAnnotationComposer,
      $$SprintIntervalTargetsTableCreateCompanionBuilder,
      $$SprintIntervalTargetsTableUpdateCompanionBuilder,
      (SprintIntervalTarget, $$SprintIntervalTargetsTableReferences),
      SprintIntervalTarget,
      PrefetchHooks Function({bool workoutExerciseId})
    >;
typedef $$DayPicksTableCreateCompanionBuilder = DayPicksCompanion Function({
  required int routineId,
  required String day,
  required int workoutId,
  Value<int> rowid,
});
typedef $$DayPicksTableUpdateCompanionBuilder = DayPicksCompanion Function({
  Value<int> routineId,
  Value<String> day,
  Value<int> workoutId,
  Value<int> rowid,
});

final class $$DayPicksTableReferences
    extends BaseReferences<_$AppDatabase, $DayPicksTable, DayPick> {
  $$DayPicksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoutinesTable _routineIdTable(_$AppDatabase db) =>
      db.routines.createAlias('day_picks__routine_id__routines__id');

  $$RoutinesTableProcessedTableManager get routineId {
    final $_column = $_itemColumn<int>('routine_id')!;

    final manager = $$RoutinesTableTableManager(
      $_db,
      $_db.routines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WorkoutsTable _workoutIdTable(_$AppDatabase db) =>
      db.workouts.createAlias('day_picks__workout_id__workouts__id');

  $$WorkoutsTableProcessedTableManager get workoutId {
    final $_column = $_itemColumn<int>('workout_id')!;

    final manager = $$WorkoutsTableTableManager(
      $_db,
      $_db.workouts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DayPicksTableFilterComposer
    extends Composer<_$AppDatabase, $DayPicksTable> {
  $$DayPicksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutinesTableFilterComposer get routineId {
    final $$RoutinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableFilterComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutsTableFilterComposer get workoutId {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableFilterComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DayPicksTableOrderingComposer
    extends Composer<_$AppDatabase, $DayPicksTable> {
  $$DayPicksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutinesTableOrderingComposer get routineId {
    final $$RoutinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableOrderingComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutsTableOrderingComposer get workoutId {
    final $$WorkoutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableOrderingComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DayPicksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DayPicksTable> {
  $$DayPicksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  $$RoutinesTableAnnotationComposer get routineId {
    final $$RoutinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableAnnotationComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutsTableAnnotationComposer get workoutId {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DayPicksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DayPicksTable,
          DayPick,
          $$DayPicksTableFilterComposer,
          $$DayPicksTableOrderingComposer,
          $$DayPicksTableAnnotationComposer,
          $$DayPicksTableCreateCompanionBuilder,
          $$DayPicksTableUpdateCompanionBuilder,
          (DayPick, $$DayPicksTableReferences),
          DayPick,
          PrefetchHooks Function({bool routineId, bool workoutId})
        > {
  $$DayPicksTableTableManager(_$AppDatabase db, $DayPicksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayPicksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayPicksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayPicksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> routineId = const Value.absent(),
                Value<String> day = const Value.absent(),
                Value<int> workoutId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DayPicksCompanion(
                routineId: routineId,
                day: day,
                workoutId: workoutId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int routineId,
                required String day,
                required int workoutId,
                Value<int> rowid = const Value.absent(),
              }) => DayPicksCompanion.insert(
                routineId: routineId,
                day: day,
                workoutId: workoutId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DayPicksTable, DayPick>(table),
                  $$DayPicksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routineId = false, workoutId = false}) {
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
                    if (routineId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.routineId,
                        referencedTable: $$DayPicksTableReferences
                            ._routineIdTable(db),
                        referencedColumn: $$DayPicksTableReferences
                            ._routineIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (workoutId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.workoutId,
                        referencedTable: $$DayPicksTableReferences
                            ._workoutIdTable(db),
                        referencedColumn: $$DayPicksTableReferences
                            ._workoutIdTable(db)
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

typedef $$DayPicksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DayPicksTable,
      DayPick,
      $$DayPicksTableFilterComposer,
      $$DayPicksTableOrderingComposer,
      $$DayPicksTableAnnotationComposer,
      $$DayPicksTableCreateCompanionBuilder,
      $$DayPicksTableUpdateCompanionBuilder,
      (DayPick, $$DayPicksTableReferences),
      DayPick,
      PrefetchHooks Function({bool routineId, bool workoutId})
    >;
typedef $$CustomExercisesTableCreateCompanionBuilder =
    CustomExercisesCompanion Function({
      required String storageKey,
      required String name,
      required String muscleGroup,
      required String equipment,
      Value<String> kind,
      Value<int> rowid,
    });
typedef $$CustomExercisesTableUpdateCompanionBuilder =
    CustomExercisesCompanion Function({
      Value<String> storageKey,
      Value<String> name,
      Value<String> muscleGroup,
      Value<String> equipment,
      Value<String> kind,
      Value<int> rowid,
    });

class $$CustomExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $CustomExercisesTable> {
  $$CustomExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get storageKey => $composableBuilder(
    column: $table.storageKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomExercisesTable> {
  $$CustomExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get storageKey => $composableBuilder(
    column: $table.storageKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomExercisesTable> {
  $$CustomExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get storageKey => $composableBuilder(
    column: $table.storageKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);
}

class $$CustomExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomExercisesTable,
          CustomExercise,
          $$CustomExercisesTableFilterComposer,
          $$CustomExercisesTableOrderingComposer,
          $$CustomExercisesTableAnnotationComposer,
          $$CustomExercisesTableCreateCompanionBuilder,
          $$CustomExercisesTableUpdateCompanionBuilder,
          (
            CustomExercise,
            BaseReferences<
              _$AppDatabase,
              $CustomExercisesTable,
              CustomExercise
            >,
          ),
          CustomExercise,
          PrefetchHooks Function()
        > {
  $$CustomExercisesTableTableManager(
    _$AppDatabase db,
    $CustomExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> storageKey = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> muscleGroup = const Value.absent(),
                Value<String> equipment = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomExercisesCompanion(
                storageKey: storageKey,
                name: name,
                muscleGroup: muscleGroup,
                equipment: equipment,
                kind: kind,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String storageKey,
                required String name,
                required String muscleGroup,
                required String equipment,
                Value<String> kind = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomExercisesCompanion.insert(
                storageKey: storageKey,
                name: name,
                muscleGroup: muscleGroup,
                equipment: equipment,
                kind: kind,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CustomExercisesTable, CustomExercise>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CustomExercisesTable,
                    CustomExercise
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomExercisesTable,
      CustomExercise,
      $$CustomExercisesTableFilterComposer,
      $$CustomExercisesTableOrderingComposer,
      $$CustomExercisesTableAnnotationComposer,
      $$CustomExercisesTableCreateCompanionBuilder,
      $$CustomExercisesTableUpdateCompanionBuilder,
      (
        CustomExercise,
        BaseReferences<_$AppDatabase, $CustomExercisesTable, CustomExercise>,
      ),
      CustomExercise,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db, _db.routines);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$WorkoutsTableTableManager get workouts =>
      $$WorkoutsTableTableManager(_db, _db.workouts);
  $$WorkoutExercisesTableTableManager get workoutExercises =>
      $$WorkoutExercisesTableTableManager(_db, _db.workoutExercises);
  $$RoutineWeekdaysTableTableManager get routineWeekdays =>
      $$RoutineWeekdaysTableTableManager(_db, _db.routineWeekdays);
  $$TrainingSlotsTableTableManager get trainingSlots =>
      $$TrainingSlotsTableTableManager(_db, _db.trainingSlots);
  $$ExerciseStartsTableTableManager get exerciseStarts =>
      $$ExerciseStartsTableTableManager(_db, _db.exerciseStarts);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$ExerciseLogsTableTableManager get exerciseLogs =>
      $$ExerciseLogsTableTableManager(_db, _db.exerciseLogs);
  $$SetLogsTableTableManager get setLogs =>
      $$SetLogsTableTableManager(_db, _db.setLogs);
  $$SprintIntervalTargetsTableTableManager get sprintIntervalTargets =>
      $$SprintIntervalTargetsTableTableManager(_db, _db.sprintIntervalTargets);
  $$DayPicksTableTableManager get dayPicks =>
      $$DayPicksTableTableManager(_db, _db.dayPicks);
  $$CustomExercisesTableTableManager get customExercises =>
      $$CustomExercisesTableTableManager(_db, _db.customExercises);
}
