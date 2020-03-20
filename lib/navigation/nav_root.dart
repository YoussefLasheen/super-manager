import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:supermanager/models/user.dart';
import 'package:supermanager/navigation/flurry_navigation.dart';
import 'package:supermanager/screens/bottom_section/bottom_section.dart';
import 'package:supermanager/screens/chat_screen/chat_screen.dart';
import 'package:supermanager/screens/dummy_screen.dart';
import 'package:supermanager/screens/slide_up_screen/slide_up_screen.dart';
import 'package:supermanager/services/api.dart';

class NavigationRoot extends StatefulWidget {
  const NavigationRoot({Key key}) : super(key: key);

  @override
  _NavigationRootState createState() => _NavigationRootState();
}

class _NavigationRootState extends State<NavigationRoot> {
  PanelController pc;
  Widget activeScreen = DummyPage();
  bool menuState = false;
  @override
  void initState() {
    super.initState();
    pc = new PanelController();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return Provider<bool>.value(
      value: menuState,
      child: StreamProvider<User>.value(
        initialData: User(
            department: "Loading...",
            role: 0,
            rating: [],
            personalInfo: {'displayName': 'not Signed In'}),
        value: Api('users').streamUserCollection(user.uid),
        child: Stack(
          children: [
            Material(
              color: Color.fromRGBO(121, 134, 203, 1),
              child: Column(
                children: <Widget>[
                  Spacer(
                    flex: 13,
                  ),
                  Expanded(
                    flex: 5,
                    child: BottomSection(
                      onChatSelected: (String otherEndId) {
                        setState(() {
                          activeScreen = ChatScreen(otherEndId);
                        });
                      },
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  )
                ],
              ),
            ),
            FlurryNavigation(
              contentScreen: activeScreen,
              menuState: (bool state) {
                menuState = state;
                toggleslidingtomatchmenu(pc, menuState);
              },
            ),
            createSlidingUpPanel(context, pc),
          ],
        ),
      ),
    );
  }
}
