import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.app}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final FirebaseApp app;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class ArbitrarySuggestionType {
  //For the mock data type we will use review (perhaps this could represent a restaurant);
  String imdbUrl;
  String name, imgURL;
  double stars;
  String year;
  ArbitrarySuggestionType(this.stars, this.name, this.imgURL);

  ArbitrarySuggestionType.fromMappedJson(Map<String, dynamic> json)
      : imdbUrl = json['imdbID'],
        name = json['Title'],
        imgURL = json['Poster'],
        year = json['Year'];
}

class _MyHomePageState extends State<MyHomePage> {
  String currentText = "";

  List<ArbitrarySuggestionType> suggestions = [];

  bool loading = false;
  List<ArbitrarySuggestionType> favorites = [];

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

  _MyHomePageState() {
    textField = new AutoCompleteTextField<ArbitrarySuggestionType>(
      clearOnSubmit: true,
      submitOnSuggestionTap: true,
      suggestionsAmount: 5,
      textChanged: (value) => {updateSuggestions(value)},
      decoration: new InputDecoration(
          hintText: "Search IMDB:", suffixIcon: new Icon(Icons.search)),
      itemSubmitted: (item) => setState(() => selected = item),
      key: key,
      suggestions: suggestions,
      itemBuilder: (context, suggestion) => new Padding(
          child: new ListTile(
              title: new Text(suggestion.name),
              trailing: new Text("Stars: ${suggestion.year}")),
          padding: EdgeInsets.all(8.0)),
      //&itemSorter: (a, b) => a.stars == b.stars ? 0 : a.stars > b.stars ? -1 : 1,
      itemFilter: (suggestion, input) =>
          suggestion.name.toLowerCase().startsWith(input.toLowerCase()),
    );

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
                favorites.add(suggestions[index]);
              },
            )
          ]))
        ]));
      },
    );
  }

  Widget _buildFavoritesList() {
    return ListView.builder(
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
                setState(() {});
              },
            )
          ]))
        ]));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
              Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: _buildList()),
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
