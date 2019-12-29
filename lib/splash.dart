import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'bloc.dart';
import 'snackbar.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key, this.uiErrorUtils, this.bloc}) : super(key: key);
  final UiErrorUtils uiErrorUtils;
  final Bloc bloc;
  @override
  _SplashPageState createState() => _SplashPageState(uiErrorUtils, bloc);
}

class _SplashPageState extends State<SplashPage> {
  UiErrorUtils uiErrorUtils;
  Bloc bloc;

  _SplashPageState(this.uiErrorUtils, this.bloc) {
    bloc = bloc ?? Bloc();
    uiErrorUtils = uiErrorUtils ?? UiErrorUtils();
  }

  Duration duration = new Duration(seconds: 2);
  //Timer timerAnim;

  List<ColorTween> tweenAnimations = [];
  int tweenIndex = 0;

  AnimationController controller;
  List<Animation<Color>> colorAnimations = [];

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
                      .catchError((err) => bloc.addMessage(err))
                }
            })
        .catchError((err) => (bloc.addMessage(err)));
    super.initState();

    //  // this is all stuff to handle the fancy timer running animation
    // controller = new AnimationController(
    //   vsync: this,
    //   duration: duration,
    // );

    // for (int i = 0; i < colors.length - 1; i++) {
    //   tweenAnimations.add(ColorTween(begin: colors[i], end: colors[i + 1]));
    // }

    // tweenAnimations
    //     .add(ColorTween(begin: colors[colors.length - 1], end: colors[0]));

    // for (int i = 0; i < colors.length; i++) {
    //   Animation<Color> animation = tweenAnimations[i].animate(CurvedAnimation(
    //       parent: controller,
    //       curve: Interval((1 / colors.length) * (i + 1) - 0.05,
    //           (1 / colors.length) * (i + 1),
    //           curve: Curves.linear)));

    //   colorAnimations.add(animation);
    // }

    // tweenIndex = 0;

    // timerAnim = Timer.periodic(duration, (Timer t) {
    //   // setState(() {
    //   tweenIndex = (tweenIndex + 1) % colors.length;
    //   bloc.animationIndexController.add(tweenIndex);

    //   //  });
    // });

    // controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    uiErrorUtils.subscribeToSnackBarStream(context, bloc.snackBarSubject);
    return Scaffold(
        body: Center(
      child: Container(
        child: StreamBuilder<int>(
            stream: bloc.currentAnimIndex,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return CircularProgressIndicator(
                  //strokeWidth: 5.0,
                  //   valueColor: colorAnimations[snapshot.data],
                  );
            }),
      ),
    ));
  }
}
