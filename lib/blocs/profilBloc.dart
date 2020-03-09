import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mom_clean/models/profileRes.dart';
import 'package:mom_clean/repastory/Authrepasatory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchProfile extends ProfileEvent {
 
  FetchProfile();
  
  @override
  List<Object> get props => [];
}


abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileUninitialized extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileError extends ProfileState {
  final string;
  ProfileError(this.string);
}

class ProfileNetworkError extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final profileRes profile;

  ProfileLoaded({this.profile});

 ProfileLoaded copyWith({
    profileRes profile,
  }) {
    return ProfileLoaded(
      profile: profile ?? this.profile
    );
  }
  @override
  List<Object> get props => [profile];
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepastory Repo;

  ProfileBloc({@required this.Repo});
  
  @override
  // TODO: implement initialState
  ProfileState get initialState => ProfileUninitialized();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    final currentState = state;
    if (event is FetchProfile) {
       SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('token');
      try {
     
          yield ProfileLoading();
          final profile = await Repo.getProfile(token);
          yield ProfileLoaded( profile:profile);
          return;
        
      } on SocketException catch (_) {
        yield ProfileNetworkError();
      }catch(_){
          yield ProfileError(_.toString());
       
      
         //print("error "+_);
      }
    }
  }}