import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashsmith/services/firestore.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirestoreService firestoreService = FirestoreService();

  final frontTextController = TextEditingController();
  final backTextController = TextEditingController();

  //Get current logged in user
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance.collection("Users").doc(currentUser!.uid).get();
  }
  
  //Old add card fucntion
  /*void addManualCard([docId]){
    showDialog(context: context, builder: (context) => AlertDialog(
      content: Column(
        children: [
          TextField(controller: frontTextController,),
          TextField(controller: backTextController,)
        ],
      ),
      actions: [
        ElevatedButton(onPressed: (){
            if(docId == null){
              firestoreService.addCard(frontTextController.text, backTextController.text);
            }else{
              firestoreService.updateCard(docId, frontTextController.text, backTextController.text);
            }
            frontTextController.clear();
            backTextController.clear();
            Navigator.pop(context);
            
          }, 
          child: Text("Save"),)
      ],
    ));
  }*/

  void logout(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
        actions: [
          IconButton(onPressed: () => logout(), icon: Icon(Icons.logout))
        ],
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(), 
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(snapshot.hasError){
            return Text("Error: ${snapshot.error}");
          }
          else if(snapshot.hasData){
            Map<String, dynamic>? user = snapshot.data!.data();
            return Column(
              children: [
                Text("Welcome ${user!["username"]}")
              ],
            );
          }
          else{
            return Text("No data");
          }
        }
      )
    );
  }
}