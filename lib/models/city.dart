// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

CityRes welcomeFromJson(String str) => CityRes.fromJson(json.decode(str));



class CityRes {
  int statusCode;
  String message;
  String error;
  Data data;

  CityRes({
    this.statusCode,
    this.message,
    this.error,
    this.data,
  });

  factory CityRes.fromJson(Map<String, dynamic> json) => CityRes(
    statusCode: json["statusCode"],
    message: json["message"],
    error: json["error"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "error": error,
    "data": data.toJson(),
  };
}

class Data {
  List<City> cities;

  Data({
    this.cities,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    cities: List<City>.from(json["cities"].map((x) => City.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cities": List<dynamic>.from(cities.map((x) => x.toJson())),
  };
}

class City {
  int id;
  String name;
  bool softDelete;
  String createAt;

  City({
    this.id,
    this.name,
    this.softDelete,
    this.createAt,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    name: json["name"],
    softDelete: json["softDelete"],
    createAt: json["createAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "softDelete": softDelete,
    "createAt": createAt,
  };
}
