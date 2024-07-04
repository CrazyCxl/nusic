import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../base/musicinfo.dart';
import '../core/MusicDownloader.dart';

class MusicProvider with ChangeNotifier {
  List<Musicinfo> _musicInfos = [];
  Musicinfo? _selectedMusic;
  Musicinfo? _nextMusic;
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
      if (state == PlayerState.completed && _isPlaying) {
        play(_nextMusic!);
      }
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

  play(Musicinfo musicInfo) async {
    _selectedMusic = musicInfo;
    notifyListeners();

    String? path = await _downloadMusic(musicInfo);
    if (path != null) {
      _isPlaying = true;
      notifyListeners();
      var play_future = _audioPlayer.play(DeviceFileSource(path));
      _nextMusic = _findNextMusicInfo(musicInfo);
      if (_nextMusic != null) {
        print('Next Music: ${_nextMusic!.name}');
        var download_future = _downloadMusic(_nextMusic!);
        await Future.wait([play_future, download_future]);
      } else {
        await Future.wait([play_future]);
      }
    } else {
      print('download path null ${musicInfo.name}');
    }
  }

  Future<String?> _downloadMusic(Musicinfo musicInfo) async {
    _downloading[musicInfo.name] = true;
    notifyListeners();

    String? path = await MusicDownloader.instance.downloadMusic(musicInfo);

    _downloading[musicInfo.name] = false;
    notifyListeners();

    if (path == null) {
      print('download failed ${musicInfo.name}');
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
