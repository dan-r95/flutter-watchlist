class JustWatchMovie {
  int id;
  String title;
  String fullPath;
  String poster;
  int originalReleaseYear;
  String objectType;
  String originalTitle;
  List<Offers> offers;
  int showId;
  String showTitle;
  int seasonNumber;

  JustWatchMovie(
      {this.id,
      this.title,
      this.fullPath,
      this.poster,
      this.originalReleaseYear,
      this.objectType,
      this.originalTitle,
      this.offers,
      this.showId,
      this.showTitle,
      this.seasonNumber});

  JustWatchMovie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    fullPath = json['full_path'];
    poster = json['poster'];
    originalReleaseYear = json['original_release_year'];
    objectType = json['object_type'];
    originalTitle = json['original_title'];
    if (json['offers'] != null) {
      offers = new List<Offers>();
      json['offers'].forEach((v) {
        offers.add(new Offers.fromJson(v));
      });
    }
    showId = json['show_id'];
    showTitle = json['show_title'];
    seasonNumber = json['season_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['full_path'] = this.fullPath;
    data['poster'] = this.poster;
    data['original_release_year'] = this.originalReleaseYear;
    data['object_type'] = this.objectType;
    data['original_title'] = this.originalTitle;
    if (this.offers != null) {
      data['offers'] = this.offers.map((v) => v.toJson()).toList();
    }
    data['show_id'] = this.showId;
    data['show_title'] = this.showTitle;
    data['season_number'] = this.seasonNumber;
    return data;
  }
}

class Language {
  Language();
  Language.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {}
}

class Offers {
  String type;
  String monetizationType;
  int providerId;
  String currency;
  Urls urls;
  List<Language> subtitleLanguages;
  List<Language> audioLanguages;
  String presentationType;
  int elementCount;
  int newElementCount;
  String dateCreatedProviderId;
  String dateCreated;
  String dateCreatedTimestamp;
  String country;

  Offers(
      {this.type,
      this.monetizationType,
      this.providerId,
      this.currency,
      this.urls,
      this.subtitleLanguages,
      this.audioLanguages,
      this.presentationType,
      this.elementCount,
      this.newElementCount,
      this.dateCreatedProviderId,
      this.dateCreated,
      this.dateCreatedTimestamp,
      this.country});

  Offers.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    monetizationType = json['monetization_type'];
    providerId = json['provider_id'];
    currency = json['currency'];
    urls = json['urls'] != null ? new Urls.fromJson(json['urls']) : null;
    if (json['subtitle_languages'] != null) {
      subtitleLanguages = new List<Language>();
      json['subtitle_languages'].forEach((v) {
        subtitleLanguages.add(Language());
      });
    }
    if (json['audio_languages'] != null) {
      audioLanguages = new List<Language>();
      json['audio_languages'].forEach((v) {
        audioLanguages.add(Language());
      });
    }
    presentationType = json['presentation_type'];
    elementCount = json['element_count'];
    newElementCount = json['new_element_count'];
    dateCreatedProviderId = json['date_created_provider_id'];
    dateCreated = json['date_created'];
    dateCreatedTimestamp = json['date_created_timestamp'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['monetization_type'] = this.monetizationType;
    data['provider_id'] = this.providerId;
    data['currency'] = this.currency;
    if (this.urls != null) {
      data['urls'] = this.urls.toJson();
    }
    if (this.subtitleLanguages != null) {
      data['subtitle_languages'] =
          this.subtitleLanguages.map((v) => v.toJson()).toList();
    }
    if (this.audioLanguages != null) {
      data['audio_languages'] =
          this.audioLanguages.map((v) => v.toJson()).toList();
    }
    data['presentation_type'] = this.presentationType;
    data['element_count'] = this.elementCount;
    data['new_element_count'] = this.newElementCount;
    data['date_created_provider_id'] = this.dateCreatedProviderId;
    data['date_created'] = this.dateCreated;
    data['date_created_timestamp'] = this.dateCreatedTimestamp;
    data['country'] = this.country;
    return data;
  }
}

class Urls {
  String standardWeb;
  String deeplinkAndroid;
  String deeplinkIos;
  String deeplinkAndroidTv;
  String deeplinkFireTv;
  String deeplinkTvos;

  Urls(
      {this.standardWeb,
      this.deeplinkAndroid,
      this.deeplinkIos,
      this.deeplinkAndroidTv,
      this.deeplinkFireTv,
      this.deeplinkTvos});

  Urls.fromJson(Map<String, dynamic> json) {
    standardWeb = json['standard_web'];
    deeplinkAndroid = json['deeplink_android'];
    deeplinkIos = json['deeplink_ios'];
    deeplinkAndroidTv = json['deeplink_android_tv'];
    deeplinkFireTv = json['deeplink_fire_tv'];
    deeplinkTvos = json['deeplink_tvos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['standard_web'] = this.standardWeb;
    data['deeplink_android'] = this.deeplinkAndroid;
    data['deeplink_ios'] = this.deeplinkIos;
    data['deeplink_android_tv'] = this.deeplinkAndroidTv;
    data['deeplink_fire_tv'] = this.deeplinkFireTv;
    data['deeplink_tvos'] = this.deeplinkTvos;
    return data;
  }
}
