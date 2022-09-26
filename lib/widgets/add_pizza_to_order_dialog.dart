import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pom/blocs/ingredients/ingredients.dart';
import 'package:pom/blocs/ingredients/ingredients_states.dart';
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
      title: Column(
        children: <Widget>[
          Text('${pizza.name} / ${pizza.price}€'),
          // Text(
          //   pizza.ingredients!
          //       .map((Ingredient ingredient) => ingredient.name)
          //       .toString(),
          // )
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
            BlocBuilder<IngredientsBloc, IngredientsState>(
              builder: (
                BuildContext context,
                IngredientsState ingredientsState,
              ) {
                if (ingredientsState is! IngredientsFetchedState) {
                  return const Center(
                    child: Text(
                      'Erreur lors de l\'obtention des ingrédients',
                    ),
                  );
                } else {
                  return Column(
                    children: ingredientsState.ingredients
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
                }
              },
            ),
          ],
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
