import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skyouthprofiling/data/app_database.dart';
import 'package:skyouthprofiling/data/view/loginform.dart';
import 'package:skyouthprofiling/service/dio_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:fl_chart/fl_chart.dart';

class HubScreen extends StatefulWidget {
  final VoidCallback chtp;
  const HubScreen({super.key, required this.chtp});
  @override
  State<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> {
  Map<String, String?> errors = {'email': null, 'password': null, 'auth': null};
  Timer? _timer;
  Timer? _timerAuth;
  String expirationCountDown = "00:00";
  String? hob;
  String? hubStat;
  String? serverConn;
  String? ipConf;
  String? disconnectionTime = "--:--:--";
  String? name;
  bool loadd = false;
  bool tryhub = false;
  bool showRetry = false;
  String? req;
  String reqType = 'dl';
  int regs = 0;
  int av = 0;
  int uv = 0;
  String? auth;
  late TextEditingController ipTextController;
  DioClient? client;
  final storage = FlutterSecureStorage();
  Map<String, Map<String, dynamic>> addresses = {};
  /*

    'Zone 1': {'value': 12, 'status': false},
    'Zone 2': {'value': 12, 'status': false},
    'Zone 3': {'value': 12, 'status': false},
    'Zone 4': {'value': 12, 'status': false},
    'Sittio Lugakit': {'value': 12, 'status': false},
    'Sittio Balunu': {'value': 12, 'status': false},
    'Sittio Hapa': {'value': 12, 'status': false},
    'Sittio Carreon': {'value': 12, 'status': false},
    'Sittio San Antonio': {'value': 12, 'status': false},
  
*/
  Future<void> mchange() async {
    await _auth();
  }

  @override
  void initState() {
    super.initState();
    ipTextController = TextEditingController();
    _init();
  }

  // void _check() async {
  //   final res = await client?.checkAuth().timeout(
  //     const Duration(seconds: 15),
  //     onTimeout: () => Future.value({'error': 'timeout'}),
  //   );
  // }

  // Future<void> _pull() async {}

  Future<void> _init() async {
    await _loadIp();
    final db = AppDatabase();
    final stat = await db.getStatus();
    setState(() {
      av = stat['Validated'];
      uv = stat['Unvalidated'];
      regs = stat['New'];
    });
    if (ipConf != 'd') {
      await _auth();
    }
  }

  Future<void> getAddr() async {
    debugPrint('ppppppp58===============');
    var res = await client?.getAddresses();
    if (res != null && res.containsKey('hub')) {
      var hub = res['hub'];
      var addrList = Map<String, Map<String, dynamic>>.from(res['q']);

      // Parse expiration time from backend
      String? expiresAt = hub['expires_at'];
      if (expiresAt != null) {
        startCountdown(expiresAt);
      }

      setState(() {
        hubStat = 'c';
        addresses = addrList;
      });
    } else if (res != null && res.containsKey('error2')) {
      setState(() {
        hubStat = 'd';
      });
    } else if (res != null && res.containsKey('error')) {
      await _init();
    }
    setState(() => tryhub = false);
  }

  void disconnectionTimeCount(String expiresAt) {
    try {
      // Parse the backend timestamp
      final expiry = DateTime.parse(expiresAt);
      _timerAuth?.cancel();
      _timerAuth = Timer.periodic(const Duration(seconds: 1), (timer) {
        final diff = expiry.difference(DateTime.now());

        if (diff.isNegative) {
          timer.cancel();
          setState(() {
            disconnectionTime = "--:--:--";
            name = null;
            auth = 'd';
          });
        } else {
          final hours = diff.inHours.toString().padLeft(2, '0');
          final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
          final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');
          setState(() => disconnectionTime = "$hours:$minutes:$seconds");
        }
      });
    } catch (e) {
      debugPrint('Error parsing expiration time: $e');
    }
  }

  void startCountdown(String expiresAt) {
    try {
      // Parse the backend timestamp
      final expiry = DateTime.parse(expiresAt);
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final diff = expiry.difference(DateTime.now());

        if (diff.isNegative) {
          timer.cancel();
          setState(() {
            expirationCountDown = "00:00";
            hubStat = 'd';
          });
        } else {
          final minutes = diff.inMinutes.toString().padLeft(2, '0');
          final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');
          setState(() => expirationCountDown = "$minutes:$seconds");
        }
      });
    } catch (e) {
      debugPrint('Error parsing expiration time: $e');
    }
  }

  // void startCountdown(String expiresAt) {
  //   final expiry = DateTime.now().add(
  //     const Duration(minutes: 15),
  //   ); // force 15 mins
  //   _timer?.cancel();
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     final diff = expiry.difference(DateTime.now());

  //     if (diff.isNegative) {
  //       timer.cancel();
  //       setState(() {
  //         expirationCountDown = "00:00";
  //         hubStat = 'd';
  //       });
  //     } else {
  //       final minutes = diff.inMinutes.toString().padLeft(2, '0');
  //       final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');
  //       setState(() => expirationCountDown = "$minutes:$seconds");
  //     }
  //   });
  // }

  Future<void> _loadIp() async {
    String? ip = await storage.read(key: 'ip');
    ipTextController.text = ip ?? '';
    if (ip != null && ip.isNotEmpty) {
      client = DioClient(ip);
    } else {
      setState(() => ipConf = 'd');
    }
  }

  bool hasActib(Map<String, Map<String, dynamic>> addresses) {
    return addresses.values.any((addr) => addr['status'] == true);
  }

  Future<void> _auth() async {
    try {
      setState(() {
        loadd = true;
      });
      final res = await client?.checkAuth().timeout(
        const Duration(seconds: 15),
        onTimeout: () => Future.value({'error': 'timeout'}),
      );
      // setState(() {
      //   auth = null;
      //   serverConn = null;
      // });
      debugPrint('===============================');
      debugPrint(res.toString());
      debugPrint(client?.base);

      if (res != null && res.containsKey('data')) {
        String? expiresAt = res['data']['expires_at'];
        setState(() {
          name = res['data']['user']['skofficials']['name'];
          if (expiresAt != null) {
            disconnectionTimeCount(expiresAt);
          }

          ipConf = 'c';
          auth = 'c';
          serverConn = 'c';
        });
      } else if (res != null && res.containsKey('error')) {
        final error = res['error'];
        if (error is Map && error['message'] == 'Unauthenticated.') {
          setState(() {
            ipConf = 'c';
            auth = 'd';
            serverConn = 'c';
          });
        } else {
          setState(() {
            ipConf = 'c';
            serverConn = 'd';
          });
        }
      } else if (res != null && res.containsKey('error2')) {
        await _loadIp();
      } else {
        setState(() => showRetry = true);
      }
    } catch (e) {
      setState(() => showRetry = true);
    } finally {
      setState(() {
        loadd = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Column(children: [_buildHead(), _buildBottom()]));
  }

  Widget _buildHead() {
    return RefreshIndicator(
      onRefresh: () async {
        await _init();
      },
      child: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            // padding: EdgeInsets.only(top: 100),
            margin: EdgeInsets.all(15),
            height: 245,
            decoration: BoxDecoration(
              // color: const Color.fromARGB(0, 30, 65, 80),
              // border: Border.all(color: Color.fromARGB(255, 1, 135, 193), width: 2),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: auth == 'c' ? 1 : .5,
                          child: SizedBox(
                            width: 160,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name ?? '----',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(230, 3, 53, 180),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                ),
                                Row(
                                  children: [
                                    Text('Disconnect in: '),
                                    Text(
                                      disconnectionTime ?? '--:--:--',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (loadd) return;
                            if (ipConf == 'd') widget.chtp();
                            if (serverConn == 'd') {
                              await _init();
                              return;
                            }
                            if (auth == 'c') {
                              try {
                                await client?.logoutOfficials();
                                setState(() {
                                  auth = 'd';
                                });
                              } catch (e) {
                                //
                                setState(() {
                                  auth = null;
                                  serverConn = 'd';
                                });
                              }
                              return;
                            }
                            if (!(auth == 'd' && serverConn == 'c')) return;
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, setModalState) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        top: 16,
                                        bottom:
                                            MediaQuery.of(
                                              context,
                                            ).viewInsets.bottom,
                                      ),
                                      child: SingleChildScrollView(
                                        child: LoginForm(mchange: mchange),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          onTapDown: (_) {
                            if (serverConn == null && auth == null) return;
                            setState(() => hob = "f3");
                          },
                          onTapCancel: () {
                            setState(() => hob = null);
                          },
                          onTapUp: (_) {
                            setState(() => hob = null);
                          },
                          child: Container(
                            width: 150,
                            padding: EdgeInsets.only(
                              bottom: 10,
                              left: 7,
                              top: 10,
                              right: 10,
                            ),
                            // Color.fromARGB(255, 2, 144, 140
                            decoration: BoxDecoration(
                              color:
                                  loadd == true
                                      ? Color.fromARGB(162, 2, 23, 77)
                                      : hob == "f3"
                                      ? Color.fromARGB(162, 2, 23, 77)
                                      : Color.fromARGB(230, 2, 23, 77),
                              border: Border.all(
                                color: Color.fromARGB(255, 0, 55, 194),
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  loadd
                                      ? Icons.safety_check_rounded
                                      : ipConf == 'd'
                                      ? Icons.settings
                                      : auth == 'c'
                                      ? Icons.power_off
                                      : serverConn == 'd'
                                      ? Icons.refresh
                                      : auth == 'd'
                                      ? Icons.fingerprint
                                      : Icons.safety_check_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                Text(
                                  loadd
                                      ? ' Checking......'
                                      : ipConf == 'd'
                                      ? ' Configure IP'
                                      : auth == 'c'
                                      ? ' Disconnect'
                                      : serverConn == 'd'
                                      ? ' Reconnect'
                                      : auth == 'd'
                                      ? ' Authenticate'
                                      : ' Checking......',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Opacity(
                          opacity:
                              (auth == 'c' && serverConn == 'c') &&
                                      regs > 0 &&
                                      req == null
                                  ? 1
                                  : .5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,

                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (req != null || regs == 0) {
                                    return;
                                  }
                                  final db = AppDatabase();

                                  setState(() {
                                    hob = "f1";
                                    req = 'f1';
                                  });
                                  final youthBulk = await db.migrate();
                                  final resMigrateRegs = await client
                                      ?.migrateData(youthBulk, true);
                                  setState(() {
                                    hob = null;
                                    req = null;
                                  });
                                  if (mounted) {
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.white,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (context, setModalState) {
                                            return displayUpload(
                                              true,
                                              resMigrateRegs,
                                            );
                                          },
                                        );
                                      },
                                    );
                                  }
                                },
                                onTapDown: (_) {
                                  if (req != null) {
                                    return;
                                  }
                                  if (!(auth == 'c' && serverConn == 'c'))
                                    return;
                                  setState(() => hob = "f1");
                                },
                                onTapCancel: () {
                                  setState(() => hob = null);
                                },
                                onTapUp: (_) {
                                  if (req != null) {
                                    return;
                                  }
                                  setState(() => hob = null);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 18,
                                  ),
                                  width: 160,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color:
                                        hob == "f1" || req != null || regs == 0
                                            ? Color.fromARGB(161, 2, 52, 74)
                                            : Color.fromARGB(217, 2, 52, 74),
                                    border: Border.all(
                                      color: Color.fromARGB(255, 0, 143, 204),
                                      width: 1.2,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(0),
                                      bottomLeft: Radius.circular(0),
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Positioned(
                                        left: 1,
                                        top: req == 'f1' ? 10 : 1,
                                        child: Icon(
                                          Icons.supervised_user_circle_sharp,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),

                                      Text(
                                        req == 'f1'
                                            ? 'Uploading...'
                                            : 'Upload the registered data',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 85,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(135, 48, 48, 48),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color.fromARGB(255, 0, 143, 204),
                                      width: 1.2,
                                    ),
                                    right: BorderSide(
                                      color: Color.fromARGB(255, 0, 143, 204),
                                      width: 1.2,
                                    ),
                                    left: BorderSide(
                                      color: Color.fromARGB(255, 0, 143, 204),
                                      width: 1.2,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(0),
                                    bottomLeft: Radius.circular(60),
                                    topLeft: Radius.circular(0),
                                    topRight: Radius.circular(0),
                                  ),
                                ),
                                child: Text(
                                  loadd ? '----' : regs.toString(),
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Opacity(
                          opacity:
                              (auth == 'c' && serverConn == 'c') &&
                                      av > 0 &&
                                      req == null
                                  ? 1
                                  : .5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,

                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (req != null || av < 1) {
                                    return;
                                  }
                                  final db = AppDatabase();

                                  setState(() {
                                    hob = "f2";
                                    req = 'f2';
                                  });
                                  final youthBulk = await db.validate();
                                  final resMigrateVal = await client
                                      ?.migrateData(youthBulk, false);

                                  setState(() {
                                    hob = null;
                                    req = null;
                                  });
                                  if (mounted) {
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.white,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (context, setModalState) {
                                            return displayUpload(
                                              false,
                                              resMigrateVal,
                                            );
                                          },
                                        );
                                      },
                                    );
                                  }
                                },
                                onTapDown: (_) {
                                  if (req != null) {
                                    return;
                                  }
                                  if (!(auth == 'c' && serverConn == 'c'))
                                    return;
                                  setState(() => hob = "f2");
                                },
                                onTapCancel: () {
                                  setState(() => hob = null);
                                },
                                onTapUp: (_) {
                                  if (req != null) {
                                    return;
                                  }
                                  setState(() => hob = null);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 18,
                                  ),
                                  width: 160,
                                  height: 80,
                                  // Color.fromARGB(255, 2, 144, 140
                                  decoration: BoxDecoration(
                                    color:
                                        hob == "f2" || req != null || av == 0
                                            ? Color.fromARGB(161, 2, 77, 75)
                                            : Color.fromARGB(227, 2, 77, 74),
                                    border: Border.all(
                                      color: Color.fromARGB(255, 2, 144, 140),
                                      width: 1.2,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(0),
                                      bottomLeft: Radius.circular(0),
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),

                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Positioned(
                                        left: 1,
                                        top: req == 'f2' ? 10 : 1,
                                        child: Icon(
                                          Icons.verified_user_sharp,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        req == 'f2'
                                            ? 'Uploading...'
                                            : 'Upload the validated data',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 85,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(135, 48, 48, 48),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color.fromARGB(255, 0, 187, 180),
                                      width: 1.2,
                                    ),
                                    left: BorderSide(
                                      color: Color.fromARGB(255, 0, 187, 180),
                                      width: 1.2,
                                    ),
                                    right: BorderSide(
                                      color: Color.fromARGB(255, 0, 187, 180),
                                      width: 1.2,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(60),
                                    bottomLeft: Radius.circular(10),
                                    topLeft: Radius.circular(0),
                                    topRight: Radius.circular(0),
                                  ),
                                ),
                                child: Text(
                                  loadd ? '----' : '$av/$uv',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 97,
                    width: 135,
                    padding: EdgeInsets.only(
                      bottom: 10,
                      left: 7,
                      top: 10,
                      right: 10,
                    ),
                    // Color.fromARGB(255, 2, 144, 140
                    decoration: BoxDecoration(
                      color: Color.fromARGB(155, 61, 61, 61),
                      border: Border.all(
                        color: Color.fromARGB(255, 55, 55, 55),
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),

                    child: Column(
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 12,
                              color:
                                  ipConf == 'c'
                                      ? Colors.green
                                      : ipConf == 'd'
                                      ? Colors.red
                                      : Colors.amber,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'IP configuration',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 12,
                              color:
                                  serverConn == 'c'
                                      ? Colors.green
                                      : serverConn == 'd'
                                      ? Colors.red
                                      : Colors.amber,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Server connection',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 12,
                              color:
                                  auth == 'c'
                                      ? Colors.green
                                      : auth == 'd'
                                      ? Colors.red
                                      : Colors.amber,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Authenticated',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
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
    );
  }

  Widget displayUpload(bool nw, Map<String, dynamic>? data) {
    String? ex, regis, fail, val, nf, uvv;

    debugPrint('loggggggg.......');
    debugPrint(data.toString());
    if (data?['data'] != null && nw) {
      ex = (data?['data']['ex'] as List<dynamic>).length.toString();
      regis = (data?['data']['regs'] as List<dynamic>).length.toString();
    } else {
      ex = '0';
      regis = '0';
    }
    if (data?['data'] != null && !nw) {
      fail = (data?['data']['fail'] as List<dynamic>).length.toString();
      val = (data?['data']['val'] as List<dynamic>).length.toString();
      nf = (data?['data']['nf'] as List<dynamic>).length.toString();
      uvv = (data?['data']['uv'] as List<dynamic>).length.toString();
    } else {
      fail = '0';
      val = '0';
      nf = '0';
      uvv = '0';
    }
    String response = 'Success';
    if (data != null && data.containsKey('error1')) {
      response = 'Failed';
    } else if (data != null && data.containsKey('error2')) {
      response = 'Server error';
    }

    return Container(
      padding: EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        color: Color.fromARGB(161, 2, 52, 74),
        borderRadius: BorderRadius.circular(27),
      ),
      height: nw ? 380 : 450,
      // width: 320,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: -32,
            left: -15,
            child: Transform.rotate(
              angle: -62,
              child: Container(
                padding: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color:
                      nw
                          ? Color.fromARGB(255, 244, 158, 54)
                          : Color.fromARGB(255, 54, 244, 190),
                  borderRadius: BorderRadius.only(),
                ),
                height: 80,
                width: 50,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.only(bottom: 15),

            decoration: BoxDecoration(
              color: Color.fromARGB(82, 180, 180, 180),
              borderRadius: BorderRadius.circular(27),
            ),
            height: 7,
            width: 150,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                nw ? 'Upload Newly Registered' : 'Upload Validated',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                response,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color:
                      response == 'Success'
                          ? Color.fromARGB(255, 54, 244, 190)
                          : Colors.red,
                ),
              ),
              SizedBox(height: 15),
              ...List.generate(nw ? 2 : 5, (i) {
                return Column(
                  children: [
                    !nw
                        ? Flex(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          direction: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color:
                                        i < 2 || i == 4
                                            ? Colors.red
                                            : i == 2
                                            ? Color.fromARGB(0, 54, 244, 190)
                                            : Color.fromARGB(255, 54, 244, 190),
                                  ),
                                ),
                                SizedBox(width: 5),
                                SizedBox(
                                  width: 80,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        i == 2
                                            ? 'Found As'
                                            : i == 0
                                            ? fail.toString()
                                            : i == 1
                                            ? nf.toString()
                                            : i == 3
                                            ? val.toString()
                                            : uvv.toString(),
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      // Second widget
                                      if (i == 2)
                                        SizedBox.shrink()
                                      else
                                        Text(
                                          i == 0
                                              ? 'Failed'
                                              : i == 1
                                              ? 'Not found'
                                              : i == 3
                                              ? 'Validated'
                                              : i == 4
                                              ? 'Unvalidated'
                                              : '',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            i == 2
                                ? SizedBox(width: 50)
                                : Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      child: Image.asset(
                                        'assets/images/ar.png',
                                      ),
                                    ),
                                  ],
                                ),
                            i == 2
                                ? SizedBox(width: 65)
                                : Row(
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        textAlign: TextAlign.end,
                                        i == 0 || i == 3
                                            ? 'Skipped'
                                            : 'Validated',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      child: IconButton(
                                        color: Colors.red,
                                        alignment: Alignment.centerLeft,
                                        icon: Icon(
                                          Icons.delete_rounded,
                                          color:
                                              i == 0 && fail.toString() == '0'
                                                  ? Color.fromARGB(
                                                    114,
                                                    142,
                                                    36,
                                                    36,
                                                  )
                                                  : i == 1 &&
                                                      nf.toString() == '0'
                                                  ? Color.fromARGB(
                                                    114,
                                                    142,
                                                    36,
                                                    36,
                                                  )
                                                  : i == 3 &&
                                                      val.toString() == '0'
                                                  ? Color.fromARGB(
                                                    114,
                                                    142,
                                                    36,
                                                    36,
                                                  )
                                                  : i == 4 &&
                                                      uvv.toString() == '0'
                                                  ? Color.fromARGB(
                                                    114,
                                                    142,
                                                    36,
                                                    36,
                                                  )
                                                  : Color.fromARGB(
                                                    255,
                                                    142,
                                                    36,
                                                    36,
                                                  ),
                                        ),
                                        highlightColor:
                                            /*
                                                 fail = '0';
                                                nf = '0';
                                                val = '0';
                                                uv = '0'; 
                                           */
                                            i == 0 && fail.toString() == '0'
                                                ? Colors.transparent
                                                : i == 1 && nf.toString() == '0'
                                                ? Colors.transparent
                                                : i == 3 &&
                                                    val.toString() == '0'
                                                ? Colors.transparent
                                                : i == 4 &&
                                                    uvv.toString() == '0'
                                                ? Colors.transparent
                                                : const Color.fromARGB(
                                                  116,
                                                  244,
                                                  67,
                                                  54,
                                                ),
                                        onPressed: () async {
                                          if (i == 0 &&
                                              fail.toString() == '0') {
                                            return;
                                          }
                                          if (i == 1 && nf.toString() == '0') {
                                            return;
                                          }
                                          if (i == 3 && val.toString() == '0') {
                                            return;
                                          }
                                          if (i == 4 && uvv.toString() == '0') {
                                            return;
                                          }
                                          String msg = 'Do you want to delete ';
                                          String f = fail.toString(),
                                              u = uvv.toString(),
                                              v = val.toString(),
                                              n = nf.toString();
                                          msg +=
                                              i == 0
                                                  ? 'the $f failed data?'
                                                  : i == 1
                                                  ? 'the $n not found data?'
                                                  : i == 3
                                                  ? 'the $v validated data?'
                                                  : 'the $u unvalidated data?';
                                          List<dynamic> toDel =
                                              i == 0
                                                  ? data!['data']['fail']
                                                  : i == 1
                                                  ? data!['data']['nf']
                                                  : i == 3
                                                  ? data!['data']['val']
                                                  : i == 4
                                                  ? data!['data']['uv']
                                                  : [];
                                          final del = await showDialog<bool>(
                                            context: context,
                                            builder:
                                                (context) => AlertDialog(
                                                  title: const Text('Delete'),
                                                  content: Text(msg),
                                                  actions: [
                                                    TextButton(
                                                      onPressed:
                                                          () => Navigator.of(
                                                            context,
                                                          ).pop(false),
                                                      child: const Text('No'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(
                                                          context,
                                                        ).pop(true);
                                                      },
                                                      child: const Text('Yes'),
                                                    ),
                                                  ],
                                                ),
                                          );
                                          if (del == true) {
                                            //
                                            if (toDel.isEmpty) {
                                              return;
                                            }
                                            final db = AppDatabase();
                                            bool s = false;
                                            try {
                                              await db.deleteBulkYouthUsers(
                                                toDel
                                                    .map((e) => e as int)
                                                    .toList(),
                                              );
                                              s = true;
                                              setState(() {
                                                if (i == 0) {
                                                  fail = '0';
                                                } else if (i == 1) {
                                                  nf = '0';
                                                } else if (i == 3) {
                                                  val = '0';
                                                  av = 0;
                                                } else if (i == 4) {
                                                  uvv = '0';
                                                  uv = 0;
                                                }
                                              });
                                              
                                            } catch (e) {
                                              debugPrint(e.toString());
                                              s = false;
                                            }
                                            if (mounted) {
                                              await showDialog<bool>(
                                                context: context,
                                                builder:
                                                    (context) => AlertDialog(
                                                      title: Text(
                                                        s
                                                            ? 'Suceess'
                                                            : 'Failed',
                                                      ),
                                                      content: Text(
                                                        s
                                                            ? 'Deleted sucessfully'
                                                            : 'Failed to delete',
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed:
                                                              () =>
                                                                  Navigator.of(
                                                                    context,
                                                                  ).pop(true),
                                                          child: const Text(
                                                            'Done',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                          ],
                        )
                        : Flex(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          direction: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color:
                                        i == 0
                                            ? Color.fromARGB(255, 54, 244, 190)
                                            : Color.fromARGB(255, 28, 2, 171),
                                  ),
                                ),
                                SizedBox(width: 5),
                                SizedBox(
                                  width: 80,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        i == 0
                                            ? ex.toString()
                                            : regis.toString(),
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      // Second widget
                                      if (i == 0)
                                        const Text(
                                          'Exist',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        )
                                      else
                                        Text(
                                          'New Data',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: Image.asset('assets/images/ar.png'),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    textAlign: TextAlign.end,
                                    i == 0 ? 'Skipped' : 'Registered',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: IconButton(
                                    color: Colors.red,
                                    alignment: Alignment.centerLeft,
                                    icon: Icon(
                                      Icons.delete_rounded,
                                      color:
                                          i == 0 && ex.toString() == '0'
                                              ? Color.fromARGB(114, 142, 36, 36)
                                              : i == 1 &&
                                                  regis.toString() == '0'
                                              ? Color.fromARGB(114, 142, 36, 36)
                                              : Color.fromARGB(
                                                255,
                                                142,
                                                36,
                                                36,
                                              ),
                                    ),
                                    highlightColor:
                                        i == 0 && ex.toString() == '0'
                                            ? Colors.transparent
                                            : i == 1 && regis.toString() == '0'
                                            ? Colors.transparent
                                            : const Color.fromARGB(
                                              116,
                                              244,
                                              67,
                                              54,
                                            ),
                                    onPressed: () async {
                                      if (i == 0 && ex.toString() == '0') {
                                        return;
                                      }
                                      if (i == 1 && regis.toString() == '0') {
                                        return;
                                      }
                                      String msg = 'Do you want to delete ';
                                      String e = ex.toString(),
                                          r = regis.toString();
                                      msg +=
                                          i == 0
                                              ? 'the $e already existed data?'
                                              : 'the $r newly inserted data?';
                                      final del = await showDialog<bool>(
                                        context: context,
                                        builder:
                                            (context) => AlertDialog(
                                              title: const Text('Delete'),
                                              content: Text(msg),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.of(
                                                        context,
                                                      ).pop(false),
                                                  child: const Text('No'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.of(
                                                      context,
                                                    ).pop(true);
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                              ],
                                            ),
                                      );
                                      if (del == true) {
                                        //
                                        if (i == 0 && ex.toString() == '0') {
                                          return;
                                        }
                                        if (i == 1 && regis.toString() == '0') {
                                          return;
                                        }
                                        List<dynamic> toDel =
                                            i == 0
                                                ? data!['data']['ex']
                                                : i == 1
                                                ? data!['data']['regs']
                                                : [];
                                        if (toDel.isEmpty) {
                                          return;
                                        }
                                        final db = AppDatabase();
                                        bool s = false;
                                        try {
                                          await db.deleteBulkYouthUsers(
                                            toDel.map((e) => e as int).toList(),
                                          );
                                          s = true;
                                          setState(() {
                                            if (i == 0) {
                                              regs -= int.parse(ex ?? '0');
                                              ex = '0';
                                            } else if (i == 1) {
                                              regs -= int.parse(regis ?? '0');
                                              regis = '0';
                                            }
                                          });
                                        } catch (e) {
                                          s = false;
                                        }
                                        if (mounted) {
                                          await showDialog<bool>(
                                            context: context,
                                            builder:
                                                (context) => AlertDialog(
                                                  title: Text(
                                                    s ? 'Suceess' : 'Failed',
                                                  ),
                                                  content: Text(
                                                    s
                                                        ? 'Deleted sucessfully'
                                                        : 'Failed to delete',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed:
                                                          () => Navigator.of(
                                                            context,
                                                          ).pop(true),
                                                      child: const Text('Done'),
                                                    ),
                                                  ],
                                                ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                    SizedBox(height: 7),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget displayDownload(Map<String, dynamic>? resdl) {
    return Container(
      padding: EdgeInsets.only(bottom: 80, top: 20),
      decoration: BoxDecoration(
        color: Color.fromARGB(161, 2, 52, 74),
        borderRadius: BorderRadius.circular(27),
      ),
      height: 504,
      // width: 320,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 15),

            decoration: BoxDecoration(
              color: Color.fromARGB(82, 180, 180, 180),
              borderRadius: BorderRadius.circular(27),
            ),
            height: 7,
            width: 150,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                reqType == 'dl'
                    ? 'Downloaded Results'
                    : reqType == 'upr'
                    ? 'Uploaded Newly Registered Results'
                    : 'Uploaded Validated Results',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Success',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 54, 244, 190),
                ),
              ),
              SizedBox(height: 15),
              ...List.generate(5, (i) {
                return Column(
                  children: [
                    Flex(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      direction: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color:
                                    i == 1
                                        ? const Color.fromARGB(0, 51, 199, 85)
                                        : i == 2
                                        ? Colors.red
                                        : i == 3
                                        ? Color.fromARGB(255, 54, 244, 190)
                                        : i == 4
                                        ? Color.fromARGB(255, 244, 158, 54)
                                        : Color.fromARGB(255, 28, 2, 171),
                              ),
                            ),
                            SizedBox(width: 5),
                            SizedBox(
                              width: 80,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    i == 1
                                        ? 'Found As'
                                        : resdl == null
                                        ? '0'
                                        : i == 0
                                        ? resdl['new'].toString()
                                        : i == 2
                                        ? resdl['uv'].toString()
                                        : i == 3
                                        ? resdl['v'].toString()
                                        : resdl['n'].toString(),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  // Second widget
                                  if (i == 0)
                                    const Text(
                                      'New Data',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    )
                                  else if (i == 1)
                                    const SizedBox.shrink()
                                  else
                                    Text(
                                      i == 2
                                          ? 'Unvalidated'
                                          : i == 3
                                          ? 'Validated'
                                          : 'Newly regs.',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        i == 1
                            ? SizedBox(width: 50)
                            : Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: Image.asset('assets/images/ar.png'),
                                ),
                              ],
                            ),
                        i == 1
                            ? SizedBox(width: 65)
                            : SizedBox(
                              width: 80,
                              child: Text(
                                textAlign: TextAlign.end,
                                i == 0
                                    ? 'Unvalidated'
                                    : i == 2
                                    ? 'Overwritten'
                                    : i == 3
                                    ? 'Skipped'
                                    : 'Validated',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                      ],
                    ),
                    SizedBox(height: 7),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return Expanded(
      flex: 1,
      child: Opacity(
        opacity: (auth == 'c' && serverConn == 'c') ? 1 : .5,
        child:
            auth == 'c' && serverConn == 'c'
                ? hubStat == 'c'
                    ?
                    // Center(
                    //   child: Wrap(
                    //     direction: Axis.horizontal,
                    //     alignment: WrapAlignment.center,
                    //     crossAxisAlignment: WrapCrossAlignment.center,
                    //     spacing: 12,
                    //     children: [
                    //       SizedBox(
                    //         width: 18,
                    //         height: 18,
                    //         child: CircularProgressIndicator(
                    //           strokeWidth: 2,
                    //           color: const Color.fromARGB(255, 0, 0, 0),
                    //         ),
                    //       ),
                    //       Text(
                    //         'Checking hub...',
                    //         style: TextStyle(
                    //           color: Colors.black,
                    //           fontSize: 15,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // )
                    // : hubStat == 'r' ?
                    // main content picking of addresses
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // 🔹 Header row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.power, color: Colors.black),
                                  SizedBox(width: 5),
                                  Text(
                                    'Server hub',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.timer, color: Colors.black),
                                  SizedBox(width: 5),
                                  Text(
                                    'Closing time: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    expirationCountDown,
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 144, 0, 0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 15),

                          SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              runAlignment: WrapAlignment.center,
                              spacing: 10,
                              runSpacing: 5,
                              children:
                                  addresses.keys.map((address) {
                                    bool status = addresses[address]?['status'];
                                    return GestureDetector(
                                      onTap: () {
                                        if (!(auth == 'c' &&
                                            serverConn == 'c')) {
                                          return;
                                        }
                                        setState(() {
                                          addresses[address]?['status'] =
                                              !status;
                                        });
                                      },
                                      child: Opacity(
                                        opacity:
                                            status == true
                                                ? 1
                                                : !hasActib(addresses)
                                                ? 1
                                                : hob == 'pd'
                                                ? .4
                                                : hob == null
                                                ? 1
                                                : 1,
                                        child: Container(
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color:
                                                status == true
                                                    ? Color.fromARGB(
                                                      149,
                                                      12,
                                                      102,
                                                      140,
                                                    )
                                                    : Color.fromARGB(
                                                      94,
                                                      45,
                                                      98,
                                                      121,
                                                    ),
                                            border: Border.all(
                                              color: Color.fromARGB(
                                                102,
                                                16,
                                                35,
                                                43,
                                              ),
                                              width: 1.2,
                                            ),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(2),
                                              bottomRight: Radius.circular(12),
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.circular(
                                                status == true ? 2 : 12,
                                              ),
                                            ),
                                          ),
                                          width: 158,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Checkbox(
                                                value: status,
                                                onChanged: (val) {
                                                  if (!(auth == 'c' &&
                                                      serverConn == 'c')) {
                                                    return;
                                                  }

                                                  setState(() {
                                                    addresses[address]?['status'] =
                                                        val;
                                                  });
                                                },
                                              ),
                                              Flexible(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      address,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    SizedBox(height: 1),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(
                                                          Icons.group,
                                                          color:
                                                              const Color.fromARGB(
                                                                255,
                                                                12,
                                                                69,
                                                                117,
                                                              ),
                                                          size: 15,
                                                        ),
                                                        SizedBox(width: 1),
                                                        Text(
                                                          (addresses[address]?['value'])
                                                              .toString(),
                                                          style: TextStyle(
                                                            color:
                                                                const Color.fromARGB(
                                                                  255,
                                                                  12,
                                                                  69,
                                                                  117,
                                                                ),
                                                            fontSize: 11,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () async {
                              if (tryhub) return;
                              if (hasActib(addresses)) {
                                try {
                                  debugPrint('Downloading...');
                                  debugPrint('addresses: $addresses');
                                  setState(() => tryhub = true);
                                  final reshub = await client?.getDataFromHub(
                                    addresses,
                                  );
                                  if (mounted) {
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (context, setModalState) {
                                            return displayDownload(reshub);
                                          },
                                        );
                                      },
                                    );
                                  }
                                  setState(() {
                                    tryhub = false;
                                    uv += int.parse(reshub?['new']);
                                    av += int.parse(reshub?['n']);
                                  });
                                } catch (e) {
                                  debugPrint('error: $e');
                                  /*
                                   : i == 0
                                        ? resdl['new'].toString()
                                        : i == 2
                                        ? resdl['uv'].toString()
                                        : i == 3
                                        ? resdl['v'].toString()
                                        : resdl['n'].toString(),
                                  */
                                }
                              }
                            },
                            onTapDown: (_) {
                              if (!(auth == 'c' && serverConn == 'c') &&
                                  tryhub) {
                                return;
                              }
                              setState(() => hob = "pd");
                            },
                            onTapCancel: () {
                              setState(() => hob = null);
                            },
                            onTapUp: (_) {
                              setState(() => hob = null);
                            },
                            child: Container(
                              width:
                                  tryhub
                                      ? 180
                                      : hasActib(addresses)
                                      ? 150
                                      : 180,
                              decoration: BoxDecoration(
                                color:
                                    (tryhub || !hasActib(addresses))
                                        ? Color.fromARGB(81, 32, 75, 128)
                                        : hob == 'pd'
                                        ? Color.fromARGB(81, 32, 75, 128)
                                        : Color.fromARGB(153, 32, 75, 128),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 0, 59, 130),
                                  width: 1.2,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 12,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  !hasActib(addresses)
                                      ? SizedBox.shrink()
                                      : Icon(
                                        Icons.cloud_download_rounded,
                                        color: const Color.fromARGB(
                                          255,
                                          50,
                                          50,
                                          50,
                                        ),
                                        size: 15,
                                      ),
                                  SizedBox(width: 2),
                                  Text(
                                    tryhub
                                        ? 'Downloading...'
                                        : !hasActib(addresses)
                                        ? 'Select addresses to download'
                                        : 'Download',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        50,
                                        50,
                                        50,
                                      ),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    : hubStat == 'd'
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.close,
                              size: 20,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                            SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Server Hub is closed',
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.start,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        GestureDetector(
                          onTap: () async {
                            if (tryhub) {
                              return;
                            }
                            if (serverConn == 'c' && ipConf == 'c') {
                              setState(() => tryhub = true);
                              await getAddr();
                            }
                          },
                          onTapDown: (_) {
                            setState(() => hob = "rtry");
                          },
                          onTapCancel: () {
                            setState(() => hob = null);
                          },
                          onTapUp: (_) {
                            setState(() => hob = null);
                          },
                          child: Container(
                            width: tryhub ? 115 : 100,
                            decoration: BoxDecoration(
                              color:
                                  tryhub
                                      ? Color.fromARGB(81, 32, 75, 128)
                                      : hob == 'rtry'
                                      ? Color.fromARGB(81, 32, 75, 128)
                                      : Color.fromARGB(153, 32, 75, 128),
                              border: Border.all(
                                color: const Color.fromARGB(255, 0, 59, 130),
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 9,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.refresh,
                                  size: 20,
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  tryhub ? 'Retrying....' : 'Retry',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      255,
                                      255,
                                      255,
                                    ),
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                    : Center(
                      child: GestureDetector(
                        onTap: () async {
                          if (tryhub) {
                            return;
                          }
                          if (serverConn == 'c' && ipConf == 'c') {
                            setState(() => tryhub = true);
                            await getAddr();
                          }
                        },
                        onTapDown: (_) {
                          if (!(auth == 'c' && serverConn == 'c')) return;
                          setState(() => hob = "f4");
                        },
                        onTapCancel: () {
                          setState(() => hob = null);
                        },
                        onTapUp: (_) {
                          setState(() => hob = null);
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          width: 210,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color:
                                tryhub
                                    ? Color.fromARGB(162, 2, 23, 77)
                                    : hob != "f4"
                                    ? Color.fromARGB(230, 2, 23, 77)
                                    : Color.fromARGB(162, 2, 23, 77),
                            border: Border.all(
                              color: Color.fromARGB(255, 0, 72, 255),
                              width: hob == "f4" ? 1.6 : 1.2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.connect_without_contact_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Flexible(
                                child: GestureDetector(
                                  child: Text(
                                    'Connect to server hub',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.start,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                : Center(
                  child: Wrap(
                    direction: Axis.vertical,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(Icons.lock_person_outlined, size: 80),
                      Text(
                        'Unauthorized',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}

/*
            GestureDetector(
              onTapDown: (_) {
                            if (!(auth == 'c' && serverConn == 'c')) return;
                setState(() => hob = "f4");
              },
              onTapCancel: () {
                setState(() => hob = null);
              },
              onTapUp: (_) {
                setState(() => hob = null);
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                width: 155,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color:
                      hob != "f4"
                          ? Color.fromARGB(230, 2, 23, 77)
                          : Color.fromARGB(162, 2, 23, 77),
                  border: Border.all(
                    color: Color.fromARGB(255, 0, 55, 194),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      auth == 'c'
                          ? Icons.power_off
                          : auth == 'd'
                          ? Icons.fingerprint
                          : serverConn == 'd'
                          ? Icons.refresh
                          : Icons.connect_without_contact_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Connect to serverr hub',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.start,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              ),
            ),
*/
