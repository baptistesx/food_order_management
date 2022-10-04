import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pom/extensions/translation_helper.dart';
import 'package:pom/route/main_router.dart';
import 'package:pom/theme/themes.dart';
import 'package:pom/views/sign_in.dart';
import 'package:provider/provider.dart';

class POMApp extends StatefulWidget {
  final NavigatorObserver? observer;

  const POMApp({Key? key, this.observer}) : super(key: key);

  @override
  State<POMApp> createState() => _POMAppState();
}

class _POMAppState extends State<POMApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (BuildContext context) => context.translate.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorObservers: widget.observer == null
          ? const <NavigatorObserver>[]
          : <NavigatorObserver>[widget.observer!],
      theme: Provider.of<AppTheme>(context).lightTheme,
      initialRoute: SignInPage.routeName,
      onGenerateRoute: MainRouter.generateRoute,
    );
  }
}
