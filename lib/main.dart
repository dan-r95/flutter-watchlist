import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

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
  ArbitrarySuggestionType(this.stars, this.name, this.imgURL);
}

class _MyHomePageState extends State<MyHomePage> {
  String currentText = "";




  List<ArbitrarySuggestionType> suggestions = [
    new ArbitrarySuggestionType(4.7, "Minamishima",
        "https://media-cdn.tripadvisor.com/media/photo-p/0f/25/de/0c/photo1jpg.jpg"),
    new ArbitrarySuggestionType(1.5, "The Meat & Wine Co Hawthorn East",
        "https://media-cdn.tripadvisor.com/media/photo-s/12/ba/7d/4c/confit-cod-chorizo-red.jpg"),
    new ArbitrarySuggestionType(3.4, "Florentino",
        "https://media-cdn.tripadvisor.com/media/photo-s/12/fc/bb/11/from-the-street.jpg"),
    new ArbitrarySuggestionType(
        4.3,
        "Syracuse Restaurant & Winebar Melbourne CBD",
        "https://media-cdn.tripadvisor.com/media/photo-p/07/ad/76/b0/the-gyoza-had-a-nice.jpg"),
    new ArbitrarySuggestionType(1.1, "Geppetto Trattoria",
        "https://media-cdn.tripadvisor.com/media/photo-s/0c/85/3d/cb/photo1jpg.jpg"),
    new ArbitrarySuggestionType(3.4, "Cumulus Inc.",
        "https://media-cdn.tripadvisor.com/media/photo-s/0e/21/a0/be/photo0jpg.jpg"),
    new ArbitrarySuggestionType(2.2, "Chin Chin",
        "https://media-cdn.tripadvisor.com/media/photo-s/0e/83/ec/07/triple-beef-triple-bacon.jpg"),
    new ArbitrarySuggestionType(5.0, "Anchovy",
        "https://media-cdn.tripadvisor.com/media/photo-s/07/e7/f6/8e/daneli-s-kosher-deli.jpg"),
    new ArbitrarySuggestionType(4.7, "Sezar Restaurant",
        "https://media-cdn.tripadvisor.com/media/photo-s/04/b8/23/d1/nevsky-russian-restaurant.jpg"),
    new ArbitrarySuggestionType(2.6, "Tipo 00",
        "https://media-cdn.tripadvisor.com/media/photo-s/11/17/67/8c/front-seats.jpg"),
    new ArbitrarySuggestionType(3.4, "Coda",
        "https://media-cdn.tripadvisor.com/media/photo-s/0d/b1/6a/84/photo0jpg.jpg"),
    new ArbitrarySuggestionType(1.1, "Pastuso",
        "https://media-cdn.tripadvisor.com/media/photo-w/0a/d9/cf/52/photo4jpg.jpg"),
    new ArbitrarySuggestionType(0.2, "San Telmo",
        "https://media-cdn.tripadvisor.com/media/photo-s/0e/51/35/35/tempura-sashimi-combo.jpg"),
    new ArbitrarySuggestionType(3.6, "Supernormal",
        "https://media-cdn.tripadvisor.com/media/photo-s/0e/bc/63/69/mr-miyagi.jpg"),
    new ArbitrarySuggestionType(4.4, "EZARD",
        "https://media-cdn.tripadvisor.com/media/photo-p/09/f2/83/15/photo0jpg.jpg"),
    new ArbitrarySuggestionType(2.1, "Maha",
        "https://media-cdn.tripadvisor.com/media/photo-s/10/f8/9e/af/20171013-205729-largejpg.jpg"),
    new ArbitrarySuggestionType(4.2, "MoVida",
        "https://media-cdn.tripadvisor.com/media/photo-s/0e/1f/55/79/and-here-we-go.jpg")
  ];

   GlobalKey key =
      new GlobalKey<AutoCompleteTextFieldState<ArbitrarySuggestionType>>();

  AutoCompleteTextField<ArbitrarySuggestionType> textField;

  ArbitrarySuggestionType selected;

  _MyHomePageState() {
    textField = new AutoCompleteTextField<ArbitrarySuggestionType>(
      decoration: new InputDecoration(
          hintText: "Search Resturant:", suffixIcon: new Icon(Icons.search)),
      itemSubmitted: (item) => setState(() => selected = item),
      key: key,
      suggestions: suggestions,
      itemBuilder: (context, suggestion) => new Padding(
          child: new ListTile(
              title: new Text(suggestion.name),
              trailing: new Text("Stars: ${suggestion.stars}")),
          padding: EdgeInsets.all(8.0)),
      itemSorter: (a, b) => a.stars == b.stars ? 0 : a.stars > b.stars ? -1 : 1,
      itemFilter: (suggestion, input) =>
          suggestion.name.toLowerCase().startsWith(input.toLowerCase()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text('AutoComplete TextField Demo Complex'),
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
                            trailing: new Text("Rating: ${selected.stars}/5")),
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
