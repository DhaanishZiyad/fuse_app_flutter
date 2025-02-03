import 'package:flutter/material.dart';
import 'package:fuse_app/layout.dart';
import 'package:fuse_app/login.dart';
import 'package:fuse_app/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Define the initial theme mode
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadThemeMode(); // Load the saved theme mode from shared preferences
  }

  void _toggleTheme() async {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
    _saveThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('darkMode') ?? false;
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _saveThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', _themeMode == ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuse Jerseys',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode, // Apply the theme mode here
      theme: ThemeData.light(), // Light theme
      darkTheme: ThemeData.dark(), // Dark theme
      initialRoute: AppLayout.id,
      routes: {
        AppLayout.id: (context) => AppLayout(onToggleTheme: _toggleTheme), // Pass _toggleTheme to AppLayout
        Login.id: (context) => const Login(),
        Signup.id: (context) => const Signup(),
      },
    );
  }
}
