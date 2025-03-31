import 'package:flashsmith/components/buttons.dart';
import 'package:flashsmith/helper/generateFlashCard.dart';
import 'package:flashsmith/pages/homepage.dart';
import 'package:flutter/material.dart';

class Generateflow extends StatefulWidget {
  const Generateflow({super.key});

  @override
  State<Generateflow> createState() => _GenerateflowState();
}

class _GenerateflowState extends State<Generateflow> {
  PageController _pageController = PageController();

  Future<void> callGenrateScriptandChangePage() async {
    _pageController.jumpToPage(1);
    final flashcards = await generateFlashCards();
    print(flashcards);
    _pageController.jumpToPage(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        //physics: NeverScrollableScrollPhysics(),
        children: [
          Container(
            child: Column(
              children: [
                Text("Please upload a PDF by clicking the button below. \n Our AI will then generate a series of flashcards based on the content", textAlign: TextAlign.center),
                Buttons(text: "Click here to upload", onTap: callGenrateScriptandChangePage)
              ],
            ),
          ),
          Container(
            color: Colors.red,
            child: Center(
              child: Text("Loading...")
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Your new flashcards have been generated"),
                  const SizedBox(height: 25),
                  Buttons(text: "Save flashcards", onTap: (){}),
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