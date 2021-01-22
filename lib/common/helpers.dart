import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_watchlist/common/bloc.dart';
import 'package:flutter_watchlist/common/types.dart';
import 'package:flutter_watchlist/movie_view/delete_dialog.dart';
import 'package:flutter_watchlist/movie_view/info_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent/android_intent.dart';

void launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

void launchYT(url) async {
  if (Platform.isAndroid) {
    try {
      final AndroidIntent intent = AndroidIntent(
          action: 'ACTION_SEARCH',
          arguments: {"query": url},
          data: 'com.google.android.youtube');
      print(intent.toString());
      await intent.launch();
    } catch (error) {}
  }
}

//TODO use https://pub.dev/packages/flutter_typeahead
showInfoDialog(BuildContext context, String url, Bloc _bloc) {
  //print(description.title);
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!

    builder: (BuildContext context) {
      return InfoDialog(
          bloc: _bloc, url: url, favorites: bloc.favoritesListController.value);
    },
  );
}

showAlertDialog(BuildContext context, String type, DocumentSnapshot document) {
  // set up the buttons

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DeleteMovieDialog(bloc: bloc, document: document, type: type);
    },
  );
}

void pushToDB(MovieSuggestion item, String dbName, String uuid) {
  print("will push");
  print("will push");
  FirebaseFirestore.instance
      .collection(dbName)
      .add({
        'user': uuid,
        'Title': item.name,
        'Poster': item.imgURL,
        'Year': item.year,
        'imdbUrl': item.imdbUrl,
        'added': DateTime.now().millisecondsSinceEpoch, //Unix timestamp
      })
      .then((result) => {print(result)})
      .catchError((err) => (bloc.addMessage(err)));
  List<MovieSuggestion> list = bloc.favoritesListController.value;
  list.add(item);
  bloc.writeToFavorites.add(list);
}
