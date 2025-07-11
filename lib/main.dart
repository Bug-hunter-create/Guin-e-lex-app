import 'package:flutter/material.dart';
import 'package:guin_lex_app/features/home/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = true;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Thème clair
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(
            255,
            79,
            92,
            209,
          ), // Couleur GuinéeLex en clair
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.grey,
        ),
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color.fromARGB(255, 79, 92, 209),
          unselectedItemColor: Colors.grey,
        ),
      ),
      // Thème sombre
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 44, 47, 49),
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 18),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 44, 47, 49),
          selectedItemColor: Color.fromARGB(255, 79, 92, 209),
          unselectedItemColor: Colors.grey,
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Guin Lex App',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MainScreen(onToggleTheme: toggleTheme),
    );
  }
}
