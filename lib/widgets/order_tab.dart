import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pom/blocs/order/order.dart';
import 'package:pom/blocs/order/order_events.dart';
import 'package:pom/blocs/order/order_states.dart';
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
          List<Order> orders = ordersState.orders
              .where((order) => order.status == widget.status)
              .toList();

          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async {
              context.read<OrdersBloc>().add(GetOrdersEvent());
            },
            child: BlocListener<OrderBloc, OrderState>(
              listener: (BuildContext context, OrderState orderState) {
                if (orderState is OrderUpdatedState) {
                  context.read<OrdersBloc>().add(UpdateOrdersEvent(ordersState
                      .orders
                      .map((Order order) =>
                          order.id == orderState.orderUpdated.id
                              ? orderState.orderUpdated
                              : order)
                      .toList()));
                }
              },
              child: ListView(
                children: <Widget>[
                  ...orders
                      .map(
                        (Order order) => Card(
                          child: ExpansionTile(
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
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
                                if (widget.status == OrderStatus.done)
                                  ElevatedButton(
                                      onPressed: () {
                                        print('pass order to delivered');
                                        context.read<OrderBloc>().add(
                                              UpdateOrderByIdEvent(
                                                  order.copyWith(
                                                      status: OrderStatus
                                                          .delivered)),
                                            );
                                      },
                                      child: Text('Livré')),
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
                                    isChecked:
                                        pizza.isDone != null && pizza.isDone!,
                                    onCheck: (bool? isChecked) {
                                      if (isChecked != null && isChecked) {
                                        if (order.pizzas
                                                .where((e) =>
                                                    e.isDone != null &&
                                                    e.isDone!)
                                                .toList()
                                                .length ==
                                            order.pizzas.length - 1) {
                                          print('change to Done pizzas');
                                          context.read<OrderBloc>().add(
                                                UpdateOrderByIdEvent(
                                                    order.copyWith(
                                                        status:
                                                            OrderStatus.done,
                                                        pizzas: List<
                                                                Pizza>.from(
                                                            order.pizzas.map((Pizza
                                                                pizzaToUpdate) {
                                                          if (pizzaToUpdate
                                                                  .id ==
                                                              pizza.id) {
                                                            return pizzaToUpdate
                                                                .copyWith(
                                                                    isDone:
                                                                        true);
                                                          } else {
                                                            return pizzaToUpdate;
                                                          }
                                                        }).toList()))),
                                              );
                                        } else {
                                          context.read<OrderBloc>().add(
                                                UpdateOrderByIdEvent(
                                                    order.copyWith(
                                                        pizzas: List<
                                                                Pizza>.from(
                                                            order.pizzas.map((Pizza
                                                                pizzaToUpdate) {
                                                  if (pizzaToUpdate.id ==
                                                      pizza.id) {
                                                    return pizzaToUpdate
                                                        .copyWith(isDone: true);
                                                  } else {
                                                    return pizzaToUpdate;
                                                  }
                                                }).toList()))),
                                              );
                                        }
                                      } else {
                                        if (widget.status != OrderStatus.toDo) {
                                          context.read<OrderBloc>().add(
                                                UpdateOrderByIdEvent(
                                                    order.copyWith(
                                                        status:
                                                            OrderStatus.toDo,
                                                        pizzas: List<
                                                                Pizza>.from(
                                                            order.pizzas.map((Pizza
                                                                pizzaToUpdate) {
                                                          if (pizzaToUpdate
                                                                  .id ==
                                                              pizza.id) {
                                                            return pizzaToUpdate
                                                                .copyWith(
                                                                    isDone:
                                                                        false);
                                                          } else {
                                                            return pizzaToUpdate;
                                                          }
                                                        }).toList()))),
                                              );
                                        } else {
                                          context.read<OrderBloc>().add(
                                                UpdateOrderByIdEvent(
                                                    order.copyWith(
                                                        pizzas: List<
                                                                Pizza>.from(
                                                            order.pizzas.map((Pizza
                                                                pizzaToUpdate) {
                                                  if (pizzaToUpdate.id ==
                                                      pizza.id) {
                                                    return pizzaToUpdate
                                                        .copyWith(
                                                            isDone: false);
                                                  } else {
                                                    return pizzaToUpdate;
                                                  }
                                                }).toList()))),
                                              );
                                        }
                                      }
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      )
                      .toList()
                ],
              ),
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
