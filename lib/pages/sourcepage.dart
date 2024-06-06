import 'package:flutter/material.dart';
import 'package:samba_browser/samba_browser.dart';

class MusicListPage extends StatefulWidget {
  @override
  _MusicListPageState createState() => _MusicListPageState();
}

class _MusicListPageState extends State<MusicListPage> {
  List<String> _shares = [];
  bool _loadingShares = true;
  String _downloadStatus = '';

  @override
  void initState() {
    super.initState();
    _fetchShareList();
  }

  Future<void> _fetchShareList() async {
    try {
      final shares = await SambaBrowser.getShareList(
        'smb://10.0.2.2/',
        // 'smb://192.168.196.11/',
        'DESKTOP-CXL-PC',
        'cxl',
        '123',
      );
      setState(() {
        _shares = shares.cast<String>();
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
      appBar: AppBar(
        title: Text('Samba Browser Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _loadingShares
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _shares.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_shares[index]),
                        );
                      },
                    ),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _downloadFile,
              child: Text('Download File'),
            ),
            SizedBox(height: 20),
            Text(_downloadStatus),
          ],
        ),
      ),
    );
  }
}
