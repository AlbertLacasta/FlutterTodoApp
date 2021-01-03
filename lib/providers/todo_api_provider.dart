import 'package:dio/dio.dart';
import 'package:flutter_todo_app/models/todo_model.dart';

import 'db_provider.dart';

class TodoApiProvider {
  Future<List<Todo>> getAllTodos() async {
    var url = "https://demo5908591.mockable.io/todo";
    Response response = await Dio().get(url);

    return (response.data as List).map( (todo) {
      //print('Inserting $todo');
      _createTodo(todo);
      return Todo.fromJson(todo);
    }).toList();
  }

  _createTodo(todo) async {
    return await DBProvider.db.createTodo(Todo.fromJson(todo));
  }
}
