import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:supermanager/screens/administration_screen.dart';
import 'package:supermanager/screens/chat_screen.dart';
import 'api.dart';
import 'flurry_navigation.dart';
import 'flurry_menu.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:supermanager/screens/dummy_screen.dart';
import 'package:supermanager/bottom_section.dart';
import 'package:flutter/services.dart';

import 'models/user.dart';

void main() {
  //Provider.debugCheckInvalidValueType = null;
  runApp(new MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
        // Make user stream available
      return MultiProvider(
      providers: [
        // Make user stream available
        StreamProvider<FirebaseUser>.value(value: FirebaseAuth.instance.onAuthStateChanged),
        // See implementation details in next sections
        /*
        ProxyProvider<FirebaseUser, StreamProvider>(
          builder: (_,user,streamProvider) =>
          StreamProvider.value(value:Api('users').streamUserCollection(user.uid)))
      */
      ],
        child: MaterialApp(
          home: MyHomePage(),
          ),
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
          bottomSection: BottomSection(
            onChatSelected: (String otherEndId){
              setState(() {
              activeScreen =
               Screen(
                contentBuilder: (BuildContext context) {
                  return ChatScreen(otherEndId);
                  },
                ); 
              });
            },
          ), //BottomSection() Class is an example of what you can use
          menu: new SideMenu(
            items: [
              new SideMenuItem(
                  id:
                      'hom', //You can set this to whatever you want but dont duplicate it
                  icon:
                      'assets/home_white.png', //Set this to the data for the icon of the button
                  isSelected: true,
                  selectedBtnColor: Color.fromRGBO(38, 198, 218, 1),
                  btnShape: BoxShape.circle,
                  selectedShadowColor: Colors.transparent),
              new SideMenuItem(
                  id:
                      'hom', //You can set this to whatever you want but dont duplicate it
                  icon:
                      'assets/sta.png', //Set this to the data for the icon of the button
                  isSelected: false,
                  selectedBtnColor: Color.fromRGBO(38, 198, 218, 1),
                  btnShape: BoxShape.circle,
                  selectedShadowColor: Colors.transparent),
              new SideMenuItem(
                  id:
                      'hom', //You can set this to whatever you want but dont duplicate it
                  icon:
                      'assets/loc.png', //Set this to the data for the icon of the button
                  isSelected: false,
                  selectedBtnColor: Color.fromRGBO(38, 198, 218, 1),
                  btnShape: BoxShape.circle,
                  selectedShadowColor: Colors.transparent),
              new SideMenuItem(
                  id:
                      'hom', //You can set this to whatever you want but dont duplicate it
                  icon:
                      'assets/set.png', //Set this to the data for the icon of the button
                  isSelected: false,
                  selectedBtnColor: Color.fromRGBO(38, 198, 218, 1),
                  btnShape: BoxShape.circle,
                  selectedShadowColor: Colors.transparent),
              new SideMenuItem(
                  id:
                      'admin', //You can set this to whatever you want but dont duplicate it
                  icon:
                      'assets/flutter-icon.png', //Set this to the data for the icon of the button
                  isSelected: false,
                  selectedBtnColor: Color.fromRGBO(38, 198, 218, 1),
                  btnShape: BoxShape.circle,
                  selectedShadowColor: Colors.transparent),
            ],
          ),
          onMenuItemSelected: (String itemId) {
            if (itemId == 'hom') {
              setState(() => activeScreen = dummy_screen);
            }else if(itemId == 'admin'){
              setState(() => activeScreen = administration_screen);
            }
          },
        ),
    );
  }
}
