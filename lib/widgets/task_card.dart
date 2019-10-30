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
      onTap: () {},
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4.0,
        margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(IconData(task.codePoint,fontFamily: 'MaterialIcons'),color: color,),
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
                                            .copyWith(color: Colors.grey[500]),
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
                            :FittedBox(
                              child: Text(task.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .copyWith(color: Colors.black54)),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: ListView.builder(
                        itemExtent: 40,
                        padding: EdgeInsets.all(0),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          var todo = todos[index];
                          List newTodos = new List.from(todos);
                          return ListTile(
                            leading: Checkbox(
                                activeColor: color,
                                onChanged: (value) {
                                  var tile =
                                      newTodos.firstWhere((ct) => ct == todo);
                                  tile['isCompleted'] = value;
                                  Api('users')
                                      .updateTodos(task.id, newTodos, user.uid);
                                }, // model.updateTodo(todo.copy(isCompleted: value ? 1 : 0)),
                                value: todo['isCompleted']),
                            trailing: IconButton(
                              icon: Icon(Icons.delete_outline),
                              onPressed: () {
                                newTodos.remove(todo);
                                Api('users')
                                    .updateTodos(task.id, newTodos, user.uid);
                              }, //model.removeTodo(todo),
                            ),
                            title: Text(
                              todo['name'],
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                color: todo['isCompleted'] == true
                                    ? color
                                    : Colors.black54,
                                decoration: todo['isCompleted'] == true
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          );
                        },
                        itemCount: todos.length,
                      ),
                    ),
                  ],
                ),
              ),
              TaskProgressIndicator(
                color: color,
                progress: taskCompletionPercent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
