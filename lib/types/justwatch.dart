class JustWatchResponse {
  String? jwEntityId;
  int? id;
  String? title;
  String? fullPath;
  FullPaths? fullPaths;
  String? poster;
  List<Backdrops>? backdrops;
  String? shortDescription;
  int? originalReleaseYear;
  double? tmdbPopularity;
  String? objectType;
  String? originalTitle;
  String? localizedReleaseDate;
  List<Offers>? offers;
  List<Clips>? clips;
  List<Scoring>? scoring;
  List<Credits>? credits;
  List<ExternalIds>? externalIds;
  List<int>? genreIds;
  String? ageCertification;
  int? runtime;
  String? cinemaReleaseDate;

  JustWatchResponse(
      {required this.jwEntityId,
      required this.id,
      required this.title,
      required this.fullPath,
      required this.fullPaths,
      required this.poster,
      required this.backdrops,
      required this.shortDescription,
      required this.originalReleaseYear,
      required this.tmdbPopularity,
      required this.objectType,
      required this.originalTitle,
      required this.localizedReleaseDate,
      required this.offers,
      required this.clips,
      required this.scoring,
      required this.credits,
      required this.externalIds,
      required this.genreIds,
      required this.ageCertification,
      required this.runtime,
      required this.cinemaReleaseDate});

  JustWatchResponse.fromJson(Map<String, dynamic> json) {
    jwEntityId = json['jw_entity_id'];
    id = json['id'];
    title = json['title'];
    fullPath = json['full_path'];
    fullPaths = json['full_paths'] != null
        ? new FullPaths.fromJson(json['full_paths'])
        : null;
    poster = json['poster'];
    if (json['backdrops'] != null) {
      backdrops = [];
      json['backdrops'].forEach((v) {
        backdrops?.add(new Backdrops.fromJson(v));
      });
    }
    shortDescription = json['short_description'];
    originalReleaseYear = json['original_release_year'];
    tmdbPopularity = json['tmdb_popularity'];
    objectType = json['object_type'];
    originalTitle = json['original_title'];
    localizedReleaseDate = json['localized_release_date'];
    if (json['offers'] != null) {
      offers = [];
      json['offers'].forEach((v) {
        offers?.add(new Offers.fromJson(v));
      });
    }
    if (json['clips'] != null) {
      clips = [];
      json['clips'].forEach((v) {
        clips?.add(new Clips.fromJson(v));
      });
    }
    if (json['scoring'] != null) {
      scoring = [];
      json['scoring'].forEach((v) {
        scoring?.add(new Scoring.fromJson(v));
      });
    }
    if (json['credits'] != null) {
      credits = [];
      json['credits'].forEach((v) {
        credits?.add(new Credits.fromJson(v));
      });
    }
    if (json['external_ids'] != null) {
      externalIds = [];
      json['external_ids'].forEach((v) {
        externalIds?.add(new ExternalIds.fromJson(v));
      });
    }
    genreIds = json['genre_ids'].cast<int>();
    ageCertification = json['age_certification'];
    runtime = json['runtime'];
    cinemaReleaseDate = json['cinema_release_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jw_entity_id'] = this.jwEntityId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['full_path'] = this.fullPath;
    if (this.fullPaths != null) {
      data['full_paths'] = this.fullPaths?.toJson();
    }
    data['poster'] = this.poster;
    if (this.backdrops != null) {
      data['backdrops'] = this.backdrops?.map((v) => v.toJson()).toList();
    }
    data['short_description'] = this.shortDescription;
    data['original_release_year'] = this.originalReleaseYear;
    data['tmdb_popularity'] = this.tmdbPopularity;
    data['object_type'] = this.objectType;
    data['original_title'] = this.originalTitle;
    data['localized_release_date'] = this.localizedReleaseDate;
    if (this.offers != null) {
      data['offers'] = this.offers?.map((v) => v.toJson()).toList();
    }
    if (this.clips != null) {
      data['clips'] = this.clips?.map((v) => v.toJson()).toList();
    }
    if (this.scoring != null) {
      data['scoring'] = this.scoring?.map((v) => v.toJson()).toList();
    }
    if (this.credits != null) {
      data['credits'] = this.credits?.map((v) => v.toJson()).toList();
    }
    if (this.externalIds != null) {
      data['external_ids'] = this.externalIds?.map((v) => v.toJson()).toList();
    }
    data['genre_ids'] = this.genreIds;
    data['age_certification'] = this.ageCertification;
    data['runtime'] = this.runtime;
    data['cinema_release_date'] = this.cinemaReleaseDate;
    return data;
  }
}

class FullPaths {
  String? movieDetailOverview;

  FullPaths({required this.movieDetailOverview});

  FullPaths.fromJson(Map<String, dynamic> json) {
    movieDetailOverview = json['MOVIE_DETAIL_OVERVIEW'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MOVIE_DETAIL_OVERVIEW'] = this.movieDetailOverview;
    return data;
  }
}

class Backdrops {
  String? backdropUrl;

  Backdrops({required this.backdropUrl});

