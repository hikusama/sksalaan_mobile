import 'package:flutter/material.dart';
import 'package:skyouthprofiling/data/view/add.dart';
import 'package:skyouthprofiling/presentation/screens/overview_screen.dart';
import 'package:skyouthprofiling/presentation/screens/records_screen.dart';
import 'package:skyouthprofiling/presentation/screens/hub_screen.dart';
import 'package:skyouthprofiling/presentation/screens/validation_screen.dart';
import 'package:skyouthprofiling/presentation/screens/settings_screen.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int? _hoveredIndex;
  final List<Widget> _screens = [
    const OverviewScreen(),
    const RecordsScreen(),
    const HubScreen(),
    const SettingsScreen(),
    const ValidationScreen(),
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
        body: Stack(children: [_screens[_selectedIndex], SizedBox()]),
        bottomNavigationBar: SafeArea(
          child: BottomAppBar(
            padding: EdgeInsets.all(0),
            height: 52,
            color: const Color.fromARGB(255, 30, 65, 80),
            // shape: const CircularNotchedRectangle(),
            // notchMargin: 18.0,
            // height: 70,
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(25),
                        ),
                        color: const Color.fromARGB(255, 8, 26, 35),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: _buildNavItem(Icons.add, "Add", 34)),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      _selectedIndex == 4
                                          ? Color.fromARGB(142, 0, 0, 0)
                                          : Colors.transparent,
                                  width: _selectedIndex == 4 ? 1 : 0,
                                ),
                                borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(25),
                                  left: Radius.circular(25),
                                ),
                                color:
                                    _selectedIndex == 4
                                        ? Color.fromARGB(188, 0, 72, 136)
                                        : Colors.transparent,
                              ),
                              child: _buildNavItem(
                                Icons.fact_check,
                                "Validate",
                                35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildNavItem(Icons.grid_view, "Home", 0),
                        ),
                        Expanded(
                          child: _buildNavItem(Icons.storage, "Data", 1),
                        ),
                        Expanded(child: _buildNavItem(Icons.hub, "Hub", 2)),
                        Expanded(
                          child: _buildNavItem(Icons.settings, "Settings", 3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      //   floatingActionButton: MouseRegion(
      //     onEnter: (_) => setState(() => isHv = true),
      //     onExit: (_) => setState(() => isHv = false),
      //     child: FloatingActionButton(
      //       backgroundColor:
      //           isHv ? Colors.black : const Color.fromRGBO(20, 126, 169, 1),
      //       shape: const CircleBorder(),
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => const Add()),
      //         );
      //         // showModalBottomSheet(
      //         //   context: context,
      //         //   enableDrag: true,
      //         //   isScrollControlled: true,
      //         //   builder: (context) => Add(),
      //         // );
      //         // Handle FAB click (e.g., open a modal, new screen, etc.)
      //       },
      //       child: const Icon(Icons.add, color: Colors.white),
      //     ),
      //   ),
      //   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;
    final bool isHovered = _hoveredIndex == index;
    final bool isActive = isSelected || isHovered;

    return GestureDetector(
      onTap: () {
        if (index == 34) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Add()),
          );
        } else if (index == 35) {
          _onItemTapped(4);
        } else {
          _onItemTapped(index);
        }
      },
      onTapDown: (_) {
        setState(() => _hoveredIndex = index);
      },
      onTapCancel: () {
        setState(() => _hoveredIndex = null);
      },
      onTapUp: (_) {
        setState(() => _hoveredIndex = null);
      },
      child: Container(
        color: const Color.fromARGB(0, 187, 10, 10),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color:
                  isActive
                      ? const Color.fromRGBO(20, 126, 169, 1)
                      : const Color.fromARGB(144, 200, 200, 200),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color:
                    isActive
                        ? const Color.fromRGBO(20, 126, 169, 1)
                        : const Color.fromARGB(144, 200, 200, 200),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
