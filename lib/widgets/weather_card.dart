import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final VoidCallback onSave; // Callback for the save button

  const WeatherCard({
    super.key,
    required this.weather,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(weather.city, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              '${weather.tempC.toStringAsFixed(1)}°C',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(weather.description, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            IconButton(
              icon: const Icon(Icons.save_alt_outlined),
              tooltip: 'Save Location',
              onPressed: onSave,
            ),
          ],
        ),
      ),
    );
  }
}
