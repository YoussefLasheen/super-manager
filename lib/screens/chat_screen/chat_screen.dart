//import 'package:chat_app/controllers/chats_controller.dart';
//import 'package:chat_app/controllers/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supermanager/screens/chat_screen/components/chat_input_widget.dart';
import 'package:supermanager/screens/chat_screen/components/chat_widget.dart';
import 'package:supermanager/services/api.dart';

class ChatScreen extends StatefulWidget {
final String otherEndId;
ChatScreen(this.otherEndId);
  @override
  State createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController scrollController = ScrollController();
  final GlobalKey _key = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isHeader = true;
  bool exists;

//  FirebaseUser _user;
//  String _uniqueChatid;

  @override
  void initState() {
    super.initState();
    initUser();
  }
  @override
  void didUpdateWidget(ChatScreen oldWidget) {
    initUser();
    super.didUpdateWidget(oldWidget);
  }
  void initUser() async {
    if (mounted) {
      setState(() => 0);
    }
    /*
    await Auth().getCurrentUser().then((user) {
      setState(() {
        _user = user;
        _uniqueChatid = _user.uid.compareTo(widget.otherEndId)<=-1?_user.uid+'_to_'+widget.otherEndId:widget.otherEndId+'_to_'+_user.uid;
    });
    });
    */
  }

  @override
  Widget build(BuildContext context) {
    var isMenuOpen = Provider.of<bool>(context);
    var _user = Provider.of<FirebaseUser>(context, listen: false);
    var _uniqueChatid = _user.uid.compareTo(widget.otherEndId)<=-1?_user.uid+'_to_'+widget.otherEndId:widget.otherEndId+'_to_'+_user.uid;
    return Scaffold(
      resizeToAvoidBottomInset: !isMenuOpen,
      key: _scaffoldKey,
      body:Column(
              children: <Widget>[
                Flexible(child: buildChats(_user,_uniqueChatid)),
                ChatInputWidget(
                  otherEndId: widget.otherEndId,
                  onSubmitted: (val) {
                    //ChatsController.sendMessage(chat);
                    Map chat = {
                      'content':val,
                      'sender' :_user.uid,
                      'date' : DateTime.now()
                      };
                    
                    setState(() {
                      Api('chats').sendMessage(chat, _uniqueChatid);
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeIn);
                    });
                  },
                )
              ],
            ),
    );
  }

  Widget buildHeader(String _otherEndId) {
    return FutureBuilder<DocumentSnapshot>(
      future: Api('users').getDocumentById(_otherEndId),
      builder: (context, snapshot) {
        return Container(
          key: _key,
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(snapshot.hasData?snapshot.data['personalInfo']['displayName']:"Loading",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                ),
              ),
              CircleAvatar(
                backgroundImage: NetworkImage("https://cdn1.iconfinder.com/data/icons/user-pictures/100/unknown-32.png"),
                radius: 60.0,
                ),
              ChatWidget(
                chat: {'content':'This is the begining of the chat'},
                isReceived: null,
              )
            ],
          ),
        );
      }
    );
  }

  Widget buildChats(FirebaseUser _user,String _uniqueChatid) {
    return StreamBuilder(
        stream: Firestore.instance.collection('chats').document(_uniqueChatid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List chats = snapshot.data['messages'];
          return ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) {
              if (index == 0) {
                return buildHeader(widget.otherEndId);
              }
              return ChatWidget(
                chat: chats[index - 1],
                isReceived:chats[index - 1]['sender'] == 'SYSTEM'?null: _user.uid != chats[index - 1]['sender'],
              );
            },
            itemCount: chats.length + 1,
          );
        });
  }
  @override
  void dispose() {
    super.dispose();
  }
}
