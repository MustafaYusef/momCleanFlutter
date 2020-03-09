// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';




class packageOrderDetails {
  int statusCode;
  String message;
  String error;
  Data data;

  packageOrderDetails({
    this.statusCode,
    this.message,
    this.error,
    this.data,
  });

  factory packageOrderDetails.fromJson(Map<String, dynamic> json) => packageOrderDetails(
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
  List<OrderItem> orderItems;

  Data({
    this.orderItems,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    orderItems: List<OrderItem>.from(json["order_items"].map((x) => OrderItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "order_items": List<dynamic>.from(orderItems.map((x) => x.toJson())),
  };
}

class OrderItem {
  int id;
  int count;
  Item item;

  OrderItem({
    this.id,
    this.count,
    this.item,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
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
