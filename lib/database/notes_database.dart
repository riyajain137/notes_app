import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';

class NotesDatabase {
  //Creating a instance of database
  static final NotesDatabase instance = NotesDatabase._init();

  NotesDatabase._init();

  static sqflite.Database? _database;
  //When db is not created initially
  Future<sqflite.Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }
  //Call for creating database
  Future<sqflite.Database> _initDB(String filePath) async {
    final dpPath = await sqflite.getDatabasesPath();
    final path = join(dpPath, filePath);

    return await sqflite.openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(sqflite.Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        date TEXT NOT NULL,
        color INTEGER NOT NULL DEFAULT 0

      )
      ''');
  }
  //create
  Future<int> addNote(
    String title,
    String description,
    String date,
    int color,
  ) async {
    final db = await instance.database;

    return await db.insert('notes', {
      'title': title,
      'description': description,
      'date': date,
      'color': color,
    });
  }
  //get
  Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await instance.database;

    return await db.query('notes', orderBy: 'date DESC');
  }
  //update
  Future<int> updateNote(
    String title,
    String description,
    String date,
    int color,
    int id,
  ) async {
    final db = await instance.database;

    return await db.update(
      'notes',
      {
        'title': title,
        'description': description,
        'date': date,
        'color': color,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  //delete
  Future<int> deleteNote(int id) async {
    final db = await instance.database;

    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
  //delete all
  Future<int> deleteAllNotes() async {
    final db = await instance.database;

    return await db.delete('notes');
  }
}

