import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../home/home_shell.dart';

class DiamondGymApp extends StatelessWidget {
  const DiamondGymApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF2DE2FF),
        ).copyWith(
          primary: const Color(0xFF2DE2FF),
          onPrimary: const Color(0xFF00131A),
          secondary: const Color(0xFF6CB8FF),
          onSecondary: const Color(0xFF071420),
          surface: const Color(0xFF101A2B),
          onSurface: const Color(0xFFE6F6FF),
          onSurfaceVariant: const Color(0xFFC9E7FF),
          error: const Color(0xFFFF5D73),
          onError: const Color(0xFF2A0007),
        );

    return MaterialApp(
      title: 'Diamond Gym',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        textTheme:
            GoogleFonts.plusJakartaSansTextTheme(
              Theme.of(context).textTheme,
            ).apply(
              bodyColor: colorScheme.onSurface,
              displayColor: colorScheme.onSurface,
            ),
        scaffoldBackgroundColor: const Color(0xFF070C17),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B1222),
          foregroundColor: Color(0xFFE6F6FF),
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF111B2D),
          surfaceTintColor: Colors.transparent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: colorScheme.onSurface),
          hintStyle: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.85),
          ),
        ),
        listTileTheme: ListTileThemeData(
          textColor: colorScheme.onSurface,
          iconColor: colorScheme.primary,
        ),
      ),
      home: const HomeShell(),
    );
  }
}
