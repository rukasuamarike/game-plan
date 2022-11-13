import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:take_break/classes/user.dart';
import 'package:take_break/pages/form.dart';
import 'package:take_break/pages/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  final db = FirebaseFirestore.instance.collection("Users");

  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(236, 217, 186, 30),
      appBar: AppBar(
        title: const Text(
          "Game Plan",
          style: TextStyle(height: 1, fontSize: 30),
        ),
        backgroundColor: Color.fromARGB(255, 40, 128, 43),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(child: Builder(
        builder: (context) {
          if (user == null) {
            return const LoginPage();
          }

          Stream<UserData> userData = db
              .doc(user.uid)
              .snapshots()
              .map((snap) => UserData.fromFirestore(snap));

          return MultiProvider(
            providers: [
              StreamProvider<UserData>.value(
                initialData:
                    UserData(id: "", email: "", firstname: "", lastname: ""),
                value: db
                    .doc(user.uid)
                    .snapshots()
                    .map((snap) => UserData.fromFirestore(snap)),
              )
            ],
            child: const InputFormPage(),
          );
        },
      )),
    );
  }
}
