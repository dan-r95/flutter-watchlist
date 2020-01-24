import 'dart:async';
import 'dart:convert';
import 'package:flutter_watchlist/movie_view/delete_dialog.dart';
import 'package:flutter_watchlist/movie_view/fab_appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_watchlist/settings/settings.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_watchlist/common/snackbar.dart';
import 'package:flutter_watchlist/common/bloc.dart';
import 'package:flutter_watchlist/common/types.dart';
import 'package:flutter_watchlist/common/tab_bloc.dart';
// import 'package:appcenter/appcenter.dart';
// import 'package:appcenter_analytics/appcenter_analytics.dart';
// import 'package:appcenter_crashes/appcenter_crashes.dart';
import 'package:flutter_watchlist/movie_view/info_dialog.dart';
import 'package:flutter_watchlist/movie_view/add_movie_dialog.dart';

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
    // notesReference.reference().once().then((DataSnapshot snapshot) {
    //   print('Connected to second database and read ${snapshot.value}');
    // });
    favorites = new List();
    _onNoteAddedSubscription = notesReference.onChildAdded.listen(_onNoteAdded);
    // _onNoteChangedSubscription =
    //    notesReference.onChildChanged.listen(_onNoteUpdated);

    _children.addAll(
        [_buildFavoritesList(), _buildCompletedList(), SettingsRoute(title: widget.title)]);
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

  Future<List<ArbitrarySuggestionType>> updateSuggestions(String query) async {
    List<ArbitrarySuggestionType> list = new List<ArbitrarySuggestionType>();
    if (query.length > 2) {
      setState(() {
        loading = true;
      });
      // trim whitespaces
      query = query.trim();
      var response =
          await http.get("https://www.omdbapi.com/?s=$query&apikey=e83d3bc2");

      //print(response.body);
      List decoded = jsonDecode(response.body)['Search'];
      //print(decoded);
      List<ArbitrarySuggestionType> listOtherSugg =
          new List<ArbitrarySuggestionType>();
      if (decoded != null) {
        listOtherSugg = decoded
            .map((m) => ArbitrarySuggestionType.fromMappedJson(m))
            .toList();
      }
      response =
          await http.get("https://www.omdbapi.com/?t=$query&apikey=e83d3bc2");

      //print(response.body);
      Map<String, dynamic> decodedMap = jsonDecode(response.body);
      //print(decoded);

      if (decoded != null) {
        ArbitrarySuggestionType item =
            ArbitrarySuggestionType.fromMappedJson(decodedMap);
        list.add(item);
        list.addAll(listOtherSugg);

        setState(() {
          loading = false;
        });
        return list;
      }
    }
    return list;
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
        .catchError((err) => (bloc.addMessage(err)));
    favorites.add(item);
  }

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
              leading: Icon(Icons.movie),
              title: Text(suggestion.name),
              subtitle: Text('${suggestion.year} / ${suggestion.stars}'),
            );
          },
          onSuggestionSelected: (suggestion) {
            showAddDialog(context, suggestion);
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
  showAddDialog(BuildContext context, ArbitrarySuggestionType suggestion) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!

      builder: (BuildContext context) {
        return AddMovieDialog(
            suggestion: suggestion, bloc: _bloc, favorites: favorites);
      },
    );
  }

  //TODO use https://pub.dev/packages/flutter_typeahead
  showInfoDialog(BuildContext context, String url) {
    //print(description.title);
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!

      builder: (BuildContext context) {
        return InfoDialog(bloc: _bloc, url: url, favorites: favorites);
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
                                    content: Text("added to already watched")));
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
                                        imageUrl: document['Poster'] == "N/A"
                                            ? "https://moviereelist.com/wp-content/uploads/2019/07/poster-placeholder.jpg"
                                            : document['Poster'],
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.7),
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
                                              onPressed: () => {
                                                    showInfoDialog(context,
                                                        document['imdbUrl']),
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
                                                icon:
                                                    Icon(Icons.delete_forever),
                                                color: Colors.white,
                                                onPressed: () {
                                                  showAlertDialog(context,
                                                      'favorites', document);
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
                                  )),
                              background: Container(
                                  color: Colors.green,
                                  child: Icon(Icons.check)),
                            );
                          });
                  }
                })));
  }

  Widget _buildCompletedList() {
    return Center(
        child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('alreadyWatched')
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
                          itemBuilder: (BuildContext context2, int index) {
                            if (snapshot.data.documents.length == 0) {
                              return Text("start adding movies!");
                            }
                            var document = snapshot.data.documents[index];

                            return new Dismissible(
                                key: UniqueKey(),
                                onDismissed: (direction) {},
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
                                          placeholder: (context2, url) =>
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
                                                onPressed: () => {
                                                      showInfoDialog(context2,
                                                          document['imdbUrl'])
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
                                                    showAlertDialog(context2,
                                                        'completed', document);
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

  showAlertDialog(
      BuildContext context, String type, DocumentSnapshot document) {
    // set up the buttons

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteMovieDialog(bloc: bloc, document: document, type: type);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Subscribe to UI feedback streams from  provided _bloc
    _uiErrorUtils.subscribeToSnackBarStream(context, _bloc.snackBarSubject);

    return Scaffold(
        appBar: new AppBar(
            leading: new IconButton(
              icon: _searchIcon,
              onPressed: null,
            ),
            centerTitle: true,
            title: _appBarTitle,
            actions: <Widget>[
              new IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () => tabBloc.updateIndex(2)),
            ]),
        body: Builder(builder: (context) {
          _uiErrorUtils.subscribeToSnackBarStream(
              context, bloc.snackBarSubject);
          return StreamBuilder(
              stream: tabBloc.getIndex,
              initialData: 0,
              builder: (BuildContext context, AsyncSnapshot snapshot2) {
                return IndexedStack(
                  index: snapshot2.data,
                  children: _children,
                );
              });
        }),

        // define the bottom tab navigaation bar
        bottomNavigationBar: StreamBuilder(
            initialData: 0,
            stream: tabBloc.getIndex,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return FABBottomAppBar(
                //centerItemText: 'A',
                color: Colors.grey,
                selectedColor: Colors.red,
                notchedShape: CircularNotchedRectangle(),
                onTabSelected: (i) => tabBloc.updateIndex(i),
                items: [
                  FABBottomAppBarItem(iconData: Icons.movie, text: 'Watchlist'),
                  FABBottomAppBarItem(
                      iconData: Icons.done, text: 'Already Seen'),
                  // FABBottomAppBarItem(
                  //     iconData: Icons.settings, text: 'Settings'),
                ],
              );
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: _searchPressed, // show search bar
        ));

  }

}

