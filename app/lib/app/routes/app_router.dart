import 'package:auth_app/app/routes/app_routes.dart';
import 'package:auth_app/features/auth/screens/login_screen.dart';
import 'package:auth_app/features/auth/screens/register_screen.dart';
import 'package:auth_app/features/auth/widgets/auth_guard.dart';
import 'package:auth_app/features/auth/widgets/guest_guard.dart';
import 'package:auth_app/screens/about_screen.dart';
import 'package:auth_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static final Map<String, WidgetBuilder> routes = {
    AppRoutes.home: (context) => AuthGuard(child: const HomeScreen()),
    AppRoutes.about: (context) => GuestGuard(child: const AboutScreen()),
    AppRoutes.login: (context) => GuestGuard(child: const LoginScreen()),
    AppRoutes.register: (context) => GuestGuard(child: const RegisterScreen()),
  };
}
