import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("About", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            ElevatedButton(
              child: Text("Redirect Home"),
              onPressed: () => Navigator.pushNamed(context, 'home'),
            ),
          ],
        ),
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth App',
      debugShowCheckedModeBanner: false,
      initialRoute: "about",
      routes: {
        'home': (context) => const HomeScreen(),
        'about': (context) => const AboutScreen(),
      },
    );
  }
}

// 🔹 Simple full-screen widgets (must return a Widget, ideally Scaffold)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Home", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, 'about'),
              child: Text('Redirect About'),
            ),
          ],
        ),
      ),
    );
  }
}
