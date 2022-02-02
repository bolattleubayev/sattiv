import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:sattiv/model/entry.dart';

class DatabaseHelper {
  static final DatabaseHelper _databaseHelper = DatabaseHelper._();

  DatabaseHelper._();

  late Database db;
  // factory keyword is used to create a constructor that would only return one instance.
  factory DatabaseHelper() {
    return _databaseHelper;
  }

  Future<void> initDB() async {
    String path = await getDatabasesPath();
    db = await openDatabase(
      join(path, 'glucose_data.db'),
      onCreate: (database, version) async {
        await database.execute(
          """
            CREATE TABLE [IF NOT EXISTS] glucose_data(
            date INTEGER PRIMARY KEY,
            type TEXT, dateString TEXT,
            sgv INTEGER, direction TEXT,
            noise INTEGER,
            filtered INTEGER,
            unfiltered INTEGER
            )
          """,
        );
      },
      version: 1,
    );
  }

  /// API
  /// get entries

  /// CRUD
  Future<int> insertEntry(Entry entry) async {
    int result = await db.insert(
      'glucose_data',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<int> updateEntry(Entry entry) async {
    int result = await db.update(
      'glucose_data',
      entry.toMap(),
      where: "date = ?",
      whereArgs: [entry.date],
    );
    return result;
  }

  Future<List<Entry>> retrieveEntries() async {
    final List<Map<String, dynamic>> queryResult =
        await db.query('glucose_data');
    return queryResult.map((e) => Entry.fromMap(e)).toList();
  }

  Future<void> deleteEntry(int date) async {
    await db.delete(
      'glucose_data',
      where: "id = ?",
      whereArgs: [date],
    );
  }
}
