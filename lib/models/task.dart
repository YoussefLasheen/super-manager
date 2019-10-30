import 'package:flutter/material.dart';

class Task {
  String id;
  String name;
  int color;
  int codePoint;
  DateTime dueDate;

  Task(
    this.name, {
    @required this.color,
    @required this.codePoint,
    this.dueDate,
    @required this.id,
  });
}
