import 'package:equatable/equatable.dart';
import '/data/model/food.dart';

abstract class SearchState extends Equatable {}

class SearchLoading extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchLoaded extends SearchState {
  final List<Recipe> recipes;
  SearchLoaded({required this.recipes});
  @override
  List<Object> get props => [];
}

class SearchError extends SearchState {
  @override
  List<Object> get props => [];
}