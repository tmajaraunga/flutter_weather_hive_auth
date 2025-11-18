import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';

import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../models/weather_model.dart';
import '../widgets/weather_card.dart';
import '../services/auth_services.dart';

class HomeScreen extends StatefulWidget {
  // Add a const constructor
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final _cityController = TextEditingController(text: 'London');
  WeatherModel? _weather;
  String? _weatherError;
  bool _loadingWeather = false;

  Future<void> _getWeather() async {
    setState(() {
      _loadingWeather = true;
      _weatherError = null;
    });
    try {
      final svc = context.read<WeatherService>();
      // You can add logic here to fetch and set the weather
    } catch (e) {
      print('Error getting weather: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // FIX: Replace the UnimplementedError with a real UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          // Add a logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthService>().signOut();
              // Navigate back to the login screen
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}
