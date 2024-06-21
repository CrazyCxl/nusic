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
    final shares = await SambaBrowser.getShareList(
      'smb://${repo.ip}/${repo.path}',
      '',
      repo.username,
      repo.password,
    );
    List<Musicinfo> infos = _loadMusicInfosFromUrls(shares.cast<String>());
    return infos;
  }

  List<Musicinfo> _loadMusicInfosFromUrls(List<String> urls) {
    // Define the supported music extensions
    final supportedExtensions = ['mp3', 'flac'];
    List<Musicinfo> musicInfos = [];

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
          name: name,
          artist: artist,
          album: album,
        );
        musicInfo.url = share;

        // Add the instance to the list
        musicInfos.add(musicInfo);
      }
    }
    return musicInfos;
  }
}
