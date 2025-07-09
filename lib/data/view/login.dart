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
  final formKey = GlobalKey<FormState>();
  final unController = TextEditingController();
  final pwController = TextEditingController();
  final storage = FlutterSecureStorage();
  final ipTextController = TextEditingController();

  int authenticated = 0;
  DioClient? client;

  Map<String, String?> errors = {
    'email': null,
    'password': null,
  };

  @override
  void initState() {
    super.initState();
    _init();
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
    }
  }

  Future<void> _auth() async {
    final res = await client?.checkAuth();
    if (res != null && res.containsKey('data')) {
      setState(() => authenticated = 1);
    } else {
      setState(() => authenticated = 2);
    }
  }

  String? extractError(dynamic value) {
    if (value is List && value.isNotEmpty) return value.first.toString();
    if (value is String) return value;
    return null;
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
      await storage.write(key: 'token', value: token.trim());

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

  @override
  Widget build(BuildContext context) {
    Widget currentView;

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
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Please wait',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
    }

    return Scaffold(body: currentView);
  }

  Widget _loginForm() {
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
              controller: unController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Type your Email address',
                border: const OutlineInputBorder(),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                errorText: errors['email'],
              ),
              style: const TextStyle(fontSize: 12, color: Colors.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please input your Email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),

            TextFormField(
              controller: pwController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Type your Password',
                border: const OutlineInputBorder(),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                errorText: errors['password'],
              ),
              style: const TextStyle(fontSize: 12, color: Colors.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please input your Password';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(20, 126, 169, 1),
                foregroundColor: Colors.white,
              ),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
