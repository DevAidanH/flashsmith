import 'package:flashsmith/components/cards.dart';
import 'package:flashsmith/services/firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Reviewflow extends StatefulWidget {
  String uid;
  Reviewflow({super.key, required this.uid});

  @override
  State<Reviewflow> createState() => _ReviewflowState();
}

class _ReviewflowState extends State<Reviewflow> {
  final FirestoreService firestoreService = FirestoreService();
  int currentIndex = 0;
  List<Map<String, String>> elements = [];
  final PageController _pageController = PageController();

  @override
  void initState(){
    super.initState();
    readDataFromFirestore();
  }

  void readDataFromFirestore()async{
    List<Map<String,String>> data = await firestoreService.readData(widget.uid);
    setState(() {
      elements = data;
    });
  }

  void nextCard() {
    if (currentIndex < elements.length - 1) {
      currentIndex++;
      _pageController.animateToPage(
        currentIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  void perviousCard() {
    if (currentIndex > 0) {
      --currentIndex;
      _pageController.animateToPage(
        currentIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool flipCardState = false; //Controls which side of the card is visable - false = front
  void flipCard(){
    setState(() => flipCardState = !flipCardState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
          children: [
            Expanded(child: elements.isEmpty
            ? Center(child: const Text("No cards yet"))
            : PageView.builder(
              controller: _pageController,
              itemCount: elements.length,
              onPageChanged: (index){
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index){
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Card ${(currentIndex+1).toString()}/${elements.length.toString()}"),
                      const SizedBox(height: 25),
                      Visibility(
                        visible: flipCardState,
                        replacement: Cards(text: elements[index]["front"]!),
                        child: Cards(text: elements[index]["back"]!)
                      ),
                    ],
                  )
                );
              }
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: perviousCard, icon: Icon(Icons.arrow_back)),
                IconButton(onPressed: flipCard, icon: Icon(Icons.flip)),
                IconButton(onPressed: nextCard, icon: Icon(Icons.arrow_forward))
              ],
            )
          ]
      )
    );
  }
}