import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
  //Get database ref
  final CollectionReference cards = FirebaseFirestore.instance.collection("cards");

  //Create
  Future<void> addCard(String front, String back){
    return cards.add({
      "front": front,
      "back": back
    });
  }

  //Read
  Stream<QuerySnapshot> getCardsStream(){
    final cardsStream = cards.snapshots();

    return cardsStream;
  }

  //Update
  Future<void> updateCard(String DocId, String newFront, String newBack){
    return cards.doc(DocId).update({
      "front": newFront,
      "back": newBack
    });
  }

  //Delete
  Future<void> deleteCard(String docId){
    return cards.doc(docId).delete();
  }
}