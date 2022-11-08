import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fom/app.dart';
import 'package:fom/blocs/auth/auth.dart';
import 'package:fom/blocs/auth/auth_states.dart';
import 'package:fom/blocs/ingredient/ingredient.dart';
import 'package:fom/blocs/ingredient/ingredient_states.dart';
import 'package:fom/blocs/ingredients/ingredients.dart';
import 'package:fom/blocs/ingredients/ingredients_states.dart';
import 'package:fom/blocs/meal/meal.dart';
import 'package:fom/blocs/meal/meal_states.dart';
import 'package:fom/blocs/meals/meals.dart';
import 'package:fom/blocs/meals/meals_states.dart';
import 'package:fom/blocs/order/order.dart';
import 'package:fom/blocs/order/order_states.dart';
import 'package:fom/blocs/orders/orders.dart';
import 'package:fom/blocs/orders/orders_states.dart';
import 'package:fom/blocs/settings/settings.dart';
import 'package:fom/blocs/suggestion/suggestion.dart';
import 'package:fom/blocs/suggestion/suggestion_states.dart';
import 'package:fom/firebase_options.dart';
import 'package:fom/models/settings_models.dart';
import 'package:fom/repositories/auth/auth.dart';
import 'package:fom/repositories/ingredient/ingredient.dart';
import 'package:fom/repositories/ingredients/ingredients.dart';
import 'package:fom/repositories/meal/meal.dart';
import 'package:fom/repositories/meals/meals.dart';
import 'package:fom/repositories/order/order.dart';
import 'package:fom/repositories/orders/orders.dart';
import 'package:fom/repositories/settings/settings.dart';
import 'package:fom/repositories/suggestion/suggestion.dart';
import 'package:fom/services/logger.dart';
import 'package:fom/theme/themes.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

bool isVersionChecked = false;

Future<void> main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

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
            BlocProvider<MealsBloc>(
              create: (BuildContext context) => MealsBloc(
                MealsRepository(),
                initialState: MealsInitialState(),
              ),
            ),
            BlocProvider<MealBloc>(
              create: (BuildContext context) => MealBloc(
                MealRepository(),
                initialState: MealInitialState(),
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
            BlocProvider<SuggestionBloc>(
              create: (BuildContext context) => SuggestionBloc(
                SuggestionRepository(),
                initialState: SuggestionInitialState(),
              ),
            ),
          ],
          child: MultiProvider(
            providers: <SingleChildWidget>[
              Provider<AppTheme>(
                create: (BuildContext context) => AppTheme(),
              ),
            ],
            child: FOMApp(
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
