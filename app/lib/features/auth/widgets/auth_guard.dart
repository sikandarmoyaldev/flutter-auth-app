import 'package:flutter/material.dart';

import '../services/auth_api.dart';

class AuthGuard extends StatefulWidget {
  final Widget child;
  final String redirectRoute;

  const AuthGuard({
    required this.child,
    this.redirectRoute = '/auth/login',
    super.key,
  });

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return widget.child;
  }

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(Duration.zero);
    if (!mounted) return;

    try {
      final authenticated = await AuthApi.isAuthenticated();

      if (!mounted) return;

      if (!authenticated) {
        Navigator.pushReplacementNamed(context, widget.redirectRoute);
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('AuthGuard error: $e');
      if (mounted) {
        Navigator.pushReplacementNamed(context, widget.redirectRoute);
      }
    }
  }
}
