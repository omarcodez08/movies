import 'package:flutter/material.dart';
import 'package:movies/UI/authentication/forget_pass/forget_password_screen.dart';
import 'package:movies/UI/authentication/login/login_screen.dart';
import 'package:movies/UI/authentication/register/register_screen.dart';
import 'package:movies/UI/main_layout/browse/browse_tab.dart';
import 'package:movies/UI/main_layout/home/home_tab.dart';
import 'package:movies/UI/main_layout/main_layout_screen.dart';
import 'package:movies/UI/main_layout/profile/edit_profile_screen.dart';
import 'package:movies/UI/main_layout/profile/profile_tab.dart';
import 'package:movies/UI/main_layout/search/search_tab.dart';
import 'package:movies/UI/on_boarding/screen/on_boarding.dart';

class RoutesManager {
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String forgetPasswordRoute = '/forget_password';
  static const String mainLayoutRoute = '/main_layout';
  static const String homeRoute = '/home';
  static const String browseRoute = '/browse';
  static const String searchRoute = '/search';
  static const String profileRoute = '/profile';
  static const String editProfileRoute = '/edit_profile';

  static Map<String, WidgetBuilder> routes = {
    // splashRoute: (context) =>  SplashScreen(),
    onboardingRoute: (context) =>  OnBoardingScreen(),
    loginRoute: (context) =>  LoginScreen(),
    registerRoute: (context) =>  RegisterScreen(),
    forgetPasswordRoute: (context) =>  ForgetPasswordScreen(),
    mainLayoutRoute: (context) =>  MainLayoutScreen(),
    homeRoute: (context) =>  HomeTab(),
    browseRoute: (context) =>  BrowseTab(),
    searchRoute: (context) =>  SearchTab(),
    profileRoute: (context) =>  ProfileTab(),
    editProfileRoute: (context) =>  EditProfileScreen(),
  };
}