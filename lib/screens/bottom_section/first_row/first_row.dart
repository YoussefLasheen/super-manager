import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermanager/models/user.dart';
import 'package:supermanager/screens/bottom_section/first_row/progress_indicator_card.dart';

class FirstRow extends StatelessWidget {
  const FirstRow({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (_, userData, __) => ListView.separated(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (BuildContext context, int index) => Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  offset: Offset(3, 4),
                  blurRadius: 6.0,
                  spreadRadius: 0.3)
            ],
          ),
          child: VerticalDivider(
            color: Colors.black12,
            width: 1,
            endIndent: 5,
            indent: 5,
          ),
        ),
        itemCount: userData.rating.length,
        itemBuilder: (context, index) => _buildCircularProgressIndicatorCard(
            context, userData.rating[index]),
      ),
    );
  }
}

_buildCircularProgressIndicatorCard(BuildContext context, Map rating) {
  return Container(
    width: (MediaQuery.of(context).size.width * .5),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Colors.transparent, Colors.transparent],
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: CircularProgressIndicatorCard(
        rating['name'],
        rating['rating'],
      ),
    ),
  );
}
