import 'package:flutter/cupertino.dart';

import 'models/api_recipe.dart';
import 'services/api_client.dart';
import 'models/app_models.dart';
import 'page_shell.dart';
import 'tab_icon.dart';
import 'tabs/favorites_history_tab.dart';
import 'tabs/main_tab.dart';
import 'tabs/pantry_tab.dart';
import 'tabs/profile_tab.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({
    required this.background,
    required this.surface,
    required this.card,
    required this.border,
    required this.primary,
    required this.secondary,
    required this.textPrimary,
    required this.textSecondary,
    super.key,
  });

  final Color background;
  final Color surface;
  final Color card;
  final Color border;
  final Color primary;
  final Color secondary;
  final Color textPrimary;
  final Color textSecondary;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  static const _apiBaseUrl = 'http://127.0.0.1:5001';

  final tab = CupertinoTabController(initialIndex: 0);
  final api = ApiClient(baseUrl: _apiBaseUrl);

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

  void rank() {
    final feel = feelingController.text.trim();
    if (feel.isEmpty) {
      return;
    }

    final budget = budgetController.text.trim();
    final time = timeController.text.trim();
    final macros = macrosController.text.trim();
    final cuisines = cuisinesController.text.trim();

    setState(() {
      rankingInputs.insert(
        0,
        'Feeling: $feel • Budget: ${budget.isNotEmpty ? budget : '—'} • Time: ${time.isNotEmpty ? time : '—'} • Macros: ${macros.isNotEmpty ? macros : '—'} • Cuisines: ${cuisines.isNotEmpty ? cuisines : '—'}',
      );
    });
  }

  void recipe() {
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

  void pantry() {
    final item = pantryItemController.text.trim();
    if (item.isEmpty) {
      return;
    }

    final qty = pantryQuantityController.text.trim();

    setState(() {
      pantryItems.insert(0, qty.isEmpty ? item : '$item • $qty');
    });

    pantryItemController.clear();
    pantryQuantityController.clear();
    api.addPantryItem(item).catchError((_) {});
  }

  void fave() {
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

  void log() {
    final name = historyNameController.text.trim();
    if (name.isEmpty) {
      return;
    }

    setState(() {
      historyEntries.insert(
        0,
        HistoryEntry(
          name: name,
          details: historyDetailsController.text.trim(),
        ),
      );
    });

    historyNameController.clear();
    historyDetailsController.clear();
  }

  void save() {
    setState(() {
      profile = ProfileData(
        name: profileNameController.text.trim(),
        restrictions: profileRestrictionsController.text.trim(),
        height: profileHeightController.text.trim(),
        weight: profileWeightController.text.trim(),
      );
      tab.index = 0;
    });
  }

  bool isFavorite(ApiRecipe recipe) {
    final recipeId = recipe.id;
    return favorites.any(
      (entry) =>
          (recipeId != null && entry.recipeId == recipeId) ||
          entry.name.toLowerCase() == recipe.title.toLowerCase(),
    );
  }

  Future<void> toggleFavorite(ApiRecipe recipe) async {
    final recipeId = recipe.id;
    final currentlyFavorite = isFavorite(recipe);

    setState(() {
      if (currentlyFavorite) {
        favorites.removeWhere(
          (entry) =>
              (recipeId != null && entry.recipeId == recipeId) ||
              entry.name.toLowerCase() == recipe.title.toLowerCase(),
        );
      } else {
        favorites.insert(
          0,
          FavoriteEntry(
            name: recipe.title,
            notes: recipe.cuisines.join(', '),
            recipeId: recipeId,
          ),
        );
      }
    });

    try {
      if (currentlyFavorite) {
        if (recipeId != null) {
          await api.removeFavorite(recipeId);
        }
      } else {
        await api.saveFavorite(recipe);
      }
    } catch (_) {}
  }

  Future<void> selectRecipe(ApiRecipe recipe) async {
    final removedIngredients = <String>[];

    setState(() {
      for (final ingredient in recipe.ingredients) {
        final pantryIndex = pantryItems.indexWhere(
          (item) => item.split('•').first.trim().toLowerCase() == ingredient,
        );

        if (pantryIndex != -1) {
          removedIngredients.add(pantryItems[pantryIndex]);
          pantryItems.removeAt(pantryIndex);
        }
      }

      historyEntries.removeWhere(
        (entry) =>
            (recipe.id != null && entry.recipeId == recipe.id) ||
            entry.name.toLowerCase() == recipe.title.toLowerCase(),
      );
      historyEntries.insert(
        0,
        HistoryEntry(
          name: recipe.title,
          details: removedIngredients.isEmpty
              ? 'Added from recipe selection'
              : 'Removed from pantry: ${removedIngredients.join(', ')}',
          recipeId: recipe.id,
        ),
      );

      tab.index = 2;
    });

    try {
      await api.selectRecipe(recipe);
    } catch (_) {}
  }

  @override
  void dispose() {
    tab.dispose();
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
    if (profile.isEmpty) {
      return _start();
    }

    return CupertinoTabScaffold(
      controller: tab,
      tabBar: _bar(),
      tabBuilder: (context, index) {
        return CupertinoTabView(builder: (context) => _page(index));
      },
    );
  }

  Widget _start() {
    return PageShell(
      title: 'Profile',
      background: widget.background,
      barColor: widget.surface,
      child: ProfileTab(
        profileNameController: profileNameController,
        profileRestrictionsController: profileRestrictionsController,
        profileHeightController: profileHeightController,
        profileWeightController: profileWeightController,
        onSave: save,
        profile: profile,
        surface: widget.surface,
        card: widget.card,
        border: widget.border,
        primary: widget.primary,
        textPrimary: widget.textPrimary,
        textSecondary: widget.textSecondary,
      ),
    );
  }

  CupertinoTabBar _bar() {
    return CupertinoTabBar(
      backgroundColor: const Color(0xF20C1628),
      activeColor: widget.primary,
      inactiveColor: widget.textSecondary,
      border: Border(
        top: BorderSide(color: widget.border.withValues(alpha: 0.7), width: 1),
      ),
      iconSize: 22,
      items: [
        _item(
          label: 'Home',
          icon: CupertinoIcons.sparkles,
          activeIcon: CupertinoIcons.sparkles,
          activeColor: widget.primary,
        ),
        _item(
          label: 'Pantry',
          icon: CupertinoIcons.cube_box,
          activeIcon: CupertinoIcons.cube_box_fill,
          activeColor: widget.secondary,
        ),
        _item(
          label: 'Favorites',
          icon: CupertinoIcons.heart_circle,
          activeIcon: CupertinoIcons.heart_circle_fill,
          activeColor: const Color(0xFFFF7FB0),
        ),
        _item(
          label: 'Profile',
          icon: CupertinoIcons.person_crop_circle,
          activeIcon: CupertinoIcons.person_crop_circle_fill,
          activeColor: widget.primary,
        ),
      ],
    );
  }

  BottomNavigationBarItem _item({
    required String label,
    required IconData icon,
    required IconData activeIcon,
    required Color activeColor,
  }) {
    return BottomNavigationBarItem(
      icon: TabIcon(icon: icon, color: widget.textSecondary),
      activeIcon: TabIcon(icon: activeIcon, color: activeColor, active: true),
      label: label,
    );
  }

  Widget _page(int index) {
    switch (index) {
      case 0:
        return _shell(
          title: 'Home',
          child: MainTab(
            feelingController: feelingController,
            budgetController: budgetController,
            timeController: timeController,
            macrosController: macrosController,
            cuisinesController: cuisinesController,
            pantryItems: pantryItems,
            onAddRanking: rank,
            rankingInputs: rankingInputs,
            recipeNameController: recipeNameController,
            recipeTimeController: recipeTimeController,
            recipeBudgetController: recipeBudgetController,
            recipeMacrosController: recipeMacrosController,
            onAddRecipe: recipe,
            recipes: recipes,
            isFavorite: isFavorite,
            onToggleFavorite: toggleFavorite,
            onSelectRecipe: selectRecipe,
            surface: widget.surface,
            card: widget.card,
            border: widget.border,
            primary: widget.primary,
            textPrimary: widget.textPrimary,
            textSecondary: widget.textSecondary,
          ),
        );
      case 1:
        return _shell(
          title: 'Pantry',
          child: PantryTab(
            pantryItemController: pantryItemController,
            quantityController: pantryQuantityController,
            pantryItems: pantryItems,
            onAddPantry: pantry,
            surface: widget.surface,
            card: widget.card,
            border: widget.border,
            primary: widget.primary,
            textPrimary: widget.textPrimary,
            textSecondary: widget.textSecondary,
          ),
        );
      case 2:
        return _shell(
          title: 'Favorites',
          child: FavoritesHistoryTab(
            favoriteNameController: favoriteNameController,
            favoriteNotesController: favoriteNotesController,
            onAddFavorite: fave,
            favorites: favorites,
            historyNameController: historyNameController,
            historyDetailsController: historyDetailsController,
            onAddHistory: log,
            historyEntries: historyEntries,
            surface: widget.surface,
            card: widget.card,
            border: widget.border,
            primary: widget.primary,
            secondary: widget.secondary,
            textPrimary: widget.textPrimary,
            textSecondary: widget.textSecondary,
          ),
        );
      default:
        return _shell(
          title: 'Profile',
          child: ProfileTab(
            profileNameController: profileNameController,
            profileRestrictionsController: profileRestrictionsController,
            profileHeightController: profileHeightController,
            profileWeightController: profileWeightController,
            onSave: save,
            profile: profile,
            surface: widget.surface,
            card: widget.card,
            border: widget.border,
            primary: widget.primary,
            textPrimary: widget.textPrimary,
            textSecondary: widget.textSecondary,
          ),
        );
    }
  }

  Widget _shell({required String title, required Widget child}) {
    return PageShell(
      title: title,
      background: widget.background,
      barColor: widget.surface,
      child: child,
    );
  }
}
