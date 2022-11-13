import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'classes/authenticate.dart';
import 'classes/user.dart';

class GButton extends StatefulWidget {
  final bool isExiting; //logging out?

//text color

  const GButton({
    Key? key,
    required this.isExiting,
  }) : super(key: key);

  @override
  GButtonState createState() => GButtonState();
}

class GButtonState extends State<GButton> {
  bool _isSigningIn = false;

  //async future functions
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      child: _isSigningIn
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });
                if (!widget.isExiting) {
                  User? user =
                      await Authentication.signInWithGoogle(context: context);
                  if (user != null) {
                    var doc = await FirebaseFirestore.instance
                        .collection('Users')
                        .doc(user.uid)
                        .get();
                    if (doc.exists) {
                      UserData userData = UserData.fromFirestore(doc);
                      await FirebaseFirestore.instance
                          .collection("Users")
                          .doc(user.uid)
                          .update(userData.toJson());
                    } else {
                      await FirebaseFirestore.instance
                          .collection("Users")
                          .doc(user.uid)
                          .set(UserData(
                                  id: user.uid,
                                  firstname: user.displayName!.split(' ')[0],
                                  lastname: user.displayName!.split(' ')[1],
                                  email: user.providerData[0].providerId)
                              .toJson());
                    }
                  } else {
                    await Authentication.signOutGoogle(context: context);
                  }

                  setState(() {
                    _isSigningIn = false;
                  });
                }
              },
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Image(
                        image: AssetImage("images/google.png"),
                        height: 35,
                        width: 35,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${widget.isExiting ? "Sign Out of" : "Sign In with"} google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
