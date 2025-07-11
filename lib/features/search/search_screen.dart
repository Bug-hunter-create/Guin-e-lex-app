import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const SearchScreen({super.key, required this.onToggleTheme});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';
  String _selectedType = 'Type';
  String _selectedSort = 'Plus récent';

  void _onSearch() {
    print(
      "Recherche lancée pour : $_query, type=$_selectedType, ordre=$_selectedSort",
    );
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey.shade400),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
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
              icon: const Icon(Icons.sunny),
              onPressed: widget.onToggleTheme,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Rechercher un texte juridique',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v),
                    onSubmitted: (_) => _onSearch(),
                    decoration: InputDecoration(
                      hintText: 'Rechercher...',
                      prefixIcon: const Icon(Icons.search),
                      enabledBorder: border,
                      focusedBorder: border.copyWith(
                        borderSide: BorderSide(color: Colors.indigo),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _onSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 45, 38, 250),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                  ),
                  child: const Text(
                    'Rechercher',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildStyledDropdown<String>(
                    value: _selectedType,
                    items: ['Type', 'Loi', 'Décret', 'Arrêté'],
                    onChanged: (v) => setState(() => _selectedType = v!),
                    border: border,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStyledDropdown<String>(
                    value: _selectedSort,
                    items: ['Plus récent', 'Alphabétique'],
                    onChanged: (v) => setState(() => _selectedSort = v!),
                    border: border,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child:
                  _query.isEmpty
                      ? const Center(
                        child: Text(
                          'Entrez un terme pour lancer la recherche.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        itemCount: 3,
                        itemBuilder:
                            (c, i) => ListTile(
                              leading: const Icon(Icons.article),
                              title: Text('$_query - Résultat ${i + 1}'),
                              subtitle: const Text('Description du résultat'),
                              onTap: () {},
                            ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required OutlineInputBorder border,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: const Color.fromARGB(255, 63, 94, 181)),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          onChanged: onChanged,
          items:
              items
                  .map(
                    (e) =>
                        DropdownMenuItem(value: e, child: Text(e.toString())),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
