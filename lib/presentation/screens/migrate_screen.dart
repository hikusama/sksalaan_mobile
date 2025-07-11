import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skyouthprofiling/data/view/logged_in.dart';
import 'package:skyouthprofiling/service/dio_client.dart';

class MigrateScreen extends StatefulWidget {
  const MigrateScreen({super.key});

  @override
  State<MigrateScreen> createState() => _MigrateScreenState();
}

class _MigrateScreenState extends State<MigrateScreen> {
  late TextEditingController ipTextController;
  final formKey = GlobalKey<FormState>();
  final unController = TextEditingController();
  final pwController = TextEditingController();
  int authenticated = 0;
  DioClient? client;
  final storage = FlutterSecureStorage();
  bool showRetry = false;

  @override
  void initState() {
    super.initState();
    ipTextController = TextEditingController();
    _init();
  }

  @override
  void dispose() {
    ipTextController.dispose();
    unController.dispose();
    pwController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    await _loadIp();
    await _auth();
  }

  Future<void> _loadIp() async {
    String? ip = await storage.read(key: 'ip');
    ipTextController.text = ip ?? '';
    if (ip != null && ip.isNotEmpty) {
      client = DioClient(ip);
    } else {
      _showSnackBar('Server IP not configured.');
    }
  }

  Future<void> _auth() async {
    try {
      final res = await client?.checkAuth().timeout(
        const Duration(seconds: 15),
        onTimeout: () => Future.value({'error': 'timeout'}),
      );

      if (res != null && res.containsKey('data')) {
        setState(() => authenticated = 1);
      } else if (res != null && res.containsKey('error')) {
        setState(() => authenticated = 2);
      } else {
        _showSnackBar('Server not found or unreachable.');
        setState(() {
          showRetry = true;
        });
      }
    } catch (e) {
      _showSnackBar('Server not found or unreachable.');
      setState(() {
        showRetry = true;
      });
    }
  }

  void _showSnackBar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(message)),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ],
          ),
          duration: const Duration(seconds: 10),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentView;

    if (showRetry) {
      currentView = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Server unreachable.'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showRetry = false;
                  authenticated = 0;
                });
                _auth();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else {
      switch (authenticated) {
        case 1:
          currentView = const LoggedIn();
          break;
        case 2:
          currentView = _loginForm();
          break;
        default:
          currentView = const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 0, 0, 0),
                    strokeWidth: 2,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'please wait',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
      }
    }

    return Scaffold(body: currentView);
  }

  Widget _loginForm() {
    Map<String, String?> errors = {'email': null, 'password': null};

    String? extractError(dynamic value) {
      if (value is List && value.isNotEmpty) {
        return value.first.toString();
      }
      if (value is String) {
        return value;
      }
      return null;
    }

    Future<void> setToken(String token) async {
      await storage.write(key: 'token', value: token.trim());
    }

    void clearErrors() {
      setState(() {
        errors['email'] = null;
        errors['password'] = null;
      });
    }

    Future<void> handleLogin() async {
      clearErrors();
      final isValid = formKey.currentState!.validate();
      if (!isValid) return;

      final res = await client?.login(
        unController.text.trim(),
        pwController.text.trim(),
      );

      if (res == null) return;

      if (res.containsKey('data')) {
        final token = res['data']['token'];
        await setToken(token);
        setState(() => authenticated = 1);
      } else if (res['error'] is Map<String, dynamic>) {
        final error = res['error'];
        setState(() {
          errors['email'] = extractError(error['errors']?['email']);
          errors['password'] = extractError(error['errors']?['password']);
        });
        formKey.currentState!.validate();
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 85),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100, child: Image.asset('assets/images/logo.png')),
            const Text(
              'Login',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(fontSize: 12),
                hintText: 'Type your Email address',
                border: const OutlineInputBorder(),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),
                errorText: errors['email'],
              ),
              style: const TextStyle(fontSize: 12, color: Colors.black),
              controller: unController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please input your Email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(fontSize: 12),
                hintText: 'Type your Password',
                border: const OutlineInputBorder(),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),
                errorText: errors['password'],
              ),
              style: const TextStyle(fontSize: 12, color: Colors.black),
              controller: pwController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please input your Password';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(20, 126, 169, 1),
                foregroundColor: Colors.white,
              ),
              onPressed: handleLogin,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
