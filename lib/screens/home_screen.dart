import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';


import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../models/weather_model.dart';
import '../widgets/weather_card.dart';
import '../services/auth_service.dart';


class HomeScreen extends StatefulWidget {
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
    setState(() { _loadingWeather = true; _weatherError = null; });
    try {
      final svc = context.read<W