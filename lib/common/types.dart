import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

Map<int, String> companyList = {8: "Netflix", 10: "Amazon", 29: "Sky"};

//TODO: use https://pub.dev/packages/json_serializable

class MovieSuggestion {
  //For the mock data type we will use review (perhaps this could represent a restaurant);
  String? _imdbUrl;
  String? _name, _imgURL;
  double? _stars;
  String? _year;
  String? _id;
  String? _type;
  DateTime? _added;
  MovieSuggestion(this._stars, this._name, this._imgURL);

  MovieSuggestion.fromMappedJson(Map<String, dynamic> json) {
    _imdbUrl = json['imdbID'] ?? "";
    _name = json['Title'] ?? "";
    _imgURL = json['Poster'] ?? "";
    _year = json['Year'] ?? "";
    _type = json['Type'] ?? "";
  }

  MovieSuggestion.fromSnapshot(DataSnapshot snapshot) {
    if (snapshot.value is List) {
      final value = snapshot.value as Map;
      _id = snapshot.key;
      _name = value['Title'] ?? "";
      _imgURL = value['Poster'] ?? "";
      _year = value['Year'] ?? "";
      _imdbUrl = value['imdbUrl'] ?? "";
      _added = DateTime.fromMillisecondsSinceEpoch(value['added']);
    }
  }

  MovieSuggestion.fromDocument(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    _id = data['id'] as String;
    _name = data['Title'] ?? "";
    _imgURL = data['Poster'] ?? "";
    _year = data['Year'] ?? "";
    _imdbUrl = data['imdbUrl'] ?? "";
    _added = DateTime.fromMillisecondsSinceEpoch(data['added']);
  }

  String get id => _id!;
  double get stars => _stars ?? 0;
  String get year => _year!;
  String get type => _type!;
  String get name => _name!;
  String get imdbUrl => _imdbUrl!;
  String get imgURL => _imgURL!;
  DateTime get added => _added!;
}

// class which models the OPEN DB movie response
class MovieDescription {
  String? title;
  String? year;
  String? rated;
  String? released;
  String? runtime;
  String? genre;
  String? director;
  String? metascore;
  String? imdbRating;
  String? country;
  String? actors;
  String? plot;

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
