import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pom/app.dart';
import 'package:pom/blocs/settings/settings.dart';
import 'package:pom/firebase_options.dart';
import 'package:pom/models/settings_models.dart';
import 'package:pom/repositories/settings/settings.dart';
import 'package:pom/services/logger.dart';
import 'package:pom/theme/themes.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<void> main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      // Init global repositories
      final SettingsRepository settingsRepository =
          SettingsRepository(logger: Logger());

      final SettingsModel? settings =
          await settingsRepository.loadFromPreferences();

      runApp(
        MultiBlocProvider(
          providers: <BlocProvider<dynamic>>[
            BlocProvider<SettingsBloc>(
              create: (BuildContext context) => SettingsBloc(
                settingsRepository,
                initialState: settings == null
                    ? null
                    : SettingsUpdatedState(settings: settings),
              ),
            ),
          ],
          child: MultiProvider(
            providers: <SingleChildWidget>[
              Provider<AppTheme>(
                create: (BuildContext context) => AppTheme(),
              ),
            ],
            child: TramsApp(
              observer: FirebaseAnalyticsObserver(
                analytics: FirebaseAnalytics.instance,
              ),
            ),
          ),
        ),
      );
    },
    (Object error, StackTrace stack) {
      Logger().record(error: error, stack: stack);
    },
  );
}
