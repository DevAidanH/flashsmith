import 'package:flashsmith/components/buttons.dart';
import 'package:flashsmith/helper/generateFlashCard.dart';
import 'package:flashsmith/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flashsmith/services/firestore.dart';


// ignore: must_be_immutable
class Generateflow extends StatefulWidget {
  String uid;
  Generateflow({required this.uid, super.key});
  

  @override
  State<Generateflow> createState() => _GenerateflowState();
}

class _GenerateflowState extends State<Generateflow> {
  final FirestoreService firestoreService = FirestoreService();
  final PageController _pageController = PageController();
  List flashcards = [];

  //Generate flashcards
  Future<void> callGenrateScriptandChangePage() async {
    _pageController.jumpToPage(1);
    flashcards = await generateFlashCards();
    _pageController.jumpToPage(2);
  }

  //Save cards to Firebase. 
  void saveFlashcards(String uid){
    for(int i = 0; i < flashcards.length; i++){
      firestoreService.addGeneratedCard(uid, flashcards[i]);
    }
    showDialog(context: context, builder: (context) => AlertDialog(
    content: Text("Your new flashcards have been saved"), actions: [
      MaterialButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));}, child: Text("Return home"),)
    ],));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(), 
        children: [
          //Page 0 - Displayed when user navigates to the page
          Container(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Please upload a PDF by clicking the button below. \n Our AI will then generate a series of flashcards based on the content", textAlign: TextAlign.center),
                  const SizedBox(height: 25),
                  Buttons(text: "Click here to upload", onTap: callGenrateScriptandChangePage)
                ],
              ),
            ),
          ),
          //Page 1 - Displayed when loading the flashcards
          Container(
            child: Center(
              child: CircularProgressIndicator()
            ),
          ),
          //Page 2 - Displayed once flashcards are created
          Container(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Your new flashcards have been generated"),
                  const SizedBox(height: 25),
                  Buttons(text: "Save flashcards", onTap: () => saveFlashcards(widget.uid)),
                  const SizedBox(height: 25),
                  Buttons(text: "Save and review the flashcards", onTap: (){}),
                  const SizedBox(height: 25),
                  Buttons(text: "Cancel", onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
                  }),
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}