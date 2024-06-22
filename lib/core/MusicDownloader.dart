import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:samba_browser/samba_browser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../base/musicinfo.dart';

class MusicDownloader {
  double maxCacheSizeMB = 100.0; // Example cache size limit
  late String cacheDirectory;
  static MusicDownloader? _instance;

  // Private constructor
  MusicDownloader._();

  // Singleton instance getter
  static MusicDownloader get instance {
    _instance ??= MusicDownloader._();
    return _instance!;
  }

  void setMaxCacheSize(double initialMaxCacheSizeMB) {
    maxCacheSizeMB = initialMaxCacheSizeMB;
  }

  Future<void> init() async {
    cacheDirectory = await _getDefaultCacheDirectory();
    Directory(cacheDirectory).createSync(recursive: true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    maxCacheSizeMB = prefs.getDouble('maxCacheSizeMB') ?? 100.0;

    await _manageCache();
  }

  Future<String?> downloadMusic(Musicinfo musicInfo) async {
    if (cacheDirectory.isEmpty) {
      await init();
    }

    String fileName = Uri.parse(musicInfo.url).pathSegments.last;
    String savePath = '$cacheDirectory/';

    // Check if the file already exists
    File file = File(savePath + fileName);
    if (file.existsSync()) {
      return savePath;
    }

    // Manage cache size before downloading
    await _manageCache();

    print('Downloading ${musicInfo.url} to $savePath');
    // Perform the download
    try {
      await SambaBrowser.saveFile(
          savePath,
          fileName,
          musicInfo.url,
          '', // Domain if needed
          musicInfo.repo.username,
          musicInfo.repo.password);
      return savePath;
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }

  Future<double> getCurrentCacheSize() async {
    Directory dir = Directory(cacheDirectory);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
      return 0;
    }

    List<FileSystemEntity> files = dir.listSync();
    double totalSizeMB = files.fold(0.0, (sum, file) {
      if (file is File) {
        return sum + file.lengthSync() / (1024 * 1024);
      }
      return sum;
    });
    return totalSizeMB;
  }

  Future<void> _manageCache() async {
    Directory dir = Directory(cacheDirectory);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
      return;
    }

    List<FileSystemEntity> files = dir.listSync();
    double totalSizeMB = files.fold(0.0, (sum, file) {
      if (file is File) {
        return sum + file.lengthSync() / (1024 * 1024);
      }
      return sum;
    });

    if (totalSizeMB > maxCacheSizeMB) {
      files.sort((a, b) {
        if (a is File && b is File) {
          return a.lastModifiedSync().compareTo(b.lastModifiedSync());
        }
        return 0;
      });

      for (var file in files) {
        if (totalSizeMB <= maxCacheSizeMB) break;
        if (file is File) {
          totalSizeMB -= file.lengthSync() / (1024 * 1024);
          file.deleteSync();
        }
      }
    }

    totalSizeMB;
  }

  static Future<String> _getDefaultCacheDirectory() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir.path;
  }
}
