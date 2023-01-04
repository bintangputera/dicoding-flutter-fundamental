import 'package:restaurant_app/data/model/restaurant/add_new_review_response.dart';
import 'package:restaurant_app/data/model/restaurant/customer_review_model.dart';

abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewSuccess extends ReviewState {
  List<CustomerReview> response;

  ReviewSuccess(this.response);
}

class AddNewReviewSuccess extends ReviewState {
  AddNewReviewResponse response;

  AddNewReviewSuccess(this.response);
}

class ReviewFailure extends ReviewState {
  String message;

  ReviewFailure(this.message);
}
