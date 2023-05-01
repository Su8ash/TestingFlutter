import 'dart:developer';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NameListProvider {
  final String dbName = "sqfliteExample.db";
  final String tableName = 'names';
  final String columnId = "_id";
  final String columnName = "name";
  final String columnPosition = "position";

  late final Database database;

  // This is to be called on class Initialization.
  Future init() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, dbName);
    log("Database Init");
    database = await openDatabase(
      path,
      version: 1,
      onCreate: createTableOnCreate,
    );
  }

  // SQL code to create the database table
  Future createTableOnCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableName (
  $columnId integer primary key autoincrement, 
  $columnName text not null,
  $columnPosition int not null
          )
          ''');

    log("Table Created");
  }

  // Adds data to the database.
  Future<List<Map<String, dynamic>>?> insert(Map<String, Object?> names) async {
    log("inserting");

    int insertId = await database.insert(tableName, names);
    if (insertId > 0) {
      return await getNameList();
    }
    return null;
  }

  // All the data of the database is returned as List<Map<String, dynamic>>.
  Future<List<Map<String, dynamic>>> getNameList() async {
    return await database.query(tableName, orderBy: columnPosition);
  }

  // As we know that _id is primary key so it is unique
  // So all the data of the row will be updated based on the id.
  Future<int> update(Map<String, dynamic> name) async {
    int nameId = name[columnId];
    return await database.update(
      tableName,
      name,
      where: '$columnId = ?',
      whereArgs: [nameId],
    );
  }

  // Deletes the row based on the id.
  Future<int> delete(int id) async {
    return await database.delete(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    log("DB Close");
    return database.close();
  }
}
