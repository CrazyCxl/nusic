class Musicinfo {
  String title;
  String artist;
  String album;
  int duration = 0; // Duration in seconds
  String url = ""; // URL to the music file

  Musicinfo({
    required this.title,
    required this.artist,
    required this.album,
  });
}
