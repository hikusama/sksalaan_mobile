import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/foundation.dart';
import 'package:skyouthprofiling/service/connection.dart';
import 'package:intl/intl.dart';

part 'app_database.g.dart';

class FullYouthProfile {
  final YouthUser youthUser;
  final YouthInfo youthInfo;
  final List<EducBg> educBgs;
  final List<CivicInvolvement> civicInvolvements;

  FullYouthProfile({
    required this.youthUser,
    required this.youthInfo,
    required this.educBgs,
    required this.civicInvolvements,
  });
  // factory YouthUser.fromJson(Map<String, dynamic> json) {
  //   return YouthUser(
  //     orgId: json['orgID'] ?? json['orgId'], // Handle both cases
  //     youthType: json['youthType'],
  //     skills: json['skills'],
  //     status: json['status'],
  //     registerAt: DateTime.parse(json['registerAt']),
  //   );
  // }
  factory FullYouthProfile.fromJson(Map<String, dynamic> json) {
    return FullYouthProfile(
      youthUser: YouthUser.fromJson(json['youthUser']),
      youthInfo: YouthInfo.fromJson(json['youthInfo']),
      educBgs:
          (json['educBgs'] as List).map((e) => EducBg.fromJson(e)).toList(),
      civicInvolvements:
          (json['civicInvolvements'] as List)
              .map((e) => CivicInvolvement.fromJson(e))
              .toList(),
    );
  }
}

class YouthUsers extends Table {
  IntColumn get youthUserId => integer().autoIncrement()();
  IntColumn get orgId => integer().nullable()();
  TextColumn get youthType => text()();
  TextColumn get skills => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get registerAt => dateTime().withDefault(currentDateAndTime)();
}

class YouthInfos extends Table {
  IntColumn get youthInfosId => integer().autoIncrement()();

  IntColumn get youthUserId =>
      integer().customConstraint(
        'REFERENCES youth_users(youth_user_id) ON DELETE CASCADE NOT NULL',
      )();

  TextColumn get fname => text()();
  TextColumn get mname => text()();
  TextColumn get lname => text()();
  TextColumn get gender => text().nullable()();
  TextColumn get sex => text()();
  TextColumn get dateOfBirth => text()();
  TextColumn get address => text()();

