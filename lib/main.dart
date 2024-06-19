import 'package:flutter/material.dart';
import '/pages/home.dart';
import './pages/playpage/MusicPlayPage.dart';
import 'pages/musiclist/musiclistpage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const TabBarDemo());
}

class TabBarDemo extends StatelessWidget {
  const TabBarDemo({super.key});

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
