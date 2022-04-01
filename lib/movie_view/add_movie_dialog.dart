import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_watchlist/common/bloc.dart';
import 'package:flutter_watchlist/common/helpers.dart';
import 'package:flutter_watchlist/common/types.dart';

class AddMovieDialog extends StatelessWidget {
  final MovieSuggestion suggestion;
  final Bloc bloc;
  final List<MovieSuggestion> favorites;
  final String uuid;

  const AddMovieDialog(
      {Key? key, this.suggestion, this.uuid, this.bloc, this.favorites})
      : super(key: key);

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
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            imageUrl: suggestion.imgURL,
            errorWidget: (context, url, error) => new Icon(Icons.error),
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
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
