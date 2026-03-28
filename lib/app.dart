import 'package:flutter/material.dart';

import 'src/pages/cube_demo_page.dart';

class CubeStudyApp extends StatelessWidget {
  const CubeStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFE28A4D),
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Cat Character Viewer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFFFF8F2),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Color(0xFFF0DFD3)),
          ),
        ),
      ),
      home: const CubeDemoPage(),
    );
  }
}
