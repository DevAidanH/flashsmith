import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashsmith/auth/login_or_signup.dart';
import 'package:flashsmith/pages/homepage.dart';
import 'package:flutter/material.dart';

class Authpage extends StatelessWidget {
  const Authpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context, snapshot){
          if(snapshot.hasData){
            return const Homepage();
          }
          else{
            return const LoginOrSignup();
          }
        }
      ),
    );
  }
}