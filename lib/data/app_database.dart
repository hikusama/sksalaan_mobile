import 'package:drift/drift.dart';
import 'package:skyouthprofiling/service/connection.dart';

part 'app_database.g.dart';  

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
}

class YouthInfos extends Table {
  IntColumn get youthInfosId => integer().autoIncrement()(); 

  IntColumn get youthUserId => integer().customConstraint('REFERENCES youth_users(youth_user_id) ON DELETE CASCADE')(); 

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

  IntColumn get youthUserId => integer().customConstraint('REFERENCES youth_users(youth_user_id) ON DELETE CASCADE')(); 

  TextColumn get level => text()();
  TextColumn get nameOfSchool => text()();
  TextColumn get periodOfAttendance => text()();
  TextColumn get yearGraduate => text()();
}

class CivicInvolvements extends Table {
  IntColumn get civicInvolvementId => integer().autoIncrement()(); 

  IntColumn get youthUserId => integer().customConstraint('REFERENCES youth_users(youth_user_id) ON DELETE CASCADE')(); 

  TextColumn get nameOfOrganization => text()();
  TextColumn get addressOfOrganization => text()();
  TextColumn get start => text()();
  TextColumn get end => text()();
  TextColumn get yearGraduated => text()();
}





@DriftDatabase(tables: [Users,YouthUsers,YouthInfos,EducBgs,CivicInvolvements])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

Future<void> insertYouthUser(YouthUsersCompanion user) =>
    into(youthUsers).insert(user);




Future<List<YouthUser>> getAllYouthUsers() =>
    select(youthUsers).get();

Future<bool> updateYouthUser(YouthUser user) =>
    update(youthUsers).replace(user);

Future<int> deleteYouthUser(int id) =>
    (delete(youthUsers)..where((t) => t.youthUserId.equals(id))).go();

  @override
  int get schemaVersion => 2;
}
