import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
class Api{
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;

  Api( this.path ) {
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.getDocuments() ;
  }
  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots() ;
  }
  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }
  Future<void> removeDocument(String id){
    return ref.document(id).delete();
  }
  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }
  Future<void> updateDocument(Map data , String id) {
    return ref.document(id).updateData(data) ;
  }

 Future<bool> sendMessage(Map chat , String id)async{
    try{
      ref.document(id).setData({'messages':FieldValue.arrayUnion([chat])},merge: true)
      .whenComplete(() {return true;}).catchError((e) => throw(e));
    }
    catch(e){
      return false;
    }
    return true;
  }
}