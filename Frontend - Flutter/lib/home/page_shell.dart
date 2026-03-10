import 'package:flutter/cupertino.dart';

class PageShell extends StatelessWidget {
  const PageShell({
    required this.title,
    required this.background,
    required this.barColor,
    required this.child,
    super.key,
  });

  final String title;
  final Color background;
  final Color barColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: background,
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
        backgroundColor: barColor,
      ),
      child: SafeArea(child: child),
    );
  }
}
