import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/sample_item.dart';
import '../services/local_json_service.dart';

class ItemListScreen extends StatelessWidget {
  const ItemListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local JSON Items'),
      ),
      // Use a FutureBuilder to handle the asynchronous loading of JSON
      body: FutureBuilder<List<SampleItem>>(
        future: context.read<LocalJsonService>().loadSampleItems(),
        builder: (context, snapshot) {
          // While waiting for data, show a loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // If an error occurs, display it
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // If data is loaded successfully, display it in a list
          if (snapshot.hasData) {
            final items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.description),
                    leading: CircleAvatar(child: Text(item.id.toString())),
                  ),
                );
              },
            );
          }
          // Fallback
          return const Center(child: Text('No items found.'));
        },
      ),
    );
  }
}
