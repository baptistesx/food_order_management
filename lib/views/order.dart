import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pom/blocs/order/order.dart';
import 'package:pom/blocs/order/order_events.dart';
import 'package:pom/blocs/order/order_states.dart';
import 'package:pom/blocs/orders/orders.dart';
import 'package:pom/blocs/orders/orders_events.dart';
import 'package:pom/models/order.dart';
import 'package:pom/models/pizza.dart';
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
  final TextEditingController _timeToDeliverController =
      TextEditingController();
  TimeOfDay? _timeToDeliver;
  List<Pizza> pizzas = <Pizza>[];

  @override
  void initState() {
    super.initState();

    if (widget.order != null) {
      _clientNameController = TextEditingController(
        text: widget.order!.clientName ?? '',
      );

      pizzas = widget.order != null ? widget.order!.pizzas : <Pizza>[];
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

                TextField(
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
                // const Text('Ingrédients:'),
                // if (pizza.ingredients != null && pizza.ingredients!.isEmpty)
                //   const Text('Aucun ingrédient')
                // else
                //   Wrap(
                //     children: pizza.ingredients!
                //         .map(
                //           (Ingredient ingredient) => IngredientChip(
                //             ingredient: ingredient,
                //             onDelete: () {
                //               if (mounted) {
                //                 setState(() {
                //                   pizza.ingredients!.removeWhere(
                //                     (Ingredient e) => e.id == ingredient.id,
                //                   );
                //                 });
                //               }
                //             },
                //           ),
                //         )
                //         .toList(),
                //   ),
                // BlocBuilder<IngredientsBloc, IngredientsState>(
                //   builder: (
                //     BuildContext context,
                //     IngredientsState ingredientsState,
                //   ) {
                //     if (ingredientsState is! IngredientsFetchedState) {
                //       return const Center(
                //         child: Text(
                //           'Erreur lors de l\'obtention des ingrédients',
                //         ),
                //       );
                //     } else {
                //       return Column(
                //         children: ingredientsState.ingredients
                //             .map(
                //               (Ingredient ingredient) => IngredientWithCheckbox(
                //                 ingredient: ingredient,
                //                 isSelected: pizza.ingredients!
                //                     .where(
                //                       (Ingredient element) =>
                //                           element.id == ingredient.id,
                //                     )
                //                     .isNotEmpty,
                //                 onClick: (bool? isSelected) {
                //                   if (isSelected != null) {
                //                     if (mounted) {
                //                       setState(() {
                //                         if (isSelected) {
                //                           pizza.ingredients!.add(ingredient);
                //                         } else {
                //                           pizza.ingredients!.removeWhere(
                //                             (Ingredient e) =>
                //                                 e.id == ingredient.id,
                //                           );
                //                         }
                //                       });
                //                     }
                //                   }
                //                 },
                //               ),
                //             )
                //             .toList(),
                //       );
                //     }
                //   },
                // ),
                const Text('Total: ${50}€')
              ],
            ),
          ),
        ),
        bottom: SafeArea(
          child: Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.order == null) {
                        context.read<OrderBloc>().add(
                              CreateOrderEvent(
                                Order(
                                  status: OrderStatus.toDo,
                                  createdAt: DateTime.now(),
                                  timeToDeliver: _timeToDeliver!,
                                  clientName: _clientNameController.text,
                                  pizzas: pizzas,
                                ),
                              ),
                            );
                      } else if (widget.order!.id != null) {
                        context.read<OrderBloc>().add(
                              UpdateOrderByIdEvent(
                                Order(
                                  status: OrderStatus.toDo,
                                  createdAt: DateTime.now(),
                                  timeToDeliver: _timeToDeliver!,
                                  clientName: _clientNameController.text,
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
        ),
      ),
    );
  }
}
