import 'package:flutter/cupertino.dart';

import '../../widgets/common_widgets.dart';
import 'main_box.dart';

class RankSection extends StatelessWidget {
  const RankSection({
    required this.feelingController,
    required this.budgetController,
    required this.macrosController,
    required this.items,
    required this.onSave,
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
  final TextEditingController macrosController;
  final List<String> items;
  final VoidCallback onSave;
  final Color surface;
  final Color card;
  final Color border;
  final Color primary;
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Ranking Inputs',
      titleColor: textPrimary,
      background: card,
      border: border,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputField(
            controller: feelingController,
            label: 'What are you feeling like today?',
            surface: surface,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: 14),
          InputField(
            controller: budgetController,
            label: 'Budget cap',
            surface: surface,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: 14),
          InputField(
            controller: macrosController,
            label: 'Macro preference',
            placeholder: 'e.g. high protein',
            surface: surface,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: 16),
          GymButton(
            label: 'Save ranking input',
            onPressed: onSave,
            primary: primary,
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            Text(
              'No saved ranking notes yet.',
              style: TextStyle(color: textSecondary),
            ),
          ...items.map(
            (item) => MainBox(
              text: item,
              surface: surface,
              border: border,
              textPrimary: textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
