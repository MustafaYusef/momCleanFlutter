// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';



class myPackageDetailsRes {
  int statusCode;
  String message;
  String error;
  Data data;

  myPackageDetailsRes({
    this.statusCode,
    this.message,
    this.error,
    this.data,
  });

  factory myPackageDetailsRes.fromJson(Map<String, dynamic> json) => myPackageDetailsRes(
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
  List<PackageItem> packageItems;

  Data({
    this.packageItems,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    packageItems: List<PackageItem>.from(json["Package_Items"].map((x) => PackageItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Package_Items": List<dynamic>.from(packageItems.map((x) => x.toJson())),
  };
}

class PackageItem {
  int packageUserDetailsId;
  int count;
  Item item;

  PackageItem({
    this.packageUserDetailsId,
    this.count,
    this.item,
  });

  factory PackageItem.fromJson(Map<String, dynamic> json) => PackageItem(
    packageUserDetailsId: json["package_user_detailsId"],
    count: json["count"],
    item: Item.fromJson(json["item"]),
  );

  Map<String, dynamic> toJson() => {
    "package_user_detailsId": packageUserDetailsId,
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
