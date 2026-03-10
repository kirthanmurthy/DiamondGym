import 'package:flutter/cupertino.dart';

import '../../models/app_models.dart';
import '../../widgets/common_widgets.dart';

class ManualSection extends StatelessWidget {
  const ManualSection({
    required this.nameController,
    required this.timeController,
    required this.budgetController,
    required this.notesController,
    required this.items,
    required this.onAdd,
    required this.surface,
    required this.card,
    required this.border,
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController timeController;
  final TextEditingController budgetController;
  final TextEditingController notesController;
  final List<RecipeData> items;
  final VoidCallback onAdd;
  final Color surface;
  final Color card;
  final Color border;
  final Color primary;
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Manual Recipe Cards',
      titleColor: textPrimary,
      background: card,
      border: border,
      child: Column(
        children: [
          InputField(
            controller: nameController,
            label: 'Recipe name',
            surface: surface,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: 14),
          InputField(
            controller: timeController,
            label: 'Meal time',
            placeholder: 'e.g. 25 min',
            surface: surface,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: 14),
          InputField(
            controller: budgetController,
            label: 'Budget',
            placeholder: 'e.g. 12',
            surface: surface,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: 14),
          InputField(
            controller: notesController,
            label: 'Macros / notes',
            surface: surface,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: 16),
          GymButton(
            label: 'Add recipe card',
            onPressed: onAdd,
            primary: primary,
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            Text(
              'Recipe cards will show up here once you add them.',
              style: TextStyle(color: textSecondary),
            ),
          ...items.map(
            (item) => RecipeCard(
              data: item,
              surface: surface,
              border: border,
              primary: primary,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
