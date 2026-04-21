import 'package:auth_app/app/routes/app_routes.dart';
import 'package:auth_app/features/auth/screens/login_screen.dart';
import 'package:auth_app/features/auth/screens/register_screen.dart';
import 'package:auth_app/screens/about_screen.dart';
import 'package:auth_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static final Map<String, WidgetBuilder> routes = {
    AppRoutes.home: (context) => const HomeScreen(),
    AppRoutes.about: (context) => const AboutScreen(),
    AppRoutes.login: (context) => const LoginScreen(),
    AppRoutes.register: (context) => const RegisterScreen(),
  };
}
