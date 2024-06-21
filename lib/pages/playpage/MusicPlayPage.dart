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
    var musicProvider = Provider.of<MusicProvider>(context);
    var selectedMusic = musicProvider.selectedMusic;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                  selectedMusic != null ? selectedMusic.name : 'Music Player'),
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
            delegate: SliverChildListDelegate(
              [
                Container(
                  height: 400.0, // 用于测试滚动效果，实际根据内容调整
                  child: ListView.builder(
                    itemCount: musicProvider.musicInfos.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text((index + 1).toString()),
                        ),
                        title: Text(musicProvider.musicInfos[index].name),
                        subtitle: Text(musicProvider.musicInfos[index].artist),
                        // 添加点击事件以播放对应歌曲
                        onTap: () {
                          musicProvider
                              .selectMusic(musicProvider.musicInfos[index]);
                          // 在这里处理点击播放列表中歌曲的逻辑
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
