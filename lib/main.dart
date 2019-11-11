import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'snackbar.dart';
import 'bloc.dart';
import 'types.dart';
import 'login.dart';
import 'register.dart';
import 'splash.dart';

Future<void> main() async {
  // final FirebaseApp app = await FirebaseApp.configure(
  //   name: 'db2',
  //   // options: Platform.isIOS
  //   //     ? {} :
  //   options: const FirebaseOptions(
  //     googleAppID: '1:297855924061:android:669871c998cc21bd',
  //     apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
  //     databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
  //   ),
  // );
  /*
  FirebaseDatabase.initializeApp(
    apiKey: "AIzaSyAekU2K2qwbisvtEkakX3d2g6eA478LwHc",
    authDomain: "flutter-watchlist.firebaseapp.com",
    databaseURL: "https://flutter-watchlist.firebaseio.com",
    projectId: "flutter-watchlist",
    storageBucket: "flutter-watchlist.appspot.com",
    messagingSenderId: "220852966414",
  );
*/
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  MyApp({Key key}) : super(key: key);
  // final FirebaseApp app;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
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
  }
}

class HomePage extends StatefulWidget {
  HomePage(
      {Key key, this.title, this.app, this.uiErrorUtils, this.bloc, this.uuid})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;
  final String uuid;
  final FirebaseApp app;
  final UiErrorUtils uiErrorUtils;
  final Bloc bloc;

  @override
  _HomePageState createState() => _HomePageState(
        uiErrorUtils: uiErrorUtils,
        bloc: bloc,
      );
}

class _HomePageState extends State<HomePage> {
  String currentText = "";

  List<ArbitrarySuggestionType> suggestions = [];

  bool loading = false;
  List<ArbitrarySuggestionType> favorites = [];
  StreamSubscription<Event> _onNoteAddedSubscription;
  StreamSubscription<Event> _onNoteChangedSubscription;
  final notesReference = FirebaseDatabase.instance.reference();
  UiErrorUtils _uiErrorUtils;
  Bloc _bloc;

  @override
  void initState() {
    super.initState();
    notesReference.reference().once().then((DataSnapshot snapshot) {
      print('Connected to second database and read ${snapshot.value}');
    });
    favorites = new List();
    _onNoteAddedSubscription = notesReference.onChildAdded.listen(_onNoteAdded);
    // _onNoteChangedSubscription =
    //    notesReference.onChildChanged.listen(_onNoteUpdated);
  }

  @override
  void dispose() {
    _onNoteAddedSubscription.cancel();
    super.dispose();
  }

  void _onNoteAdded(Event event) {
    setState(() {
      favorites.add(new ArbitrarySuggestionType.fromSnapshot(event.snapshot));
    });
  }

/*
  void _onNoteUpdated(Event event) {
    var oldNoteValue =
        favorites.singleWhere((note) => note.id == event.snapshot.key);
    setState(() {
      favorites[favorites.indexOf(oldNoteValue)] =
          new ArbitrarySuggestionType.fromSnapshot(event.snapshot);
    });
  }
*/
  void pushToDB(ArbitrarySuggestionType item) {
    print("will push");
    Firestore.instance
        .collection('favorites')
        .add({'Title': item.name, 'Poster': item.imgURL, 'Year': item.year})
        .then((result) => {})
        .catchError((err) => (_bloc.addMessage(err)));
    favorites.add(item);
  }

  void updateSuggestions(String query) async {
    if (query.length > 2) {
      setState(() {
        loading = true;
      });
      final response =
          await http.get("https://www.omdbapi.com/?s=${query}&apikey=e83d3bc2");

      print(response.body);
      List decoded = jsonDecode(response.body)['Search'];
      print(decoded);
      if (decoded != null) {
        List<ArbitrarySuggestionType> list = decoded
            .map((m) => ArbitrarySuggestionType.fromMappedJson(m))
            .toList();
        print(list.toString());
        // setState(() {
        suggestions = list;
        // });
        setState(() {
          loading = false;
        });
      }
    }
  }

  GlobalKey key =
      new GlobalKey<AutoCompleteTextFieldState<ArbitrarySuggestionType>>();

  AutoCompleteTextField<ArbitrarySuggestionType> textField;

  ArbitrarySuggestionType selected;

