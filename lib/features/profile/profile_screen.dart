import 'package:flutter/material.dart';
import 'package:guin_lex_app/features/home/widgets/recent_tile.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const ProfileScreen({super.key, required this.onToggleTheme});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Profile Header
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/icon/justice_ico.jpg'),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: const Text(
              'Foula Fofana',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: const Text(
              'Développeur Flutter',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          Divider(),

          const RecentTile(
            title: 'Activité Récente',
            description: 'Accédez à votre activité récente',
            leadingIcon: Icon(Icons.history, color: Colors.white, size: 30.0),
          ),
          const SizedBox(height: 16),
          const RecentTile(
            title: 'Profile Settings',
            description: 'Manage your profile settings and preferences',
            leadingIcon: Icon(Icons.settings, color: Colors.white, size: 30.0),
          ),
          const SizedBox(height: 16),
          const RecentTile(
            title: 'Notifications',
            description: 'Check your notifications and alerts',
            leadingIcon: Icon(
              Icons.notifications,
              color: Colors.white,
              size: 30.0,
            ),
          ),
          const SizedBox(height: 16),
          const RecentTile(
            title: 'Help & Support',
            description: 'Get help and support for any issues',
            leadingIcon: Icon(Icons.help, color: Colors.white, size: 30.0),
          ),
          const SizedBox(height: 16),
          const RecentTile(
            title: 'About Us',
            description: 'Learn more about GuinéeLex and our mission',
            leadingIcon: Icon(Icons.info, color: Colors.white, size: 30.0),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 45, 38, 250),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout, color: Colors.white, size: 20),

                const SizedBox(width: 20),
                const Text(
                  'Rechercher',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
