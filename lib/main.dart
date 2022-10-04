import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pom/app.dart';
import 'package:pom/blocs/auth/auth.dart';
import 'package:pom/blocs/auth/auth_states.dart';
import 'package:pom/blocs/ingredient/ingredient.dart';
import 'package:pom/blocs/ingredient/ingredient_states.dart';
import 'package:pom/blocs/ingredients/ingredients.dart';
import 'package:pom/blocs/ingredients/ingredients_states.dart';
import 'package:pom/blocs/order/order.dart';
import 'package:pom/blocs/order/order_states.dart';
import 'package:pom/blocs/orders/orders.dart';
import 'package:pom/blocs/orders/orders_states.dart';
import 'package:pom/blocs/pizza/pizza.dart';
import 'package:pom/blocs/pizza/pizza_states.dart';
import 'package:pom/blocs/pizzas/pizzas.dart';
import 'package:pom/blocs/pizzas/pizzas_states.dart';
import 'package:pom/blocs/settings/settings.dart';
import 'package:pom/firebase_options.dart';
import 'package:pom/models/settings_models.dart';
import 'package:pom/repositories/auth/auth.dart';
import 'package:pom/repositories/ingredient/ingredient.dart';
import 'package:pom/repositories/ingredients/ingredients.dart';
import 'package:pom/repositories/order/order.dart';
import 'package:pom/repositories/orders/orders.dart';
import 'package:pom/repositories/pizza/pizza.dart';
import 'package:pom/repositories/pizzas/pizzas.dart';
import 'package:pom/repositories/settings/settings.dart';
import 'package:pom/services/logger.dart';
import 'package:pom/theme/themes.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
// final navigatorKey = GlobalKey<NavigatorState>();

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
            BlocProvider<IngredientsBloc>(
              create: (BuildContext context) => IngredientsBloc(
                IngredientsRepository(),
                initialState: IngredientsInitialState(),
              ),
            ),
            BlocProvider<IngredientBloc>(
              create: (BuildContext context) => IngredientBloc(
                IngredientRepository(),
                initialState: IngredientInitialState(),
              ),
            ),
            BlocProvider<PizzasBloc>(
              create: (BuildContext context) => PizzasBloc(
                PizzasRepository(),
                initialState: PizzasInitialState(),
              ),
            ),
            BlocProvider<PizzaBloc>(
              create: (BuildContext context) => PizzaBloc(
                PizzaRepository(),
                initialState: PizzaInitialState(),
              ),
            ),
            BlocProvider<OrdersBloc>(
              create: (BuildContext context) => OrdersBloc(
                OrdersRepository(),
                initialState: OrdersInitialState(),
              ),
            ),
            BlocProvider<OrderBloc>(
              create: (BuildContext context) => OrderBloc(
                OrderRepository(),
                initialState: OrderInitialState(),
              ),
            ),
            BlocProvider<AuthBloc>(
              create: (BuildContext context) => AuthBloc(
                AuthRepository(),
                initialState: AuthInitialState(),
              ),
            ),
          ],
          child: MultiProvider(
            providers: <SingleChildWidget>[
              Provider<AppTheme>(
                create: (BuildContext context) => AppTheme(),
              ),
            ],
            child: POMApp(
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
