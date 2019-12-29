import 'package:firebase_database/firebase_database.dart';

class ArbitrarySuggestionType {
  //For the mock data type we will use review (perhaps this could represent a restaurant);
  String _imdbUrl;
  String _name, _imgURL;
  double _stars;
  String _year;
  String _id;
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
  }

  String get id => _id;
  double get stars => _stars;
  String get year => _year;
  String get name => _name;
  String get imdbUrl => _imdbUrl;
  String get imgURL => _imgURL;
}

class MovieDescription {
  String title;
  String year;
  double rated;
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
      : title = json['title'],
        year = json['year'],
        rated = json['rated'],
        released = json['released'],
        runtime = json['runtime'],
        genre = json['genre'],
        director = json['director'],
        metascore = json['metascore'],
        imdbRating = json['imdbRating'],
        country = json['country'],
        actors = json['actors'],
        plot = json['plot'];
}
