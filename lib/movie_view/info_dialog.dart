import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:flutter_watchlist/common/bloc.dart';
import 'package:flutter_watchlist/common/types.dart';
import 'package:flutter_watchlist/api/justwatchManager.dart';
import 'package:flutter_watchlist/common/helpers.dart';
import 'package:flutter_watchlist/common/Movie.dart';
import 'package:flutter_watchlist/common/MovieDBProvider.dart';

class InfoDialog extends StatelessWidget {
  final String url;
  final Bloc bloc;
  final List<MovieSuggestion> favorites;

  const InfoDialog(
      {Key key,
      @required this.url,
      @required this.bloc,
      @required this.favorites})
      : super(key: key);

  Future<Movie> getMovieDescription(String id) async {
    final response = await http.get(new Uri.https(
        "api.themoviedb.org", "/3/movie/$id", {
      "api_key": "623ee3bd0e5c4882ac7411d102f1aeb6",
      "language": "de-DE"
    })); // "www.omdbapi.com/", "?i=$id&apikey=e83d3bc2"));

    Map<String, dynamic> decoded = jsonDecode(response.body);
    if (decoded != null) {
      Movie desc = Movie.fromJson(decoded);
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
      //scrollable: true,
      title: Text("All the details"),
      content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ListBody(children: <Widget>[
            FutureBuilder(
                builder: (BuildContext context, AsyncSnapshot<Movie> snapshot) {
                  if (snapshot.hasData) {
                    return // new Card(
                        Column(mainAxisSize: MainAxisSize.min, children: <
                            Widget>[
                      ListTile(
                        trailing: IconButton(
                          icon: Icon(Icons.video_label),
                          onPressed: () => launchYT(snapshot.data.title),
                        ),
                        title: Text(snapshot.data.title),
                        subtitle: Text(snapshot.data.popularity.toString()),
                      ),
                      Text(snapshot.data.runtime.toString()),
                      Text(snapshot.data.voteAverage.toString()),
                      Text(snapshot.data.overview),
                      // Text(snapshot.data.director),
                      // Text("Metascore: ${snapshot.data.metascore}"),
                      // Text(snapshot.data.runtime),
                      FutureBuilder(
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Flatrate>> snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasData &&
                              snapshot.data.length > 0) {
                            //   &&
                            //   snapshot.data.offers.length > 0) {
                            // snapshot.data.list = snapshot.data.offers
                            //     .where((element) => (element.providerId == 8 ||
                            //         element.providerId == 10 ||
                            //         element.providerId == 29))
                            //     .toList();
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  //                               CachedNetworkImage(
                                  //   imageUrl: "http://via.placeholder.com/200x150",
                                  //   imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider,),
                                  //   placeholder: (context, url) => CircularProgressIndicator(),
                                  //   errorWidget: (context, url, error) => Icon(Icons.error),
                                  // );
                                  return ListView.builder(
                                      itemCount: snapshot.data.length,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) => ListTile(
                                            leading: CircleAvatar(
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                              snapshot.data[index].providerName,
                                            )),
                                            // no matter how big it is, it won't overflow

                                            subtitle: Text("aa"),
                                            //  Text(snapshot
                                            //         .data[index].providerName
                                            //         .toString() +
                                            //     snapshot.data[index].logoPath
                                            //         .toString()),
                                            title: Text("aa"),

                                            // Text(snapshot
                                            // .data[index].providerName
                                            // .toString())),
                                          ));
                                });
                          } else {
                            return Shimmer.fromColors(
                                baseColor: Colors.grey[300],
                                highlightColor: Colors.grey[100],
                                enabled: _enabled,
                                child: Column(
                                  children: <int>[0, 1]
                                      .map((_) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 48.0,
                                                  height: 48.0,
                                                  color: Colors.white,
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Container(
                                                        width: double.infinity,
                                                        height: 8.0,
                                                        color: Colors.white,
                                                      ),
                                                      const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 2.0),
                                                      ),
                                                      Container(
                                                        width: double.infinity,
                                                        height: 8.0,
                                                        color: Colors.white,
                                                      ),
                                                      const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
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
                        future: apiManager.searchTitle(snapshot.data.id),
                      )
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 48.0,
                                          height: 48.0,
                                          color: Colors.white,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
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
