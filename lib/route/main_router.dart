import 'package:flutter/material.dart';
import 'package:pom/models/ingredient.dart';
import 'package:pom/models/pizza.dart';
import 'package:pom/views/home.dart';
import 'package:pom/views/ingredient.dart';
import 'package:pom/views/ingredients.dart';
import 'package:pom/views/orders.dart';
import 'package:pom/views/pizza.dart';
import 'package:pom/views/pizzas.dart';
import 'package:pom/views/statistics.dart';

class MainRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomePage.routeName:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (BuildContext context) => const HomePage(),
        );
      case IngredientsPage.routeName:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (BuildContext context) => const IngredientsPage(),
        );
      case PizzasPage.routeName:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (BuildContext context) => const PizzasPage(),
        );
      case OrdersPage.routeName:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (BuildContext context) => const OrdersPage(),
        );
      case StatisticsPage.routeName:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (BuildContext context) => StatisticsPage(),
        );
      case IngredientPage.routeName:
        final Map<String, dynamic>? args =
            settings.arguments as Map<String, dynamic>?;

        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (BuildContext context) => IngredientPage(
            ingredient: args?['ingredient'] as Ingredient?,
          ),
        );
      case PizzaPage.routeName:
        final Map<String, dynamic>? args =
            settings.arguments as Map<String, dynamic>?;

        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (BuildContext context) => PizzaPage(
            pizza: args?['pizza'] as Pizza?,
          ),
        );
      default:
        assert(false, 'Need to implement ${settings.name}');
        return null;
    }
  }
}
