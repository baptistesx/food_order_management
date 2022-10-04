import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pom/blocs/orders/orders.dart';
import 'package:pom/blocs/orders/orders_events.dart';
import 'package:pom/blocs/pizzas/pizzas.dart';
import 'package:pom/blocs/pizzas/pizzas_events.dart';
import 'package:pom/views/ingredients.dart';
import 'package:pom/views/orders.dart';
import 'package:pom/views/pizzas.dart';
import 'package:pom/views/statistics.dart';
import 'package:pom/widgets/custom_appbar.dart';
import 'package:pom/widgets/home_section_button.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/';

  const HomePage({Key? key, required User? user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: Text('Accueil')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <HomeSectionButton>[
          const HomeSectionButton(
            title: 'Liste des ingrédients',
            route: IngredientsPage.routeName,
          ),
          HomeSectionButton(
            title: 'Carte des pizzas',
            route: PizzasPage.routeName,
            onClick: () {
              context.read<PizzasBloc>().add(
                    GetPizzasEvent(),
                  );
            },
          ),
          const HomeSectionButton(
            title: 'Commandes du jour',
            route: OrdersPage.routeName,
          ),
          HomeSectionButton(
            title: 'Statistiques',
            route: StatisticsPage.routeName,
            onClick: () {
              context.read<PizzasBloc>().add(
                    GetPizzasEvent(),
                  );
              context.read<OrdersBloc>().add(
                    GetOrdersEvent(),
                  );
            },
          ),
        ],
      ),
    );
  }
}
