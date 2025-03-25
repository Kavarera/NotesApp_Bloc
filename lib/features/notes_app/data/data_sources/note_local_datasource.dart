import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/category_model.dart';
import '../models/note_model.dart';

class NoteLocalDataSource {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'note_app_v1.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
      ''');

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        categoryId INTEGER NULL,
        FOREIGN KEY (categoryId) REFERENCES categories(id)
      )
    ''');
  }

  Future<List<NoteModel>> getNotes() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db!.rawQuery('''
  SELECT notes.*, categories.name as category_name 
  FROM notes 
  LEFT JOIN categories ON notes.categoryId = categories.id
''');
    return List.generate(maps.length, (i) {
      return NoteModel.fromJson(maps[i]);
    });
  }

  Future<int> insertNote(NoteModel note) async {
    final db = await database;
    return await db!.insert(
      'notes',
      note.toJson(),
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateNote(NoteModel note) async {
    final db = await database;
    log("Data sebelum Update: ${note.toJson()}", name: "DATABASE");
    await db!.update(
      'notes',
      note.toJson(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await database;
    await db!.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  //Category
  Future<List<CategoryModel>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('categories');
    return List.generate(maps.length, (i) {
      return CategoryModel.fromJson(maps[i]);
    });
  }

  Future<void> insertCategory(CategoryModel category) async {
    final db = await database;
    await db!.insert(
      'categories',
      category.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCategory(CategoryModel category) async {
    final db = await database;
    await db!.update(
      'categories',
      category.toJson(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<void> deleteCategory(int id) async {
    final db = await database;
    await db!.delete('categories', where: 'id = ?', whereArgs: [id]);
  }
}
