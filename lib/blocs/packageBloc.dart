import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:mom_clean/models/homeBanars.dart';
import 'package:mom_clean/models/myPackageDetailsRes.dart';
import 'package:mom_clean/models/orders.dart';
import 'package:mom_clean/models/packagesItemsRes.dart';
import 'package:mom_clean/models/packagesRes.dart';
import 'package:mom_clean/models/profileRes.dart';
import 'package:mom_clean/repastory/Authrepasatory.dart';
import 'package:mom_clean/repastory/MainRepastory.dart';
import 'package:mom_clean/ui/packageDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PackageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPackageDetails extends PackageEvent {
  final int id;
  FetchPackageDetails(this.id);

  @override
  List<Object> get props => [id];
}

class BuyPackageEvent extends PackageEvent {
  final int id;
  final String token;
  BuyPackageEvent(this.id, this.token);

  @override
  List<Object> get props => [id, token];
}

class FetchMyPackageDetails extends PackageEvent {
  final int id;

  FetchMyPackageDetails(this.id);

  @override
  List<Object> get props => [id];
}

abstract class PackageState extends Equatable {
  const PackageState();

  @override
  List<Object> get props => [];
}

class PackageLoading extends PackageState {}

class MyPackageDetailsLoaded extends PackageState {
  final myPackageDetailsRes myPackage;

  MyPackageDetailsLoaded({this.myPackage});

  @override
  List<Object> get props => [myPackage];
}

class PackageError extends PackageState {
  int msg;
  PackageError(this.msg);
}

class PackageNetworkError extends PackageState {}

class PackageDetailsLoaded extends PackageState {
  final packagesItemsRes package;

  PackageDetailsLoaded({this.package});

  PackageDetailsLoaded copyWith({
    packagesItemsRes package,
  }) {
    return PackageDetailsLoaded(package: package ?? this.package);
  }

  @override
  List<Object> get props => [package];
}

class PackageBuySuccessfully extends PackageState {
  final String msg;

  PackageBuySuccessfully(this.msg);

  @override
  List<Object> get props => [msg];
}

class PackageBloc extends Bloc<PackageEvent, PackageState> {
  final MainRepastory Repo;

  PackageBloc({@required this.Repo}) : super(PackageLoading());

  @override
  // TODO: implement initialState
  PackageState get initialState => PackageLoading();

  @override
  Stream<PackageState> mapEventToState(PackageEvent event) async* {
    final currentState = state;
    if (event is FetchPackageDetails) {
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
        yield PackageLoading();
        final package = await Repo.getPackageItems(event.id);

        //print(package.data.packages[0].nameAr);
        yield PackageDetailsLoaded(package: package);

        return;
      } on SocketException catch (_) {
        yield PackageNetworkError();
      } catch (_) {
        // print("error    "+_);
        yield PackageError(_);
      }
    } else if (event is BuyPackageEvent) {
      try {
        print(event.id);
        yield PackageLoading();
        final package = await Repo.buyPackage(event.token, event.id);
        print("error    " + package.statusCode.toString());
        //print(package.data.packages[0].nameAr);
        yield PackageBuySuccessfully("تم ارسال طلب الأشتراك");

        return;
      } on SocketException catch (_) {
        yield PackageNetworkError();
      } catch (_) {
        //print("error    "+_);

        yield PackageError(400);
      }
    } else if (event is FetchMyPackageDetails) {
      try {
        print(event.id);
        yield PackageLoading();
        final package = await Repo.getUserPackageItems(event.id);

        //print(package.data.packages[0].nameAr);
        yield MyPackageDetailsLoaded(myPackage: package);

        return;
      } on SocketException catch (_) {
        yield PackageNetworkError();
      } catch (_) {
        // print("error    "+_);
        yield PackageError(_);
      }
    }
  }
}
