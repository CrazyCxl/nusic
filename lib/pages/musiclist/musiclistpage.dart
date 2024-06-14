import 'package:flutter/material.dart';
import 'package:samba_browser/samba_browser.dart';
import '../../base/musicinfo.dart';
import './sourcemanager.dart';

class MusicListPage extends StatefulWidget {
  @override
  _MusicListPageState createState() => _MusicListPageState();
}

class _MusicListPageState extends State<MusicListPage> {
  List<Musicinfo> m_musicInfos = [];
  bool _loadingShares = true;
  String _downloadStatus = '';
  SourceManager sourceManager = SourceManager.instance;
  @override
  void initState() {
    super.initState();
    _loadMusicList();
  }

  Future<void> _loadMusicList() async {
    List<Musicinfo> loadedList = await sourceManager.loadMusicInfoList();
    setState(() {
      m_musicInfos = loadedList;
      _loadingShares = false;
    });
  }

  Future<void> _downloadFile() async {
    try {
      final path = await SambaBrowser.saveFile(
        './local/',
        'sync.ffs_db',
        'smb://10.0.2.2/share/music/sync.ffs_db',
        '',
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
                ? Center(child: CircularProgressIndicator())
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
