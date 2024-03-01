import 'package:equatable/equatable.dart';
import '/data/model/food.dart';

abstract class FoodState extends Equatable {}

class FoodInitialState extends FoodState {
  @override
  List<Object> get props => [];
}

class FoodLoadingState extends FoodState {
  @override
  List<Object> get props => [];
}

class FoodLoadedState extends FoodState {
  final List<Recipe> recipes;
  FoodLoadedState({required this.recipes});
  @override
  List<Object> get props => [];
}

class FoodErrorState extends FoodState {
  final String message;
  FoodErrorState({required this.message});
  @override
  List<Object> get props => [];
}