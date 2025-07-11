import 'package:flutter/material.dart';
import 'package:guin_lex_app/features/home/widgets/recent_tile.dart';
import 'widgets/category_tile.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const HomeScreen({super.key, required this.onToggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 79, 92, 209),
        onPressed: () {},
        child: const Icon(
          Icons.chat_outlined,
          color: Color.fromARGB(255, 253, 254, 255),
        ),
      ),
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
            // Texte de bienvenue
            const Text(
              'Bienvenue sur GuinéeLex',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    width: 100,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 248, 5, 5),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    width: 100,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 217, 255, 2),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    width: 100,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 4, 255, 4),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Description de l'application
            const Text(
              'Votre application de référence pour accéder aux textes juridiques guinéens.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Barre de recherche
            TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un texte juridique...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Titre section catégories
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Catégories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.category, size: 22),
              ],
            ),
            const SizedBox(height: 16),

            // Grille des catégories
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                CategoryTile(title: "Lois", icon: Icons.book),
                CategoryTile(title: "Décrets", icon: Icons.library_books),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                CategoryTile(title: "Arrêtés", icon: Icons.article),
                CategoryTile(title: "Codes", icon: Icons.note),
              ],
            ),
            const SizedBox(height: 24),

            // Titre section textes récents
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Textes récents',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.new_releases, size: 22),
              ],
            ),
            const SizedBox(height: 16),

            // Liste des textes récents
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return RecentTile(
                  title: 'Texte Juridique ${index + 1}',
                  description: 'Description du texte juridique ${index + 1}',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
