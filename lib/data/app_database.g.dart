// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userNameMeta = const VerificationMeta(
    'userName',
  );
  @override
  late final GeneratedColumn<String> userName = GeneratedColumn<String>(
    'user_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
    'token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [userName, password, token];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_name')) {
      context.handle(
        _userNameMeta,
        userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta),
      );
    } else if (isInserting) {
      context.missing(_userNameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('token')) {
      context.handle(
        _tokenMeta,
        token.isAcceptableOrUnknown(data['token']!, _tokenMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      userName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_name'],
          )!,
      password:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}password'],
          )!,
      token:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}token'],
          )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String userName;
  final String password;
  final String token;
  const User({
    required this.userName,
    required this.password,
    required this.token,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_name'] = Variable<String>(userName);
    map['password'] = Variable<String>(password);
    map['token'] = Variable<String>(token);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      userName: Value(userName),
      password: Value(password),
      token: Value(token),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      userName: serializer.fromJson<String>(json['userName']),
      password: serializer.fromJson<String>(json['password']),
      token: serializer.fromJson<String>(json['token']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userName': serializer.toJson<String>(userName),
      'password': serializer.toJson<String>(password),
      'token': serializer.toJson<String>(token),
    };
  }

  User copyWith({String? userName, String? password, String? token}) => User(
    userName: userName ?? this.userName,
    password: password ?? this.password,
    token: token ?? this.token,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      userName: data.userName.present ? data.userName.value : this.userName,
      password: data.password.present ? data.password.value : this.password,
      token: data.token.present ? data.token.value : this.token,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('userName: $userName, ')
          ..write('password: $password, ')
          ..write('token: $token')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userName, password, token);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.userName == this.userName &&
          other.password == this.password &&
          other.token == this.token);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> userName;
  final Value<String> password;
  final Value<String> token;
  final Value<int> rowid;
  const UsersCompanion({
    this.userName = const Value.absent(),
    this.password = const Value.absent(),
    this.token = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String userName,
    required String password,
    required String token,
    this.rowid = const Value.absent(),
  }) : userName = Value(userName),
       password = Value(password),
       token = Value(token);
  static Insertable<User> custom({
    Expression<String>? userName,
    Expression<String>? password,
    Expression<String>? token,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userName != null) 'user_name': userName,
      if (password != null) 'password': password,
      if (token != null) 'token': token,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? userName,
    Value<String>? password,
    Value<String>? token,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      userName: userName ?? this.userName,
      password: password ?? this.password,
      token: token ?? this.token,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('userName: $userName, ')
          ..write('password: $password, ')
          ..write('token: $token, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $YouthUsersTable extends YouthUsers
    with TableInfo<$YouthUsersTable, YouthUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $YouthUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _youthUserIdMeta = const VerificationMeta(
    'youthUserId',
  );
  @override
  late final GeneratedColumn<int> youthUserId = GeneratedColumn<int>(
    'youth_user_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _youthTypeMeta = const VerificationMeta(
    'youthType',
  );
  @override
  late final GeneratedColumn<String> youthType = GeneratedColumn<String>(
    'youth_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skillsMeta = const VerificationMeta('skills');
  @override
  late final GeneratedColumn<String> skills = GeneratedColumn<String>(
    'skills',
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
  static const VerificationMeta _registerAtMeta = const VerificationMeta(
    'registerAt',
  );
  @override
  late final GeneratedColumn<DateTime> registerAt = GeneratedColumn<DateTime>(
    'register_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    youthUserId,
    userId,
    youthType,
    skills,
    status,
    registerAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'youth_users';
  @override
  VerificationContext validateIntegrity(
    Insertable<YouthUser> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('youth_user_id')) {
      context.handle(
        _youthUserIdMeta,
        youthUserId.isAcceptableOrUnknown(
          data['youth_user_id']!,
          _youthUserIdMeta,
        ),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('youth_type')) {
      context.handle(
        _youthTypeMeta,
        youthType.isAcceptableOrUnknown(data['youth_type']!, _youthTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_youthTypeMeta);
    }
    if (data.containsKey('skills')) {
      context.handle(
        _skillsMeta,
        skills.isAcceptableOrUnknown(data['skills']!, _skillsMeta),
      );
    } else if (isInserting) {
      context.missing(_skillsMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('register_at')) {
      context.handle(
        _registerAtMeta,
        registerAt.isAcceptableOrUnknown(data['register_at']!, _registerAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {youthUserId};
  @override
  YouthUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return YouthUser(
      youthUserId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}youth_user_id'],
          )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      ),
      youthType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}youth_type'],
          )!,
      skills:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}skills'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      registerAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}register_at'],
          )!,
    );
  }

  @override
  $YouthUsersTable createAlias(String alias) {
    return $YouthUsersTable(attachedDatabase, alias);
  }
}

class YouthUser extends DataClass implements Insertable<YouthUser> {
  final int youthUserId;
  final int? userId;
  final String youthType;
  final String skills;
  final String status;
  final DateTime registerAt;
  const YouthUser({
    required this.youthUserId,
    this.userId,
    required this.youthType,
    required this.skills,
    required this.status,
    required this.registerAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['youth_user_id'] = Variable<int>(youthUserId);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['youth_type'] = Variable<String>(youthType);
    map['skills'] = Variable<String>(skills);
    map['status'] = Variable<String>(status);
    map['register_at'] = Variable<DateTime>(registerAt);
    return map;
  }

  YouthUsersCompanion toCompanion(bool nullToAbsent) {
    return YouthUsersCompanion(
      youthUserId: Value(youthUserId),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      youthType: Value(youthType),
      skills: Value(skills),
      status: Value(status),
      registerAt: Value(registerAt),
    );
  }

  factory YouthUser.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return YouthUser(
      youthUserId: serializer.fromJson<int>(json['youthUserId']),
      userId: serializer.fromJson<int?>(json['userId']),
      youthType: serializer.fromJson<String>(json['youthType']),
      skills: serializer.fromJson<String>(json['skills']),
      status: serializer.fromJson<String>(json['status']),
      registerAt: serializer.fromJson<DateTime>(json['registerAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'youthUserId': serializer.toJson<int>(youthUserId),
      'userId': serializer.toJson<int?>(userId),
      'youthType': serializer.toJson<String>(youthType),
      'skills': serializer.toJson<String>(skills),
      'status': serializer.toJson<String>(status),
      'registerAt': serializer.toJson<DateTime>(registerAt),
    };
  }

  YouthUser copyWith({
    int? youthUserId,
    Value<int?> userId = const Value.absent(),
    String? youthType,
    String? skills,
    String? status,
    DateTime? registerAt,
  }) => YouthUser(
    youthUserId: youthUserId ?? this.youthUserId,
    userId: userId.present ? userId.value : this.userId,
    youthType: youthType ?? this.youthType,
    skills: skills ?? this.skills,
    status: status ?? this.status,
    registerAt: registerAt ?? this.registerAt,
  );
  YouthUser copyWithCompanion(YouthUsersCompanion data) {
    return YouthUser(
      youthUserId:
          data.youthUserId.present ? data.youthUserId.value : this.youthUserId,
      userId: data.userId.present ? data.userId.value : this.userId,
      youthType: data.youthType.present ? data.youthType.value : this.youthType,
      skills: data.skills.present ? data.skills.value : this.skills,
      status: data.status.present ? data.status.value : this.status,
      registerAt:
          data.registerAt.present ? data.registerAt.value : this.registerAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('YouthUser(')
          ..write('youthUserId: $youthUserId, ')
          ..write('userId: $userId, ')
          ..write('youthType: $youthType, ')
          ..write('skills: $skills, ')
          ..write('status: $status, ')
          ..write('registerAt: $registerAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(youthUserId, userId, youthType, skills, status, registerAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is YouthUser &&
          other.youthUserId == this.youthUserId &&
          other.userId == this.userId &&
          other.youthType == this.youthType &&
          other.skills == this.skills &&
          other.status == this.status &&
          other.registerAt == this.registerAt);
}

class YouthUsersCompanion extends UpdateCompanion<YouthUser> {
  final Value<int> youthUserId;
  final Value<int?> userId;
  final Value<String> youthType;
  final Value<String> skills;
  final Value<String> status;
  final Value<DateTime> registerAt;
  const YouthUsersCompanion({
    this.youthUserId = const Value.absent(),
    this.userId = const Value.absent(),
    this.youthType = const Value.absent(),
    this.skills = const Value.absent(),
    this.status = const Value.absent(),
    this.registerAt = const Value.absent(),
  });
  YouthUsersCompanion.insert({
    this.youthUserId = const Value.absent(),
    this.userId = const Value.absent(),
    required String youthType,
    required String skills,
    required String status,
    this.registerAt = const Value.absent(),
  }) : youthType = Value(youthType),
       skills = Value(skills),
       status = Value(status);
  static Insertable<YouthUser> custom({
    Expression<int>? youthUserId,
    Expression<int>? userId,
    Expression<String>? youthType,
    Expression<String>? skills,
    Expression<String>? status,
    Expression<DateTime>? registerAt,
  }) {
    return RawValuesInsertable({
      if (youthUserId != null) 'youth_user_id': youthUserId,
      if (userId != null) 'user_id': userId,
      if (youthType != null) 'youth_type': youthType,
      if (skills != null) 'skills': skills,
      if (status != null) 'status': status,
      if (registerAt != null) 'register_at': registerAt,
    });
  }

  YouthUsersCompanion copyWith({
    Value<int>? youthUserId,
    Value<int?>? userId,
    Value<String>? youthType,
    Value<String>? skills,
    Value<String>? status,
    Value<DateTime>? registerAt,
  }) {
    return YouthUsersCompanion(
      youthUserId: youthUserId ?? this.youthUserId,
      userId: userId ?? this.userId,
      youthType: youthType ?? this.youthType,
      skills: skills ?? this.skills,
      status: status ?? this.status,
      registerAt: registerAt ?? this.registerAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (youthUserId.present) {
      map['youth_user_id'] = Variable<int>(youthUserId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (youthType.present) {
      map['youth_type'] = Variable<String>(youthType.value);
    }
    if (skills.present) {
      map['skills'] = Variable<String>(skills.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (registerAt.present) {
      map['register_at'] = Variable<DateTime>(registerAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('YouthUsersCompanion(')
          ..write('youthUserId: $youthUserId, ')
          ..write('userId: $userId, ')
          ..write('youthType: $youthType, ')
          ..write('skills: $skills, ')
          ..write('status: $status, ')
          ..write('registerAt: $registerAt')
          ..write(')'))
        .toString();
  }
}

class $YouthInfosTable extends YouthInfos
    with TableInfo<$YouthInfosTable, YouthInfo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $YouthInfosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _youthInfosIdMeta = const VerificationMeta(
    'youthInfosId',
  );
  @override
  late final GeneratedColumn<int> youthInfosId = GeneratedColumn<int>(
    'youth_infos_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _youthUserIdMeta = const VerificationMeta(
    'youthUserId',
  );
  @override
  late final GeneratedColumn<int> youthUserId = GeneratedColumn<int>(
    'youth_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints:
        'REFERENCES youth_users(youth_user_id) ON DELETE CASCADE ',
  );
  static const VerificationMeta _fnameMeta = const VerificationMeta('fname');
  @override
  late final GeneratedColumn<String> fname = GeneratedColumn<String>(
    'fname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mnameMeta = const VerificationMeta('mname');
  @override
  late final GeneratedColumn<String> mname = GeneratedColumn<String>(
    'mname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lnameMeta = const VerificationMeta('lname');
  @override
  late final GeneratedColumn<String> lname = GeneratedColumn<String>(
    'lname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateOfBirthMeta = const VerificationMeta(
    'dateOfBirth',
  );
  @override
  late final GeneratedColumn<String> dateOfBirth = GeneratedColumn<String>(
    'date_of_birth',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _placeOfBirthMeta = const VerificationMeta(
    'placeOfBirth',
  );
  @override
  late final GeneratedColumn<String> placeOfBirth = GeneratedColumn<String>(
    'place_of_birth',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactNoMeta = const VerificationMeta(
    'contactNo',
  );
  @override
  late final GeneratedColumn<String> contactNo = GeneratedColumn<String>(
    'contact_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<double> height = GeneratedColumn<double>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _religionMeta = const VerificationMeta(
    'religion',
  );
  @override
  late final GeneratedColumn<String> religion = GeneratedColumn<String>(
    'religion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occupationMeta = const VerificationMeta(
    'occupation',
  );
  @override
  late final GeneratedColumn<String> occupation = GeneratedColumn<String>(
    'occupation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _civilStatusMeta = const VerificationMeta(
    'civilStatus',
  );
  @override
  late final GeneratedColumn<String> civilStatus = GeneratedColumn<String>(
    'civil_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noOfChildrenMeta = const VerificationMeta(
    'noOfChildren',
  );
  @override
  late final GeneratedColumn<int> noOfChildren = GeneratedColumn<int>(
    'no_of_children',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    youthInfosId,
    youthUserId,
    fname,
    mname,
    lname,
    age,
    gender,
    sex,
    dateOfBirth,
    placeOfBirth,
    contactNo,
    height,
    weight,
    religion,
    occupation,
    civilStatus,
    noOfChildren,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'youth_infos';
  @override
  VerificationContext validateIntegrity(
    Insertable<YouthInfo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('youth_infos_id')) {
      context.handle(
        _youthInfosIdMeta,
        youthInfosId.isAcceptableOrUnknown(
          data['youth_infos_id']!,
          _youthInfosIdMeta,
        ),
      );
    }
    if (data.containsKey('youth_user_id')) {
      context.handle(
        _youthUserIdMeta,
        youthUserId.isAcceptableOrUnknown(
          data['youth_user_id']!,
          _youthUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_youthUserIdMeta);
    }
    if (data.containsKey('fname')) {
      context.handle(
        _fnameMeta,
        fname.isAcceptableOrUnknown(data['fname']!, _fnameMeta),
      );
    } else if (isInserting) {
      context.missing(_fnameMeta);
    }
    if (data.containsKey('mname')) {
      context.handle(
        _mnameMeta,
        mname.isAcceptableOrUnknown(data['mname']!, _mnameMeta),
      );
    } else if (isInserting) {
      context.missing(_mnameMeta);
    }
    if (data.containsKey('lname')) {
      context.handle(
        _lnameMeta,
        lname.isAcceptableOrUnknown(data['lname']!, _lnameMeta),
      );
    } else if (isInserting) {
      context.missing(_lnameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    } else if (isInserting) {
      context.missing(_sexMeta);
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
        _dateOfBirthMeta,
        dateOfBirth.isAcceptableOrUnknown(
          data['date_of_birth']!,
          _dateOfBirthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateOfBirthMeta);
    }
    if (data.containsKey('place_of_birth')) {
      context.handle(
        _placeOfBirthMeta,
        placeOfBirth.isAcceptableOrUnknown(
          data['place_of_birth']!,
          _placeOfBirthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_placeOfBirthMeta);
    }
    if (data.containsKey('contact_no')) {
      context.handle(
        _contactNoMeta,
        contactNo.isAcceptableOrUnknown(data['contact_no']!, _contactNoMeta),
      );
    } else if (isInserting) {
      context.missing(_contactNoMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('religion')) {
      context.handle(
        _religionMeta,
        religion.isAcceptableOrUnknown(data['religion']!, _religionMeta),
      );
    } else if (isInserting) {
      context.missing(_religionMeta);
    }
    if (data.containsKey('occupation')) {
      context.handle(
        _occupationMeta,
        occupation.isAcceptableOrUnknown(data['occupation']!, _occupationMeta),
      );
    } else if (isInserting) {
      context.missing(_occupationMeta);
    }
    if (data.containsKey('civil_status')) {
      context.handle(
        _civilStatusMeta,
        civilStatus.isAcceptableOrUnknown(
          data['civil_status']!,
          _civilStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_civilStatusMeta);
    }
    if (data.containsKey('no_of_children')) {
      context.handle(
        _noOfChildrenMeta,
        noOfChildren.isAcceptableOrUnknown(
          data['no_of_children']!,
          _noOfChildrenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_noOfChildrenMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {youthInfosId};
  @override
  YouthInfo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return YouthInfo(
      youthInfosId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}youth_infos_id'],
          )!,
      youthUserId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}youth_user_id'],
          )!,
      fname:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}fname'],
          )!,
      mname:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}mname'],
          )!,
      lname:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}lname'],
          )!,
      age:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}age'],
          )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      sex:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sex'],
          )!,
      dateOfBirth:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}date_of_birth'],
          )!,
      placeOfBirth:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}place_of_birth'],
          )!,
      contactNo:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}contact_no'],
          )!,
      height:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}height'],
          )!,
      weight:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}weight'],
          )!,
      religion:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}religion'],
          )!,
      occupation:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}occupation'],
          )!,
      civilStatus:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}civil_status'],
          )!,
      noOfChildren:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}no_of_children'],
          )!,
    );
  }

  @override
  $YouthInfosTable createAlias(String alias) {
    return $YouthInfosTable(attachedDatabase, alias);
  }
}

