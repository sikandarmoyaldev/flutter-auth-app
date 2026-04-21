import 'package:auth_app/app/routes/app_routes.dart';
import 'package:auth_app/features/auth/services/auth_api.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoggingOut = false;
  Map<String, String>? _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home${_user != null ? ', ${_user!['name']}' : ''}'),
        actions: [
          // Logout button in AppBar (optional)
          IconButton(
            icon: _isLoggingOut
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.logout),
            onPressed: _isLoggingOut ? null : _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 👤 Display user info if loaded
            if (_user != null) ...[
              Text(
                'Welcome, ${_user!['name']}!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _user!['email']!,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
            ],

            const Text('Home', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),

            // Navigate to About
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.about),
              child: const Text('Go to About'),
            ),
            const SizedBox(height: 16),

            // Navigate to Login (for testing GuestGuard)
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
              child: const Text('Go to Login'),
            ),
            const SizedBox(height: 16),

            // Logout button in body
            ElevatedButton(
              onPressed: _isLoggingOut ? null : _handleLogout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: _isLoggingOut
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUser(); // Load stored user data on startup
  }

  // 🚪 Handle logout with loading state + error handling
  Future<void> _handleLogout() async {
    // Optional: Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    // User cancelled or widget unmounted
    if (confirmed != true || !mounted) return;

    // Show loading state
    setState(() => _isLoggingOut = true);

    try {
      // 🔥 Await the logout call
      await AuthApi.logout();

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // 🔥 Clear navigation stack + go to login
      // (prevents back-button returning to protected pages)
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false, // Remove ALL previous routes
        );
      }
    } catch (e) {
      if (!mounted) return;

      // Show actual error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Always hide loading state if still mounted
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  // 👤 Load user data from secure storage
  Future<void> _loadUser() async {
    final user = await AuthApi.getUser();
    if (mounted) {
      setState(() => _user = user);
    }
  }
}
