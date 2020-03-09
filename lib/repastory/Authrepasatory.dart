




import 'dart:convert';

import 'package:http/http.dart';
import 'package:mom_clean/models/city.dart';
import 'package:mom_clean/models/profileRes.dart';
import 'package:mom_clean/models/signUpRes.dart';



class AuthRepastory{
  final baseUrl="https://maamclean.com/";

  Future<CityRes> getCity() async {
    final response = await get(
        baseUrl+"city");
    if (response.statusCode == 200) {
      return CityFromJson(response.body);
    } else {
      
      throw Exception('حدث خطأ ما');
    }
  }
  CityRes CityFromJson(String str) => CityRes.fromJson(json.decode(str));


  Future<signUpRes> SignUp(String name,String phone,String password,int cityId,String player_id) async {
    final response = await post(baseUrl+"auth/singup",headers: {"Content-Type": "application/json"},
    body:json.encode({"name":name,"phone":phone,"password":password,"city":cityId.toString(),"player_id":player_id}) );
    if (response.statusCode == 200||response.statusCode == 201) {
      return SignUpResFromJson(response.body);
    } else {
      throw Exception(SignUpResFromJson(response.body).message);
    }
  }
  signUpRes SignUpResFromJson(String str) => signUpRes.fromJson(json.decode(str));

 Future<signUpRes> Login(String phone,String password,String player_id) async {
    final response = await post(baseUrl+"auth/login",headers: {"Content-Type": "application/json"},
    body:json.encode({"phone":phone,"password":password,"player_id":player_id}));
    if (response.statusCode==200||response.statusCode==201) {
      return SignUpResFromJson(response.body);
    } else {
      throw Exception(SignUpResFromJson(response.body).statusCode);
    }
  }
Future<profileRes> getProfile(String authorization) async {
    final response = await get(baseUrl+"auth/profile",headers: {"Authorization":authorization});
    if (response.statusCode == 200||response.statusCode == 201) {
      return ProfileResFromJson(response.body);
    } else {
      throw Exception(ProfileResFromJson(response.body).message);
    }
  }
profileRes ProfileResFromJson(String str) => profileRes.fromJson(json.decode(str));
  


    Future<signUpRes> changePassword(String token,String password,String newPassword) async {
    final response = await put(baseUrl+"auth/changepassword",
    headers: {"Content-Type": "application/json","Authorization":token},
    body:json.encode({"password":password,"newpassword":newPassword}));
    if (response.statusCode == 200||response.statusCode == 201) {
      return SignUpResFromJson(response.body);
    } else {
      throw Exception(SignUpResFromJson(response.body).statusCode);
    }
  }

  Future<signUpRes> verficationUser(String code,String phone) async {
    final response = await post(baseUrl+"auth/verification",
    headers: {"Content-Type": "application/json"},
    body:json.encode({"code":code,"phone":phone}));
    if (response.statusCode == 200||response.statusCode == 201) {
      return SignUpResFromJson(response.body);
    } else {
      throw Exception(SignUpResFromJson(response.body).error);
    }}

Future<signUpRes> reSendCode(String phone) async {
    final response = await post(baseUrl+"auth/checkPhone",
    headers: {"Content-Type": "application/json"},
    body:json.encode({"phone":phone}));
    if (response.statusCode == 200||response.statusCode == 201) {
      return SignUpResFromJson(response.body);
    } else {
      throw Exception('حدث خطأ ما');
    }
  }

Future<signUpRes> reSetPassword(String password,String reset_Code,String phone) async {
    final response = await put(baseUrl+"auth/reset",
    headers: {"Content-Type": "application/json"},
    body:json.encode({"password":password,"reset_Code":reset_Code,"phone":phone}));
    if (response.statusCode == 200||response.statusCode == 201) {
      return SignUpResFromJson(response.body);
    } else {
      throw Exception('حدث خطأ ما');
    }
  }


Future<signUpRes> UpdateProfile(String token,String name,int city) async {
    final response = await put(baseUrl+"auth/profile",
    headers: {"Authorization":token},
    body:{"name":name,"cityId":city.toString()});
    if (response.statusCode == 200||response.statusCode == 201) {
      return SignUpResFromJson(response.body);
    } else {
      throw Exception('حدث خطأ ما');
    }
  }

// @Multipart
//     @PUT("auth/photo")
//     suspend fun updateProfilePhoto(
//         @Header("Authorization") token:String,
//         @Part image: MultipartBody.Part
//     ):Response<reSendRes>

// Future<signUpRes> updateProfilePhoto(String token,String name,String city) async {
//     final response = await put(baseUrl+"auth/photo",
//     headers: {"Content-Type": "application/json","Authorization":token},
//     body:json.encode({"name":name,"cityId":city}));
//     if (response.statusCode == 200||response.statusCode == 201) {
//       return SignUpResFromJson(response.body);
//     } else {
//       throw Exception('حدث خطأ ما');
//     }
//   }
}
