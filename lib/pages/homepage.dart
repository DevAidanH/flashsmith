import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashsmith/components/buttons.dart';
import 'package:flashsmith/pages/generateflow.dart';
import 'package:flashsmith/pages/reviewflow.dart';
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

  String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance.collection("Users").doc(currentUser!.uid).get();
  }

  void logout(){
    FirebaseAuth.instance.signOut();
  }

  void goToGen(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Generateflow(uid: uid,)));
  }

  void goToReview(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Reviewflow(uid: uid,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
        automaticallyImplyLeading: false, 
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
            return Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Welcome ${user?["username"]}"),
                  const SizedBox(height: 25),
                  Buttons(text: "Generate Cards", onTap: goToGen),
                  const SizedBox(height: 25),
                  Buttons(text: "Review Cards", onTap: goToReview)
                ],
              ),
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