import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fom/blocs/meals/meals.dart';
import 'package:fom/blocs/meals/meals_states.dart';
import 'package:fom/models/day_statistics.dart';
import 'package:fom/models/meal.dart';
import 'package:fom/theme/themes.dart';
import 'package:intl/intl.dart';

class DayStatisticsCard extends StatelessWidget {
  final DayStatistics dayStatistics;

  const DayStatisticsCard({
    Key? key,
    required this.dayStatistics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: const Color(0xffececec),
      child: Column(
        children: <Widget>[
          Text(
            DateFormat('d MMMM y', 'fr_FR').format(dayStatistics.date),
            style: context.theme.textTheme.headline5,
          ),
          Text(
            'Total commandes livrées: ${dayStatistics.ordersDelivered.isEmpty ? "0" : dayStatistics.ordersDelivered.length}',
          ),
          // Text(
          //   'Total meals livrées: ${dayStatistics.allOrdersDeliveredMeals.length}',
          // ),
          Text('CA total: ${dayStatistics.totalDayIncomes.toString()}€'),
          BlocBuilder<MealsBloc, MealsState>(
            builder: (BuildContext context, MealsState mealsState) {
              if (mealsState is MealsFetchedState) {
                return Column(
                  children: mealsState.meals
                      .map(
                        (Meal meal) => dayStatistics.allOrdersDeliveredMeals
                                .where(
                                  (Meal element) => element.id == meal.id,
                                )
                                .isEmpty
                            ? const SizedBox()
                            : Card(
                                child: ListTile(
                                  title: Text(
                                    '${dayStatistics.allOrdersDeliveredMeals.where((Meal element) => element.id == meal.id).length} x ${meal.name}',
                                  ),
                                ),
                              ),
                      )
                      .toList(),
                );
              } else {
                return (const Center(
                  child: Text('Erreur'),
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}
