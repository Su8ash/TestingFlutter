import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NameListProvider {
  final String dbName = "sqfliteExample2.db";
  final String tableName = "names";

  // Columns
  final String columnId = "_id";
  final String columnName = "name";
  final String columnPosition = "position";

  late Database database;

  Future init() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, dbName);

    log("DB init");

    database = await openDatabase(
      path,
      version: 2,
      onCreate: createTableOnCreate,
    );
  }

  Future createTableOnCreate(Database db, int version) async {
    db.execute('''
create table $tableName ( 
  $columnId integer primary key autoincrement, 
  $columnName text not null,
  $columnPosition integer not null)
''');

    log("Table Created");
  }

  // {

  //   "name": "Name",
  //   "position": 1
  // }

  // Insert
  Future<List<Map<String, Object?>>?> insert(Map<String, Object?> name) async {
    int insertID = await database.insert(tableName, name);

    if (insertID > 0) {
      return await getNameList();
    }

    return null;
  }

  Future<List<Map<String, Object?>>> getNameList() async {
    return await database.query(
      tableName,
      orderBy: columnPosition,
    );
  }

  Future update(Map<String, Object?> name) async {
    // {
    //  "_id": 1,
    //   "name": "Name",
    //   "position": 1
    // }

    // "Update table where id = name.id"

    database.update(
      tableName,
      name,
      where: "$columnId = ?",
      whereArgs: [name[columnId]],
    );
  }

  Future delete(int id) async {
    await database.delete(
      tableName,
      where: "$columnId = ?",
      whereArgs: [id],
    );
  }

  Future close() async {
    log("DB close");
    database.close();
  }
}
