import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_watchlist/common/bloc.dart';
import 'package:flutter_watchlist/common/snackbar.dart';
import 'package:flutter_watchlist/movie_view/homepage.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_watchlist/common/tab_bloc.dart';
import 'package:flutter_watchlist/login/build_info.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.uiErrorUtils, this.bloc}) : super(key: key);

  final UiErrorUtils? uiErrorUtils;
  final Bloc? bloc;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState>? _loginFormKey = GlobalKey<FormState>();
  TextEditingController? emailInputController;
  TextEditingController? pwdInputController;
  UiErrorUtils? _uiErrorUtils;
  Bloc? _bloc;

  GoogleSignInAccount? _currentUser;

  @override
  initState() {
    super.initState();
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
      footerBuilder: (context, _) {
        return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(children: <Widget>[
              Text(buildTime),
              Text(buildCommit),
            ]));
      },
      sideBuilder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: AspectRatio(
              aspectRatio: 1, child: Image.asset("../assets/watchlist.png")),
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
        ForgotPasswordAction((context, state) => {
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
              )
            })
      ],
    );
  }
}
