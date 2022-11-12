import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:take_break/classes/user.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:take_break/googlebutton.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final pwController = TextEditingController();
  final confirmPwController = TextEditingController();

  Future<void> signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: pwController.text);
      User? user = FirebaseAuth.instance.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
            'Incorrect Password',
            style: TextStyle(fontSize: 24, color: Colors.red),
          )),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GButton(
      isExiting: false,
    ));
  }
}
