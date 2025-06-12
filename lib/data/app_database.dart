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
  TextColumn get contactNo => text()();
  RealColumn get height => real()();
  RealColumn get weight => real()();
  TextColumn get religion => text()();
  TextColumn get occupation => text()();
  TextColumn get civilStatus => text()();
  IntColumn get noOfChildren => integer()();
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

  Future<List<YouthUser>> getAllYouthUsers() => select(youthUsers).get();

  Future<bool> updateYouthUser(YouthUser user) =>
      update(youthUsers).replace(user);

  Future<int> deleteYouthUser(int id) =>
      (delete(youthUsers)..where((t) => t.youthUserId.equals(id))).go();

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

  Future<List<FullYouthProfile>> getAllYouthProfiles() async {
    final users = await select(youthUsers).get();

    final List<FullYouthProfile> result = [];

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

    return result;
  }

  @override
  int get schemaVersion => 2;
}
