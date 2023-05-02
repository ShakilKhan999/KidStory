import 'dart:convert';

StoryImageResponse storyImageResponseFromJson(String str) =>
    StoryImageResponse.fromJson(json.decode(str));

String storyImageResponseToJson(StoryImageResponse data) =>
    json.encode(data.toJson());

class StoryImageResponse {
  StoryImageResponse({
    this.created,
    this.data,
  });

  int? created;
  List<Datum>? data;

  factory StoryImageResponse.fromJson(Map<String, dynamic> json) =>
      StoryImageResponse(
        created: json["created"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "created": created,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.url,
  });

  String? url;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
      };
}
