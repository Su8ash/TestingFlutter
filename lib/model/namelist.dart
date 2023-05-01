// To parse this JSON data, do
//
//     final nameList = nameListFromJson(jsonString);

import 'dart:convert';

List<NameList> nameListFromJson(String str) =>
    List<NameList>.from(json.decode(str).map((x) => NameList.fromJson(x)));

String nameListToJson(List<NameList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NameList {
  int id;
  String name;
  int position;

  NameList({
    required this.id,
    required this.name,
    required this.position,
  });

  factory NameList.fromJson(Map<String, dynamic> json) => NameList(
        id: json["id"],
        name: json["name"],
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "position": position,
      };
}
