import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'bloc.dart';
import 'snackbar.dart';
class SplashPage extends StatefulWidget {
  SplashPage({Key key,this.uiErrorUtils, this.bloc}) : super(key: key);
 final UiErrorUtils uiErrorUtils;
  final Bloc bloc; 
  @override
  _SplashPageState createState() => _SplashPageState(  uiErrorUtils,
         bloc);
}

class _SplashPageState extends State<SplashPage> {

    UiErrorUtils uiErrorUtils;
  Bloc bloc;

 _SplashPageState(this.uiErrorUtils, this.bloc) {
    bloc = bloc ?? Bloc();
    uiErrorUtils = uiErrorUtils ?? UiErrorUtils();
  }

  @override
  initState() {
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) => {
              if (currentUser == null)
                {Navigator.pushReplacementNamed(context, "/login")}
              else
                {
                  Firestore.instance
                      .collection("users")
                      .document(currentUser.uid)
                      .get()
                      .then((DocumentSnapshot result) =>
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        title: result["fname"] + "'s Tasks",
                                        uuid: currentUser.uid,
                                      ))))
                      .catchError((err) => print(err))
                }
            })
        .catchError((err) => (bloc.addMessage(err)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Loading..."),
        ),
      ),
    );
  }
}
