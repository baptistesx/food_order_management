import 'package:flutter/material.dart';

class StatisticsPage extends StatelessWidget {
  static const String routeName = '/statistics';

  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
      ),
      body: const Text('Stats'),
    );
  }
}
