import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_watchlist/login/login.dart';
import 'package:flutter_watchlist/login/register.dart';
import 'package:flutter_watchlist/login/splash.dart';
import 'package:flutter_watchlist/movie_view/homepage.dart';

import 'common/bloc.dart';
// import 'package:appcenter/appcenter.dart';
// import 'package:appcenter_analytics/appcenter_analytics.dart';
// import 'package:appcenter_crashes/appcenter_crashes.dart';

Future<void> main() async {
  print("before run App...");
  runApp(MyApp());
  // final ios = defaultTargetPlatform == TargetPlatform.iOS;
  // var app_secret = ios ? "iOSGuid" : "AndroidGuid";
  // await AppCenter.start(
  //     app_secret, [AppCenterAnalytics.id, AppCenterCrashes.id]);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  MyApp({Key key}) : super(key: key);
  // final FirebaseApp app;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Brightness>(
        stream: bloc.currentBrightness,
        builder: (BuildContext context, AsyncSnapshot<Brightness> snapshot) {
          return MaterialApp(
              title: 'My Watchlist',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                brightness: snapshot.data,
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.
                primarySwatch: Colors.blue,
              ),
              home: SplashPage(),
              routes: <String, WidgetBuilder>{
                '/home': (BuildContext context) => HomePage(title: 'Home'),
                '/login': (BuildContext context) => LoginPage(),
                '/register': (BuildContext context) => RegisterPage(),
              });
        });
  }
}
