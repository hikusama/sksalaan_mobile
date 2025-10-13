import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skyouthprofiling/service/dio_client.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback mchange;
  const LoginForm({super.key, required this.mchange});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  DioClient? client;
  late TextEditingController ipTextController;
  String? hob;
  final storage = FlutterSecureStorage();
  final formKey = GlobalKey<FormState>();
  final unController = TextEditingController();
  bool loggingin = false;
  Map<String, String?> errors = {'email': null, 'password': null, 'auth': null};
  final pwController = TextEditingController();
  void clearErrors() {
    setState(() {
      errors['email'] = null;
      errors['password'] = null;
      errors['auth'] = null;
    });
  }

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
    } else {
      // setState(() => ipConf = 'd');
    }
  }

  // Future<void> setToken(String token) async {
  //   await storage.write(key: 'token', value: token.trim());
  // }

  String? extractError(dynamic value) {
    if (value is List && value.isNotEmpty) return value.first.toString();
    if (value is String) return value;
    return null;
  }

  Future<void> handleLogin() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid || loggingin) return;
    setState(() => loggingin = true);

    try {
      final res = await client?.login(
        unController.text.trim(),
        pwController.text.trim(),
      );
      debugPrint("res:");
      debugPrint(res.toString());

      if (res == null) {
        setState(() => errors['auth'] = "No response from server");
        return;
      }

      if (res.containsKey('data')) {
        final token = res['data']['token'];
        debugPrint("token: ");
        debugPrint(token);
        widget.mchange();
        if (mounted) {
          Navigator.pop(context);
        }
      } else if (res['error'] is Map<String, dynamic>) {
        final errorMap = res['error']['errors'] as Map<String, dynamic>?;
        setState(() {
          errors['auth'] = extractError(errorMap?['auth']);
          errors['email'] = extractError(errorMap?['email']);
          errors['password'] = extractError(errorMap?['password']);
        });
        formKey.currentState!.validate();
      } else if (res.containsKey('error3')) {
        debugPrint("error3 gointtomount: ");
        if (mounted) {
          widget.mchange();
          debugPrint("error3 mounted: ");
          Navigator.pop(context);
        }
      }
    } catch (e) {
      debugPrint("Login error: $e");
      setState(() => errors['auth'] = "Login failed. Please try again.");
    } finally {
      setState(() => loggingin = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      padding: const EdgeInsets.only(left: 85, right: 85, top: 35),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            SizedBox(height: 100, child: Image.asset('assets/images/logo.png')),
            const Text(
              'Login',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextFormField(
              style: const TextStyle(fontSize: 12, color: Colors.black),
              controller: unController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: errors['email'],
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? 'Please input your Email'
                          : null,
            ),
            const SizedBox(height: 15),
            TextFormField(
              style: const TextStyle(fontSize: 12, color: Colors.black),
              controller: pwController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: errors['password'],
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? 'Please input your Password'
                          : null,
            ),
            const SizedBox(height: 15),
            if (errors['auth']?.isNotEmpty ?? false)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  errors['auth']!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 15),
            GestureDetector(
              onTapDown: (_) {
                if (!loggingin) {
                  setState(() => hob = "lg");
                }
              },
              onTapCancel: () {
                setState(() => hob = null);
              },
              onTap: () async {
                debugPrint(",,,,,,,,,,,,,,,,,,,,,,,,,,,,");
                setState(() => hob = null);
                if (!loggingin) {
                  await handleLogin();
                }
              },

              child: Container(
                padding: EdgeInsets.only(
                  bottom: 10,
                  left: 25,
                  top: 10,
                  right: 25,
                ),
                decoration: BoxDecoration(
                  color:
                      loggingin || hob == 'lg'
                          ? const Color.fromARGB(134, 15, 97, 130)
                          : const Color.fromRGBO(20, 126, 169, 1),
                  border: Border.all(
                    color: const Color.fromARGB(255, 5, 30, 51),
                    width: 1.2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child:
                    loggingin
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
