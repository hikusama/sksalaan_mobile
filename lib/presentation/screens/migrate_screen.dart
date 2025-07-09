import 'package:flutter/material.dart';
import 'package:skyouthprofiling/data/view/logged_in.dart';

class MigrateScreen extends StatefulWidget {
  const MigrateScreen({super.key});

  @override
  State<MigrateScreen> createState() => _MigrateScreenState();
}

bool isHv = false;
bool isPressed = false;

class _MigrateScreenState extends State<MigrateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoggedIn()
    );
  }
}
