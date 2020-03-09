// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';



class myPackageRes {
  int statusCode;
  String message;
  String error;
  Data data;

  myPackageRes({
    this.statusCode,
    this.message,
    this.error,
    this.data,
  });

  factory myPackageRes.fromJson(Map<String, dynamic> json) => myPackageRes(
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
  List<myPackage> packages;

  Data({
    this.packages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    packages: List<myPackage>.from(json["packages"].map((x) => myPackage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "packages": List<dynamic>.from(packages.map((x) => x.toJson())),
  };
}

class myPackage {
  int userPackageId;
  int visitsCount;
  String expireAt;
  bool isActive;
  bool sameArea;
  PackageDetails packageDetails;
  String createAt;

  myPackage({
    this.userPackageId,
    this.visitsCount,
    this.expireAt,
    this.isActive,
    this.sameArea,
    this.packageDetails,
    this.createAt,
  });

  factory myPackage.fromJson(Map<String, dynamic> json) => myPackage(
    userPackageId: json["user_packageId"],
    visitsCount: json["visits_count"],
    expireAt: json["expireAt"],
    isActive: json["is_Active"],
    sameArea: json["same_Area"],
    packageDetails: PackageDetails.fromJson(json["packageDetails"]),
    createAt: json["createAt"],
  );

  Map<String, dynamic> toJson() => {
    "user_packageId": userPackageId,
    "visits_count": visitsCount,
    "expireAt": expireAt,
    "is_Active": isActive,
    "same_Area": sameArea,
    "packageDetails": packageDetails.toJson(),
    "createAt": createAt,
  };
}

class PackageDetails {
  int id;
  String nameAr;
  String nameEn;
  String currency;
  int days;
  String descriptionAr;
  String descriptionEn;
  int visitsCount;
  int price;
  bool softDelele;
  String file;
  int officeId;
  String createAt;

  PackageDetails({
    this.id,
    this.nameAr,
    this.nameEn,
    this.currency,
    this.days,
    this.descriptionAr,
    this.descriptionEn,
    this.visitsCount,
    this.price,
    this.softDelele,
    this.file,
    this.officeId,
    this.createAt,
  });

  factory PackageDetails.fromJson(Map<String, dynamic> json) => PackageDetails(
    id: json["id"],
    nameAr: json["name_ar"],
    nameEn: json["name_en"],
    currency: json["currency"],
    days: json["days"],
    descriptionAr: json["description_ar"],
    descriptionEn: json["description_en"],
    visitsCount: json["visits_count"],
    price: json["price"],
    softDelele: json["softDelele"],
    file: json["file"],
    officeId: json["officeId"],
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
    "softDelele": softDelele,
    "file": file,
    "officeId": officeId,
    "createAt": createAt,
  };
}