  _HomePageState({Bloc bloc, UiErrorUtils uiErrorUtils}) {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
        updateSuggestions(_searchText);
      }
    });

    _bloc = bloc ?? Bloc();
    _uiErrorUtils = uiErrorUtils ?? UiErrorUtils();
  }

  final TextEditingController _filter = new TextEditingController();
  //final dio = new Dio();
  String _searchText = "";
  List names = new List();
  List filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Watchlist');

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
            controller: _filter,
            decoration: new InputDecoration(
                prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
            autofocus: true);
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Watchlist');
        suggestions.clear();
        _filter.clear();
      }
    });
  }
  //TODO use https://pub.dev/packages/flutter_typeahead

  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      List tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]['name']
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        return new Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
            title: Text(suggestions[index].name),
            onTap: () => print(suggestions[index].imgURL),
          ),
          Image.network(suggestions[index].imgURL, fit: BoxFit.scaleDown),
          ButtonTheme.bar(
              // make buttons use the appropriate styles for cards
              child: ButtonBar(children: <Widget>[
            IconButton(
              icon: Icon(Icons.star),
              onPressed: () {
                if (favorites.indexOf(suggestions[index]) == -1) {
                  favorites.add(suggestions[index]);
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('added to favs!'),
                  ));
                  pushToDB(suggestions[index]);
                }
              },
            )
          ]))
        ]));
      },
    );
  }

  Widget _buildFavoritesList() {
    /*return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (BuildContext context, int index) {
        return new Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
            title: Text(favorites[index].name),
            onTap: () => print(favorites[index].imgURL),
          ),
          Image.network(favorites[index].imgURL, fit: BoxFit.scaleDown),
          ButtonTheme.bar(
              // make buttons use the appropriate styles for cards
              child: ButtonBar(children: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                favorites.removeAt(index);
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('deleted!'),
                ));
                setState(() {});
              },
            )
          ]))
        ]));
      },
    );*/
    _uiErrorUtils.subscribeToSnackBarStream(context, _bloc.snackBarSubject);
    return Center(
        child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('favorites').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return new Text('Loading...');
                    default:
                      return new ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            if(snapshot.data.documents.length == 0){
                              return Text("start adding movies!");
                            }
                            var document = snapshot.data.documents[index];

                            return new Card(
                              semanticContainer: true,
                              child: Column(children: <Widget>[
                                Image.network(
                                  document['Poster'],
                                  fit: BoxFit.scaleDown,
                                ),
                                ListTile(
                                  leading: Icon(Icons.album),
                                  title: Text(document['Title']),
                                  subtitle: Text(document['Year']),
                                ),
                                ButtonTheme.bar(
                                    // make buttons use the appropriate styles for cards
                                    child: ButtonBar(children: <Widget>[
                                  FlatButton(
                                    child: const Text('Remove'),
                                    onPressed: () {
                                      Firestore.instance
                                          .document("favorites/" +
                                              document.documentID)
                                          .delete()
                                          .then((onValue) =>
                                              _bloc.addMessage("deleted entry"))
                                          .catchError((error) =>
                                              _bloc.addMessage(error));
                                    },
                                  ),
                                ]))
                              ]),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 5,
                              margin: EdgeInsets.all(10),
                            );
                          });
                  }
                })));
  }

  @override
  Widget build(BuildContext context) {
    // Subscribe to UI feedback streams from  provided _bloc
    _uiErrorUtils.subscribeToSnackBarStream(context, _bloc.snackBarSubject);
    return MaterialApp(
        title: "Watchlist",
        home: Scaffold(
            appBar: new AppBar(
                centerTitle: true,
                title: _appBarTitle,
                leading: new IconButton(
                  icon: _searchIcon,
                  onPressed: _searchPressed,
                )),
            body: new Stack(children: <Widget>[
              new Container(child: _buildFavoritesList()),
             /* Container(
                  //color: const Color(0xFFFFFF).withOpacity(0.5),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: _buildList()),*/
              if (loading) new CircularProgressIndicator(),
            ])

            /* new Card(
                child: selected != null
                    ? new Column(children: [
                        new ListTile(
                            title: new Text(selected.name),
                            trailing: new Text("Rating: ${selected.stars}/5"),
                            subtitle: new Text(" ${selected.year}")),
                        new Container(
                            child: new Image(
                                image: new NetworkImage(selected.imgURL)),
                            width: 400.0,
                            height: 300.0)
                      ])
                    : new Icon(Icons.cancel))),*/
            ));
  }
}
