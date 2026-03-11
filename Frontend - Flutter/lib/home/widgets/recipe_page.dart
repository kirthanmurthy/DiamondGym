import 'package:flutter/cupertino.dart';

import '../models/api_recipe.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({
    required this.recipe,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onSelectRecipe,
    required this.surface,
    required this.border,
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    super.key,
  });

  final ApiRecipe recipe;
  final bool isFavorite;
  final Future<void> Function() onToggleFavorite;
  final Future<void> Function() onSelectRecipe;
  final Color surface;
  final Color border;
  final Color primary;
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    final time = recipe.time != null ? '${recipe.time} min' : 'Time not listed';
    final calories = recipe.calories != null
        ? '${recipe.calories} cal'
        : 'Calories not listed';

    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF07111F),
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Text(recipe.title),
        backgroundColor: const Color(0xFF0C1628),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (recipe.image.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    recipe.image,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: TextStyle(
                        color: primary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$time • $calories',
                      style: TextStyle(color: textPrimary, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Score: ${recipe.score.toStringAsFixed(2)}',
                      style: TextStyle(color: textSecondary, fontSize: 12),
                    ),
                    if (recipe.ingredients.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Ingredients: ${recipe.ingredients.join(', ')}',
                        style: TextStyle(color: textSecondary, fontSize: 13),
                      ),
                    ],
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          onPressed: onToggleFavorite,
                          child: Row(
                            children: [
                              Icon(
                                isFavorite
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                                color: const Color(0xFFFF7FB0),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isFavorite ? 'Favorited' : 'Favorite',
                                style: TextStyle(color: textPrimary),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        CupertinoButton.filled(
                          onPressed: onSelectRecipe,
                          child: const Text('Select recipe'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recipe',
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (recipe.steps.isEmpty)
                      Text(
                        'No recipe steps were returned for this meal.',
                        style: TextStyle(color: textSecondary),
                      ),
                    ...recipe.steps.map(
                      (step) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          step,
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
