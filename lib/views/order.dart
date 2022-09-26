import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pom/blocs/order/order.dart';
import 'package:pom/blocs/order/order_events.dart';
import 'package:pom/blocs/order/order_states.dart';
import 'package:pom/blocs/orders/orders.dart';
import 'package:pom/blocs/orders/orders_events.dart';
import 'package:pom/blocs/pizzas/pizzas.dart';
import 'package:pom/blocs/pizzas/pizzas_states.dart';
import 'package:pom/models/ingredient.dart';
import 'package:pom/models/order.dart';
import 'package:pom/models/pizza.dart';
import 'package:pom/widgets/add_pizza_to_order_dialog.dart';
import 'package:pom/widgets/layout/scrollable_column_space_between.dart';

class OrderPage extends StatefulWidget {
  static const String routeName = '/order';
  final Order? order;

  const OrderPage({Key? key, this.order}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPage();
}

class _OrderPage extends State<OrderPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _clientNameController = TextEditingController();
  TextEditingController _timeToDeliverController = TextEditingController();
  TimeOfDay? _timeToDeliver;
  List<Pizza> pizzas = <Pizza>[];

  @override
  void initState() {
    super.initState();

    if (widget.order != null) {
      _clientNameController = TextEditingController(
        text: widget.order!.clientName ?? '',
      );
      _timeToDeliverController = TextEditingController(
        text:
            '${widget.order!.timeToDeliver.hour}:${widget.order!.timeToDeliver.minute}',
      );
      _timeToDeliver = TimeOfDay(
        hour: widget.order!.timeToDeliver.hour,
        minute: widget.order!.timeToDeliver.minute,
      );
      pizzas = widget.order != null
          ? widget.order!.pizzas.map((Pizza e) => e).toList()
          : <Pizza>[];
    }
  }

  @override
  void dispose() {
    super.dispose();

    _clientNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.order != null ? 'Editer la commande' : 'Nouvelle commande',
        ),
      ),
      body: ScrollableColumnSpaceBetween(
        padding: const EdgeInsets.all(24.0),
        content: BlocListener<OrderBloc, OrderState>(
          listener: (BuildContext context, OrderState state) {
            if (state is OrderAddedState || state is OrderUpdatedState) {
              context.read<OrdersBloc>().add(GetOrdersEvent());
              Navigator.pop(context);
            }
          },
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _clientNameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: 'Nom du client',
                    labelText: 'Nom du client*',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Merci de remplir ce champ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _timeToDeliverController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // contentPadding:
                    //     const EdgeInsets.symmetric(horizontal: 12),
                    // border: roundedInputBorder,
                    prefixIcon: const Icon(Icons.calendar_today),
                    hintText: 'Heure de livaison',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Merci de remplir ce champ';
                    }
                    return null;
                  },
                  readOnly: true,
                  onTap: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (BuildContext context, Widget? child) {
                        return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: child ?? Container(),
                        );
                      },
                    );

                    if (pickedTime != null) {
                      setState(() {
                        _timeToDeliverController.text =
                            '${pickedTime.hour}:${pickedTime.minute}';
                        _timeToDeliver = pickedTime;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 24),
                Wrap(
                  children: pizzas
                      .map(
                        (Pizza pizza) => Chip(
                          label: Row(
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
                                        (Ingredient ingredient) =>
                                            ingredient.name,
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
                                        (Ingredient ingredient) =>
                                            ingredient.name,
                                      )
                                      .toList()
                                      .toString(),
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                )
                            ],
                          ),
                          deleteIcon: const Icon(Icons.remove_circle_outline),
                          onDeleted: () {
                            if (mounted) {
                              setState(() {
                                pizzas.removeWhere(
                                  (Pizza pizzaToCheck) => pizza == pizzaToCheck,
                                );
                              });
                            }
                          },
                        ),
                      )
                      .toList(),
                ),
                BlocBuilder<PizzasBloc, PizzasState>(
                  builder: (BuildContext context, PizzasState pizzasState) {
                    if (pizzasState is! PizzasFetchedState) {
                      return const Center(
                        child: Text('Center'),
                      );
                    } else {
                      return Wrap(
                        children: pizzasState.pizzas
                            .map(
                              (Pizza pizza) => SizedBox(
                                width: 300,
                                child: Card(
                                  child: ListTile(
                                    onTap: () async {
                                      final pizzaToAdd = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AddPizzaToOrderDialog(
                                            pizza: pizza,
                                          );
                                        },
                                      );
                                      if (pizzaToAdd != null) {
                                        if (mounted) {
                                          setState(() {
                                            pizzas.add(pizzaToAdd);
                                          });
                                        }
                                      }
                                    },
                                    title: Text(
                                      '${pizza.name}${pizza.runtimeType == Pizza ? " / ${(pizza).price}€" : ""}',
                                    ),
                                    subtitle: pizza.runtimeType == Pizza
                                        ? Text(
                                            (pizza).ingredients == null
                                                ? 'Erreur'
                                                : (pizza)
                                                    .ingredients!
                                                    .map(
                                                      (
                                                        Ingredient ingredient,
                                                      ) =>
                                                          ingredient.name,
                                                    )
                                                    .toList()
                                                    .toString(),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        bottom: SafeArea(
          child: Column(
            children: <Widget>[
              Text(
                'Total: ${pizzas.isEmpty ? "0" : pizzas.map((Pizza pizza) => pizza.price!).toList().reduce((double value, double element) => value + element)}€',
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: pizzas.isEmpty || _timeToDeliver == null
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                if (widget.order == null) {
                                  context.read<OrderBloc>().add(
                                        CreateOrderEvent(
                                          Order(
                                            status: OrderStatus.toDo,
                                            createdAt: DateTime.now(),
                                            timeToDeliver: _timeToDeliver!,
                                            clientName:
                                                _clientNameController.text,
                                            pizzas: pizzas,
                                          ),
                                        ),
                                      );
                                } else if (widget.order!.id != null) {
                                  context.read<OrderBloc>().add(
                                        UpdateOrderByIdEvent(
                                          Order(
                                            id: widget.order!.id,
                                            status: OrderStatus.toDo,
                                            createdAt: DateTime.now(),
                                            timeToDeliver: _timeToDeliver!,
                                            clientName:
                                                _clientNameController.text,
                                            pizzas: pizzas,
                                          ),
                                        ),
                                      );
                                }
                              }
                            },
                      child: const Text('Valider'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
