import 'package:flutter/material.dart';
import 'package:samba_browser/samba_browser.dart';
import '../base/musicinfo.dart';

class MusicListPage extends StatefulWidget {
  @override
  _MusicListPageState createState() => _MusicListPageState();
}

class _MusicListPageState extends State<MusicListPage> {
  List<Musicinfo> m_musicInfos = [];
  bool _loadingShares = true;
  String _downloadStatus = '';

  @override
  void initState() {
    super.initState();
    _fetchShareList();
  }

  List<Musicinfo> loadMusicInfos(List<String> urls) {
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

  Future<void> _fetchShareList() async {
    try {
      final shares = await SambaBrowser.getShareList(
        'smb://10.0.2.2/share/music/',
        '',
        'cxl',
        '123',
      );
      List<Musicinfo> infos = loadMusicInfos(shares.cast<String>());
      setState(() {
        m_musicInfos = infos;
        _loadingShares = false;
      });
    } catch (e) {
      print('Error fetching share list: $e');
      setState(() {
        _loadingShares = false;
      });
    }
  }

  Future<void> _downloadFile() async {
    try {
      final path = await SambaBrowser.saveFile(
        './local/',
        'sync.ffs_db',
        'smb://10.0.2.2/share/music/sync.ffs_db',
        'DESKTOP-CXL-PC',
        'cxl',
        '123',
      );
      setState(() {
        _downloadStatus = 'File downloaded to: $path';
      });
    } catch (e) {
      print('Error downloading file: $e');
      setState(() {
        _downloadStatus = 'Error downloading file';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _loadingShares
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: m_musicInfos.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2.0,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16.0),
                            title: Text(m_musicInfos[index].name),
                            subtitle: m_musicInfos[index].artist.isEmpty
                                ? null
                                : Text(m_musicInfos[index].artist),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
