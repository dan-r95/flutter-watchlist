import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_watchlist/common/bloc.dart';
import 'package:flutter_watchlist/common/types.dart';
import 'package:flutter_watchlist/movie_view/homepage.dart';
import 'package:flutter_watchlist/common/bloc.dart';

class DeleteMovieDialog extends StatelessWidget {
  const DeleteMovieDialog(
      {Key key,
      @required this.type,
      @required this.bloc,
      @required this.document})
      : super(key: key);

  final String type;
  final Bloc bloc;
  final DocumentSnapshot document;

  @override
  Widget build(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        type == 'favorites'
            ? Firestore.instance
                .document("favorites/" + document.documentID)
                .delete()
                .then((onValue) => bloc.addMessage("deleted entry"))
                .catchError((error) => bloc.addMessage(error))
            : Firestore.instance
                .document("alreadyWatched/" + document.documentID)
                .delete()
                .then((onValue) => bloc.addMessage("deleted entry"))
                .catchError((error) => bloc.addMessage(error));
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    // set up the AlertDialog
    return AlertDialog(
      title: Text("You will delete the movie from your favorites!"),
      content: Text("Delete?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
  }
}