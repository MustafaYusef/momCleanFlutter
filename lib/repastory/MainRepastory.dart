
import 'dart:convert';

import 'package:http/http.dart';
import 'package:mom_clean/models/cartRes.dart';
import 'package:mom_clean/models/categoryItemsRes.dart';
import 'package:mom_clean/models/categoryRes.dart';
import 'package:mom_clean/models/city.dart';
import 'package:mom_clean/models/homeBanars.dart';
import 'package:mom_clean/models/myPackageDetailsRes.dart';
import 'package:mom_clean/models/myPackageRes.dart';
import 'package:mom_clean/models/myRequest.dart';
import 'package:mom_clean/models/normalOrderDetails.dart';
import 'package:mom_clean/models/notificAndCartnum.dart';
import 'package:mom_clean/models/notificationRes.dart';
import 'package:mom_clean/models/orders.dart';
import 'package:mom_clean/models/packageOrders.dart';
import 'package:mom_clean/models/packageOrdersDetails.dart';
import 'package:mom_clean/models/packagesItemsRes.dart';
import 'package:mom_clean/models/packagesRes.dart';
import 'package:mom_clean/models/signUpRes.dart';

class MainRepastory{
  final baseUrl="https://api.maamclean.com/";

  Future<categoryRes> getCategory() async {
    final response = await get(
        baseUrl+"category");
    if (response.statusCode == 200) {
      return categoryResFromJson(response.body);
    } else {
      throw Exception('حدث خطأ ما');
    }
  }
categoryRes categoryResFromJson(String str) => categoryRes.fromJson(json.decode(str));

Future<categoryItemsRes> getItemsGategore(int id,double lon,double lat) async {
    final response = await get(
        baseUrl+"item/category/$id"+"?lon=$lon&lat=$lat");
    if (response.statusCode == 200) {
      return categoryItemsResFromJson(response.body);
    } else {
      throw Exception(categoryItemsResFromJson(response.body).error);
    }
  }
categoryItemsRes categoryItemsResFromJson(String str) => categoryItemsRes.fromJson(json.decode(str));

Future<packagesRes> getPackages(double lon,double lat) async {
    final response = await get(
        baseUrl+"package"+"?lon=$lon&lat=$lat");
    if (response.statusCode == 200) {
      return packagesResFromJson(response.body);
    } else {
      throw Exception('حدث خطأ ما');
    }
  }
 packagesRes packagesResFromJson(String str) => packagesRes.fromJson(json.decode(str));

Future<packagesItemsRes> getPackageItems(int id) async {
    final response = await get(
        baseUrl+"package/$id");
    if (response.statusCode == 200) {
      return packagesItemsResFromJson(response.body);
    } else {
      throw Exception('حدث خطأ ما');
    }
  }
packagesItemsRes packagesItemsResFromJson(String str) => packagesItemsRes.fromJson(json.decode(str));

Future<signUpRes> buyPackage(String token,int packageId) async {
    final response = await post(
        baseUrl+"package/buy",headers: {"Authorization":token},
        body:{"PackageId":packageId.toString()});
    if (response.statusCode == 200||response.statusCode == 201) {
      return signUpResFromJson(response.body);
    } else {
      throw Exception(signUpResFromJson(response.body).statusCode);
    }
  }

Future<myPackageRes> getMyPackage(String token,double lon,double lat) async {
    final response = await get(
        baseUrl+"userpackage"+"?lon=$lon&lat=$lat",headers: {"Authorization":token});
    if (response.statusCode == 200) {
      return myPackageResFromJson(response.body);
    } else {
      throw Exception('حدث خطأ ما');
    }
  }

myPackageRes myPackageResFromJson(String str) => myPackageRes.fromJson(json.decode(str));


Future<myPackageDetailsRes> getUserPackageItems(int id) async {
    final response = await get(
        baseUrl+"userpackage/$id");
    if (response.statusCode == 200) {
      return myPackageDetailsResFromJson(response.body);
    } else {
      throw Exception('حدث خطأ ما');
    }
  }

myPackageDetailsRes myPackageDetailsResFromJson(String str) => myPackageDetailsRes.fromJson(json.decode(str));


Future<OrdersRes> getHomOrder(String token) async {
    final response = await get(
        baseUrl+"auth/orders",headers: {"Authorization":token});
    if (response.statusCode == 200) {
      return OrdersResFromJson(response.body);
    } else {
      throw Exception('حدث خطأ ما');
    }
  }
OrdersRes OrdersResFromJson(String str) => OrdersRes.fromJson(json.decode(str));




Future<HomeBanners> getHomePackages(double lon,double lat) async {
    final response = await post(
        baseUrl+"package/home?lon=$lon&lat=$lat");
    if (response.statusCode == 200 ||response.statusCode == 201) {
      return HomeBannersFromJson(response.body);
    } else {
      throw Exception(packagesResFromJson(response.body).error);
    }
  }
HomeBanners HomeBannersFromJson(String str) => HomeBanners.fromJson(json.decode(str));

Future<int> addItemToCart(String token,int item_id,int count,String type) async {
    final response = await post(
        baseUrl+"auth/cart",headers: {"Authorization":token},
         body:{"item_id":item_id.toString(),"count":count.toString(),"type":type});
    if (response.statusCode == 200 || response.statusCode == 201) {
      return signUpResFromJson(response.body).statusCode;
    } else {
      throw Exception('حدث خطأ ما');
    }
  }
signUpRes signUpResFromJson(String str) => signUpRes.fromJson(json.decode(str));

Future<signUpRes> deleteItemFromCart(String token,int id) async {
    final response = await delete(
        baseUrl+"auth/cart/$id",headers: {"Authorization":token});
    if (response.statusCode == 200 || response.statusCode == 201) {
      return signUpResFromJson(response.body);
    } else {
      throw Exception('حدث خطأ ما');
    }
  }


