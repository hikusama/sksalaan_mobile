import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skyouthprofiling/data/app_database.dart';
import 'package:skyouthprofiling/data/view/edit.dart';
import 'package:fl_chart/fl_chart.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final db = DatabaseProvider.instance;
  final ScrollController _scrollController = ScrollController();

  List<FullYouthProfile> _youthProfiles = [];

  bool _isLoadingMore = false;
  int _offset = 0;
  int pagesLeft = 0;
  int totalPages = 0;
  int currentPage = 0;
  int totalCount = 0;
  int rowsLeft = 0;
  int sm = 0;
  int fl = 0;
  int sb = 0;

  final int _limit = 5;
  bool _isInitialLoading = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadStats() async {
    final stat = await db.getStatus();

    setState(() {
      isLoading = false;
      sm = stat['Submitted'];
      fl = stat['Failed'];
      sb = stat['Standby'];
    });
  }

  Future<void> _loadInitialData() async {
    final res = await db.getAllYouthProfiles(offset: _offset, limit: _limit);
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

    final res = await db.getAllYouthProfiles(offset: _offset, limit: _limit);
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

  int clicked = 0;
  @override
  Widget build(BuildContext context) {
    int total = sm + fl + sb;
    double smPct = total == 0 ? 0 : sm / total * 100;
    double flPct = total == 0 ? 0 : fl / total * 100;
    double sbPct = total == 0 ? 0 : sb / total * 100;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              _buildDashboard(sbPct, flPct, smPct, total),
              Expanded(
                child:
                    _isInitialLoading
                        ? const Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                          onRefresh: () async {
                            _offset = 0;
                            _isInitialLoading = true;
                            isLoading = true;
                            await _loadStats();
                            await _loadInitialData();
                          },
                          child:
                              _youthProfiles.isEmpty
                                  ? Center(child: Text('No record...'))
                                  : Scrollbar(
                                    thumbVisibility: true,
                                    controller: _scrollController,
                                    child: ListView.builder(
                                      itemCount:
                                          _youthProfiles.length +
                                          (_isLoadingMore ? 1 : 0),
                                      itemBuilder: (context, index) {
                                        if (index == _youthProfiles.length) {
                                          return const Padding(
                                            padding: EdgeInsets.all(16),
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
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

  Widget _buildDashboard(sbPct, flPct, smPct, tot) {
    return Container(
      height: 250,
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 30, 65, 80),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "Youth Migration Status",
              style: TextStyle(
                color: const Color.fromARGB(191, 255, 255, 255),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: 5),
          Container(
            margin: EdgeInsets.only(left: 15),
            height: 3,
            width: 150,
            decoration: BoxDecoration(
              color: const Color.fromARGB(157, 255, 255, 255),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          SizedBox(height: isLoading ? 55 : 30),
          Row(
            mainAxisAlignment:
                isLoading
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              isLoading
                  ? Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 213, 213, 213),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Fetching data',
                        style: TextStyle(
                          color: Color.fromARGB(255, 213, 213, 213),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                  : Expanded(
                    flex: 4,
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child:
                          tot == 0
                              ? const Center(
                                child: Text(
                                  'No record...',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                              : PieChart(
                                PieChartData(
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 0,
                                  sections: [
                                    PieChartSectionData(
                                      value: sm.toDouble(),
                                      color: Colors.green,
                                      radius: 60,
                                      title: '${smPct.toStringAsFixed(0)}%',
                                      titleStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      titlePositionPercentageOffset: 1.2,
                                    ),
                                    PieChartSectionData(
                                      value: fl.toDouble(),
                                      color: Colors.red,
                                      radius: 60,
                                      title: '${flPct.toStringAsFixed(0)}%',
                                      titleStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      titlePositionPercentageOffset: 1.2,
                                    ),
                                    PieChartSectionData(
                                      value: sb.toDouble(),
                                      color: Colors.orangeAccent,
                                      radius: 60,
                                      title: '${sbPct.toStringAsFixed(0)}%',
                                      titleStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      titlePositionPercentageOffset: 1.2,
                                    ),
                                  ],
                                ),
                              ),
                    ),
                  ),

              if (!isLoading) const SizedBox(width: 16),
              if (!isLoading)
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegend(Colors.green, "Submitted"),
                      _buildLegend(Colors.red, "Failed"),
                      _buildLegend(Colors.orangeAccent, "Standby"),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
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

  Widget _buildViewModal() {
    return Container(
      padding: EdgeInsets.all(15),
      height: 300,
      width: double.infinity,
      child: Text('hello'),
    );
  }
}
