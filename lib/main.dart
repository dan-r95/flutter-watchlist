import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_watchlist/login/login.dart';
import 'package:flutter_watchlist/login/register.dart';
import 'package:flutter_watchlist/movie_view/homepage.dart';
import 'package:flutterfire_ui/auth.dart';
import 'common/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter_appcenter_bundle/flutter_appcenter_bundle.dart';

var firebaseConfig = {
  "apiKey": "AIzaSyAekU2K2qwbisvtEkakX3d2g6eA478LwHc",
  "authDomain": "flutter-watchlist.firebaseapp.com",
  "databaseURL": "https://flutter-watchlist.firebaseio.com",
  "projectId": "flutter-watchlist",
  "storageBucket": "flutter-watchlist.appspot.com",
  "messagingSenderId": "220852966414",
  "appId": "1:220852966414:web:4916c4b790d8b390cad85f",
  "measurementId": "G-W2YH6JWLEN"
};

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    // not running on web
    // await AppCenter.startAsync(
    //   appSecretAndroid: '9ad0404e-6929-4ab4-9dd4-3198c8e96786',
    //   appSecretIOS: 'xxxx',
    //   enableAnalytics: true, // Defaults to true
    //   enableCrashes: true, // Defaults to true
    //   enableDistribute: false, // Defaults to false
    //   usePrivateDistributeTrack: false, // Defaults to false
    // );
  }

  FlutterFireUIAuth.configureProviders([
    const EmailProviderConfiguration(),
    const PhoneProviderConfiguration(),
    const GoogleProviderConfiguration(clientId: "null"),
    const AppleProviderConfiguration(),
  ]);

  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text("Sorry, something went wrong! Restart app?");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  MyApp({Key? key}) : super(key: key);
  // final FirebaseApp app;

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

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
              initialRoute: auth.currentUser == null ? '/' : '/profile',
              routes: <String, WidgetBuilder>{
                '/home': (BuildContext context) => HomePage(title: 'Home', app: ),
                '/login': (BuildContext context) => LoginPage(),
                '/register': (BuildContext context) => RegisterPage(),
                '/': (context) {
                  return SignInScreen(
                    // no providerConfigs property - global configuration will be used instead
                    actions: [
                      AuthStateChangeAction<SignedIn>((context, state) {
                        Navigator.pushReplacementNamed(context, '/profile');
                      }),
                    ],
                  );
                },
                '/profile': (context) {
                  return ProfileScreen(
                    // no providerConfigs property here as well
                    actions: [
                      SignedOutAction((context) {
                        Navigator.pushReplacementNamed(context, '/');
                      }),
                    ],
                  );
                },
              });
        });
  }
}
