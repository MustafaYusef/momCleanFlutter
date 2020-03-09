// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';



class packagesRes {
  int statusCode;
  String message;
  String error;
  Data data;

  packagesRes({
    this.statusCode,
    this.message,
    this.error,
    this.data,
  });

  factory packagesRes.fromJson(Map<String, dynamic> json) => packagesRes(
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
  List<Package> packages;

  Data({
    this.packages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    packages: List<Package>.from(json["packages"].map((x) => Package.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "packages": List<dynamic>.from(packages.map((x) => x.toJson())),
  };
}

class Package {
  int id;
  String nameAr;
  String nameEn;
  String currency;
  int days;
  String descriptionAr;
  String descriptionEn;
  int visitsCount;
  int price;
  String file;
  String createAt;

  Package({
    this.id,
    this.nameAr,
    this.nameEn,
    this.currency,
    this.days,
    this.descriptionAr,
    this.descriptionEn,
    this.visitsCount,
    this.price,
    this.file,
    this.createAt,
  });

  factory Package.fromJson(Map<String, dynamic> json) => Package(
    id: json["id"],
    nameAr: json["name_ar"],
    nameEn: json["name_en"],
    currency: json["currency"],
    days: json["days"],
    descriptionAr: json["description_ar"],
    descriptionEn: json["description_en"],
    visitsCount: json["visits_count"],
    price: json["price"],
    file: json["file"],
    createAt: json["createAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name_ar": nameAr,
    "name_en": nameEn,
    "currency": currency,
    "days": days,
    "description_ar": descriptionAr,
    "description_en": descriptionEn,
    "visits_count": visitsCount,
    "price": price,
    "file": file,
    "createAt": createAt,
  };
}
