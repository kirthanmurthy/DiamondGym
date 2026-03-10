import 'package:flutter/cupertino.dart';

import '../home/home_shell.dart';

class DiamondGymApp extends StatelessWidget {
  const DiamondGymApp({super.key});

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFF07111F);
    const surface = Color(0xFF0F1B30);
    const card = Color(0xFF13223B);
    const border = Color(0xFF244066);
    const primary = Color(0xFF33C2FF);
    const secondary = Color(0xFF7CFFB2);
    const textPrimary = Color(0xFFF4F8FF);
    const textSecondary = Color(0xFF9BB1D1);

    return CupertinoApp(
      title: 'Diamond Gym',
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: primary,
        scaffoldBackgroundColor: background,
        barBackgroundColor: Color(0xFF0C1628),
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(color: textPrimary, fontSize: 16),
          navTitleTextStyle: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          navLargeTitleTextStyle: TextStyle(
            color: textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      home: const HomeShell(
        background: background,
        surface: surface,
        card: card,
        border: border,
        primary: primary,
        secondary: secondary,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
      ),
    );
  }
}
