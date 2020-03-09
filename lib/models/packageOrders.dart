// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

packageOrders welcomeFromJson(String str) => packageOrders.fromJson(json.decode(str));



class packageOrders {
  Res res;

  packageOrders({
    this.res,
  });

  factory packageOrders.fromJson(Map<String, dynamic> json) => packageOrders(
    res: Res.fromJson(json["res"]),
  );

  Map<String, dynamic> toJson() => {
    "res": res.toJson(),
  };
}

class Res {
  int statusCode;
  String message;
  String error;
  Data data;

  Res({
    this.statusCode,
    this.message,
    this.error,
    this.data,
  });

  factory Res.fromJson(Map<String, dynamic> json) => Res(
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
  List<PackageOrder> packageOrders;

  Data({
    this.packageOrders,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    packageOrders: List<PackageOrder>.from(json["PackageOrders"].map((x) => PackageOrder.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "PackageOrders": List<dynamic>.from(packageOrders.map((x) => x.toJson())),
  };
}

class PackageOrder {
  int id;
  String latitude;
  String longitude;
  int itemsCount;
  String status;
  String receivedAt;
  String createAt;
  Office office;
  User user;
  UserPackage userPackage;

  PackageOrder({
    this.id,
    this.latitude,
    this.longitude,
    this.itemsCount,
    this.status,
    this.receivedAt,
    this.createAt,
    this.office,
    this.user,
    this.userPackage,
  });

  factory PackageOrder.fromJson(Map<String, dynamic> json) => PackageOrder(
    id: json["id"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    itemsCount: json["itemsCount"],
    status: json["status"],
    receivedAt: json["receivedAt"],
    createAt: json["createAt"],
    office: Office.fromJson(json["office"]),
    user: User.fromJson(json["user"]),
    userPackage: UserPackage.fromJson(json["user_Package"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
    "itemsCount": itemsCount,
    "status": status,
    "receivedAt": receivedAt,
    "createAt": createAt,
    "office": office.toJson(),
    "user": user.toJson(),
    "user_Package": userPackage.toJson(),
  };
}

class Office {
  int id;
  String name;
  String latitude;
  String longitude;
  String phone;

  Office({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
    this.phone,
  });

  factory Office.fromJson(Map<String, dynamic> json) => Office(
    id: json["id"],
    name: json["name"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "latitude": latitude,
    "longitude": longitude,
    "phone": phone,
  };
}

class User {
  int id;
  String name;
  String phone;

  User({
    this.id,
    this.name,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
  };
}

class UserPackage {
  int id;
  int visitsCount;
  String expireAt;
  int packageId;

  UserPackage({
    this.id,
    this.visitsCount,
    this.expireAt,
    this.packageId,
  });

  factory UserPackage.fromJson(Map<String, dynamic> json) => UserPackage(
    id: json["id"],
    visitsCount: json["visits_count"],
    expireAt: json["expireAt"],
    packageId: json["packageId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "visits_count": visitsCount,
    "expireAt": expireAt,
    "packageId": packageId,
  };
}
