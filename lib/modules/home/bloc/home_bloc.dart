import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/data/repository/restaurant_repo.dart';
import 'package:restaurant_app/modules/home/bloc/home_event.dart';
import 'package:restaurant_app/modules/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late RestaurantRepository repo;

  HomeBloc() : super(HomeInitial()) {
    repo = RestaurantRepository.instance;

    on<GetListRestaurantsEvent>(((event, emit) async {
      emit(HomeLoading());
      try {
        var response = await repo.getRestaurant();

        if (!response.error) {
          emit(HomeSuccess(response));
        } else {
          emit(HomeFailure(response.message));
        }
      } catch (ex) {
        emit(HomeFailure(ex.toString()));
      }
    }));

    on<SearchRestaurantsEvent>(((event, emit) async {
      emit(HomeLoading());
      try {
        var response = await repo.searchRestaurant(event.query);

        if (!response.error) {
          if (response.restaurants.isEmpty) {
            emit(HomeEmpty());
          } else {
            emit(HomeSuccess(response));
          }
        } else {
          emit(HomeFailure(response.message));
        }
      } catch (ex) {
        emit(HomeFailure(ex.toString()));
      }
    }));
  }
}
