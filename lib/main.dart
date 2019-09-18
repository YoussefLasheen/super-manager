import 'package:flutter/material.dart';
import 'package:flurry_navigation/flurry_navigation.dart';
import 'package:flurry_navigation/flurry_menu.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:supermanagerandroidx/screens/dummy_screen.dart';
import 'package:supermanagerandroidx/bottom_section.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Decalre active screen var with the the default screen somewhere accesible to the contentScreen attributes
  var activeScreen = dummy_screen;
  Widget build(BuildContext context) {
    return FlurryNavigation(
        // The curve of the screen (Double)
        curveRadius: (MediaQuery.of(context).size.width *
                MediaQuery.of(context).size.height) /
            4980,
        // The Icon data of the icon the BottomLeft
        expandIcon: Image.asset("assets/expan1.png"),
        // The size of the icon on the BottomLeft (Double)
        iconSize: ((MediaQuery.of(context).size.width *
                MediaQuery.of(context).size.height) /
            15420),
        // The content of the screen
        contentScreen: activeScreen,
        menuScreen: new FlurryMenu(
          bgColor: Color.fromRGBO(121, 134, 203, 1),
          // The content of the bottom sction of the menu screen
          bottomSection:
              BottomSection(), //BottomSection() Class is an example of what you can use
          menu: new SideMenu(
            items: [
              new SideMenuItem(
                  id:
                      'hom', //You can set this to whatever you want but dont duplicate it
                  icon:
                      'assets/home_black.png', //Set this to the data for the icon of the button
                  isSelected: true,
                  selectedBtnColor: Color.fromRGBO(38, 198, 218, 1),
                  btnShape: BoxShape.circle,
                  selectedShadowColor: Colors.transparent),
            ],
          ),
          onMenuItemSelected: (String itemId) {
            if (itemId == 'hom') {
              setState(() => activeScreen = dummy_screen);
            }
          },
        ),
    );
  }
}
