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

  List<FullYouthProfile> _youthProfiles = [];
  late ScrollController _scrollController;

  bool _isLoadingMore = false;
  int _offset = 0;
  final int _limit = 15;
  bool _hasMore = true;
  bool _isInitialLoading = true;

 
@override
void initState() {
  super.initState();
  _scrollController = ScrollController()..addListener(_scrollListener);
  _loadInitialData();
}

Future<void> _loadInitialData() async {
  final res = await db.getAllYouthProfiles(offset: _offset, limit: _limit);
  setState(() {
    _youthProfiles = List<FullYouthProfile>.from(res['youth']);
    _offset += _limit;
    _hasMore = res['youth'].length == _limit;
     _isInitialLoading = false;
  });
}


void _scrollListener() {
  if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
      !_isLoadingMore &&
      _hasMore) {
        print('hello');
    _loadMoreData();
  }
}


Future<void> _loadMoreData() async {
  setState(() {
    _isLoadingMore = true;
  });

  final res = await db.getAllYouthProfiles(offset: _offset, limit: _limit);
  final List<FullYouthProfile> moreProfiles =
      List<FullYouthProfile>.from(res['youth']);

  setState(() {
    _youthProfiles.addAll(moreProfiles);
    _offset += _limit;
    _hasMore = moreProfiles.length == _limit;
    _isLoadingMore = false;
  });
}


  int clicked = 0;
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
                child:
                    _isInitialLoading
                        ? const Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                          onRefresh: () async {
                            _offset = 0;
                            _hasMore = true;
                            _isInitialLoading = true;
                            await _loadInitialData();
                          },
                          child: Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            child: ListView.builder(
                              controller: _scrollController,
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

  Widget _designRecord(
    FullYouthProfile profile,
    BuildContext context,
    int index,
    int proflen,
  ) {
    final name =
        '${profile.youthInfo?.lname ?? ''}, ${profile.youthInfo?.fname ?? ''}';
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
            color: const Color.fromARGB(181, 20, 127, 169),
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
                        }
                      },
                      itemBuilder:
                          (context) => [
                            PopupMenuItem(
                              value: 'see more',
                              child: Text('All info.'),
                            ),
                          ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        index + 1 == proflen ? Text('hello') : SizedBox.shrink(),
      ],
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
