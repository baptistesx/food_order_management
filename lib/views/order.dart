import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pom/blocs/order/order.dart';
import 'package:pom/blocs/order/order_events.dart';
import 'package:pom/blocs/order/order_states.dart';
import 'package:pom/blocs/pizzas/pizzas.dart';
import 'package:pom/blocs/pizzas/pizzas_states.dart';
import 'package:pom/models/ingredient.dart';
import 'package:pom/models/order.dart';
import 'package:pom/models/pizza.dart';
import 'package:pom/theme/themes.dart';
import 'package:pom/widgets/add_pizza_to_order_dialog.dart';
import 'package:pom/widgets/confirm_action_dialog.dart';
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

  Map<Pizza, int> getPizzasSorted(List<Pizza> pizzas) {
    final Map<Pizza, int> distinct = <Pizza, int>{};

    for (int i = 0; i < pizzas.length; i++) {
      if (distinct.keys
          .where((Pizza element) => element == pizzas[i])
          .isEmpty) {
        distinct[pizzas[i].copyWith()] = 1;
      } else {
        distinct[distinct.keys
            .firstWhere((Pizza element) => element == pizzas[i])] = distinct[
                distinct.keys
                    .firstWhere((Pizza element) => element == pizzas[i])]! +
            1;
      }
    }

    return distinct;
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
            if (state is OrderAddedState ||
                state is OrderUpdatedState ||
                state is OrderDeletedState) {
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
                  spacing: 5,
                  children: getPizzasSorted(pizzas)
                      .entries
                      .map(
                        (MapEntry<Pizza, int> pizza) => Chip(
                          label: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              if (pizza.key.ingredientsToAdd!.isNotEmpty ||
                                  pizza.key.ingredientsToRemove!.isNotEmpty)
                                const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.red,
                                ),
                              Text(
                                  '${pizza.value.toString()} x ${pizza.key.isBig != null && pizza.key.isBig! ? "Grande(s)" : "Petite(s)"}'),
                              Text(
                                pizza.key.name ?? 'Error',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              if (pizza.key.ingredientsToRemove!.isNotEmpty)
                                Text(
                                  pizza.key.ingredientsToRemove!
                                      .map(
                                        (Ingredient ingredient) =>
                                            ingredient.name,
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
                              const SizedBox(width: 5),
                              if (pizza.key.ingredientsToAdd!.isNotEmpty)
                                Text(
                                  pizza.key.ingredientsToAdd!
                                      .map(
                                        (Ingredient ingredient) =>
                                            ingredient.name,
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
                          deleteIcon: const Icon(Icons.remove_circle_outline),
                          onDeleted: () {
                            if (mounted) {
                              setState(() {
                                pizzas.removeWhere(
                                  (Pizza pizzaToCheck) =>
                                      pizza.key == pizzaToCheck,
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
                        child: Text('Erreur'),
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
                                      // ignore: always_specify_types
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
                                      '${pizza.name}${pizza.runtimeType == Pizza ? " / ${pizza.priceSmall}€ / ${pizza.priceBig}€" : ""}',
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
                'Total: ${pizzas.isEmpty ? "0" : pizzas.map((Pizza pizza) => pizza.isBig != null && pizza.isBig! ? pizza.priceBig! : pizza.priceSmall!).toList().reduce((double value, double element) => value + element)}€',
                style: TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 16),
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
                                            status: widget.order!.status,
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
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        final shouldDelete = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmActionDialog();
                          },
                        );
                        if (widget.order != null &&
                            shouldDelete != null &&
                            shouldDelete) {
                          context
                              .read<OrderBloc>()
                              .add(DeleteOrderByIdEvent(widget.order!));
                        }
                      },
                      child: Text(
                        'Supprimer',
                        style: TextStyle(color: context.theme.errorColor),
                      ),
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
