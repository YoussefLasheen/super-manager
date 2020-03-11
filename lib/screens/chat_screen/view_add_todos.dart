// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ViewAddTodos extends StatefulWidget {
  final Color taskColor;
  final Function(List<Map>) callback;

  const ViewAddTodos({Key key, this.taskColor, this.callback})
      : super(key: key);
  @override
  _ViewAddTodosState createState() => _ViewAddTodosState();
}

class _ViewAddTodosState extends State<ViewAddTodos> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ListModel<Map> _list;

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _list = ListModel<Map>(
      listKey: _listKey,
      initialItems: <Map>[],
      removedItemBuilder: _buildRemovedItem,
    );
  }

  // Used to build list items that haven't been removed.
  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    if (_list.length == index)
      return Container(
        child: Row(
          children: <Widget>[
            Expanded(
                child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Type a Todo here",
                  contentPadding: EdgeInsets.only(left: 10)),
              maxLength: 15,
              textInputAction: TextInputAction.done,
              onEditingComplete: () {
                if (editingController.text == '') {
                } else {
                  _insert(editingController.text);
                  widget.callback(_list._items);
                  editingController.clear();
                }
              },
              controller: editingController,
            )),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                if (editingController.text == '') {
                } else {
                  _insert(editingController.text);
                  widget.callback(_list._items);
                  editingController.clear();
                }
                //editingController.text = '';
              },
              color: widget.taskColor,
            ),
          ],
        ),
      );
    return CardItem(
      color: widget.taskColor,
      animation: animation,
      name: _list[index]['name'],
      index: index,
      remove: _remove,
      callback: (value) {
        _list._items[index]['isCompleted'] = value;
      },
    );
  }

  // Used to build an item after it has been removed from the list. This method is
  // needed because a removed item remains  visible until its animation has
  // completed (even though it's gone as far this ListModel is concerned).
  // The widget will be used by the [AnimatedListState.removeItem] method's
  // [AnimatedListRemovedItemBuilder] parameter.
  Widget _buildRemovedItem(BuildContext context, Animation<double> animation) {
    return CardItem(
      animation: animation,
      color: Colors.red,
      // No gesture detector here: we don't want removed items to be interactive.
    );
  }

  // Insert the "next item" into the list model.
  void _insert(String name) {
    _list.insert(_list.length, {'name': name, 'isCompleted': false});
  }

  // Remove the selected item from the list model.
  void _remove(int index) {
    _list.removeAt(index);
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
          border: Border.all(color: widget.taskColor),
          borderRadius: BorderRadius.circular(5)),
      child: AnimatedList(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        key: _listKey,
        initialItemCount: _list.length + 1,
        itemBuilder: _buildItem,
      ),
    );
  }
}

/// Keeps a Dart List in sync with an AnimatedList.
///
/// The [insert] and [removeAt] methods apply to both the internal list and the
/// animated list that belongs to [listKey].
///
/// This class only exposes as much of the Dart List API as is needed by the
/// sample app. More list methods are easily added, however methods that mutate the
/// list must make the same changes to the animated list in terms of
/// [AnimatedListState.insertItem] and [AnimatedList.removeItem].
class ListModel<E> {
  ListModel({
    @required this.listKey,
    @required this.removedItemBuilder,
    Iterable<E> initialItems,
  })  : assert(listKey != null),
        assert(removedItemBuilder != null),
        _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final dynamic removedItemBuilder;
  final List<E> _items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(index,
          (BuildContext context, Animation<double> animation) {
        return Container();
      });
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

/// Displays its integer item as 'item N' on a Card whose color is based on
/// the item's value. The text is displayed in bright green if selected is true.
/// This widget's height is based on the animation parameter, it varies
/// from 0 to 128 as the animation varies from 0.0 to 1.0.
class CardItem extends StatefulWidget {
  final Animation<double> animation;
  final String name;
  final Color color;
  final Function remove;
  final int index;
  final Function(bool) callback;

  CardItem(
      {Key key,
      this.animation,
      this.name,
      this.color,
      this.remove,
      this.index,
      this.callback})
      : super(key: key);

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    ValueChanged<bool> onValue =
        (bool newvalue) => setState(() => value = newvalue);
    widget.callback(value);
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: widget.animation,
      child: SizedBox(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: Checkbox(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: widget.color,
            value: value,
            onChanged: (newValue) {
              setState(() {
                onValue(newValue);
              });
            },
          ),
          trailing: IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: () {
                widget.remove(widget.index);
              }),
          title: Text(
            widget.name,
            maxLines: 1,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
