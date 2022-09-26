import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pom/models/ingredient.dart';
import 'package:pom/models/pizza.dart';
import 'package:pom/widgets/ingredient_with_checkbox.dart';

class AddPizzaToOrderDialog extends StatefulWidget {
  final Pizza pizza;

  const AddPizzaToOrderDialog({Key? key, required this.pizza})
      : super(key: key);

  @override
  State<AddPizzaToOrderDialog> createState() => _AddPizzaToOrderDialogState();
}

class _AddPizzaToOrderDialogState extends State<AddPizzaToOrderDialog> {
  late Pizza pizza;

  @override
  void initState() {
    super.initState();

    pizza = widget.pizza.copyWith();
    pizza.ingredientsToRemove = <Ingredient>[];
    pizza.ingredientsToAdd = <Ingredient>[];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${pizza.name} / ${pizza.priceSmall} / ${pizza.priceBig}€'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width > 500
            ? MediaQuery.of(context).size.width * 0.7
            : MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Petite',
                    style: TextStyle(
                      fontWeight: pizza.isBig != null && !pizza.isBig!
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  Switch(
                    value: pizza.isBig ?? false,
                    onChanged: (bool value) {
                      if (mounted) {
                        setState(() {
                          pizza.isBig = value;
                        });
                      }
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                  Text(
                    'Grande',
                    style: TextStyle(
                      fontWeight: pizza.isBig != null && pizza.isBig!
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 5,
                children: pizza.ingredients!
                    .map(
                      (Ingredient e) => ActionChip(
                        backgroundColor: pizza.ingredientsToRemove!.contains(e)
                            ? Colors.red[300]
                            : Colors.green[300],
                        label: Text(
                          e.name ?? 'Error',
                          style: pizza.ingredientsToRemove!.contains(e)
                              ? const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  decorationThickness: 3,
                                )
                              : null,
                        ),
                        onPressed: () {
                          final bool isSelected =
                              pizza.ingredientsToRemove!.contains(e);
                          if (mounted) {
                            setState(() {
                              if (isSelected) {
                                if (pizza.ingredients!.contains(e)) {
                                  pizza.ingredientsToRemove!.removeWhere(
                                    (Ingredient element) => element.id == e.id,
                                  );
                                } else {
                                  pizza.ingredientsToAdd!.add(e);
                                }
                              } else {
                                if (pizza.ingredients!.contains(e)) {
                                  pizza.ingredientsToRemove!.add(e);
                                } else {
                                  pizza.ingredientsToAdd!.removeWhere(
                                    (Ingredient element) => element.id == e.id,
                                  );
                                }
                              }
                            });
                          }
                        },
                      ),
                    )
                    .toList(),
              ),
              if (pizza.ingredientsToAdd!.isNotEmpty)
                Wrap(
                  spacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    const Text('Suppléments: '),
                    ...pizza.ingredientsToAdd!
                        .map(
                          (Ingredient e) => ActionChip(
                            backgroundColor: Colors.blue[300],
                            label: Text(e.name ?? 'Error'),
                            onPressed: () {
                              if (mounted) {
                                setState(() {
                                  pizza.ingredientsToAdd!.removeWhere(
                                    (Ingredient element) => element.id == e.id,
                                  );
                                });
                              }
                            },
                          ),
                        )
                        .toList(),
                  ],
                ),
              StreamBuilder<QuerySnapshot<Object?>>(
                stream: FirebaseFirestore.instance
                    .collection('ingredients')
                    .orderBy('name')
                    .snapshots(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
                ) {
                  if (!snapshot.hasData) {
                    return const LinearProgressIndicator();
                  }
                  final List<Ingredient> ingredients = snapshot.data == null
                      ? <Ingredient>[]
                      : snapshot.data!.docs
                          .map(
                            (QueryDocumentSnapshot<Object?> e) =>
                                Ingredient.fromMap(
                              e.data() as Map<String, dynamic>,
                              e.reference.id,
                            ),
                          )
                          .toList();

                  return Column(
                    children: ingredients
                        .map(
                          (Ingredient ingredient) => IngredientWithCheckbox(
                            ingredient: ingredient,
                            isSelected: (pizza.ingredients!
                                        .where(
                                          (Ingredient element) =>
                                              element.id == ingredient.id,
                                        )
                                        .isNotEmpty &&
                                    !pizza.ingredientsToRemove!
                                        .contains(ingredient)) ||
                                pizza.ingredientsToAdd!.contains(ingredient),
                            onClick: (bool? isSelected) {
                              if (isSelected != null) {
                                if (mounted) {
                                  setState(() {
                                    if (isSelected) {
                                      if (pizza.ingredients!
                                          .contains(ingredient)) {
                                        pizza.ingredientsToRemove!.removeWhere(
                                          (Ingredient element) =>
                                              element.id == ingredient.id,
                                        );
                                      } else {
                                        pizza.ingredientsToAdd!.add(ingredient);
                                      }
                                    } else {
                                      if (pizza.ingredients!
                                          .contains(ingredient)) {
                                        pizza.ingredientsToRemove!
                                            .add(ingredient);
                                      } else {
                                        pizza.ingredientsToAdd!.removeWhere(
                                          (Ingredient element) =>
                                              element.id == ingredient.id,
                                        );
                                      }
                                    }
                                  });
                                }
                              }
                            },
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Annuler'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Ajouter'),
          onPressed: () {
            Navigator.of(context).pop(pizza);
          },
        ),
      ],
    );
  }
}
