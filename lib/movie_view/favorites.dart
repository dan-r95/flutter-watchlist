import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_watchlist/common/bloc.dart';
import 'package:flutter_watchlist/common/helpers.dart';
import 'package:flutter_watchlist/common/types.dart';

class FavoritesList extends StatelessWidget {
  String uuid;
  Bloc bloc;
  FavoritesList(this.uuid, this.bloc);

  void _move(QueryDocumentSnapshot<Object?>? document, BuildContext context) {
    print(document);

    List<MovieSuggestion> list = bloc.alreadyWatchedListController.value;
    list.add(MovieSuggestion.fromDocument(document!));
    bloc.writeToalreadyWatched.add(list);

    pushToDB(MovieSuggestion.fromDocument(document), 'alreadyWatched', uuid);
    FirebaseFirestore.instance
        .collection('favorites')
        .doc(document.id)
        .delete();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("added to already watched")));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("favorites")
                    .where("user", isEqualTo: this.uuid)
                    .orderBy("added", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Container(
                        height: 200,
                        width: 200,
                        child: FlareActor("assets/animations/loading.flr",
                            animation: "roll"),
                      );
                    default:
                      //print(snapshot.data?.docs);
                      if (snapshot.data?.docs.length == 0) {
                        return Container(
                            height: 200,
                            width: 200,
                            child: Column(
                              children: [
                                Text("no movies added yet 😫"),
                                FlareActor("assets/animations/loading.flr",
                                    animation: "roll"),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ));
                      }
                      return new GridView.builder(
                          shrinkWrap: true,
                          gridDelegate: MediaQuery.of(context).size.width > 1000
                              ? SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  crossAxisSpacing: 2.0,
                                  mainAxisSpacing: 2.0)
                              : SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 2.0,
                                  mainAxisSpacing: 2.0),
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (snapshot.data?.docs.length == 0) {
                              return Text("start adding movies!");
                            }
                            var document = snapshot.data?.docs[index];

                            return new Dismissible(
                              key: UniqueKey(),
                              onDismissed: (direction) {
                                _move(document, context);
                              },
                              child: Card(
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5,
                                  margin: EdgeInsets.all(10),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      new Positioned.fill(
                                          child: Image.network(
                                        // placeholder: (context, url) =>
                                        //     CircularProgressIndicator(),
                                        document?['Poster'] == "N/A"
                                            ? "https://moviereelist.com/wp-content/uploads/2019/07/poster-placeholder.jpg"
                                            : document?['Poster'],
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.7),
                                        colorBlendMode: BlendMode.modulate,
                                        fit: BoxFit.cover,
                                        // width: context.size.width,
                                        // height: context.size.height / 4,
                                      )),
                                      // This gradient ensures that the toolbar icons are distinct
                                      // against the background image.
                                      Column(
                                        children: <Widget>[
                                          ListTile(
                                            contentPadding:
                                                EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            leading: IconButton(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                                iconSize: 26,
                                                icon: Icon(Icons.info),
                                                color: Colors.white,
                                                onPressed: () => {
                                                      showInfoDialog(
                                                          context,
                                                          document?['imdbUrl'],
                                                          bloc),
                                                    }),
                                            title: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black45,
                                                ),
                                                child: Text(
                                                  document?['Title'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                            subtitle: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black45,
                                                ),
                                                child: Text(
                                                  document?['Year'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                          ),
                                          ButtonBar(children: <Widget>[
                                            Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black26,
                                                ),
                                                child: IconButton(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  iconSize: 24,
                                                  icon: Icon(
                                                      Icons.delete_forever),
                                                  color: Colors.red,
                                                  onPressed: () {
                                                    showAlertDialog(context,
                                                        'favorites', document!);
                                                  },
                                                )),
                                            Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black26,
                                                ),
                                                child: IconButton(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  iconSize: 24,
                                                  icon: Icon(Icons
                                                      .move_to_inbox_outlined),
                                                  color: Colors.white,
                                                  onPressed: () {
                                                    _move(document, context);
                                                  },
                                                )),
                                          ]),
                                          // This gradient ensures that the toolbar icons are distinct
                                          // against the background image.
                                          const DecoratedBox(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment(0.0, -1.0),
                                                end: Alignment(0.0, -0.4),
                                                colors: <Color>[
                                                  Color(0x60000000),
                                                  Color(0x00000000)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                      ),
                                    ],
                                  )),
                              background: Container(
                                  color: Colors.green,
                                  child: Icon(Icons.check)),
                            );
                          });
                  }
                })));
  }
}
