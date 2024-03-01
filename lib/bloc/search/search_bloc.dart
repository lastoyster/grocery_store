// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';

import '/bloc/search/search_state.dart';
import '/data/model/food.dart';
import '/data/repositories/search_repository.dart';

import 'search_event.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepository;

  SearchBloc({
    required this.searchRepository,
  }) : super(SearchLoading()) {
    on<Search>((event, emit) async {
      emit(SearchLoading());

      try {
        List<Recipe> recipes = await searchRepository.searchFoods(event.query);
        emit(SearchLoaded(recipes: recipes));
      } catch (e) {
        emit(SearchError());
      }
    });
  }
}