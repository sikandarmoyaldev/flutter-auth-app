// FILE: lib/components/hello_card.dart
import 'package:flutter/material.dart';

class HelloCard extends StatelessWidget {
  const HelloCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "Enter Your Name",
              hintStyle: TextStyle(color: Colors.red[500]),
              label: Text("Name"),
              labelStyle: TextStyle(
                backgroundColor: Colors.blue[500],
                color: Colors.black,
                fontSize: 25,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.red, width: 25),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.red),
              ),
              prefixIcon: Icon(Icons.person, color: Colors.grey[500]),
              filled: true,
              fillColor: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 12), // 👈 Add spacing between field and text
          const Text("Hello, World!"),
        ],
      ),
    );
  }
}
