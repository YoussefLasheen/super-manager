import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'login_page.dart';
import 'authentication.dart';
import 'profile_page.dart';














var cardsList = [
  [
    ItemCard(0.5,Colors.transparent,Colors.transparent,CircularProgressIndicator(value: .75,)),
    ItemCard(0.5,Colors.transparent,Colors.transparent,CircularProgressIndicator(value: .75,)),

  ],
  [
    ItemCard(0.2,Colors.transparent,Colors.transparent,Text("Adham")),
    ItemCard(0.2,Colors.transparent,Colors.transparent,Text("Adham")),
    ItemCard(0.2,Colors.transparent,Colors.transparent,Text("Adham")),
    ItemCard(0.2,Colors.transparent,Colors.transparent,Text("Adham")),
    ItemCard(0.2,Colors.transparent,Colors.transparent,Text("Adham")),
    
  ]
];

class BottomSection extends StatefulWidget {
  BottomSection({Key key,})
      : super(key: key);

  @override
  _BottomSectionState createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
              height: (MediaQuery.of(context).size.height * 0.02),
              child: PageView(
                physics: BouncingScrollPhysics(),
                pageSnapping: true,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  for (var i = 0; i < cardsList.length; ++i)
                    ListView.separated(
                      physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (BuildContext context, int index) =>
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                offset: Offset(3, 4),
                                blurRadius: 6.0,
                                spreadRadius: 0.3
                                )]),
                            child:VerticalDivider(
                              color: Colors.black12,
                              width: 1,
                              endIndent: 5,
                              indent: 5,
                            ),),
                        itemCount: cardsList[i].length,
                        itemBuilder: (context, index) => cardsList[i][index],
                        )
                ],
              ),
              
    );
}
}
class ItemCard extends StatelessWidget {
  final content;
  final color1;
  final color2;
  final widthRatio;
  const ItemCard(
      this.widthRatio, this.color1, this.color2, this.content);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width * widthRatio),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [color1, color2])),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: content,
      ),
    );
}
}