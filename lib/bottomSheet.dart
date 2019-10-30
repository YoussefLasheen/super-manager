import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/block_picker.dart';
import 'package:provider/provider.dart';
import 'package:supermanager/widgets/icon_picker.dart';
import 'package:supermanager/widgets/view_add_todos.dart';

import 'api.dart';
import 'util.dart';

class Modal {
  mainBottomSheet(BuildContext context, String otherEndId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50), topRight: Radius.circular(50)),
      ),
      builder: (BuildContext context) {
        return SheetBody(otherEndId);
      },
    );
  }
}

class SheetBody extends StatefulWidget {
  final String otherEndId;

  const SheetBody(this.otherEndId);
  @override
  _SheetBodyState createState() => _SheetBodyState();
}

class _SheetBodyState extends State<SheetBody> {
  DateTime selectedDate;
  String dueDate;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  final descFocus = FocusNode();
  Color taskColor = Color.fromRGBO(38, 198, 218, 1);
  IconData taskIcon = Icons.notifications;
  List<Map> todos = [];
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    var _uniqueChatid = user.uid.compareTo(widget.otherEndId) <= -1
        ? user.uid + '_to_' + widget.otherEndId
        : widget.otherEndId + '_to_' + user.uid;
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          backgroundColor: taskColor,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.close),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 30),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                child: TextFormField(
                    autofocus: true,
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    cursorColor: taskColor,
                    style: TextStyle(fontSize: 44, fontStyle: FontStyle.normal),
                    decoration: InputDecoration(hintText: 'Enter a Title'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(descFocus);
                    },
                    validator: (value) =>
                        value.isEmpty ? 'Can\'t be empty' : null),
              ),
              SizedBox(height: 5),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                child: TextFormField(
                    maxLines: null,
                    minLines: 3,
                    keyboardType: TextInputType.text,
                    controller: descController,
                    cursorColor: taskColor,
                    focusNode: descFocus,
                    textInputAction: TextInputAction.newline,
                    style: TextStyle(fontSize: 22, fontStyle: FontStyle.normal),
                    decoration:
                        InputDecoration(hintText: 'Enter a Description'),
                    validator: (value) =>
                        value.isEmpty ? 'Can\'t be empty' : null),
              ),
              SizedBox(height: 5),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 60,
                padding: EdgeInsets.symmetric(vertical: 15),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: <Widget>[
                    Center(
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 10.0,
                            width: 10.0,
                            margin: EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: CustomColors.YellowAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Text('Personal'),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 10.0,
                            width: 10.0,
                            margin: EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: CustomColors.PurpleIcon,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Text('Urgent'),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 10.0,
                            width: 10.0,
                            margin: EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: CustomColors.BlueIcon,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Text('Not Urgent'),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 10.0,
                            width: 10.0,
                            margin: EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: CustomColors.OrangeIcon,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Text('Meeting'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ColorPickerBuilder(
                        color: taskColor,
                        onColorChanged: (newColor) =>
                            setState(() => taskColor = newColor)),
                    IconPickerBuilder(
                        iconData: taskIcon,
                        highlightColor: taskColor,
                        action: (newIcon) =>
                            setState(() => taskIcon = newIcon)),
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.all(
                            Radius.circular(20),
                          ),
                          side: BorderSide(color: taskColor)),
                      child: Icon(
                        Icons.calendar_today,
                        color: taskColor,
                      ),
                      onPressed: () async {
                        dueDate = _selectDate(context);
                      },
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.all(
                            Radius.circular(20),
                          ),
                          side: BorderSide(color: taskColor)),
                      child: Icon(
                        Icons.attach_file,
                        color: taskColor,
                      ),
                      onPressed: () async {
                        dueDate = _selectDate(context);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: dueDate != null
                    ? Row(
                        children: <Widget>[Text("Due Date: "), Text(dueDate)],
                      )
                    : Container(),
              ),
              SizedBox(height: 20),
              Container(
                constraints: BoxConstraints(minHeight: 50),
                child: ViewAddTodos(
                  taskColor: taskColor,
                  callback: (value){
                    todos = value;
                  },
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  onPressed: () {
                    Map task = {
                      'title': nameController.text,
                      'desc': descController.text,
                      'sender': user.uid,
                      'dueDate': selectedDate,
                      'date': DateTime.now(),
                      'codePoint':taskIcon.codePoint,
                      'color' : taskColor.value,
                      'todos': todos,
                      'isCompleted': false
                    };
                    Api('users').addTask(task, widget.otherEndId);
                    widget.otherEndId != user.uid
                    ?Api('chats').sendMessage({
                      'content': nameController.text +
                          ' Task was Created by the manager',
                      'sender': 'SYSTEM'
                    }, _uniqueChatid):null;
                    Navigator.pop(context);
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  color: taskColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: const Text(
                      'Add task',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2020),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData(
            primaryColor: taskColor,
            accentColor: taskColor
          ),
          child: child,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dueDate =
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
      });
      print('Date selected: $dueDate');
    }
  }
}

class ColorPickerBuilder extends StatelessWidget {
  final Color color;
  final ValueChanged<Color> onColorChanged;

  ColorPickerBuilder({@required this.color, @required this.onColorChanged});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: color,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Select a color'),
              content: SingleChildScrollView(
                child: BlockPicker(
                  availableColors: [
                    Colors.blueGrey,
                    Colors.red,
                    Colors.pink,
                    Colors.purple,
                    Colors.deepPurple,
                    Colors.indigo,
                    Colors.blue,
                    Colors.lightBlue,
                    Colors.cyan,
                    Colors.teal,
                    Colors.green,
                    Colors.lightGreen,
                    Colors.lime,
                    Colors.yellow,
                    Colors.amber,
                    Colors.orange,
                    Colors.deepOrange,
                    Colors.brown,
                    Colors.grey,
                  ],
                  pickerColor: color,
                  onColorChanged: onColorChanged,
                ),
              ),
            );
          },
        );
      },
      child: Icon(
        Icons.color_lens,
        ),
    );
  }
}

class IconPickerBuilder extends StatelessWidget {
  final IconData iconData;
  final ValueChanged<IconData> action;
  final Color highlightColor;

  IconPickerBuilder({
    @required this.iconData,
    @required this.action,
    Color highlightColor,
  }) : this.highlightColor = highlightColor;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: highlightColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Select an icon'),
                content: SingleChildScrollView(
                  child: IconPicker(
                    currentIconData: iconData,
                    onIconChanged: action,
                    highlightColor: highlightColor,
                  ),
                ),
              );
            },
          );
        },
        child: Icon(iconData));
  }
}
