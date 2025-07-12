import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:skyouthprofiling/service/dio_client.dart';
import 'package:skyouthprofiling/data/app_database.dart';

class LoggedIn extends StatefulWidget {
  const LoggedIn({super.key});

  @override
  State<LoggedIn> createState() => _LoggedInState();
}

final Dio dio = Dio();

class _LoggedInState extends State<LoggedIn> {
  final storage = FlutterSecureStorage();
  final ScrollController _scrollController = ScrollController();

  late TextEditingController ipTextController;
  final db = DatabaseProvider.instance;
  DioClient? client;
  Map<String, dynamic> errors = {};
  final CancelToken cancelToken = CancelToken();
  int sub = 0;
  int fld = 0;
  int attempted = 0;
  bool isHv = false;
  int isPressed = 0; // 0=Scan, 1=Scanning, 2=Go, 3=Migrating, 4=Start
  bool isRequested = false;

  @override
  void initState() {
    super.initState();
    ipTextController = TextEditingController();
    _loadIp();
  }

  Future<void> _loadIp() async {
    String? ip = await storage.read(key: 'ip');
    ipTextController.text = ip ?? '';
    if (ip != null && ip.isNotEmpty) {
      client = DioClient(ip);
    }
  }

  int scanned = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors:
                    isRequested
                        ? [
                          const Color.fromARGB(255, 27, 57, 70),
                          const Color.fromARGB(166, 27, 57, 70),
                          const Color.fromARGB(255, 27, 57, 70),
                        ]
                        : [
                          const Color.fromARGB(0, 70, 40, 27),
                          const Color.fromARGB(0, 70, 40, 27),
                        ],
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
            width: double.infinity,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap:
                          () => setState(() {
                            if (isRequested) {
                              isRequested = false;
                              isPressed = 0;
                            }
                          }),
                      borderRadius: BorderRadius.circular(150),
                      onTapDown: (_) => setState(() => isHv = true),
                      onTapCancel: () => setState(() => isHv = false),
                      onLongPress: () async {
                        if (client == null || (isPressed == 4 && isRequested)) {
                          return;
                        }

                        if (isPressed == 3) {
                          client!.cancelToken.cancel("Aborted");
                          return;
                        }

                        if (isPressed == 0) {
                          setState(() => isPressed = 1); // Scanning
                          final count = await db.countStandbyYouthUsers();
                          await Future.delayed(Duration(seconds: 2));
                          setState(() => scanned = count); // Go
                          setState(() => isPressed = 2); // Go
                          return;
                        }

                        if (isPressed == 2) {
                          setState(() => isPressed = 3); //
                          print('------------');

                          if (scanned < 1) return;
                          try {
                          final youthBulk = await db.migrate();
                          final resMigrate = await client?.migrateData(
                            youthBulk,
                          );
                          print('------------2');
                          print(youthBulk);
                          print('------------3');
                          print(resMigrate);


                            if (resMigrate != null &&
                                resMigrate.containsKey('data')) {
                              final data = resMigrate['data'];
                              final submitted = List<int>.from(
                                data['submitted'] ?? [],
                              );
                              final failed = List<int>.from(
                                data['failed'] ?? [],
                              );
                              setState(() {
                                attempted = submitted.length + failed.length;
                                sub = submitted.length;
                                fld = failed.length;
                              });

                              await db.updateMigrationStatus(
                                submitted: submitted,
                                failed: failed,
                              );
                            } else {}
                          } catch (e) {
                          await Future.delayed(Duration(seconds: 2));
                            print(e);
                          }
                          setState(() => isRequested = true); // Migrating
                          setState(() => isPressed = 4); // Start
                          return;
                        }

                        if (isPressed == 4) {
                          setState(() => isPressed = 0); // Reset to Scan
                          return;
                        }
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (isPressed == 1 || isPressed == 3)
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
                            height:
                                isPressed == 1 || isPressed == 3
                                    ? 200
                                    : isPressed == 4
                                    ? 130
                                    : 150,
                            width:
                                isPressed == 1 || isPressed == 3
                                    ? 200
                                    : isPressed == 4
                                    ? 130
                                    : 150,
                            decoration: BoxDecoration(
                              color:
                                  isRequested
                                      ? const Color.fromARGB(218, 9, 53, 87)
                                      : isPressed == 3
                                      ? isHv
                                          ? const Color.fromARGB(
                                            146,
                                            113,
                                            64,
                                            7,
                                          )
                                          : const Color.fromARGB(
                                            255,
                                            113,
                                            63,
                                            7,
                                          )
                                      : isHv
                                      ? const Color.fromARGB(100, 27, 57, 70)
                                      : const Color.fromARGB(205, 27, 57, 70),
                              borderRadius: BorderRadius.circular(150),
                              border: Border.all(
                                width: 4,
                                color:
                                    isRequested
                                        ? const Color.fromARGB(255, 9, 53, 87)
                                        : isPressed == 3
                                        ? const Color.fromARGB(255, 87, 51, 9)
                                        : const Color.fromARGB(255, 6, 64, 91),
                              ),
                            ),
                            child: _buttonText(),
                          ),
                        ],
                      ),
                    ),
                    if (isRequested) SizedBox(width: 15),
                    if (isRequested)
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: isRequested ? 160 : 0,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              _buildLegend(
                                Colors.orange,
                                "Attempted",
                                attempted.toString(),
                              ),
                              _buildLegend(
                                Colors.green,
                                "Submitted",
                                sub.toString(),
                              ),
                              _buildLegend(
                                Colors.red,
                                "Failed",
                                fld.toString(),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonText() {
    switch (isPressed) {
      case 1:
        return _label("Scanning", "Please wait...");
      case 2:
        return _label("Go", "$scanned scanned data");
      case 3:
        return _label("Migrating", "Long press to abort");
      case 4:
        return _label("Start", "Scan again");
      default:
        return _label("Scan", "Scan youth");
    }
  }

  Widget _label(String title, String subtitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(subtitle, style: TextStyle(color: Colors.white, fontSize: 14)),
        if (title == "Go")
          Text(
            'Migrate now',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
      ],
    );
  }

  Widget _buildLegend(Color color, String label, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 20,
            child: Text(
              v,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