  TextColumn get placeOfBirth => text()();
  TextColumn get contactNo => text()();
  RealColumn get height => real().nullable()();
  RealColumn get weight => real().nullable()();
  TextColumn get religion => text()();
  TextColumn get occupation => text()();
  TextColumn get civilStatus => text()();
  IntColumn get noOfChildren => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class EducBgs extends Table {
  IntColumn get educBgId => integer().autoIncrement()();
  IntColumn get orgId => integer().nullable()();

  IntColumn get youthUserId =>
      integer().customConstraint(
        'REFERENCES youth_users(youth_user_id) ON DELETE CASCADE NOT NULL',
      )();

  TextColumn get level => text()();
  TextColumn get nameOfSchool => text()();
  TextColumn get periodOfAttendance => text()();
  TextColumn get yearGraduate => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class CivicInvolvements extends Table {
  IntColumn get civicInvolvementId => integer().autoIncrement()();
  IntColumn get orgId => integer().nullable()();

  IntColumn get youthUserId =>
      integer().customConstraint(
        'REFERENCES youth_users(youth_user_id) ON DELETE CASCADE NOT NULL',
      )();

  TextColumn get nameOfOrganization => text()();
  TextColumn get addressOfOrganization => text()();
  TextColumn get start => text()();
  TextColumn get end => text()();
  TextColumn get yearGraduated => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class DatabaseProvider {
  DatabaseProvider._();

  static final AppDatabase instance = AppDatabase();
}

@DriftDatabase(tables: [YouthUsers, YouthInfos, EducBgs, CivicInvolvements])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(openConnection());

  static final AppDatabase _instance = AppDatabase._internal();

  factory AppDatabase() => _instance;

  // youth user
  Future<int> insertYouthUser(YouthUsersCompanion user) =>
      into(youthUsers).insert(user);

  // Future<int> countStandbyYouthUsers() {
  //   final query =
  //       youthUsers.select()..where((tbl) => tbl.status.equals('Standby'));
  //   return query.get().then((rows) => rows.length);
  // }
  Future<bool> updateFullYouthData({
    required int youthUserId,
    required Map<String, bool> rec,
    required YouthUsersCompanion user,
    required YouthInfosCompanion info,
    required List<EducBgsCompanion> educList,
    required List<CivicInvolvementsCompanion> civicList,
  }) async {
    bool success = false;

    await transaction(() async {
      try {
        // Update user + info tables
        await (update(youthUsers)
          ..where((t) => t.youthUserId.equals(youthUserId))).write(user);

        await (update(youthInfos)
          ..where((t) => t.youthUserId.equals(youthUserId))).write(info);

        // Delete existing educ & civic records if necessary
        await _deleteIfExists(id: youthUserId, rec: rec);

        if (educList.isNotEmpty && rec['ebg'] != false) {
          for (final educ in educList) {
            await into(educBgs).insert(educ);
          }
        }

        if (civicList.isNotEmpty && rec['cv'] != false) {
          for (final civic in civicList) {
            await into(civicInvolvements).insert(civic);
          }
        }

        success = true;
      } catch (e, st) {
        debugPrint('updateFullYouthData error: $e\n$st');
        success = false;
      }
    });

    return success;
  }

  Future<void> _deleteIfExists({
    required int id,
    required Map<String, bool> rec,
  }) async {
    debugPrint('updateFullYouthDat/*/******a error: $rec');
    final hasEbg =
        await (select(educBgs)..where((t) => t.youthUserId.equals(id))).get();
    if (hasEbg.isNotEmpty && rec['ebg'] != false) {
      await (delete(educBgs)..where((t) => t.youthUserId.equals(id))).go();
    }

    final hasCivic =
        await (select(civicInvolvements)
          ..where((t) => t.youthUserId.equals(id))).get();
    if (hasCivic.isNotEmpty && rec['cv'] != false) {
      await (delete(civicInvolvements)
        ..where((t) => t.youthUserId.equals(id))).go();
    }
  }

  Future<int> deleteBulkYouthUsers(List<int> ids) async {
    if (ids.isEmpty) return 0;
    debugPrint(ids.toString());
    return (delete(youthUsers)..where((t) => t.youthUserId.isIn(ids))).go();
  }

  Future<int> deleteYouthUser(int id) =>
      (delete(youthUsers)..where((t) => t.youthUserId.equals(id))).go();
  Future<Map<String, dynamic>> getStatus() async {
    final result =
        await customSelect(
          '''
    SELECT 
      SUM(CASE WHEN status = 'New' THEN 1 ELSE 0 END) AS new,
      SUM(CASE WHEN status = 'Validated' THEN 1 ELSE 0 END) AS validated,
      SUM(CASE WHEN status = 'Unvalidated' THEN 1 ELSE 0 END) AS unvalidated
    FROM youth_users
    ''',
          readsFrom: {youthUsers},
        ).getSingle();

    return {
      'New': (result.data['new'] ?? 0) as int,
      'Validated': (result.data['validated'] ?? 0) as int,
      'Unvalidated': (result.data['unvalidated'] ?? 0) as int,
    };
  }

  Future<bool> youthExistsIgnoreCaseExceptInVal(
    int id,
    String fname,
    String mname,
    String lname,
  ) async {
    final query = customSelect(
      '''
    SELECT 1
    FROM youth_infos
    RIGHT JOIN youth_users
      ON youth_infos.youth_user_id = youth_users.youth_user_id
    WHERE LOWER(fname) = ?
      AND LOWER(mname) = ?
      AND LOWER(lname) = ?
      AND youth_users.youth_user_id != ?
      AND youth_users.status = 'New'
    LIMIT 1
    ''',
      variables: [
        Variable(fname.trim().toLowerCase()),
        Variable(mname.trim().toLowerCase()),
        Variable(lname.trim().toLowerCase()),
        Variable(id),
      ],
      readsFrom: {youthInfos, youthUsers},
    );

    final result = await query.get();
    return result.isNotEmpty;
  }

  Future<Map<String, dynamic>> checkStatExist({
    required String fname,
    required String mname,
    required String lname,
  }) async {
    final query = customSelect(
      '''
    SELECT youth_users.status, youth_users.youth_user_id
    FROM youth_users
    LEFT JOIN youth_infos
      ON youth_infos.youth_user_id = youth_users.youth_user_id
    WHERE LOWER(youth_infos.fname) = ?
      AND LOWER(youth_infos.mname) = ?
      AND LOWER(youth_infos.lname) = ?
    LIMIT 1
    ''',
      variables: [
        Variable(fname.trim().toLowerCase()),
        Variable(mname.trim().toLowerCase()),
        Variable(lname.trim().toLowerCase()),
      ],
      readsFrom: {youthInfos, youthUsers},
    );

    final result = await query.get();

    // 🔍 Logging
    debugPrint('---- checkStatExist ----');
    debugPrint('Searching for: $fname $mname $lname');
    debugPrint('Rows found: ${result.length}');
    for (final row in result) {
      debugPrint(
        'Row -> status: ${row.read<String>('status')}, '
        'id: ${row.read<int>('youth_user_id')}',
      );
    }
    debugPrint('------------------------');

    if (result.isEmpty) {
      return {'status': null, 'id': null};
    }

    return {
      'status': result.first.read<String>('status'),
      'id': result.first.read<int>('youth_user_id'),
    };
  }

  Future<bool> youthExistsIgnoreCaseExcept(
    int id,
    String fname,
    String mname,
    String lname,
  ) async {
    final query = customSelect(
      'SELECT 1 FROM youth_infos '
      'WHERE LOWER(fname) = ? AND LOWER(mname) = ? AND LOWER(lname) = ? AND youth_user_id != ? LIMIT 1',
      variables: [
        Variable(fname.trim().toLowerCase()),
        Variable(mname.trim().toLowerCase()),
        Variable(lname.trim().toLowerCase()),
        Variable(id),
      ],
      readsFrom: {youthInfos},
    );

    final result = await query.get();
    return result.isNotEmpty;
  }

  Future<bool> youthExistsIgnoreCase(
    String fname,
    String mname,
    String lname,
  ) async {
    final query = customSelect(
      'SELECT 1 FROM youth_infos '
      'WHERE LOWER(fname) = ? AND LOWER(mname) = ? AND LOWER(lname) = ? LIMIT 1',
      variables: [
        Variable(fname.trim().toLowerCase()),
        Variable(mname.trim().toLowerCase()),
        Variable(lname.trim().toLowerCase()),
      ],
      readsFrom: {youthInfos},
    );

    final result = await query.get();
    return result.isNotEmpty;
  }

  // youth info
  Future<void> insertYouthInfo(YouthInfosCompanion info) =>
      into(youthInfos).insert(info);

  Future<void> insertAllEducBgs(
    int youthUserId,
    Map<String, Map<String, dynamic>> educbg,
    AppDatabase db,
  ) async {
    for (final entry in educbg.entries) {
      final data = entry.value;

      final educ = EducBgsCompanion(
        youthUserId: Value(youthUserId),
        level: Value(data['level'] ?? ''),
        nameOfSchool: Value(data['nameOfSchool'] ?? ''),
        periodOfAttendance: Value(data['periodOfAttendance'] ?? ''),
        yearGraduate: Value(data['yearGraduate'] ?? ''),
      );

      await db.into(db.educBgs).insert(educ);
    }
  }

  Future<void> insertAllCivic(
    int youthUserId,
    Map<String, Map<String, dynamic>> civic,
    AppDatabase db,
  ) async {
    for (final entry in civic.entries) {
      final data = entry.value;

      final involvement = CivicInvolvementsCompanion(
        youthUserId: Value(youthUserId),
        nameOfOrganization: Value(data['nameOfOrganization'] ?? ''),
        addressOfOrganization: Value(data['addressOfOrganization'] ?? ''),
        start: Value(data['start'] ?? ''),
        end: Value(data['end'] ?? ''),
        yearGraduated: Value(data['yearGraduated'] ?? ''),
      );

      await db.into(db.civicInvolvements).insert(involvement);
    }
  }

  Future<List<Map<String, dynamic>>> migrate() async {
    final newUsers =
        await (select(youthUsers)
          ..where((tbl) => tbl.status.equals('New'))).get();

    final List<Map<String, dynamic>> exportData = [];

    try {
      for (final user in newUsers) {
        final info =
            await (select(youthInfos)..where(
              (tbl) => tbl.youthUserId.equals(user.youthUserId),
            )).getSingle();

        final educs =
            await (select(educBgs)
              ..where((tbl) => tbl.youthUserId.equals(user.youthUserId))).get();

        final civics =
            await (select(civicInvolvements)
              ..where((tbl) => tbl.youthUserId.equals(user.youthUserId))).get();

        exportData.add({
          'user': {
            'id': user.youthUserId,
            'youthType': user.youthType,
            'skills': user.skills,
            'created_at': DateFormat('yyyy-MM-dd').format(user.createdAt),
          },
          'info': {
            'fname': info.fname,
            'mname': info.mname,
            'lname': info.lname,
            'sex': info.sex,
            'gender': info.gender,
            'address': info.address,
            'dateOfBirth': info.dateOfBirth,
            'placeOfBirth': info.placeOfBirth,
            'contactNo': info.contactNo,
            'height': info.height,
            'weight': info.weight,
            'religion': info.religion,
            'occupation': info.occupation,
            'civilStatus': info.civilStatus,
            'noOfChildren': info.noOfChildren,
            'created_at': DateFormat('yyyy-MM-dd').format(info.createdAt),
          },
          'educBG':
              educs
                  .map(
                    (e) => {
                      'level': e.level,
                      'nameOfSchool': e.nameOfSchool,
                      'periodOfAttendance': e.periodOfAttendance,
                      'yearGraduate': e.yearGraduate,
                      'created_at': DateFormat(
                        'yyyy-MM-dd',
                      ).format(e.createdAt),
                    },
                  )
                  .toList(),
          'civic':
              civics
                  .map(
                    (c) => {
                      'nameOfOrganization': c.nameOfOrganization,
                      'addressOfOrganization': c.addressOfOrganization,
                      'start': c.start,
                      'end': c.end,
                      'yearGraduated': c.yearGraduated,
                      'created_at': DateFormat(
                        'yyyy-MM-dd',
                      ).format(c.createdAt),
                    },
                  )
                  .toList(),
        });
      }
    } catch (e) {
      //
    }
    return exportData;
  }

  Future<List<Map<String, dynamic>>> validate() async {
    final newUsers =
        await (select(youthUsers)
          ..where((tbl) => tbl.status.equals('Validated'))).get();

    final List<Map<String, dynamic>> exportData = [];

    try {
      for (final user in newUsers) {
        final info =
            await (select(youthInfos)..where(
              (tbl) => tbl.youthUserId.equals(user.youthUserId),
            )).getSingle();

        final educs =
            await (select(educBgs)
              ..where((tbl) => tbl.youthUserId.equals(user.youthUserId))).get();

        final civics =
            await (select(civicInvolvements)
              ..where((tbl) => tbl.youthUserId.equals(user.youthUserId))).get();

        exportData.add({
          'user': {
            'idM': user.youthUserId,
            'id': user.orgId,
            'youthType': user.youthType,
            'skills': user.skills,
            'created_at': DateFormat('yyyy-MM-dd').format(user.createdAt),
          },
          'info': {
            'fname': info.fname,
            'mname': info.mname,
            'lname': info.lname,
            'sex': info.sex,
            'gender': info.gender,
            'address': info.address,
            'dateOfBirth': info.dateOfBirth,
            'placeOfBirth': info.placeOfBirth,
            'contactNo': info.contactNo,
            'height': info.height,
            'weight': info.weight,
            'religion': info.religion,
            'occupation': info.occupation,
            'civilStatus': info.civilStatus,
            'noOfChildren': info.noOfChildren,
            'created_at': DateFormat('yyyy-MM-dd').format(info.createdAt),
          },
          'educBG':
              educs
                  .map(
                    (e) => {
                      'id': e.orgId,
                      'level': e.level,
                      'nameOfSchool': e.nameOfSchool,
                      'periodOfAttendance': e.periodOfAttendance,
                      'yearGraduate': e.yearGraduate,
                      'created_at': DateFormat(
                        'yyyy-MM-dd',
                      ).format(e.createdAt),
                    },
                  )
                  .toList(),
          'civic':
              civics
                  .map(
                    (c) => {
                      'id': c.orgId,
                      'nameOfOrganization': c.nameOfOrganization,
                      'addressOfOrganization': c.addressOfOrganization,
                      'start': c.start,
                      'end': c.end,
                      'yearGraduated': c.yearGraduated,
                      'created_at': DateFormat(
                        'yyyy-MM-dd',
                      ).format(c.createdAt),
                    },
                  )
                  .toList(),
        });
      }
    } catch (e) {
      //
    }
    return exportData;
  }

  Future<void> changeStat({required int id, required String stat}) async {
    (update(youthUsers)..where(
      (u) => u.youthUserId.equals(id),
    )).write(YouthUsersCompanion(status: Value(stat)));
  }

  Future<Map<String, dynamic>> getSingleProfile({required int id}) async {
    final user =
        await (select(youthUsers)
          ..where((tbl) => tbl.youthUserId.equals(id))).getSingle();

    final youthInfo =
        await (select(youthInfos)..where(
          (tbl) => tbl.youthUserId.equals(user.youthUserId),
        )).getSingle();

    final educs =
        await (select(educBgs)
          ..where((tbl) => tbl.youthUserId.equals(user.youthUserId))).get();

    final civics =
        await (select(civicInvolvements)
          ..where((tbl) => tbl.youthUserId.equals(user.youthUserId))).get();

    final profile = FullYouthProfile(
      youthUser: user,
      youthInfo: youthInfo,
      educBgs: educs,
      civicInvolvements: civics,
    );

    return {'profile': profile};
  }

  Future<Map<String, dynamic>> getAllYouthProfiles({
    String searchKeyword = '',
    int limit = 10,
    String sortBy = 'lname', // default sorting
    int offset = 0,
    bool ascending = true,
    String? validated,
  }) async {
    debugPrint('validated: $validated');
    debugPrint('sort: $sortBy');

    final joinedQuery = select(youthUsers).join([
      innerJoin(
        youthInfos,
        youthInfos.youthUserId.equalsExp(youthUsers.youthUserId),
      ),
    ]);

    // 🔍 Optional search
    if (searchKeyword.isNotEmpty) {
      joinedQuery.where(
        (youthInfos.fname.like('%$searchKeyword%')) |
            (youthInfos.lname.like('%$searchKeyword%')),
      );
    }

    // 🧩 Validation filter
    if (validated != null && validated.isNotEmpty) {
      if (validated == 'New') {
        joinedQuery.where(youthUsers.status.equals('New'));
      } else {
        joinedQuery.where(youthUsers.status.isNotValue('New'));
      }
    }

    // 🔽 Sorting
    final sortColumn = switch (sortBy) {
      'fname' => youthInfos.fname,
      'lname' => youthInfos.lname,
      'age' => youthInfos.dateOfBirth, // approximate age sort
      'registerAt' => youthUsers.registerAt,
      _ => youthInfos.lname,
    };

    joinedQuery.orderBy([
      OrderingTerm(
        expression: sortColumn,
        mode: ascending ? OrderingMode.asc : OrderingMode.desc,
      ),
    ]);

    // 📄 Pagination
    joinedQuery.limit(limit, offset: offset);

    // 🧾 Fetch
    final rows = await joinedQuery.get();
    final result = <FullYouthProfile>[];

    for (final row in rows) {
      final user = row.readTable(youthUsers);
      final info = row.readTable(youthInfos);

      final educs =
          await (select(educBgs)
            ..where((tbl) => tbl.youthUserId.equals(user.youthUserId))).get();

      final civics =
          await (select(civicInvolvements)
            ..where((tbl) => tbl.youthUserId.equals(user.youthUserId))).get();

      result.add(
        FullYouthProfile(
          youthUser: user,
          youthInfo: info,
          educBgs: educs,
          civicInvolvements: civics,
        ),
      );
    }

    // 📊 Count for pagination (with join!)
    final countJoin = select(youthUsers).join([
      innerJoin(
        youthInfos,
        youthInfos.youthUserId.equalsExp(youthUsers.youthUserId),
      ),
    ]);

    countJoin.addColumns([youthUsers.youthUserId]);

    if (searchKeyword.isNotEmpty) {
      countJoin.where(
        (youthInfos.fname.like('%$searchKeyword%')) |
            (youthInfos.lname.like('%$searchKeyword%')),
      );
    }

    if (validated != null && validated.isNotEmpty) {
      if (validated == 'New') {
        countJoin.where(youthUsers.status.equals('New'));
      } else {
        countJoin.where(youthUsers.status.isNotValue('New'));
      }
    }

    final countRows = await countJoin.get();
    final totalCount = countRows.length;

    final totalPages = (totalCount / limit).ceil();
    final currentPage = (offset / limit).floor() + 1;
    final pagesLeft = (totalPages - currentPage).clamp(0, totalPages);
    final rowsLeft = (totalCount - (offset + result.length)).clamp(
      0,
      totalCount,
    );

    debugPrint('result length: ${result.length}');
    debugPrint('totalCount: $totalCount');

    return {
      'youth': result,
      'pagesLeft': pagesLeft,
      'totalPages': totalPages,
      'totalCount': totalCount,
      'currentPage': currentPage,
      'rowsLeft': rowsLeft,
    };
  }

  Future<Map<String, dynamic>> insertBulkProfiles(
    List<dynamic> profiles,
  ) async {
    var nIn = 0;
    var existV = 0;
    var existUV = 0;
    var existN = 0;
    await transaction(() async {
      final Map<String, bool> rec = {'ebg': true, 'cv': true};
      for (final profile in profiles) {
        Map<String, dynamic> yuser = profile['youthUser'];
        Map<String, dynamic> yinfo = profile['youthInfo'];

        final eduList =
            (profile['educBgs'] as List<dynamic>? ?? [])
                .map((e) => Map<String, dynamic>.from(e))
                .toList();

        final civicList =
            (profile['civicInvolvements'] as List<dynamic>? ?? [])
                .map((e) => Map<String, dynamic>.from(e))
                .toList();
        final stat = await checkStatExist(
          fname: yinfo['fname'],
          mname: yinfo['mname'],
          lname: yinfo['lname'],
        );
        // await deleteYouthUser(5);
        debugPrint('------------------------123');
        if (stat['status'] == null) {
          debugPrint('newdata');
          nIn += 1;
          debugPrint('validated');
          // continue;
          final youthId = await into(youthUsers).insert(
            YouthUsersCompanion.insert(
              orgId: Value(yuser['orgId']),
              youthType: yuser['youthType'],
              skills: yuser['skills'],
              status: yuser['status'],
              registerAt: Value(DateTime.parse(yuser['registerAt'])),
            ),
          );

          await into(youthInfos).insert(
            YouthInfosCompanion.insert(
              youthUserId: youthId,
              fname: yinfo['fname'],
              mname: yinfo['mname'],
              lname: yinfo['lname'],
              sex: yinfo['sex'],
              address: yinfo['address'],
              placeOfBirth: yinfo['placeOfBirth'],
              contactNo: yinfo['contactNo'],
              religion: yinfo['religion'],
              civilStatus: yinfo['civilStatus'],
              dateOfBirth: yinfo['dateOfBirth'],
              noOfChildren: yinfo['noOfChildren'],
              occupation: yinfo['occupation'],
              gender: Value(yinfo['gender']),
              height: Value(double.tryParse(yinfo['height']?.toString() ?? '')),
              weight: Value(double.tryParse(yinfo['weight']?.toString() ?? '')),
            ),
          );

          // Insert Education Backgrounds
          for (final educ in eduList) {
            await into(educBgs).insert(
              EducBgsCompanion.insert(
                youthUserId: youthId,
                level: educ['level'],
                nameOfSchool: educ['nameOfSchool'],
                periodOfAttendance: educ['periodOfAttendance'],
                yearGraduate: Value(educ['yearGraduate']),
              ),
            );
          }

          // Insert Civic Involvements
          for (final cv in civicList) {
            await into(civicInvolvements).insert(
              CivicInvolvementsCompanion.insert(
                youthUserId: youthId,
                nameOfOrganization: cv['nameOfOrganization'],
                addressOfOrganization: cv['addressOfOrganization'],
                start: cv['start'],
                end: cv['end'],
                yearGraduated: cv['yearGraduated'],
              ),
            );
          }
        } else if (stat['status'] == 'New') {
          debugPrint('new');
          existN += 1;
          // continue;
          await changeStat(id: stat['id'], stat: 'Validated');
        } else if (stat['status'] == 'Unvalidated') {
          debugPrint('unvalidated');
          existUV += 1;

          // continue;
          await updateFullYouthData(
            youthUserId: stat['id'],
            rec: rec,
            user: YouthUsersCompanion(
              youthType: Value(yuser['youthType']?.toString() ?? ''),
              skills: Value(yuser['skills']?.toString() ?? ''),
              status: const Value('Unvalidated'),
            ),

            info: YouthInfosCompanion(
              fname: Value(yinfo['fname']?.toString() ?? ''),
              mname: Value(yinfo['mname']?.toString() ?? ''),
              lname: Value(yinfo['lname']?.toString() ?? ''),
              occupation: Value(yinfo['occupation']?.toString() ?? ''),
              placeOfBirth: Value(yinfo['placeOfBirth']?.toString() ?? ''),
              contactNo: Value(yinfo['contactNo']?.toString() ?? ''),

              // ---- FIX for int / string errors ----
              noOfChildren: Value(
                yinfo['noOfChildren'] is int
                    ? yinfo['noOfChildren']
                    : int.tryParse(yinfo['noOfChildren']?.toString() ?? '') ??
                        0,
              ),

              // ---- FIX for double / string errors ----
              height: Value(
                yinfo['height'] is double
                    ? yinfo['height']
                    : double.tryParse(yinfo['height']?.toString() ?? '0') ??
                        0.0,
              ),
              weight: Value(
                yinfo['weight'] is double
                    ? yinfo['weight']
                    : double.tryParse(yinfo['weight']?.toString() ?? '0') ??
                        0.0,
              ),

              dateOfBirth: Value(yinfo['dateOfBirth']?.toString() ?? ''),
              civilStatus: Value(yinfo['civilStatus']?.toString() ?? ''),
              gender: Value(yinfo['gender']?.toString() ?? ''),
              religion: Value(yinfo['religion']?.toString().trim() ?? ''),
              sex: Value(yinfo['sex']?.toString().trim() ?? ''),
              address: Value(yinfo['address']?.toString().trim() ?? ''),
            ),

            // ------------------------------------------------------------
            // ----------- EDUCATION LIST (safe integer ID) --------------
            // ------------------------------------------------------------
            educList:
                eduList.map((e) {
                  return EducBgsCompanion.insert(
                    orgId: Value(
                      yuser['orgId'] is int
                          ? yuser['orgId']
                          : int.tryParse(yuser['orgId']?.toString() ?? '0') ??
                              0,
                    ),
                    youthUserId: stat['id'],
                    level: e['level']?.toString() ?? '',
                    nameOfSchool: e['nameOfSchool']?.toString() ?? '',
                    periodOfAttendance:
                        e['periodOfAttendance']?.toString() ?? '',
                    yearGraduate: Value(
                      e['yearGraduate'] is int
                          ? e['yearGraduate']
                          : int.tryParse(
                                e['yearGraduate']?.toString() ?? '0',
                              ) ??
                              0,
                    ),
                  );
                }).toList(),

            // ------------------------------------------------------------
            // --------------- CIVIC LIST (safe ID) ------------------------
            // ------------------------------------------------------------
            civicList:
                civicList.map((c) {
                  return CivicInvolvementsCompanion.insert(
                    orgId: Value(
                      yuser['orgId'] is int
                          ? yuser['orgId']
                          : int.tryParse(yuser['orgId']?.toString() ?? '0') ??
                              0,
                    ),
                    youthUserId: stat['id'],
                    nameOfOrganization:
                        c['nameOfOrganization']?.toString() ?? '',
                    addressOfOrganization:
                        c['addressOfOrganization']?.toString() ?? '',
                    start: c['start']?.toString() ?? '',
                    end: c['end']?.toString() ?? '',
                    yearGraduated:
                        c['yearGraduated'] is int
                            ? c['yearGraduated']
                            : int.tryParse(
                                  c['yearGraduated']?.toString() ?? '0',
                                ) ??
                                0,
                  );
                }).toList(),
          );
        } else if (stat['status'] != 'Validated') {
          existV += 1;
        }
      }
    });
    return {
      'v': existV,
      'uv': existUV,
      'n': existN,
      'sz': profiles.length,
      'res': null,
      'new': nIn,
    };
  }

  @override
  int get schemaVersion => 2;
}
