import 'package:flutter/material.dart';
import 'package:skyouthprofiling/data/app_database.dart';

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
                          return _designRecord(profiles[index]);
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

  Widget _designRecord(FullYouthProfile profile) {
    final name =
        '${profile.youthInfo?.lname ?? ''}, ${profile.youthInfo?.fname ?? ''}';
    final age = profile.youthInfo?.age ?? '--';
    final type = profile.youthUser.youthType;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      padding: const EdgeInsets.fromLTRB(17, 6, 8, 6),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(20, 126, 169, 1),
        borderRadius: BorderRadius.circular(12),
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
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.more_horiz_rounded),
            onPressed: () {
              // Add action here (e.g., show dialog, navigate)
            },
          ),
        ],
      ),
    );
  }
}
