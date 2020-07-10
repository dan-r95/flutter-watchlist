import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_watchlist/login/login.dart';
import 'package:flutter_watchlist/login/register.dart';
import 'package:flutter_watchlist/login/splash.dart';
import 'package:flutter_watchlist/movie_view/homepage.dart';

import 'common/bloc.dart';
import 'package:flutter_appcenter_bundle/flutter_appcenter_bundle.dart';

Future<void> main() async {
  print("before run App...");
  runApp(MyApp());
  // await AppCenter.startAsync(
  //   appSecretAndroid: '9ad0404e-6929-4ab4-9dd4-3198c8e96786',
  //   appSecretIOS: 'xxxx',
  //   enableAnalytics: true, // Defaults to true
  //   enableCrashes: true, // Defaults to true
  //   enableDistribute: false, // Defaults to false
  //   usePrivateDistributeTrack: false, // Defaults to false
  // );
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
