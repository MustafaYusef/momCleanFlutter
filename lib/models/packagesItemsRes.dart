// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';


class packagesItemsRes {
  int statusCode;
  String message;
  String error;
  Data data;

  packagesItemsRes({
    this.statusCode,
    this.message,
    this.error,
    this.data,
  });

  factory packagesItemsRes.fromJson(Map<String, dynamic> json) => packagesItemsRes(
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
  PackageItems packageItems;

  Data({
    this.packageItems,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    packageItems: PackageItems.fromJson(json["packageItems"]),
  );

  Map<String, dynamic> toJson() => {
    "packageItems": packageItems.toJson(),
  };
}

class PackageItems {
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
  List<PackageItem> packageItems;

  PackageItems({
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
    this.packageItems,
  });

  factory PackageItems.fromJson(Map<String, dynamic> json) => PackageItems(
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
    packageItems: List<PackageItem>.from(json["packageItems"].map((x) => PackageItem.fromJson(x))),
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
    "packageItems": List<dynamic>.from(packageItems.map((x) => x.toJson())),
  };
}

class PackageItem {
  int id;
  int count;
  Item item;

  PackageItem({
    this.id,
    this.count,
    this.item,
  });

  factory PackageItem.fromJson(Map<String, dynamic> json) => PackageItem(
    id: json["id"],
    count: json["count"],
    item: Item.fromJson(json["item"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "count": count,
    "item": item.toJson(),
  };
}

class Item {
  int id;
  String nameAr;
  String nameEn;
  String photo;
  int washPrice;
  int dwPrice;
  bool softDelete;
  int categoryId;
  String currency;
  int officeId;
  String createAt;

  Item({
    this.id,
    this.nameAr,
    this.nameEn,
    this.photo,
    this.washPrice,
    this.dwPrice,
    this.softDelete,
    this.categoryId,
    this.currency,
    this.officeId,
    this.createAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    nameAr: json["name_ar"],
    nameEn: json["name_en"],
    photo: json["photo"],
    washPrice: json["wash_price"],
    dwPrice: json["dw_price"],
    softDelete: json["softDelete"],
    categoryId: json["categoryId"],
    currency: json["currency"],
    officeId: json["officeId"],
    createAt: json["createAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name_ar": nameAr,
    "name_en": nameEn,
    "photo": photo,
    "wash_price": washPrice,
    "dw_price": dwPrice,
    "softDelete": softDelete,
    "categoryId": categoryId,
    "currency": currency,
    "officeId": officeId,
    "createAt": createAt,
  };
}
