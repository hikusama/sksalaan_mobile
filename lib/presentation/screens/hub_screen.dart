import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skyouthprofiling/data/app_database.dart';
import 'package:skyouthprofiling/data/view/loginform.dart';
import 'package:skyouthprofiling/service/dio_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HubScreen extends StatefulWidget {
  final VoidCallback chtp;
  const HubScreen({super.key, required this.chtp});
  @override
  State<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> {
  Map<String, String?> errors = {'email': null, 'password': null, 'auth': null};
  Timer? _timer;
  String expirationCountDown = "00:00";
  String? hob;
  String? hubStat;
  String? serverConn;
  String? ipConf;
  bool loadd = false;
  bool tryhub = false;
  bool showRetry = false;
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

  void startCountdown(String expiresAt) {
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
        final minutes = diff.inMinutes.remainder(60).toString().padLeft(2, '0');
        final seconds = diff.inSeconds.remainder(60).toString().padLeft(2, '0');
        setState(() => expirationCountDown = "$minutes:$seconds");
      }
    });
  }

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

  Future<void> getAddr() async {
    debugPrint('ppppppp58===============');
    var res = await client?.getAddresses();
    if (res != null && res.containsKey('hub')) {
      var hub = res['hub'];
      var addrList = Map<String, Map<String, dynamic>>.from(res['q']);
      startCountdown(hub['expires_at']);
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

      if (res != null && res.containsKey('data')) {
        setState(() {
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
    return Container(
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
                              bottom: MediaQuery.of(context).viewInsets.bottom,
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
                    borderRadius: BorderRadius.all(Radius.circular(10)),
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
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Opacity(
                    opacity: (auth == 'c' && serverConn == 'c') ? 1 : .5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        GestureDetector(
                          onTapDown: (_) {
                            if (!(auth == 'c' && serverConn == 'c')) return;
                            setState(() => hob = "f1");
                          },
                          onTapCancel: () {
                            setState(() => hob = null);
                          },
                          onTapUp: (_) {
                            setState(() => hob = null);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 18,
                            ),
                            width: 160,
                            decoration: BoxDecoration(
                              color:
                                  hob == "f1"
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
                              children: [
                                Icon(
                                  Icons.supervised_user_circle_sharp,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Upload the registered data',
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
                    opacity: (auth == 'c' && serverConn == 'c') ? 1 : .5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        GestureDetector(
                          onTapDown: (_) {
                            if (!(auth == 'c' && serverConn == 'c')) return;
                            setState(() => hob = "f2");
                          },
                          onTapCancel: () {
                            setState(() => hob = null);
                          },
                          onTapUp: (_) {
                            setState(() => hob = null);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 18,
                            ),
                            width: 160,
                            // Color.fromARGB(255, 2, 144, 140
                            decoration: BoxDecoration(
                              color:
                                  hob == "f2"
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
                              children: [
                                Positioned(
                                  child: Icon(
                                    Icons.verified_user_sharp,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Upload the validated data',
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
                            style: TextStyle(color: Colors.white, fontSize: 15),
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
              padding: EdgeInsets.only(bottom: 10, left: 7, top: 10, right: 10),
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
                    'Statuses',
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
                        style: TextStyle(color: Colors.white, fontSize: 13),
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
                        style: TextStyle(color: Colors.white, fontSize: 13),
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
                        style: TextStyle(color: Colors.white, fontSize: 13),
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
    );
  }

  Widget _buildBottom() {
    return Expanded(
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
                                  debugPrint('Pulling...');
                                  debugPrint('addresses: $addresses');
                                  setState(() => tryhub = true);
                                  await client?.getDataFromHub(addresses);
                                } catch (e) {
                                  debugPrint('error: $e');
                                } finally {
                                  setState(() => tryhub = false);
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
                                        ? 'Pulling data...'
                                        : !hasActib(addresses)
                                        ? 'Select addresses to pull'
                                        : 'Pull data',
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
