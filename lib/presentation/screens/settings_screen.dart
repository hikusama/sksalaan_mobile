import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final storage = FlutterSecureStorage();
  late TextEditingController ipTextController;
  bool _isEditOn = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    ipTextController = TextEditingController();

    _loadIp();
  }

  Future<void> _loadIp() async {
    String? ip = await storage.read(key: 'ip');
    ipTextController.text = ip ?? '';
  }

  Future<void> _setIp() async {
    await storage.write(key: 'ip', value: ipTextController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 80),
      padding: EdgeInsets.only(left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings),
              Text(
                'Settings',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text('Set the host ip.', style: TextStyle(fontSize: 15)),
          Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  flex: _isEditOn ? 2 : 3,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Host ip address',
                      labelStyle: TextStyle(fontSize: 12),
                      hintText: 'Type the host ip address',
                      border: OutlineInputBorder(),
                      isDense: true,
                      enabled: _isEditOn ? true : false,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                    ),
                    style: TextStyle(fontSize: 12, color: Colors.black),
                    controller: ipTextController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Input Host IP';
                      }
                      if (value.length > 14) {
                        return '14 characters only allowed';
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child:
                      !_isEditOn
                          ? IconButton(
                            onPressed:
                                () => setState(() {
                                  _isEditOn = true;
                                }),
                            icon: Icon(Icons.edit),
                            iconSize: 20,
                          )
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _loadIp();
                                  setState(() {
                                    _isEditOn = false;
                                  });
                                },
                                icon: Icon(Icons.close),
                                iconSize: 20,
                              ),
                              IconButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _setIp();
                                    setState(() {
                                      _isEditOn = false;
                                    });
                                  }
                                },
                                icon: Icon(Icons.check),
                                iconSize: 20,
                              ),
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
