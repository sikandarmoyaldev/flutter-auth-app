// FILE: lib/components/hello_card.dart
import 'package:flutter/material.dart';

class HelloCard extends StatelessWidget {
  const HelloCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Hello, World!'),
      ),
    );
  }
}