  Future<CartRes> getMyCart(String token) async {
    final response = await get(
        baseUrl+"auth/cart",headers: {"Authorization":token});
    if (response.statusCode == 200 || response.statusCode == 201) {
      return CartResFromJson(response.body);
    } else {
      throw Exception('حدث خطأ ما');
    }
  }
CartRes CartResFromJson(String str) => CartRes.fromJson(json.decode(str));


  Future<MyNotificationRes> getMyNotification(String token) async {
    final response = await get(
        baseUrl+"auth/notifications",headers: {"Authorization":token});
    if (response.statusCode == 200 || response.statusCode == 201) {
      return MyNotificationResFromJson(response.body);
    } else {
      throw Exception('حدث خطأ ما');
    }
  }
MyNotificationRes MyNotificationResFromJson(String str) => MyNotificationRes.fromJson(json.decode(str));

 Future<signUpRes> deleteNotification(String token,int id) async {
    final response = await delete(
        baseUrl+"auth/notifications/$id",headers: {"Authorization":token});
    if (response.statusCode == 200 || response.statusCode == 201) {
      return signUpResFromJson(response.body);
    } else {
      throw Exception('حدث خطأ ما');
    }
  }
 Future<notificAndCartRes> getNotifcAndCart(String token) async {
    final response = await get(
        baseUrl+"auth/home",headers: {"Authorization":token});
    if (response.statusCode == 200 || response.statusCode == 201) {
      return notificAndCartResFromJson(response.body);
    } else {
      throw Exception('حدث خطأ ما');
    }
  }
notificAndCartRes notificAndCartResFromJson(String str) => notificAndCartRes.fromJson(json.decode(str));

  Future<MyRequestRes> getMyRequest(String token) async {
    final response = await post(
        baseUrl+"package/requests",headers: {"Authorization":token});
    if (response.statusCode == 200||response.statusCode == 201) {
      return MyRequestResFromJson(response.body);
    } else {
      throw Exception('حدث خطأ ما');
    }
  }
MyRequestRes MyRequestResFromJson(String str) => MyRequestRes.fromJson(json.decode(str));


  
Future<OrdersRes> getAllOrder(String token) async {
    final response = await get(
        baseUrl+"auth/allorders",headers: {"Authorization":token});
    if (response.statusCode == 200) {
      return OrdersResFromJson(response.body);
    } else {
      throw Exception('حدث خطأ ما');
    }
  }


Future<normalOrderDetails> getNormalOrderItems(String token,int id) async {
    final response = await get(
        baseUrl+"orders/$id",headers: {"Authorization":token});
    if (response.statusCode == 200) {
      return normalOrderDetailsFromJson(response.body);
    } else {
      throw Exception('حدث خطأ ما');
    }
  }
normalOrderDetails normalOrderDetailsFromJson(String str) => normalOrderDetails.fromJson(json.decode(str));

  

Future<signUpRes> cancelNormalOrder(String token,int id) async {
    final response = await delete(
        baseUrl+"orders/$id",headers: {"Authorization":token});
    if (response.statusCode == 200||response.statusCode == 201) {
      return signUpResFromJson(response.body);
    } else {
      throw Exception('حدث خطأ ما');
    }
  }

  Future<packageOrderDetails> getPackageOrderItems(String token,int id) async {
    final response = await get(
        baseUrl+"package-orders/$id",headers: {"Authorization":token});
    if (response.statusCode == 200) {
      return packageOrderDetailsFromJson(response.body);
    } else {
      throw Exception(packageOrderDetailsFromJson(response.body));
    }
  }
packageOrderDetails packageOrderDetailsFromJson(String str) => packageOrderDetails.fromJson(json.decode(str));


  Future<signUpRes> cancelPackageOrder(String token,int id) async {
    final response = await delete(
        baseUrl+"package-orders/$id",headers: {"Authorization":token});
    if (response.statusCode == 200||response.statusCode == 201) {
      return signUpResFromJson(response.body);
    } else {
      throw Exception('حدث خطأ ما');
    }
  }

   Future<signUpRes> makeNormalOrder(String token,double lat,double lon) async {
    final response = await post(
        baseUrl+"orders",headers: {"Authorization":token},
        body: {"latitude":lat.toString(),"longitude":lon.toString()});
    if (response.statusCode == 200||response.statusCode == 201) {
      return signUpResFromJson(response.body);
    } else {
      throw Exception('حدث خطأ ما');
    }
  }

     Future<signUpRes> makePackageOrder(String token,
     double lat,double lon,int itemsCount,List<String> items
     ,List<String> counts,List<String> Newcounts,int packageId) async {
    final response = await post(
        baseUrl+"package-orders",headers: {"Content-Type": "application/json","Authorization":token},
        body:json.encode( {"latitude":lat.toString(),"longitude":lon.toString(),
        "itemsCount":itemsCount.toString(),"items[]":items,"counts[]":counts,
       "Newcounts[]":Newcounts,"packageId": packageId.toString()}));
    if (response.statusCode == 200||response.statusCode == 201) {
      return signUpResFromJson(response.body);
    } else {
      print(signUpResFromJson(response.body).message);
      throw Exception(signUpResFromJson(response.body).message);
    }
  }
}