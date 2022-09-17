import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pom/extensions/translation_helper.dart';
import 'package:pom/route/main_router.dart';
import 'package:pom/theme/themes.dart';
import 'package:pom/views/home.dart';
import 'package:provider/provider.dart';

class TramsApp extends StatelessWidget {
  final NavigatorObserver? observer;

  const TramsApp({Key? key, this.observer}) : super(key: key);

  // This widget is the root of your application.
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
      initialRoute: HomePage.routeName,
      onGenerateRoute: MainRouter.generateRoute,
    );
  }
}
