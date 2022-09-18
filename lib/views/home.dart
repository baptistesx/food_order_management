import 'package:flutter/material.dart';
import 'package:pom/views/ingredients.dart';
import 'package:pom/views/orders.dart';
import 'package:pom/views/pizzas.dart';
import 'package:pom/views/statistics.dart';
import 'package:pom/widgets/home_section_button.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const <HomeSectionButton>[
          HomeSectionButton(
            title: 'Liste des ingrédients',
            route: IngredientsPage.routeName,
          ),
          HomeSectionButton(
              title: 'Carte des pizzas', route: PizzasPage.routeName),
          HomeSectionButton(
              title: 'Commandes du jour', route: OrdersPage.routeName),
          HomeSectionButton(
            title: 'Statistiques',
            route: StatisticsPage.routeName,
          ),
        ],
      ),
    );
  }
}
