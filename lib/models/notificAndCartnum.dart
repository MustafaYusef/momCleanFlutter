// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';



class notificAndCartRes {
    int statusCode;
    String message;
    String error;
    Data data;

    notificAndCartRes({
        this.statusCode,
        this.message,
        this.error,
        this.data,
    });

    factory notificAndCartRes.fromJson(Map<String, dynamic> json) => notificAndCartRes(
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
    Statistics statistics;

    Data({
        this.statistics,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        statistics: Statistics.fromJson(json["statistics"]),
    );

    Map<String, dynamic> toJson() => {
        "statistics": statistics.toJson(),
    };
}

class Statistics {
    int cart;
    int notifications;

    Statistics({
        this.cart,
        this.notifications,
    });

    factory Statistics.fromJson(Map<String, dynamic> json) => Statistics(
        cart: json["cart"],
        notifications: json["notifications"],
    );

    Map<String, dynamic> toJson() => {
        "cart": cart,
        "notifications": notifications,
    };
}
