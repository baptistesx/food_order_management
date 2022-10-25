import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fom/blocs/meal/meal.dart';
import 'package:fom/blocs/meal/meal_events.dart';
import 'package:fom/blocs/meal/meal_states.dart';
import 'package:fom/blocs/meals/meals.dart';
import 'package:fom/blocs/meals/meals_events.dart';
import 'package:fom/main.dart';
import 'package:fom/models/ingredient.dart';
import 'package:fom/models/meal.dart';
import 'package:fom/theme/themes.dart';
import 'package:fom/views/meal.dart';
import 'package:fom/widgets/confirm_action_dialog.dart';
import 'package:fom/widgets/custom_appbar.dart';
import 'package:fom/widgets/item_card.dart';

class MealsPage extends StatefulWidget {
  static const String routeName = '/meals';

  const MealsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MealsPage> createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('La carte'),
      ),
      body: BlocListener<MealBloc, MealState>(
        listener: (BuildContext context, MealState mealState) {
          if (mealState is MealDeletedState || mealState is MealUpdatedState) {
            context.read<MealsBloc>().add(
                  GetMealsEvent(),
                );
          }
        },
        child: StreamBuilder<QuerySnapshot<Object?>>(
            stream: FirebaseFirestore.instance
                .collection('ingredients')
                // .orderBy('name')
                .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
                .snapshots(),
            builder: (
              BuildContext context,
              AsyncSnapshot<QuerySnapshot<Object?>> ingredientsSnapshot,
            ) {
              return StreamBuilder<QuerySnapshot<Object?>>(
                  stream: FirebaseFirestore.instance
                      .collection('meals')
                      // .orderBy('name')
                      .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
                      .snapshots(),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Object?>> mealsSnapshot,
                  ) {
                    if (!ingredientsSnapshot.hasData ||
                        !mealsSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final List<Ingredient> ingredients =
                        ingredientsSnapshot.data == null
                            ? <Ingredient>[]
                            : ingredientsSnapshot.data!.docs
                                .map(
                                  (QueryDocumentSnapshot<Object?> e) =>
                                      Ingredient.fromMap(
                                    e.data() as Map<String, dynamic>,
                                    e.reference.id,
                                  ),
                                )
                                .toList();

                    final List<Meal> meals = mealsSnapshot.data == null
                        ? <Meal>[]
                        : mealsSnapshot.data!.docs
                            .map(
                              (QueryDocumentSnapshot<Object?> e) =>
                                  Meal.fromMap(e.data() as Map<String, dynamic>,
                                      e.reference.id, ingredients),
                            )
                            .toList();

                    meals.sort(
                      (a, b) => a.name == null || b.name == null
                          ? -1
                          : a.name!.compareTo(b.name!),
                    );

                    return ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 24),
                      children: meals.isEmpty
                          ? <Widget>[const Text('Aucun élément trouvé.')]
                          : meals
                              .map(
                                (Meal meal) => ItemCard(
                                  item: meal,
                                  onDelete: () async {
                                    // ignore: always_specify_types
                                    final shouldDelete = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const ConfirmActionDialog();
                                      },
                                    );
                                    if (shouldDelete != null && shouldDelete) {
                                      if (meal.id != null && mounted) {
                                        context.read<MealBloc>().add(
                                              DeleteMealByIdEvent(meal.id!),
                                            );
                                      }
                                    }
                                  },
                                  onEdit: () {
                                    Navigator.pushNamed(
                                      context,
                                      MealPage.routeName,
                                      arguments: <String, dynamic>{
                                        'meal': meal
                                      },
                                    );
                                  },
                                ),
                              )
                              .toList(),
                    );
                  });
            }),

        //  BlocBuilder<MealsBloc, MealsState>(
        //   builder: (BuildContext context, MealsState mealsState) {
        //     if (mealsState is MealsLoadingState) {
        //       return const Center(child: CircularProgressIndicator());
        //     } else if (mealsState is MealsFetchedState) {
        //       return RefreshIndicator(
        //         key: _refreshIndicatorKey,
        //         onRefresh: () async {
        //           context.read<MealsBloc>().add(GetMealsEvent());
        //         },
        //         child: ListView(
        //           padding:
        //               const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        //           children: mealsState.meals.isEmpty
        //               ? <Widget>[const Text('Aucun élément trouvé.')]
        //               : mealsState.meals
        //                   .map(
        //                     (Meal meal) => ItemCard(
        //                       item: meal,
        //                       onDelete: () async {
        //                         // ignore: always_specify_types
        //                         final shouldDelete = await showDialog(
        //                           context: context,
        //                           builder: (BuildContext context) {
        //                             return const ConfirmActionDialog();
        //                           },
        //                         );
        //                         if (shouldDelete != null && shouldDelete) {
        //                           if (meal.id != null && mounted) {
        //                             context.read<MealBloc>().add(
        //                                   DeleteMealByIdEvent(meal.id!),
        //                                 );
        //                           }
        //                         }
        //                       },
        //                       onEdit: () {
        //                         Navigator.pushNamed(
        //                           context,
        //                           MealPage.routeName,
        //                           arguments: <String, dynamic>{'meal': meal},
        //                         );
        //                       },
        //                     ),
        //                   )
        //                   .toList(),
        //         ),
        //       );
        //     } else {
        //       return const Center(
        //         child: Text('Erreur'),
        //       );
        //     }
        //   },
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.themeColors.secondaryColor,
        onPressed: () {
          Navigator.pushNamed(context, MealPage.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
