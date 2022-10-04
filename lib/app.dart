import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pom/extensions/translation_helper.dart';
import 'package:pom/main.dart';
import 'package:pom/route/main_router.dart';
import 'package:pom/theme/themes.dart';
import 'package:pom/views/home.dart';
import 'package:pom/views/sign_in.dart';
import 'package:provider/provider.dart';

class POMApp extends StatelessWidget {
  final NavigatorObserver? observer;

  const POMApp({Key? key, this.observer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (BuildContext context) => context.translate.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorObservers: observer == null
          ? const <NavigatorObserver>[]
          : <NavigatorObserver>[observer!],
      theme: Provider.of<AppTheme>(context).lightTheme,
      initialRoute: firebaseAuth.currentUser == null
          ? SignInPage.routeName
          : HomePage.routeName,
      onGenerateRoute: MainRouter.generateRoute,
    );
  }
}
