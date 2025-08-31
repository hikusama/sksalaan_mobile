import 'package:flutter/material.dart';
import 'package:skyouthprofiling/data/view/add.dart';
import 'package:skyouthprofiling/presentation/screens/overview_screen.dart';
import 'package:skyouthprofiling/presentation/screens/records_screen.dart';
import 'package:skyouthprofiling/presentation/screens/hun_screen.dart';
import 'package:skyouthprofiling/presentation/screens/settings_screen.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool isHv = false;
  final List<Widget> _screens = [
    const OverviewScreen(),
    const RecordsScreen(),
    const HubScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop(BuildContext context) async {
    // You can show a dialog or handle logic here
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Exit'),
            content: const Text('Do you want to exit? 🥹'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
    );
    return shouldLeave ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) async {
        bool canPop = await _onWillPop(context);
        if (canPop) {
          FlutterExitApp.exitApp();
        } else {
          return;
        }
      },
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomAppBar(
                      color: const Color.fromARGB(255, 30, 65, 80),
          shape: const CircularNotchedRectangle(),
          notchMargin: 18.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.grid_view, "Overview", 0),
              _buildNavItem(Icons.storage, "Records", 1),
              const SizedBox(width: 40),
              _buildNavItem(Icons.hub, "Hub", 2),
              _buildNavItem(Icons.settings, "Settings", 3),
            ],
          ),
        ),
        floatingActionButton: MouseRegion(
          onEnter: (_) => setState(() => isHv = true),
          onExit: (_) => setState(() => isHv = false),
          child: FloatingActionButton(
            backgroundColor:
                isHv ? Colors.black : const Color.fromRGBO(20, 126, 169, 1),
            shape: const CircleBorder(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Add()),
              );
              // showModalBottomSheet(
              //   context: context,
              //   enableDrag: true,
              //   isScrollControlled: true,
              //   builder: (context) => Add(),
              // );
              // Handle FAB click (e.g., open a modal, new screen, etc.)
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color:
                isSelected
                    ? const Color.fromRGBO(20, 126, 169, 1)
                    : const Color.fromARGB(144, 200, 200, 200),
          ),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:
                  isSelected
                      ? const Color.fromRGBO(20, 126, 169, 1)
                      : const Color.fromARGB(144, 200, 200, 200),
            ),
          ),
        ],
      ),
    );
  }
}
