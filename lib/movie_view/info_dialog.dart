import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_watchlist/common/bloc.dart';
import 'package:flutter_watchlist/common/justwatch.dart';
import 'package:flutter_watchlist/common/types.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_watchlist/api/justwatchManager.dart';
import 'package:flutter_watchlist/common/helpers.dart';

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
      //scrollable: true,
      title: Text("All the details"),
      content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ListBody(children: <Widget>[
            FutureBuilder(
                builder: (BuildContext context,
                    AsyncSnapshot<MovieDescription> snapshot) {
                  if (snapshot.hasData) {
                    return // new Card(
                        Column(mainAxisSize: MainAxisSize.min, children: <
                            Widget>[
                      ListTile(
                        trailing: IconButton(
                          icon: Icon(Icons.video_label),
                          onPressed: () => launchYT(snapshot.data.title),
                        ),
                        title: Text(snapshot.data.genre),
                        subtitle: Text(snapshot.data.imdbRating),
                      ),
                      Text(snapshot.data.metascore),
                      Text(snapshot.data.plot),
                      Text(snapshot.data.actors),
                      Text(snapshot.data.director),
                      Text("Metascore: ${snapshot.data.metascore}"),
                      Text(snapshot.data.runtime),
                      FutureBuilder(
                        builder: (BuildContext context,
                            AsyncSnapshot<JustWatchResponse> snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }
                          else if (snapshot.hasData && snapshot.data.offers != null &&  snapshot.data.offers.length > 0) {
                            snapshot.data.offers = snapshot.data.offers
                                .where((element) => (element.providerId == 8 ||
                                    element.providerId == 10 ||
                                    element.providerId == 29))
                                .toList();
                            return Column(
                              children: <Widget>[
                                ListTile(
                                    leading: Icon(Icons.info),
                                    subtitle: Text(snapshot
                                            .data.offers[0].retailPrice
                                            .toString() +
                                        snapshot.data.offers[0].currency +
                                        snapshot
                                            .data.offers[0].monetizationType),
                                    title: Text(companyList[
                                            snapshot.data.offers[0].providerId]
                                        .toString()),
                                    onTap: () => launchURL(snapshot
                                        .data.offers[0].urls.standardWeb)),
                                ListTile(
                                  leading: Icon(Icons.info),
                                  subtitle: Text(snapshot
                                          .data.offers[1].retailPrice
                                          .toString() +
                                      snapshot.data.offers[1].currency +
                                      snapshot.data.offers[1].monetizationType),
                                  title: Text(companyList[
                                          snapshot.data.offers[2].providerId]
                                      .toString()),
                                  onTap: () => launchURL(
                                      snapshot.data.offers[1].urls.standardWeb),
                                ),
                                ListTile(
                                    leading: Icon(Icons.info),
                                    subtitle: Text(snapshot
                                            .data.offers[2].retailPrice
                                            .toString() +
                                        snapshot.data.offers[2].currency +
                                        snapshot
                                            .data.offers[2].monetizationType),
                                    title: Text(companyList[
                                            snapshot.data.offers[2].providerId]
                                        .toString()),
                                    onTap: () => launchURL(snapshot
                                        .data.offers[2].urls.standardWeb)),
                              ],
                            );
                            //   child: ListView.builder(
                            //     itemCount: snapshot.data.offers.length,
                            //     scrollDirection: Axis.horizontal,
                            //     shrinkWrap: true,
                            //     itemBuilder: (context, index) => ListTile(
                            //         leading: Icon(Icons.info),
                            //         subtitle: Text(snapshot
                            //                 .data.offers[index].retailPrice
                            //                 .toString() +
                            //             snapshot
                            //                 .data.offers[index].currency),
                            //         title: Text(snapshot
                            //             .data.offers[index].providerId
                            //             .toString())),
                            //   ),
                            //   width:
                            //       MediaQuery.of(context).size.width * 0.9,
                            // );
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
                        future: apiManager.searchTitle(snapshot.data.title),
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
