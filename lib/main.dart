import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/config/text_styles.dart';
import 'package:restaurant_app/modules/home/bloc/home_bloc.dart';
import 'package:restaurant_app/modules/home/home_screen.dart';
import 'package:restaurant_app/modules/restaurant/bloc/restaurant_bloc.dart';
import 'package:restaurant_app/modules/restaurant/detail/detail_screen.dart';
import 'package:restaurant_app/modules/restaurant/review/bloc/review_bloc.dart';

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
        BlocProvider(create: (context) => HomeBloc()),
        BlocProvider(create: (context) => RestaurantBloc()),
        BlocProvider(create: (context) => ReviewBloc())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          textTheme: RestaurantTextTheme,
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
        routes: {
          DetailScreen.routeName: (context) =>
              DetailScreen(ModalRoute.of(context)!.settings.arguments as String)
        },
      ),
    );
  }
}
