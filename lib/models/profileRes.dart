// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

profileRes welcomeFromJson(String str) => profileRes.fromJson(json.decode(str));



class profileRes {
  int statusCode;
  String message;
  String error;
  Data data;

  profileRes({
    this.statusCode,
    this.message,
    this.error,
    this.data,
  });

  factory profileRes.fromJson(Map<String, dynamic> json) => profileRes(
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
  Profile profile;

  Data({
    this.profile,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    profile: Profile.fromJson(json["profile"]),
  );

  Map<String, dynamic> toJson() => {
    "profile": profile.toJson(),
  };
}

class Profile {
  int id;
  String name;
  String city;
  String phone;
  String photo;
  String playerId;
  String resetCode;
  String createAt;

  Profile({
    this.id,
    this.name,
    this.city,
    this.phone,
    this.photo,
    this.playerId,
    this.resetCode,
    this.createAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json["id"],
    name: json["name"],
    city: json["city"],
    phone: json["phone"],
    photo: json["photo"],
    playerId: json["player_id"],
    resetCode: json["reset_Code"],
    createAt: json["createAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "city": city,
    "phone": phone,
    "photo": photo,
    "player_id": playerId,
    "reset_Code": resetCode,
    "createAt": createAt,
  };
}
