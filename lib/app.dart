import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_app/extensions/translation_helper.dart';
import 'package:mobile_app/route/main_router.dart';
import 'package:mobile_app/theme/themes.dart';
import 'package:mobile_app/views/home.dart';
import 'package:provider/provider.dart';

class TramsApp extends StatelessWidget {
  final NavigatorObserver? observer;

  const TramsApp({Key? key, this.observer}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
