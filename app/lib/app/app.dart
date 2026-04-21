import 'package:flutter/material.dart';

import '../components/hello_card.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: const Center(
          child: HelloCard(), // ✅ Use your component
        ),
      ),
    );
  }
}
