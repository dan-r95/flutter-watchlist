import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_watchlist/common/types.dart';

// void pushToDB(ArbitrarySuggestionType item, String dbName) {
//     print("will push");
//     Firestore.instance
//         .collection(dbName)
//         .add({
//           'Title': item.name,
//           'Poster': item.imgURL,
//           'Year': item.year,
//           'imdbUrl': item.imdbUrl,
//           'added': DateTime.now().millisecondsSinceEpoch, //Unix timestamp
//         })
//         .then((result) => {})
//         .catchError((err) => (_bloc.addMessage(err)));
//     favorites.add(item);
//   }
