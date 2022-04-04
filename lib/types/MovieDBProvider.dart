class Providers {
  int? id;
  Results? results;

  Providers({required this.id, required this.results});

  Providers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    results =
        json['results'] != null ? new Results.fromJson(json['results']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.results != null) {
      data['results'] = this.results?.toJson();
    }
    return data;
  }
}

class Results {
  LanguageResults? languageRes;

  Results({
    this.languageRes,
  });

  Results.fromJson(Map<String, dynamic> json) {
    languageRes =
        json['DE'] != null ? new LanguageResults.fromJson(json['DE']) : null;
    //uS = json['US'] != null ? new LanguageResults.fromJson(json['US']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.languageRes != null) {
      data['US'] = this.languageRes?.toJson();
    }
    // if (this.zA != null) {
    //   data['DE'] = this.zA.toJson();
    // }
    return data;
  }
}

class LanguageResults {
  String? link;
  List<Flatrate>? flatrate;

  LanguageResults({this.link, this.flatrate});

  LanguageResults.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    if (json['flatrate'] != null) {
      flatrate = [];
      json['flatrate'].forEach((v) {
        flatrate?.add(new Flatrate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link'] = this.link;
    if (this.flatrate != null) {
      data['flatrate'] = this.flatrate?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Flatrate {
  int? displayPriority;
  String? logoPath;
  int? providerId;
  String? providerName;

  Flatrate(
      {this.displayPriority,
      this.logoPath,
      this.providerId,
      this.providerName});

  Flatrate.fromJson(Map<String, dynamic> json) {
    displayPriority = json['display_priority'];
    logoPath = json['logo_path'];
    providerId = json['provider_id'];
    providerName = json['provider_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['display_priority'] = this.displayPriority;
    data['logo_path'] = this.logoPath;
    data['provider_id'] = this.providerId;
    data['provider_name'] = this.providerName;
    return data;
  }
}
