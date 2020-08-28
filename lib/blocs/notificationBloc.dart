import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mom_clean/models/notificationRes.dart';
import 'package:mom_clean/models/profileRes.dart';
import 'package:mom_clean/repastory/Authrepasatory.dart';
import 'package:mom_clean/repastory/MainRepastory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

abstract class NotificationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchNotification extends NotificationEvent {
 
  FetchNotification();
  
  @override
  List<Object> get props => [];
}
class CancelNotification extends NotificationEvent {
  final int id;
  CancelNotification(this.id);
  
  @override
  List<Object> get props => [id];
}

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}



class NotificationLoading extends NotificationState {}

class NotificationError extends NotificationState {
  final string;
  NotificationError(this.string);
}

class NotificationNetworkError extends NotificationState {}

class NotificationCanceld extends NotificationState {



  @override
  List<Object> get props => [];
}
class NotificationLoaded extends NotificationState {
  final MyNotificationRes notification;

  NotificationLoaded({this.notification});


  @override
  List<Object> get props => [notification];
}
class NotificationDeleted extends NotificationState {



  @override
  List<Object> get props => [];
}

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final MainRepastory Repo;

  NotificationBloc({@required this.Repo}) : super(NotificationLoading());
  
  @override
  // TODO: implement initialState
  NotificationState get initialState => NotificationLoading();

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    final currentState = state;
    if (event is FetchNotification) {
       SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('token');
      try {
     
          yield NotificationLoading();
          final notification = await Repo.getMyNotification(token);
          yield NotificationLoaded( notification:notification);
          return;
        
      } on SocketException catch (_) {
        yield NotificationNetworkError();
      }catch(_){
          yield NotificationError(_.toString());
       
      
         //print("error "+_);
      }
    }else if(event is CancelNotification){
         SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('token');
      try {
     
          yield NotificationLoading();
          final notification = await Repo.deleteNotification(token, event.id);
          //yield NotificationDeleted();
            final notifAndCartNum = await Repo.getNotifcAndCart(token);

        await prefs.setInt(
            "notification", notifAndCartNum.data.statistics.notifications);
        await prefs.setInt("cart", notifAndCartNum.data.statistics.cart);

          return;
        
      } on SocketException catch (_) {
        yield NotificationNetworkError();
      }catch(_){
          yield NotificationError(_.toString());
       
      
         //print("error "+_);
      }
    }
  }}