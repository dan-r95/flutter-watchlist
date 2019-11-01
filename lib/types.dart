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
