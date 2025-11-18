import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';


import 'services/auth_services.dart';import 'services/weather_service.dart';
import 'services/local_json_service.dart';
import 'services/location_service.dart';


import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/item_list_screen.dart';
import 'screens/saved_screen.dart';
import 'screens/map_screen.dart';


import 'package:google_fonts/google_fonts.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('savedBox');
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    final ThemeData base = ThemeData.dark();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => WeatherService()),
        Provider(create: (_) => LocalJsonService()),
        Provider(create: (_) => LocationService()),
      ],
      child: MaterialApp(
        title: 'ProtoWeatherHiveAuth',
        theme: base.copyWith(
          scaffoldBackgroundColor: const Color(0xFF0F1724),
          textTheme: GoogleFonts.interTextTheme(base.textTheme),
          colorScheme: base.colorScheme.copyWith(
            primary: Colors.cyan,
            secondary: Colors.amber,
          ),
        ),
        initialRoute: '/',
        routes: {
          // FIX: Removed 'const' because the screen widgets do not have const constructors.
          '/': (_) => EntryGate(),
          '/home': (_) => HomeScreen(),
          '/items': (_) => ItemListScreen(),
          '/saved': (_) => SavedScreen(),
          '/map': (_) => MapScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


class EntryGate extends StatelessWidget {
  const EntryGate({super.key});


  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    // FIX: Removed 'const' because LoginScreen and HomeScreen do not have const constructors.
    if (auth.user == null) return LoginScreen();
    return HomeScreen();
  }
}

