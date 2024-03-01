import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {}

class Search extends SearchEvent {
  final String query;

  Search({required this.query});

  @override
  List<Object> get props => [];
}