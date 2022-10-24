import 'package:flutter/material.dart';
import 'package:fom/models/ingredient.dart';
import 'package:fom/models/order.dart';
import 'package:fom/models/pizza.dart';
import 'package:fom/views/home.dart';
import 'package:fom/views/ingredient.dart';
import 'package:fom/views/ingredients.dart';
import 'package:fom/views/order.dart';
import 'package:fom/views/orders.dart';
import 'package:fom/views/pizza.dart';
import 'package:fom/views/pizzas.dart';
import 'package:fom/views/sign_in.dart';
import 'package:fom/views/statistics.dart';
import 'package:fom/views/suggestion.dart';

class MainRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SignInPage.routeName:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (BuildContext context) => const SignInPage(),
        );
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
      case OrderPage.routeName:
        final Map<String, dynamic>? args =
            settings.arguments as Map<String, dynamic>?;

        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (BuildContext context) => OrderPage(
            order: args?['order'] as Order?,
          ),
        );
      case StatisticsPage.routeName:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (BuildContext context) => const StatisticsPage(),
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
      case SuggestionPage.routeName:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (BuildContext context) => const SuggestionPage(),
        );
      default:
        assert(false, 'Need to implement ${settings.name}');
        return null;
    }
  }
}
