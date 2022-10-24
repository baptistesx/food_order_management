import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fom/blocs/order/order.dart';
import 'package:fom/blocs/order/order_events.dart';
import 'package:fom/models/ingredient.dart';
import 'package:fom/models/order.dart';
import 'package:fom/models/pizza.dart';
import 'package:fom/views/order.dart';

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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Object?>>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .orderBy('timeToDeliver')
          .snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
      ) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final List<Order> orders = snapshot.data == null
            ? <Order>[]
            : snapshot.data!.docs
                .map(
                  (QueryDocumentSnapshot<Object?> e) => Order.fromMap(
                    e.data() as Map<String, dynamic>,
                    e.reference.id,
                  ),
                )
                .toList()
                .where((Order order) => order.status == widget.status)
                .toList();

        return ListView(
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
                                arguments: <String, dynamic>{'order': order},
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          if (widget.status == OrderStatus.done)
                            ElevatedButton(
                              onPressed: () {
                                context.read<OrderBloc>().add(
                                      UpdateOrderByIdEvent(
                                        order.copyWith(
                                          status: OrderStatus.delivered,
                                        ),
                                      ),
                                    );
                              },
                              child: const Text('Livrée'),
                            ),
                        ],
                      ),
                      title: Text(
                        '♯${order.id!.substring(0, 4)} - ${order.clientName}',
                      ),
                      subtitle: Wrap(
                        children: <Widget>[
                          Chip(
                            label: Text(
                              '${order.timeToDeliver.hour}:${order.timeToDeliver.minute}',
                            ),
                          ),
                          const SizedBox(width: 5),
                          Chip(
                            label: Text(
                              '${order.pizzas.length.toString()} pizzas (${order.pizzas.where((Pizza pizza) => pizza.isBig != null && pizza.isBig!).length} grande(s), ${order.pizzas.where((Pizza pizza) => pizza.isBig == null || !pizza.isBig!).length} petite(s))',
                            ),
                          ),
                          const SizedBox(width: 5),
                          Chip(
                            label: Text(
                              order.pizzas.isEmpty
                                  ? '0'
                                  : '${order.pizzas.map((Pizza pizza) => pizza.isBig != null && pizza.isBig! ? pizza.priceBig : pizza.priceSmall).reduce((double? value, double? element) => value! + element!).toString()}€',
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
                              isChecked: pizza.isDone != null && pizza.isDone!,
                              onCheck: (bool? isChecked) {
                                if (isChecked != null && isChecked) {
                                  if (order.pizzas
                                          .where(
                                            (Pizza e) =>
                                                e.isDone != null && e.isDone!,
                                          )
                                          .toList()
                                          .length ==
                                      order.pizzas.length - 1) {
                                    context.read<OrderBloc>().add(
                                          UpdateOrderByIdEvent(
                                            order.copyWith(
                                              status: OrderStatus.done,
                                              pizzas: List<Pizza>.from(
                                                order.pizzas
                                                    .map((Pizza pizzaToUpdate) {
                                                  if (pizzaToUpdate.hashCode ==
                                                      pizza.hashCode) {
                                                    return pizzaToUpdate
                                                        .copyWith(isDone: true);
                                                  } else {
                                                    return pizzaToUpdate;
                                                  }
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        );
                                  } else {
                                    context.read<OrderBloc>().add(
                                          UpdateOrderByIdEvent(
                                            order.copyWith(
                                              pizzas: List<Pizza>.from(
                                                order.pizzas
                                                    .map((Pizza pizzaToUpdate) {
                                                  if (pizzaToUpdate.hashCode ==
                                                      pizza.hashCode) {
                                                    return pizzaToUpdate
                                                        .copyWith(
                                                      isDone: true,
                                                    );
                                                  } else {
                                                    return pizzaToUpdate;
                                                  }
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        );
                                  }
                                } else {
                                  if (widget.status != OrderStatus.toDo) {
                                    context.read<OrderBloc>().add(
                                          UpdateOrderByIdEvent(
                                            order.copyWith(
                                              status: OrderStatus.toDo,
                                              pizzas: List<Pizza>.from(
                                                order.pizzas
                                                    .map((Pizza pizzaToUpdate) {
                                                  if (pizzaToUpdate.hashCode ==
                                                      pizza.hashCode) {
                                                    return pizzaToUpdate
                                                        .copyWith(
                                                      isDone: false,
                                                    );
                                                  } else {
                                                    return pizzaToUpdate;
                                                  }
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        );
                                  } else {
                                    context.read<OrderBloc>().add(
                                          UpdateOrderByIdEvent(
                                            order.copyWith(
                                              pizzas: List<Pizza>.from(
                                                order.pizzas
                                                    .map((Pizza pizzaToUpdate) {
                                                  if (pizzaToUpdate.hashCode ==
                                                      pizza.hashCode) {
                                                    return pizzaToUpdate
                                                        .copyWith(
                                                      isDone: false,
                                                    );
                                                  } else {
                                                    return pizzaToUpdate;
                                                  }
                                                }).toList(),
                                              ),
                                            ),
                                          ),
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
        );
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
        leading: Text(
          '$count x ${pizza.isBig != null && pizza.isBig! ? "Grande" : "Petite"}',
        ),
        title: Text(pizza.name ?? 'Error'),
        subtitle: Wrap(
          children: <Widget>[
            if (pizza.ingredientsToAdd!.isNotEmpty ||
                pizza.ingredientsToRemove!.isNotEmpty)
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
              ),
            // Text(pizza.name ?? 'Error'),
            const SizedBox(width: 8),
            if (pizza.ingredientsToRemove!.isNotEmpty)
              Text(
                pizza.ingredientsToRemove!
                    .map(
                      (Ingredient ingredient) => ingredient.name,
                    )
                    .toList()
                    .toString()
                    .replaceFirst('[', '')
                    .replaceFirst(']', ''),
                style: TextStyle(
                  color: Colors.red[300],
                  decoration: TextDecoration.lineThrough,
                  decorationThickness: 2,
                ),
              ),
            const SizedBox(width: 8),
            if (pizza.ingredientsToAdd!.isNotEmpty)
              Text(
                pizza.ingredientsToAdd!
                    .map(
                      (Ingredient ingredient) => ingredient.name,
                    )
                    .toList()
                    .toString()
                    .replaceFirst('[', '')
                    .replaceFirst(']', ''),
                style: TextStyle(
                  color: Colors.blue[300],
                  decoration: TextDecoration.underline,
                  decorationThickness: 3,
                ),
              )
          ],
        ),
        trailing: Checkbox(value: isChecked, onChanged: onCheck),
      ),
    );
  }
}
