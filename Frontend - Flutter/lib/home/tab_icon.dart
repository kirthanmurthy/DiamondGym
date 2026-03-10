import 'package:flutter/cupertino.dart';

class TabIcon extends StatelessWidget {
  const TabIcon({
    required this.icon,
    required this.color,
    this.active = false,
    super.key,
  });

  final IconData icon;
  final Color color;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: active
            ? color.withValues(alpha: 0.18)
            : CupertinoColors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: active
            ? Border.all(color: color.withValues(alpha: 0.22))
            : null,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
