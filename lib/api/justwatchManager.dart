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

  getAvailability(int id) async {
    JustWatchResponse movieResponse = await getMovie(id);
    for (var company in movieResponse.offers) {
      if (company.providerId == 10 ||
          company.providerId == 8 ||
          company.providerId == 29)
        print("available on: ${company.urls}, id:, ${company.providerId}");
    }
  }

  searchTitle(String query) async {
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
      "q": null,
      "person_id": null,
      "sort_by": null,
      "sort_asc": null,
      "titles_per_provider": 44,
      "page": 1,
      "page_size": 2
    });
    var response = await http.post(
        "https://apis.justwatch.com/content/titles/popular/locale/de_DE",
        body: encoded);
    return JustWatchMovie.fromJson(jsonDecode(response.body)['items']);
  }
}

final apiManager = JustWatchManager();
