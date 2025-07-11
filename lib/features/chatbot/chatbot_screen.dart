import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const ChatbotScreen({super.key, required this.onToggleTheme});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color.fromARGB(255, 2, 96, 248);

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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                isDarkMode
                    ? [
                      const Color.fromARGB(255, 17, 18, 20),
                      const Color.fromARGB(255, 12, 13, 14),
                    ]
                    : [
                      const Color.fromARGB(
                        255,
                        253,
                        254,
                        255,
                      ), // Bleu très clair
                      const Color.fromARGB(255, 248, 248, 249), // Bleu clair
                    ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // En-tête avec icône et titre
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                isDarkMode
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.chat_bubble_outline,
                            color: primaryColor,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Assistant juridique IA',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Posez vos questions sur le droit guinéen en langage simple',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Icône centrale avec message de bienvenue
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color:
                            isDarkMode
                                ? Colors.white.withOpacity(0.1)
                                : Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.gavel,
                        size: 40,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Bienvenue dans votre assistant juridique',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Je peux vous aider à comprendre le droit guinéen. Posez-moi une question !',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Questions suggérées
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Questions suggérées',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Boutons de questions suggérées
                    _buildSuggestedQuestion(
                      'Quels sont les droits d\'un locataire ?',
                      isDarkMode,
                    ),
                    const SizedBox(height: 12),
                    _buildSuggestedQuestion(
                      'Comment fonctionne le Code du travail ?',
                      isDarkMode,
                    ),
                    const SizedBox(height: 12),
                    _buildSuggestedQuestion(
                      'Quelles sont les lois sur l\'environnement ?',
                      isDarkMode,
                    ),
                  ],
                ),
              ),
            ),

            // Barre de saisie en bas
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.05),
                border: Border(
                  top: BorderSide(
                    color:
                        isDarkMode
                            ? Colors.white.withOpacity(0.2)
                            : Colors.black.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isDarkMode
                                ? Colors.white.withOpacity(0.1)
                                : Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color:
                              isDarkMode
                                  ? Colors.white.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.2),
                        ),
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Posez votre question...',
                          hintStyle: TextStyle(
                            color: isDarkMode ? Colors.white54 : Colors.black54,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color:
                          isDarkMode
                              ? Colors.white.withOpacity(0.2)
                              : Colors.black.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        color:
                            _messageController.text.isEmpty
                                ? (isDarkMode
                                    ? Colors.grey
                                    : Colors.grey.shade600)
                                : primaryColor,
                      ),
                      onPressed: () {
                        if (_messageController.text.trim().isNotEmpty) {
                          _messageController.clear();
                          setState(() {}); // Pour mettre à jour l'icône
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedQuestion(String question, bool isDarkMode) {
    return Container(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          _messageController.text = question;
          setState(() {}); // Pour mettre à jour l'icône d'envoi
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color:
                isDarkMode
                    ? Colors.white.withOpacity(0.3)
                    : Colors.black.withOpacity(0.2),
          ),
          backgroundColor:
              isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.7),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            question,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
