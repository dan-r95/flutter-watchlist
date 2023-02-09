import 'dart:async';
import 'dart:convert';
import 'package:flutter_watchlist/movie_view/already_watched.dart';
import 'package:flutter_watchlist/movie_view/fab_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_watchlist/movie_view/favorites.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_watchlist/common/snackbar.dart';
import 'package:flutter_watchlist/common/bloc.dart';
import 'package:flutter_watchlist/common/types.dart';
import 'package:flutter_watchlist/common/tab_bloc.dart';
// import 'package:appcenter/appcenter.dart';
// import 'package:appcenter_analytics/appcenter_analytics.dart';
// import 'package:appcenter_crashes/appcenter_crashes.dart';
import 'package:flutter_watchlist/movie_view/add_movie_dialog.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {Key? key, required this.title, this.app, this.uiErrorUtils, this.uuid})
      : super(key: key);

  final String title;
  final String? uuid;
  final FirebaseApp? app;
  final UiErrorUtils? uiErrorUtils;

  @override
  _HomePageState createState() => _HomePageState(
        uiErrorUtils: errorUtils,
        bloc: bloc,
      );
}

class _HomePageState extends State<HomePage> {
  String currentText = "";

  List<MovieSuggestion> suggestions = [];

  bool loading = false;
  List<MovieSuggestion> favorites = [];
  StreamSubscription<DatabaseEvent>? _onNoteAddedSubscription;
  StreamSubscription<DatabaseEvent>? _onNoteChangedSubscription;
  StreamSubscription<DatabaseEvent>? _onNoteRemovedSubscription;
  final notesReference = FirebaseDatabase.instance.ref();
  UiErrorUtils? _uiErrorUtils;
  Bloc _bloc = bloc;

  List<MovieSuggestion> alreadyWatched = [];

  @override
  void initState() {
    super.initState();
    favorites = [];

    _onNoteAddedSubscription = notesReference.onChildAdded.listen(_onNoteAdded);
    _onNoteChangedSubscription =
        notesReference.onChildChanged.listen(_onNoteUpdated);
    _onNoteRemovedSubscription = notesReference.onChildRemoved.listen(null);

    _children.addAll([
      FavoritesList(widget.uuid!, bloc),
      AlreadyWatchedList(widget.uuid!, bloc),
    ]);
  }

  @override
  void dispose() {
    _onNoteAddedSubscription?.cancel();
    super.dispose();
    _onNoteChangedSubscription?.cancel();
  }

  void _onNoteAdded(DatabaseEvent event) {
    setState(() {
      favorites.add(new MovieSuggestion.fromSnapshot(event.snapshot));
    });
  }

  void _onNoteUpdated(DatabaseEvent event) {
    var oldNoteValue =
        favorites.singleWhere((note) => note.id == event.snapshot.key);
    setState(() {
      favorites[favorites.indexOf(oldNoteValue)] =
          new MovieSuggestion.fromSnapshot(event.snapshot);
    });
  }

  Future<List<MovieSuggestion>> updateSuggestions(String query) async {
    List<MovieSuggestion> list = [];
    if (query.length > 2) {
      setState(() {
        loading = true;
      });
      // trim whitespaces
      query = query.trim();
      var response = await http.get(
          new Uri.https("omdbapi.com", "", {"s": query, "apikey": "e83d3bc2"}));

      //print(response.body);
      List decoded = jsonDecode(response.body)['Search'];
      //print(decoded);
      List<MovieSuggestion> listOtherSugg = [];
      if (decoded != null) {
        listOtherSugg =
            decoded.map((m) => MovieSuggestion.fromMappedJson(m)).toList();
      }
      response = await http.get(
          new Uri.https("omdbapi.com", "", {"t": query, "apikey": "e83d3bc2"}));

      Map<String, dynamic> decodedMap = jsonDecode(response.body);

      if (decoded != null) {
        MovieSuggestion item = MovieSuggestion.fromMappedJson(decodedMap);
        //print(item.toString());
        list.add(item);
        list.addAll(listOtherSugg);

        //print(list.length);
        setState(() {
          loading = false;
        });
        return list;
      }
    }
    return list;
  }

  MovieSuggestion? selected;

  _HomePageState({required Bloc bloc, required UiErrorUtils uiErrorUtils}) {
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

    _bloc = bloc;
    _uiErrorUtils = uiErrorUtils;
  }

  final TextEditingController _filter = new TextEditingController();
  //final dio = new Dio();
  String _searchText = "";
  List names = [];
  List filteredNames = [];
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Watchlist');

  MovieDescription? description;

  void _searchPressed() {
    print("search pressed");
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
          itemBuilder: (context, MovieSuggestion suggestion) {
            //print(suggestion.toString());
            return Listener(
              child: ListTile(
                leading: Icon(Icons.movie),
                title: Text(suggestion.name ?? ''),
                subtitle: Text(
                    '${suggestion.year ?? ''} / ${suggestion.stars ?? ''}'),
              ),
              onPointerDown: (_) => showAddDialog(context, suggestion),
            );
          },
          onSuggestionSelected: (MovieSuggestion suggestion) {
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
  showAddDialog(BuildContext context, MovieSuggestion suggestion) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!

      builder: (BuildContext context) {
        return AddMovieDialog(
          suggestion: suggestion,
          bloc: _bloc,
          favorites: favorites,
          uuid: widget.uuid!,
        );
      },
    );
  }

  List<Widget> _children = [];

  void onTabTapped(int index) {
    tabBloc.updateIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    // Subscribe to UI feedback streams from  provided _bloc
    _uiErrorUtils?.subscribeToSnackBarStream(context, _bloc.snackBarSubject);

    return Scaffold(
        appBar: new AppBar(
            leading: new IconButton(
              icon: _searchIcon,
              onPressed: _searchPressed,
            ),
            centerTitle: true,
            title: _appBarTitle,
            actions: <Widget>[
              new IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/profile')),
            ]),
        body: Container(
            margin: MediaQuery.of(context).size.width > 1400
                ? EdgeInsets.fromLTRB(200, 0, 30, 200)
                : EdgeInsets.all(0),
            child: Builder(
              builder: (context) {
                _uiErrorUtils?.subscribeToSnackBarStream(
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
              },
            )),
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
