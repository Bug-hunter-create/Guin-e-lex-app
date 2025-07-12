import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FavoriteScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const FavoriteScreen({super.key, required this.onToggleTheme});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with TickerProviderStateMixin {
  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _heartController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _heartAnimation;

  // State variables
  List<FavoriteArticle> favoriteArticles = [];
  String selectedCategory = 'Tous';
  String searchQuery = '';
  bool isSearching = false;
  int totalFavorites = 0;

  // Mock data for demonstration
  final List<FavoriteArticle> _mockArticles = [
    FavoriteArticle(
      id: '1',
      title: 'Code Civil Guinéen - Article 25',
      category: 'Civil',
      content: 'Définition des droits de la personnalité et protection...',
      dateAdded: DateTime.now().subtract(const Duration(days: 2)),
      isRecent: true,
    ),
    FavoriteArticle(
      id: '2',
      title: 'Code Pénal - Article 142',
      category: 'Pénal',
      content: 'Sanctions relatives aux infractions contre les biens...',
      dateAdded: DateTime.now().subtract(const Duration(days: 5)),
      isRecent: false,
    ),
    FavoriteArticle(
      id: '3',
      title: 'Code du Travail - Article 8',
      category: 'Travail',
      content: 'Droits et obligations des travailleurs salariés...',
      dateAdded: DateTime.now().subtract(const Duration(days: 1)),
      isRecent: true,
    ),
    FavoriteArticle(
      id: '4',
      title: 'Constitution - Article 15',
      category: 'Constitutional',
      content: 'Droits fondamentaux et libertés publiques...',
      dateAdded: DateTime.now().subtract(const Duration(days: 10)),
      isRecent: false,
    ),
  ];

  final List<String> categories = [
    'Tous',
    'Civil',
    'Pénal',
    'Travail',
    'Commercial',
    'Constitutional',
    'Administratif',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadFavorites();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _heartController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _heartAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _slideController.forward();
    _heartController.repeat(reverse: true);
  }

  void _loadFavorites() {
    // Simulate loading favorites
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          favoriteArticles = _mockArticles;
          totalFavorites = favoriteArticles.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _heartController.dispose();
    super.dispose();
  }

  void _showComingSoon(String feature) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Text('Fonctionnalité à venir'),
              ],
            ),
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

  void _toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        searchQuery = '';
      }
    });
  }

  void _removeFromFavorites(String articleId) {
    HapticFeedback.lightImpact();
    setState(() {
      favoriteArticles.removeWhere((article) => article.id == articleId);
      totalFavorites = favoriteArticles.length;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Article retiré des favoris'),
        action: SnackBarAction(
          label: 'Annuler',
          onPressed: () {
            // Implement undo functionality
            _showComingSoon('Fonction Annuler');
          },
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _shareArticle(FavoriteArticle article) {
    HapticFeedback.selectionClick();
    _showComingSoon('Partage d\'article');
  }

  void _exportFavorites() {
    HapticFeedback.mediumImpact();
    _showComingSoon('Export des favoris');
  }

  List<FavoriteArticle> get filteredArticles {
    List<FavoriteArticle> filtered = favoriteArticles;

    if (selectedCategory != 'Tous') {
      filtered =
          filtered
              .where((article) => article.category == selectedCategory)
              .toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (article) =>
                    article.title.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ) ||
                    article.content.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ),
              )
              .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(position: _slideAnimation, child: _buildBody()),
      ),
      floatingActionButton:
          totalFavorites > 0 ? _buildFloatingActionButton() : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
                  child: const Icon(
                    Icons.balance,
                    color: Colors.white,
                    size: 20,
                  ),
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
                    'Droit Guinéen',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              if (totalFavorites > 0) ...[
                IconButton(
                  icon: Icon(
                    isSearching ? Icons.close : Icons.search,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: _toggleSearch,
                ),
              ],
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
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildHeader(),
          if (isSearching) _buildSearchBar(),
          if (totalFavorites > 0) _buildCategoryFilter(),
          const SizedBox(height: 16),
          Expanded(
            child:
                totalFavorites == 0
                    ? _buildEmptyState()
                    : _buildFavoritesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            AnimatedBuilder(
              animation: _heartAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale:
                      totalFavorites == 0
                          ? 1.0 + (_heartAnimation.value * 0.1)
                          : 1.0,
                  child: Icon(
                    totalFavorites > 0
                        ? Icons.favorite
                        : Icons.favorite_border_sharp,
                    color:
                        totalFavorites > 0
                            ? Colors.red
                            : Colors.red.withOpacity(0.7),
                    size: 30,
                  ),
                );
              },
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Vous avez $totalFavorites article${totalFavorites > 1 ? 's' : ''} favori${totalFavorites > 1 ? 's' : ''}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
            if (totalFavorites > 0)
              TextButton.icon(
                onPressed: _exportFavorites,
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Exporter'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF4F5CD1),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Rechercher dans vos favoris...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;

          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(category),
              onSelected: (selected) {
                setState(() {
                  selectedCategory = category;
                });
              },
              selectedColor: const Color(0xFF4F5CD1).withOpacity(0.2),
              checkmarkColor: const Color(0xFF4F5CD1),
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF4F5CD1) : null,
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _heartAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_heartAnimation.value * 0.1),
                child: const Icon(
                  Icons.favorite_outline_sharp,
                  size: 120,
                  color: Colors.grey,
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Aucun article favori pour le moment.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Appuyez sur',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'lors de la lecture',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to main screen or article list
              _showComingSoon('Navigation vers les articles');
            },
            icon: const Icon(Icons.explore),
            label: const Text('Explorer les articles'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F5CD1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    final articles = filteredArticles;

    if (articles.isEmpty && searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Aucun résultat pour "$searchQuery"',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  searchQuery = '';
                });
              },
              child: const Text('Effacer la recherche'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return _buildFavoriteCard(article, index);
      },
    );
  }

  Widget _buildFavoriteCard(FavoriteArticle article, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            HapticFeedback.selectionClick();
            _showComingSoon('Ouverture de l\'article');
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(
                                    article.category,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  article.category,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _getCategoryColor(article.category),
                                  ),
                                ),
                              ),
                              if (article.isRecent) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'NOUVEAU',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            article.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            article.content,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'share':
                            _shareArticle(article);
                            break;
                          case 'remove':
                            _removeFromFavorites(article.id);
                            break;
                        }
                      },
                      itemBuilder:
                          (context) => [
                            const PopupMenuItem(
                              value: 'share',
                              child: Row(
                                children: [
                                  Icon(Icons.share, size: 18),
                                  SizedBox(width: 8),
                                  Text('Partager'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'remove',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Retirer',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                      child: const Icon(Icons.more_vert, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(article.dateAdded),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share, size: 18),
                          onPressed: () => _shareArticle(article),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.favorite, size: 18),
                          onPressed: () => _removeFromFavorites(article.id),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        _showComingSoon('Synchronisation des favoris');
      },
      backgroundColor: const Color(0xFF4F5CD1),
      foregroundColor: Colors.white,
      icon: const Icon(Icons.sync),
      label: const Text('Synchroniser'),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Civil':
        return Colors.blue;
      case 'Pénal':
        return Colors.red;
      case 'Travail':
        return Colors.green;
      case 'Commercial':
        return Colors.orange;
      case 'Constitutional':
        return Colors.purple;
      case 'Administratif':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return "Aujourd'hui";
    } else if (difference == 1) {
      return "Hier";
    } else if (difference < 7) {
      return "Il y a $difference jours";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }
}

class FavoriteArticle {
  final String id;
  final String title;
  final String category;
  final String content;
  final DateTime dateAdded;
  final bool isRecent;

  FavoriteArticle({
    required this.id,
    required this.title,
    required this.category,
    required this.content,
    required this.dateAdded,
    required this.isRecent,
  });
}
