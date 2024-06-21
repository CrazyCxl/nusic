import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../base/repoinfo.dart';
import '../../musiclist/sourcemanager.dart';

class MusicRepoManager {
  // 私有静态实例
  static MusicRepoManager? _instance;

  // 私有构造函数
  MusicRepoManager._();

  // 全局访问点
  static MusicRepoManager get instance {
    // 如果实例不存在，则创建一个新的实例
    _instance ??= MusicRepoManager._();
    return _instance!;
  }

  static final String _keyMusicRepoList = 'musicRepoList';
  List<Repoinfo> _cachedMusicRepoList = []; // 保存已加载的音乐仓库列表

  // 初始化方法，在此方法中加载 SharedPreferences 数据
  Future<void> init() async {
    _cachedMusicRepoList = await _loadCachedMusicRepoList();
  }

  Future<List<Repoinfo>> _loadCachedMusicRepoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? musicRepoListJson = prefs.getString(_keyMusicRepoList);
    if (musicRepoListJson != null) {
      List<dynamic> decodedList = jsonDecode(musicRepoListJson);
      return decodedList.map((item) => Repoinfo.fromJson(item)).toList();
    }
    return [];
  }

  Future<List<Repoinfo>> loadMusicRepoList() async {
    if (_cachedMusicRepoList.isNotEmpty) {
      return _cachedMusicRepoList;
    } else {
      _cachedMusicRepoList = await _loadCachedMusicRepoList();
      return _cachedMusicRepoList;
    }
  }

  Future<void> saveMusicRepoList(List<Repoinfo> musicRepoList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedList =
        musicRepoList.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setString(_keyMusicRepoList, jsonEncode(encodedList));
    _cachedMusicRepoList = List.from(musicRepoList); // 更新缓存的数据
    await SourceManager.instance.initializeMusicInfoList();
  }

  Future<void> addRepo(Repoinfo repo) async {
    _cachedMusicRepoList.add(repo);
    await saveMusicRepoList(_cachedMusicRepoList);
  }

  Future<void> updateRepo(Repoinfo updatedRepo, int index) async {
    _cachedMusicRepoList[index] = updatedRepo;
    await saveMusicRepoList(_cachedMusicRepoList);
  }
}
