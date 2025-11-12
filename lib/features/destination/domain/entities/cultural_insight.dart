// To parse this JSON data, do
//
//     final culturalInsight = culturalInsightFromJson(jsonString);

class CulturalInsight {
  String destination;
  Overview overview;
  List<CulturalHighlight> culturalHighlights;
  VisitorGuidelines visitorGuidelines;
  List<String> travelTips;
  List<LanguageTip> languageTips;
  CulturalRating culturalRating;

  CulturalInsight({
    required this.destination,
    required this.overview,
    required this.culturalHighlights,
    required this.visitorGuidelines,
    required this.travelTips,
    required this.languageTips,
    required this.culturalRating,
  });

  factory CulturalInsight.fromJson(Map<String, dynamic> json) =>
      CulturalInsight(
        destination: json["destination"],
        overview: Overview.fromJson(json["overview"]),
        culturalHighlights: List<CulturalHighlight>.from(
          json["cultural_highlights"].map((x) => CulturalHighlight.fromJson(x)),
        ),
        visitorGuidelines: VisitorGuidelines.fromJson(
          json["visitor_guidelines"],
        ),
        travelTips: List<String>.from(json["travel_tips"].map((x) => x)),
        languageTips: List<LanguageTip>.from(
          json["language_tips"].map((x) => LanguageTip.fromJson(x)),
        ),
        culturalRating: CulturalRating.fromJson(json["cultural_rating"]),
      );

  Map<String, dynamic> toJson() => {
    "destination": destination,
    "overview": overview.toJson(),
    "cultural_highlights": List<dynamic>.from(
      culturalHighlights.map((x) => x.toJson()),
    ),
    "visitor_guidelines": visitorGuidelines.toJson(),
    "travel_tips": List<dynamic>.from(travelTips.map((x) => x)),
    "language_tips": List<dynamic>.from(languageTips.map((x) => x.toJson())),
    "cultural_rating": culturalRating.toJson(),
  };
}

class CulturalHighlight {
  String title;
  String description;

  CulturalHighlight({required this.title, required this.description});

  factory CulturalHighlight.fromJson(Map<String, dynamic> json) =>
      CulturalHighlight(title: json["title"], description: json["description"]);

  Map<String, dynamic> toJson() => {"title": title, "description": description};
}

class CulturalRating {
  int traditionDepth;
  int touristFriendliness;
  int spiritualSignificance;

  CulturalRating({
    required this.traditionDepth,
    required this.touristFriendliness,
    required this.spiritualSignificance,
  });

  factory CulturalRating.fromJson(Map<String, dynamic> json) => CulturalRating(
    traditionDepth: json["tradition_depth"],
    touristFriendliness: json["tourist_friendliness"],
    spiritualSignificance: json["spiritual_significance"],
  );

  Map<String, dynamic> toJson() => {
    "tradition_depth": traditionDepth,
    "tourist_friendliness": touristFriendliness,
    "spiritual_significance": spiritualSignificance,
  };
}

class LanguageTip {
  String phrase;
  String meaning;

  LanguageTip({required this.phrase, required this.meaning});

  factory LanguageTip.fromJson(Map<String, dynamic> json) =>
      LanguageTip(phrase: json["phrase"], meaning: json["meaning"]);

  Map<String, dynamic> toJson() => {"phrase": phrase, "meaning": meaning};
}

class Overview {
  String summary;
  List<String> mainValues;

  Overview({required this.summary, required this.mainValues});

  factory Overview.fromJson(Map<String, dynamic> json) => Overview(
    summary: json["summary"],
    mainValues: List<String>.from(json["main_values"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "summary": summary,
    "main_values": List<dynamic>.from(mainValues.map((x) => x)),
  };
}

class VisitorGuidelines {
  List<String> visitorGuidelinesDo;
  List<String> dont;

  VisitorGuidelines({required this.visitorGuidelinesDo, required this.dont});

  factory VisitorGuidelines.fromJson(Map<String, dynamic> json) =>
      VisitorGuidelines(
        visitorGuidelinesDo: List<String>.from(json["do"].map((x) => x)),
        dont: List<String>.from(json["dont"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "do": List<dynamic>.from(visitorGuidelinesDo.map((x) => x)),
    "dont": List<dynamic>.from(dont.map((x) => x)),
  };
}
