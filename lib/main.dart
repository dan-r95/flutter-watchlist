import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pwa_install/pwa_install.dart';

import 'package:flutter_watchlist/login/login.dart';
import 'package:flutter_watchlist/movie_view/homepage.dart';
import 'package:flutter_watchlist/common/bloc.dart';
import 'package:flutter_watchlist/settings/settings.dart';

import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart'
    as google_auth;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "user.env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  final googleClientId = dotenv.env['GOOGLE_CLIENT_ID'];

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    EmailLinkAuthProvider(
        actionCodeSettings:
            ActionCodeSettings(url: 'https://watchlist.firebaseapp.com/')),
    google_auth.GoogleProvider(clientId: googleClientId!),
  ]);

  // Add this
  PWAInstall().setup(installCallback: () {
    debugPrint('APP INSTALLED!');
  });

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
  MyApp({Key? key}) : super(key: key);

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
                inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
                outlinedButtonTheme: OutlinedButtonThemeData(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(24),
                    ),
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.blue),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                  ),
                ),
                brightness: snapshot.data,
                primarySwatch: Colors.blue,
                textTheme: GoogleFonts.latoTextTheme(
                  Theme.of(context)
                      .textTheme, // If this is not set, then ThemeData.light().textTheme is used.
                ),
              ),
              initialRoute: auth.currentUser == null ? '/' : '/home',
              routes: <String, WidgetBuilder>{
                '/home': (BuildContext context) => HomePage(
                      title: 'Home',
                      uuid: auth.currentUser?.uid,
                    ),
                '/': (context) {
                  return LoginPage();
                },
                '/profile': (context) {
                  return
                      //Column(children: [
                      ProfileScreen(
                    appBar: AppBar(
                      title: Text('Profile'),
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.pushReplacementNamed(context, '/');
                      }),
                    ],
                    children: [
                      SettingsRoute(title: "Settings"),
                    ],
                  );
                },
              });
        });
  }
}
