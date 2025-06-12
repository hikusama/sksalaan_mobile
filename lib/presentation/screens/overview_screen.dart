import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skyouthprofiling/data/app_database.dart';
import 'package:skyouthprofiling/data/view/edit.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final db = DatabaseProvider.instance;

  Future<List<FullYouthProfile>> _fetchProfiles(BuildContext context) async {
    return db.getAllYouthProfiles(offset: 1,searchKeyword: '');
  }

  int clicked = 0;
  bool isDeleteSuccess = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              _buildDashboard(),
              Expanded(
                child: FutureBuilder<List<FullYouthProfile>>(
                  future: _fetchProfiles(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No records found.'));
                    }

                    final profiles = snapshot.data!;
                    return RefreshIndicator(
                      onRefresh: () async {
                        setState(
                          () {},
                        ); 
                      },
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          itemCount: profiles.length,
                          itemBuilder: (context, index) {
                            return _designRecord(profiles[index], context);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    return Container(
      height: 250,
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 73, 73, 73),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _designRecord(FullYouthProfile profile, BuildContext context) {
    final name =
        '${profile.youthInfo?.lname ?? ''}, ${profile.youthInfo?.fname ?? ''}';
    final fullname =
        '${profile.youthInfo?.lname ?? ''}, ${profile.youthInfo?.fname ?? ''} - ${profile.youthInfo?.mname ?? ''}';
    final dateString = profile.youthUser.registerAt.toString().split(' ').first;
    String date = DateFormat('MMM d, yy').format(DateTime.parse(dateString));

    final status = profile.youthUser.status;
    Color statColor = Colors.white;
    switch (status) {
      case 'Standby':
        statColor = const Color.fromARGB(255, 255, 217, 0);
        break;
      case 'Failed':
        statColor = const Color.fromARGB(255, 255, 0, 0);
        break;
      case 'Submitted':
        statColor = Colors.red;
        break;
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      padding: const EdgeInsets.fromLTRB(17, 0, 8, 0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(181, 20, 127, 169),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 2, color: Color.fromARGB(255, 19, 137, 184)),
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Positioned(
            right: 11,
            bottom: -16,
            child: Transform.rotate(
              angle: 3.25 / 6,
              child: Container(
                width: 160,
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                padding: const EdgeInsets.fromLTRB(17, 6, 8, 6),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(210, 28, 61, 74),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                      Text(status, style: TextStyle(color: statColor)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 73,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Registered',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                      Text(date, style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) {
                    switch (value) {
                      case 'see more':
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return _buildViewModal();
                          },
                        );
                        break;
                      case 'edit':
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Edit()),
                        );
                        break;
                      case 'delete':
                        clicked = 0;

                        showModalBottomSheet(
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (context, setModalState) {
                                return Container(
                                  padding: const EdgeInsets.fromLTRB(
                                    17,
                                    25,
                                    17,
                                    17,
                                  ),
                                  height: 300,
                                  width: double.infinity,
                                  child:
                                      clicked > 3
                                          ? SizedBox(
                                            height: 200,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 90,
                                                  child:
                                                      isDeleteSuccess
                                                          ? Image.asset(
                                                            'assets/images/success.png',
                                                          )
                                                          : Image.asset(
                                                            'assets/images/failed.png',
                                                          ),
                                                ),
                                                SizedBox(height: 15),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 8,
                                                      backgroundColor:
                                                          isDeleteSuccess
                                                              ? Colors.green
                                                              : Colors.red,
                                                      child: Icon(
                                                        size: 15,
                                                        isDeleteSuccess
                                                            ? Icons.check
                                                            : Icons.close,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(width: 4),
                                                    isDeleteSuccess
                                                        ? Text(
                                                          'Success....',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                          ),
                                                        )
                                                        : Text(
                                                          'Something went wrong',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),

                                                MaterialButton(
                                                  minWidth: 80,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  onPressed: () {
                                                    clicked = 0;
                                                    Navigator.pop(context);
                                                  },
                                                  color: Color.fromRGBO(
                                                    20,
                                                    126,
                                                    169,
                                                    1,
                                                  ),
                                                  child: Text(
                                                    'Done',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                          : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,

                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    fullname,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),

                                                  const SizedBox(width: 10),
                                                  Text(
                                                    date,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,

                                                children: [
                                                  Text(
                                                    'Name',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    'Date Registered',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 20),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,

                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Are you sure you want to delete?',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 19,
                                                      ),
                                                    ),
                                                    Text(
                                                      'To confirm click the button 3 times: $clicked/3',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              MaterialButton(
                                                color:
                                                    clicked < 3
                                                        ? const Color.fromARGB(
                                                          120,
                                                          244,
                                                          67,
                                                          54,
                                                        )
                                                        : Colors.red,
                                                textColor: Colors.white,
                                                onPressed: () async {
                                                  if (clicked >= 3) {
                                                    bool isGood = false;
                                                    try {
                                                      await db.deleteYouthUser(
                                                        profile
                                                            .youthUser
                                                            .youthUserId,
                                                      );
                                                      isGood = true;
                                                    } catch (e) {
                                                      isGood = false;
                                                    }
                                                    if (isGood) {
                                                      isDeleteSuccess = true;
                                                      setState(() {});
                                                    } else {
                                                      isDeleteSuccess = false;
                                                    }
                                                  }
                                                  setModalState(() {
                                                    clicked++;
                                                  });
                                                },
                                                child: Text(
                                                  clicked < 3
                                                      ? 'Click'
                                                      : 'Delete',
                                                ),
                                              ),
                                              const SizedBox(height: 25),
                                            ],
                                          ),
                                );
                              },
                            );
                          },
                        );

                        break;
                    }
                  },
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          value: 'see more',
                          child: Text('All info.'),
                        ),
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewModal() {
    return Container(
      padding: EdgeInsets.all(15),
      height: 300,
      width: double.infinity,
      child: Text('hello'),
    );
  }
}
