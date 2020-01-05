import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

// provide a way to change the port, ip, username, password and theme and save it to the preferences
// next time the app is openend, the preferences are read from storage
class SettingsRoute extends StatefulWidget {
  SettingsRoute({Key key}) : super(key: key);

  @override
  SettingsRouteState createState() => SettingsRouteState();
}

class SettingsRouteState extends State<SettingsRoute> {
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  void getPrefs() async {
    // initialize shared preferences
    prefs = await SharedPreferences.getInstance();
  }

  void showDialog(String str) {
    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text(str)),
    );
  }

  // provide a way to change the port, ip, username, password and theme and save it to the preferences
  // next time the app is openend, the preferences are read from storage
  @override
  Widget build(BuildContext context) {
    // set up the AlertDialog

    return SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Settings",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    thickness: 0,
                  ),
                  RaisedButton(
                      onPressed: () => {
                            FirebaseAuth.instance.signOut(),
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()))
                          },
                      child: Text("Logout")),
                  RaisedButton(
                    onPressed: () => {
                      bloc.brightnessController.value == Brightness.dark
                          ? {
                              prefs
                                  .setString('theme', 'light')
                                  .then((bool success) {
                                showDialog("Changed the theme");
                                bloc.brightnessController.add(Brightness.light);
                              }),
                            }
                          : {
                              prefs
                                  .setString('theme', 'dark')
                                  .then((bool success) {
                                showDialog("Changed the theme");
                                bloc.brightnessController.add(Brightness.dark);
                              }),
                            }
                    },
                    child: Text("Change theme"),
                  ),
                  RaisedButton(
                    onPressed: () => {
                      prefs
                          .clear()
                          .then((onValue) =>
                              showDialog("Cleared all preferences"))
                          .catchError((onError) => showDialog(onError))
                    },
                    child: Text("Clear preferences"),
                  )
                ])));
  }
}
