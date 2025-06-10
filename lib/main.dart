import 'package:flutter/material.dart';
// import 'package:skyouthprofiling/data/view/add.dart';
// import 'package:skyouthprofiling/data/view/insert.dart';
import 'presentation/main_screen.dart';

void main() async {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0
        )
      ),
      // theme: ThemeData.light(),
      // darkTheme: ThemeData.dark(),
      // themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}
