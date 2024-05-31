import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('cxl Page'),
      ),
      body: const Center(
        child: Icon(Icons.directions_car, size: 100),
      ),
    );
  }
}
