import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skyouthprofiling/data/app_database.dart';
import 'package:skyouthprofiling/data/view/edit.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  RecordsScreenState createState() => RecordsScreenState();
}

class RecordsScreenState extends State<RecordsScreen> {
  final db = DatabaseProvider.instance;
  bool _isLoadingMore = false;
  int _offset = 0;
  int pagesLeft = 0;
  int totalPages = 0;
  int currentPage = 0;
  int totalCount = 0;
  int rowsLeft = 0;
  List<FullYouthProfile> _youthProfiles = [];
  int clicked = 0;
  bool isDeleteSuccess = false;
  final int _limit = 5;
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData('');
  }

  Future<void> _loadInitialData(String arg) async {
    final res = await db.getAllYouthProfiles(
      offset: _offset,
      limit: _limit,
      searchKeyword: arg,
    );
    setState(() {
      _youthProfiles = List<FullYouthProfile>.from(res['youth']);
      _offset += _limit;
      _isInitialLoading = false;
      pagesLeft = res['pagesLeft'];
      totalCount = res['totalCount'];
      totalPages = res['totalPages'];
      currentPage = res['currentPage'];
      rowsLeft = res['rowsLeft'];
    });
  }

  Future<void> _loadMoreData() async {
    setState(() {
      _isLoadingMore = true;
    });

    final res = await db.getAllYouthProfiles(
      offset: _offset,
      limit: _limit,
      searchKeyword: '',
    );
    final List<FullYouthProfile> moreProfiles = List<FullYouthProfile>.from(
      res['youth'],
    );

    setState(() {
      _youthProfiles.addAll(moreProfiles);
      _offset += _limit;
      _isLoadingMore = false;
      pagesLeft = res['pagesLeft'];
      totalCount = res['totalCount'];
      totalPages = res['totalPages'];
      currentPage = res['currentPage'];
      rowsLeft = res['rowsLeft'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              _builConHeader(),
              SizedBox(height: 15),
              _builSummary(),
              SizedBox(height: 8),
              Expanded(
                child:
                    _isInitialLoading
                        ? const Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                          onRefresh: () async {
                            _offset = 0;
                            _isInitialLoading = true;
                            await _loadInitialData('');
                          },
                          child: Scrollbar(
                            thumbVisibility: true,
                            child: ListView.builder(
                              itemCount:
                                  _youthProfiles.length +
                                  (_isLoadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == _youthProfiles.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                return _designRecord(
                                  _youthProfiles[index],
                                  context,
                                  index,
                                  _youthProfiles.length,
                                );
                              },
                            ),
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _builSummary() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Records',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 7),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(child: Row(children: [Text('Sort '), Icon(Icons.tune)])),
              SizedBox(width: 15),

              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('aksdjaksd'),
                      );
                    },
                  );
                },
                child: Row(children: [Text('Filter '), Icon(Icons.filter_alt)]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _builConHeader() {
    return Container(
      height: 230,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 30, 65, 80),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 100, child: Image.asset('assets/images/logo.png')),
          Text(
            'SK Youth records',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 200,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelStyle: TextStyle(fontSize: 12),
                    hintText: 'Search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(150)),
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(45, 10, 10, 10),
                  ),
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  onChanged: (value) {
                    _offset = 0;
                    _isInitialLoading = true;
                    _loadInitialData(value.trim());
                  },
                ),
                Positioned(
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(width: 1.0, color: Colors.black),
                      ),
                    ),
                    child: Icon(Icons.search, color: Colors.black, size: 23),
                  ),
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

  Widget _designRecord(
    FullYouthProfile profile,
    BuildContext context,
    int index,
    int proflen,
  ) {
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
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          padding: const EdgeInsets.fromLTRB(17, 0, 8, 0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(181, 11, 67, 90),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 2,
              color: Color.fromARGB(255, 19, 137, 184),
            ),
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
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
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
                          Text(
                            date,
                            style: const TextStyle(color: Colors.white),
                          ),
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
                              MaterialPageRoute(
                                builder: (context) => const Edit(),
                              ),
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
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
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
                                                                color:
                                                                    Colors
                                                                        .black,
                                                                fontSize: 18,
                                                              ),
                                                            )
                                                            : Text(
                                                              'Something went wrong',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .black,
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
                                                          MainAxisAlignment
                                                              .center,

                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
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
                                                          await db
                                                              .deleteYouthUser(
                                                                profile
                                                                    .youthUser
                                                                    .youthUserId,
                                                              );
                                                          isGood = true;
                                                        } catch (e) {
                                                          isGood = false;
                                                        }
                                                        if (isGood) {
                                                          isDeleteSuccess =
                                                              true;
                                                          setState(() {});
                                                        } else {
                                                          isDeleteSuccess =
                                                              false;
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
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        index + 1 == proflen ? SizedBox(height: 5) : SizedBox.shrink(),
        (index + 1 == proflen && pagesLeft != 0)
            ? MaterialButton(
              onPressed: () => _loadMoreData(),
              child: Text('Load more'),
            )
            : SizedBox.shrink(),
        (index + 1 == proflen && pagesLeft == 0)
            ? SizedBox(height: 15)
            : SizedBox.shrink(),
        (_youthProfiles.isEmpty) ? Text('No records.') : SizedBox.shrink(),
        (index + 1 == proflen && pagesLeft == 0)
            ? Text('You\'re all caught up.')
            : SizedBox.shrink(),
        (index + 1 == proflen && pagesLeft == 0)
            ? SizedBox(height: 15)
            : SizedBox.shrink(),
        index + 1 == proflen
            ? Container(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            pagesLeft.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                          Text('Pages left', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            currentPage.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                          Text('Current page', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            totalPages.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                          Text('Total pages', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            rowsLeft.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                          Text('Rows left', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            totalCount.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                          Text('Total rows', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
            : SizedBox.shrink(),
      ],
    );
  }
}
