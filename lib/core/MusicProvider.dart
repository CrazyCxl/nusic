import 'package:flutter/material.dart';
import '../base/musicinfo.dart';
import '../core/MusicDownloader.dart';

class MusicProvider with ChangeNotifier {
  List<Musicinfo> _musicInfos = [];
  Musicinfo? _selectedMusic;
  Map<String, bool> _downloading = {};

  List<Musicinfo> get musicInfos => _musicInfos;
  Musicinfo? get selectedMusic => _selectedMusic;
  Map<String, bool> get downloading => _downloading;

  void setMusicInfos(List<Musicinfo> musicInfos) {
    _musicInfos = musicInfos;
    notifyListeners();
  }

  Future<void> play(BuildContext context, Musicinfo musicInfo) async {
    _selectedMusic = musicInfo;
    notifyListeners();

    String? path = await _downloadMusic(context, musicInfo);
    if (path != null) {
      // 播放音乐的逻辑
    }
  }

  Future<String?> _downloadMusic(
      BuildContext context, Musicinfo musicInfo) async {
    _downloading[musicInfo.name] = true;
    notifyListeners();

    String? path = await MusicDownloader.instance.downloadMusic(musicInfo);

    _downloading[musicInfo.name] = false;
    notifyListeners();

    if (path == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('下载失败'),
            content: Text('无法下载 ${musicInfo.name}。请重试。'),
            actions: <Widget>[
              TextButton(
                child: Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    return path;
  }
}
