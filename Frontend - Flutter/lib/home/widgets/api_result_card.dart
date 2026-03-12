import 'package:flutter/cupertino.dart';

import '../models/api_recipe.dart';
import 'recipe_page.dart';

class ApiResultCard extends StatelessWidget {
  const ApiResultCard({
    required this.recipe,
    required this.surface,
    required this.border,
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    super.key,
  });

  final ApiRecipe recipe;
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

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => RecipePage(
              recipe: recipe,
              surface: surface,
              border: border,
              primary: primary,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [surface, surface.withValues(alpha: 0.86)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border, width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x16000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (recipe.image.isNotEmpty)
                Image.network(
                  recipe.image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      color: surface,
                      alignment: Alignment.center,
                      child: Icon(
                        CupertinoIcons.photo,
                        size: 34,
                        color: textSecondary,
                      ),
                    );
                  },
                ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Match',
                        style: TextStyle(
                          color: primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      recipe.title,
                      style: TextStyle(
                        color: primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$time • $calories',
                      style: TextStyle(color: textPrimary, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Score: ${recipe.score.toStringAsFixed(2)}',
                      style: TextStyle(color: textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.book,
                          color: textSecondary,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Tap to view recipe',
                          style: TextStyle(color: textSecondary, fontSize: 12),
                        ),
                      ],
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
