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
  AppDatabase() : super(openConnection());

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
    required YouthUsersCompanion user,
    required YouthInfosCompanion info,
    required List<EducBgsCompanion> educList,
    required List<CivicInvolvementsCompanion> civicList,
  }) async {
    bool success = false;

    await transaction(() async {
      try {
        // 1️⃣ Update youth user
        await (update(youthUsers)
          ..where((t) => t.youthUserId.equals(youthUserId))).write(user);

        // 2️⃣ Update youth info
        await (update(youthInfos)
          ..where((t) => t.youthUserId.equals(youthUserId))).write(info);

        // 3️⃣ Update all educ backgrounds
        for (final educ in educList) {
          await (update(educBgs)
            ..where((t) => t.youthUserId.equals(youthUserId))).write(educ);
        }

        for (final civic in civicList) {
          await (update(civicInvolvements)
            ..where((t) => t.youthUserId.equals(youthUserId))).write(civic);
        }

        success = true;
      } catch (e) {
        success = false;
      }
    });

    return success;
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

  // Future<void> updateMigrationStatus({
  //   required List<int> submitted,
  //   required List<int> failed,
  // }) async {
  //   await batch((batch) {
  //     if (submitted.isNotEmpty) {
  //       batch.update(
  //         youthUsers,
  //         YouthUsersCompanion(status: const Value('Submitted')),
  //         where: (tbl) => tbl.youthUserId.isIn(submitted),
  //       );
  //     }

  //     // Update failed users
  //     if (failed.isNotEmpty) {
  //       batch.update(
  //         youthUsers,
  //         YouthUsersCompanion(status: const Value('Failed')),
  //         where: (tbl) => tbl.youthUserId.isIn(failed),
  //       );
  //     }
  //   });
  // }

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
    bool ascending = true, // optional for direction
    String? validated,
  }) async {
    debugPrint('uv: $validated');
    List<FullYouthProfile> result = [];
    List<int> userIds = [];

    // 🔎 Filter by keyword (search in infos table)
    if (searchKeyword.isNotEmpty) {
      userIds =
          await (select(youthInfos)..where(
            (tbl) =>
                tbl.fname.like('%$searchKeyword%') |
                tbl.lname.like('%$searchKeyword%'),
          )).map((info) => info.youthUserId).get();

      if (userIds.isEmpty) {
        return {
          'youth': [],
          'pagesLeft': 0,
          'totalPages': 0,
          'totalCount': 0,
          'currentPage': 1,
          'rowsLeft': 0,
        };
      }
    }

    // 🗂️ Handle sorting
    if (['fname', 'lname', 'age'].contains(sortBy)) {
      // Sorting that requires youthInfos → join
      final joinedQuery = select(youthUsers).join([
        innerJoin(
          youthInfos,
          youthInfos.youthUserId.equalsExp(youthUsers.youthUserId),
        ),
      ])..limit(limit, offset: offset);

      if (userIds.isNotEmpty) {
        joinedQuery.where(youthUsers.youthUserId.isIn(userIds));
      }

      if (validated == 'New') {
        joinedQuery.where(youthUsers.status.equals('New'));
      } else if (validated == 'Validated' || validated == 'Unvalidated') {
        joinedQuery.where(youthUsers.status.isNotValue('New'));
      }
      final ageExpr = CustomExpression<int>(
        'CAST((strftime("%Y", "now") - strftime("%Y", date_of_birth)) AS INTEGER)',
      );

      switch (sortBy) {
        case 'fname':
          joinedQuery.orderBy([
            OrderingTerm(
              expression: youthInfos.fname,
              mode: ascending ? OrderingMode.asc : OrderingMode.desc,
            ),
          ]);
          break;

        case 'lname':
          joinedQuery.orderBy([
            OrderingTerm(
              expression: youthInfos.lname,
              mode: ascending ? OrderingMode.asc : OrderingMode.desc,
            ),
          ]);
          break;

        case 'age':
          joinedQuery.orderBy([
            OrderingTerm(
              expression: ageExpr,
              mode: ascending ? OrderingMode.asc : OrderingMode.desc,
            ),
          ]);
          break;
      }

      final rows = await joinedQuery.get();
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
    } else {
      // Sorting only on youthUsers table (registerAt, createdAt, etc.)
      final query = select(youthUsers)..limit(limit, offset: offset);

      if (userIds.isNotEmpty) {
        query.where((tbl) => tbl.youthUserId.isIn(userIds));
      }
      if (validated == 'New') {
        query.where((tbl) => tbl.status.equals('New'));
      } else if (validated == 'Validated' || validated == 'Unvalidated') {
        query.where((tbl) => tbl.status.isNotValue('New'));
      }

      // Default to youthUsers fields
      // switch (sortBy) {
      //   case 'registerAt':
      //   default:
      //     query.orderBy([
      //       (tbl) =>
      //           ascending
      //               ? OrderingTerm.asc(tbl.registerAt)
      //               : OrderingTerm.desc(tbl.registerAt),
      //     ]);
      // }

      final users = await query.get();
      for (final user in users) {
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

        result.add(
          FullYouthProfile(
            youthUser: user,
            youthInfo: info,
            educBgs: educs,
            civicInvolvements: civics,
          ),
        );
      }
    }

    final countQuery = selectOnly(youthUsers)
      ..addColumns([youthUsers.youthUserId.count()]);

    if (userIds.isNotEmpty) {
      countQuery.where(youthUsers.youthUserId.isIn(userIds));
    }

    final countRow = await countQuery.getSingle();
    final int totalCount = countRow.read(youthUsers.youthUserId.count()) ?? 0;

    final int totalPages = (totalCount / limit).ceil();
    final int currentPage = (offset / limit).floor() + 1;
    final int pagesLeft = (totalPages - currentPage).clamp(0, totalPages);
    final int rowsLeft = (totalCount - (offset + result.length)).clamp(
      0,
      totalCount,
    );
    // print("===============>");
    // print(sortBy);
    // print(result);

    return {
      'youth': result,
      'pagesLeft': pagesLeft,
      'totalPages': totalPages,
      'totalCount': totalCount,
      'currentPage': currentPage,
      'rowsLeft': rowsLeft,
    };
  }

  Future<void> insertBulkProfiles(List<dynamic> profiles) async {
    await transaction(() async {
      debugPrint('Error 1============ : $profiles');

      for (final profile in profiles) {
        Map<String, dynamic> yuser = profile['youthUser'];
        Map<String, dynamic> yinfo = profile['youthInfo'];
        // final eduList = (profile['educBgs'] as List<dynamic>? ?? [])
        //     .map((e) => Map<String, dynamic>.from(e))
        //     .toList();

        // final civicList = (profile['civicInvolvements'] as List<dynamic>? ?? [])
        //     .map((e) => Map<String, dynamic>.from(e))
        //     .toList();
        var youthId = 0;
        var sc = false;
        // await deleteYouthUser(5);
        try {
          youthId = await into(youthUsers).insert(
            YouthUsersCompanion.insert(
              orgId: Value(yuser['orgId']),
              youthType: yuser['youthType'],
              skills: yuser['skills'],
              status: yuser['status'],
              registerAt: Value(DateTime.parse(yuser['registerAt'])),
            ),
          );
          sc = true;
        } catch (e) {
          sc = false;
          debugPrint('Error 1============ : $e');
        }

        if (sc) {
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
          // for (final educ in eduList) {
          //   await into(educBgs).insert(
          //     EducBgsCompanion.insert(
          //       youthUserId: youthId,
          //       level: educ['level'],
          //       nameOfSchool: educ['nameOfSchool'],
          //       periodOfAttendance: educ['periodOfAttendance'],
          //       yearGraduate: Value(educ['yearGraduate']),
          //     ),
          //   );
          // }

          // // Insert Civic Involvements
          // for (final cv in civicList) {
          //   await into(civicInvolvements).insert(
          //     CivicInvolvementsCompanion.insert(
          //       youthUserId: youthId,
          //       nameOfOrganization: cv['nameOfOrganization'],
          //       addressOfOrganization: cv['addressOfOrganization'],
          //       start: cv['start'],
          //       end: cv['end'],
          //       yearGraduated: cv['yearGraduated'],
          //     ),
          //   );
          // }
          debugPrint(
            'Success =============================***********************',
          );
        }
      }
    });
  }

  @override
  int get schemaVersion => 2;
}
