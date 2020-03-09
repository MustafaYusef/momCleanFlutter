// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';



class HomeBanners {
    int statusCode;
    String message;
    String error;
    Data data;

    HomeBanners({
        this.statusCode,
        this.message,
        this.error,
        this.data,
    });

    factory HomeBanners.fromJson(Map<String, dynamic> json) => HomeBanners(
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
    List<MyBanner> banner;

    Data({
        this.banner,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        banner: List<MyBanner>.from(json["banner"].map((x) => MyBanner.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "banner": List<dynamic>.from(banner.map((x) => x.toJson())),
    };
}

class MyBanner {
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

    MyBanner({
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
    });

    factory MyBanner.fromJson(Map<String, dynamic> json) => MyBanner(
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
    };
}
