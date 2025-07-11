import 'package:flutter/material.dart';
import 'package:guin_lex_app/features/chatbot/chatbot_screen.dart';
import 'package:guin_lex_app/features/favorite/favorite_screen.dart';
import 'package:guin_lex_app/features/home/home_screen.dart';
import 'package:guin_lex_app/features/profile/profile_screen.dart';
import 'package:guin_lex_app/features/search/search_screen.dart';

class MainScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const MainScreen({super.key, required this.onToggleTheme});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onToggleTheme: widget.onToggleTheme),
      SearchScreen(onToggleTheme: widget.onToggleTheme),
      FavoriteScreen(onToggleTheme: widget.onToggleTheme),
      ChatbotScreen(onToggleTheme: widget.onToggleTheme),
      ProfileScreen(onToggleTheme: widget.onToggleTheme),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color.fromARGB(255, 79, 92, 209),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Recherche'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined),
            label: 'Assistant',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
