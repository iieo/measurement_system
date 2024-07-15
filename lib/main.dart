import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:measurement_system/home_page.dart';
import 'package:measurement_system/time_series_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Measurement System',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF64FFDA),
          secondary: Color(0xFF1DE9B6),
          surface: Color(0xFF121212),
          background: Color(0xFF121212),
          error: Color(0xFFCF6679),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Color(0xFFE0E0E0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: const Color(0xFF64FFDA),
          ),
        ),
        cardTheme: const CardTheme(
          color: Color(0xFF1E1E1E),
        ),
      ),
    );
  }

  static final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MeasurementSystem(),
      ),
      GoRoute(
        path: '/time-series',
        builder: (context, state) => const TimeSeriesPage(),
      ),
    ],
  );
}
