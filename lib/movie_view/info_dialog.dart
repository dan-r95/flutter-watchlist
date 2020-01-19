import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_watchlist/common/bloc.dart';
import 'package:flutter_watchlist/common/types.dart';
import 'package:flutter_watchlist/movie_view/homepage.dart';

class InfoDialog extends StatelessWidget {
  final MovieDescription description;
  final Bloc bloc;
  final List<ArbitrarySuggestionType> favorites;

  const InfoDialog(
      {Key key,
      @required this.description,
      @required this.bloc,
      @required this.favorites})
      : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(description.title),
      content: SingleChildScrollView(
          child: ListBody(children: <Widget>[
        new Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
            title: Text(description.genre),
            subtitle: Text(description.imdbRating),
          ),
          Text(description.metascore),
          Text(description.plot),
          Text(description.actors),
          Text(description.director),
          Text("Metascore: ${description.metascore}"),
          Text(description.runtime)
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
  }
}
