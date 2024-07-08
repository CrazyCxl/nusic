import '../../base/musicinfo.dart';
import '../../base/repoinfo.dart';
import '../settings/repository/MusicRepoManager.dart';
import 'package:samba_browser/samba_browser.dart';

class SourceManager {
  static SourceManager? _instance;
  static SourceManager get instance {
    _instance ??= SourceManager._();
    return _instance!;
  }

  List<Musicinfo> _musicInfos = [];

  SourceManager._();

  Future<List<Musicinfo>> loadMusicInfoList() async {
    if (_musicInfos.isNotEmpty) {
      return _musicInfos;
    } else {
      await initializeMusicInfoList();
      return _musicInfos;
    }
  }

  Future<void> initializeMusicInfoList() async {
    List<Repoinfo> repoList =
        await MusicRepoManager.instance.loadMusicRepoList();
    List<Musicinfo> musicInfos = [];

    for (var repo in repoList) {
      List<Musicinfo> infos = await _loadMusicInfosFromRepo(repo);
      musicInfos.addAll(infos);
    }

    _musicInfos = musicInfos;
  }

  Future<List<Musicinfo>> _loadMusicInfosFromRepo(Repoinfo repo) async {
    List<Musicinfo> musicInfos = [];

    try {
      final shares = await SambaBrowser.getShareList(
        'smb://${repo.ip}/${repo.path}',
        '',
        repo.username,
        repo.password,
      );

      final supportedExtensions = ['mp3', 'flac', 'wav'];

      List<String> urls = shares.cast<String>();
      for (var share in urls) {
        // Get the file extension
        String extension = share.split('.').last;

        // Check if the file is a supported music file
        if (supportedExtensions.contains(extension.toLowerCase())) {
          // Assuming the share name is the file name
          String name = share.split('/').last.split('.').first;
          // You can set artist and album as empty strings for now, since this information might not be available
          String artist = "";
          String album = "";

          // Create a Musicinfo instance and set the URL
          Musicinfo musicInfo = Musicinfo(
              name: name, artist: artist, album: album, url: share, repo: repo);

          // Add the instance to the list
          musicInfos.add(musicInfo);
        }
      }
    } catch (e) {
      print('Error list: $e');
    }
    return musicInfos;
  }
}
