import 'package:flutter/cupertino.dart';

import '../../models/api_recipe.dart';
import '../../widgets/api_result_card.dart';
import '../../widgets/common_widgets.dart';

class ResultsSection extends StatelessWidget {
  const ResultsSection({
    required this.loading,
    required this.didSearch,
    required this.items,
    required this.surface,
    required this.card,
    required this.border,
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    super.key,
  });

  final bool loading;
  final bool didSearch;
  final List<ApiRecipe> items;
  final Color surface;
  final Color card;
  final Color border;
  final Color primary;
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Results',
      titleColor: textPrimary,
      background: card,
      border: border,
      child: Column(
        children: [
          if (!loading && items.isEmpty)
            Text(
              didSearch
                  ? 'No recipes matched these filters. Try broader inputs.'
                  : 'Run a search to load recipes here.',
              style: TextStyle(color: textSecondary),
            ),
          ...items.map(
            (item) => ApiResultCard(
              recipe: item,
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
