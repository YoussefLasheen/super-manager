import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String userUID;
  String department;
  Map personalInfo;
  List rating;
  int role;
  User({ 
    this.userUID,
    this.department,
    this.personalInfo,
    this.rating,
    this.role
    });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    
    return User(
      userUID: doc.documentID,
      personalInfo: doc['personalInfo'],
      rating: doc['rating'],
      department: doc['department'],
      role: doc['role']
    );
  }

}