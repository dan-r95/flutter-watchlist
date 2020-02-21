import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_watchlist/common/bloc.dart';
import 'package:flutter_watchlist/common/snackbar.dart';
import 'package:flutter_watchlist/movie_view/homepage.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key, this.uiErrorUtils, this.bloc}) : super(key: key);
  final UiErrorUtils uiErrorUtils;
  final Bloc bloc;
  @override
  _SplashPageState createState() => _SplashPageState(uiErrorUtils, bloc);
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  UiErrorUtils uiErrorUtils;
  Bloc bloc;

  _SplashPageState(this.uiErrorUtils, this.bloc) {
    bloc = bloc ?? Bloc();
    uiErrorUtils = uiErrorUtils ?? UiErrorUtils();
  }

  Duration duration = new Duration(seconds: 2);
  Timer timerAnim;

  List<ColorTween> tweenAnimations = [];
  int tweenIndex = 0;

  AnimationController controller;
  List<Animation<Color>> colorAnimations = [];

  List<Color> colors = [Colors.green, Colors.red, Colors.white, Colors.blue];
  @override
  initState() {
    print("init state");
    //FirebaseAuth.instance.signOut();
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) => {
              print("Curr User: " + currentUser.toString()),
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
                      .catchError((err) => {print(err), bloc.addMessage(err)})
                }
            })
        .catchError((err) => {print(err), bloc.addMessage(err)});
    super.initState();

    //  // this is all stuff to handle the fancy timer running animation
    controller = new AnimationController(
      vsync: this,
      duration: duration,
    );

    for (int i = 0; i < colors.length - 1; i++) {
      tweenAnimations.add(ColorTween(begin: colors[i], end: colors[i + 1]));
    }

    tweenAnimations
        .add(ColorTween(begin: colors[colors.length - 1], end: colors[0]));

    for (int i = 0; i < colors.length; i++) {
      Animation<Color> animation = tweenAnimations[i].animate(CurvedAnimation(
          parent: controller,
          curve: Interval((1 / colors.length) * (i + 1) - 0.05,
              (1 / colors.length) * (i + 1),
              curve: Curves.linear)));

      colorAnimations.add(animation);
    }

    tweenIndex = 0;

    timerAnim = Timer.periodic(duration, (Timer t) {
      // setState(() {
      tweenIndex = (tweenIndex + 1) % colors.length;
      bloc.animationIndexController.add(tweenIndex);

      //  });
    });
  uiErrorUtils.subscribeToSnackBarStream(context, bloc.snackBarSubject);
    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timerAnim?.cancel();
    controller?.stop();
  }

  @override
  Widget build(BuildContext context) {
    print("build splash");
    return Scaffold(body: Builder(builder: (context) {
      return Center(
        child: Container(
          child: StreamBuilder<int>(
              stream: bloc.currentAnimIndex,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                return CircularProgressIndicator(
                  //strokeWidth: 5.0,
                  valueColor: colorAnimations[snapshot.data],
                );
              }),
        ),
      );
    }));
  }
}
