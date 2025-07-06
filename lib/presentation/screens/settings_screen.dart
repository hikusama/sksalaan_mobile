import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ipTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Set the host ip'),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'First Name',
            labelStyle: TextStyle(fontSize: 12),
            hintText: 'Enter a first name',
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          ),
          style: TextStyle(fontSize: 12, color: Colors.black),
          controller: ipTextController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the first name';
            }
            if (value.length > 20) {
              return 'Use only 20 characters';
            }
            return null;
          },
        ),
      ],
    );
  }
}
