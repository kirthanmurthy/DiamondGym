import 'package:flutter/cupertino.dart';

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
    required this.surface,
    required this.card,
    required this.border,
    required this.primary,
    required this.secondary,
    required this.textPrimary,
    required this.textSecondary,
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
  final Color surface;
  final Color card;
  final Color border;
  final Color primary;
  final Color secondary;
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Favorites & history',
            style: TextStyle(
              color: textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Keep track of meals you loved and cooked.',
            style: TextStyle(color: textSecondary),
          ),
          const SizedBox(height: 20),
          SectionCard(
            title: 'Favorites',
            titleColor: textPrimary,
            background: card,
            border: border,
            child: Column(
              children: [
                InputField(
                  controller: favoriteNameController,
                  label: 'Favorite recipe',
                  surface: surface,
                  border: border,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                const SizedBox(height: 14),
                InputField(
                  controller: favoriteNotesController,
                  label: 'Why you liked it',
                  surface: surface,
                  border: border,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                const SizedBox(height: 16),
                GymButton(
                  label: 'Save favorite',
                  onPressed: onAddFavorite,
                  primary: primary,
                ),
                const SizedBox(height: 12),
                if (favorites.isEmpty)
                  Text(
                    'No favorites yet. Log one using the form above.',
                    style: TextStyle(color: textSecondary),
                  ),
                ...favorites.map(
                  (entry) => Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: border),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.heart_fill,
                          color: secondary,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.name,
                                style: TextStyle(color: textPrimary),
                              ),
                              if (entry.notes.isNotEmpty)
                                Text(
                                  entry.notes,
                                  style: TextStyle(
                                    color: textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SectionCard(
            title: 'History',
            titleColor: textPrimary,
            background: card,
            border: border,
            child: Column(
              children: [
                InputField(
                  controller: historyNameController,
                  label: 'Recently made recipe',
                  surface: surface,
                  border: border,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                const SizedBox(height: 14),
                InputField(
                  controller: historyDetailsController,
                  label: 'Time / macros / notes',
                  surface: surface,
                  border: border,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                const SizedBox(height: 16),
                GymButton(
                  label: 'Log to history',
                  onPressed: onAddHistory,
                  primary: primary,
                ),
                const SizedBox(height: 12),
                if (historyEntries.isEmpty)
                  Text(
                    'Your history will appear here once you log a meal.',
                    style: TextStyle(color: textSecondary),
                  ),
                ...historyEntries.map(
                  (entry) => Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: border),
                    ),
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.clock, color: primary, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.name,
                                style: TextStyle(color: textPrimary),
                              ),
                              if (entry.details.isNotEmpty)
                                Text(
                                  entry.details,
                                  style: TextStyle(
                                    color: textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
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
}
