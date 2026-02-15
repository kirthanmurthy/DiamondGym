import 'package:flutter/material.dart';

import '../models/app_models.dart';
import '../widgets/common_widgets.dart';

class FavoritesHistoryTab extends StatelessWidget {
  const FavoritesHistoryTab({
    required this.favoriteNameController,
    required this.favoriteNotesController,
    required this.onAddFavorite,
    required this.favorites,
    required this.historyNameController,
    required this.historyDetailsController,
    required this.onAddHistory,
    required this.historyEntries,
    super.key,
  });

  final TextEditingController favoriteNameController;
  final TextEditingController favoriteNotesController;
  final VoidCallback onAddFavorite;
  final List<FavoriteEntry> favorites;
  final TextEditingController historyNameController;
  final TextEditingController historyDetailsController;
  final VoidCallback onAddHistory;
  final List<HistoryEntry> historyEntries;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(title: 'Favorites'),
          const SizedBox(height: 8),
          InputField(
            controller: favoriteNameController,
            label: 'Favorite recipe',
          ),
          const SizedBox(height: 8),
          InputField(
            controller: favoriteNotesController,
            label: 'Why you liked it',
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onAddFavorite,
            child: const Text('Save favorite'),
          ),
          const SizedBox(height: 16),
          if (favorites.isEmpty)
            const Text('No favorites yet. Log one using the form above.'),
          ...favorites.map(
            (entry) => Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: Icon(Icons.favorite, color: colors.secondary),
                title: Text(entry.name),
                subtitle: entry.notes.isNotEmpty ? Text(entry.notes) : null,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const SectionLabel(title: 'History'),
          const SizedBox(height: 8),
          InputField(
            controller: historyNameController,
            label: 'Recently made recipe',
          ),
          const SizedBox(height: 8),
          InputField(
            controller: historyDetailsController,
            label: 'Time / macros / notes',
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onAddHistory,
            child: const Text('Log to history'),
          ),
          const SizedBox(height: 16),
          if (historyEntries.isEmpty)
            const Text('Your history will appear here once you log a meal.'),
          ...historyEntries.map(
            (entry) => Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: Icon(Icons.history, color: colors.primary),
                title: Text(entry.name),
                subtitle: entry.details.isNotEmpty ? Text(entry.details) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
