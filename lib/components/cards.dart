import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Cards extends StatefulWidget {
  String text;
  Cards({super.key, required this.text});

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  @override
  Widget build(BuildContext context) {
    return Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.inversePrimary.withValues(alpha: 0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),)]
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      widget.text, 
                      style: TextStyle(
                        fontSize: 20
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            );
  }
}