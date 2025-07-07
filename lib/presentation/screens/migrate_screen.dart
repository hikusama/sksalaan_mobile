import 'package:flutter/material.dart';

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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(150),
            onTapDown: (_) => setState(() => isHv = true),
            onTapCancel: () => setState(() => isHv = false),
            onLongPress: () {
              setState(() {
                isPressed = !isPressed;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isPressed)
                  SizedBox(
                    height: 250,
                    width: 250,
                    child: CircularProgressIndicator(
                      value: null,
                      strokeWidth: 6,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color.fromARGB(255, 113, 63, 7),
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),

                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: isPressed ? 200 : 300,
                  width: isPressed ? 200 : 300,
                  decoration: BoxDecoration(
                    color:
                        isPressed
                            ? isHv
                                ? const Color.fromARGB(146, 113, 64, 7)
                                : const Color.fromARGB(255, 113, 63, 7)
                            : isHv
                            ? const Color.fromARGB(100, 27, 57, 70)
                            : const Color.fromARGB(205, 27, 57, 70),

                    borderRadius: BorderRadius.circular(150),
                    border: Border.all(
                      width: 4,
                      color: isPressed ? const Color.fromARGB(255, 87, 51, 9) : const Color.fromARGB(255, 6, 64, 91),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isPressed
                          ? Icon(
                            Icons.import_export_outlined,
                            color: Colors.white,
                            size: 35,
                          )
                          : Text(
                            'Go',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      isPressed
                          ? Text(
                            'Migrating data',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          )
                          : Text(
                            '< Long press to start >',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                      isPressed
                          ? Text(
                            '< Long press to abort >',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
