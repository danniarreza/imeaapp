import 'package:imeaapp/model/prayertime.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PrayerTimeDatabase {
  static final PrayerTimeDatabase instance = PrayerTimeDatabase._init();

  static Database _database;

  PrayerTimeDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDB('notes.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = 'BOOLEAN NOT NULL';
    final intType = 'INTEGER NOT NULL';
    final stringType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE $tablePrayerTime (
        ${PrayerTimeFields.id} $idType,
        ${PrayerTimeFields.date} $stringType,
        ${PrayerTimeFields.subuh} $stringType,
        ${PrayerTimeFields.terbit} $stringType,
        ${PrayerTimeFields.dhuhur} $stringType,
        ${PrayerTimeFields.ashar} $stringType,
        ${PrayerTimeFields.maghrib} $stringType,
        ${PrayerTimeFields.isha} $stringType
      )
    ''');

    // to create another table
    // await db.execute('''
    //   CREATE TABLE $tablePrayerTime (
    //     ${PrayerTimeFields.id} $idType,
    //     ${PrayerTimeFields.date} $stringType,
    //     ${PrayerTimeFields.subuh} $stringType,
    //     ${PrayerTimeFields.dhuhur} $stringType,
    //     ${PrayerTimeFields.ashar} $stringType,
    //     ${PrayerTimeFields.maghrib} $stringType,
    //     ${PrayerTimeFields.isha} $stringType,
    //   )
    // ''');
  }

  Future<PrayerTime> create(PrayerTime prayerTime) async {
    final db = await instance.database;

    // final columns = '${PrayerTimeFields.date}, ${PrayerTimeFields.subuh}';
    // final id = await db.rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tablePrayerTime, prayerTime.toJson());
    prayerTime.id = id;
    return prayerTime;
  }

  Future<PrayerTime> read(int id) async {
    final db = await instance.database;
    final result = await db.query(
      tablePrayerTime,
      columns: PrayerTimeFields.values,
      where: '${PrayerTimeFields.id} = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return PrayerTime.fromJson(result.first);
    } else {
      throw Exception('ID $id is not found');
    }
  }

  Future<List<PrayerTime>> readAll() async {
    final db = await instance.database;
    final orderBy = '${PrayerTimeFields.date} ASC';
    final result = await db.query(tablePrayerTime, orderBy: orderBy);

    return result.map((json) {
      return PrayerTime.fromJson(json);
    }).toList();
  }

  Future<int> count() async{
    final db = await instance.database;
    final result = await db.rawQuery("SELECT COUNT(*) FROM "+ tablePrayerTime);
    return Sqflite.firstIntValue(result);
  }

  Future<int> update(PrayerTime prayerTime) async {
    final db = await instance.database;

    return db.update(
      tablePrayerTime,
      prayerTime.toJson(),
      where: '${PrayerTimeFields.id} = ?',
      whereArgs: [prayerTime.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tablePrayerTime,
      where: '${PrayerTimeFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
