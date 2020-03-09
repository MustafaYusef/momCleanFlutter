// To parse this JSON data, do
//
// final welcome = welcomeFromJson(jsonString);

import 'dart:convert';




class categoryRes {
  int statusCode;
  String message;
  String error;
  Data data;

  categoryRes({
    this.statusCode,
    this.message,
    this.error,
    this.data,
  });

  factory categoryRes.fromJson(Map<String, dynamic> json) => categoryRes(
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
  List<Category> categories;

  Data({
    this.categories,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}

class Category {
  int id;
  String nameAr;
  String nameEn;
  String file;
  String createAt;

  Category({
    this.id,
    this.nameAr,
    this.nameEn,
    this.file,
    this.createAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    nameAr: json["name_ar"],
    nameEn: json["name_en"],
    file: json["file"],
    createAt: json["createAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name_ar": nameAr,
    "name_en": nameEn,
    "file": file,
    "createAt": createAt,
  };
}
