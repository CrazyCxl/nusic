// music_provider.dart
import 'package:flutter/material.dart';
import '../base/musicinfo.dart';

class MusicProvider with ChangeNotifier {
  List<Musicinfo> _musicInfos = [];
  Musicinfo? _selectedMusic;

  List<Musicinfo> get musicInfos => _musicInfos;
  Musicinfo? get selectedMusic => _selectedMusic;

  void setMusicInfos(List<Musicinfo> musicInfos) {
    _musicInfos = musicInfos;
    notifyListeners();
  }

  void selectMusic(Musicinfo musicInfo) {
    _selectedMusic = musicInfo;
    notifyListeners();
  }
}
