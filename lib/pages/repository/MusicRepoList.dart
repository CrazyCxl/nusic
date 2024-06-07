import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nusic/pages/repository/MusicRepoConfig.dart';
import '../../base/repoinfo.dart';

class MusicRepoList extends StatelessWidget {
  MusicRepoList({Key? key}) : super(key: key);

  final List<Repoinfo> musicRepoList = [
    Repoinfo(name: 'Repo 1', url: 'url1'),
    Repoinfo(name: 'Repo 2', url: 'url2'),
    Repoinfo(name: 'Repo 3', url: 'url3'),
    // Add more repositories as needed...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.musicresource),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MusicRepoConfig()),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Adjust the number of grid columns here
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: musicRepoList.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildMusicRepoCard(context, musicRepoList[index]);
        },
      ),
    );
  }

  Widget _buildMusicRepoCard(BuildContext context, Repoinfo repo) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          // Add your action here
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_queue_outlined, size: 64.0, color: Colors.blue),
            SizedBox(height: 8.0),
            Text(repo.name,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
