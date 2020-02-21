import 'package:flutter_watchlist/common/justwatch.dart';
import 'package:flutter_watchlist/common/justwatch_movie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JustWatchManager {
  getMovie(int id) async {
    var response = await http.get(
        "https://apis.justwatch.com/content/titles/movie/$id/locale/de_DE");
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

  Future<JustWatchResponse> searchTitle(String query) async {
    var encoded = jsonEncode({
      "age_certifications": [],
      "content_types": [],
      "genres": [],
      "languages": null,
      "min_price": null,
      "max_price": null,
      "monetization_types": ["ads", "buy", "flatrate", "rent", "free"],
      "presentation_types": [],
      "providers": ["nfx", "prv", "mvs", "fil", "atr", "hbo"],
      "release_year_from": null,
      "release_year_until": null,
      "scoring_filter_types": null,
      "timeline_type": null,
      "query": query,
      "person_id": null,
      "sort_by": null,
      "sort_asc": null,
      "titles_per_provider": 5,
      "page": 1,
      "page_size": 2
    });
    var response = await http.post(
        "https://apis.justwatch.com/content/titles/en_US/popular",
        body: encoded);
    var movieWithIt =
        JustWatchMovie.fromJson(jsonDecode(response.body)['items'][0]);
        print("offers: ");
    print(jsonDecode(response.body)['items']);

    return getAvailability(movieWithIt.id);
  }
}

final apiManager = JustWatchManager();
