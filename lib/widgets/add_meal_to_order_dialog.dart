import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fom/main.dart';
import 'package:fom/models/ingredient.dart';
import 'package:fom/models/meal.dart';
import 'package:fom/widgets/ingredient_with_checkbox.dart';

class AddMealToOrderDialog extends StatefulWidget {
  final Meal meal;

  const AddMealToOrderDialog({Key? key, required this.meal}) : super(key: key);

  @override
  State<AddMealToOrderDialog> createState() => _AddMealToOrderDialogState();
}

class _AddMealToOrderDialogState extends State<AddMealToOrderDialog> {
  late Meal meal;

  @override
  void initState() {
    super.initState();

    meal = widget.meal.copyWith();
    meal.ingredientsToRemove = <Ingredient>[];
    meal.ingredientsToAdd = <Ingredient>[];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${meal.name} / ${meal.priceSmall} / ${meal.priceBig}€'),
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
                      fontWeight: meal.isBig != null && !meal.isBig!
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  Switch(
                    value: meal.isBig ?? false,
                    onChanged: (bool value) {
                      if (mounted) {
                        setState(() {
                          meal.isBig = value;
                        });
                      }
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                  Text(
                    'Grande',
                    style: TextStyle(
                      fontWeight: meal.isBig != null && meal.isBig!
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 5,
                children: meal.ingredients!
                    .map(
                      (Ingredient e) => ActionChip(
                        backgroundColor: meal.ingredientsToRemove!.contains(e)
                            ? Colors.red[300]
                            : Colors.green[300],
                        label: Text(
                          e.name ?? 'Error',
                          style: meal.ingredientsToRemove!.contains(e)
                              ? const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  decorationThickness: 3,
                                )
                              : null,
                        ),
                        onPressed: () {
                          final bool isSelected =
                              meal.ingredientsToRemove!.contains(e);
                          if (mounted) {
                            setState(() {
                              if (isSelected) {
                                if (meal.ingredients!.contains(e)) {
                                  meal.ingredientsToRemove!.removeWhere(
                                    (Ingredient element) => element.id == e.id,
                                  );
                                } else {
                                  meal.ingredientsToAdd!.add(e);
                                }
                              } else {
                                if (meal.ingredients!.contains(e)) {
                                  meal.ingredientsToRemove!.add(e);
                                } else {
                                  meal.ingredientsToAdd!.removeWhere(
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
              if (meal.ingredientsToAdd!.isNotEmpty)
                Wrap(
                  spacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    const Text('Suppléments: '),
                    ...meal.ingredientsToAdd!
                        .map(
                          (Ingredient e) => ActionChip(
                            backgroundColor: Colors.blue[300],
                            label: Text(e.name ?? 'Error'),
                            onPressed: () {
                              if (mounted) {
                                setState(() {
                                  meal.ingredientsToAdd!.removeWhere(
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
                    .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
                    .orderBy('name')
                    .snapshots(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
                ) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
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
                            isSelected: (meal.ingredients!
                                        .where(
                                          (Ingredient element) =>
                                              element.id == ingredient.id,
                                        )
                                        .isNotEmpty &&
                                    !meal.ingredientsToRemove!
                                        .contains(ingredient)) ||
                                meal.ingredientsToAdd!.contains(ingredient),
                            onClick: (bool? isSelected) {
                              if (isSelected != null) {
                                if (mounted) {
                                  setState(() {
                                    if (isSelected) {
                                      if (meal.ingredients!
                                          .contains(ingredient)) {
                                        meal.ingredientsToRemove!.removeWhere(
                                          (Ingredient element) =>
                                              element.id == ingredient.id,
                                        );
                                      } else {
                                        meal.ingredientsToAdd!.add(ingredient);
                                      }
                                    } else {
                                      if (meal.ingredients!
                                          .contains(ingredient)) {
                                        meal.ingredientsToRemove!
                                            .add(ingredient);
                                      } else {
                                        meal.ingredientsToAdd!.removeWhere(
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
            Navigator.of(context).pop(meal);
          },
        ),
      ],
    );
  }
}
