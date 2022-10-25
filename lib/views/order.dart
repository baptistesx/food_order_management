import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fom/blocs/order/order.dart';
import 'package:fom/blocs/order/order_events.dart';
import 'package:fom/blocs/order/order_states.dart';
import 'package:fom/main.dart';
import 'package:fom/models/ingredient.dart';
import 'package:fom/models/meal.dart';
import 'package:fom/models/order.dart';
import 'package:fom/theme/themes.dart';
import 'package:fom/widgets/add_meal_to_order_dialog.dart';
import 'package:fom/widgets/confirm_action_dialog.dart';
import 'package:fom/widgets/custom_appbar.dart';
import 'package:fom/widgets/layout/scrollable_column_space_between.dart';

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
  List<Meal> selectedMeals = <Meal>[];

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
      selectedMeals = widget.order != null
          ? widget.order!.meals.map((Meal e) => e).toList()
          : <Meal>[];
    }
  }

  @override
  void dispose() {
    super.dispose();

    _clientNameController.dispose();
  }

  Map<Meal, int> getMealsSorted(List<Meal> meals) {
    final Map<Meal, int> distinct = <Meal, int>{};

    for (int i = 0; i < meals.length; i++) {
      if (distinct.keys.where((Meal element) => element == meals[i]).isEmpty) {
        distinct[meals[i].copyWith()] = 1;
      } else {
        distinct[distinct.keys
            .firstWhere((Meal element) => element == meals[i])] = distinct[
                distinct.keys
                    .firstWhere((Meal element) => element == meals[i])]! +
            1;
      }
    }

    return distinct;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          widget.order != null ? 'Editer la commande' : 'Nouvelle commande',
        ),
      ),
      body: ScrollableColumnSpaceBetween(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                            '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                        _timeToDeliver = pickedTime;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 5,
                  children: getMealsSorted(selectedMeals)
                      .entries
                      .map(
                        (MapEntry<Meal, int> meal) => Chip(
                          label: Wrap(
                            children: <Widget>[
                              if (meal.key.ingredientsToAdd!.isNotEmpty ||
                                  meal.key.ingredientsToRemove!.isNotEmpty)
                                const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.red,
                                ),
                              Text(
                                '${meal.value.toString()} x ${meal.key.isBig != null && meal.key.isBig! ? "Grande(s)" : "Petite(s)"}',
                              ),
                              Text(
                                meal.key.name ?? 'Error',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              if (meal.key.ingredientsToRemove!.isNotEmpty)
                                Text(
                                  meal.key.ingredientsToRemove!
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
                              if (meal.key.ingredientsToAdd!.isNotEmpty)
                                Text(
                                  meal.key.ingredientsToAdd!
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
                                selectedMeals.removeWhere(
                                  (Meal mealToCheck) => meal.key == mealToCheck,
                                );
                              });
                            }
                          },
                        ),
                      )
                      .toList(),
                ),
                StreamBuilder<QuerySnapshot<Object?>>(
                    stream: FirebaseFirestore.instance
                        .collection('meals')
                        .where('userId',
                            isEqualTo: firebaseAuth.currentUser!.uid)
                        // .orderBy('name')
                        .snapshots(),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Object?>> mealsSnapshot,
                    ) {
                      return StreamBuilder<QuerySnapshot<Object?>>(
                          stream: FirebaseFirestore.instance
                              .collection('ingredients')
                              .where('userId',
                                  isEqualTo: firebaseAuth.currentUser!.uid)
                              // .orderBy('name')
                              .snapshots(),
                          builder: (
                            BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Object?>>
                                ingredientsSnapshot,
                          ) {
                            if (!ingredientsSnapshot.hasData ||
                                !mealsSnapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
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

                            final List<Meal> meals = mealsSnapshot.data == null
                                ? <Meal>[]
                                : mealsSnapshot.data!.docs
                                    .map(
                                      (QueryDocumentSnapshot<Object?> e) =>
                                          Meal.fromMap(
                                              e.data() as Map<String, dynamic>,
                                              e.reference.id,
                                              ingredients),
                                    )
                                    .toList();
                            if (!mealsSnapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            return Wrap(
                              children: meals
                                  .map(
                                    (Meal meal) => SizedBox(
                                      width: 300,
                                      child: Card(
                                        child: ListTile(
                                          onTap: () async {
                                            // ignore: always_specify_types
                                            final mealToAdd = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AddMealToOrderDialog(
                                                  meal: meal,
                                                );
                                              },
                                            );
                                            if (mealToAdd != null) {
                                              if (mounted) {
                                                setState(() {
                                                  selectedMeals.add(mealToAdd);
                                                });
                                              }
                                            }
                                          },
                                          title: Text(
                                            '${meal.name}${meal.runtimeType == Meal ? " / ${meal.priceSmall}€ / ${meal.priceBig}€" : ""}',
                                          ),
                                          subtitle: meal.runtimeType == Meal
                                              ? Text(
                                                  (meal).ingredients == null
                                                      ? 'Erreur'
                                                      : (meal)
                                                          .ingredients!
                                                          .map(
                                                            (
                                                              Ingredient
                                                                  ingredient,
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
                          });
                    }),
              ],
            ),
          ),
        ),
        bottom: SafeArea(
          child: Column(
            children: <Widget>[
              Text(
                'Total: ${selectedMeals.isEmpty ? "0" : selectedMeals.map((Meal meal) => meal.isBig != null && meal.isBig! ? meal.priceBig! : meal.priceSmall!).toList().reduce((double value, double element) => value + element)}€',
                style: const TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: selectedMeals.isEmpty || _timeToDeliver == null
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
                                            meals: selectedMeals,
                                            userId:
                                                firebaseAuth.currentUser!.uid,
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
                                            meals: selectedMeals,
                                            userId:
                                                firebaseAuth.currentUser!.uid,
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
                        // ignore: always_specify_types
                        final shouldDelete = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const ConfirmActionDialog();
                          },
                        );
                        if (widget.order != null &&
                            shouldDelete != null &&
                            shouldDelete &&
                            mounted) {
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
