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
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt, anchorMonday];
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
  const Routine({
    required this.id,
    required this.name,
    required this.createdAt,
    this.anchorMonday,
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
    };
  }

  Routine copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    Value<String?> anchorMonday = const Value.absent(),
  }) => Routine(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    anchorMonday: anchorMonday.present ? anchorMonday.value : this.anchorMonday,
  );
  Routine copyWithCompanion(RoutinesCompanion data) {
    return Routine(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      anchorMonday: data.anchorMonday.present
          ? data.anchorMonday.value
          : this.anchorMonday,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Routine(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('anchorMonday: $anchorMonday')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt, anchorMonday);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Routine &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.anchorMonday == this.anchorMonday);
}

class RoutinesCompanion extends UpdateCompanion<Routine> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<String?> anchorMonday;
  const RoutinesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.anchorMonday = const Value.absent(),
  });
  RoutinesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
    this.anchorMonday = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Routine> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<String>? anchorMonday,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (anchorMonday != null) 'anchor_monday': anchorMonday,
    });
  }

  RoutinesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<String?>? anchorMonday,
  }) {
    return RoutinesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      anchorMonday: anchorMonday ?? this.anchorMonday,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutinesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('anchorMonday: $anchorMonday')
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
  final int? targetMinutes;
  final double? targetSpeedKmh;
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
          ..write('targetSpeedKmh: $targetSpeedKmh')
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
          other.targetSpeedKmh == this.targetSpeedKmh);
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
          ..write('targetSpeedKmh: $targetSpeedKmh')
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
  @override
  List<GeneratedColumn> get $columns => [id, sessionId, exercise, weightKg];
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
  const ExerciseLog({
    required this.id,
    required this.sessionId,
    required this.exercise,
    required this.weightKg,
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
    return map;
  }

  ExerciseLogsCompanion toCompanion(bool nullToAbsent) {
    return ExerciseLogsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      exercise: Value(exercise),
      weightKg: Value(weightKg),
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
    };
  }

  ExerciseLog copyWith({
    int? id,
    int? sessionId,
    Exercise? exercise,
    double? weightKg,
  }) => ExerciseLog(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    exercise: exercise ?? this.exercise,
    weightKg: weightKg ?? this.weightKg,
  );
  ExerciseLog copyWithCompanion(ExerciseLogsCompanion data) {
    return ExerciseLog(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exercise: data.exercise.present ? data.exercise.value : this.exercise,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseLog(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exercise: $exercise, ')
          ..write('weightKg: $weightKg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, exercise, weightKg);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseLog &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.exercise == this.exercise &&
          other.weightKg == this.weightKg);
}

class ExerciseLogsCompanion extends UpdateCompanion<ExerciseLog> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<Exercise> exercise;
  final Value<double> weightKg;
  const ExerciseLogsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exercise = const Value.absent(),
    this.weightKg = const Value.absent(),
  });
  ExerciseLogsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required Exercise exercise,
    required double weightKg,
  }) : sessionId = Value(sessionId),
       exercise = Value(exercise),
       weightKg = Value(weightKg);
  static Insertable<ExerciseLog> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<String>? exercise,
    Expression<double>? weightKg,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (exercise != null) 'exercise': exercise,
      if (weightKg != null) 'weight_kg': weightKg,
    });
  }

  ExerciseLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<Exercise>? exercise,
    Value<double>? weightKg,
  }) {
    return ExerciseLogsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exercise: exercise ?? this.exercise,
      weightKg: weightKg ?? this.weightKg,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseLogsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exercise: $exercise, ')
          ..write('weightKg: $weightKg')
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

  /// Jogging and sprinting. Strength leaves these empty.
  final double? speedKmh;
  final int? durationSeconds;
  final String? durationUnit;
  const SetLog({
    required this.id,
    required this.exerciseLogId,
    required this.setIndex,
    required this.reps,
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
    Value<double?> speedKmh = const Value.absent(),
    Value<int?> durationSeconds = const Value.absent(),
    Value<String?> durationUnit = const Value.absent(),
  }) => SetLog(
    id: id ?? this.id,
    exerciseLogId: exerciseLogId ?? this.exerciseLogId,
    setIndex: setIndex ?? this.setIndex,
    reps: reps ?? this.reps,
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
          other.speedKmh == this.speedKmh &&
          other.durationSeconds == this.durationSeconds &&
          other.durationUnit == this.durationUnit);
}

