import 'package:flutter/material.dart';

class PizzasPage extends StatelessWidget {
  static const String routeName = '/pizzas';

  const PizzasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizzas'),
      ),
      body: const Text('Pizzas'),
    );
  }
}
