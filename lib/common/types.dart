import 'package:cloud_firestore/cloud_firestore.dart';

Map<int, String> companyList = {8: "Netflix", 10: "Amazon", 29: "Sky"};

class MovieSuggestion {
  //For the mock data type we will use review (perhaps this could represent a restaurant);
  String _imdbUrl;
  String _name, _imgURL;
  double _stars;
  String _year;
  String _id;
  DateTime _added;
  MovieSuggestion(this._stars, this._name, this._imgURL);

  MovieSuggestion.fromMappedJson(Map<String, dynamic> json)
      : _imdbUrl = json['imdbID'],
        _name = json['Title'],
        _imgURL = json['Poster'],
        _year = json['Year'];

/*
  MovieSuggestion.fromSnapshot(DataSnapshot snapshot) {
    if (snapshot.value is List) {
      _id = snapshot.key;
      _name = snapshot.value?.Title;
      _imgURL = snapshot.value['Poster'];
      _year = snapshot.value['Year'];
      _imdbUrl = snapshot.value['imdbUrl'];
      _added = DateTime.fromMillisecondsSinceEpoch(snapshot.value['added']);
    }
  }
*/

  MovieSuggestion.fromDocument(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    _id = data['id'] as String;
    _name = data['Title'];
    _imgURL = data['Poster'];
    _year = data['Year'];
    _imdbUrl = data['imdbUrl'];
    _added = DateTime.fromMillisecondsSinceEpoch(data['added']);
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
