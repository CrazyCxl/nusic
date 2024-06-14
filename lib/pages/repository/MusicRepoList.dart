import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../base/repoinfo.dart';
import 'MusicRepoConfig.dart';

class MusicRepoList extends StatefulWidget {
  MusicRepoList({Key? key}) : super(key: key);

  @override
  _MusicRepoListState createState() => _MusicRepoListState();
}

class _MusicRepoListState extends State<MusicRepoList> {
  List<Repoinfo> musicRepoList = [
    Repoinfo(name: 'Repo 1', url: 'url1', type: RepoType.SMB),
    Repoinfo(name: 'Repo 2', url: 'url2', type: RepoType.LOCAL),
    Repoinfo(name: 'Repo 3', url: 'url3', type: RepoType.SMB),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.musicresource),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final Repoinfo? result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MusicRepoConfig()),
              );
              if (result != null) {
                setState(() {
                  musicRepoList.add(result);
                });
              }
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
          return _buildMusicRepoCard(context, musicRepoList[index], index);
        },
      ),
    );
  }

  Widget _buildMusicRepoCard(BuildContext context, Repoinfo repo, int index) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () async {
          final Repoinfo? result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MusicRepoConfig(initialRepo: repo)),
          );
          if (result != null) {
            setState(() {
              musicRepoList[index] = result;
            });
          }
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
