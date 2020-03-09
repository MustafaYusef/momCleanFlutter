import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mom_clean/models/cartRes.dart';
import 'package:mom_clean/models/notificationRes.dart';
import 'package:mom_clean/models/profileRes.dart';
import 'package:mom_clean/repastory/Authrepasatory.dart';
import 'package:mom_clean/repastory/MainRepastory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddItemToCart extends CartEvent {
 int item_id;
int countWach;
int countdryWash;

int status;// check if just wash or drywach or both (1,2,3)
//wash or dry and wash
  AddItemToCart({this.item_id,this.countWach,this.countdryWash,this.status});
  
  @override
  List<Object> get props => [item_id,countWach,countdryWash,status];
}
class FetchCart extends CartEvent {
  

}
class ReturnToInitial extends CartEvent{

}
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}



class CartLoading extends CartState {}
class ItemAddedSuccusfully extends CartState {}
class CartError extends CartState {
  final string;
  CartError(this.string);
}

class CartNetworkError extends CartState {}
class CartIsEmpty extends CartState {}

class CartUninitial extends CartState {}

class CartLoaded extends CartState {
  final CartRes cart;

  CartLoaded({this.cart});


  @override
  List<Object> get props => [cart];
}


class CartBloc extends Bloc<CartEvent, CartState> {
  final MainRepastory Repo;

  CartBloc({@required this.Repo});
  
  @override
  // TODO: implement initialState
  CartState get initialState => CartUninitial();

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    final currentState = state;
    if (event is AddItemToCart) {
       SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('token');
      try {
     
          yield CartLoading();
          if(event.status==1){
            final cart1 = await Repo.addItemToCart(token,event.item_id,event.countWach,"wash");
             
          }else if(event.status==2){
             final cart2 = await Repo.addItemToCart(token,event.item_id,event.countdryWash,"dry and wash");
          }
          else{
            final cart = await Repo.addItemToCart(token,event.item_id,event.countWach,"wash");
            final cart2 = await Repo.addItemToCart(token,event.item_id,event.countdryWash,"dry and wash");
          }
         
          yield ItemAddedSuccusfully();
          return;
        
      } on SocketException catch (_) {
        yield CartNetworkError();
      }catch(_){
          yield CartError(_.toString());

      }
    }else if(event is ReturnToInitial){
      yield CartUninitial();
    }else if(event is FetchCart){
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('token');
      try {
     
          yield CartLoading();
        
            final cart = await Repo.getMyCart(token);
             if(cart.data.myCart.isEmpty){
    yield CartIsEmpty();
          return;
             }else{
                 yield CartLoaded(cart: cart);
          return;
             }
         
         
        
        
      } on SocketException catch (_) {
        yield CartNetworkError();
      }catch(_){
          yield CartError(_.toString());

      }
    }
  }}