// musiclistpage.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../base/musicinfo.dart';
import './sourcemanager.dart';
import '../../core/MusicProvider.dart';

class MusicListPage extends StatefulWidget {
  @override
  _MusicListPageState createState() => _MusicListPageState();
}

class _MusicListPageState extends State<MusicListPage> {
  bool _loadingShares = true;
  SourceManager sourceManager = SourceManager.instance;

  @override
  void initState() {
    super.initState();
    _loadMusicList();
  }

  Future<void> _loadMusicList() async {
    List<Musicinfo> loadedList = await sourceManager.loadMusicInfoList();
    Provider.of<MusicProvider>(context, listen: false)
        .setMusicInfos(loadedList);
    setState(() {
      _loadingShares = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var musicProvider = Provider.of<MusicProvider>(context);

    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _loadingShares
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: musicProvider.musicInfos.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2.0,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16.0),
                            title: Text(musicProvider.musicInfos[index].name),
                            subtitle: musicProvider
                                    .musicInfos[index].artist.isEmpty
                                ? null
                                : Text(musicProvider.musicInfos[index].artist),
                            onTap: () async {
                              DefaultTabController.of(context)
                                  ?.animateTo(2); // Switch to MusicPlayPage
                              await musicProvider.play(
                                  context, musicProvider.musicInfos[index]);
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
