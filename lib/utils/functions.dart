import 'package:flutter/material.dart';
import 'package:pom/views/sign_in.dart';

Route<dynamic> routeToSignInScreen() {
  return PageRouteBuilder<dynamic>(
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) =>
        const SignInPage(),
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      const Offset begin = Offset(-1.0, 0.0);
      const Offset end = Offset.zero;
      const Cubic curve = Curves.ease;

      final Animatable<Offset> tween =
          Tween<Offset>(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
