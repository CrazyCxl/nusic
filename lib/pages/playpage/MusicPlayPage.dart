import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../base/musicinfo.dart';
import '../../core/MusicProvider.dart';

class MusicPlayPage extends StatefulWidget {
  @override
  _MusicPlayPageState createState() => _MusicPlayPageState();
}

class _MusicPlayPageState extends State<MusicPlayPage> {
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
                  background: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Positioned(
                        bottom: 60.0,
                        left: 20.0,
                        child: FloatingActionButton(
                          backgroundColor: Color.fromARGB(62, 156, 181, 236),
                          onPressed: () {
                            switch (musicProvider.state) {
                              case PlayerState.playing:
                                musicProvider.pause();
                                break;
                              case PlayerState.paused:
                                musicProvider.resume();
                                break;
                              default:
                            }
                          },
                          child: Icon(
                            musicProvider.state == PlayerState.playing
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                        ),
                      ),
                      if (musicProvider.state == PlayerState.playing ||
                          musicProvider.state == PlayerState.paused)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LinearProgressIndicator(
                                value: musicProvider.duration.inMilliseconds > 0
                                    ? musicProvider.position.inMilliseconds /
                                        musicProvider.duration.inMilliseconds
                                    : 0.0,
                                backgroundColor: Colors.grey,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blueAccent),
                              ),
                            ],
                          ),
                        ),
                    ],
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}
