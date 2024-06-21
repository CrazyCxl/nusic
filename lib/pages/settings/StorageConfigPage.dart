import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/MusicDownloader.dart';

class StorageConfigPage extends StatefulWidget {
  @override
  _StorageConfigPageState createState() => _StorageConfigPageState();
}

class _StorageConfigPageState extends State<StorageConfigPage> {
  double maxCacheSizeMB = 10;
  double currentCacheSizeMB = 0;

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCacheInfo();
  }

  Future<void> _loadCacheInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    maxCacheSizeMB = prefs.getDouble('maxCacheSizeMB') ?? 100.0;
    currentCacheSizeMB = await MusicDownloader.instance.getCurrentCacheSize();
    _controller.text = maxCacheSizeMB.toString();
    setState(() {});
  }

  Future<void> _updateMaxCacheSize(double newSize) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('maxCacheSizeMB', newSize);
    setState(() {
      maxCacheSizeMB = newSize;
    });

    // Pass the updated maxCacheSizeMB to MusicDownloader
    MusicDownloader.instance.setMaxCacheSize(maxCacheSizeMB);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.storeConfig),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Current Cache Size: ${currentCacheSizeMB.toStringAsFixed(2)} MB',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Max Cache Size Limit:',
              style: TextStyle(fontSize: 18),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter max size (MB)',
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    double newSize = double.parse(_controller.text);
                    _updateMaxCacheSize(newSize);
                  },
                  child: Text('Save'),
                ),
              ],
            ),
            SizedBox(height: 16),
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 28.0, // 设置轨道高度
                thumbShape:
                    RoundSliderThumbShape(enabledThumbRadius: 14.0), // 设置滑块大小
              ),
              child: Slider(
                value: currentCacheSizeMB,
                min: 0,
                max: maxCacheSizeMB,
                divisions: 100,
                label: '${currentCacheSizeMB.toStringAsFixed(2)} MB',
                onChanged: (newValue) {
                  // 可以在需要时添加逻辑处理
                },
                onChangeStart: (value) {
                  // 阻止用户交互，设置为不可编辑状态
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
