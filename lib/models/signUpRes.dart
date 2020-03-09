import 'dart:convert';


class signUpRes {
  int statusCode;
  String message;
  String error;
  Data data;

  signUpRes({
    this.statusCode,
    this.message,
    this.error,
    this.data,
  });

  factory signUpRes.fromJson(Map<String, dynamic> json) => signUpRes(
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
  String token;
  bool isActive;

  Data({
    this.token,
    this.isActive,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "isActive": isActive,
      };
}
