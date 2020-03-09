// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';


class MyRequestRes {
    int statusCode;
    String message;
    String error;
    Data data;

    MyRequestRes({
        this.statusCode,
        this.message,
        this.error,
        this.data,
    });

    factory MyRequestRes.fromJson(Map<String, dynamic> json) => MyRequestRes(
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
    List<MyRequest> myRequest;

    Data({
        this.myRequest,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        myRequest: List<MyRequest>.from(json["myRequest"].map((x) => MyRequest.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "myRequest": List<dynamic>.from(myRequest.map((x) => x.toJson())),
    };
}

class MyRequest {
    int id;
    Status status;
    String createAt;
    Package package;

    MyRequest({
        this.id,
        this.status,
        this.createAt,
        this.package,
    });

    factory MyRequest.fromJson(Map<String, dynamic> json) => MyRequest(
        id: json["id"],
        status: statusValues.map[json["status"]],
        createAt: json["createAt"],
        package: Package.fromJson(json["package"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "status": statusValues.reverse[status],
        "createAt": createAt,
        "package": package.toJson(),
    };
}

class Package {
    int id;
    String nameAr;
    String nameEn;
    String currency;
    int days;
    String descriptionAr;
    String descriptionEn;
    int visitsCount;
    int price;
    bool softDelele;
    String file;
    int officeId;
    String createAt;

    Package({
        this.id,
        this.nameAr,
        this.nameEn,
        this.currency,
        this.days,
        this.descriptionAr,
        this.descriptionEn,
        this.visitsCount,
        this.price,
        this.softDelele,
        this.file,
        this.officeId,
        this.createAt,
    });

    factory Package.fromJson(Map<String, dynamic> json) => Package(
        id: json["id"],
        nameAr: json["name_ar"],
        nameEn: json["name_en"],
        currency:json["currency"],
        days: json["days"],
        descriptionAr: json["description_ar"],
        descriptionEn: json["description_en"],
        visitsCount: json["visits_count"],
        price: json["price"],
        softDelele: json["softDelele"],
        file: json["file"],
        officeId: json["officeId"],
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
        "softDelele": softDelele,
        "file": file,
        "officeId": officeId,
        "createAt": createAt,
    };
}



enum Status { PANDING, ACCEPTED, CANCELLED }

final statusValues = EnumValues({
    "accepted": Status.ACCEPTED,
    "cancelled": Status.CANCELLED,
    "panding": Status.PANDING
});

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
