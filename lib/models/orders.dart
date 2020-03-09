// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';



class OrdersRes {
    int statusCode;
    String message;
    String error;
    Data data;

    OrdersRes({
        this.statusCode,
        this.message,
        this.error,
        this.data,
    });

    factory OrdersRes.fromJson(Map<String, dynamic> json) => OrdersRes(
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
    List<Myorder> myorders;

    Data({
        this.myorders,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        myorders: List<Myorder>.from(json["myorders"].map((x) => Myorder.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "myorders": List<dynamic>.from(myorders.map((x) => x.toJson())),
    };
}

class Myorder {
    int id;
    String status;
    String type;
    String createAt;

    Myorder({
        this.id,
        this.status,
        this.type,
        this.createAt,
    });

    factory Myorder.fromJson(Map<String, dynamic> json) => Myorder(
        id: json["id"],
        status: json["status"],
        type: json["type"],
        createAt: json["createAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "type": type,
        "createAt": createAt,
    };
}
