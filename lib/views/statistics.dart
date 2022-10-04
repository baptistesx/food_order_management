import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pom/blocs/orders/orders.dart';
import 'package:pom/blocs/orders/orders_events.dart';
import 'package:pom/blocs/orders/orders_states.dart';
import 'package:pom/blocs/pizzas/pizzas.dart';
import 'package:pom/blocs/pizzas/pizzas_states.dart';
import 'package:pom/models/order.dart';
import 'package:pom/models/pizza.dart';
import 'package:pom/widgets/custom_appbar.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (BuildContext context, OrdersState ordersState) {
            if (ordersState is OrdersFetchedState) {
              final List<Order> ordersDelivered = ordersState.orders
                  .where((Order order) => order.status == OrderStatus.delivered)
                  .toList();

              final List<Pizza> allOrdersDeliveredPizzas = ordersDelivered
                  .map((Order order) => order.pizzas)
                  .expand((List<Pizza> element) => element)
                  .toList();

              final double totalDayIncomes = allOrdersDeliveredPizzas.isEmpty
                  ? 0.0
                  : allOrdersDeliveredPizzas
                      .map(
                        (Pizza pizza) => pizza.isBig != null && pizza.isBig!
                            ? pizza.priceBig!
                            : pizza.priceSmall!,
                      )
                      .reduce(
                        (double value, double element) => value + element,
                      );

              return RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: () async {
                  context.read<OrdersBloc>().add(GetOrdersEvent());
                },
                child: ListView(
                  children: <Widget>[
                    Text(
                      'Total commandes livrées: ${ordersState.orders.isEmpty ? "0" : ordersDelivered.length}',
                    ),
                    Text(
                      'Total pizzas livrées: ${allOrdersDeliveredPizzas.length}',
                    ),
                    Text('CA total: ${totalDayIncomes.toString()}€'),
                    BlocBuilder<PizzasBloc, PizzasState>(
                      builder: (BuildContext context, PizzasState pizzasState) {
                        if (pizzasState is PizzasFetchedState) {
                          return Column(
                            children: pizzasState.pizzas
                                .map(
                                  (Pizza pizza) => allOrdersDeliveredPizzas
                                          .where(
                                            (Pizza element) =>
                                                element.id == pizza.id,
                                          )
                                          .isEmpty
                                      ? const SizedBox()
                                      : Card(
                                          child: ListTile(
                                            title: Text(
                                              '${allOrdersDeliveredPizzas.where((Pizza element) => element.id == pizza.id).length} x ${pizza.name}',
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
