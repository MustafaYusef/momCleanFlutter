// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';



class categoryItemsRes {
  int statusCode;
  String message;
  String error;
  Data data;

  categoryItemsRes({
    this.statusCode,
    this.message,
    this.error,
    this.data,
  });

  factory categoryItemsRes.fromJson(Map<String, dynamic> json) => categoryItemsRes(
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
  List<Item> items;

  Data({
    this.items,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Item {
  int id;
  String nameAr;
  String nameEn;
  String photo;
  int washPrice;
  int dwPrice;
  String currency;
  String createAt;

  Item({
    this.id,
    this.nameAr,
    this.nameEn,
    this.photo,
    this.washPrice,
    this.dwPrice,
    this.currency,
    this.createAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    nameAr: json["name_ar"],
    nameEn: json["name_en"],
    photo: json["photo"],
    washPrice: json["wash_price"],
    dwPrice: json["dw_price"],
    currency: json["currency"],
    createAt: json["createAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name_ar": nameAr,
    "name_en": nameEn,
    "photo": photo,
    "wash_price": washPrice,
    "dw_price": dwPrice,
    "currency": currency,
    "createAt": createAt,
  };
}
