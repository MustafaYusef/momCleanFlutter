// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

normalOrderRes welcomeFromJson(String str) => normalOrderRes.fromJson(json.decode(str));



class normalOrderRes {
  int statusCode;
  String message;
  String error;
  Data data;

  normalOrderRes({
    this.statusCode,
    this.message,
    this.error,
    this.data,
  });

  factory normalOrderRes.fromJson(Map<String, dynamic> json) => normalOrderRes(
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
  List<Order> orders;

  Data({
    this.orders,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
  };
}

class Order {
  int id;
  String latitude;
  String longitude;
  int price;
  int itemsCount;
  int rating;
  String status;
  String type;
  int officeId;
  int userId;
  bool softDelete;
  String receivedAt;
  String createAt;

  Order({
    this.id,
    this.latitude,
    this.longitude,
    this.price,
    this.itemsCount,
    this.rating,
    this.status,
    this.type,
    this.officeId,
    this.userId,
    this.softDelete,
    this.receivedAt,
    this.createAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    price: json["price"],
    itemsCount: json["itemsCount"],
    rating: json["rating"],
    status: json["status"],
    type: json["type"],
    officeId: json["officeId"],
    userId: json["userId"],
    softDelete: json["softDelete"],
    receivedAt: json["receivedAt"],
    createAt: json["createAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
    "price": price,
    "itemsCount": itemsCount,
    "rating": rating,
    "status": status,
    "type": type,
    "officeId": officeId,
    "userId": userId,
    "softDelete": softDelete,
    "receivedAt": receivedAt,
    "createAt": createAt,
  };
}
