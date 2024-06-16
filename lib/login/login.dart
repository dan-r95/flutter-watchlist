import 'package:flutter/material.dart';
import 'package:flutter_watchlist/common/bloc.dart';
import 'package:flutter_watchlist/common/snackbar.dart';
import 'package:flutter_watchlist/movie_view/homepage.dart';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_watchlist/login/build_info.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.uiErrorUtils, this.bloc}) : super(key: key);

  final UiErrorUtils? uiErrorUtils;
  final Bloc? bloc;

  @override
  _LoginPageState createState() => _LoginPageState(uiErrorUtils: errorUtils);
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState>? _loginFormKey = GlobalKey<FormState>();

  UiErrorUtils? _uiErrorUtils;
  Bloc? _bloc;

  GoogleSignInAccount? _currentUser;

  _LoginPageState({required UiErrorUtils uiErrorUtils}) {
    _uiErrorUtils = uiErrorUtils;
  }

  _signInWithTest() async {
    final testPw = dotenv.env['TEST_PASSWORD'];
    final testMail = dotenv.env['TEST_MAIL'];
    if (testMail == null || testPw == null) {
      _uiErrorUtils?.openSnackBar(context, "environment not set up");
    }
    late final EmailAuthProvider provider = EmailAuthProvider();
    try {
      //TODO: fix
      /* await FirebaseAuth.instance
          .signInWithCredential(provider.authenticate(testMail!, testPw!));*/
    } catch (e) {
      _uiErrorUtils?.openSnackBar(context, e.toString());
    }
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  title: '',
                  uuid: FirebaseAuth.instance.currentUser?.uid,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      subtitleBuilder: (context, action) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            action == AuthAction.signIn
                ? 'Please sign in to continue.'
                : 'Please create an account to continue',
          ),
        );
      },
      /* footerBuilder: (context, _) {
        return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(children: <Widget>[
              Text(buildTime),
              Text(buildCommit),
              TextButton(
                child: Text('Use a test account 🚀'),
                onPressed: () async {
                  await _signInWithTest();
                },
              ),
            ]));
      },*/
      sideBuilder: (context, constraints) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset("../assets/watchlist.png")),
            ),
            Text("My Watchlist")
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
        );
      },
      headerBuilder: (context, constraints, _) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset("../assets/watchlist.png"),
          ),
        );
      },
      // no providerConfigs property - global configuration will be used instead
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          Navigator.pushReplacementNamed(context, '/home');
        }),
        EmailLinkSignInAction((context) {
          EmailLinkSignInScreen();
        }),
        ForgotPasswordAction((context, state) {
          ForgotPasswordScreen(
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20).copyWith(top: 40),
                child: Icon(
                  Icons.lock,
                  color: Colors.blue,
                  size: constraints.maxWidth / 4 * (1 - shrinkOffset),
                ),
              );
            },
          );
        })
      ],
    );
  }
}
