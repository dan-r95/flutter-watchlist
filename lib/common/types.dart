import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArbitrarySuggestionType {
  //For the mock data type we will use review (perhaps this could represent a restaurant);
  String _imdbUrl;
  String _name, _imgURL;
  double _stars;
  String _year;
  String _id;
  DateTime _added;
  ArbitrarySuggestionType(this._stars, this._name, this._imgURL);

  ArbitrarySuggestionType.fromMappedJson(Map<String, dynamic> json)
      : _imdbUrl = json['imdbID'],
        _name = json['Title'],
        _imgURL = json['Poster'],
        _year = json['Year'];

  ArbitrarySuggestionType.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _name = snapshot.value['Title'];
    _imgURL = snapshot.value['Poster'];
    _year = snapshot.value['Year'];
    _imdbUrl = snapshot.value['imdbUrl'];
    _added = DateTime.fromMillisecondsSinceEpoch(snapshot.value['added']);
  }

  ArbitrarySuggestionType.fromDocument(DocumentSnapshot snapshot) {
    _id = snapshot.data['id'] as String;
    _name = snapshot.data['Title'];
    _imgURL = snapshot.data['Poster'];
    _year = snapshot.data['Year'];
    _imdbUrl = snapshot.data['imdbUrl'];
    _added = DateTime.fromMillisecondsSinceEpoch(snapshot.data['added']);
  }

  String get id => _id;
  double get stars => _stars;
  String get year => _year;
  String get name => _name;
  String get imdbUrl => _imdbUrl;
  String get imgURL => _imgURL;
  DateTime get added => _added;
}

// class which models the OPEN DB movie response
class MovieDescription {
  String title;
  String year;
  String rated;
  String released;
  String runtime;
  String genre;
  String director;
  String metascore;
  String imdbRating;
  String country;
  String actors;
  String plot;

  MovieDescription();

  MovieDescription.fromMappedJson(Map<String, dynamic> json)
      : title = json['Title'],
        year = json['Year'],
        rated = json['Rated'],
        released = json['Released'],
        runtime = json['Runtime'],
        genre = json['Genre'],
        director = json['Director'],
        metascore = json['Metascore'],
        imdbRating = json['imdbRating'],
        country = json['Country'],
        actors = json['Actors'],
        plot = json['Plot'];
}
