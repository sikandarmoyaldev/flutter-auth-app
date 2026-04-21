import 'package:flutter/material.dart';

class HelloCard extends StatelessWidget {
  const HelloCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [const Text("Hello, World!")],
      ),
    );
  }
}