  Backdrops.fromJson(Map<String, dynamic> json) {
    backdropUrl = json['backdrop_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['backdrop_url'] = this.backdropUrl;
    return data;
  }
}

class Offers {
  String? monetizationType;
  int? providerId;
  double? retailPrice;
  String? currency;
  Urls? urls;
  String? presentationType;
  String? dateProviderId;
  String? dateCreated;
  double? lastChangeRetailPrice;
  double? lastChangeDifference;
  double? lastChangePercent;
  String? lastChangeDate;
  String? lastChangeDateProviderId;
  List<String>? audioLanguages;
  List<String>? subtitleLanguages;

  Offers(
      {required this.monetizationType,
      required this.providerId,
      required this.retailPrice,
      required this.currency,
      required this.urls,
      required this.presentationType,
      required this.dateProviderId,
      required this.dateCreated,
      required this.lastChangeRetailPrice,
      required this.lastChangeDifference,
      required this.lastChangePercent,
      required this.lastChangeDate,
      required this.lastChangeDateProviderId,
      required this.audioLanguages,
      required this.subtitleLanguages});

  Offers.fromJson(Map<String, dynamic> json) {
    monetizationType = json['monetization_type'];
    providerId = json['provider_id'];
    retailPrice = json['retail_price'];
    currency = json['currency'];
    urls = json['urls'] != null ? new Urls.fromJson(json['urls']) : null;
    presentationType = json['presentation_type'];
    dateProviderId = json['date_provider_id'];
    dateCreated = json['date_created'];
    lastChangeRetailPrice = json['last_change_retail_price'];
    lastChangeDifference =
        double.tryParse(json['last_change_difference'].toString());
    lastChangePercent = json['last_change_percent'];
    lastChangeDate = json['last_change_date'];
    lastChangeDateProviderId = json['last_change_date_provider_id'];
    audioLanguages = json['audio_languages'] != null
        ? json['audio_languages'].cast<String>()
        : null;
    subtitleLanguages = json['subtitle_languages'] != null
        ? json['subtitle_languages'].cast<String>()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['monetization_type'] = this.monetizationType;
    data['provider_id'] = this.providerId;
    data['retail_price'] = this.retailPrice;
    data['currency'] = this.currency;
    if (this.urls != null) {
      data['urls'] = this.urls?.toJson();
    }
    data['presentation_type'] = this.presentationType;
    data['date_provider_id'] = this.dateProviderId;
    data['date_created'] = this.dateCreated;
    data['last_change_retail_price'] = this.lastChangeRetailPrice;
    data['last_change_difference'] = this.lastChangeDifference;
    data['last_change_percent'] = this.lastChangePercent;
    data['last_change_date'] = this.lastChangeDate;
    data['last_change_date_provider_id'] = this.lastChangeDateProviderId;
    data['audio_languages'] = this.audioLanguages;
    data['subtitle_languages'] = this.subtitleLanguages;
    return data;
  }
}

class Urls {
  String? standardWeb;
  String? deeplinkAndroidTv;
  String? deeplinkFireTv;
  String? deeplinkTvos;

  Urls(
      {required this.standardWeb,
      required this.deeplinkAndroidTv,
      required this.deeplinkFireTv,
      required this.deeplinkTvos});

  Urls.fromJson(Map<String, dynamic> json) {
    standardWeb = json['standard_web'];
    deeplinkAndroidTv = json['deeplink_android_tv'];
    deeplinkFireTv = json['deeplink_fire_tv'];
    deeplinkTvos = json['deeplink_tvos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['standard_web'] = this.standardWeb;
    data['deeplink_android_tv'] = this.deeplinkAndroidTv;
    data['deeplink_fire_tv'] = this.deeplinkFireTv;
    data['deeplink_tvos'] = this.deeplinkTvos;
    return data;
  }
}

class Clips {
  String? type;
  String? provider;
  String? externalId;
  String? name;

  Clips(
      {required this.type,
      required this.provider,
      required this.externalId,
      required this.name});

  Clips.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    provider = json['provider'];
    externalId = json['external_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['provider'] = this.provider;
    data['external_id'] = this.externalId;
    data['name'] = this.name;
    return data;
  }
}

class Scoring {
  String? providerType;
  double? value;

  Scoring({required this.providerType, required this.value});

  Scoring.fromJson(Map<String, dynamic> json) {
    providerType = json['provider_type'];
    value = double.tryParse(json['value'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provider_type'] = this.providerType;
    data['value'] = this.value;
    return data;
  }
}

class Credits {
  String? role;
  String? characterName;
  int? personId;
  String? name;

  Credits(
      {required this.role,
      required this.characterName,
      required this.personId,
      required this.name});

  Credits.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    characterName = json['character_name'];
    personId = json['person_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    data['character_name'] = this.characterName;
    data['person_id'] = this.personId;
    data['name'] = this.name;
    return data;
  }
}

class ExternalIds {
  String? provider;
  String? externalId;

  ExternalIds({required this.provider, required this.externalId});

  ExternalIds.fromJson(Map<String, dynamic> json) {
    provider = json['provider'];
    externalId = json['external_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provider'] = this.provider;
    data['external_id'] = this.externalId;
    return data;
  }
}
