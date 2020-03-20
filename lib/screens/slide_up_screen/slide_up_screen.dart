import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:supermanager/models/user.dart';
import 'package:supermanager/screens/slide_up_screen/profile_page.dart';

createSlidingUpPanel(BuildContext context, PanelController pc) {
  return SlidingUpPanel(
    defaultPanelState: PanelState.OPEN,
    color: Color.fromRGBO(121, 134, 203, 1),
    isDraggable: false,
    backdropTapClosesPanel: false,
    minHeight: MediaQuery.of(context).size.height * 1 / 20,
    maxHeight: MediaQuery.of(context).size.height,
    controller: pc,
    collapsed: FlatButton(
      onPressed: () => togglesliding(pc),
      child: Consumer<User>(
        builder: (_, userData, __) => Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Text(
                "Hi " + userData.personalInfo['displayName'] + " You're logged in",
              ),
              Spacer(),
              //IconButton(icon: Icon(Icons.person),onPressed: (){pc.open();},)
            ],
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
      ),
    ),
  );
}

togglesliding(PanelController pc) {
  if (pc.isPanelClosed) {
    pc.animatePanelToPosition(0.265);
  } else if (pc.panelPosition == 0.265) {
    pc.close();
  }
}

toggleslidingtomatchmenu(PanelController pc, bool menuState) {
  if (pc.isAttached) {
    if (menuState) {
      pc.show();
    } else {
      pc.hide();
    }
  }
}
