import 'package:flutter/material.dart';
import 'package:mobile_app/views/home.dart';

class MainRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomePage.routeName:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (BuildContext context) => const HomePage(),
        );
      default:
        assert(false, 'Need to implement ${settings.name}');
        return null;
    }
  }
}
