import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const FavoriteScreen({super.key, required this.onToggleTheme});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/icon/justice_ico.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'GuinéeLex',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            IconButton(
              icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: widget.onToggleTheme,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.favorite_border_sharp,
                  color: Colors.red,
                  size: 30,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Vos Favoris',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Nombre d'articles favoris
            Text(
              'Vous avez 0 articles favoris',

              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 100),
            // Here you can add your favorite items
            Center(
              child: Icon(
                Icons.favorite_outline_sharp,
                size: 100,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucun article favori pour le moment.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              ' Appuyez sur ❤️ lors de la lecture',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
