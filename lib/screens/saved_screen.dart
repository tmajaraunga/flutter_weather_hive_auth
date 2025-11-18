import 'package:flutter/material.dart';

class SavedScreen extends StatelessWidget {
  // Add a const constructor
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Items'),
      ),
      body: const Center(
        child: Text('Saved Screen'),
      ),
    );
  }
}
