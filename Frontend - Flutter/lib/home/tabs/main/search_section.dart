import 'package:flutter/cupertino.dart';

import '../../widgets/common_widgets.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({
    required this.itemsController,
    required this.rulesController,
    required this.cuisineController,
    required this.timeController,
    required this.calorieController,
    required this.loading,
    required this.error,
    required this.onSearch,
    required this.surface,
    required this.card,
    required this.border,
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    super.key,
  });

  final TextEditingController itemsController;
  final TextEditingController rulesController;
  final TextEditingController cuisineController;
  final TextEditingController timeController;
  final TextEditingController calorieController;
  final bool loading;
  final String? error;
  final VoidCallback onSearch;
  final Color surface;
  final Color card;
  final Color border;
  final Color primary;
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Search Filters',
      titleColor: textPrimary,
      background: card,
      border: border,
      child: Column(
        children: [
          InputField(
            controller: itemsController,
            label: 'Ingredients on hand',
            placeholder: 'e.g. chicken, rice, garlic',
            surface: surface,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: 8),
          Text(
            'Pantry ingredients are automatically included in your search.',
            style: TextStyle(color: textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 14),
          InputField(
            controller: rulesController,
            label: 'Restrictions (comma-separated)',
            placeholder: 'e.g. gluten, peanuts',
            surface: surface,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: 14),
          InputField(
            controller: cuisineController,
            label: 'Cuisine preference',
            placeholder: 'e.g. italian, mexican',
            surface: surface,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: 14),
          InputField(
            controller: timeController,
            label: 'Time cap (minutes)',
            placeholder: 'e.g. 30',
            surface: surface,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: 14),
          InputField(
            controller: calorieController,
            label: 'Calorie goal',
            placeholder: 'e.g. 600',
            surface: surface,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: 16),
          GymButton(
            label: loading ? 'Searching...' : 'Search recipes',
            onPressed: loading ? null : onSearch,
            primary: primary,
          ),
          if (error != null) ...[
            const SizedBox(height: 10),
            Text(error!, style: TextStyle(color: textSecondary)),
          ],
        ],
      ),
    );
  }
}
