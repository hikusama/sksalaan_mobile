import 'package:drift/drift.dart';
import 'package:skyouthprofiling/service/connection.dart';

part 'app_database.g.dart';

class FullYouthProfile {
  final YouthUser youthUser;
  final YouthInfo? youthInfo;
  final List<EducBg> educBgs;
  final List<CivicInvolvement> civicInvolvements;

  FullYouthProfile({
    required this.youthUser,
    this.youthInfo,
    required this.educBgs,
    required this.civicInvolvements,
  });
}

class Users extends Table {
  TextColumn get userName => text()();
  TextColumn get password => text()();
  TextColumn get token => text()();
}

class YouthUsers extends Table {
  IntColumn get youthUserId => integer().autoIncrement()();
  IntColumn get userId => integer().nullable()();
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
        'REFERENCES youth_users(youth_user_id) ON DELETE CASCADE ',
      )();

  TextColumn get fname => text()();
  TextColumn get mname => text()();
  TextColumn get lname => text()();
  IntColumn get age => integer()();
  TextColumn get gender => text().nullable()();
  TextColumn get sex => text()();
  TextColumn get dateOfBirth => text()();

  TextColumn get placeOfBirth => text()();
  IntColumn get contactNo => integer()();
  RealColumn get height => real()();
  RealColumn get weight => real()();
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
  TextColumn get yearGraduate => text()();
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

@DriftDatabase(
  tables: [Users, YouthUsers, YouthInfos, EducBgs, CivicInvolvements],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  // youth user
  Future<int> insertYouthUser(YouthUsersCompanion user) =>
      into(youthUsers).insert(user);

  Future<int> countStandbyYouthUsers() {
    final query =
        youthUsers.select()..where((tbl) => tbl.status.equals('Standby'));
    return query.get().then((rows) => rows.length);
  }

  Future<bool> updateYouthUser(YouthUser user) =>
      update(youthUsers).replace(user);

  Future<int> deleteYouthUser(int id) =>
      (delete(youthUsers)..where((t) => t.youthUserId.equals(id))).go();
  Future<Map<String, dynamic>> getStatus() async {
    final result =
        await customSelect(
          '''
    SELECT 
      SUM(CASE WHEN status = 'Standby' THEN 1 ELSE 0 END) AS standby,
      SUM(CASE WHEN status = 'Submitted' THEN 1 ELSE 0 END) AS submitted,
      SUM(CASE WHEN status = 'Failed' THEN 1 ELSE 0 END) AS failed
    FROM youth_users
    ''',
          readsFrom: {youthUsers},
        ).getSingle();

    return {
      'Standby': (result.data['standby'] ?? 0) as int,
      'Submitted': (result.data['submitted'] ?? 0) as int,
      'Failed': (result.data['failed'] ?? 0) as int,
    };
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
    final standbyUsers =
        await (select(youthUsers)
          ..where((tbl) => tbl.status.equals('Standby'))).get();

    final List<Map<String, dynamic>> exportData = [];

    try {
      for (final user in standbyUsers) {
        final info =
            await (select(youthInfos)..where(
              (tbl) => tbl.youthUserId.equals(user.youthUserId),
            )).getSingleOrNull();

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
            'created_at': user.createdAt.toIso8601String(),
          },
          'info':
              info != null
                  ? {
                    'fname': info.fname,
                    'mname': info.mname,
                    'lname': info.lname,
                    'sex': info.sex,
                    'gender': info.gender,
                    'age': info.age,
                    'address': info.placeOfBirth,
                    'dateOfBirth': info.dateOfBirth,
                    'placeOfBirth': info.placeOfBirth,
                    'contactNo': info.contactNo,
                    'height': info.height,
                    'weight': info.weight,
                    'religion': info.religion,
                    'occupation': info.occupation,
                    'civilStatus': info.civilStatus,
                    'noOfChildren': info.noOfChildren,
                    'created_at': info.createdAt.toIso8601String(),
                  }
                  : null,
          'educBG':
              educs
                  .map(
                    (e) => {
                      'level': e.level,
                      'nameOfSchool': e.nameOfSchool,
                      'periodOfAttendance': e.periodOfAttendance,
                      'yearGraduate': e.yearGraduate,
                      'created_at': e.createdAt.toIso8601String(),
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
                      'created_at': c.createdAt.toIso8601String(),
                    },
                  )
                  .toList(),
        });
      }
    } catch (e) {
      print(e);
    }
    return exportData;
  }

  Future<void> updateMigrationStatus({
    required List<int> submitted,
    required List<int> failed,
  }) async {
    await batch((batch) {
      if (submitted.isNotEmpty) {
        batch.update(
          youthUsers,
          YouthUsersCompanion(status: const Value('Submitted')),
          where: (tbl) => tbl.youthUserId.isIn(submitted),
        );
      }

      // Update failed users
      if (failed.isNotEmpty) {
        batch.update(
          youthUsers,
          YouthUsersCompanion(status: const Value('Failed')),
          where: (tbl) => tbl.youthUserId.isIn(failed),
        );
      }
    });
  }

  Future<Map<String, dynamic>> getAllYouthProfiles({
    String searchKeyword = '',
    int limit = 10,
    int offset = 0,
  }) async {
    final query = select(youthUsers)..limit(limit, offset: offset);
    List<int> userIds = [];

    // If there is a search keyword, find matching user IDs
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

      query.where((tbl) => tbl.youthUserId.isIn(userIds));
    }

    final users = await query.get();
    final result = <FullYouthProfile>[];

    for (final user in users) {
      final youthInfo =
          await (select(youthInfos)..where(
            (tbl) => tbl.youthUserId.equals(user.youthUserId),
          )).getSingleOrNull();

      final educs =
          await (select(educBgs)
            ..where((tbl) => tbl.youthUserId.equals(user.youthUserId))).get();

      final civics =
          await (select(civicInvolvements)
            ..where((tbl) => tbl.youthUserId.equals(user.youthUserId))).get();

      result.add(
        FullYouthProfile(
          youthUser: user,
          youthInfo: youthInfo,
          educBgs: educs,
          civicInvolvements: civics,
        ),
      );
    }

    final countQuery = selectOnly(youthUsers)
      ..addColumns([youthUsers.youthUserId.count()]);

    if (searchKeyword.isNotEmpty && userIds.isNotEmpty) {
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

    return {
      'youth': result,
      'pagesLeft': pagesLeft,
      'totalPages': totalPages,
      'totalCount': totalCount,
      'currentPage': currentPage,
      'rowsLeft': rowsLeft,
    };
  }

  @override
  int get schemaVersion => 2;
}
