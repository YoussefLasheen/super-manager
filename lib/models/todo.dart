import 'package:meta/meta.dart';

class Todo {
  final String id, parent;
  final String name;
  
  final int isCompleted;

  Todo(this.name, {
    @required this.parent,
    this.isCompleted = 0,
    String id
  }): this.id = id;
}
