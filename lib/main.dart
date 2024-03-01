import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocerie_app/bloc/search/search_bloc.dart';
import 'package:grocerie_app/data/repositories/search_repository.dart';
import 'package:grocerie_app/ui/home_page.dart';

import 'bloc/food_bloc.dart';
import 'data/repositories/food_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SearchBloc(
              searchRepository: SearchRepositoryImpl(),
            ),
          ),
          BlocProvider(
              create: (context) => FoodBloc(
                    foodRepository: FoodRepositoryImpl(),
                  )),
        ],
        child: const MaterialApp(
          title: 'Foodie App',
          home: HomePage(),
        ));
  }
}