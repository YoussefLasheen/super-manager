import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermanager/api.dart';
import 'package:supermanager/models/task.dart';
import 'package:supermanager/widgets/add_task_card.dart';
import 'package:supermanager/widgets/task_progress_indicator.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  final List todos;

  final int totalTodos;
  final int taskCompletionPercent;

  TaskCard({
    @required this.task,
    @required this.todos,
    @required this.totalTodos,
    @required this.taskCompletionPercent,
  });

  @override
  Widget build(BuildContext context) {
    Color color = Color(task.color);
    var user = Provider.of<FirebaseUser>(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 8.0,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
          child: Stack(
            children: <Widget>[
              Column(
                children: [
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              InkWell(
                                child: Icon(
                                  IconData(task.codePoint,
                                      fontFamily: 'MaterialIcons'),
                                  color: color,
                                ),
                                onLongPress: () {
                                  Api('users').updateTask(
                                      task.id,
                                      {'isCompleted': !task.isCompleted},
                                      user.uid);
                                },
                              ),
                              Expanded(
                                  flex: 8,
                                  child: task.dueDate == null
                                      ? Container()
                                      : FittedBox(
                                          child: Text(
                                            'Due:'
                                            "\n${task.dueDate.day}/\n${task.dueDate.month}/\n${task.dueDate.year}",
                                            maxLines: 4,
                                            style: Theme.of(context)
                                                .textTheme
                                                .body1
                                                .copyWith(
                                                    color: Colors.grey[500]),
                                          ),
                                        )),
                              Container(
                                margin: EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  "$totalTodos Task",
                                  style: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(color: Colors.grey[500]),
                                ),
                              ),
                              Container(
                                child: task.name == ''
                                    ? Container()
                                    : FittedBox(
                                        child: Text(task.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .title
                                                .copyWith(
                                                    color: Colors.black54)),
                                      ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: ListView.builder(
                            itemExtent: 30,
                            padding: EdgeInsets.all(0),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0) {
                                return task.desc == ''
                                    ? Container()
                                    : Text(
                                        task.desc,
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black54,
                                        ),
                                      );
                              }
                              var todo = todos[index - 1];
                              List newTodos = new List.from(todos);
                              return Row(
                                children: <Widget>[
                                  Checkbox(
                                      tristate: true,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      activeColor: color,
                                      onChanged: (value) {
                                        if (!task.isCompleted) {
                                          var tile = newTodos
                                              .firstWhere((ct) => ct == todo);
                                          tile['isCompleted'] = value;
                                          Api('users').updateTask(task.id,
                                              {'todos': newTodos}, user.uid);
                                        }
                                      }, // model.updateTodo(todo.copy(isCompleted: value ? 1 : 0)),
                                      value: todo['isCompleted']),
                                  Expanded(
                                    child: Text(
                                      todo['name'],
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                        color: todo['isCompleted'] != false
                                            ? color
                                            : Colors.black54,
                                        decoration: todo['isCompleted'] != false
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            itemCount: todos.length + 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TaskProgressIndicator(
                    color: color,
                    progress: task.isCompleted
                        ? 100
                        : (taskCompletionPercent * 0.9).toInt(),
                  ),
                ],
              ),
              task.isCompleted
                  ? Center(
                      child: Divider(
                      color: Colors.red,
                      thickness: 5,
                    ))
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
