import 'package:flutter/material.dart';
import 'package:guin_lex_app/models/legalDocument_model.dart';
import 'package:guin_lex_app/models/searchFilter_model.dart';

class SearchScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const SearchScreen({super.key, required this.onToggleTheme});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _query = '';
  bool _isLoading = false;
  bool _showAdvancedFilters = false;
  SearchFilter _filter = SearchFilter();
  List<LegalDocument> _searchResults = [];
  List<String> _recentSearches = [];
  final List<String> _popularTags = [
    'Constitution',
    'Code Civil',
    'Droit Commercial',
    'Droit Pénal',
    'Droit Administratif',
  ];

  late AnimationController _animationController;
  late AnimationController _filterAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  // Données simulées pour la démonstration
  final List<LegalDocument> _allDocuments = [
    LegalDocument(
      id: '1',
      title: 'Constitution de la République de Guinée',
      type: 'Constitution',
      description:
          'Loi fondamentale de la République de Guinée adoptée en 2020',
      date: DateTime(2020, 3, 22),
      status: 'En vigueur',
      tags: ['Constitution', 'République', 'Droits fondamentaux'],
      content: 'Préambule de la Constitution...',
      views: 1250,
    ),
    LegalDocument(
      id: '2',
      title: 'Code Civil Guinéen - Livre Premier',
      type: 'Code',
      description: 'Dispositions générales du Code Civil',
      date: DateTime(2019, 6, 15),
      status: 'En vigueur',
      tags: ['Code Civil', 'Droit civil', 'Personnes'],
      content: 'Article 1er : Les personnes...',
      views: 890,
    ),
    LegalDocument(
      id: '3',
      title: 'Loi sur les Investissements',
      type: 'Loi',
      description: 'Cadre juridique pour les investissements privés',
      date: DateTime(2021, 11, 8),
      status: 'En vigueur',
      tags: ['Investissement', 'Économie', 'Secteur privé'],
      content: 'Chapitre I : Dispositions générales...',
      views: 560,
    ),
    LegalDocument(
      id: '4',
      title: 'Décret sur la Fonction Publique',
      type: 'Décret',
      description: 'Statut général des fonctionnaires',
      date: DateTime(2022, 2, 14),
      status: 'En vigueur',
      tags: ['Fonction publique', 'Administration', 'Fonctionnaires'],
      content: 'Article 1er : Le présent décret...',
      views: 320,
    ),
    LegalDocument(
      id: '5',
      title: 'Arrêté sur la Sécurité Routière',
      type: 'Arrêté',
      description: 'Mesures de sécurité sur les voies publiques',
      date: DateTime(2023, 5, 3),
      status: 'En vigueur',
      tags: ['Sécurité routière', 'Transport', 'Circulation'],
      content: 'Considérant la nécessité...',
      views: 180,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _filterAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _loadRecentSearches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    _filterAnimationController.dispose();
    super.dispose();
  }

  void _loadRecentSearches() {
    setState(() {
      _recentSearches = ['Constitution', 'Code Civil', 'Investissement'];
    });
  }

  Future<void> _onSearch() async {
    if (_query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    // Ajouter à l'historique de recherche
    if (!_recentSearches.contains(_query) && _query.trim().isNotEmpty) {
      setState(() {
        _recentSearches.insert(0, _query);
        if (_recentSearches.length > 5) {
          _recentSearches.removeLast();
        }
      });
    }

    // Simuler une recherche avec délai
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _searchResults = _performSearch(_query, _filter);
      _isLoading = false;
    });

    _animationController.forward();
    print("Recherche lancée pour : $_query, filtres appliqués");
  }

  List<LegalDocument> _performSearch(String query, SearchFilter filter) {
    var results =
        _allDocuments.where((doc) {
          bool matchesQuery =
              doc.title.toLowerCase().contains(query.toLowerCase()) ||
              doc.description.toLowerCase().contains(query.toLowerCase()) ||
              doc.content.toLowerCase().contains(query.toLowerCase()) ||
              doc.tags.any(
                (tag) => tag.toLowerCase().contains(query.toLowerCase()),
              );

          bool matchesType = filter.type == 'Tous' || doc.type == filter.type;
          bool matchesStatus =
              filter.status == 'Tous' || doc.status == filter.status;

          bool matchesDateRange = true;
          if (filter.dateFrom != null) {
            matchesDateRange =
                matchesDateRange && doc.date.isAfter(filter.dateFrom!);
          }
          if (filter.dateTo != null) {
            matchesDateRange =
                matchesDateRange &&
                doc.date.isBefore(filter.dateTo!.add(const Duration(days: 1)));
          }

          return matchesQuery &&
              matchesType &&
              matchesStatus &&
              matchesDateRange;
        }).toList();

    // Trier les résultats
    switch (filter.sort) {
      case 'Plus récent':
        results.sort((a, b) => b.date.compareTo(a.date));
        break;
      case 'Alphabétique':
        results.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Plus consulté':
        results.sort((a, b) => b.views.compareTo(a.views));
        break;
    }

    return results;
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
                Icon(Icons.info_outline, color: Color(0xFF4F5CD1)),
                SizedBox(width: 8),
                Text('Fonctionnalité à venir'),
              ],
            ),
            content: Text(
              '$feature sera disponible bientôt.\nNous travaillons dur pour vous offrir la meilleure expérience.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Compris',
                  style: TextStyle(color: Color(0xFF4F5CD1)),
                ),
              ),
            ],
          ),
    );
  }

  void _toggleAdvancedFilters() {
    setState(() {
      _showAdvancedFilters = !_showAdvancedFilters;
    });
    if (_showAdvancedFilters) {
      _filterAnimationController.forward();
    } else {
      _filterAnimationController.reverse();
    }
  }

  void _clearSearch() {
    setState(() {
      _query = '';
      _searchResults.clear();
      _searchController.clear();
    });
    _animationController.reset();
  }

  void _onDocumentTap(LegalDocument doc) {
    // Navigation vers la page de détail du document
    _showComingSoon('Consultation du document "${doc.title}"');
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
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
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFE8142A),
                          const Color(0xFFD9FF02),
                          const Color(0xFF04FF04),
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
                      style: theme.textTheme.titleMedium?.copyWith(
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
                IconButton(
                  icon: Stack(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: theme.iconTheme.color,
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
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    color: const Color(0xFF4F5CD1),
                  ),
                  onPressed: widget.onToggleTheme,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // En-tête de recherche
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: theme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Rechercher un texte juridique',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 16),

                // Barre de recherche
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          onChanged: (v) => setState(() => _query = v),
                          onSubmitted: (_) => _onSearch(),
                          decoration: InputDecoration(
                            hintText:
                                'Rechercher par titre, contenu ou tags...',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFF4F5CD1),
                            ),
                            suffixIcon:
                                _query.isNotEmpty
                                    ? IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.grey[400],
                                      ),
                                      onPressed: _clearSearch,
                                    )
                                    : null,
                            filled: true,
                            fillColor: theme.cardColor,
                            enabledBorder: border,
                            focusedBorder: border.copyWith(
                              borderSide: BorderSide(
                                color: Color(0xFF4F5CD1),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [Color(0xFF4F5CD1), Color(0xFF6366F1)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF4F5CD1).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _onSearch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child:
                            _isLoading
                                ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
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
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Filtres de base et bouton filtres avancés
                Row(
                  children: [
                    Expanded(
                      child: _buildStyledDropdown<String>(
                        value: _filter.type,
                        items: [
                          'Tous',
                          'Constitution',
                          'Loi',
                          'Décret',
                          'Arrêté',
                          'Code',
                        ],
                        onChanged:
                            (v) => setState(
                              () => _filter = _filter.copyWith(type: v),
                            ),
                        border: border,
                        icon: Icons.category,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStyledDropdown<String>(
                        value: _filter.sort,
                        items: ['Plus récent', 'Alphabétique', 'Plus consulté'],
                        onChanged:
                            (v) => setState(
                              () => _filter = _filter.copyWith(sort: v),
                            ),
                        border: border,
                        icon: Icons.sort,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                        color:
                            _showAdvancedFilters
                                ? Color(0xFF4F5CD1).withOpacity(0.1)
                                : null,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.tune,
                          color:
                              _showAdvancedFilters
                                  ? Color(0xFF4F5CD1)
                                  : Colors.grey[600],
                        ),
                        onPressed: _toggleAdvancedFilters,
                        tooltip: 'Filtres avancés',
                      ),
                    ),
                  ],
                ),

                // Filtres avancés animés
                AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, child) {
                    return ClipRect(
                      child: Transform.translate(
                        offset: Offset(0, _slideAnimation.value * 50),
                        child: Opacity(
                          opacity: _showAdvancedFilters ? 1.0 : 0.0,
                          child:
                              _showAdvancedFilters
                                  ? _buildAdvancedFilters(border)
                                  : Container(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Contenu principal
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }

  Widget _buildAdvancedFilters(OutlineInputBorder border) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF4F5CD1).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filtres avancés',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4F5CD1),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStyledDropdown<String>(
                  value: _filter.status,
                  items: ['Tous', 'En vigueur', 'Abrogé', 'En projet'],
                  onChanged:
                      (v) =>
                          setState(() => _filter = _filter.copyWith(status: v)),
                  border: border,
                  icon: Icons.gavel,
                  label: 'Statut',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextButton.icon(
                  onPressed:
                      () => _showComingSoon('Sélection de plage de dates'),
                  icon: Icon(Icons.date_range, size: 18),
                  label: Text('Période'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (_query.isEmpty) {
      return _buildWelcomeContent();
    } else if (_isLoading) {
      return _buildLoadingContent();
    } else if (_searchResults.isEmpty) {
      return _buildNoResultsContent();
    } else {
      return _buildSearchResults();
    }
  }

  Widget _buildWelcomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recherches récentes
          if (_recentSearches.isNotEmpty) ...[
            Text(
              'Recherches récentes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _recentSearches
                      .map(
                        (search) => ActionChip(
                          label: Text(search),
                          onPressed: () {
                            setState(() {
                              _query = search;
                              _searchController.text = search;
                            });
                            _onSearch();
                          },
                          backgroundColor: Color(0xFF4F5CD1).withOpacity(0.1),
                          side: BorderSide(
                            color: Color(0xFF4F5CD1).withOpacity(0.3),
                          ),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Tags populaires
          Text(
            'Catégories populaires',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _popularTags
                    .map(
                      (tag) => ActionChip(
                        label: Text(tag),
                        avatar: Icon(
                          _getIconForTag(tag),
                          size: 16,
                          color: Color(0xFF4F5CD1),
                        ),
                        onPressed: () {
                          setState(() {
                            _query = tag;
                            _searchController.text = tag;
                          });
                          _onSearch();
                        },
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.1),
                        side: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                    )
                    .toList(),
          ),

          const SizedBox(height: 24),

          // Conseils de recherche
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF4F5CD1).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFF4F5CD1).withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Color(0xFF4F5CD1)),
                    SizedBox(width: 8),
                    Text(
                      'Conseils de recherche',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4F5CD1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '• Utilisez des mots-clés spécifiques\n'
                  '• Recherchez par numéro de loi ou décret\n'
                  '• Utilisez les filtres pour affiner vos résultats\n'
                  '• Explorez les catégories populaires ci-dessus',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4F5CD1)),
          ),
          const SizedBox(height: 16),
          Text(
            'Recherche en cours...',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Aucun résultat trouvé',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Essayez avec d\'autres termes ou ajustez vos filtres',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _filter = SearchFilter();
                _showAdvancedFilters = false;
              });
              _filterAnimationController.reset();
            },
            icon: Icon(Icons.refresh),
            label: Text('Réinitialiser les filtres'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4F5CD1),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          // En-tête des résultats
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_searchResults.length} résultat${_searchResults.length > 1 ? 's' : ''} trouvé${_searchResults.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showComingSoon('Export des résultats'),
                  icon: Icon(Icons.download, size: 16),
                  label: Text('Exporter'),
                ),
              ],
            ),
          ),

          // Liste des résultats
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final doc = _searchResults[index];
                return _buildDocumentCard(doc, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(LegalDocument doc, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => _onDocumentTap(doc),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête du document
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getColorForType(doc.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getIconForType(doc.type),
                        color: _getColorForType(doc.type),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.color,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getColorForType(doc.type),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  doc.type,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      doc.status == 'En vigueur'
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  doc.status,
                                  style: TextStyle(
                                    color:
                                        doc.status == 'En vigueur'
                                            ? Colors.green
                                            : Colors.orange,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        doc.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: doc.isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () => _showComingSoon('Favoris'),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Description
                Text(
                  doc.description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Tags
                if (doc.tags.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children:
                        doc.tags
                            .take(3)
                            .map(
                              (tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),

                const SizedBox(height: 12),

                // Footer avec date et stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(doc.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.visibility,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${doc.views} vues',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Colors.grey[400],
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

  Widget _buildStyledDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required OutlineInputBorder border,
    IconData? icon,
    String? label,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InputDecorator(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: BorderSide(color: Color(0xFF4F5CD1), width: 2),
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          prefixIcon:
              icon != null
                  ? Icon(icon, color: Color(0xFF4F5CD1), size: 18)
                  : null,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            onChanged: onChanged,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 14,
            ),
            items:
                items
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e.toString(),
                          style: TextStyle(
                            fontWeight:
                                e == value
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'constitution':
        return Icons.account_balance;
      case 'loi':
        return Icons.gavel;
      case 'décret':
        return Icons.description;
      case 'arrêté':
        return Icons.assignment;
      case 'code':
        return Icons.menu_book;
      default:
        return Icons.article;
    }
  }

  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'constitution':
        return Color(0xFF1976D2); // Bleu
      case 'loi':
        return Color(0xFF388E3C); // Vert
      case 'décret':
        return Color(0xFFF57C00); // Orange
      case 'arrêté':
        return Color(0xFF7B1FA2); // Violet
      case 'code':
        return Color(0xFFD32F2F); // Rouge
      default:
        return Color(0xFF616161); // Gris
    }
  }

  IconData _getIconForTag(String tag) {
    switch (tag.toLowerCase()) {
      case 'constitution':
        return Icons.account_balance;
      case 'code civil':
        return Icons.menu_book;
      case 'droit commercial':
        return Icons.business;
      case 'droit pénal':
        return Icons.security;
      case 'droit administratif':
        return Icons.admin_panel_settings;
      default:
        return Icons.local_offer;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Jun',
      'Jul',
      'Aoû',
      'Sep',
      'Oct',
      'Nov',
      'Déc',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
