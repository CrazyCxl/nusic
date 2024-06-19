import 'package:flutter/material.dart';

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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Music Player'),
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
                    itemCount: 20, // 假设有20首歌曲
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text((index + 1).toString()),
                        ),
                        title: Text('Song Title $index'),
                        subtitle: Text('Artist Name'),
                        // 添加点击事件以播放对应歌曲
                        onTap: () {
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
