import 'package:flutter/material.dart';
import 'package:skyouthprofiling/data/view/insert.dart';
import 'package:skyouthprofiling/presentation/screens/overview_screen.dart';
import 'package:skyouthprofiling/presentation/screens/records_screen.dart';
import 'package:skyouthprofiling/presentation/screens/migrate_screen.dart';
import 'package:skyouthprofiling/presentation/screens/settings_screen.dart';

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
    // const MigrateScreen(),
    // const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: _screens[_selectedIndex], // Load selected screen
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 18.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.grid_view, "Overview", 0),
            _buildNavItem(Icons.storage, "Records", 1),
            const SizedBox(width: 40),  
            _buildNavItem(Icons.import_export_sharp, "Migrate", 2),
            _buildNavItem(Icons.settings, "Settings", 3),
          ],
        ),
      ),
      floatingActionButton: MouseRegion(
        onEnter:(_) => setState(() => isHv = true),
        onExit:(_) => setState(() => isHv = false),
        child: FloatingActionButton(
          backgroundColor: isHv ? Colors.black : Color.fromARGB(75, 0, 0, 0) ,
          shape: const CircleBorder(),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => InsertYouth(),
            );
            // Handle FAB click (e.g., open a modal, new screen, etc.)
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.black : Colors.grey),
          Text(
            label,
            style: TextStyle(color: isSelected ? Colors.black : Colors.grey),
          ),
        ],
      ),
    );
  }
}
