import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pom/blocs/orders/orders.dart';
import 'package:pom/blocs/orders/orders_events.dart';
import 'package:pom/blocs/orders/orders_states.dart';
import 'package:pom/models/ingredient.dart';
import 'package:pom/models/order.dart';
import 'package:pom/models/pizza.dart';
import 'package:pom/views/order.dart';

class OrderTab extends StatefulWidget {
  final OrderStatus status;

  const OrderTab({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  State<OrderTab> createState() => _OrderTabState();
}

class _OrderTabState extends State<OrderTab> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (BuildContext context, OrdersState ordersState) {
        if (ordersState is OrdersFetchedState) {
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async {
              context.read<OrdersBloc>().add(GetOrdersEvent());
            },
            child: ListView(
              children: <Widget>[
                ...ordersState.orders
                    .map(
                      (Order order) => Card(
                        child: ExpansionTile(
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <IconButton>[
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    OrderPage.routeName,
                                    arguments: <String, dynamic>{
                                      'order': order
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit),
                              ),
                            ],
                          ),
                          title: Text(
                            '♯${order.id!.substring(0, 4)} - ${order.clientName}',
                          ),
                          subtitle: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Chip>[
                              Chip(
                                label: Text(
                                  '${order.timeToDeliver.hour}:${order.timeToDeliver.minute}',
                                ),
                              ),
                              Chip(
                                label: Text(order.pizzas.length.toString()),
                              ),
                              Chip(
                                label: Text(
                                  order.pizzas.isEmpty
                                      ? '0'
                                      : '${order.pizzas.map((Pizza pizza) => pizza.price).reduce((double? value, double? element) => value! + element!).toString()}€',
                                ),
                              ),
                            ],
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          children: order.pizzas
                              .map(
                                (Pizza pizza) => OrderPizzaCard(
                                  pizza: pizza,
                                  count: 1,
                                  isChecked: true,
                                  onCheck: (bool? isChecked) {},
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    )
                    .toList()
              ],
            ),
          );
        } else if (ordersState is OrdersLoadingState) {
          return (const Center(
            child: CircularProgressIndicator(),
          ));
        } else {
          return const Text('Erreur');
        }
      },
    );
  }
}

class OrderPizzaCard extends StatelessWidget {
  final Pizza pizza;
  final int count;
  final bool isChecked;
  final void Function(bool?) onCheck;

  const OrderPizzaCard({
    Key? key,
    required this.pizza,
    required this.count,
    required this.isChecked,
    required this.onCheck,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text('$count x '),
        title: Text(pizza.name ?? 'Error'),
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (pizza.ingredientsToAdd!.isNotEmpty ||
                pizza.ingredientsToRemove!.isNotEmpty)
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
              ),
            Text(pizza.name ?? 'Error'),
            if (pizza.ingredientsToRemove!.isNotEmpty)
              Text(
                pizza.ingredientsToRemove!
                    .map(
                      (Ingredient ingredient) => ingredient.name,
                    )
                    .toList()
                    .toString(),
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            if (pizza.ingredientsToAdd!.isNotEmpty)
              Text(
                pizza.ingredientsToAdd!
                    .map(
                      (Ingredient ingredient) => ingredient.name,
                    )
                    .toList()
                    .toString(),
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),
              )
          ],
        ),
        trailing: Checkbox(value: isChecked, onChanged: onCheck),
      ),
    );
  }
}
