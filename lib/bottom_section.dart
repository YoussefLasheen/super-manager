import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermanager/api.dart';

import 'models/user.dart';

class NotificationCard extends StatelessWidget {
final Map message;
final String senderName;
final IconData notificationIcon;

  const NotificationCard(
    this.message, this.senderName, this.notificationIcon
      );
  @override
  Widget build(BuildContext context) {
    return Column(
          children: <Widget>[
              Expanded(
                flex: 1,
               child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: FittedBox(
                        child: Icon(
                            notificationIcon,
                            color: Colors.white,
                            ),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 3,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          message['date']==null?"Never Texted you":
                          DateTime.now().difference(message['date'].toDate()).inMinutes.toString()+" minutes ago",
                          style: TextStyle(color: Colors.white,),
                          ),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              flex: 2,
              child: 
                FittedBox(
                 child: Text(
                  "$senderName Messaged You",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
                ),
            ),
            Expanded(
              flex: 3,
                child: Text(
                  message['content'],
                  overflow: TextOverflow.fade,
                  maxLines: 3,
                  style: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: 40),
                ),
            ),
          ],
    );
  }
}

class CircularProgressIndicatorCard extends StatelessWidget {
  final String name;
  final int rating;
  const CircularProgressIndicatorCard(
    this.name,
    this.rating, 
      );
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1.0,
          child: Stack(
            children: <Widget>[
              Container(
                height: double.maxFinite,
                width: double.maxFinite,
                child:CircularProgressIndicator(value: rating/100,valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),),),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Spacer(flex:3),
                    Expanded(
                      flex: 4,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text("$rating%",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Source Sans Pro',
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child:FittedBox(
                        fit: BoxFit.contain,
                        child: Text(name,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style:TextStyle(fontFamily: 'Source Sans Pro',
                      color: Colors.white,
                      fontWeight: FontWeight.w400),),
                    ),),
                    Spacer(flex:4,)
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}

class BottomSection extends StatefulWidget {
  final Function(String) onChatSelected;
  BottomSection({this.onChatSelected});

  @override
  _BottomSectionState createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> {
  /*
  //String _userId = "";
  String _userDepartment;
  int _userRole;
  @override
  void initState() {
    super.initState();
    Auth().getCurrentUser().then((user) {
      setState(() {
          _userId = user?.uid;
      });
    
    Api('users').getDocumentById(_userId).then((doc){
      setState(() {
       _userRole = doc.data['role'];
       _userDepartment = doc.data['department'];
      });
    });
    });
  }
*/
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    /*
    Api('users').getDocumentById(user.uid).then((doc){
      setState(() {
       _userRole = doc.data['role'];
       _userDepartment = doc.data['department'];
      });
    });
    */
 return Container(
            child: PageView(
              physics: BouncingScrollPhysics(),
              pageSnapping: true,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                  Consumer<User>(
                    builder: (_, userData,__) =>
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
                          itemCount: userData.rating.length,
                          itemBuilder: (context, index) => _buildCircularProgressIndicatorCard(context, userData.rating[index]),
                          )
                  ),
                  Consumer<User>(
                    builder: (_,userData,__)=>
                    StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection('users')
                      .where('role',isGreaterThanOrEqualTo: userData.role)
                      .where('department',isEqualTo: userData.department)
                      .snapshots(),
                      builder: (context, snapshot) {
                         if (!snapshot.hasData) return LinearProgressIndicator();
                        return ListView.separated(
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
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              if (snapshot.data.documents[index].data['userUID'] == user.uid) return Container();
                              return _buildNotificationCard(context, snapshot.data.documents[index].data,widget.onChatSelected);
                              }
                            );
                      }
                    ),
                  )
              ],
            ),
            
  );
 /*_userId == "" ||_userId == null ?  CircularProgressIndicator(): buildPageView(context/*, _userId*/);*/
}
/*
  buildPageView(BuildContext context/*, String userId*/) {
    return Container(
            child: PageView(
              physics: BouncingScrollPhysics(),
              pageSnapping: true,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                  StreamBuilder<DocumentSnapshot>(
                    stream: Firestore.instance.collection('users').document(user.uid).snapshots(),
                    builder: (context, snapshot) {
                       if (!snapshot.hasData) return LinearProgressIndicator();
                      return ListView.separated(
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
                          itemCount: snapshot.data['rating'].length,
                          itemBuilder: (context, index) => _buildCircularProgressIndicatorCard(context, snapshot.data['rating'][index]),
                          );
                    }
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('users')
                    .where('role',isGreaterThanOrEqualTo: _userRole)
                    .where('department',isEqualTo: _userDepartment)
                    .snapshots(),
                    builder: (context, snapshot) {
                       if (!snapshot.hasData) return LinearProgressIndicator();
                      return ListView.separated(
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
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            //if (snapshot.data.documents[index].data['userUID'] == userId) return null;
                            return _buildNotificationCard(context, snapshot.data.documents[index].data,widget.onChatSelected);
                            }
                          );
                    }
                  )
              ],
            ),
            
  );
  }
*/
}

_buildCircularProgressIndicatorCard (BuildContext context ,Map rating){
    return Container(
      width: (MediaQuery.of(context).size.width * .5),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.transparent,Colors.transparent])),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CircularProgressIndicatorCard(rating['name'],rating['rating'])
      ),
    );
}

_buildNotificationCard (BuildContext context ,Map notifiaction ,Function onChatSelected){
    return Consumer<FirebaseUser>(
                    builder: (_, _user,__) =>
    StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('chats').document(_user.uid.compareTo(notifiaction['userUID'])<=-1?_user.uid+'_to_'+notifiaction['userUID']:notifiaction['userUID']+'_to_'+_user.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List chats;
        try{
          chats = snapshot.data['messages'];
          }on NoSuchMethodError catch(e){
            print(e);
            Firestore.instance.collection('chats').document(_user.uid.compareTo(notifiaction['userUID'])<=-1?_user.uid+'_to_'+notifiaction['userUID']:notifiaction['userUID']+'_to_'+_user.uid).setData({'messages':[]});
            return Center(
              child: CircularProgressIndicator(),
              );
          }
        return InkWell(
          onTap:() => onChatSelected(notifiaction['userUID']),
              child: Container(
            width: (MediaQuery.of(context).size.width * 0.4),
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:NotificationCard(chats.lastWhere((element) => element['sender'] == notifiaction['userUID'],orElse: () => {'content':"No Recent messages",'date':null,'sender':'noone'}),notifiaction['personalInfo']['displayName'],Icons.notifications)
            ),
          ),
        );
      }
    )
    );
}