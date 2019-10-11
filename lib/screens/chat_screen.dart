//import 'package:chat_app/controllers/chats_controller.dart';
//import 'package:chat_app/controllers/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:supermanager/api.dart';

import '../authentication.dart';
import '../chat_input_widget.dart';
import '../chat_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    var _user = Provider.of<FirebaseUser>(context, listen: false);
    var _uniqueChatid = _user.uid.compareTo(widget.otherEndId)<=-1?_user.uid+'_to_'+widget.otherEndId:widget.otherEndId+'_to_'+_user.uid;
    return Scaffold(
      key: _scaffoldKey,
      body:Column(
              children: <Widget>[
                Flexible(child: buildChats(_user,_uniqueChatid)),
                ChatInputWidget(
                  onSubmitted: (val) {
                    //ChatsController.sendMessage(chat);
                    Map chat = {
                      'content':val,
                      'sender' :_user.uid,
                      'date' : DateTime.now()
                      };
                    
                    setState(() async {
                      await Api('chats').sendMessage(chat, _uniqueChatid);
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

  Widget buildHeader(FirebaseUser _user) {
    return Container(
      key: _key,
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(_user.displayName==null|| _user.displayName == ""?"Unamed User":_user.displayName,
              //widget.friend.displayName,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
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
                return buildHeader(_user);
              }
              return ChatWidget(
                chat: chats[index - 1],
                isReceived: _user.uid != chats[index - 1]['sender'],
                showUser: false,
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
