import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:skyouthprofiling/data/app_database.dart';
import 'package:skyouthprofiling/data/view/edit.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  Future<List<FullYouthProfile>> _fetchProfiles(BuildContext context) async {
    final db = DatabaseProvider.instance;

    return db.getAllYouthProfiles();
  }

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
                    return Scrollbar(
                      thumbVisibility: true,
                      child: ListView.builder(
                        itemCount: profiles.length,
                        itemBuilder: (context, index) {
                          return _designRecord(profiles[index], context);
                        },
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
    final age = profile.youthInfo?.age ?? '--';
    final status = profile.youthUser.status;
    final type = profile.youthUser.youthType;
    Color statColor = Colors.white;
    switch (status) {
      case 'Standby':
        statColor = const Color.fromARGB(255, 255, 17, 0);
        break;
      case 'Failed':
        statColor = const Color.fromARGB(255, 255, 217, 0);
        break;
      case 'Submitted':
        statColor = Colors.red;
        break;
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      padding: const EdgeInsets.fromLTRB(17, 6, 8, 6),
      decoration: BoxDecoration(
        color: const Color.fromARGB(181, 20, 127, 169),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 2,color:  Color.fromARGB(255, 19, 137, 184),)
      ),
      child: Row(
        children: [
          Expanded(
            flex: 7,
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
                  style: const TextStyle(fontSize: 14, color: Colors.white),
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
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Age',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                Text(
                  age.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Type',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                Text(type, style: const TextStyle(color: Colors.white)),
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
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return _buildDeleteModal();
                    },
                  );
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(value: 'see more', child: Text('Show info.')),
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteModal() {
    return Container(
      padding: EdgeInsets.all(15),
      height: 300,
      width: double.infinity,
      child: Text('hello'),
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
