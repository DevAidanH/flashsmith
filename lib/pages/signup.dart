import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashsmith/components/buttons.dart';
import 'package:flashsmith/components/textfields.dart';
import 'package:flashsmith/helper/helper_functions.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  final void Function()? onTap;

  const Signup({super.key, required this.onTap});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  //Text controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();

  //Login method
  void signup() async {
    //show loading circle
    //showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator(),));

    //make sure passwords match
    if(passwordController.text != passwordConfirmController.text){
      //pop loading cirle
      //Navigator.pop(context);

      //Show error message
      displayMessageToUser("Passwords don't match", context);
    }
    else{
      //create user in firebase
      try{
        UserCredential? userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
        //Add new user to database
        await createUserDocument(userCredential);
        //if(context.mounted)Navigator.pop(context);
        
      }on FirebaseAuthException catch (e){
       // if(context.mounted)Navigator.pop(context);
        displayMessageToUser(e.code, context);
      }
    }
  }

  Future<void> createUserDocument(UserCredential? userCredential)async{
    if(userCredential != null && userCredential.user != null){
      //Sign in as the new user
      UserCredential? userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);

      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection("Users").doc(uid).set({
        "username": usernameController.text,
        "email": emailController.text,
        "createdCards": [],
        "generatedCards": []
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              //logo
              Icon(
                Icons.bolt, 
                size: 150, 
                color: Theme.of(context).colorScheme.inversePrimary
              ),
            
              const SizedBox(height: 25),
            
              //app name
              Text(
                "F L A S H  S M I T H", 
                style: TextStyle(fontSize: 20)
              ),
            
              const SizedBox(height: 25),
        
              //Username textfield
              Textfields(
                hintText: "Username", 
                obscureText: false, 
                controller: usernameController
              ),
        
              const SizedBox(height: 10),
            
              //email textfield
              Textfields(
                hintText: "Email", 
                obscureText: false, 
                controller: emailController
              ),
        
              const SizedBox(height: 10),
        
              //password textfield
              Textfields(
                hintText: "Password", 
                obscureText: true, 
                controller: passwordController
              ),
            
              const SizedBox(height: 10),
        
              Textfields(
                hintText: "Confirm Password", 
                obscureText: true, 
                controller: passwordConfirmController
              ),
        
              const SizedBox(height: 25),
            
              //login button
              Buttons(text: "Sign up", onTap: () => signup()),
        
              const SizedBox(height: 10),
            
              //Text and register button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Have an account already? "),
                  
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text("Login Here", style: TextStyle(fontWeight: FontWeight.bold),),
                  )
                ],
              )
              ]
            ),
          ),
        ),
      ),
    );
  }
}