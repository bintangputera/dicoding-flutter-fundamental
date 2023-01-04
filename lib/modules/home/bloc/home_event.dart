abstract class HomeEvent {}

class GetListRestaurantsEvent extends HomeEvent {
  GetListRestaurantsEvent();
}

class SearchRestaurantsEvent extends HomeEvent {
  final String query;

  SearchRestaurantsEvent(this.query);
}
