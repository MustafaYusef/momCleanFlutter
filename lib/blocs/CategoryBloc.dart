import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:mom_clean/models/categoryItemsRes.dart';
import 'package:mom_clean/models/categoryRes.dart';
import 'package:mom_clean/models/profileRes.dart';
import 'package:mom_clean/repastory/Authrepasatory.dart';
import 'package:mom_clean/repastory/MainRepastory.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCategory extends CategoryEvent {
   final int id;
  FetchCategory(this.id);

  @override
  List<Object> get props => [id];
}

class FetchItemsCategory extends CategoryEvent {
  int id;
  FetchItemsCategory(this.id);

  @override
  List<Object> get props => [id];
}

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryUninitialized extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryItemsLoading extends CategoryState {
  final categoryRes category;

  CategoryItemsLoading({this.category});
  CategoryItemsLoading copyWith({
    categoryRes category,
  }) {
    return CategoryItemsLoading(category: category ?? this.category);
  }

  @override
  List<Object> get props => [category];
}

class CategoryError extends CategoryState {}

class CategoryNetworkError extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final categoryRes category;
final categoryItemsRes categoryItems;
  CategoryLoaded({this.category,this.categoryItems});
  CategoryLoaded copyWith({
    categoryRes category,
  }) {
    return CategoryLoaded(category: category ?? this.category,categoryItems: categoryItems ?? this.categoryItems);
  }

  @override
  List<Object> get props => [category];
}

class CategoryItemsLoaded extends CategoryState {
  final categoryItemsRes categoryItem;

  CategoryItemsLoaded({this.categoryItem});
  CategoryItemsLoaded copyWith({
    categoryItemsRes categoryItem,
  }) {
    return CategoryItemsLoaded(categoryItem: categoryItem ?? this.categoryItem);
  }

  @override
  List<Object> get props => [categoryItem];
}

// Future<Position> getLocation() async {
//   Position position = await Geolocator()
//       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   print(position);
//   return position;
// }

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final MainRepastory Repo;

  CategoryBloc({@required this.Repo}) : super(CategoryLoading());

  @override
  // TODO: implement initialState
  CategoryState get initialState => CategoryLoading();

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    final currentState = state;
    if (event is FetchCategory) {
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

        yield CategoryLoading();
        final category = await Repo.getCategory();
        var id=event.id==-1?category.data.categories[0].id:event.id;
        final categorytems =
            await Repo.getItemsGategore(id, _locationData.longitude, _locationData.latitude);
        yield CategoryLoaded(category: category,categoryItems:categorytems);

        return;
      } on SocketException catch (_) {
        yield CategoryNetworkError();
      } catch (_) {
        yield CategoryError();
      }
    } else if (event is FetchItemsCategory) {
      try {
        yield CategoryLoading();
      
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
      //  var pos = await getLocation();

        final categorytems =
            await Repo.getItemsGategore(event.id, _locationData.longitude, _locationData.latitude);
        yield CategoryItemsLoaded(categoryItem: categorytems);
        return;
      } on SocketException catch (_) {
        yield CategoryNetworkError();
      } catch (_) {
        print(_.toString());
        yield CategoryError();
      }
    }
  }
}
