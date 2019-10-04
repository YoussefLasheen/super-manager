import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'authentication.dart';

class NotificationCard extends StatelessWidget {
final String messageText;
final String senderName;
final IconData notificationIcon;

  const NotificationCard(
    this.messageText, this.senderName, this.notificationIcon
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
                          "2 hours ago",
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
                  messageText,
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
  BottomSection({Key key,})
      : super(key: key);

  @override
  _BottomSectionState createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> {
  String _userId = "";
  @override
  void initState() {
    super.initState();
    Auth().getCurrentUser().then((user) {
      setState(() {
          _userId = user?.uid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
 return _userId == ""?  CircularProgressIndicator(): buildPageView(context, _userId);
}
  buildPageView(BuildContext context, String userId) {
    return Container(
            child: PageView(
              physics: BouncingScrollPhysics(),
              pageSnapping: true,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                  StreamBuilder<DocumentSnapshot>(
                    stream: Firestore.instance.collection('users').document(userId).snapshots(),
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
                    stream: Firestore.instance.collection('users').where('role',isGreaterThanOrEqualTo: 2).snapshots(),
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
                          itemBuilder: (context, index) => _buildNotificationCard(context, snapshot.data.documents[index].data),
                          );
                    }
                  )
              ],
            ),
            
  );
  }
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

_buildNotificationCard (BuildContext context ,Map notifiaction){
    return Container(
      width: (MediaQuery.of(context).size.width * 0.4),
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child:NotificationCard(notifiaction['personalInfo']['name'],notifiaction['personalInfo']['name'],Icons.notifications)
      ),
    );
}