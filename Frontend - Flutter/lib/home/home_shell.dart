import 'package:flutter/material.dart';

import 'models/app_models.dart';
import 'tabs/favorites_history_tab.dart';
import 'tabs/main_tab.dart';
import 'tabs/pantry_tab.dart';
import 'tabs/profile_tab.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final feelingController = TextEditingController();
  final budgetController = TextEditingController();
  final timeController = TextEditingController();
  final macrosController = TextEditingController();
  final cuisinesController = TextEditingController();

  final recipeNameController = TextEditingController();
  final recipeTimeController = TextEditingController();
  final recipeBudgetController = TextEditingController();
  final recipeMacrosController = TextEditingController();

  final pantryItemController = TextEditingController();
  final pantryQuantityController = TextEditingController();

  final favoriteNameController = TextEditingController();
  final favoriteNotesController = TextEditingController();
  final historyNameController = TextEditingController();
  final historyDetailsController = TextEditingController();

  final profileNameController = TextEditingController();
  final profileRestrictionsController = TextEditingController();
  final profileHeightController = TextEditingController();
  final profileWeightController = TextEditingController();

  final List<String> rankingInputs = [];
  final List<RecipeData> recipes = [];
  final List<String> pantryItems = [];
  final List<FavoriteEntry> favorites = [];
  final List<HistoryEntry> historyEntries = [];
  ProfileData profile = const ProfileData.empty();

  void addRankingInput() {
    final feeling = feelingController.text.trim();
    if (feeling.isEmpty) {
      return;
    }

    final budget = budgetController.text.trim();
    final time = timeController.text.trim();
    final macros = macrosController.text.trim();
    final cuisines = cuisinesController.text.trim();

    setState(() {
      rankingInputs.insert(
        0,
        'Feeling: $feeling • Budget: ${budget.isNotEmpty ? budget : '—'} • Time: ${time.isNotEmpty ? time : '—'} • Macros: ${macros.isNotEmpty ? macros : '—'} • Cuisines: ${cuisines.isNotEmpty ? cuisines : '—'}',
      );
    });
  }

  void addRecipe() {
    final name = recipeNameController.text.trim();
    if (name.isEmpty) {
      return;
    }

    final time = recipeTimeController.text.trim();
    final budget = recipeBudgetController.text.trim();
    final macros = recipeMacrosController.text.trim();

    setState(() {
      recipes.insert(
        0,
        RecipeData(
          name: name,
          time: time.isNotEmpty ? time : '—',
          budget: budget.isNotEmpty ? budget : '—',
          macros: macros.isNotEmpty ? macros : '—',
        ),
      );
    });

    recipeNameController.clear();
    recipeTimeController.clear();
    recipeBudgetController.clear();
    recipeMacrosController.clear();
  }

  void addPantryItem() {
    final ingredient = pantryItemController.text.trim();
    if (ingredient.isEmpty) {
      return;
    }

    final quantity = pantryQuantityController.text.trim();

    setState(() {
      pantryItems.insert(
        0,
        quantity.isEmpty ? ingredient : '$ingredient • $quantity',
      );
    });

    pantryItemController.clear();
    pantryQuantityController.clear();
  }

  void addFavorite() {
    final name = favoriteNameController.text.trim();
    if (name.isEmpty) {
      return;
    }

    setState(() {
      favorites.insert(
        0,
        FavoriteEntry(name: name, notes: favoriteNotesController.text.trim()),
      );
    });

    favoriteNameController.clear();
    favoriteNotesController.clear();
  }

  void addHistory() {
    final name = historyNameController.text.trim();
    if (name.isEmpty) {
      return;
    }

    setState(() {
      historyEntries.insert(
        0,
        HistoryEntry(name: name, details: historyDetailsController.text.trim()),
      );
    });

    historyNameController.clear();
    historyDetailsController.clear();
  }

  void saveProfile() {
    setState(() {
      profile = ProfileData(
        name: profileNameController.text.trim(),
        restrictions: profileRestrictionsController.text.trim(),
        height: profileHeightController.text.trim(),
        weight: profileWeightController.text.trim(),
      );
    });
  }

  @override
  void dispose() {
    feelingController.dispose();
    budgetController.dispose();
    timeController.dispose();
    macrosController.dispose();
    cuisinesController.dispose();

    recipeNameController.dispose();
    recipeTimeController.dispose();
    recipeBudgetController.dispose();
    recipeMacrosController.dispose();

    pantryItemController.dispose();
    pantryQuantityController.dispose();

    favoriteNameController.dispose();
    favoriteNotesController.dispose();
    historyNameController.dispose();
    historyDetailsController.dispose();

    profileNameController.dispose();
    profileRestrictionsController.dispose();
    profileHeightController.dispose();
    profileWeightController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Diamond Gym'),
          centerTitle: true,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0B1222),
                  Color(0xFF13213A),
                  Color(0xFF0E1A30),
                ],
              ),
            ),
          ),
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorWeight: 3,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.9),
            tabs: [
              Tab(text: 'Main', icon: Icon(Icons.search)),
              Tab(text: 'Pantry', icon: Icon(Icons.kitchen)),
              Tab(text: 'Favorites', icon: Icon(Icons.favorite_border)),
              Tab(text: 'Profile', icon: Icon(Icons.person)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MainTab(
              feelingController: feelingController,
              budgetController: budgetController,
              timeController: timeController,
              macrosController: macrosController,
              cuisinesController: cuisinesController,
              onAddRanking: addRankingInput,
              rankingInputs: rankingInputs,
              recipeNameController: recipeNameController,
              recipeTimeController: recipeTimeController,
              recipeBudgetController: recipeBudgetController,
              recipeMacrosController: recipeMacrosController,
              onAddRecipe: addRecipe,
              recipes: recipes,
            ),
            PantryTab(
              pantryItemController: pantryItemController,
              quantityController: pantryQuantityController,
              pantryItems: pantryItems,
              onAddPantry: addPantryItem,
            ),
            FavoritesHistoryTab(
              favoriteNameController: favoriteNameController,
              favoriteNotesController: favoriteNotesController,
              onAddFavorite: addFavorite,
              favorites: favorites,
              historyNameController: historyNameController,
              historyDetailsController: historyDetailsController,
              onAddHistory: addHistory,
              historyEntries: historyEntries,
            ),
            ProfileTab(
              profileNameController: profileNameController,
              profileRestrictionsController: profileRestrictionsController,
              profileHeightController: profileHeightController,
              profileWeightController: profileWeightController,
              onSave: saveProfile,
              profile: profile,
            ),
          ],
        ),
      ),
    );
  }
}