class SetLogsCompanion extends UpdateCompanion<SetLog> {
  final Value<int> id;
  final Value<int> exerciseLogId;
  final Value<int> setIndex;
  final Value<int> reps;
  final Value<double?> speedKmh;
  final Value<int?> durationSeconds;
  final Value<String?> durationUnit;
  const SetLogsCompanion({
    this.id = const Value.absent(),
    this.exerciseLogId = const Value.absent(),
    this.setIndex = const Value.absent(),
    this.reps = const Value.absent(),
    this.speedKmh = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.durationUnit = const Value.absent(),
  });
  SetLogsCompanion.insert({
    this.id = const Value.absent(),
    required int exerciseLogId,
    required int setIndex,
    required int reps,
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
    Expression<double>? speedKmh,
    Expression<int>? durationSeconds,
    Expression<String>? durationUnit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseLogId != null) 'exercise_log_id': exerciseLogId,
      if (setIndex != null) 'set_index': setIndex,
      if (reps != null) 'reps': reps,
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
    Value<double?>? speedKmh,
    Value<int?>? durationSeconds,
    Value<String?>? durationUnit,
  }) {
    return SetLogsCompanion(
      id: id ?? this.id,
      exerciseLogId: exerciseLogId ?? this.exerciseLogId,
      setIndex: setIndex ?? this.setIndex,
      reps: reps ?? this.reps,
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
  ];
}

typedef $$RoutinesTableCreateCompanionBuilder = RoutinesCompanion Function({
  Value<int> id,
  required String name,
  Value<DateTime> createdAt,
  Value<String?> anchorMonday,
});
typedef $$RoutinesTableUpdateCompanionBuilder = RoutinesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<DateTime> createdAt,
  Value<String?> anchorMonday,
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
              }) => RoutinesCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                anchorMonday: anchorMonday,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> anchorMonday = const Value.absent(),
              }) => RoutinesCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                anchorMonday: anchorMonday,
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
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutExercisesRefs) db.workoutExercises,
                    if (routineWeekdaysRefs) db.routineWeekdays,
                    if (trainingSlotsRefs) db.trainingSlots,
                    if (sessionsRefs) db.sessions,
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
    });
typedef $$ExerciseLogsTableUpdateCompanionBuilder =
    ExerciseLogsCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<Exercise> exercise,
      Value<double> weightKg,
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
              }) => ExerciseLogsCompanion(
                id: id,
                sessionId: sessionId,
                exercise: exercise,
                weightKg: weightKg,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required Exercise exercise,
                required double weightKg,
              }) => ExerciseLogsCompanion.insert(
                id: id,
                sessionId: sessionId,
                exercise: exercise,
                weightKg: weightKg,
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
  Value<double?> speedKmh,
  Value<int?> durationSeconds,
  Value<String?> durationUnit,
});
typedef $$SetLogsTableUpdateCompanionBuilder = SetLogsCompanion Function({
  Value<int> id,
  Value<int> exerciseLogId,
  Value<int> setIndex,
  Value<int> reps,
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
                Value<double?> speedKmh = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<String?> durationUnit = const Value.absent(),
              }) => SetLogsCompanion(
                id: id,
                exerciseLogId: exerciseLogId,
                setIndex: setIndex,
                reps: reps,
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
                Value<double?> speedKmh = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<String?> durationUnit = const Value.absent(),
              }) => SetLogsCompanion.insert(
                id: id,
                exerciseLogId: exerciseLogId,
                setIndex: setIndex,
                reps: reps,
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
}
