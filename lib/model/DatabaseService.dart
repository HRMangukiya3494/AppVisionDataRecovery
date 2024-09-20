import 'dart:developer';
import 'package:path/path.dart';
import 'package:photo_recovery/model/FileModel.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  late Database _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'ecovered_files.db');
      _database = await openDatabase(
        path,
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE files(id INTEGER PRIMARY KEY, name TEXT, path TEXT, type INTEGER)",
          );
        },
        version: 1,
      );
    } catch (e) {
      log('Error initializing database: $e');
      rethrow;
    }
  }

  Future<Database> get database async {
    await _initDatabase();
    return _database;
  }

  Future<void> insertFiles(List<FileModel> files) async {
    final db = await database; // Wait for database initialization
    for (var file in files) {
      await db.insert('files', file.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<FileModel>> getFiles() async {
    final db = await database; // Wait for database initialization
    final List<Map<String, dynamic>> maps = await db.query('files');
    return List.generate(maps.length, (i) {
      return FileModel.fromMap(maps[i]);
    });
  }
}