// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';



class normalOrderDetails {
  int statusCode;
  String message;
  String error;
  Data data;

  normalOrderDetails({
    this.statusCode,
    this.message,
    this.error,
    this.data,
  });

  factory normalOrderDetails.fromJson(Map<String, dynamic> json) => normalOrderDetails(
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
  Order order;

  Data({
    this.order,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    order: Order.fromJson(json["order"]),
  );

  Map<String, dynamic> toJson() => {
    "order": order.toJson(),
  };
}

class Order {
  int id;
  String latitude;
  String longitude;
  int price;
  int itemsCount;
  String status;
  String receivedAt;
  String createAt;
  List<OrderItme> orderItmes;

  Order({
    this.id,
    this.latitude,
    this.longitude,
    this.price,
    this.itemsCount,
    this.status,
    this.receivedAt,
    this.createAt,
    this.orderItmes,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    price: json["price"],
    itemsCount: json["itemsCount"],
    status: json["status"],
    receivedAt: json["receivedAt"],
    createAt: json["createAt"],
    orderItmes: List<OrderItme>.from(json["orderItmes"].map((x) => OrderItme.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
    "price": price,
    "itemsCount": itemsCount,
    "status": status,
    "receivedAt": receivedAt,
    "createAt": createAt,
    "orderItmes": List<dynamic>.from(orderItmes.map((x) => x.toJson())),
  };
}

class OrderItme {
  int id;
  int count;
  String type;
  Item item;

  OrderItme({
    this.id,
    this.count,
    this.type,
    this.item,
  });

  factory OrderItme.fromJson(Map<String, dynamic> json) => OrderItme(
    id: json["id"],
    count: json["count"],
    type: json["type"],
    item: Item.fromJson(json["item"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "count": count,
    "type": type,
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
