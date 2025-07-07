import 'package:flutter/material.dart';

class MigrateScreen extends StatefulWidget {
  const MigrateScreen({super.key});

  @override
  State<MigrateScreen> createState() => _MigrateScreenState();
}

bool isHv = false;

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
            onLongPress: () {
              setState(() {
                isHv ? isHv = false : isHv = true;
              });
            },
            child: Container(
              height: isHv ? 200 : 300,
              width: isHv ? 200 : 300,
              decoration: BoxDecoration(
                color:
                    isHv
                        ? const Color.fromARGB(255, 122, 60, 2)
                        : const Color.fromARGB(205, 27, 57, 70),
                borderRadius: BorderRadius.circular(150),
                border: Border.all(
                  width: 4,
                  color: const Color.fromARGB(255, 6, 64, 91),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isHv
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
                  isHv
                      ? Text(
                        'Migrating data',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      )
                      : Text(
                        '< Long press to start >',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                  isHv
                      ? Text(
                        '< Long press to abort >',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
