import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fom/main.dart';
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
          StreamBuilder<QuerySnapshot<Object?>>(
              stream: FirebaseFirestore.instance
                  .collection('meals')
                  // .orderBy('name')
                  .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
                  .snapshots(),
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot<Object?>> mealsSnapshot,
              ) {
                if (!mealsSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final List<Meal> meals = mealsSnapshot.data == null
                    ? <Meal>[]
                    : mealsSnapshot.data!.docs
                        .map(
                          (QueryDocumentSnapshot<Object?> e) => Meal.fromMap(
                              e.data() as Map<String, dynamic>,
                              e.reference.id, []),
                        )
                        .toList();

                return Column(
                  children: meals
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
              }),
        ],
      ),
    );
  }
}
