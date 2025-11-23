import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/weather_model.dart';class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('savedBox');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Locations'),
      ),
      // Use a ValueListenableBuilder to automatically update the UI when Hive changes
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('You have no saved locations.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final key = box.keyAt(index) as String;
              final weather = box.get(key) as WeatherModel;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(weather.city),
                  subtitle: Text(weather.description),
                  trailing: Text('${weather.tempC.toStringAsFixed(1)}°C'),
                  // Add a delete button
                  onLongPress: () => box.delete(key),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // This is the Saved screen
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 2) Navigator.pushNamed(context, '/map');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.save), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
        ],
      ),
    );
  }
}

