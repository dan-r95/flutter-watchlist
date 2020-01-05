import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_watchlist/settings.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'snackbar.dart';
import 'bloc.dart';
import 'types.dart';
import 'login.dart';
import 'register.dart';
import 'splash.dart';
import 'tab_bloc.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  MyApp({Key key}) : super(key: key);
  // final FirebaseApp app;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Watchlist',
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

  List<ArbitrarySuggestionType> alreadyWatched = [];

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

    _children.addAll(
        [_buildFavoritesList(), _buildCompletedList(), SettingsRoute()]);
  }

  @override
  void dispose() {
    _onNoteAddedSubscription.cancel();
    super.dispose();
    _onNoteChangedSubscription.cancel();
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
  void pushToDB(ArbitrarySuggestionType item, String dbName) {
    print("will push");
    Firestore.instance
        .collection(dbName)
        .add({
          'Title': item.name,
          'Poster': item.imgURL,
          'Year': item.year,
          'imdbUrl': item.imdbUrl,
          'added': DateTime.now().millisecondsSinceEpoch, //Unix timestamp
        })
        .then((result) => {})
        .catchError((err) => (_bloc.addMessage(err)));
    favorites.add(item);
  }

  Future<MovieDescription> getMovieDescription(String id) async {
    final response =
        await http.get("https://www.omdbapi.com/?i=$id&apikey=e83d3bc2");

    print(response.body);
    Map<String, dynamic> decoded = jsonDecode(response.body);
    print(decoded);
    if (decoded != null) {
      MovieDescription desc = MovieDescription.fromMappedJson(decoded);
      print(desc.title.toString());
      // setState(() {
      //suggestions = list;
      // });

      return desc;
    }
    return null;
  }

  Future<List<ArbitrarySuggestionType>> updateSuggestions(String query) async {
    if (query.length > 2) {
      setState(() {
        loading = true;
      });
      // final response =
      //     await http.get("https://www.omdbapi.com/?s=$query&apikey=e83d3bc2");

      // print(response.body);
      // List decoded = jsonDecode(response.body)['Search'];
      // print(decoded);
      // if (decoded != null) {
      //   List<ArbitrarySuggestionType> list = decoded
      //       .map((m) => ArbitrarySuggestionType.fromMappedJson(m))
      //       .toList();
      //   print(list.toString());
      //   // setState(() {
      //   //suggestions = list;
      //   // });
      //   setState(() {
      //     loading = false;
      //   });
      //   return list;
      // } else {
      final response =
          await http.get("https://www.omdbapi.com/?t=$query&apikey=e83d3bc2");

      print(response.body);
      Map<String, dynamic> decoded = jsonDecode(response.body);
      print(decoded);
      List<ArbitrarySuggestionType> list = new List<ArbitrarySuggestionType>();
      if (decoded != null) {
        ArbitrarySuggestionType item =
            ArbitrarySuggestionType.fromMappedJson(decoded);
        list.add(item);

        print(list.toString());
        // setState(() {
        //suggestions = list;
        // });
        setState(() {
          loading = false;
        });
        return list;
        // }

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

  MovieDescription description;

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
              autofocus: true,
              style: TextStyle(),
              decoration: InputDecoration(border: OutlineInputBorder())),
          suggestionsCallback: (pattern) async {
            return await updateSuggestions(pattern);
          },
          itemBuilder: (context, ArbitrarySuggestionType suggestion) {
            return ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text(suggestion.name),
              subtitle: Text('\$${suggestion.year}'),
            );
          },
          onSuggestionSelected: (suggestion) {
            showDialogA(context, suggestion);
          },
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Watchlist');
        suggestions.clear();
        _filter.clear();
      }
    });
  }

  //TODO use https://pub.dev/packages/flutter_typeahead
  showDialogA(BuildContext context, ArbitrarySuggestionType suggestion) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!

      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add new movie?'),
          content: SingleChildScrollView(
              child: ListBody(children: <Widget>[
            new Card(
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              ListTile(
                title: Text(suggestion.name),
                subtitle: Text(suggestion.year),
                onTap: () => print(suggestion.imgURL),
              ),
              Image.network(suggestion.imgURL, fit: BoxFit.scaleDown),
              ButtonBar(
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.star),
                      onPressed: () {
                        /*if (favorites.indexOf(suggestions[index]) == -1) {
                  favorites.add(suggestions[index]);
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('added to favs!'),
                  ));*/
                        pushToDB(suggestion, 'favorites');
                        setState(() {
                          if (this._searchIcon.icon == Icons.search) {
                            this._searchIcon = new Icon(Icons.close);
                            this._appBarTitle = new Text('Watchlist');
                          }
                        });
                        //}
                      }),
                ],
              ),
            ]))
          ])),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //TODO use https://pub.dev/packages/flutter_typeahead
  showInfoDialog(BuildContext context, MovieDescription description) {
    print(description.title);
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!

      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(description.title),
          content: SingleChildScrollView(
              child: ListBody(children: <Widget>[
            new Card(
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              ListTile(
                title: Text(description.genre),
                subtitle: Text(description.imdbRating),
              ),
              Text(description.metascore),
              Text(description.plot),
              //Image.network(description., fit: BoxFit.scaleDown),
            ]))
          ])),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFavoritesList() {
    return Center(
        child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('favorites')
                    .orderBy("added", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return new Text('Loading...');
                    default:
                      return new GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 2.0,
                                  mainAxisSpacing: 2.0),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (snapshot.data.documents.length == 0) {
                              return Text("start adding movies!");
                            }
                            var document = snapshot.data.documents[index];

                            return new Dismissible(
                              key: UniqueKey(),
                                onDismissed: (direction) {
                                  setState(() {
                                    alreadyWatched.add(
                                        ArbitrarySuggestionType.fromDocument(
                                            document));
                                  });
                                  print(alreadyWatched.length.toString());
                                  pushToDB(
                                      ArbitrarySuggestionType.fromDocument(
                                          document),
                                      'alreadyWatched');
                                  Firestore.instance
                                      .collection('favorites')
                                      .document(document.documentID)
                                      .delete();
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content:
                                          Text("added to already watched")));
                                },
                                child: Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,
                                    margin: EdgeInsets.all(10),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        new Positioned.fill(
                                            child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          imageUrl: document['Poster'],
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.7),
                                          colorBlendMode: BlendMode.modulate,
                                          fit: BoxFit.cover,
                                          // width: context.size.width,
                                          // height: context.size.height / 4,
                                        )),
                                        // This gradient ensures that the toolbar icons are distinct
                                        // against the background image.
                                        Column(children: <Widget>[
                                          ListTile(
                                            contentPadding:
                                                EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            leading: IconButton(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                                iconSize: 32,
                                                icon: Icon(Icons.info),
                                                color: Colors.white,
                                                onPressed: () async => {
                                                      description =
                                                          (await getMovieDescription(
                                                              document[
                                                                  'imdbUrl'])),
                                                      print(description.actors),
                                                      showInfoDialog(
                                                          context, description)
                                                    }),
                                            title: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black45,
                                                ),
                                                child: Text(
                                                  document['Title'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                            subtitle: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black45,
                                                ),
                                                child: Text(
                                                  document['Year'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                          ),
                                          ButtonBar(children: <Widget>[
                                            Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black26,
                                                ),
                                                child: IconButton(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  iconSize: 24,
                                                  icon: Icon(
                                                      Icons.delete_forever),
                                                  color: Colors.white,
                                                  onPressed: () {
                                                    Firestore.instance
                                                        .document("favorites/" +
                                                            document.documentID)
                                                        .delete()
                                                        .then((onValue) =>
                                                            _bloc.addMessage(
                                                                "deleted entry"))
                                                        .catchError((error) =>
                                                            _bloc.addMessage(
                                                                error));
                                                  },
                                                )),
                                          ]),
                                          // This gradient ensures that the toolbar icons are distinct
                                          // against the background image.
                                          const DecoratedBox(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment(0.0, -1.0),
                                                end: Alignment(0.0, -0.4),
                                                colors: <Color>[
                                                  Color(0x60000000),
                                                  Color(0x00000000)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ],
                                    )));
                          });
                  }
                })));
  }

  Widget _buildCompletedList() {
    return Center(
        child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
                stream:
                    Firestore.instance.collection('alreadyWatched').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return new Text('Loading...');
                    default:
                      return new GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 2.0,
                                  mainAxisSpacing: 2.0),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (snapshot.data.documents.length == 0) {
                              return Text("start adding movies!");
                            }
                            var document = snapshot.data.documents[index];

                            return new Dismissible(
                                key: UniqueKey(),
                                onDismissed: (direction) {
                                 
                                },
                                child: Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,
                                    margin: EdgeInsets.all(10),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        new Positioned.fill(
                                            child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          imageUrl: document['Poster'],
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.7),
                                          colorBlendMode: BlendMode.modulate,
                                          fit: BoxFit.cover,
                                          // width: context.size.width,
                                          // height: context.size.height / 4,
                                        )),
                                        // This gradient ensures that the toolbar icons are distinct
                                        // against the background image.
                                        Column(children: <Widget>[
                                          ListTile(
                                            contentPadding:
                                                EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            leading: IconButton(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                                iconSize: 32,
                                                icon: Icon(Icons.info),
                                                onPressed: () async => {
                                                      description =
                                                          (await getMovieDescription(
                                                              document[
                                                                  'imdbUrl'])),
                                                      print(description.actors),
                                                      showInfoDialog(
                                                          context, description)
                                                    }),
                                            title: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black45,
                                                ),
                                                child: Text(
                                                  document['Title'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                            subtitle: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black45,
                                                ),
                                                child: Text(
                                                  document['Year'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                          ),
                                          ButtonBar(children: <Widget>[
                                            Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black26,
                                                ),
                                                child: IconButton(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  iconSize: 24,
                                                  icon: Icon(
                                                      Icons.delete_forever),
                                                  color: Colors.white,
                                                  onPressed: () {
                                                    Firestore.instance
                                                        .document(
                                                            "alreadyWatched/" +
                                                                document
                                                                    .documentID)
                                                        .delete()
                                                        .then((onValue) =>
                                                            _bloc.addMessage(
                                                                "deleted entry"))
                                                        .catchError((error) =>
                                                            _bloc.addMessage(
                                                                error));
                                                  },
                                                )),
                                          ]),
                                          // This gradient ensures that the toolbar icons are distinct
                                          // against the background image.
                                          const DecoratedBox(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment(0.0, -1.0),
                                                end: Alignment(0.0, -0.4),
                                                colors: <Color>[
                                                  Color(0x60000000),
                                                  Color(0x00000000)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ],
                                    )));
                          });
                  }
                })));
  }

  List<Widget> _children = [];

  void onTabTapped(int index) {
    tabBloc.updateIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    // Subscribe to UI feedback streams from  provided _bloc
    _uiErrorUtils.subscribeToSnackBarStream(context, _bloc.snackBarSubject);
    return StreamBuilder<Brightness>(
        stream: bloc.currentBrightness,
        builder: (BuildContext context, AsyncSnapshot<Brightness> snapshot) {
          return MaterialApp(
              title: "Watchlist",
              theme: ThemeData(
                // This is the theme of the application.
                brightness: snapshot.data,
              ),
              home: Scaffold(
                  appBar: new AppBar(
                      centerTitle: true,
                      title: _appBarTitle,
                      actions: <Widget>[
                        new IconButton(
                          icon: _searchIcon,
                          onPressed: _searchPressed,
                        ),
                      ]),
                  body: StreamBuilder(
                      stream: tabBloc.getIndex,
                      initialData: 3,
                      builder: (BuildContext context, AsyncSnapshot snapshot2) {
                        return IndexedStack(
                          index: snapshot2.data,
                          children: _children,
                        );
                      }),

                  // define the bottom tab navigaation bar
                  bottomNavigationBar: StreamBuilder(
                      initialData: 0,
                      stream: tabBloc.getIndex,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return BottomNavigationBar(
                          onTap: onTabTapped, // new
                          unselectedItemColor: Colors.black,
                          selectedItemColor: Colors.blue,
                          currentIndex: snapshot.data, // new
                          type: BottomNavigationBarType.fixed,
                          items: [
                            BottomNavigationBarItem(
                              icon: new Icon(Icons.list),
                              title: new Text(
                                'To Watch',
                              ),
                            ),
                            BottomNavigationBarItem(
                              icon: new Icon(Icons.alarm),
                              title: new Text(
                                'Completed',
                              ),
                            ),
                              BottomNavigationBarItem(
                              icon: new Icon(Icons.alarm),
                              title: new Text(
                                'Settings',
                              ),
                            ),
                          ],
                        );
                      })));
        });

  }
}
