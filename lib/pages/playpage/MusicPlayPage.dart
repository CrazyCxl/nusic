// musicplaypage.dart
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
  double _progress = 0.5; // 播放进度，默认为50%

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
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text((index + 1).toString()),
                      ),
                      title: Text(musicInfo.name),
                      subtitle: Text(musicInfo.artist),
                      // 添加点击事件以播放对应歌曲
                      onTap: () {
                        musicProvider.selectMusic(musicInfo);
                        // 在这里处理点击播放列表中歌曲的逻辑
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
