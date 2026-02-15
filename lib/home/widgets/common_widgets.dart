import 'package:flutter/material.dart';

import '../models/app_models.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: colors.secondary,
      ),
    );
  }
}

class InputField extends StatelessWidget {
  const InputField({required this.controller, required this.label, super.key});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      style: TextStyle(color: colors.onSurface),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: colors.surfaceContainerHigh,
        labelStyle: TextStyle(color: colors.onSurface),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  const RecipeCard({required this.data, super.key});

  final RecipeData data;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Time: ${data.time} • Budget: ${data.budget}',
              style: TextStyle(color: colors.onSurface),
            ),
            const SizedBox(height: 4),
            Text(
              'Notes: ${data.macros}',
              style: TextStyle(color: colors.onSurface.withValues(alpha: 0.95)),
            ),
          ],
        ),
      ),
    );
  }
}
