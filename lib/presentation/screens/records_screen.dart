import 'package:flutter/material.dart';
// import 'package:skyouthprofiling/service/database_helper.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  RecordsScreenState createState() => RecordsScreenState();
}

class RecordsScreenState extends State<RecordsScreen> {
  // final DatabaseService _databaseService = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          child: Column(children: [_builContLogo(), _designRecords()]),
        ),
      ),
    );
  }

  Widget _builContLogo() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Color.fromARGB(0, 11, 48, 65),
      ),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            child: Column(
              children: [
                Image.asset('assets/images/logo.png'),
                Text('SK Youth records')
              ],
            ),
          ),
          SizedBox(),

        ],
      ) ,
      // width: ,
    );
  }
  // Widget _buildRecords() {
  //   return FutureBuilder(
  //     future: _databaseService.getYouth(),
  //     builder: (context, snapshot) {
  //       return ListView.builder(
  //         itemCount: snapshot.data?.length ?? 0,
  //         itemBuilder: (context, index) {
  //           Youth youth = snapshot.data![index];
  //           return _designRecords(youth);
  //         },
  //       );
  //     },
  //   );
  // }
// Youth youth
  Widget _designRecords() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 61, 61, 61),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 175,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Incent',
                  // youth.name,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Incent',
                  // youth.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
              Text('27', style: TextStyle(fontSize: 16, color: Colors.white)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Type',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
              Text('OSY', style: TextStyle(fontSize: 16, color: Colors.white)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Created',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
              Text(
                'Dec 24, 2025',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
