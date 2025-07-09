import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:skyouthprofiling/service/dio_client.dart';

class LoggedIn extends StatefulWidget {
  const LoggedIn({super.key});

  @override
  State<LoggedIn> createState() => _LoggedInState();
}

final Dio dio = Dio();

class _LoggedInState extends State<LoggedIn> {

  final storage = FlutterSecureStorage();
  late TextEditingController ipTextController;
  DioClient? client;
  Future<Map<String, dynamic>>? data;
  Map<String, dynamic> errors = {};

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

  final CancelToken cancelToken = CancelToken();

  bool isHv = false;
  bool isPressed = false;

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
            onLongPress: () async {
              if (client == null) return;

              if (isPressed) {
                print('Aborting request...');
                client!.cancelToken.cancel("User aborted request");
                return;
              }

              setState(() {
                isPressed = true;
              });

              print('Requesting.......');
              final res = await client!.login('', '');

              if (res['error'] is Map<String, dynamic>) {
                final error = res['error'];
                errors['password'] = error['errors']?['password']?.first;
                errors['email'] = error['errors']?['email']?.first;

                print(errors["password"]);
                print(errors["email"]);
              }

              print('........Ended.......');
              setState(() {
                isPressed = false;
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
                      color:
                          isPressed
                              ? const Color.fromARGB(255, 87, 51, 9)
                              : const Color.fromARGB(255, 6, 64, 91),
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
