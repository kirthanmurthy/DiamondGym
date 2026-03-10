import 'package:flutter/cupertino.dart';

import '../models/api_query.dart';
import '../models/api_recipe.dart';
import '../models/app_models.dart';
import '../services/api_client.dart';
import 'main/main_top.dart';
import 'main/manual_section.dart';
import 'main/rank_section.dart';
import 'main/results_section.dart';
import 'main/search_section.dart';

class MainTab extends StatefulWidget {
  const MainTab({
    required this.feelingController,
    required this.budgetController,
    required this.timeController,
    required this.macrosController,
    required this.cuisinesController,
    required this.pantryItems,
    required this.onAddRanking,
    required this.rankingInputs,
    required this.recipeNameController,
    required this.recipeTimeController,
    required this.recipeBudgetController,
    required this.recipeMacrosController,
    required this.onAddRecipe,
    required this.recipes,
    required this.surface,
    required this.card,
    required this.border,
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    super.key,
  });

  final TextEditingController feelingController;
  final TextEditingController budgetController;
  final TextEditingController timeController;
  final TextEditingController macrosController;
  final TextEditingController cuisinesController;
  final List<String> pantryItems;
  final VoidCallback onAddRanking;
  final List<String> rankingInputs;
  final TextEditingController recipeNameController;
  final TextEditingController recipeTimeController;
  final TextEditingController recipeBudgetController;
  final TextEditingController recipeMacrosController;
  final VoidCallback onAddRecipe;
  final List<RecipeData> recipes;
  final Color surface;
  final Color card;
  final Color border;
  final Color primary;
  final Color textPrimary;
  final Color textSecondary;

  @override
  State<MainTab> createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  final itemsController = TextEditingController();
  final rulesController = TextEditingController();
  final calorieController = TextEditingController();

  bool isLoading = false;
  bool didSearch = false;
  String? errorText;
  List<ApiRecipe> results = [];

  @override
  void dispose() {
    itemsController.dispose();
    rulesController.dispose();
    calorieController.dispose();
    super.dispose();
  }

  Future<void> runSearch() async {
    final ingredients = _buildIngredients();

    if (ingredients.isEmpty) {
      setState(() {
        errorText =
            'Add pantry items first, or type ingredients before searching.';
        didSearch = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      didSearch = true;
      errorText = null;
    });

    final api = ApiClient(baseUrl: 'http://127.0.0.1:5001');
    final query = ApiQuery(
      ingredients: ingredients,
      restrictions: rulesController.text.trim(),
      cuisine: widget.cuisinesController.text.trim(),
      time: widget.timeController.text.trim(),
      calories: calorieController.text.trim(),
    );

    try {
      final data = await api.search(query);
      setState(() {
        results = data;
      });
    } catch (_) {
      setState(() {
        errorText = 'Unable to load recipes right now.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _buildIngredients() {
    final pantry = widget.pantryItems
        .map((item) => item.split('•').first.trim().toLowerCase())
        .where((item) => item.isNotEmpty);

    final typed = itemsController.text
        .split(',')
        .map((item) => item.trim().toLowerCase())
        .where((item) => item.isNotEmpty);

    return <String>{...pantry, ...typed}.join(',');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MainTop(
            pantryCount: widget.pantryItems.length,
            resultCount: results.length,
            primary: widget.primary,
            secondary: const Color(0xFF7CFFB2),
            textPrimary: widget.textPrimary,
            textSecondary: widget.textSecondary,
          ),
          const SizedBox(height: 20),
          SearchSection(
            itemsController: itemsController,
            rulesController: rulesController,
            cuisineController: widget.cuisinesController,
            timeController: widget.timeController,
            calorieController: calorieController,
            loading: isLoading,
            error: errorText,
            onSearch: runSearch,
            surface: widget.surface,
            card: widget.card,
            border: widget.border,
            primary: widget.primary,
            textPrimary: widget.textPrimary,
            textSecondary: widget.textSecondary,
          ),
          const SizedBox(height: 20),
          ResultsSection(
            loading: isLoading,
            didSearch: didSearch,
            items: results,
            surface: widget.surface,
            card: widget.card,
            border: widget.border,
            primary: widget.primary,
            textPrimary: widget.textPrimary,
            textSecondary: widget.textSecondary,
          ),
          const SizedBox(height: 20),
          RankSection(
            feelingController: widget.feelingController,
            budgetController: widget.budgetController,
            macrosController: widget.macrosController,
            items: widget.rankingInputs,
            onSave: widget.onAddRanking,
            surface: widget.surface,
            card: widget.card,
            border: widget.border,
            primary: widget.primary,
            textPrimary: widget.textPrimary,
            textSecondary: widget.textSecondary,
          ),
          const SizedBox(height: 20),
          ManualSection(
            nameController: widget.recipeNameController,
            timeController: widget.recipeTimeController,
            budgetController: widget.recipeBudgetController,
            notesController: widget.recipeMacrosController,
            items: widget.recipes,
            onAdd: widget.onAddRecipe,
            surface: widget.surface,
            card: widget.card,
            border: widget.border,
            primary: widget.primary,
            textPrimary: widget.textPrimary,
            textSecondary: widget.textSecondary,
          ),
        ],
      ),
    );
  }
}
