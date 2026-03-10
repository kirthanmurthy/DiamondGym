import 'package:flutter/cupertino.dart';

import '../widgets/common_widgets.dart';

class PantryTab extends StatelessWidget {
  const PantryTab({
    required this.pantryItemController,
    required this.quantityController,
    required this.pantryItems,
    required this.onAddPantry,
    required this.surface,
    required this.card,
    required this.border,
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    super.key,
  });

  final TextEditingController pantryItemController;
  final TextEditingController quantityController;
  final List<String> pantryItems;
  final VoidCallback onAddPantry;
  final Color surface;
  final Color card;
  final Color border;
  final Color primary;
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
            'Pantry inventory',
            style: TextStyle(
              color: textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Track what you already have on hand.',
            style: TextStyle(color: textSecondary),
          ),
          const SizedBox(height: 20),
          SectionCard(
            title: 'Add ingredient',
            titleColor: textPrimary,
            background: card,
            border: border,
            child: Column(
              children: [
                InputField(
                  controller: pantryItemController,
                  label: 'Ingredient or pantry item',
                  surface: surface,
                  border: border,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                const SizedBox(height: 14),
                InputField(
                  controller: quantityController,
                  label: 'Quantity (optional)',
                  surface: surface,
                  border: border,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                const SizedBox(height: 16),
                GymButton(
                  label: 'Save ingredient',
                  onPressed: onAddPantry,
                  primary: primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SectionCard(
            title: 'Items on hand',
            titleColor: textPrimary,
            background: card,
            border: border,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pantryItems.isEmpty)
                  Text(
                    'Your pantry list is empty. Add ingredients above.',
                    style: TextStyle(color: textSecondary),
                  ),
                ...pantryItems.map(
                  (item) => Container(
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
                          CupertinoIcons.cube_box_fill,
                          color: primary,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item,
                            style: TextStyle(color: textPrimary),
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
