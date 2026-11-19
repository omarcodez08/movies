
import 'package:flutter/material.dart';
import 'package:movies/UI/login/login_screen.dart';
import 'package:movies/UI/on_boarding/screen/on_boarding.dart';
import 'package:movies/UI/register/register_screen.dart';
import 'package:movies/UI/search/search_screen.dart';
import 'package:movies/UI/browse/browse_screen.dart';
import 'package:movies/UI/details/details_screen.dart';

class RoutesManager {
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String browseRoute = '/browse';
  static const String searchRoute = '/search';
  static const String detailsRoute = '/details';
  static const String profileRoute = '/profile';

  static Map<String, WidgetBuilder> routes = {
    onboardingRoute: (context) => const OnBoardingScreen(),
    loginRoute: (context) => LoginScreen(),
    registerRoute: (context) => RegisterScreen(),
    browseRoute: (context) => BrowseScreen(),
    searchRoute: (context) => SearchScreen(),
    detailsRoute: (context) => DetailsScreen(),

  };
}
