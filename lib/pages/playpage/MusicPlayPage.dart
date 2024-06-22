import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../base/musicinfo.dart';
import '../../core/MusicProvider.dart';

class MusicPlayPage extends StatefulWidget {
  @override
  _MusicPlayPageState createState() => _MusicPlayPageState();
}

class _MusicPlayPageState extends State<MusicPlayPage> {
  bool _isPlaying = false; // 是否正在播放

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MusicProvider>(
        builder: (context, musicProvider, child) {
          var selectedMusic = musicProvider.selectedMusic;

          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(selectedMusic != null
                      ? selectedMusic.name
                      : 'Music Player'),
                  background: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                      // 在这里处理播放/暂停逻辑
                    },
                    child: Image.network(
                      'https://via.placeholder.com/400x200',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    var musicInfo = musicProvider.musicInfos[index];
                    bool isSelected = selectedMusic == musicInfo;
                    bool isDownloading =
                        musicProvider.downloading[musicInfo.name] ?? false;

                    return ListTile(
                      leading: CircleAvatar(
                        child: Text((index + 1).toString()),
                      ),
                      title: Text(musicInfo.name),
                      subtitle: Text(musicInfo.artist),
                      selected: isSelected,
                      selectedTileColor: Colors.blue.withOpacity(0.1),
                      trailing:
                          isDownloading ? CircularProgressIndicator() : null,
                      onTap: () async {
                        await musicProvider.play(context, musicInfo);
                      },
                    );
                  },
                  childCount: musicProvider.musicInfos.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
