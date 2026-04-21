import 'package:flutter/material.dart';

import '../services/auth_api.dart';

class GuestGuard extends StatelessWidget {
  final Widget child;
  final String redirectRoute;

  const GuestGuard({
    required this.child,
    this.redirectRoute = '/home',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Check auth on first build (no State needed for simple case)
    AuthApi.isAuthenticated().then((authenticated) {
      if (authenticated && context.mounted) {
        Navigator.pushReplacementNamed(context, redirectRoute);
      }
    });
    return child; // Show login/register immediately
  }
}
