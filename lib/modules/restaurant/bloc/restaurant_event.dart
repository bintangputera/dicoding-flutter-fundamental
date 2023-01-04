abstract class RestaurantEvent {}

class GetDetailRestaurantsEvent extends RestaurantEvent {
  final String id;

  GetDetailRestaurantsEvent(this.id);
}
