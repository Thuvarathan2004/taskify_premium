import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() => runApp(const TaskifyApp());

class TaskifyApp extends StatelessWidget {
  const TaskifyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Taskify Premium',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF090E26),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFAB61FF),
            brightness: Brightness.dark,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            filled: true,
            fillColor: const Color(0xFF1D254D),
          ),
        ),
        home: const SplashScreen(),
      );
}