class YouthInfo extends DataClass implements Insertable<YouthInfo> {
  final int youthInfosId;
  final int youthUserId;
  final String fname;
  final String mname;
  final String lname;
  final int age;
  final String? gender;
  final String sex;
  final String dateOfBirth;
  final String placeOfBirth;
  final String contactNo;
  final double height;
  final double weight;
  final String religion;
  final String occupation;
  final String civilStatus;
  final int noOfChildren;
  const YouthInfo({
    required this.youthInfosId,
    required this.youthUserId,
    required this.fname,
    required this.mname,
    required this.lname,
    required this.age,
    this.gender,
    required this.sex,
    required this.dateOfBirth,
    required this.placeOfBirth,
    required this.contactNo,
    required this.height,
    required this.weight,
    required this.religion,
    required this.occupation,
    required this.civilStatus,
    required this.noOfChildren,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['youth_infos_id'] = Variable<int>(youthInfosId);
    map['youth_user_id'] = Variable<int>(youthUserId);
    map['fname'] = Variable<String>(fname);
    map['mname'] = Variable<String>(mname);
    map['lname'] = Variable<String>(lname);
    map['age'] = Variable<int>(age);
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    map['sex'] = Variable<String>(sex);
    map['date_of_birth'] = Variable<String>(dateOfBirth);
    map['place_of_birth'] = Variable<String>(placeOfBirth);
    map['contact_no'] = Variable<String>(contactNo);
    map['height'] = Variable<double>(height);
    map['weight'] = Variable<double>(weight);
    map['religion'] = Variable<String>(religion);
    map['occupation'] = Variable<String>(occupation);
    map['civil_status'] = Variable<String>(civilStatus);
    map['no_of_children'] = Variable<int>(noOfChildren);
    return map;
  }

  YouthInfosCompanion toCompanion(bool nullToAbsent) {
    return YouthInfosCompanion(
      youthInfosId: Value(youthInfosId),
      youthUserId: Value(youthUserId),
      fname: Value(fname),
      mname: Value(mname),
      lname: Value(lname),
      age: Value(age),
      gender:
          gender == null && nullToAbsent ? const Value.absent() : Value(gender),
      sex: Value(sex),
      dateOfBirth: Value(dateOfBirth),
      placeOfBirth: Value(placeOfBirth),
      contactNo: Value(contactNo),
      height: Value(height),
      weight: Value(weight),
      religion: Value(religion),
      occupation: Value(occupation),
      civilStatus: Value(civilStatus),
      noOfChildren: Value(noOfChildren),
    );
  }

  factory YouthInfo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return YouthInfo(
      youthInfosId: serializer.fromJson<int>(json['youthInfosId']),
      youthUserId: serializer.fromJson<int>(json['youthUserId']),
      fname: serializer.fromJson<String>(json['fname']),
      mname: serializer.fromJson<String>(json['mname']),
      lname: serializer.fromJson<String>(json['lname']),
      age: serializer.fromJson<int>(json['age']),
      gender: serializer.fromJson<String?>(json['gender']),
      sex: serializer.fromJson<String>(json['sex']),
      dateOfBirth: serializer.fromJson<String>(json['dateOfBirth']),
      placeOfBirth: serializer.fromJson<String>(json['placeOfBirth']),
      contactNo: serializer.fromJson<String>(json['contactNo']),
      height: serializer.fromJson<double>(json['height']),
      weight: serializer.fromJson<double>(json['weight']),
      religion: serializer.fromJson<String>(json['religion']),
      occupation: serializer.fromJson<String>(json['occupation']),
      civilStatus: serializer.fromJson<String>(json['civilStatus']),
      noOfChildren: serializer.fromJson<int>(json['noOfChildren']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'youthInfosId': serializer.toJson<int>(youthInfosId),
      'youthUserId': serializer.toJson<int>(youthUserId),
      'fname': serializer.toJson<String>(fname),
      'mname': serializer.toJson<String>(mname),
      'lname': serializer.toJson<String>(lname),
      'age': serializer.toJson<int>(age),
      'gender': serializer.toJson<String?>(gender),
      'sex': serializer.toJson<String>(sex),
      'dateOfBirth': serializer.toJson<String>(dateOfBirth),
      'placeOfBirth': serializer.toJson<String>(placeOfBirth),
      'contactNo': serializer.toJson<String>(contactNo),
      'height': serializer.toJson<double>(height),
      'weight': serializer.toJson<double>(weight),
      'religion': serializer.toJson<String>(religion),
      'occupation': serializer.toJson<String>(occupation),
      'civilStatus': serializer.toJson<String>(civilStatus),
      'noOfChildren': serializer.toJson<int>(noOfChildren),
    };
  }

  YouthInfo copyWith({
    int? youthInfosId,
    int? youthUserId,
    String? fname,
    String? mname,
    String? lname,
    int? age,
    Value<String?> gender = const Value.absent(),
    String? sex,
    String? dateOfBirth,
    String? placeOfBirth,
    String? contactNo,
    double? height,
    double? weight,
    String? religion,
    String? occupation,
    String? civilStatus,
    int? noOfChildren,
  }) => YouthInfo(
    youthInfosId: youthInfosId ?? this.youthInfosId,
    youthUserId: youthUserId ?? this.youthUserId,
    fname: fname ?? this.fname,
    mname: mname ?? this.mname,
    lname: lname ?? this.lname,
    age: age ?? this.age,
    gender: gender.present ? gender.value : this.gender,
    sex: sex ?? this.sex,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    placeOfBirth: placeOfBirth ?? this.placeOfBirth,
    contactNo: contactNo ?? this.contactNo,
    height: height ?? this.height,
    weight: weight ?? this.weight,
    religion: religion ?? this.religion,
    occupation: occupation ?? this.occupation,
    civilStatus: civilStatus ?? this.civilStatus,
    noOfChildren: noOfChildren ?? this.noOfChildren,
  );
  YouthInfo copyWithCompanion(YouthInfosCompanion data) {
    return YouthInfo(
      youthInfosId:
          data.youthInfosId.present
              ? data.youthInfosId.value
              : this.youthInfosId,
      youthUserId:
          data.youthUserId.present ? data.youthUserId.value : this.youthUserId,
      fname: data.fname.present ? data.fname.value : this.fname,
      mname: data.mname.present ? data.mname.value : this.mname,
      lname: data.lname.present ? data.lname.value : this.lname,
      age: data.age.present ? data.age.value : this.age,
      gender: data.gender.present ? data.gender.value : this.gender,
      sex: data.sex.present ? data.sex.value : this.sex,
      dateOfBirth:
          data.dateOfBirth.present ? data.dateOfBirth.value : this.dateOfBirth,
      placeOfBirth:
          data.placeOfBirth.present
              ? data.placeOfBirth.value
              : this.placeOfBirth,
      contactNo: data.contactNo.present ? data.contactNo.value : this.contactNo,
      height: data.height.present ? data.height.value : this.height,
      weight: data.weight.present ? data.weight.value : this.weight,
      religion: data.religion.present ? data.religion.value : this.religion,
      occupation:
          data.occupation.present ? data.occupation.value : this.occupation,
      civilStatus:
          data.civilStatus.present ? data.civilStatus.value : this.civilStatus,
      noOfChildren:
          data.noOfChildren.present
              ? data.noOfChildren.value
              : this.noOfChildren,
    );
  }

  @override
  String toString() {
    return (StringBuffer('YouthInfo(')
          ..write('youthInfosId: $youthInfosId, ')
          ..write('youthUserId: $youthUserId, ')
          ..write('fname: $fname, ')
          ..write('mname: $mname, ')
          ..write('lname: $lname, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('sex: $sex, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('placeOfBirth: $placeOfBirth, ')
          ..write('contactNo: $contactNo, ')
          ..write('height: $height, ')
          ..write('weight: $weight, ')
          ..write('religion: $religion, ')
          ..write('occupation: $occupation, ')
          ..write('civilStatus: $civilStatus, ')
          ..write('noOfChildren: $noOfChildren')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    youthInfosId,
    youthUserId,
    fname,
    mname,
    lname,
    age,
    gender,
    sex,
    dateOfBirth,
    placeOfBirth,
    contactNo,
    height,
    weight,
    religion,
    occupation,
    civilStatus,
    noOfChildren,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is YouthInfo &&
          other.youthInfosId == this.youthInfosId &&
          other.youthUserId == this.youthUserId &&
          other.fname == this.fname &&
          other.mname == this.mname &&
          other.lname == this.lname &&
          other.age == this.age &&
          other.gender == this.gender &&
          other.sex == this.sex &&
          other.dateOfBirth == this.dateOfBirth &&
          other.placeOfBirth == this.placeOfBirth &&
          other.contactNo == this.contactNo &&
          other.height == this.height &&
          other.weight == this.weight &&
          other.religion == this.religion &&
          other.occupation == this.occupation &&
          other.civilStatus == this.civilStatus &&
          other.noOfChildren == this.noOfChildren);
}

class YouthInfosCompanion extends UpdateCompanion<YouthInfo> {
  final Value<int> youthInfosId;
  final Value<int> youthUserId;
  final Value<String> fname;
  final Value<String> mname;
  final Value<String> lname;
  final Value<int> age;
  final Value<String?> gender;
  final Value<String> sex;
  final Value<String> dateOfBirth;
  final Value<String> placeOfBirth;
  final Value<String> contactNo;
  final Value<double> height;
  final Value<double> weight;
  final Value<String> religion;
  final Value<String> occupation;
  final Value<String> civilStatus;
  final Value<int> noOfChildren;
  const YouthInfosCompanion({
    this.youthInfosId = const Value.absent(),
    this.youthUserId = const Value.absent(),
    this.fname = const Value.absent(),
    this.mname = const Value.absent(),
    this.lname = const Value.absent(),
    this.age = const Value.absent(),
    this.gender = const Value.absent(),
    this.sex = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.placeOfBirth = const Value.absent(),
    this.contactNo = const Value.absent(),
    this.height = const Value.absent(),
    this.weight = const Value.absent(),
    this.religion = const Value.absent(),
    this.occupation = const Value.absent(),
    this.civilStatus = const Value.absent(),
    this.noOfChildren = const Value.absent(),
  });
  YouthInfosCompanion.insert({
    this.youthInfosId = const Value.absent(),
    required int youthUserId,
    required String fname,
    required String mname,
    required String lname,
    required int age,
    this.gender = const Value.absent(),
    required String sex,
    required String dateOfBirth,
    required String placeOfBirth,
    required String contactNo,
    required double height,
    required double weight,
    required String religion,
    required String occupation,
    required String civilStatus,
    required int noOfChildren,
  }) : youthUserId = Value(youthUserId),
       fname = Value(fname),
       mname = Value(mname),
       lname = Value(lname),
       age = Value(age),
       sex = Value(sex),
       dateOfBirth = Value(dateOfBirth),
       placeOfBirth = Value(placeOfBirth),
       contactNo = Value(contactNo),
       height = Value(height),
       weight = Value(weight),
       religion = Value(religion),
       occupation = Value(occupation),
       civilStatus = Value(civilStatus),
       noOfChildren = Value(noOfChildren);
  static Insertable<YouthInfo> custom({
    Expression<int>? youthInfosId,
    Expression<int>? youthUserId,
    Expression<String>? fname,
    Expression<String>? mname,
    Expression<String>? lname,
    Expression<int>? age,
    Expression<String>? gender,
    Expression<String>? sex,
    Expression<String>? dateOfBirth,
    Expression<String>? placeOfBirth,
    Expression<String>? contactNo,
    Expression<double>? height,
    Expression<double>? weight,
    Expression<String>? religion,
    Expression<String>? occupation,
    Expression<String>? civilStatus,
    Expression<int>? noOfChildren,
  }) {
    return RawValuesInsertable({
      if (youthInfosId != null) 'youth_infos_id': youthInfosId,
      if (youthUserId != null) 'youth_user_id': youthUserId,
      if (fname != null) 'fname': fname,
      if (mname != null) 'mname': mname,
      if (lname != null) 'lname': lname,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (sex != null) 'sex': sex,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (placeOfBirth != null) 'place_of_birth': placeOfBirth,
      if (contactNo != null) 'contact_no': contactNo,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (religion != null) 'religion': religion,
      if (occupation != null) 'occupation': occupation,
      if (civilStatus != null) 'civil_status': civilStatus,
      if (noOfChildren != null) 'no_of_children': noOfChildren,
    });
  }

  YouthInfosCompanion copyWith({
    Value<int>? youthInfosId,
    Value<int>? youthUserId,
    Value<String>? fname,
    Value<String>? mname,
    Value<String>? lname,
    Value<int>? age,
    Value<String?>? gender,
    Value<String>? sex,
    Value<String>? dateOfBirth,
    Value<String>? placeOfBirth,
    Value<String>? contactNo,
    Value<double>? height,
    Value<double>? weight,
    Value<String>? religion,
    Value<String>? occupation,
    Value<String>? civilStatus,
    Value<int>? noOfChildren,
  }) {
    return YouthInfosCompanion(
      youthInfosId: youthInfosId ?? this.youthInfosId,
      youthUserId: youthUserId ?? this.youthUserId,
      fname: fname ?? this.fname,
      mname: mname ?? this.mname,
      lname: lname ?? this.lname,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      sex: sex ?? this.sex,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      contactNo: contactNo ?? this.contactNo,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      religion: religion ?? this.religion,
      occupation: occupation ?? this.occupation,
      civilStatus: civilStatus ?? this.civilStatus,
      noOfChildren: noOfChildren ?? this.noOfChildren,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (youthInfosId.present) {
      map['youth_infos_id'] = Variable<int>(youthInfosId.value);
    }
    if (youthUserId.present) {
      map['youth_user_id'] = Variable<int>(youthUserId.value);
    }
    if (fname.present) {
      map['fname'] = Variable<String>(fname.value);
    }
    if (mname.present) {
      map['mname'] = Variable<String>(mname.value);
    }
    if (lname.present) {
      map['lname'] = Variable<String>(lname.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<String>(dateOfBirth.value);
    }
    if (placeOfBirth.present) {
      map['place_of_birth'] = Variable<String>(placeOfBirth.value);
    }
    if (contactNo.present) {
      map['contact_no'] = Variable<String>(contactNo.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (religion.present) {
      map['religion'] = Variable<String>(religion.value);
    }
    if (occupation.present) {
      map['occupation'] = Variable<String>(occupation.value);
    }
    if (civilStatus.present) {
      map['civil_status'] = Variable<String>(civilStatus.value);
    }
    if (noOfChildren.present) {
      map['no_of_children'] = Variable<int>(noOfChildren.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('YouthInfosCompanion(')
          ..write('youthInfosId: $youthInfosId, ')
          ..write('youthUserId: $youthUserId, ')
          ..write('fname: $fname, ')
          ..write('mname: $mname, ')
          ..write('lname: $lname, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('sex: $sex, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('placeOfBirth: $placeOfBirth, ')
          ..write('contactNo: $contactNo, ')
          ..write('height: $height, ')
          ..write('weight: $weight, ')
          ..write('religion: $religion, ')
          ..write('occupation: $occupation, ')
          ..write('civilStatus: $civilStatus, ')
          ..write('noOfChildren: $noOfChildren')
          ..write(')'))
        .toString();
  }
}

class $EducBgsTable extends EducBgs with TableInfo<$EducBgsTable, EducBg> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EducBgsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _educBgIdMeta = const VerificationMeta(
    'educBgId',
  );
  @override
  late final GeneratedColumn<int> educBgId = GeneratedColumn<int>(
    'educ_bg_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _youthUserIdMeta = const VerificationMeta(
    'youthUserId',
  );
  @override
  late final GeneratedColumn<int> youthUserId = GeneratedColumn<int>(
    'youth_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints:
        'REFERENCES youth_users(youth_user_id) ON DELETE CASCADE NOT NULL',
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameOfSchoolMeta = const VerificationMeta(
    'nameOfSchool',
  );
  @override
  late final GeneratedColumn<String> nameOfSchool = GeneratedColumn<String>(
    'name_of_school',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodOfAttendanceMeta =
      const VerificationMeta('periodOfAttendance');
  @override
  late final GeneratedColumn<String> periodOfAttendance =
      GeneratedColumn<String>(
        'period_of_attendance',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _yearGraduateMeta = const VerificationMeta(
    'yearGraduate',
  );
  @override
  late final GeneratedColumn<String> yearGraduate = GeneratedColumn<String>(
    'year_graduate',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    educBgId,
    youthUserId,
    level,
    nameOfSchool,
    periodOfAttendance,
    yearGraduate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'educ_bgs';
  @override
  VerificationContext validateIntegrity(
    Insertable<EducBg> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('educ_bg_id')) {
      context.handle(
        _educBgIdMeta,
        educBgId.isAcceptableOrUnknown(data['educ_bg_id']!, _educBgIdMeta),
      );
    }
    if (data.containsKey('youth_user_id')) {
      context.handle(
        _youthUserIdMeta,
        youthUserId.isAcceptableOrUnknown(
          data['youth_user_id']!,
          _youthUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_youthUserIdMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('name_of_school')) {
      context.handle(
        _nameOfSchoolMeta,
        nameOfSchool.isAcceptableOrUnknown(
          data['name_of_school']!,
          _nameOfSchoolMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameOfSchoolMeta);
    }
    if (data.containsKey('period_of_attendance')) {
      context.handle(
        _periodOfAttendanceMeta,
        periodOfAttendance.isAcceptableOrUnknown(
          data['period_of_attendance']!,
          _periodOfAttendanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_periodOfAttendanceMeta);
    }
    if (data.containsKey('year_graduate')) {
      context.handle(
        _yearGraduateMeta,
        yearGraduate.isAcceptableOrUnknown(
          data['year_graduate']!,
          _yearGraduateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_yearGraduateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {educBgId};
  @override
  EducBg map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EducBg(
      educBgId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}educ_bg_id'],
          )!,
      youthUserId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}youth_user_id'],
          )!,
      level:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}level'],
          )!,
      nameOfSchool:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name_of_school'],
          )!,
      periodOfAttendance:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}period_of_attendance'],
          )!,
      yearGraduate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}year_graduate'],
          )!,
    );
  }

  @override
  $EducBgsTable createAlias(String alias) {
    return $EducBgsTable(attachedDatabase, alias);
  }
}

class EducBg extends DataClass implements Insertable<EducBg> {
  final int educBgId;
  final int youthUserId;
  final String level;
  final String nameOfSchool;
  final String periodOfAttendance;
  final String yearGraduate;
  const EducBg({
    required this.educBgId,
    required this.youthUserId,
    required this.level,
    required this.nameOfSchool,
    required this.periodOfAttendance,
    required this.yearGraduate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['educ_bg_id'] = Variable<int>(educBgId);
    map['youth_user_id'] = Variable<int>(youthUserId);
    map['level'] = Variable<String>(level);
    map['name_of_school'] = Variable<String>(nameOfSchool);
    map['period_of_attendance'] = Variable<String>(periodOfAttendance);
    map['year_graduate'] = Variable<String>(yearGraduate);
    return map;
  }

  EducBgsCompanion toCompanion(bool nullToAbsent) {
    return EducBgsCompanion(
      educBgId: Value(educBgId),
      youthUserId: Value(youthUserId),
      level: Value(level),
      nameOfSchool: Value(nameOfSchool),
      periodOfAttendance: Value(periodOfAttendance),
      yearGraduate: Value(yearGraduate),
    );
  }

  factory EducBg.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EducBg(
      educBgId: serializer.fromJson<int>(json['educBgId']),
      youthUserId: serializer.fromJson<int>(json['youthUserId']),
      level: serializer.fromJson<String>(json['level']),
      nameOfSchool: serializer.fromJson<String>(json['nameOfSchool']),
      periodOfAttendance: serializer.fromJson<String>(
        json['periodOfAttendance'],
      ),
      yearGraduate: serializer.fromJson<String>(json['yearGraduate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'educBgId': serializer.toJson<int>(educBgId),
      'youthUserId': serializer.toJson<int>(youthUserId),
      'level': serializer.toJson<String>(level),
      'nameOfSchool': serializer.toJson<String>(nameOfSchool),
      'periodOfAttendance': serializer.toJson<String>(periodOfAttendance),
      'yearGraduate': serializer.toJson<String>(yearGraduate),
    };
  }

  EducBg copyWith({
    int? educBgId,
    int? youthUserId,
    String? level,
    String? nameOfSchool,
    String? periodOfAttendance,
    String? yearGraduate,
  }) => EducBg(
    educBgId: educBgId ?? this.educBgId,
    youthUserId: youthUserId ?? this.youthUserId,
    level: level ?? this.level,
    nameOfSchool: nameOfSchool ?? this.nameOfSchool,
    periodOfAttendance: periodOfAttendance ?? this.periodOfAttendance,
    yearGraduate: yearGraduate ?? this.yearGraduate,
  );
  EducBg copyWithCompanion(EducBgsCompanion data) {
    return EducBg(
      educBgId: data.educBgId.present ? data.educBgId.value : this.educBgId,
      youthUserId:
          data.youthUserId.present ? data.youthUserId.value : this.youthUserId,
      level: data.level.present ? data.level.value : this.level,
      nameOfSchool:
          data.nameOfSchool.present
              ? data.nameOfSchool.value
              : this.nameOfSchool,
      periodOfAttendance:
          data.periodOfAttendance.present
              ? data.periodOfAttendance.value
              : this.periodOfAttendance,
      yearGraduate:
          data.yearGraduate.present
              ? data.yearGraduate.value
              : this.yearGraduate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EducBg(')
          ..write('educBgId: $educBgId, ')
          ..write('youthUserId: $youthUserId, ')
          ..write('level: $level, ')
          ..write('nameOfSchool: $nameOfSchool, ')
          ..write('periodOfAttendance: $periodOfAttendance, ')
          ..write('yearGraduate: $yearGraduate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    educBgId,
    youthUserId,
    level,
    nameOfSchool,
    periodOfAttendance,
    yearGraduate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EducBg &&
          other.educBgId == this.educBgId &&
          other.youthUserId == this.youthUserId &&
          other.level == this.level &&
          other.nameOfSchool == this.nameOfSchool &&
          other.periodOfAttendance == this.periodOfAttendance &&
          other.yearGraduate == this.yearGraduate);
}

class EducBgsCompanion extends UpdateCompanion<EducBg> {
  final Value<int> educBgId;
  final Value<int> youthUserId;
  final Value<String> level;
  final Value<String> nameOfSchool;
  final Value<String> periodOfAttendance;
  final Value<String> yearGraduate;
  const EducBgsCompanion({
    this.educBgId = const Value.absent(),
    this.youthUserId = const Value.absent(),
    this.level = const Value.absent(),
    this.nameOfSchool = const Value.absent(),
    this.periodOfAttendance = const Value.absent(),
    this.yearGraduate = const Value.absent(),
  });
  EducBgsCompanion.insert({
    this.educBgId = const Value.absent(),
    required int youthUserId,
    required String level,
    required String nameOfSchool,
    required String periodOfAttendance,
    required String yearGraduate,
  }) : youthUserId = Value(youthUserId),
       level = Value(level),
       nameOfSchool = Value(nameOfSchool),
       periodOfAttendance = Value(periodOfAttendance),
       yearGraduate = Value(yearGraduate);
  static Insertable<EducBg> custom({
    Expression<int>? educBgId,
    Expression<int>? youthUserId,
    Expression<String>? level,
    Expression<String>? nameOfSchool,
    Expression<String>? periodOfAttendance,
    Expression<String>? yearGraduate,
  }) {
    return RawValuesInsertable({
      if (educBgId != null) 'educ_bg_id': educBgId,
      if (youthUserId != null) 'youth_user_id': youthUserId,
      if (level != null) 'level': level,
      if (nameOfSchool != null) 'name_of_school': nameOfSchool,
      if (periodOfAttendance != null)
        'period_of_attendance': periodOfAttendance,
      if (yearGraduate != null) 'year_graduate': yearGraduate,
    });
  }

  EducBgsCompanion copyWith({
    Value<int>? educBgId,
    Value<int>? youthUserId,
    Value<String>? level,
    Value<String>? nameOfSchool,
    Value<String>? periodOfAttendance,
    Value<String>? yearGraduate,
  }) {
    return EducBgsCompanion(
      educBgId: educBgId ?? this.educBgId,
      youthUserId: youthUserId ?? this.youthUserId,
      level: level ?? this.level,
      nameOfSchool: nameOfSchool ?? this.nameOfSchool,
      periodOfAttendance: periodOfAttendance ?? this.periodOfAttendance,
      yearGraduate: yearGraduate ?? this.yearGraduate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (educBgId.present) {
      map['educ_bg_id'] = Variable<int>(educBgId.value);
    }
    if (youthUserId.present) {
      map['youth_user_id'] = Variable<int>(youthUserId.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (nameOfSchool.present) {
      map['name_of_school'] = Variable<String>(nameOfSchool.value);
    }
    if (periodOfAttendance.present) {
      map['period_of_attendance'] = Variable<String>(periodOfAttendance.value);
    }
    if (yearGraduate.present) {
      map['year_graduate'] = Variable<String>(yearGraduate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EducBgsCompanion(')
          ..write('educBgId: $educBgId, ')
          ..write('youthUserId: $youthUserId, ')
          ..write('level: $level, ')
          ..write('nameOfSchool: $nameOfSchool, ')
          ..write('periodOfAttendance: $periodOfAttendance, ')
          ..write('yearGraduate: $yearGraduate')
          ..write(')'))
        .toString();
  }
}

class $CivicInvolvementsTable extends CivicInvolvements
    with TableInfo<$CivicInvolvementsTable, CivicInvolvement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CivicInvolvementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _civicInvolvementIdMeta =
      const VerificationMeta('civicInvolvementId');
  @override
  late final GeneratedColumn<int> civicInvolvementId = GeneratedColumn<int>(
    'civic_involvement_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _youthUserIdMeta = const VerificationMeta(
    'youthUserId',
  );
  @override
  late final GeneratedColumn<int> youthUserId = GeneratedColumn<int>(
    'youth_user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints:
        'REFERENCES youth_users(youth_user_id) ON DELETE CASCADE NOT NULL',
  );
  static const VerificationMeta _nameOfOrganizationMeta =
      const VerificationMeta('nameOfOrganization');
  @override
  late final GeneratedColumn<String> nameOfOrganization =
      GeneratedColumn<String>(
        'name_of_organization',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _addressOfOrganizationMeta =
      const VerificationMeta('addressOfOrganization');
  @override
  late final GeneratedColumn<String> addressOfOrganization =
      GeneratedColumn<String>(
        'address_of_organization',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _startMeta = const VerificationMeta('start');
  @override
  late final GeneratedColumn<String> start = GeneratedColumn<String>(
    'start',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMeta = const VerificationMeta('end');
  @override
  late final GeneratedColumn<String> end = GeneratedColumn<String>(
    'end',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearGraduatedMeta = const VerificationMeta(
    'yearGraduated',
  );
  @override
  late final GeneratedColumn<String> yearGraduated = GeneratedColumn<String>(
    'year_graduated',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    civicInvolvementId,
    youthUserId,
    nameOfOrganization,
    addressOfOrganization,
    start,
    end,
    yearGraduated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'civic_involvements';
  @override
  VerificationContext validateIntegrity(
    Insertable<CivicInvolvement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('civic_involvement_id')) {
      context.handle(
        _civicInvolvementIdMeta,
        civicInvolvementId.isAcceptableOrUnknown(
          data['civic_involvement_id']!,
          _civicInvolvementIdMeta,
        ),
      );
    }
    if (data.containsKey('youth_user_id')) {
      context.handle(
        _youthUserIdMeta,
        youthUserId.isAcceptableOrUnknown(
          data['youth_user_id']!,
          _youthUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_youthUserIdMeta);
    }
    if (data.containsKey('name_of_organization')) {
      context.handle(
        _nameOfOrganizationMeta,
        nameOfOrganization.isAcceptableOrUnknown(
          data['name_of_organization']!,
          _nameOfOrganizationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameOfOrganizationMeta);
    }
    if (data.containsKey('address_of_organization')) {
      context.handle(
        _addressOfOrganizationMeta,
        addressOfOrganization.isAcceptableOrUnknown(
          data['address_of_organization']!,
          _addressOfOrganizationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_addressOfOrganizationMeta);
    }
    if (data.containsKey('start')) {
      context.handle(
        _startMeta,
        start.isAcceptableOrUnknown(data['start']!, _startMeta),
      );
    } else if (isInserting) {
      context.missing(_startMeta);
    }
    if (data.containsKey('end')) {
      context.handle(
        _endMeta,
        end.isAcceptableOrUnknown(data['end']!, _endMeta),
      );
    } else if (isInserting) {
      context.missing(_endMeta);
    }
    if (data.containsKey('year_graduated')) {
      context.handle(
        _yearGraduatedMeta,
        yearGraduated.isAcceptableOrUnknown(
          data['year_graduated']!,
          _yearGraduatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_yearGraduatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {civicInvolvementId};
  @override
  CivicInvolvement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CivicInvolvement(
      civicInvolvementId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}civic_involvement_id'],
          )!,
      youthUserId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}youth_user_id'],
          )!,
      nameOfOrganization:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name_of_organization'],
          )!,
      addressOfOrganization:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}address_of_organization'],
          )!,
      start:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}start'],
          )!,
      end:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}end'],
          )!,
      yearGraduated:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}year_graduated'],
          )!,
    );
  }

  @override
  $CivicInvolvementsTable createAlias(String alias) {
    return $CivicInvolvementsTable(attachedDatabase, alias);
  }
}

class CivicInvolvement extends DataClass
    implements Insertable<CivicInvolvement> {
  final int civicInvolvementId;
  final int youthUserId;
  final String nameOfOrganization;
  final String addressOfOrganization;
  final String start;
  final String end;
  final String yearGraduated;
  const CivicInvolvement({
    required this.civicInvolvementId,
    required this.youthUserId,
    required this.nameOfOrganization,
    required this.addressOfOrganization,
    required this.start,
    required this.end,
    required this.yearGraduated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['civic_involvement_id'] = Variable<int>(civicInvolvementId);
    map['youth_user_id'] = Variable<int>(youthUserId);
    map['name_of_organization'] = Variable<String>(nameOfOrganization);
    map['address_of_organization'] = Variable<String>(addressOfOrganization);
    map['start'] = Variable<String>(start);
    map['end'] = Variable<String>(end);
    map['year_graduated'] = Variable<String>(yearGraduated);
    return map;
  }

  CivicInvolvementsCompanion toCompanion(bool nullToAbsent) {
    return CivicInvolvementsCompanion(
      civicInvolvementId: Value(civicInvolvementId),
      youthUserId: Value(youthUserId),
      nameOfOrganization: Value(nameOfOrganization),
      addressOfOrganization: Value(addressOfOrganization),
      start: Value(start),
      end: Value(end),
      yearGraduated: Value(yearGraduated),
    );
  }

  factory CivicInvolvement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CivicInvolvement(
      civicInvolvementId: serializer.fromJson<int>(json['civicInvolvementId']),
      youthUserId: serializer.fromJson<int>(json['youthUserId']),
      nameOfOrganization: serializer.fromJson<String>(
        json['nameOfOrganization'],
      ),
      addressOfOrganization: serializer.fromJson<String>(
        json['addressOfOrganization'],
      ),
      start: serializer.fromJson<String>(json['start']),
      end: serializer.fromJson<String>(json['end']),
      yearGraduated: serializer.fromJson<String>(json['yearGraduated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'civicInvolvementId': serializer.toJson<int>(civicInvolvementId),
      'youthUserId': serializer.toJson<int>(youthUserId),
      'nameOfOrganization': serializer.toJson<String>(nameOfOrganization),
      'addressOfOrganization': serializer.toJson<String>(addressOfOrganization),
      'start': serializer.toJson<String>(start),
      'end': serializer.toJson<String>(end),
      'yearGraduated': serializer.toJson<String>(yearGraduated),
    };
  }

  CivicInvolvement copyWith({
    int? civicInvolvementId,
    int? youthUserId,
    String? nameOfOrganization,
    String? addressOfOrganization,
    String? start,
    String? end,
    String? yearGraduated,
  }) => CivicInvolvement(
    civicInvolvementId: civicInvolvementId ?? this.civicInvolvementId,
    youthUserId: youthUserId ?? this.youthUserId,
    nameOfOrganization: nameOfOrganization ?? this.nameOfOrganization,
    addressOfOrganization: addressOfOrganization ?? this.addressOfOrganization,
    start: start ?? this.start,
    end: end ?? this.end,
    yearGraduated: yearGraduated ?? this.yearGraduated,
  );
  CivicInvolvement copyWithCompanion(CivicInvolvementsCompanion data) {
    return CivicInvolvement(
      civicInvolvementId:
          data.civicInvolvementId.present
              ? data.civicInvolvementId.value
              : this.civicInvolvementId,
      youthUserId:
          data.youthUserId.present ? data.youthUserId.value : this.youthUserId,
      nameOfOrganization:
          data.nameOfOrganization.present
              ? data.nameOfOrganization.value
              : this.nameOfOrganization,
      addressOfOrganization:
          data.addressOfOrganization.present
              ? data.addressOfOrganization.value
              : this.addressOfOrganization,
      start: data.start.present ? data.start.value : this.start,
      end: data.end.present ? data.end.value : this.end,
      yearGraduated:
          data.yearGraduated.present
              ? data.yearGraduated.value
              : this.yearGraduated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CivicInvolvement(')
          ..write('civicInvolvementId: $civicInvolvementId, ')
          ..write('youthUserId: $youthUserId, ')
          ..write('nameOfOrganization: $nameOfOrganization, ')
          ..write('addressOfOrganization: $addressOfOrganization, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('yearGraduated: $yearGraduated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    civicInvolvementId,
    youthUserId,
    nameOfOrganization,
    addressOfOrganization,
    start,
    end,
    yearGraduated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CivicInvolvement &&
          other.civicInvolvementId == this.civicInvolvementId &&
          other.youthUserId == this.youthUserId &&
          other.nameOfOrganization == this.nameOfOrganization &&
          other.addressOfOrganization == this.addressOfOrganization &&
          other.start == this.start &&
          other.end == this.end &&
          other.yearGraduated == this.yearGraduated);
}

class CivicInvolvementsCompanion extends UpdateCompanion<CivicInvolvement> {
  final Value<int> civicInvolvementId;
  final Value<int> youthUserId;
  final Value<String> nameOfOrganization;
  final Value<String> addressOfOrganization;
  final Value<String> start;
  final Value<String> end;
  final Value<String> yearGraduated;
  const CivicInvolvementsCompanion({
    this.civicInvolvementId = const Value.absent(),
    this.youthUserId = const Value.absent(),
    this.nameOfOrganization = const Value.absent(),
    this.addressOfOrganization = const Value.absent(),
    this.start = const Value.absent(),
    this.end = const Value.absent(),
    this.yearGraduated = const Value.absent(),
  });
  CivicInvolvementsCompanion.insert({
    this.civicInvolvementId = const Value.absent(),
    required int youthUserId,
    required String nameOfOrganization,
    required String addressOfOrganization,
    required String start,
    required String end,
    required String yearGraduated,
  }) : youthUserId = Value(youthUserId),
       nameOfOrganization = Value(nameOfOrganization),
       addressOfOrganization = Value(addressOfOrganization),
       start = Value(start),
       end = Value(end),
       yearGraduated = Value(yearGraduated);
  static Insertable<CivicInvolvement> custom({
    Expression<int>? civicInvolvementId,
    Expression<int>? youthUserId,
    Expression<String>? nameOfOrganization,
    Expression<String>? addressOfOrganization,
    Expression<String>? start,
    Expression<String>? end,
    Expression<String>? yearGraduated,
  }) {
    return RawValuesInsertable({
      if (civicInvolvementId != null)
        'civic_involvement_id': civicInvolvementId,
      if (youthUserId != null) 'youth_user_id': youthUserId,
      if (nameOfOrganization != null)
        'name_of_organization': nameOfOrganization,
      if (addressOfOrganization != null)
        'address_of_organization': addressOfOrganization,
      if (start != null) 'start': start,
      if (end != null) 'end': end,
      if (yearGraduated != null) 'year_graduated': yearGraduated,
    });
  }

  CivicInvolvementsCompanion copyWith({
    Value<int>? civicInvolvementId,
    Value<int>? youthUserId,
    Value<String>? nameOfOrganization,
    Value<String>? addressOfOrganization,
    Value<String>? start,
    Value<String>? end,
    Value<String>? yearGraduated,
  }) {
    return CivicInvolvementsCompanion(
      civicInvolvementId: civicInvolvementId ?? this.civicInvolvementId,
      youthUserId: youthUserId ?? this.youthUserId,
      nameOfOrganization: nameOfOrganization ?? this.nameOfOrganization,
      addressOfOrganization:
          addressOfOrganization ?? this.addressOfOrganization,
      start: start ?? this.start,
      end: end ?? this.end,
      yearGraduated: yearGraduated ?? this.yearGraduated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (civicInvolvementId.present) {
      map['civic_involvement_id'] = Variable<int>(civicInvolvementId.value);
    }
    if (youthUserId.present) {
      map['youth_user_id'] = Variable<int>(youthUserId.value);
    }
    if (nameOfOrganization.present) {
      map['name_of_organization'] = Variable<String>(nameOfOrganization.value);
    }
    if (addressOfOrganization.present) {
      map['address_of_organization'] = Variable<String>(
        addressOfOrganization.value,
      );
    }
    if (start.present) {
      map['start'] = Variable<String>(start.value);
    }
    if (end.present) {
      map['end'] = Variable<String>(end.value);
    }
    if (yearGraduated.present) {
      map['year_graduated'] = Variable<String>(yearGraduated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CivicInvolvementsCompanion(')
          ..write('civicInvolvementId: $civicInvolvementId, ')
          ..write('youthUserId: $youthUserId, ')
          ..write('nameOfOrganization: $nameOfOrganization, ')
          ..write('addressOfOrganization: $addressOfOrganization, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('yearGraduated: $yearGraduated')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $YouthUsersTable youthUsers = $YouthUsersTable(this);
  late final $YouthInfosTable youthInfos = $YouthInfosTable(this);
  late final $EducBgsTable educBgs = $EducBgsTable(this);
  late final $CivicInvolvementsTable civicInvolvements =
      $CivicInvolvementsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    youthUsers,
    youthInfos,
    educBgs,
    civicInvolvements,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'youth_users',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('youth_infos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'youth_users',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('educ_bgs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'youth_users',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('civic_involvements', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String userName,
      required String password,
      required String token,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> userName,
      Value<String> password,
      Value<String> token,
      Value<int> rowid,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userName =>
      $composableBuilder(column: $table.userName, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get token =>
      $composableBuilder(column: $table.token, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userName = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<String> token = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                userName: userName,
                password: password,
                token: token,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userName,
                required String password,
                required String token,
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                userName: userName,
                password: password,
                token: token,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$YouthUsersTableCreateCompanionBuilder =
    YouthUsersCompanion Function({
      Value<int> youthUserId,
      Value<int?> userId,
      required String youthType,
      required String skills,
      required String status,
      Value<DateTime> registerAt,
    });
typedef $$YouthUsersTableUpdateCompanionBuilder =
    YouthUsersCompanion Function({
      Value<int> youthUserId,
      Value<int?> userId,
      Value<String> youthType,
      Value<String> skills,
      Value<String> status,
      Value<DateTime> registerAt,
    });

final class $$YouthUsersTableReferences
    extends BaseReferences<_$AppDatabase, $YouthUsersTable, YouthUser> {
  $$YouthUsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$YouthInfosTable, List<YouthInfo>>
  _youthInfosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.youthInfos,
    aliasName: $_aliasNameGenerator(
      db.youthUsers.youthUserId,
      db.youthInfos.youthUserId,
    ),
  );

  $$YouthInfosTableProcessedTableManager get youthInfosRefs {
    final manager = $$YouthInfosTableTableManager($_db, $_db.youthInfos).filter(
      (f) => f.youthUserId.youthUserId.sqlEquals(
        $_itemColumn<int>('youth_user_id')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(_youthInfosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EducBgsTable, List<EducBg>> _educBgsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.educBgs,
    aliasName: $_aliasNameGenerator(
      db.youthUsers.youthUserId,
      db.educBgs.youthUserId,
    ),
  );

  $$EducBgsTableProcessedTableManager get educBgsRefs {
    final manager = $$EducBgsTableTableManager($_db, $_db.educBgs).filter(
      (f) => f.youthUserId.youthUserId.sqlEquals(
        $_itemColumn<int>('youth_user_id')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(_educBgsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CivicInvolvementsTable, List<CivicInvolvement>>
  _civicInvolvementsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.civicInvolvements,
        aliasName: $_aliasNameGenerator(
          db.youthUsers.youthUserId,
          db.civicInvolvements.youthUserId,
        ),
      );

  $$CivicInvolvementsTableProcessedTableManager get civicInvolvementsRefs {
    final manager = $$CivicInvolvementsTableTableManager(
      $_db,
      $_db.civicInvolvements,
    ).filter(
      (f) => f.youthUserId.youthUserId.sqlEquals(
        $_itemColumn<int>('youth_user_id')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(
      _civicInvolvementsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$YouthUsersTableFilterComposer
    extends Composer<_$AppDatabase, $YouthUsersTable> {
  $$YouthUsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get youthUserId => $composableBuilder(
    column: $table.youthUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get youthType => $composableBuilder(
    column: $table.youthType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get skills => $composableBuilder(
    column: $table.skills,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get registerAt => $composableBuilder(
    column: $table.registerAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> youthInfosRefs(
    Expression<bool> Function($$YouthInfosTableFilterComposer f) f,
  ) {
    final $$YouthInfosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.youthUserId,
      referencedTable: $db.youthInfos,
      getReferencedColumn: (t) => t.youthUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YouthInfosTableFilterComposer(
            $db: $db,
            $table: $db.youthInfos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> educBgsRefs(
    Expression<bool> Function($$EducBgsTableFilterComposer f) f,
  ) {
    final $$EducBgsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.youthUserId,
      referencedTable: $db.educBgs,
      getReferencedColumn: (t) => t.youthUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EducBgsTableFilterComposer(
            $db: $db,
            $table: $db.educBgs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> civicInvolvementsRefs(
    Expression<bool> Function($$CivicInvolvementsTableFilterComposer f) f,
  ) {
    final $$CivicInvolvementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.youthUserId,
      referencedTable: $db.civicInvolvements,
      getReferencedColumn: (t) => t.youthUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CivicInvolvementsTableFilterComposer(
            $db: $db,
            $table: $db.civicInvolvements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$YouthUsersTableOrderingComposer
    extends Composer<_$AppDatabase, $YouthUsersTable> {
  $$YouthUsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get youthUserId => $composableBuilder(
    column: $table.youthUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get youthType => $composableBuilder(
    column: $table.youthType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get skills => $composableBuilder(
    column: $table.skills,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get registerAt => $composableBuilder(
    column: $table.registerAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$YouthUsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $YouthUsersTable> {
  $$YouthUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get youthUserId => $composableBuilder(
    column: $table.youthUserId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get youthType =>
      $composableBuilder(column: $table.youthType, builder: (column) => column);

  GeneratedColumn<String> get skills =>
      $composableBuilder(column: $table.skills, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get registerAt => $composableBuilder(
    column: $table.registerAt,
    builder: (column) => column,
  );

  Expression<T> youthInfosRefs<T extends Object>(
    Expression<T> Function($$YouthInfosTableAnnotationComposer a) f,
  ) {
    final $$YouthInfosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.youthUserId,
      referencedTable: $db.youthInfos,
      getReferencedColumn: (t) => t.youthUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YouthInfosTableAnnotationComposer(
            $db: $db,
            $table: $db.youthInfos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> educBgsRefs<T extends Object>(
    Expression<T> Function($$EducBgsTableAnnotationComposer a) f,
  ) {
    final $$EducBgsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.youthUserId,
      referencedTable: $db.educBgs,
      getReferencedColumn: (t) => t.youthUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EducBgsTableAnnotationComposer(
            $db: $db,
            $table: $db.educBgs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> civicInvolvementsRefs<T extends Object>(
    Expression<T> Function($$CivicInvolvementsTableAnnotationComposer a) f,
  ) {
    final $$CivicInvolvementsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.youthUserId,
          referencedTable: $db.civicInvolvements,
          getReferencedColumn: (t) => t.youthUserId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CivicInvolvementsTableAnnotationComposer(
                $db: $db,
                $table: $db.civicInvolvements,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$YouthUsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $YouthUsersTable,
          YouthUser,
          $$YouthUsersTableFilterComposer,
          $$YouthUsersTableOrderingComposer,
          $$YouthUsersTableAnnotationComposer,
          $$YouthUsersTableCreateCompanionBuilder,
          $$YouthUsersTableUpdateCompanionBuilder,
          (YouthUser, $$YouthUsersTableReferences),
          YouthUser,
          PrefetchHooks Function({
            bool youthInfosRefs,
            bool educBgsRefs,
            bool civicInvolvementsRefs,
          })
        > {
  $$YouthUsersTableTableManager(_$AppDatabase db, $YouthUsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$YouthUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$YouthUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$YouthUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> youthUserId = const Value.absent(),
                Value<int?> userId = const Value.absent(),
                Value<String> youthType = const Value.absent(),
                Value<String> skills = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> registerAt = const Value.absent(),
              }) => YouthUsersCompanion(
                youthUserId: youthUserId,
                userId: userId,
                youthType: youthType,
                skills: skills,
                status: status,
                registerAt: registerAt,
              ),
          createCompanionCallback:
              ({
                Value<int> youthUserId = const Value.absent(),
                Value<int?> userId = const Value.absent(),
                required String youthType,
                required String skills,
                required String status,
                Value<DateTime> registerAt = const Value.absent(),
              }) => YouthUsersCompanion.insert(
                youthUserId: youthUserId,
                userId: userId,
                youthType: youthType,
                skills: skills,
                status: status,
                registerAt: registerAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$YouthUsersTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            youthInfosRefs = false,
            educBgsRefs = false,
            civicInvolvementsRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (youthInfosRefs) db.youthInfos,
                if (educBgsRefs) db.educBgs,
                if (civicInvolvementsRefs) db.civicInvolvements,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (youthInfosRefs)
                    await $_getPrefetchedData<
                      YouthUser,
                      $YouthUsersTable,
                      YouthInfo
                    >(
                      currentTable: table,
                      referencedTable: $$YouthUsersTableReferences
                          ._youthInfosRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$YouthUsersTableReferences(
                                db,
                                table,
                                p0,
                              ).youthInfosRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.youthUserId == item.youthUserId,
                          ),
                      typedResults: items,
                    ),
                  if (educBgsRefs)
                    await $_getPrefetchedData<
                      YouthUser,
                      $YouthUsersTable,
                      EducBg
                    >(
                      currentTable: table,
                      referencedTable: $$YouthUsersTableReferences
                          ._educBgsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$YouthUsersTableReferences(
                                db,
                                table,
                                p0,
                              ).educBgsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.youthUserId == item.youthUserId,
                          ),
                      typedResults: items,
                    ),
                  if (civicInvolvementsRefs)
                    await $_getPrefetchedData<
                      YouthUser,
                      $YouthUsersTable,
                      CivicInvolvement
                    >(
                      currentTable: table,
                      referencedTable: $$YouthUsersTableReferences
                          ._civicInvolvementsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$YouthUsersTableReferences(
                                db,
                                table,
                                p0,
                              ).civicInvolvementsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.youthUserId == item.youthUserId,
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

typedef $$YouthUsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $YouthUsersTable,
      YouthUser,
      $$YouthUsersTableFilterComposer,
      $$YouthUsersTableOrderingComposer,
      $$YouthUsersTableAnnotationComposer,
      $$YouthUsersTableCreateCompanionBuilder,
      $$YouthUsersTableUpdateCompanionBuilder,
      (YouthUser, $$YouthUsersTableReferences),
      YouthUser,
      PrefetchHooks Function({
        bool youthInfosRefs,
        bool educBgsRefs,
        bool civicInvolvementsRefs,
      })
    >;
typedef $$YouthInfosTableCreateCompanionBuilder =
    YouthInfosCompanion Function({
      Value<int> youthInfosId,
      required int youthUserId,
      required String fname,
      required String mname,
      required String lname,
      required int age,
      Value<String?> gender,
      required String sex,
      required String dateOfBirth,
      required String placeOfBirth,
      required String contactNo,
      required double height,
      required double weight,
      required String religion,
      required String occupation,
      required String civilStatus,
      required int noOfChildren,
    });
typedef $$YouthInfosTableUpdateCompanionBuilder =
    YouthInfosCompanion Function({
      Value<int> youthInfosId,
      Value<int> youthUserId,
      Value<String> fname,
      Value<String> mname,
      Value<String> lname,
      Value<int> age,
      Value<String?> gender,
      Value<String> sex,
      Value<String> dateOfBirth,
      Value<String> placeOfBirth,
      Value<String> contactNo,
      Value<double> height,
      Value<double> weight,
      Value<String> religion,
      Value<String> occupation,
      Value<String> civilStatus,
      Value<int> noOfChildren,
    });

final class $$YouthInfosTableReferences
    extends BaseReferences<_$AppDatabase, $YouthInfosTable, YouthInfo> {
  $$YouthInfosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $YouthUsersTable _youthUserIdTable(_$AppDatabase db) =>
      db.youthUsers.createAlias(
        $_aliasNameGenerator(
          db.youthInfos.youthUserId,
          db.youthUsers.youthUserId,
        ),
      );

  $$YouthUsersTableProcessedTableManager get youthUserId {
    final $_column = $_itemColumn<int>('youth_user_id')!;

    final manager = $$YouthUsersTableTableManager(
      $_db,
      $_db.youthUsers,
    ).filter((f) => f.youthUserId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_youthUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$YouthInfosTableFilterComposer
    extends Composer<_$AppDatabase, $YouthInfosTable> {
  $$YouthInfosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get youthInfosId => $composableBuilder(
    column: $table.youthInfosId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fname => $composableBuilder(
    column: $table.fname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mname => $composableBuilder(
    column: $table.mname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lname => $composableBuilder(
    column: $table.lname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeOfBirth => $composableBuilder(
    column: $table.placeOfBirth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactNo => $composableBuilder(
    column: $table.contactNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get religion => $composableBuilder(
    column: $table.religion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get civilStatus => $composableBuilder(
    column: $table.civilStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get noOfChildren => $composableBuilder(
    column: $table.noOfChildren,
    builder: (column) => ColumnFilters(column),
  );

  $$YouthUsersTableFilterComposer get youthUserId {
    final $$YouthUsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.youthUserId,
      referencedTable: $db.youthUsers,
      getReferencedColumn: (t) => t.youthUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YouthUsersTableFilterComposer(
            $db: $db,
            $table: $db.youthUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$YouthInfosTableOrderingComposer
    extends Composer<_$AppDatabase, $YouthInfosTable> {
  $$YouthInfosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get youthInfosId => $composableBuilder(
    column: $table.youthInfosId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fname => $composableBuilder(
    column: $table.fname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mname => $composableBuilder(
    column: $table.mname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lname => $composableBuilder(
    column: $table.lname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeOfBirth => $composableBuilder(
    column: $table.placeOfBirth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactNo => $composableBuilder(
    column: $table.contactNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get religion => $composableBuilder(
    column: $table.religion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get civilStatus => $composableBuilder(
    column: $table.civilStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get noOfChildren => $composableBuilder(
    column: $table.noOfChildren,
    builder: (column) => ColumnOrderings(column),
  );

  $$YouthUsersTableOrderingComposer get youthUserId {
    final $$YouthUsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.youthUserId,
      referencedTable: $db.youthUsers,
      getReferencedColumn: (t) => t.youthUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YouthUsersTableOrderingComposer(
            $db: $db,
            $table: $db.youthUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$YouthInfosTableAnnotationComposer
    extends Composer<_$AppDatabase, $YouthInfosTable> {
  $$YouthInfosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get youthInfosId => $composableBuilder(
    column: $table.youthInfosId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fname =>
      $composableBuilder(column: $table.fname, builder: (column) => column);

  GeneratedColumn<String> get mname =>
      $composableBuilder(column: $table.mname, builder: (column) => column);

  GeneratedColumn<String> get lname =>
      $composableBuilder(column: $table.lname, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get placeOfBirth => $composableBuilder(
    column: $table.placeOfBirth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contactNo =>
      $composableBuilder(column: $table.contactNo, builder: (column) => column);

  GeneratedColumn<double> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<String> get religion =>
      $composableBuilder(column: $table.religion, builder: (column) => column);

  GeneratedColumn<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get civilStatus => $composableBuilder(
    column: $table.civilStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get noOfChildren => $composableBuilder(
    column: $table.noOfChildren,
    builder: (column) => column,
  );

  $$YouthUsersTableAnnotationComposer get youthUserId {
    final $$YouthUsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.youthUserId,
      referencedTable: $db.youthUsers,
      getReferencedColumn: (t) => t.youthUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YouthUsersTableAnnotationComposer(
            $db: $db,
            $table: $db.youthUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$YouthInfosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $YouthInfosTable,
          YouthInfo,
          $$YouthInfosTableFilterComposer,
          $$YouthInfosTableOrderingComposer,
          $$YouthInfosTableAnnotationComposer,
          $$YouthInfosTableCreateCompanionBuilder,
          $$YouthInfosTableUpdateCompanionBuilder,
          (YouthInfo, $$YouthInfosTableReferences),
          YouthInfo,
          PrefetchHooks Function({bool youthUserId})
        > {
  $$YouthInfosTableTableManager(_$AppDatabase db, $YouthInfosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$YouthInfosTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$YouthInfosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$YouthInfosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> youthInfosId = const Value.absent(),
                Value<int> youthUserId = const Value.absent(),
                Value<String> fname = const Value.absent(),
                Value<String> mname = const Value.absent(),
                Value<String> lname = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String> sex = const Value.absent(),
                Value<String> dateOfBirth = const Value.absent(),
                Value<String> placeOfBirth = const Value.absent(),
                Value<String> contactNo = const Value.absent(),
                Value<double> height = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<String> religion = const Value.absent(),
                Value<String> occupation = const Value.absent(),
                Value<String> civilStatus = const Value.absent(),
                Value<int> noOfChildren = const Value.absent(),
              }) => YouthInfosCompanion(
                youthInfosId: youthInfosId,
                youthUserId: youthUserId,
                fname: fname,
                mname: mname,
                lname: lname,
                age: age,
                gender: gender,
                sex: sex,
                dateOfBirth: dateOfBirth,
                placeOfBirth: placeOfBirth,
                contactNo: contactNo,
                height: height,
                weight: weight,
                religion: religion,
                occupation: occupation,
                civilStatus: civilStatus,
                noOfChildren: noOfChildren,
              ),
          createCompanionCallback:
              ({
                Value<int> youthInfosId = const Value.absent(),
                required int youthUserId,
                required String fname,
                required String mname,
                required String lname,
                required int age,
                Value<String?> gender = const Value.absent(),
                required String sex,
                required String dateOfBirth,
                required String placeOfBirth,
                required String contactNo,
                required double height,
                required double weight,
                required String religion,
                required String occupation,
                required String civilStatus,
                required int noOfChildren,
              }) => YouthInfosCompanion.insert(
                youthInfosId: youthInfosId,
                youthUserId: youthUserId,
                fname: fname,
                mname: mname,
                lname: lname,
                age: age,
                gender: gender,
                sex: sex,
                dateOfBirth: dateOfBirth,
                placeOfBirth: placeOfBirth,
                contactNo: contactNo,
                height: height,
                weight: weight,
                religion: religion,
                occupation: occupation,
                civilStatus: civilStatus,
                noOfChildren: noOfChildren,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$YouthInfosTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({youthUserId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (youthUserId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.youthUserId,
                            referencedTable: $$YouthInfosTableReferences
                                ._youthUserIdTable(db),
                            referencedColumn:
                                $$YouthInfosTableReferences
                                    ._youthUserIdTable(db)
                                    .youthUserId,
                          )
                          as T;
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

typedef $$YouthInfosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $YouthInfosTable,
      YouthInfo,
      $$YouthInfosTableFilterComposer,
      $$YouthInfosTableOrderingComposer,
      $$YouthInfosTableAnnotationComposer,
      $$YouthInfosTableCreateCompanionBuilder,
      $$YouthInfosTableUpdateCompanionBuilder,
      (YouthInfo, $$YouthInfosTableReferences),
      YouthInfo,
      PrefetchHooks Function({bool youthUserId})
    >;
typedef $$EducBgsTableCreateCompanionBuilder =
    EducBgsCompanion Function({
      Value<int> educBgId,
      required int youthUserId,
      required String level,
      required String nameOfSchool,
      required String periodOfAttendance,
      required String yearGraduate,
    });
typedef $$EducBgsTableUpdateCompanionBuilder =
    EducBgsCompanion Function({
      Value<int> educBgId,
      Value<int> youthUserId,
      Value<String> level,
      Value<String> nameOfSchool,
      Value<String> periodOfAttendance,
      Value<String> yearGraduate,
    });

final class $$EducBgsTableReferences
    extends BaseReferences<_$AppDatabase, $EducBgsTable, EducBg> {
  $$EducBgsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $YouthUsersTable _youthUserIdTable(_$AppDatabase db) =>
      db.youthUsers.createAlias(
        $_aliasNameGenerator(db.educBgs.youthUserId, db.youthUsers.youthUserId),
      );

  $$YouthUsersTableProcessedTableManager get youthUserId {
    final $_column = $_itemColumn<int>('youth_user_id')!;

    final manager = $$YouthUsersTableTableManager(
      $_db,
      $_db.youthUsers,
    ).filter((f) => f.youthUserId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_youthUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EducBgsTableFilterComposer
    extends Composer<_$AppDatabase, $EducBgsTable> {
  $$EducBgsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get educBgId => $composableBuilder(
    column: $table.educBgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameOfSchool => $composableBuilder(
    column: $table.nameOfSchool,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get periodOfAttendance => $composableBuilder(
    column: $table.periodOfAttendance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get yearGraduate => $composableBuilder(
    column: $table.yearGraduate,
    builder: (column) => ColumnFilters(column),
  );

  $$YouthUsersTableFilterComposer get youthUserId {
    final $$YouthUsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.youthUserId,
      referencedTable: $db.youthUsers,
      getReferencedColumn: (t) => t.youthUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YouthUsersTableFilterComposer(
            $db: $db,
            $table: $db.youthUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EducBgsTableOrderingComposer
    extends Composer<_$AppDatabase, $EducBgsTable> {
  $$EducBgsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get educBgId => $composableBuilder(
    column: $table.educBgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameOfSchool => $composableBuilder(
    column: $table.nameOfSchool,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get periodOfAttendance => $composableBuilder(
    column: $table.periodOfAttendance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get yearGraduate => $composableBuilder(
    column: $table.yearGraduate,
    builder: (column) => ColumnOrderings(column),
  );

  $$YouthUsersTableOrderingComposer get youthUserId {
    final $$YouthUsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.youthUserId,
      referencedTable: $db.youthUsers,
      getReferencedColumn: (t) => t.youthUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YouthUsersTableOrderingComposer(
            $db: $db,
            $table: $db.youthUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EducBgsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EducBgsTable> {
  $$EducBgsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get educBgId =>
      $composableBuilder(column: $table.educBgId, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get nameOfSchool => $composableBuilder(
    column: $table.nameOfSchool,
    builder: (column) => column,
  );

  GeneratedColumn<String> get periodOfAttendance => $composableBuilder(
    column: $table.periodOfAttendance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get yearGraduate => $composableBuilder(
    column: $table.yearGraduate,
    builder: (column) => column,
  );

  $$YouthUsersTableAnnotationComposer get youthUserId {
    final $$YouthUsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.youthUserId,
      referencedTable: $db.youthUsers,
      getReferencedColumn: (t) => t.youthUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YouthUsersTableAnnotationComposer(
            $db: $db,
            $table: $db.youthUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EducBgsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EducBgsTable,
          EducBg,
          $$EducBgsTableFilterComposer,
          $$EducBgsTableOrderingComposer,
          $$EducBgsTableAnnotationComposer,
          $$EducBgsTableCreateCompanionBuilder,
          $$EducBgsTableUpdateCompanionBuilder,
          (EducBg, $$EducBgsTableReferences),
          EducBg,
          PrefetchHooks Function({bool youthUserId})
        > {
  $$EducBgsTableTableManager(_$AppDatabase db, $EducBgsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$EducBgsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$EducBgsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$EducBgsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> educBgId = const Value.absent(),
                Value<int> youthUserId = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String> nameOfSchool = const Value.absent(),
                Value<String> periodOfAttendance = const Value.absent(),
                Value<String> yearGraduate = const Value.absent(),
              }) => EducBgsCompanion(
                educBgId: educBgId,
                youthUserId: youthUserId,
                level: level,
                nameOfSchool: nameOfSchool,
                periodOfAttendance: periodOfAttendance,
                yearGraduate: yearGraduate,
              ),
          createCompanionCallback:
              ({
                Value<int> educBgId = const Value.absent(),
                required int youthUserId,
                required String level,
                required String nameOfSchool,
                required String periodOfAttendance,
                required String yearGraduate,
              }) => EducBgsCompanion.insert(
                educBgId: educBgId,
                youthUserId: youthUserId,
                level: level,
                nameOfSchool: nameOfSchool,
                periodOfAttendance: periodOfAttendance,
                yearGraduate: yearGraduate,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$EducBgsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({youthUserId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (youthUserId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.youthUserId,
                            referencedTable: $$EducBgsTableReferences
                                ._youthUserIdTable(db),
                            referencedColumn:
                                $$EducBgsTableReferences
                                    ._youthUserIdTable(db)
                                    .youthUserId,
                          )
                          as T;
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

typedef $$EducBgsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EducBgsTable,
      EducBg,
      $$EducBgsTableFilterComposer,
      $$EducBgsTableOrderingComposer,
      $$EducBgsTableAnnotationComposer,
      $$EducBgsTableCreateCompanionBuilder,
      $$EducBgsTableUpdateCompanionBuilder,
      (EducBg, $$EducBgsTableReferences),
      EducBg,
      PrefetchHooks Function({bool youthUserId})
    >;
typedef $$CivicInvolvementsTableCreateCompanionBuilder =
    CivicInvolvementsCompanion Function({
      Value<int> civicInvolvementId,
      required int youthUserId,
      required String nameOfOrganization,
      required String addressOfOrganization,
      required String start,
      required String end,
      required String yearGraduated,
    });
typedef $$CivicInvolvementsTableUpdateCompanionBuilder =
    CivicInvolvementsCompanion Function({
      Value<int> civicInvolvementId,
      Value<int> youthUserId,
      Value<String> nameOfOrganization,
      Value<String> addressOfOrganization,
      Value<String> start,
      Value<String> end,
      Value<String> yearGraduated,
    });

final class $$CivicInvolvementsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CivicInvolvementsTable,
          CivicInvolvement
        > {
  $$CivicInvolvementsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $YouthUsersTable _youthUserIdTable(_$AppDatabase db) =>
      db.youthUsers.createAlias(
        $_aliasNameGenerator(
          db.civicInvolvements.youthUserId,
          db.youthUsers.youthUserId,
        ),
      );

  $$YouthUsersTableProcessedTableManager get youthUserId {
    final $_column = $_itemColumn<int>('youth_user_id')!;

    final manager = $$YouthUsersTableTableManager(
      $_db,
      $_db.youthUsers,
    ).filter((f) => f.youthUserId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_youthUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CivicInvolvementsTableFilterComposer
    extends Composer<_$AppDatabase, $CivicInvolvementsTable> {
  $$CivicInvolvementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get civicInvolvementId => $composableBuilder(
    column: $table.civicInvolvementId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameOfOrganization => $composableBuilder(
    column: $table.nameOfOrganization,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressOfOrganization => $composableBuilder(
    column: $table.addressOfOrganization,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get yearGraduated => $composableBuilder(
    column: $table.yearGraduated,
    builder: (column) => ColumnFilters(column),
  );

  $$YouthUsersTableFilterComposer get youthUserId {
    final $$YouthUsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.youthUserId,
      referencedTable: $db.youthUsers,
      getReferencedColumn: (t) => t.youthUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YouthUsersTableFilterComposer(
            $db: $db,
            $table: $db.youthUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CivicInvolvementsTableOrderingComposer
    extends Composer<_$AppDatabase, $CivicInvolvementsTable> {
  $$CivicInvolvementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get civicInvolvementId => $composableBuilder(
    column: $table.civicInvolvementId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameOfOrganization => $composableBuilder(
    column: $table.nameOfOrganization,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressOfOrganization => $composableBuilder(
    column: $table.addressOfOrganization,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get yearGraduated => $composableBuilder(
    column: $table.yearGraduated,
    builder: (column) => ColumnOrderings(column),
  );

  $$YouthUsersTableOrderingComposer get youthUserId {
    final $$YouthUsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.youthUserId,
      referencedTable: $db.youthUsers,
      getReferencedColumn: (t) => t.youthUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YouthUsersTableOrderingComposer(
            $db: $db,
            $table: $db.youthUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CivicInvolvementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CivicInvolvementsTable> {
  $$CivicInvolvementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get civicInvolvementId => $composableBuilder(
    column: $table.civicInvolvementId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameOfOrganization => $composableBuilder(
    column: $table.nameOfOrganization,
    builder: (column) => column,
  );

  GeneratedColumn<String> get addressOfOrganization => $composableBuilder(
    column: $table.addressOfOrganization,
    builder: (column) => column,
  );

  GeneratedColumn<String> get start =>
      $composableBuilder(column: $table.start, builder: (column) => column);

  GeneratedColumn<String> get end =>
      $composableBuilder(column: $table.end, builder: (column) => column);

  GeneratedColumn<String> get yearGraduated => $composableBuilder(
    column: $table.yearGraduated,
    builder: (column) => column,
  );

  $$YouthUsersTableAnnotationComposer get youthUserId {
    final $$YouthUsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.youthUserId,
      referencedTable: $db.youthUsers,
      getReferencedColumn: (t) => t.youthUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YouthUsersTableAnnotationComposer(
            $db: $db,
            $table: $db.youthUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CivicInvolvementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CivicInvolvementsTable,
          CivicInvolvement,
          $$CivicInvolvementsTableFilterComposer,
          $$CivicInvolvementsTableOrderingComposer,
          $$CivicInvolvementsTableAnnotationComposer,
          $$CivicInvolvementsTableCreateCompanionBuilder,
          $$CivicInvolvementsTableUpdateCompanionBuilder,
          (CivicInvolvement, $$CivicInvolvementsTableReferences),
          CivicInvolvement,
          PrefetchHooks Function({bool youthUserId})
        > {
  $$CivicInvolvementsTableTableManager(
    _$AppDatabase db,
    $CivicInvolvementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CivicInvolvementsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$CivicInvolvementsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$CivicInvolvementsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> civicInvolvementId = const Value.absent(),
                Value<int> youthUserId = const Value.absent(),
                Value<String> nameOfOrganization = const Value.absent(),
                Value<String> addressOfOrganization = const Value.absent(),
                Value<String> start = const Value.absent(),
                Value<String> end = const Value.absent(),
                Value<String> yearGraduated = const Value.absent(),
              }) => CivicInvolvementsCompanion(
                civicInvolvementId: civicInvolvementId,
                youthUserId: youthUserId,
                nameOfOrganization: nameOfOrganization,
                addressOfOrganization: addressOfOrganization,
                start: start,
                end: end,
                yearGraduated: yearGraduated,
              ),
          createCompanionCallback:
              ({
                Value<int> civicInvolvementId = const Value.absent(),
                required int youthUserId,
                required String nameOfOrganization,
                required String addressOfOrganization,
                required String start,
                required String end,
                required String yearGraduated,
              }) => CivicInvolvementsCompanion.insert(
                civicInvolvementId: civicInvolvementId,
                youthUserId: youthUserId,
                nameOfOrganization: nameOfOrganization,
                addressOfOrganization: addressOfOrganization,
                start: start,
                end: end,
                yearGraduated: yearGraduated,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$CivicInvolvementsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({youthUserId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (youthUserId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.youthUserId,
                            referencedTable: $$CivicInvolvementsTableReferences
                                ._youthUserIdTable(db),
                            referencedColumn:
                                $$CivicInvolvementsTableReferences
                                    ._youthUserIdTable(db)
                                    .youthUserId,
                          )
                          as T;
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

typedef $$CivicInvolvementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CivicInvolvementsTable,
      CivicInvolvement,
      $$CivicInvolvementsTableFilterComposer,
      $$CivicInvolvementsTableOrderingComposer,
      $$CivicInvolvementsTableAnnotationComposer,
      $$CivicInvolvementsTableCreateCompanionBuilder,
      $$CivicInvolvementsTableUpdateCompanionBuilder,
      (CivicInvolvement, $$CivicInvolvementsTableReferences),
      CivicInvolvement,
      PrefetchHooks Function({bool youthUserId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$YouthUsersTableTableManager get youthUsers =>
      $$YouthUsersTableTableManager(_db, _db.youthUsers);
  $$YouthInfosTableTableManager get youthInfos =>
      $$YouthInfosTableTableManager(_db, _db.youthInfos);
  $$EducBgsTableTableManager get educBgs =>
      $$EducBgsTableTableManager(_db, _db.educBgs);
  $$CivicInvolvementsTableTableManager get civicInvolvements =>
      $$CivicInvolvementsTableTableManager(_db, _db.civicInvolvements);
}
