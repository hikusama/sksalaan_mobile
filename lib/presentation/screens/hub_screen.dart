import 'package:flutter/material.dart';

class HubScreen extends StatefulWidget {
  const HubScreen({super.key});

  @override
  State<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Column(children: [_buildHead(), _buildBottom()]));
  }

  Widget _buildHead() {
    return Container(
      // padding: EdgeInsets.only(top: 100),
      margin: EdgeInsets.all(15),
      height: 280,
      decoration: BoxDecoration(
        color: const Color.fromARGB(139, 30, 65, 80),
        border: Border.all(color: Color.fromARGB(255, 1, 135, 193), width: 2),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          Column(
            children: [
              InkWell(
                child: Container(
                  height: 15,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(139, 30, 65, 80),
                    border: Border.all(
                      color: Color.fromARGB(255, 3, 38, 53),
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              InkWell(
                child: Container(
                  height: 15,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 3, 38, 53),
                    border: Border.all(
                      color: Color.fromARGB(255, 1, 135, 193),
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  height: 15,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 3, 38, 53),
                    border: Border.all(
                      color: Color.fromARGB(255, 1, 135, 193),
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return Expanded(child: Text("Scroll itemss"));
  }
}
