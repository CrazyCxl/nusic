import './repoinfo.dart';

class Musicinfo {
  String name;
  String artist;
  String album;
  int duration = 0; // Duration in seconds
  String url = ""; // URL to the music file
  Repoinfo repo;

  Musicinfo({
    required this.name,
    this.artist = '',
    this.album = '',
    this.url = '',
    Repoinfo? repo,
  }) : repo = repo ?? Repoinfo(type: RepoType.LOCAL);
}
