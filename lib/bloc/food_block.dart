import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocerie_app/bloc/food_event.dart';
import 'package:grocerie_app/bloc/food_state.dart';
import 'package:grocerie_app/data/model/food.dart';
import 'package:grocerie_app/data/repositories/food_repository.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodRepository foodRepository;

  FoodBloc({
    required this.foodRepository,
  }) : super(FoodLoadingState()) {
    on<FetchFoodEvent>((event, emit) async {
      emit(FoodLoadingState());

      try {
        List<Recipe> recipes = await foodRepository.getFoods();
        emit(FoodLoadedState(recipes: recipes));
      } catch (e) {
        emit(FoodErrorState(message: e.toString()));
      }
    });
  }
}
