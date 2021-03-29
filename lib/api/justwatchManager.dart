import 'package:flutter_watchlist/common/justwatch.dart';
import 'package:flutter_watchlist/common/justwatch_movie.dart';
import 'package:flutter_watchlist/common/MovieDBProvider.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

const movieURL = "apis.justwatch.com/";

class JustWatchManager {
  getMovie(int id) async {
    var response = await http
        .get(new Uri.https(movieURL, "content/titles/movie/$id/locale/de_DE"));
    return JustWatchResponse.fromJson(jsonDecode(response.body));
  }

  Future<JustWatchResponse> getAvailability(int id) async {
    JustWatchResponse movieResponse = await getMovie(id);
    print(movieResponse.toString());
    if (movieResponse.offers != null) {
      for (var company in movieResponse.offers) {
        if (company.providerId == 10 ||
            company.providerId == 8 ||
            company.providerId == 29)
          print("available on: ${company.urls}, id:, ${company.providerId}");
      }
    }
    return movieResponse;
  }

  Future<List<Flatrate>> searchTitle(int id) async {
    var response = await http.post(new Uri.https(
      "api.themoviedb.org",
      "/3/movie/{$id}/watch/providers",
      {"api_key": "623ee3bd0e5c4882ac7411d102f1aeb6"},
    ));
    var movieWithIt = Providers.fromJson(jsonDecode(response.body));
    print(movieWithIt.results.languageRes.flatrate.toString());
    return movieWithIt.results.languageRes.flatrate;
    //return getAvailability(movieWithIt.id);
  }
}

final apiManager = JustWatchManager();
