import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermanager/api.dart';
import 'package:supermanager/widgets/add_task_card.dart';
import 'package:supermanager/widgets/task_card.dart';

import 'models/task.dart';
import 'models/user.dart';
import 'widgets/gesture_card.dart';

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
                  StreamBuilder<DocumentSnapshot>(
                    stream: Firestore.instance.collection('users')
                    .document(user.uid)
                    .collection('Data')
                    .document('Data')
                    .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return LinearProgressIndicator();
                      return PageView.builder(
                        controller: PageController(initialPage: 0, viewportFraction: 0.95),
                        itemBuilder: (BuildContext context, int index) {
                          //String key = snapshot.data['Tasks'].keys.elementAt(index);
                          var keys = snapshot.data['Tasks'].keys.toList();
                          if (index == snapshot.data['Tasks'].length)
                            return AddPageCard(color: Colors.blueGrey,userUID: user.uid,);
                            var val = snapshot.data['Tasks'][keys[index]];
                            return TaskCard(
                            task: Task(val['title'] ,desc: val['desc'],codePoint: val['codePoint'],color: val['isCompleted']?0x42000000:val['color'],dueDate: val['dueDate']?.toDate(),id: keys[index],isCompleted: val['isCompleted']),
                            todos: val['todos'],
                            taskCompletionPercent: val['todos'].length == 0
                            ? 0
                            : 100-
                            ((val['todos'].where((user) => user['isCompleted'] == false).length /
                             val['todos'].length)
                             *100)
                             .toInt(),
                            totalTodos: val['todos'].length,
                          );
                          
                        },
                        itemCount: snapshot.data['Tasks'].length +1,
                      );
                    }
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
                              return _buildNotificationCard(context, snapshot.data.documents[index].data,widget.onChatSelected, userData);
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

_buildNotificationCard (BuildContext context ,Map otherEnd ,Function onChatSelected ,User currentUser){
  String path = currentUser.userUID.compareTo(otherEnd['userUID'])<=-1?currentUser.userUID+'_to_'+otherEnd['userUID']:otherEnd['userUID']+'_to_'+currentUser.userUID;
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('chats').document(path).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List chats;
        try{
          chats = snapshot.data['messages'];
          }on NoSuchMethodError {
            Firestore.instance.collection('chats').document(path).setData({'messages':[]});
            return Center(
              child: CircularProgressIndicator(),
              );
          }
        return SizedBox(
          width:MediaQuery.of(context).size.width/3,
            child: GestureCard(
              currentUser: currentUser,
              otherEnd: otherEnd,
              chats: chats,
              onChatSelected: onChatSelected,
          ),
        );
      }
    );
}