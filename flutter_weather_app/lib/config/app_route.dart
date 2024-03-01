import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/presentation/view/signIn/cubit/sign_in_cubit.dart';
import 'package:flutter_weather_app/presentation/view/signIn/sign_in_view.dart';

import '../presentation/view/home/cubit/home_cubit.dart';
import '../presentation/view/home/home_view.dart';
import '../presentation/view/signUp/cubit/sign_up_cubit.dart';
import '../presentation/view/signUp/sign_up_view.dart';
import 'extenstions/page_navigation.dart';

class AppRoute {
  static const String signInRoute = "/SignInRoute";
  static const String signUpRoute = "/SignupPage";
  static const String homeRoute = "/HomeRoute";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signInRoute:
        return PageNavigation.push(
            isLTR: true,
            child: BlocProvider(
                create: (context) => SignInCubit(), child: SignInScreen()));

      case signUpRoute:
        return PageNavigation.push(
            isLTR: true,
            child: BlocProvider(
                create: (context) => SignUpCubit(), child: SignUpScreen()));


      case homeRoute:
        return PageNavigation.push(
            isLTR: true,
            child: BlocProvider(
                create: (context) => HomeCubit(), child: HomeScreen()));

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
