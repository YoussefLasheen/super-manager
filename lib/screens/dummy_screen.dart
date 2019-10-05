import 'package:flutter/material.dart';
import 'package:supermanager/screens/chat_screen.dart';
import '../flurry_navigation.dart';

final Screen dummy_screen = new Screen(
    contentBuilder: (BuildContext context) {
      return ChatScreen("joe");
    }
);