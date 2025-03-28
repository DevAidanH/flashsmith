import 'package:flutter/material.dart';

class Textfields extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  const Textfields({
    required this.hintText,
    required this.obscureText,
    required this.controller,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12)
        ),
        hintText: hintText
      ),
      obscureText: obscureText,
    );
  }
}