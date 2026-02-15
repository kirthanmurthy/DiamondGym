import 'package:flutter/material.dart';

import '../widgets/common_widgets.dart';

class PantryTab extends StatelessWidget {
  const PantryTab({
    required this.pantryItemController,
    required this.quantityController,
    required this.pantryItems,
    required this.onAddPantry,
    super.key,
  });

  final TextEditingController pantryItemController;
  final TextEditingController quantityController;
  final List<String> pantryItems;
  final VoidCallback onAddPantry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(title: 'Pantry / Fridge inventory'),
          const SizedBox(height: 8),
          InputField(
            controller: pantryItemController,
            label: 'Ingredient or pantry item',
          ),
          const SizedBox(height: 8),
          InputField(
            controller: quantityController,
            label: 'Quantity (optional)',
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onAddPantry,
            child: const Text('Save ingredient'),
          ),
          const SizedBox(height: 16),
          if (pantryItems.isEmpty)
            const Text('Your pantry list is empty. Add ingredients above.'),
          ...pantryItems.map(
            (item) => Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: Icon(Icons.kitchen, color: colors.primary),
                title: Text(item),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
