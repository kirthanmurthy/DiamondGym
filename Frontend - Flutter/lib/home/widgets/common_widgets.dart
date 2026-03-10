import 'package:flutter/cupertino.dart';

import '../models/app_models.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    required this.title,
    required this.titleColor,
    required this.background,
    required this.border,
    required this.child,
    super.key,
  });

  final String title;
  final Color titleColor;
  final Color background;
  final Color border;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: titleColor,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: titleColor,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class InputField extends StatelessWidget {
  const InputField({
    required this.controller,
    required this.label,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    this.placeholder,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String? placeholder;
  final Color surface;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        CupertinoTextField(
          controller: controller,
          placeholder: placeholder ?? 'Enter ${label.toLowerCase()}',
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          style: TextStyle(color: textPrimary, fontSize: 15),
          placeholderStyle: TextStyle(color: textSecondary),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border, width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GymButton extends StatelessWidget {
  const GymButton({
    required this.label,
    required this.onPressed,
    required this.primary,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final color = onPressed == null ? primary.withValues(alpha: 0.45) : primary;

    return CupertinoButton(
      color: color,
      borderRadius: BorderRadius.circular(14),
      onPressed: onPressed,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Text(
        label,
        style: const TextStyle(
          color: CupertinoColors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    required this.data,
    required this.surface,
    required this.border,
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    super.key,
  });

  final RecipeData data;
  final Color surface;
  final Color border;
  final Color primary;
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.name,
            style: TextStyle(
              color: primary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Time: ${data.time} • Budget: ${data.budget}',
            style: TextStyle(color: textPrimary, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            'Notes: ${data.macros}',
            style: TextStyle(color: textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
