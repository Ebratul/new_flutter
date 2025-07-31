import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import 'login_page.dart';

class ForgetPasswardPage extends StatefulWidget {
  const ForgetPasswardPage({super.key});

  @override
  State<ForgetPasswardPage> createState() => _ForgetPasswardPageState();
}

class _ForgetPasswardPageState extends State<ForgetPasswardPage> {

  TextEditingController EmailController = TextEditingController();

  @override
  void dispose()
  {
    EmailController.dispose();
    super.dispose();
  }



  Future PassWordReset() async {
    final email = EmailController.text.trim();

    // if (email.isEmpty) {
    //   Fluttertoast.showToast(msg: "Please enter your email");
    //   return;
    // }

    // Basic format validation
    // final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    // if (!emailRegex.hasMatch(email)) {
    //   Fluttertoast.showToast(msg: "Enter a valid email address");
    //   return;
    // }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(msg: "Reset link sent to $email");

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Password reset link sent. Check your email."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              )
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(e.message ?? "Something went wrong"),
            // actions: [
            //   TextButton(
            //     onPressed: () => Navigator.pop(context),
            //     child: Text("OK"),
            //   )
            // ],
          );
        },
      );
    }
  }

  Future SignOut()async{
    Fluttertoast.showToast(
        msg: "SignOut",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER
    );
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)=> LoginPage())
    );

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, ///////////////////
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 10,
        title: Text("PassWord Reset",
        style: TextStyle(
            color: Colors.white
        ),
        ),
        actions: [
          IconButton
            (
              onPressed: SignOut,
              icon: Icon(Icons.logout)
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: SafeArea
          (
            child:Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Lottie.asset('assets/forget.json')),

                  SizedBox(height: 20,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: EmailController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(15)
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(15)
                        ),
                        hintText: "Enter your email",
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: PassWordReset,
                      color: Colors.red,
                      child: Text
                        (
                        "Reset PassWord",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      )
                  )

                ],
              ),
            )
        ),
      ),

    );
  }
}
