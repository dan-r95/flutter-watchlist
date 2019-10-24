import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

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

  void updateSuggestions(String query) async {
    if (query.length > 2) {
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
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text('My Watchlist'),
      ),
      body: new Column(children: [
        new Padding(
            child: new Container(child: textField),
            padding: EdgeInsets.all(16.0)),
        new Padding(
            padding: EdgeInsets.fromLTRB(0.0, 64.0, 0.0, 0.0),
            child: new Card(
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
                    : new Icon(Icons.cancel))),
      ]),
    );
  }
}
