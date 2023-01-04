import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/modules/restaurant/bloc/restaurant_event.dart';
import 'package:restaurant_app/modules/restaurant/bloc/restaurant_state.dart';

import '../../../data/repository/restaurant_repo.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  late RestaurantRepository repo;

  RestaurantBloc() : super(RestaurantInitial()) {
    repo = RestaurantRepository.instance;

    on<GetDetailRestaurantsEvent>(((event, emit) async {
      emit(RestaurantLoading());
      try {
        var response = await repo.getDetailRestaurant(event.id);

        if (!response.error) {
          emit(RestaurantDetailSuccess(response));
        } else {
          emit(RestaurantFailure(response.message));
        }
      } catch (ex) {
        emit(RestaurantFailure(ex.toString()));
      }
    }));
  }
}
