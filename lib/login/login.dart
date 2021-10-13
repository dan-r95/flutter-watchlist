import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_watchlist/common/bloc.dart';
import 'package:flutter_watchlist/common/snackbar.dart';
import 'package:flutter_watchlist/movie_view/homepage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_watchlist/common/tab_bloc.dart';
import 'package:flutter_watchlist/build_info.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.uiErrorUtils, this.bloc}) : super(key: key);

  final UiErrorUtils uiErrorUtils;
  final Bloc bloc;

  @override
  _LoginPageState createState() => _LoginPageState(
        uiErrorUtils: uiErrorUtils,
        bloc: bloc,
      );
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  UiErrorUtils _uiErrorUtils;
  Bloc _bloc;

  GoogleSignInAccount _currentUser;

  @override
  initState() {
    super.initState();
    _bloc.addMessage("LOL");
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
  }

  _LoginPageState({UiErrorUtils uiErrorUtils, Bloc bloc}) {
    _bloc = bloc ?? Bloc();
    _uiErrorUtils = uiErrorUtils ?? UiErrorUtils();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 6) {
      return 'Password must be longer than 6 characters';
    } else {
      return null;
    }
  }

  Widget _signInButton() {
    return OutlinedButton(
      onPressed: () async {
        await signInWithGoogle();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn
        .signIn()
        .catchError((err) => bloc.addMessage(err.toString()));
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    // assert(!user.isAnonymous);
    // assert(await user.getIdToken() != null);

    FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((currentUser) => FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.user.uid)
            .get()
            .then((DocumentSnapshot result) => {
                  print(result),
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                title: result["fname"] + "'s Tasks",
                                uuid: currentUser.user.uid,
                              )))
                })
            .catchError((err) => _bloc.addMessage(err)))
        .catchError((err) => (_bloc.addMessage(err)));
  }

  void signOutGoogle() async {
    await _googleSignIn.signOut();

    print("User Sign Out");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Builder(builder: (context) {
          _uiErrorUtils.subscribeToSnackBarStream(
              context, bloc.snackBarSubject);
          return Container(
              margin: MediaQuery.of(context).size.width > 1400
                  ? EdgeInsets.fromLTRB(200, 0, 200, 0)
                  : EdgeInsets.all(0),
              child: SingleChildScrollView(
                  child: Form(
                key: _loginFormKey,
                child: Column(
                  children: <Widget>[
                    AutofillGroup(
                        child: Column(children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Email*',
                            hintText: "john.doe@gmail.com"),
                        controller: emailInputController,
                        keyboardType: TextInputType.emailAddress,
                        validator: emailValidator,
                        autofillHints: [AutofillHints.email],
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Password*', hintText: "********"),
                        controller: pwdInputController,
                        obscureText: true,
                        validator: pwdValidator,
                        autofillHints: [AutofillHints.password],
                      )
                    ])),
                    SizedBox(
                      height: 15,
                    ),
                    _signInButton(),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      child: Text("Login"),
                      onPressed: () => {
                        if (_loginFormKey.currentState.validate())
                          {
                            FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: emailInputController.text.trim(),
                                    password: pwdInputController.text.trim())
                                .then((currentUser) => FirebaseFirestore
                                    .instance
                                    .collection("users")
                                    .doc(currentUser.user.uid)
                                    .get()
                                    .then((DocumentSnapshot result) => {
                                          tabBloc.updateIndex(0),
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage(
                                                        title: result["fname"] +
                                                            "'s Tasks",
                                                        uuid: currentUser
                                                            .user.uid,
                                                      )))
                                        })
                                    .catchError((err) =>
                                        bloc.addMessage(err.toString())))
                                .catchError(
                                    (err) => (bloc.addMessage(err.toString())))
                          }
                      },
                    ),
                    Text("Don't have an account yet?"),
                    TextButton(
                      child: Text("Register here!"),
                      onPressed: () =>
                          {Navigator.pushNamed(context, "/register")},
                    ),
                    /* ElevatedButton(
                        child: Text("Or Continue without an account!"),
                        onPressed: () => {
                              FirebaseAuth.instance
                                  .signInAnonymously()
                                  .then(
                                      (currentUser) =>
                                          FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(currentUser.user.uid)
                                              .get()
                                              .then(
                                                  (DocumentSnapshot result) => {
                                                        Navigator
                                                            .pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            HomePage(
                                                                              title: result.data == null ? "Temp account" : result["fname"] + "'s Tasks",
                                                                              uuid: currentUser.user.uid,
                                                                            )))
                                                      })
                                              .catchError((err) => bloc
                                                  .addMessage(err.toString())))
                                  .catchError((err) =>
                                      (bloc.addMessage(err.toString())))
                            }), */
                    Text(buildTime),
                    Text(buildCommit),
                  ],
                ),
              )));
        }));
  }
}
