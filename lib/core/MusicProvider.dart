import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../base/musicinfo.dart';
import '../core/MusicDownloader.dart';

class MusicProvider with ChangeNotifier {
  List<Musicinfo> _musicInfos = [];
  Musicinfo? _selectedMusic;
  Map<String, bool> _downloading = {};
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  PlayerState _state = PlayerState.stopped;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  List<Musicinfo> get musicInfos => _musicInfos;
  Musicinfo? get selectedMusic => _selectedMusic;
  Map<String, bool> get downloading => _downloading;
  Duration get duration => _duration;
  Duration get position => _position;
  AudioPlayer get audioPlayer => _audioPlayer;
  PlayerState get state => _state;

  MusicProvider() {
    _audioPlayer.onDurationChanged.listen((d) {
      _duration = d;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((p) {
      _position = p;
      notifyListeners();
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      _state = state;
      notifyListeners();
    });
  }

  void setMusicInfos(List<Musicinfo> musicInfos) {
    _musicInfos = musicInfos;
    notifyListeners();
  }

  // 根据当前音乐信息找到下一首音乐信息
  Musicinfo? _findNextMusicInfo(Musicinfo currentMusicInfo) {
    int currentIndex =
        _musicInfos.indexWhere((music) => music == currentMusicInfo);
    int nextIndex = currentIndex + 1;

    if (nextIndex < _musicInfos.length) {
      return _musicInfos[nextIndex];
    } else {
      // 如果已经是最后一首，则返回第一首音乐信息作为循环
      return null;
    }
  }

  Future<void> play(BuildContext context, Musicinfo musicInfo) async {
    _selectedMusic = musicInfo;
    notifyListeners();

    String? path = await _downloadMusic(context, musicInfo);
    if (path != null) {
      _isPlaying = true;
      notifyListeners();
      var play_future = _audioPlayer.play(DeviceFileSource(path));
      Musicinfo? next_music_info = _findNextMusicInfo(musicInfo);
      if (next_music_info != null) {
        print('Next Music: ${next_music_info.name}');
        var download_future = _downloadMusic(context, next_music_info);
        await Future.wait([play_future, download_future]);
      } else {
        await Future.wait([play_future]);
      }
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

  Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    notifyListeners();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
