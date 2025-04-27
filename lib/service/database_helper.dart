import 'package:path/path.dart';
import 'package:skyouthprofiling/data/models/youth.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();


  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE info (
          infoID INTEGER PRIMARY KEY AUTOINCREMENT,
          name VARCHAR NOT NULL,
          age INTEGER NOT NULL,
          role VARCHAR NOT NULL,
          company VARCHAR NOT NULL
        )
        ''');
      },
    );
    return database;
  }

  Future<void> addYouth(Map<String,dynamic> data) async {
    final db = await database;
    await db.insert('info', {
      'name': data['name'],
      'age': data['age'],
      'role': data['role'],
      'company': data['company'],
    });
  }

  Future<List<Youth>> getYouth() async {
    final db = await database;
    final data = await db.query('info');
    // print(data);
    List<Youth> info =
        data
            .map(
              (e) => Youth(
                name: e["name"] as String,
                age: e["age"] as int,
                company: e["company"] as String,
                role: e["role"] as String,
              ),
            )
            .toList();
            /*
    required this.name,
    required this.age,
    required this.company,
    required this.role,
            */
    return info;
  }
}
