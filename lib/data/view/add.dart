import 'package:flutter/material.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  List<String> steps = ["Basic", "Personal", "Educ", "Civic", "Finish"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(size: 20, Icons.arrow_back, color: Colors.black),
            SizedBox(width: 20),
            Text(
              'Inserting Youth',
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(6, 0, 6, 0),
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: stepTab(),
            ),
          ),
        ],
      ),
    );
  }



































  List<Widget> stepTab() => [
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: Colors.grey,
          child: Text('1', style: TextStyle(fontSize: 11)),
        ),
        Text(steps[0], style: TextStyle(color: Colors.black, fontSize: 11)),
      ],
    ),
    Container(height: 4, width: 25,decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(25)
    ),),


    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: Colors.grey,
          child: Text('2', style: TextStyle(fontSize: 11)),
        ),
        Text(steps[1], style: TextStyle(color: Colors.black, fontSize: 11)),
      ],
    ),
    Container(height: 4, width: 25,decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(25)
    ),),


    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: Colors.grey,
          child: Text('3', style: TextStyle(fontSize: 11)),
        ),
        Text(steps[2], style: TextStyle(color: Colors.black, fontSize: 11)),
      ],
    ),
    Container(height: 4, width: 25,decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(25)
    ),),


    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: Colors.grey,
          child: Text('4', style: TextStyle(fontSize: 11)),
        ),
        Text(steps[3], style: TextStyle(color: Colors.black, fontSize: 11)),
      ],
    ),
    Container(height: 4, width: 25,decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(25)
    ),),


    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: Colors.grey,
          child: Text('5', style: TextStyle(fontSize: 11)),
        ),
        Text(steps[4], style: TextStyle(color: Colors.black, fontSize: 11)),
      ],
    ),
  ];
}
