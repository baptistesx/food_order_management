import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  static const String routeName = '/orders';

  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commandes'),
      ),
      body: const Text('Commandes'),
    );
  }
}
