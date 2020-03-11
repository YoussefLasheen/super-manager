import 'package:flutter/material.dart';

class IconPicker extends StatefulWidget {
  final ValueChanged<IconData> onIconChanged;
  final IconData currentIconData;
  final Color highlightColor, unHighlightColor;

  final List<IconData> icons = [
    Icons.notifications,
    Icons.notifications_active,
    Icons.notification_important,
    Icons.hotel,
    Icons.book,
    Icons.phone,
    Icons.next_week,
    Icons.work,
    Icons.traffic,
    Icons.airplanemode_active,
    Icons.favorite,

  ];

  IconPicker({
    @required this.currentIconData,
    @required this.onIconChanged,
    Color highlightColor,
    Color unHighlightColor,
  })  : this.highlightColor = highlightColor ?? Colors.red,
        this.unHighlightColor = unHighlightColor ?? Colors.blueGrey;

  @override
  State<StatefulWidget> createState() {
    return _IconPickerState();
  }
}

class _IconPickerState extends State<IconPicker> {
  IconData selectedIconData;

  @override
  void initState() {
    selectedIconData = widget.currentIconData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      width: orientation == Orientation.portrait ? 300.0 : 300.0,
      height: orientation == Orientation.portrait ? 360.0 : 200.0,
      child: GridView.builder(
        itemBuilder: (BuildContext context, int index) {
          var iconData = widget.icons[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedIconData = iconData;
                });
                widget.onIconChanged(iconData);
              },
              borderRadius: BorderRadius.circular(50.0),
              child: Icon(iconData,color: iconData == selectedIconData?widget.unHighlightColor:widget.highlightColor,)
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: orientation == Orientation.portrait ? 4 : 6,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 1.0,
        ),
        itemCount: widget.icons.length,
      ),
    );
  }
}
