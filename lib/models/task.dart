import 'package:flutter/material.dart';

class Task {
  String id;
  String name;
  String desc;
  int color;
  int codePoint;
  DateTime dueDate;
  bool isCompleted;

  Task(
    this.name, {
    @required this.color,
    @required this.codePoint,
    this.desc,
    this.dueDate,
    this.isCompleted = false,
    @required this.id,
  });
}
