import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:sattiv/model/entry.dart';
import 'package:sattiv/model/calibration_plot_datapoint.dart';

class DatabaseService {
  static final DatabaseService _databaseHelper = DatabaseService._();

  DatabaseService._();

  late Database _entriesDB;
  late Database _calibrationsDB;

  // factory keyword is used to create a constructor that would only return one instance.
  factory DatabaseService() {
    return _databaseHelper;
  }

  Future<void> initDB() async {
    String path = await getDatabasesPath();
    WidgetsFlutterBinding.ensureInitialized();
    _entriesDB = await openDatabase(
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

    _calibrationsDB = await openDatabase(
      join(path, 'calibrations_data.db'),
      onCreate: (database, version) async {
        await database.execute(
          """
            CREATE TABLE calibrations(
            date INTEGER PRIMARY KEY,
            dateString TEXT NULL, 
            measuredValue REAL NULL,
            sensorValue INTEGER NULL
            )
          """,
        );
      },
      version: 1,
    );
  }

  /// Calibrations CRUD
  Future<int> insertCalibration(CalibrationPlotDatapoint calibration) async {
    int result = await _calibrationsDB.insert(
      'calibrations',
      calibration.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<int> updateCalibration(CalibrationPlotDatapoint calibration) async {
    int result = await _calibrationsDB.update(
      'calibrations',
      calibration.toMap(),
      where: "date = ?",
      whereArgs: [calibration.date],
    );
    return result;
  }

  Future<List<CalibrationPlotDatapoint>> retrieveAllCalibrations() async {
    final List<Map<String, dynamic>> queryResult =
        await _calibrationsDB.query('calibrations');
    return queryResult.map((e) => CalibrationPlotDatapoint.fromMap(e)).toList();
  }

  Future<List<CalibrationPlotDatapoint>> retrieveCalibrations(int count) async {
    final List<Map<String, dynamic>> queryResult = //await db.query('entries');
        await _calibrationsDB.rawQuery("""
        SELECT * FROM calibrations 
        ORDER BY date DESC
        LIMIT $count""");
    return queryResult.map((e) => CalibrationPlotDatapoint.fromMap(e)).toList();
  }

  Future<void> deleteCalibration(int date) async {
    await _calibrationsDB.delete(
      'calibrations',
      where: "id = ?",
      whereArgs: [date],
    );
  }

  /// Entries CRUD
  Future<int> insertEntry(Entry entry) async {
    int result = await _entriesDB.insert(
      'entries',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<int> updateEntry(Entry entry) async {
    int result = await _entriesDB.update(
      'entries',
      entry.toMap(),
      where: "date = ?",
      whereArgs: [entry.date],
    );
    return result;
  }

  Future<List<Entry>> retrieveLastEntry() async {
    // Actually retrieves the one before last
    // as last entry refresh is called more often
    final List<Map<String, dynamic>> queryResult = //await db.query('entries');
        await _entriesDB.rawQuery("""
        SELECT * FROM entries ORDER BY date DESC LIMIT 2
        """);
    return queryResult.map((e) => Entry.fromMap(e)).toList();
  }

  Future<List<Entry>> retrieveAllEntries() async {
    final List<Map<String, dynamic>> queryResult =
        await _entriesDB.query('entries');
    return queryResult.map((e) => Entry.fromMap(e)).toList();
  }

  Future<List<Entry>> retrieveEntries(int timestamp) async {
    final List<Map<String, dynamic>> queryResult = //await db.query('entries');
        await _entriesDB.rawQuery("""
        SELECT * FROM entries 
        WHERE date > $timestamp
        ORDER BY date DESC
        LIMIT 288""");
    return queryResult.map((e) => Entry.fromMap(e)).toList();
  }

  Future<void> deleteEntry(int date) async {
    await _entriesDB.delete(
      'entries',
      where: "id = ?",
      whereArgs: [date],
    );
  }
}
