abstract class ReviewEvent {}

class GetRestaurantsReviewEvent extends ReviewEvent {
  final String id;

  GetRestaurantsReviewEvent(this.id);
}

class AddNewReviewEvent extends ReviewEvent {
  final Map<String, dynamic> body;

  AddNewReviewEvent(this.body);
}
