import 'dart:io';
import 'package:flutter_todo_app/models/todo_model.dart';
import 'package:flutter_todo_app/providers/todo_api_provider.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Employee table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'todo.db');

    var apiProvider = TodoApiProvider();
    await apiProvider.getAllTodos();

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE Todo('
              'id INTEGER PRIMARY KEY,'
              'text TEXT,'
              'done BOOLEAN'
              ')');
        });
  }

  // Insert employee on database
  createTodo(Todo newTodo) async {
    final db = await database;
    final res = await db.insert('Todo', newTodo.toJson());

    return res;
  }

  // Insert item on database
  updateTodo(int id, bool done) async {
    final db = await database;
    final res = await db.update('Todo', {"id": id, "done": done});

    return res;
  }

  // Delete all todos
  Future<int> deleteAllTodos() async {
    final db = await database;
    await db.execute('DELETE FROM TODO');
  }

  Future<int> deleteTodo(int id) async {
    final db = await database;
    await db.delete('TODO', where: "id = ?", whereArgs: [id]);
  }

  Future<List<Todo>> getAllTodos() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM TODO");
    return res.isNotEmpty ? res.map((c) => Todo.fromJson(c)).toList() : [];
  }
}
