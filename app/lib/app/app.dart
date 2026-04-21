import 'package:auth_app/app/routes/app_router.dart';
import 'package:auth_app/app/routes/app_routes.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth App',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initial,
      routes: AppRouter.routes,
    );
  }
}
