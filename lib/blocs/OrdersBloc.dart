
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:mom_clean/models/homeBanars.dart';
import 'package:mom_clean/models/normalOrderDetails.dart';
import 'package:mom_clean/models/orders.dart';
import 'package:mom_clean/models/packageOrdersDetails.dart';
import 'package:mom_clean/models/packagesItemsRes.dart';
import 'package:mom_clean/models/packagesRes.dart';
import 'package:mom_clean/models/profileRes.dart';
import 'package:mom_clean/repastory/Authrepasatory.dart';
import 'package:mom_clean/repastory/MainRepastory.dart';
import 'package:mom_clean/ui/packageDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OrdersEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchOrdersDetails extends OrdersEvent {
  final int id;
  FetchOrdersDetails(this.id);

  @override
  List<Object> get props => [id];
}

class FetchPackageOrdersDetails extends OrdersEvent {
  final int id;
  FetchPackageOrdersDetails(this.id);

  @override
  List<Object> get props => [id];
}
abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

class OrdersLoaded extends OrdersState {
    final normalOrderDetails orders;

  OrdersLoaded({this.orders});

 

  @override
  List<Object> get props => [orders];
}
class OrdersPackageLoaded extends OrdersState {
    final packageOrderDetails orders;

  OrdersPackageLoaded({this.orders});

 

  @override
  List<Object> get props => [orders];
}
class OrdersLoading extends OrdersState {}

class OrdersError extends OrdersState {
  String msg;
  OrdersError(this.msg);
}

class OrdersNetworkError extends OrdersState {}

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final MainRepastory Repo;

  OrdersBloc({@required this.Repo}) : super(OrdersLoading());

  @override
  // TODO: implement initialState
  OrdersState get initialState =>OrdersLoading();

  @override
  Stream<OrdersState> mapEventToState(OrdersEvent event) async* {
    final currentState = state;
    if (event is FetchOrdersDetails) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('token');
      try {
      
        yield OrdersLoading();
        final orders = await Repo.getNormalOrderItems(token,event.id);

        //print(package.data.packages[0].nameAr);
        yield OrdersLoaded(orders: orders);

        return;
      } on SocketException catch (_) {
        yield OrdersNetworkError();
      } catch (_) {
        // print("error    "+_);
        yield OrdersError(_.toString());
      }
    } else if(event is FetchPackageOrdersDetails){
                SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('token');
      try {
      
        yield OrdersLoading();
        final orders = await Repo.getPackageOrderItems(token,event.id);

        //print(package.data.packages[0].nameAr);
        yield OrdersPackageLoaded(orders: orders);

        return;
      } on SocketException catch (_) {
        yield OrdersNetworkError();
      } catch (_) {
        // print("error    "+_);
        yield OrdersError(_.toString());
      }
    }
  }
}
