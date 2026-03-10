import 'package:flutter/cupertino.dart';

class MainBox extends StatelessWidget {
  const MainBox({
    required this.text,
    required this.surface,
    required this.border,
    required this.textPrimary,
    super.key,
  });

  final String text;
  final Color surface;
  final Color border;
  final Color textPrimary;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [surface, surface.withValues(alpha: 0.82)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Text(text, style: TextStyle(color: textPrimary)),
    );
  }
}
