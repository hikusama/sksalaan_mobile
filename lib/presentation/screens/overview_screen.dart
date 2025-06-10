import 'package:flutter/material.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(children: [_buildDashboard(), _buildContRecords()]),
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    return Container(
      height: 250,
      margin: EdgeInsets.fromLTRB(10, 5, 10, 20),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 73, 73, 73),
        borderRadius: BorderRadius.circular(12),
      ),
      // width: ,
    );
  }

  Widget _buildContRecords() {
    return Expanded(
      child: Column(
        children: [
          Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              // width: 400,
              child: Column(
                spacing: 6,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [_designRecords(), _designRecords()],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
          Expanded(
            flex: 7,
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
                  'Nakamotoasdas asdasdsa asdasd, Hikusama',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Age',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                Text('27', style: TextStyle(fontSize: 14, color: Colors.white)),
              ],
            ),
          ),
          Expanded(
            flex: 1,

            child: Column(
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
                Text(
                  'OSY',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),

          IconButton(
            color: Colors.white,
            onPressed: () => {},
            icon: Icon(Icons.more_horiz_rounded),
          ),
        ],
      ),
    );
  }

  // Widget _designRecords2() {
  //   return Container(
  //     margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
  //     padding: EdgeInsets.fromLTRB(6.5, 5, 6.5, 5),
  //     alignment: Alignment.center,
  //     decoration: BoxDecoration(
  //       color: Color.fromARGB(255, 61, 61, 61),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Row(
  //       spacing: 20,
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'Name',
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 13,
  //                 color: Colors.white,
  //               ),
  //             ),
  //             Text(
  //               'Nakamotojoko, Hikusama',
  //               style: TextStyle(fontSize: 16, color: Colors.white),
  //             ),
  //           ],
  //         ),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'Age',
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 13,
  //                 color: Colors.white,
  //               ),
  //             ),
  //             Text('13', style: TextStyle(fontSize: 16, color: Colors.white)),
  //           ],
  //         ),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'Type',
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 13,
  //                 color: Colors.white,
  //               ),
  //             ),
  //             Text('OSY', style: TextStyle(fontSize: 16, color: Colors.white)),
  //           ],
  //         ),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'Created',
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 13,
  //                 color: Colors.white,
  //               ),
  //             ),
  //             Text(
  //               'Dec 24, 2025',
  //               style: TextStyle(fontSize: 16, color: Colors.white),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
