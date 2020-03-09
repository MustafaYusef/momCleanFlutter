import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:mom_clean/models/homeBanars.dart';
import 'package:mom_clean/models/myPackageRes.dart';
import 'package:mom_clean/models/myRequest.dart';
import 'package:mom_clean/models/orders.dart';
import 'package:mom_clean/models/packagesRes.dart';
import 'package:mom_clean/models/profileRes.dart';
import 'package:mom_clean/repastory/Authrepasatory.dart';
import 'package:mom_clean/repastory/MainRepastory.dart';

import 'package:shared_preferences/shared_preferences.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchHome extends HomeEvent {
 
  FetchHome();
  
  @override
  List<Object> get props => [];
}
class FetchAllOrders extends HomeEvent {
 
  FetchAllOrders();
  
  @override
  List<Object> get props => [];
}
class FetchAllPackages extends HomeEvent {
 
  FetchAllPackages();
  
  @override
  List<Object> get props => [];
}
class FetchMyPackages extends HomeEvent {
 
  FetchMyPackages();
  
  @override
  List<Object> get props => [];
}

class FetchRequests extends HomeEvent {
 
  FetchRequests();
  
  @override
  List<Object> get props => [];
}

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeUninitialized extends HomeState {}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  String msg;
  HomeError(this.msg);
}
class AllOrdersError extends HomeState {
  String msg;
  AllOrdersError(this.msg);
}
class HomeNetworkError extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeBanners package;
final OrdersRes orders;
  HomeLoaded({this.package,this.orders});

 HomeLoaded copyWith({
    profileRes profile,
  }) {
    return HomeLoaded(
      package: package ?? this.package,orders: orders ?? this.orders
    );
  }
  @override
  List<Object> get props => [package,orders];
}

class AllOrdersLoaded extends HomeState {

final OrdersRes orders;
  AllOrdersLoaded({this.orders});

 AllOrdersLoaded copyWith({
    profileRes profile,
  }) {
    return AllOrdersLoaded(
       orders: orders ?? this.orders
    );
  }
  @override
  List<Object> get props => [orders];
}
class RequestsLoaded extends HomeState {

final MyRequestRes requests;
  RequestsLoaded({this.requests});


  @override
  List<Object> get props => [requests];
}
class MyPackageLoaded extends HomeState {

final myPackageRes myPackage;
  MyPackageLoaded({this.myPackage});


  @override
  List<Object> get props => [myPackage];
}

class AllPackagesLoaded extends HomeState {

final packagesRes packages;
  AllPackagesLoaded({this.packages});

 AllPackagesLoaded copyWith({
    packagesRes packages,
  }) {
    return AllPackagesLoaded(
       packages: packages ?? this.packages
    );
  }
  @override
  List<Object> get props => [packages];
}
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MainRepastory Repo;

  HomeBloc({@required this.Repo});
  
  @override
  // TODO: implement initialState
  HomeState get initialState => HomeLoading();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    final currentState = state;
    if (event is FetchHome) {
       SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('token');
      try {
 Location location = new Location();

        bool _serviceEnabled;
        PermissionStatus _permissionGranted;
        LocationData _locationData;

        _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();
          if (!_serviceEnabled) {
            return;
          }
        }

        _permissionGranted = await location.hasPermission();
        if (_permissionGranted == PermissionStatus.DENIED) {
          _permissionGranted = await location.requestPermission();
          if (_permissionGranted != PermissionStatus.GRANTED) {
            return;
          }
        }

        _locationData = await location.getLocation();

         print(_locationData.latitude);
          yield HomeLoading();
          final package = await Repo.getHomePackages(_locationData.longitude, _locationData.latitude);
    //  print(package.data.packages[0].nameAr);
        // yield HomeLoaded( package:package,orders:null);
        if(token==""||token==null){

         //print(package.data.packages[0].nameAr);
          yield HomeLoaded( package:package,orders:null);
            return;
        }else{
 final orders=await Repo.getHomOrder(token);
        
          yield HomeLoaded( package:package,orders:orders);
          return;
        }
        
        
        
      } on SocketException catch (_) {
        yield HomeNetworkError();
      }catch(_){
       // print("error    "+_);
        yield HomeError(_.toString());
      }
    }else if(event is FetchAllOrders){
           SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('token');
      try {
        yield HomeLoading(); 
        if(token==null||token==""){
 yield AllOrdersLoaded(orders:null);
        }else{
 final orders = await Repo.getAllOrder(token);
 yield AllOrdersLoaded(orders:orders);
        }
         

          
        
        
          return;
        
      } on SocketException catch (_) {
        yield HomeNetworkError();
      }catch(_){
       // print("error    "+_);
        yield AllOrdersError(_.toString());
      }
    }else if(event is FetchAllPackages){
       try {
         Location location = new Location();

        bool _serviceEnabled;
        PermissionStatus _permissionGranted;
        LocationData _locationData;

        _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();
          if (!_serviceEnabled) {
            return;
          }
        }

        _permissionGranted = await location.hasPermission();
        if (_permissionGranted == PermissionStatus.DENIED) {
          _permissionGranted = await location.requestPermission();
          if (_permissionGranted != PermissionStatus.GRANTED) {
            return;
          }
        }

        _locationData = await location.getLocation();
        yield HomeLoading(); 
          final packages = await Repo.getPackages(_locationData.longitude
          , _locationData.latitude);

          yield AllPackagesLoaded(packages:packages);
        
        
          return;
        
      } on SocketException catch (_) {
        yield HomeNetworkError();
      }catch(_){
       // print("error    "+_);
        yield AllOrdersError(_.toString());
      }
    }else if(event is FetchRequests){
              SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('token');
        try {
            yield HomeLoading(); 
          final requests = await Repo.getMyRequest(token);
      

          yield RequestsLoaded(requests:requests);     
       } on SocketException catch (_) {
        yield HomeNetworkError();
      }catch(_){
       // print("error    "+_);
        yield HomeError(_.toString());
      }
    }else if(event is FetchMyPackages){
           SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('token');
        try {
              Location location = new Location();

        bool _serviceEnabled;
        PermissionStatus _permissionGranted;
        LocationData _locationData;

        _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();
          if (!_serviceEnabled) {
            return;
          }
        }

        _permissionGranted = await location.hasPermission();
        if (_permissionGranted == PermissionStatus.DENIED) {
          _permissionGranted = await location.requestPermission();
          if (_permissionGranted != PermissionStatus.GRANTED) {
            return;
          }
        }

        _locationData = await location.getLocation();
        yield HomeLoading(); 
 if(token==""||token==null){

         //print(package.data.packages[0].nameAr);
         yield MyPackageLoaded(myPackage:null); 
        }else{
   
          final myPackage = await Repo.getMyPackage(token, _locationData.longitude
          , _locationData.latitude);
           if(myPackage.data.packages.isEmpty){
 yield MyPackageLoaded(myPackage:null); 
           }else{
              yield MyPackageLoaded(myPackage:myPackage); 
           }

          
        }

        return;
             
       } on SocketException catch (_) {
        yield HomeNetworkError();
      }catch(_){
       // print("error    "+_);
        yield HomeError(_.toString());
      }
    }
  }}