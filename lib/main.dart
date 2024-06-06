import 'package:flutter/material.dart';
import '/pages/home.dart';
import '/pages/sourcepage.dart';

void main() {
  runApp(const TabBarDemo());
}

class TabBarDemo extends StatelessWidget {
  const TabBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title:
                null, // You can set title to null if you don't want any title
          ),
          body: TabBarView(
            children: [
              HomePage(),
              MusicListPage(),
              Icon(Icons.directions_bike),
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
