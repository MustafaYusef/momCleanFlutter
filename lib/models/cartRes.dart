// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';



class CartRes {
    int statusCode;
    String message;
    String error;
    Data data;

    CartRes({
        this.statusCode,
        this.message,
        this.error,
        this.data,
    });

    factory CartRes.fromJson(Map<String, dynamic> json) => CartRes(
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
    List<MyCart> myCart;

    Data({
        this.myCart,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        myCart: List<MyCart>.from(json["my_cart"].map((x) => MyCart.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "my_cart": List<dynamic>.from(myCart.map((x) => x.toJson())),
    };
}

class MyCart {
    int id;
    String type;
    int count;
    String nameAr;
    String nameEn;
    String photo;
    String currency;
    int price;

    MyCart({
        this.id,
        this.type,
        this.count,
        this.nameAr,
        this.nameEn,
        this.photo,
        this.currency,
        this.price,
    });

    factory MyCart.fromJson(Map<String, dynamic> json) => MyCart(
        id: json["id"],
        type: json["type"],
        count: json["count"],
        nameAr: json["name_ar"],
        nameEn: json["name_en"],
        photo: json["photo"],
        currency: json["currency"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "count": count,
        "name_ar": nameAr,
        "name_en": nameEn,
        "photo": photo,
        "currency": currency,
        "price": price,
    };
}
