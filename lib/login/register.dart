import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_watchlist/common/bloc.dart';
import 'package:flutter_watchlist/common/snackbar.dart';
import 'package:flutter_watchlist/movie_view/homepage.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.bloc, this.uiErrorUtils}) : super(key: key);
  final UiErrorUtils uiErrorUtils;
  final Bloc bloc;
  @override
  _RegisterPageState createState() => _RegisterPageState(
        uiErrorUtils: uiErrorUtils,
        bloc: bloc,
      );
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;

  UiErrorUtils _uiErrorUtils;
  Bloc _bloc;

  _RegisterPageState({UiErrorUtils uiErrorUtils, Bloc bloc}) {
    _bloc = bloc;
    _uiErrorUtils = uiErrorUtils;
  }

  @override
  initState() {
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    super.initState();
  }

  String? emailValidator(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Email format is invalid';
    } else {
      return "";
    }
  }

  String? pwdValidator(String? value) {
    if (value!.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register"),
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
                key: _registerFormKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'First Name*', hintText: "John"),
                      controller: firstNameInputController,
                      autofillHints: [AutofillHints.name],
                      validator: (value) {
                        if (value!.length < 3) {
                          return "Please enter a valid first name.";
                        }
                        return "";
                      },
                    ),
                    TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Last Name*', hintText: "Doe"),
                        controller: lastNameInputController,
                        autofillHints: [AutofillHints.familyName],
                        validator: (value) {
                          if (value.length < 3) {
                            return "Please enter a valid last name.";
                          }
                          return "";
                        }),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Email*', hintText: "john.doe@gmail.com"),
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
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Confirm Password*', hintText: "********"),
                      controller: confirmPwdInputController,
                      obscureText: true,
                      validator: pwdValidator,
                    ),
                    ElevatedButton(
                      child: Text("Register"),
                      onPressed: () {
                        if (_registerFormKey.currentState!.validate()) {
                          if (pwdInputController.text ==
                              confirmPwdInputController.text) {
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: emailInputController.text,
                                    password: pwdInputController.text)
                                .then((currentUser) => FirebaseFirestore
                                    .instance
                                    .collection("users")
                                    .doc(currentUser.user?.uid)
                                    .set({
                                      "uid": currentUser.user?.uid,
                                      "fname": firstNameInputController.text,
                                      "surname": lastNameInputController.text,
                                      "email": emailInputController.text,
                                    })
                                    .then((result) => {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage(
                                                        title:
                                                            firstNameInputController
                                                                    .text +
                                                                "'s Tasks",
                                                        uuid: currentUser
                                                            .user!.uid,
                                                      )),
                                              (_) => false),
                                          firstNameInputController.clear(),
                                          lastNameInputController.clear(),
                                          emailInputController.clear(),
                                          pwdInputController.clear(),
                                          confirmPwdInputController.clear()
                                        })
                                    .catchError(
                                        (err) => (_bloc.addMessage(err))))
                                .catchError((err) => _bloc.addMessage(err));
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Error"),
                                    content: Text("The passwords do not match"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("Close"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          }
                        }
                      },
                    ),
                    Text("Already have an account?"),
                    TextButton(
                      child: Text("Login here!"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              )));
        }));
  }
}
