import 'package:restaurant_app/data/model/restaurant/add_new_review_response.dart';
import 'package:restaurant_app/data/model/restaurant/get_detail_restaurant_model.dart';
import 'package:restaurant_app/data/remote/network_service.dart';

import '../model/restaurant/get_restaurant_model.dart';

class RestaurantRepository extends NetworkService {
  RestaurantRepository();
  RestaurantRepository._privateConstructor();
  static final RestaurantRepository _instance =
      RestaurantRepository._privateConstructor();
  static RestaurantRepository get instance => _instance;

  Future<GetRestaurantsResponse> getRestaurant() async {
    var map = await getMethod("list");
    print(map);
    return GetRestaurantsResponse.fromJson(map);
  }

  Future<GetDetailRestaurantsResponse> getDetailRestaurant(String id) async {
    var map = await getMethod("detail/$id");
    print(map);
    return GetDetailRestaurantsResponse.fromJson(map);
  }

  Future<GetRestaurantsResponse> searchRestaurant(String query) async {
    var map = await getMethod("search?q=$query");
    print(map);
    return GetRestaurantsResponse.fromJson(map);
  }

  Future<AddNewReviewResponse> addNewReview(Map<String, dynamic> body) async {
    var map = await postMethod("review", body);
    print(map);
    return AddNewReviewResponse.fromJson(map);
  }
}
