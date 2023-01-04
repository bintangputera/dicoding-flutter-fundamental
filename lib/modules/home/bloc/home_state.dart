import 'package:restaurant_app/data/model/restaurant/get_restaurant_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  GetRestaurantsResponse response;

  HomeSuccess(this.response);
}

class HomeEmpty extends HomeState {}

class HomeFailure extends HomeState {
  String message;

  HomeFailure(this.message);
}
