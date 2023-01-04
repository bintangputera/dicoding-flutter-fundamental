import 'package:restaurant_app/data/model/restaurant/get_detail_restaurant_model.dart';

abstract class RestaurantState {}

class RestaurantInitial extends RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantDetailSuccess extends RestaurantState {
  GetDetailRestaurantsResponse response;

  RestaurantDetailSuccess(this.response);
}

class RestaurantFailure extends RestaurantState {
  String message;

  RestaurantFailure(this.message);
}
