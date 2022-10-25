import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fom/blocs/order/order.dart';
import 'package:fom/blocs/order/order_events.dart';
import 'package:fom/main.dart';
import 'package:fom/models/ingredient.dart';
import 'package:fom/models/meal.dart';
import 'package:fom/models/order.dart';
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
        AsyncSnapshot<QuerySnapshot<Object?>> ordersSnapshot,
      ) {
        return StreamBuilder<QuerySnapshot<Object?>>(
            stream: FirebaseFirestore.instance
                .collection('ingredients')
                // .orderBy('name')
                .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
                .snapshots(),
            builder: (
              BuildContext context,
              AsyncSnapshot<QuerySnapshot<Object?>> ingredientsSnapshot,
            ) {
              if (!ordersSnapshot.hasData && !ingredientsSnapshot.hasData) {
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
                        (QueryDocumentSnapshot<Object?> e) => Order.fromMap(
                            e.data() as Map<String, dynamic>,
                            e.reference.id,
                            ingredients),
                      )
                      .toList();

              return ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  children: orders
                          .where((Order order) => order.status == widget.status)
                          .toList()
                          .isEmpty
                      ? <Widget>[const Text('Aucune commande trouvée.')]
                      : orders
                          .where((Order order) => order.status == widget.status)
                          .toList()
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
                                          context.read<OrderBloc>().add(
                                                UpdateOrderByIdEvent(
                                                  order.copyWith(
                                                    status:
                                                        OrderStatus.delivered,
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
                                        '${order.meals.length.toString()} éléments (${order.meals.where((Meal meal) => meal.isBig != null && meal.isBig!).length} grande(s), ${order.meals.where((Meal meal) => meal.isBig == null || !meal.isBig!).length} petite(s))',
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Chip(
                                      label: Text(
                                        order.meals.isEmpty
                                            ? '0'
                                            : '${order.meals.map((Meal meal) => meal.isBig != null && meal.isBig! ? meal.priceBig : meal.priceSmall).reduce((double? value, double? element) => value! + element!).toString()}€',
                                      ),
                                    ),
                                  ],
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                children: order.meals
                                    .map(
                                      (Meal meal) => OrderMealCard(
                                        meal: meal,
                                        count: 1,
                                        isChecked:
                                            meal.isDone != null && meal.isDone!,
                                        onCheck: (bool? isChecked) {
                                          if (isChecked != null && isChecked) {
                                            if (order.meals
                                                    .where(
                                                      (Meal e) =>
                                                          e.isDone != null &&
                                                          e.isDone!,
                                                    )
                                                    .toList()
                                                    .length ==
                                                order.meals.length - 1) {
                                              context.read<OrderBloc>().add(
                                                    UpdateOrderByIdEvent(
                                                      order.copyWith(
                                                        status:
                                                            OrderStatus.done,
                                                        meals: List<Meal>.from(
                                                          order.meals.map((Meal
                                                              mealToUpdate) {
                                                            if (mealToUpdate
                                                                    .hashCode ==
                                                                meal.hashCode) {
                                                              return mealToUpdate
                                                                  .copyWith(
                                                                      isDone:
                                                                          true);
                                                            } else {
                                                              return mealToUpdate;
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
                                                        meals: List<Meal>.from(
                                                          order.meals.map((Meal
                                                              mealToUpdate) {
                                                            if (mealToUpdate
                                                                    .hashCode ==
                                                                meal.hashCode) {
                                                              return mealToUpdate
                                                                  .copyWith(
                                                                isDone: true,
                                                              );
                                                            } else {
                                                              return mealToUpdate;
                                                            }
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                            }
                                          } else {
                                            if (widget.status !=
                                                OrderStatus.toDo) {
                                              context.read<OrderBloc>().add(
                                                    UpdateOrderByIdEvent(
                                                      order.copyWith(
                                                        status:
                                                            OrderStatus.toDo,
                                                        meals: List<Meal>.from(
                                                          order.meals.map((Meal
                                                              mealToUpdate) {
                                                            if (mealToUpdate
                                                                    .hashCode ==
                                                                meal.hashCode) {
                                                              return mealToUpdate
                                                                  .copyWith(
                                                                isDone: false,
                                                              );
                                                            } else {
                                                              return mealToUpdate;
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
                                                        meals: List<Meal>.from(
                                                          order.meals.map((Meal
                                                              mealToUpdate) {
                                                            if (mealToUpdate
                                                                    .hashCode ==
                                                                meal.hashCode) {
                                                              return mealToUpdate
                                                                  .copyWith(
                                                                isDone: false,
                                                              );
                                                            } else {
                                                              return mealToUpdate;
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
                          .toList());
            });
      },
    );
  }
}

class OrderMealCard extends StatelessWidget {
  final Meal meal;
  final int count;
  final bool isChecked;
  final void Function(bool?) onCheck;

  const OrderMealCard({
    Key? key,
    required this.meal,
    required this.count,
    required this.isChecked,
    required this.onCheck,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text(
          '$count x ${meal.isBig != null && meal.isBig! ? "Grande" : "Petite"}',
        ),
        title: Text(meal.name ?? 'Error'),
        subtitle: Wrap(
          children: <Widget>[
            if (meal.ingredientsToAdd!.isNotEmpty ||
                meal.ingredientsToRemove!.isNotEmpty)
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
              ),
            // Text(meal.name ?? 'Error'),
            const SizedBox(width: 8),
            if (meal.ingredientsToRemove!.isNotEmpty)
              Text(
                meal.ingredientsToRemove!
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
            if (meal.ingredientsToAdd!.isNotEmpty)
              Text(
                meal.ingredientsToAdd!
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
