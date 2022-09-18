import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pom/blocs/orders/orders.dart';
import 'package:pom/blocs/orders/orders_states.dart';
import 'package:pom/models/ingredient.dart';
import 'package:pom/models/order.dart';
import 'package:pom/models/pizza.dart';

class OrderTab extends StatelessWidget {
  final OrderStatus status;

  const OrderTab({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (BuildContext context, OrdersState ordersState) {
        if (ordersState is OrdersFetchedState) {
          return ListView(
            children: <Widget>[
              ...ordersState.orders
                  .map(
                    (Order order) => Card(
                      child: ExpansionTile(
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <IconButton>[
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.remove_circle_outline),
                            )
                          ],
                        ),
                        title: Text('♯${order.id} - ${order.clientName}'),
                        subtitle: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Chip>[
                            Chip(
                              label: Text(order.timeToDeliver.toString()),
                            ),
                            Chip(
                              label: Text(order.pizzas.length.toString()),
                            ),
                            Chip(
                              label: Text(
                                '${order.pizzas.map((Pizza pizza) => pizza.price).reduce((double? value, double? element) => value! + element!).toString()}€',
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
        subtitle: Text(
          pizza.ingredients == null
              ? 'Erreur'
              : pizza.ingredients!
                  .map((Ingredient ingredient) => ingredient.name)
                  .toString(),
        ),
        trailing: Checkbox(value: isChecked, onChanged: onCheck),
      ),
    );
  }
}
