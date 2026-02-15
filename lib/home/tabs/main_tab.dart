import 'package:flutter/material.dart';

import '../models/app_models.dart';
import '../widgets/common_widgets.dart';

class MainTab extends StatelessWidget {
  const MainTab({
    required this.feelingController,
    required this.budgetController,
    required this.timeController,
    required this.macrosController,
    required this.cuisinesController,
    required this.onAddRanking,
    required this.rankingInputs,
    required this.recipeNameController,
    required this.recipeTimeController,
    required this.recipeBudgetController,
    required this.recipeMacrosController,
    required this.onAddRecipe,
    required this.recipes,
    super.key,
  });

  final TextEditingController feelingController;
  final TextEditingController budgetController;
  final TextEditingController timeController;
  final TextEditingController macrosController;
  final TextEditingController cuisinesController;
  final VoidCallback onAddRanking;
  final List<String> rankingInputs;
  final TextEditingController recipeNameController;
  final TextEditingController recipeTimeController;
  final TextEditingController recipeBudgetController;
  final TextEditingController recipeMacrosController;
  final VoidCallback onAddRecipe;
  final List<RecipeData> recipes;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(title: 'Search & Ranking inputs'),
          const SizedBox(height: 8),
          InputField(
            controller: feelingController,
            label: 'What are you feeling like eating today?',
          ),
          const SizedBox(height: 8),
          InputField(controller: budgetController, label: 'Budget cap'),
          const SizedBox(height: 8),
          InputField(controller: timeController, label: 'Time cap'),
          const SizedBox(height: 8),
          InputField(
            controller: macrosController,
            label: 'Preferred macros (carbs/protein/calories)',
          ),
          const SizedBox(height: 8),
          InputField(
            controller: cuisinesController,
            label: 'Preferred cuisines / ingredients',
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onAddRanking,
            child: const Text('Add ranking input'),
          ),
          const SizedBox(height: 16),
          const SectionLabel(title: 'Current ranking inputs'),
          const SizedBox(height: 8),
          if (rankingInputs.isEmpty)
            const Text(
              'Nothing saved yet. Use the button above to add your session data.',
            ),
          ...rankingInputs.map(
            (item) => Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                visualDensity: VisualDensity.compact,
                title: Text(item),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const SectionLabel(title: 'Top recipes you add'),
          const SizedBox(height: 8),
          InputField(controller: recipeNameController, label: 'Recipe name'),
          const SizedBox(height: 8),
          InputField(
            controller: recipeTimeController,
            label: 'Meal time (e.g. 25 min)',
          ),
          const SizedBox(height: 8),
          InputField(
            controller: recipeBudgetController,
            label: 'Budget (e.g. \$12)',
          ),
          const SizedBox(height: 8),
          InputField(
            controller: recipeMacrosController,
            label: 'Macros / notes',
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onAddRecipe,
            child: const Text('Add recipe card'),
          ),
          const SizedBox(height: 12),
          if (recipes.isEmpty)
            const Text('Recipe cards will show up here once you add them.'),
          ...recipes.map((recipe) => RecipeCard(data: recipe)),
        ],
      ),
    );
  }
}
