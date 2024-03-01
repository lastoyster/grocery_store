import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocerie_app/bloc/food_bloc.dart';
import 'package:grocerie_app/bloc/food_event.dart';
import 'package:grocerie_app/bloc/food_state.dart';
import 'package:grocerie_app/bloc/search/search_bloc.dart';
import 'package:grocerie_app/bloc/search/search_event.dart';
import 'package:grocerie_app/bloc/search/search_state.dart';
import 'package:grocerie_app/data/repositories/food_repository.dart';
import 'package:grocerie_app/elements/error.dart';
import 'package:grocerie_app/elements/list.dart';
import 'package:grocerie_app/elements/loading.dart';
import 'package:grocerie_app/ui/food_detail.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => FoodBloc(foodRepository: FoodRepositoryImpl())
          ..add(FetchFoodEvent()),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Food Search App"),
            actions: [
              IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: FoodSearch(
                            searchBloc: BlocProvider.of<SearchBloc>(context)));
                  }),
            ],
          ),
          body: SingleChildScrollView(
            child: BlocBuilder<FoodBloc, FoodState>(builder: (context, state) {
              if (state is FoodInitialState) {
                return buildLoading();
              } else if (state is FoodLoadingState) {
                return buildLoading();
              } else if (state is FoodLoadedState) {
                return buildHintsList(state.recipes);
              } else if (state is FoodErrorState) {
                return buildError(state.message);
              }
              return Container();
            }),
          ),
        ));
  }
}

class FoodSearch extends SearchDelegate<List> {
  SearchBloc searchBloc;
  FoodSearch({required this.searchBloc});
  String? queryString;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          close(context, []);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    queryString = query;
    searchBloc.add(Search(query: query));
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (BuildContext context, SearchState state) {
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SearchError) {
          return const Center(
            child: Text('Data Not Found'),
          );
        }
        if (state is SearchLoaded) {
          if (state.recipes.isEmpty) {
            return const Center(
              child: Text('No Results'),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 3.7 / 4,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20),
                      itemCount: state.recipes.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FoodDetail(
                                        recipes: state.recipes[index])));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            // alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 236, 236, 235),
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox(
                                    height: 90,
                                    width: MediaQuery.of(context).size.width,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        state.recipes[index].imageUrl!,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  state.recipes[index].title!,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  state.recipes[index].publisher!,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }
        return const Scaffold();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}