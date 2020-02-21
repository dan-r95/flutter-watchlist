import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_watchlist/common/bloc.dart';
import 'package:flutter_watchlist/common/types.dart';

class AddMovieDialog extends StatelessWidget {
  final MovieSuggestion suggestion;
  final Bloc bloc;
  final List<MovieSuggestion> favorites;
  final String uuid;

  const AddMovieDialog(
      {Key key,
      @required this.suggestion,
      @required this.uuid,
      @required this.bloc,
      @required this.favorites})
      : super(key: key);

  void pushToDB(MovieSuggestion item, String dbName, String uuid) {
    print("will push");
    Firestore.instance
        .collection(dbName)
        .add({
          'user': uuid,
          'Title': item.name,
          'Poster': item.imgURL,
          'Year': item.year,
          'imdbUrl': item.imdbUrl,
          'added': DateTime.now().millisecondsSinceEpoch, //Unix timestamp
        })
        .then((result) => { print(result)})
        .catchError((err) => (bloc.addMessage(err)));
    favorites.add(item);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add new movie?'),
      content: SingleChildScrollView(
          child: ListBody(children: <Widget>[
        new Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
            title: Text(suggestion.name),
            subtitle: Text(suggestion.year),
            onTap: () => print(suggestion.imgURL),
          ),
          CachedNetworkImage(
            placeholder: (context2, url) => CircularProgressIndicator(),
            imageUrl: suggestion.imgURL,

            fit: BoxFit.cover,
            // width: context.size.width,
            height: MediaQuery.of(context).size.height / 2,
            // context.size.height / 4,
          ),
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
                    pushToDB(suggestion, 'favorites', this.uuid);
                    Navigator.pop(context);
                    // setState(() {
                    //   if (this._searchIcon.icon == Icons.search) {
                    //     this._searchIcon = new Icon(Icons.close);
                    //     this._appBarTitle = new Text('Watchlist');
                    //   }
                    // });
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
  }
}
