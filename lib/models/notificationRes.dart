// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';



class MyNotificationRes {
    int statusCode;
    String message;
    String error;
    Data data;

    MyNotificationRes({
        this.statusCode,
        this.message,
        this.error,
        this.data,
    });

    factory MyNotificationRes.fromJson(Map<String, dynamic> json) => MyNotificationRes(
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
    List<MyNotification> myNotifications;

    Data({
        this.myNotifications,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        myNotifications: List<MyNotification>.from(json["my_notifications"].map((x) => MyNotification.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "my_notifications": List<dynamic>.from(myNotifications.map((x) => x.toJson())),
    };
}

class MyNotification {
    int id;
    String titleAr;
    String titleEn;
    String descriptionAr;
    String descriptionEn;
    String createAt;

    MyNotification({
        this.id,
        this.titleAr,
        this.titleEn,
        this.descriptionAr,
        this.descriptionEn,
        this.createAt,
    });

    factory MyNotification.fromJson(Map<String, dynamic> json) => MyNotification(
        id: json["id"],
        titleAr: json["title_ar"],
        titleEn: json["title_en"],
        descriptionAr: json["description_ar"],
        descriptionEn: json["description_en"],
        createAt: json["createAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title_ar": titleAr,
        "title_en": titleEn,
        "description_ar": descriptionAr,
        "description_en": descriptionEn,
        "createAt": createAt,
    };
}
