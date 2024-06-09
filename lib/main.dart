import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/theme_provider.dart';
import './screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true).copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xfffffbfe),
          surfaceTintColor: Color(0xfffffbfe),
        ),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff1c1c1c),
          surfaceTintColor: Color(0xff1c1c1c),
        ),
      ),
      themeMode: Provider.of<ThemeProvider>(context).currentTheme,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
