import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fom/blocs/orders/orders.dart';
import 'package:fom/blocs/orders/orders_events.dart';
import 'package:fom/blocs/orders/orders_states.dart';
import 'package:fom/models/day_statistics.dart';
import 'package:fom/models/order.dart';
import 'package:fom/models/pizza.dart';
import 'package:fom/widgets/custom_appbar.dart';
import 'package:fom/widgets/day_statistics_card.dart';

class StatisticsPage extends StatefulWidget {
  static const String routeName = '/statistics';

  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: Text('Statistiques')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (BuildContext context, OrdersState ordersState) {
            if (ordersState is OrdersFetchedState) {
              final List<DayStatistics> dayStatistics = <DayStatistics>[];

              final List<Order> ordersDelivered = ordersState.orders
                  .where((Order order) => order.status == OrderStatus.delivered)
                  .toList();

              for (int i = 0; i < ordersDelivered.length; i++) {
                if (dayStatistics
                    .where(
                      (DayStatistics day) =>
                          day.date.year == ordersDelivered[i].createdAt.year &&
                          day.date.month ==
                              ordersDelivered[i].createdAt.month &&
                          day.date.day == ordersDelivered[i].createdAt.day,
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
                      allOrdersDeliveredPizzas: <Pizza>[],
                      totalDayIncomes: 0,
                    ),
                  );
                } else {
                  dayStatistics[dayStatistics.indexWhere(
                    (DayStatistics day) =>
                        day.date.year == ordersDelivered[i].createdAt.year &&
                        day.date.month == ordersDelivered[i].createdAt.month &&
                        day.date.day == ordersDelivered[i].createdAt.day,
                  )]
                      .ordersDelivered
                      .add(ordersDelivered[i]);
                }
              }

              for (int i = 0; i < dayStatistics.length; i++) {
                dayStatistics[i].allOrdersDeliveredPizzas = dayStatistics[i]
                    .ordersDelivered
                    .map((Order order) => order.pizzas)
                    .expand((List<Pizza> element) => element)
                    .toList();

                dayStatistics[i].totalDayIncomes =
                    dayStatistics[i].allOrdersDeliveredPizzas.isEmpty
                        ? 0.0
                        : dayStatistics[i]
                            .allOrdersDeliveredPizzas
                            .map(
                              (Pizza pizza) =>
                                  pizza.isBig != null && pizza.isBig!
                                      ? pizza.priceBig!
                                      : pizza.priceSmall!,
                            )
                            .reduce(
                              (double value, double element) => value + element,
                            );
              }

              return RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: () async {
                  context.read<OrdersBloc>().add(GetOrdersEvent());
                },
                child: ListView(
                  children: <Widget>[
                    const SizedBox(height: 24),
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
                ),
              );
            } else if (ordersState is OrdersLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Center(
                child: Text('Erreur'),
              );
            }
          },
        ),
      ),
    );
  }
}
