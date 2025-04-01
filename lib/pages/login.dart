import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashsmith/components/buttons.dart';
import 'package:flashsmith/components/textfields.dart';
import 'package:flashsmith/helper/helper_functions.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final void Function()? onTap;

  const Login({super.key, required this.onTap});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Text controllers
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  //Login method
  void login() async {
    //Show loading circle
    //showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator(),));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      //if(context.mounted) Navigator.pop(context); 
    } on FirebaseAuthException catch (e){
      //Navigator.pop(context);
      displayMessageToUser(e.code, context); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
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

            //forgot password
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),
          
            //login button
            Buttons(text: "Login", onTap: () => login()),

            const SizedBox(height: 10),
          
            //Text and register button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? "),
                
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text("Register Here", style: TextStyle(fontWeight: FontWeight.bold),),
                )
              ],
            )
            ]
          ),
        ),
      ),
    );
  }
}