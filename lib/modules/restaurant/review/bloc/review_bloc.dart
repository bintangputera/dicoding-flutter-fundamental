import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/data/repository/restaurant_repo.dart';
import 'package:restaurant_app/modules/restaurant/review/bloc/review_event.dart';
import 'package:restaurant_app/modules/restaurant/review/bloc/review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  late RestaurantRepository repo;

  ReviewBloc() : super(ReviewInitial()) {
    repo = RestaurantRepository.instance;

    on<AddNewReviewEvent>(((event, emit) async {
      emit(ReviewLoading());
      try {
        var response = await repo.addNewReview(event.body);

        if (!response.error) {
          emit(ReviewSuccess(response.customerReviews));
        } else {
          emit(ReviewFailure(response.message));
        }
      } catch (ex) {
        emit(ReviewFailure(ex.toString()));
      }
    }));

    on<GetRestaurantsReviewEvent>(((event, emit) async {
      emit(ReviewLoading());
      try {
        var response = await repo.getDetailRestaurant(event.id);

        if (!response.error) {
          emit(ReviewSuccess(response.restaurant.customerReviews));
        } else {
          emit(ReviewFailure(response.message));
        }
      } catch (ex) {
        emit(ReviewFailure(ex.toString()));
      }
    }));
  }
}
