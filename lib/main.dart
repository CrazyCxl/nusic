import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/MusicProvider.dart';
import 'pages/home.dart';
import 'pages/playpage/MusicPlayPage.dart';
import 'pages/musiclist/musiclistpage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'core/MusicDownloader.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MusicProvider(),
      child: const TabBarDemo(),
    ),
  );
}

class TabBarDemo extends StatefulWidget {
  const TabBarDemo({Key? key}) : super(key: key);

  @override
  _TabBarDemoState createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<TabBarDemo> {
  @override
  void initState() {
    MusicDownloader.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('zh'),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: null,
          body: TabBarView(
            children: [
              HomePage(),
              MusicListPage(),
              MusicPlayPage(),
            ],
          ),
          bottomNavigationBar: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home_outlined)),
              Tab(icon: Icon(Icons.music_note_outlined)),
              Tab(icon: Icon(Icons.album_outlined)),
            ],
          ),
        ),
      ),
    );
  }
}
