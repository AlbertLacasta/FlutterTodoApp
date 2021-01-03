import 'dart:convert';

List<Todo> todoFromJson(String str) =>
    List<Todo>.from(json.decode(str).map((x) => Todo.fromJson(x)));

String todoToJson(List<Todo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Todo {
  int id;
  String text;
  bool done;

  Todo({
    this.id,
    this.text,
    this.done
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json["id"],
    text: json["text"],
    done: json["done"] is bool ? json["done"] : json["done"] == 1,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
    "done": done
  };
}
