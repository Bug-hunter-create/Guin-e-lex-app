import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const CategoryTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 150,
        height: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Adapte la couleur de fond selon le thème
          color:
              isDarkMode
                  ? const Color.fromARGB(255, 44, 47, 49) // Couleur sombre
                  : const Color.fromARGB(255, 240, 244, 248), // Couleur claire
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isDarkMode
                    ? Colors.grey.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.2),
            width: 1,
          ),
          // Ajoute une ombre subtile
          boxShadow: [
            BoxShadow(
              color:
                  isDarkMode
                      ? Colors.black.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 36,
              color: const Color.fromARGB(
                255,
                79,
                92,
                209,
              ), // Garde la couleur d'accent
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                // Adapte la couleur du texte selon le thème
                color: theme.textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
