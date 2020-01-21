import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_watchlist/common/bloc.dart';
import 'package:flutter_watchlist/common/types.dart';
import 'package:flutter_watchlist/movie_view/homepage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class InfoDialog extends StatelessWidget {
  final String url;
  final Bloc bloc;
  final List<ArbitrarySuggestionType> favorites;

  const InfoDialog(
      {Key key,
      @required this.url,
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

  Future<MovieDescription> getMovieDescription(String id) async {
    final response =
        await http.get("https://www.omdbapi.com/?i=$id&apikey=e83d3bc2");

    print(response.body);
    Map<String, dynamic> decoded = jsonDecode(response.body);
    print(decoded);
    if (decoded != null) {
      MovieDescription desc = MovieDescription.fromMappedJson(decoded);
      print(desc.title.toString());
      // setState(() {
      //suggestions = list;
      // });

      return desc;
    }
    return null;
  }

  final bool _enabled = true;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("All the details"),
      content: SingleChildScrollView(
          child: ListBody(children: <Widget>[
        FutureBuilder(
            builder: (BuildContext context,
                AsyncSnapshot<MovieDescription> snapshot) {
              if (snapshot.hasData) {
                return // new Card(
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  ListTile(
                    title: Text(snapshot.data.genre),
                    subtitle: Text(snapshot.data.imdbRating),
                  ),
                  Text(snapshot.data.metascore),
                  Text(snapshot.data.plot),
                  Text(snapshot.data.actors),
                  Text(snapshot.data.director),
                  Text("Metascore: ${snapshot.data.metascore}"),
                  Text(snapshot.data.runtime)
                ]);
                //Image.network(description., fit: BoxFit.scaleDown),
              } else {
                return Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    enabled: _enabled,
                    child: Column(
                      children: <int>[0, 1, 2, 3, 4, 5]
                          .map((_) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 48.0,
                                      height: 48.0,
                                      color: Colors.white,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: double.infinity,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                          ),
                                          Container(
                                            width: 40.0,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ))
                          .toList(),
                    ));
              }
            },
            future: getMovieDescription(this.url))

        // ]))
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
