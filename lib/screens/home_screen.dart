import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;

import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../models/weather_model.dart';
import '../widgets/weather_card.dart'; // We will create this widget
import '../services/auth_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _cityController = TextEditingController(text: 'Duluth');
  WeatherModel? _weather;
  String? _weatherError;
  bool _loadingWeather = false;

  // --- 1. GET WEATHER BY CITY NAME ---
  Future<void> _getWeatherByCity() async {
    setState(() {
      _loadingWeather = true;
      _weatherError = null;
      _weather = null;
    });
    try {
      final svc = context.read<WeatherService>();
      final weather = await svc.fetchWeatherByCity(_cityController.text.trim());
      setState(() => _weather = weather);
    } catch (e) {
      setState(() => _weatherError = e.toString());
    } finally {
      if (mounted) setState(() => _loadingWeather = false);
    }
  }

  // --- 2. GET WEATHER BY GPS LOCATION ---
  Future<void> _getWeatherByLocation() async {
    setState(() {
      _loadingWeather = true;
      _weatherError = null;
      _weather = null;
    });
    try {
      // Get device location
      final locationSvc = context.read<LocationService>();
      final locationData = await locationSvc.getLocation();

      // Use geocoding to find city name from coordinates
      final placemarks = await geo.placemarkFromCoordinates(locationData.latitude!, locationData.longitude!);
      final cityName = placemarks.first.locality ?? 'Unknown';
      _cityController.text = cityName;

      // Fetch weather using the found city name
      final weatherSvc = context.read<WeatherService>();
      final weather = await weatherSvc.fetchWeatherByCity(cityName);
      setState(() => _weather = weather);
    } catch (e) {
      setState(() => _weatherError = e.toString());
    } finally {
      if (mounted) setState(() => _loadingWeather = false);
    }
  }

  // --- 3. SAVE WEATHER TO HIVE BOX ---
  void _saveWeather() {
    if (_weather != null) {
      final box = Hive.box('savedBox');
      // Use city name as the key, and store the full weather object
      box.put(_weather!.city, _weather!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_weather!.city} saved!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthService>().signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- INPUT FIELDS ---
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Enter City Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loadingWeather ? null : _getWeatherByCity,
                    child: const Text('Get Weather'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _loadingWeather ? null : _getWeatherByLocation,
                    icon: const Icon(Icons.my_location),
                    label: const Text('My Location'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- DISPLAY RESULTS ---
            if (_loadingWeather)
              const Center(child: CircularProgressIndicator()),
            if (_weatherError != null)
              Text('Error: $_weatherError', style: const TextStyle(color: Colors.redAccent)),
            if (_weather != null)
              WeatherCard(
                weather: _weather!,
                onSave: _saveWeather, // Pass the save function
              ),
          ],
        ),
      ),
      // --- BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // This is the Home screen
        onTap: (index) {
          if (index == 1) Navigator.pushNamed(context, '/saved');
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
