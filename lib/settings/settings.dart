import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_watchlist/common/bloc.dart';
import 'package:flutter_watchlist/login/build_info.dart';

// provide a way to change the port, ip, username, password and theme and save it to the preferences
// next time the app is openend, the preferences are read from storage
class SettingsRoute extends StatefulWidget {
  SettingsRoute({
    Key? key,
    required final this.title,
  }) : super(key: key);
  String title = "";
  @override
  SettingsRouteState createState() => SettingsRouteState();
}

class SettingsRouteState extends State<SettingsRoute> {
  SharedPreferences? prefs;

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(str)),
    );
  }

  // provide a way to change the port, ip, username, password and theme and save it to the preferences
  // next time the app is openend, the preferences are read from storage
  @override
  Widget build(BuildContext context) {
    // set up the AlertDialog

    return Container(
        margin: EdgeInsets.all(20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              ElevatedButton(
                onPressed: () => {
                  bloc.brightnessController.value == Brightness.dark
                      ? {
                          prefs
                              ?.setString('theme', 'light')
                              .then((bool success) {
                            showDialog("Changed the theme");
                            bloc.brightnessController.add(Brightness.light);
                          }),
                        }
                      : {
                          prefs
                              ?.setString('theme', 'dark')
                              .then((bool success) {
                            showDialog("Changed the theme");
                            bloc.brightnessController.add(Brightness.dark);
                          }),
                        }
                },
                child: Text("Change theme"),
              ),
              ElevatedButton(
                onPressed: () => {
                  prefs
                      ?.clear()
                      .then((onValue) => showDialog("Cleared all preferences"))
                      .catchError((onError) => showDialog(onError))
                },
                child: Text("Clear preferences"),
              ),
              ElevatedButton(
                onPressed: () => {
                  showAboutDialog(
                      context: context,
                      applicationName: "Watchlist",
                      applicationVersion: "0.1",
                      applicationLegalese: "MIT License")
                },
                child: Text("About"),
              ),
              Text(buildTime),
              Text(buildCommit),
            ]));
  }
}
