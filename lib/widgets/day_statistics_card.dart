import 'package:flutter/material.dart';
import 'package:fom/models/day_statistics.dart';
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
    Map<String, int> countedMeals = {};
    for (int i = 0; i < dayStatistics.allOrdersDeliveredMeals.length; i++) {
      countedMeals[dayStatistics.allOrdersDeliveredMeals[i].name!] =
          countedMeals[dayStatistics.allOrdersDeliveredMeals[i].name] == null
              ? 1
              : countedMeals[dayStatistics.allOrdersDeliveredMeals[i].name!]! +
                  1;
    }

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
          Column(
            children: countedMeals.keys
                .map(
                  (String key) => Card(
                    child: ListTile(
                      title: Text(
                        '${countedMeals[key]} x $key',
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
