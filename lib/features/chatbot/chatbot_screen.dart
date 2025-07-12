import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Modèle pour les messages
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isLoading;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isLoading = false,
  });
}

// Modèle pour les réponses juridiques prédéfinies
class LegalResponse {
  static final Map<String, String> responses = {
    'locataire': '''
Droits du locataire en Guinée :

• Droit à un logement décent : Le bailleur doit fournir un logement en bon état
• Protection contre l'expulsion abusive : Procédure légale obligatoire
• Droit au préavis : Délai minimum de 3 mois pour résiliation
• Dépôt de garantie : Maximum 3 mois de loyer
• Réparations : À la charge du bailleur sauf usage normal

Base légale : Code civil guinéen, articles 1728-1831*
    ''',
    'travail': '''
Code du travail guinéen - Points clés :

• Durée légale : 40h/semaine, 8h/jour maximum
• Congés payés : 2,5 jours/mois travaillé (30 jours/an)
• Salaire minimum : Fixé par décret gouvernemental
• Préavis de licenciement : 1 mois (cadres), 15 jours (autres)
• Indemnités : En cas de licenciement abusif

*Référence : Loi L/2014/072/CNT du Code du travail
    ''',
    'environnement': '''
Lois environnementales en Guinée :

• Code de l'environnement : Protection des ressources naturelles
• Études d'impact : Obligatoires pour grands projets
• Zones protégées : Parcs nationaux et réserves
• Pollution : Sanctions pénales et civiles
• Exploitation minière : Réglementation stricte

Base : Code de l'environnement L/2019/0034/AN
    ''',
  };

  static String getResponse(String query) {
    query = query.toLowerCase();

    if (query.contains('locataire') ||
        query.contains('bail') ||
        query.contains('loyer')) {
      return responses['locataire']!;
    } else if (query.contains('travail') ||
        query.contains('emploi') ||
        query.contains('salaire')) {
      return responses['travail']!;
    } else if (query.contains('environnement') ||
        query.contains('pollution') ||
        query.contains('écologie')) {
      return responses['environnement']!;
    } else {
      return '''
Je comprends votre question sur le droit guinéen. Pour vous donner une réponse précise, pourriez-vous me fournir plus de détails ?

**Domaines que je couvre :**
• Droit civil et commercial
• Droit du travail
• Droit de l'environnement
• Droit pénal
• Droit administratif

N'hésitez pas à reformuler votre question pour une réponse plus spécifique.*
      ''';
    }
  }
}

class ChatbotScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const ChatbotScreen({super.key, required this.onToggleTheme});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  late AnimationController _fadeAnimationController;
  late AnimationController _scaleAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimationController.forward();
    _scaleAnimationController.forward();

    // Message de bienvenue
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addWelcomeMessage();
    });
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(
        ChatMessage(
          text:
              'Bonjour ! Je suis votre assistant juridique GuinéeLex. Comment puis-je vous aider avec le droit guinéen aujourd\'hui ?',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();

    // Haptic feedback
    HapticFeedback.lightImpact();

    setState(() {
      _messages.add(
        ChatMessage(text: userMessage, isUser: true, timestamp: DateTime.now()),
      );
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate typing delay
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _isTyping = false;
      _messages.add(
        ChatMessage(
          text: LegalResponse.getResponse(userMessage),
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _handleSuggestedQuestion(String question) {
    _messageController.text = question;
    _sendMessage();
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Effacer la conversation'),
            content: const Text(
              'Voulez-vous vraiment effacer toute la conversation ?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _messages.clear();
                  });
                  _addWelcomeMessage();
                },
                child: const Text(
                  'Effacer',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color.fromARGB(255, 2, 96, 248);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          children: [
            Hero(
              tag: 'app_logo',
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFE8142A),
                      Color(0xFFD9FF02),
                      Color(0xFF04FF04),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4F5CD1).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.balance, color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GuinéeLex',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Assistant IA • En ligne',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (_messages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _clearChat,
              tooltip: 'Effacer la conversation',
            ),
          IconButton(
            icon: Stack(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8142A),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () => _showComingSoon('Notifications'),
          ),
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: const Color(0xFF4F5CD1),
            ),
            onPressed: widget.onToggleTheme,
          ),
        ],
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
                      const Color.fromARGB(255, 253, 254, 255),
                      const Color.fromARGB(255, 248, 248, 249),
                    ],
          ),
        ),
        child: Column(
          children: [
            // Zone de chat ou écran de bienvenue
            Expanded(
              child:
                  _messages.isEmpty
                      ? _buildWelcomeScreen(isDarkMode)
                      : _buildChatArea(isDarkMode),
            ),

            // Zone de frappe si quelqu'un tape
            if (_isTyping) _buildTypingIndicator(isDarkMode),

            // Barre de saisie
            _buildInputArea(isDarkMode, primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen(bool isDarkMode) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Icône centrale animée
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:
                      isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4F5CD1).withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.gavel,
                  size: 50,
                  color: const Color(0xFF4F5CD1),
                ),
              ),
              const SizedBox(height: 30),

              Text(
                'Bienvenue dans GuinéeLex',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Votre assistant juridique intelligent pour le droit guinéen',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 40),

              // Fonctionnalités
              _buildFeatureCard(
                Icons.chat_bubble_outline,
                'Chat Intelligent',
                'Posez vos questions en langage naturel',
                isDarkMode,
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                Icons.library_books,
                'Base Juridique',
                'Accès aux lois et codes guinéens',
                isDarkMode,
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                Icons.security,
                'Confidentiel',
                'Vos conversations restent privées',
                isDarkMode,
              ),
              const SizedBox(height: 40),

              // Questions suggérées
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Questions fréquentes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _buildSuggestedQuestion(
                'Quels sont les droits d\'un locataire ?',
                Icons.home_outlined,
                isDarkMode,
              ),
              const SizedBox(height: 12),
              _buildSuggestedQuestion(
                'Comment fonctionne le Code du travail ?',
                Icons.work_outline,
                isDarkMode,
              ),
              const SizedBox(height: 12),
              _buildSuggestedQuestion(
                'Quelles sont les lois sur l\'environnement ?',
                Icons.nature_outlined,
                isDarkMode,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatArea(bool isDarkMode) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return _buildMessageBubble(_messages[index], isDarkMode);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF4F5CD1),
              child: const Icon(Icons.balance, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    message.isUser
                        ? const Color(0xFF4F5CD1)
                        : (isDarkMode
                            ? Colors.white.withOpacity(0.1)
                            : Colors.white.withOpacity(0.9)),
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomRight:
                      message.isUser
                          ? const Radius.circular(4)
                          : const Radius.circular(16),
                  bottomLeft:
                      !message.isUser
                          ? const Radius.circular(4)
                          : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color:
                          message.isUser
                              ? Colors.white
                              : (isDarkMode ? Colors.white : Colors.black87),
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color:
                          message.isUser
                              ? Colors.white70
                              : (isDarkMode ? Colors.white54 : Colors.black54),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF4F5CD1).withOpacity(0.2),
              child: Icon(
                Icons.person,
                color: const Color(0xFF4F5CD1),
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF4F5CD1),
            child: const Icon(Icons.balance, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  isDarkMode
                      ? Colors.white.withOpacity(0.1)
                      : Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'GuinéeLex tape...',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDarkMode ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    IconData icon,
    String title,
    String subtitle,
    bool isDarkMode,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4F5CD1).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF4F5CD1), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedQuestion(
    String question,
    IconData icon,
    bool isDarkMode,
  ) {
    return Container(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _handleSuggestedQuestion(question),
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
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF4F5CD1), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                question,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDarkMode ? Colors.white54 : Colors.black54,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(bool isDarkMode, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.9),
        border: Border(
          top: BorderSide(
            color:
                isDarkMode
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.1),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color:
                      isDarkMode ? Colors.white.withOpacity(0.1) : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color:
                        isDarkMode
                            ? Colors.white.withOpacity(0.2)
                            : Colors.black.withOpacity(0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _messageController,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Posez votre question juridique...',
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.white54 : Colors.black54,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (text) => setState(() {}),
                  onSubmitted: (text) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color:
                    _messageController.text.trim().isNotEmpty
                        ? primaryColor
                        : (isDarkMode
                            ? Colors.white.withOpacity(0.2)
                            : Colors.black.withOpacity(0.1)),
                shape: BoxShape.circle,
                boxShadow:
                    _messageController.text.trim().isNotEmpty
                        ? [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : null,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.send_rounded,
                  color:
                      _messageController.text.trim().isNotEmpty
                          ? Colors.white
                          : (isDarkMode ? Colors.grey : Colors.grey.shade600),
                ),
                onPressed:
                    _messageController.text.trim().isNotEmpty
                        ? _sendMessage
                        : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _showComingSoon(String feature) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Bientôt disponible'),
            content: Text('$feature sera disponible prochainement.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _fadeAnimationController.dispose();
    _scaleAnimationController.dispose();
    super.dispose();
  }
}
