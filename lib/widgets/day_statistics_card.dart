import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pom/blocs/pizzas/pizzas.dart';
import 'package:pom/blocs/pizzas/pizzas_states.dart';
import 'package:pom/models/day_statistics.dart';
import 'package:pom/models/pizza.dart';
import 'package:pom/theme/themes.dart';

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
          Text(
            'Total pizzas livrées: ${dayStatistics.allOrdersDeliveredPizzas.length}',
          ),
          Text('CA total: ${dayStatistics.totalDayIncomes.toString()}€'),
          BlocBuilder<PizzasBloc, PizzasState>(
            builder: (BuildContext context, PizzasState pizzasState) {
              if (pizzasState is PizzasFetchedState) {
                return Column(
                  children: pizzasState.pizzas
                      .map(
                        (Pizza pizza) => dayStatistics.allOrdersDeliveredPizzas
                                .where(
                                  (Pizza element) => element.id == pizza.id,
                                )
                                .isEmpty
                            ? const SizedBox()
                            : Card(
                                child: ListTile(
                                  title: Text(
                                    '${dayStatistics.allOrdersDeliveredPizzas.where((Pizza element) => element.id == pizza.id).length} x ${pizza.name}',
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
