import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fom/main.dart';
import 'package:fom/models/day_statistics.dart';
import 'package:fom/models/ingredient.dart';
import 'package:fom/models/meal.dart';
import 'package:fom/models/order.dart';
import 'package:fom/widgets/custom_appbar.dart';
import 'package:fom/widgets/day_statistics_card.dart';

class StatisticsPage extends StatefulWidget {
  static const String routeName = '/statistics';

  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: Text('Statistiques')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: StreamBuilder<QuerySnapshot<Object?>>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
                  // .orderBy('timeToDeliver')
                  .snapshots(),
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot<Object?>> ordersSnapshot,
              ) {
                return StreamBuilder<QuerySnapshot<Object?>>(
                    stream: FirebaseFirestore.instance
                        .collection('ingredients')
                        // .orderBy('name')
                        .where('userId',
                            isEqualTo: firebaseAuth.currentUser!.uid)
                        .snapshots(),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Object?>> ingredientsSnapshot,
                    ) {
                      if (!ordersSnapshot.hasData ||
                          !ingredientsSnapshot.hasData) {
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

                      final List<Order> orders = ordersSnapshot.data == null
                          ? <Order>[]
                          : ordersSnapshot.data!.docs
                              .map(
                                (QueryDocumentSnapshot<Object?> e) =>
                                    Order.fromMap(
                                        e.data() as Map<String, dynamic>,
                                        e.reference.id,
                                        ingredients),
                              )
                              .toList();

                      final List<DayStatistics> dayStatistics =
                          <DayStatistics>[];

                      final List<Order> ordersDelivered = orders
                          .where((Order order) =>
                              order.status == OrderStatus.delivered)
                          .toList();

                      for (int i = 0; i < ordersDelivered.length; i++) {
                        if (dayStatistics
                            .where(
                              (DayStatistics day) =>
                                  day.date.year ==
                                      ordersDelivered[i].createdAt.year &&
                                  day.date.month ==
                                      ordersDelivered[i].createdAt.month &&
                                  day.date.day ==
                                      ordersDelivered[i].createdAt.day,
                            )
                            .isEmpty) {
                          dayStatistics.add(
                            DayStatistics(
                              date: DateTime(
                                ordersDelivered[i].createdAt.year,
                                ordersDelivered[i].createdAt.month,
                                ordersDelivered[i].createdAt.day,
                              ),
                              ordersDelivered: <Order>[ordersDelivered[i]],
                              allOrdersDeliveredMeals: <Meal>[],
                              totalDayIncomes: 0,
                            ),
                          );
                        } else {
                          dayStatistics[dayStatistics.indexWhere(
                            (DayStatistics day) =>
                                day.date.year ==
                                    ordersDelivered[i].createdAt.year &&
                                day.date.month ==
                                    ordersDelivered[i].createdAt.month &&
                                day.date.day ==
                                    ordersDelivered[i].createdAt.day,
                          )]
                              .ordersDelivered
                              .add(ordersDelivered[i]);
                        }
                      }

                      for (int i = 0; i < dayStatistics.length; i++) {
                        dayStatistics[i].allOrdersDeliveredMeals =
                            dayStatistics[i]
                                .ordersDelivered
                                .map((Order order) => order.meals)
                                .expand((List<Meal> element) => element)
                                .toList();

                        dayStatistics[i].totalDayIncomes =
                            dayStatistics[i].allOrdersDeliveredMeals.isEmpty
                                ? 0.0
                                : dayStatistics[i]
                                    .allOrdersDeliveredMeals
                                    .map(
                                      (Meal meal) =>
                                          meal.isBig != null && meal.isBig!
                                              ? meal.priceBig!
                                              : meal.priceSmall!,
                                    )
                                    .reduce(
                                      (double value, double element) =>
                                          value + element,
                                    );
                      }

                      return ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 24),
                        children: dayStatistics.isEmpty
                            ? <Widget>[const Text('Aucune vente trouvée.')]
                            : <Widget>[
                                ...dayStatistics
                                    .map(
                                      (DayStatistics e) => <Widget>[
                                        DayStatisticsCard(dayStatistics: e),
                                        const SizedBox(height: 24)
                                      ],
                                    )
                                    .expand((List<Widget> element) => element)
                                    .toList(),
                                const SizedBox(height: 24),
                              ],
                      );
                    });
              }),
        ));
  }
}
