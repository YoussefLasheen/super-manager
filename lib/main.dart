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
  Widget activeScreen = DummyPage();
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
        menuScreen: Material(
          color: Color.fromRGBO(121, 134, 203, 1),
          child: Column(
            children: <Widget>[
              Spacer(flex: 22,),
              Expanded(
                flex: 10,
                child: BottomSection(
                onChatSelected: (String otherEndId){
                  setState(() {
                  activeScreen = ChatScreen(otherEndId);
                  });
                },
            ),
              ),
            Spacer(flex: 1,)
            ],
          ),
        )
    );
  }
}
