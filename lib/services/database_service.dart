import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:sattiv/model/entry.dart';

class DatabaseService {
  static final DatabaseService _databaseHelper = DatabaseService._();

  DatabaseService._();

  late Database db;
  // factory keyword is used to create a constructor that would only return one instance.
  factory DatabaseService() {
    return _databaseHelper;
  }

  Future<void> initDB() async {
    String path = await getDatabasesPath();
    WidgetsFlutterBinding.ensureInitialized();
    db = await openDatabase(
      join(path, 'entries_data.db'),
      onCreate: (database, version) async {
        await database.execute(
          """
            CREATE TABLE entries(
            date INTEGER PRIMARY KEY,
            type TEXT NULL,
            dateString TEXT NULL, 
            sgv INTEGER NULL,
            direction TEXT NULL,
            noise INTEGER NULL,
            filtered INTEGER NULL,
            unfiltered INTEGER NULL
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
      'entries',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<int> updateEntry(Entry entry) async {
    int result = await db.update(
      'entries',
      entry.toMap(),
      where: "date = ?",
      whereArgs: [entry.date],
    );
    return result;
  }

  Future<List<Entry>> retrieveAllEntries() async {
    final List<Map<String, dynamic>> queryResult = await db.query('entries');
    return queryResult.map((e) => Entry.fromMap(e)).toList();
  }

  Future<List<Entry>> retrieveEntries(int timestamp) async {
    final List<Map<String, dynamic>> queryResult = //await db.query('entries');
        await db.rawQuery("""
        SELECT * FROM entries 
        WHERE date > $timestamp
        ORDER BY date DESC
        LIMIT 288""");
    return queryResult.map((e) => Entry.fromMap(e)).toList();
  }

  Future<void> deleteEntry(int date) async {
    await db.delete(
      'entries',
      where: "id = ?",
      whereArgs: [date],
    );
  }
}
