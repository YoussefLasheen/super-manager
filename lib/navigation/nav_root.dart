import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:supermanager/models/user.dart';
import 'package:supermanager/navigation/flurry_navigation.dart';
import 'package:supermanager/screens/auth_screen/login_page.dart';
import 'package:supermanager/screens/bottom_section/bottom_section.dart';
import 'package:supermanager/screens/chat_screen/chat_screen.dart';
import 'package:supermanager/screens/dummy_screen.dart';
import 'package:supermanager/screens/slide_up_screen/profile_page.dart';
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
                toggleslidingtomatchmenu();
              },
            ),
            createSlidingUpPanel(context),
          ],
        ),
      ),
    );
  }

  createSlidingUpPanel(BuildContext context) {
    return SlidingUpPanel(
      defaultPanelState: PanelState.OPEN,
      color: Color.fromRGBO(121, 134, 203, 1),
      isDraggable: false,
      backdropTapClosesPanel: false,
      minHeight: MediaQuery.of(context).size.height * 1 / 20,
      maxHeight: MediaQuery.of(context).size.height,
      controller: pc,
      collapsed: FlatButton(
        onPressed: () => togglesliding(),
        child: Consumer<User>(
          builder: (_, userData, __) => Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Hi " +
                  userData.personalInfo['displayName'] +
                  " You're logged in",
            ),
          ),
        ),
      ),
      panel: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 1 / 20,
          ),
          child: Profile(
            pc: pc,
          )),
    );
  }

  togglesliding() {
    if (pc.isPanelClosed()) {
      pc.animatePanelToPosition(0.265);
    } else if (pc.getPanelPosition() == 0.265) {
      pc.close();
    }
  }

  toggleslidingtomatchmenu() {
    if (menuState) {
      pc.show();
    } else {
      pc.hide();
    }
  }
}
