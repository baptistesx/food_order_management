import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pom/blocs/ingredients/ingredients.dart';
import 'package:pom/blocs/ingredients/ingredients_states.dart';
import 'package:pom/blocs/pizza/pizza.dart';
import 'package:pom/blocs/pizza/pizza_events.dart';
import 'package:pom/blocs/pizza/pizza_states.dart';
import 'package:pom/blocs/pizzas/pizzas.dart';
import 'package:pom/blocs/pizzas/pizzas_events.dart';
import 'package:pom/models/ingredient.dart';
import 'package:pom/models/pizza.dart';
import 'package:pom/widgets/ingredient_chip.dart';
import 'package:pom/widgets/ingredient_with_checkbox.dart';
import 'package:pom/widgets/layout/scrollable_column_space_between.dart';

class PizzaPage extends StatefulWidget {
  static const String routeName = '/pizza';
  final Pizza? pizza;

  const PizzaPage({Key? key, this.pizza}) : super(key: key);

  @override
  State<PizzaPage> createState() => _PizzaPage();
}

class _PizzaPage extends State<PizzaPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceSmallController;
  late TextEditingController _priceBigController;
  late Pizza pizza;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.pizza != null ? widget.pizza!.name : '',
    );
    _priceSmallController = TextEditingController(
      text: widget.pizza != null ? widget.pizza!.priceSmall.toString() : '0',
    );
    _priceBigController = TextEditingController(
      text: widget.pizza != null ? widget.pizza!.priceBig.toString() : '0',
    );

    pizza = widget.pizza ??
        Pizza(
          name: '',
          priceSmall: 0,
          priceBig: 0,
          ingredients: <Ingredient>[],
        );
  }

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
    _priceSmallController.dispose();
    _priceBigController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pizza != null ? 'Editer la pizza' : 'Nouvelle pizza',
        ),
      ),
      body: ScrollableColumnSpaceBetween(
        padding: const EdgeInsets.all(24.0),
        content: BlocListener<PizzaBloc, PizzaState>(
          listener: (BuildContext context, PizzaState state) {
            if (state is PizzaAddedState || state is PizzaUpdatedState) {
              context.read<PizzasBloc>().add(GetPizzasEvent());
              Navigator.pop(context);
            }
          },
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: 'Nom',
                    labelText: 'Nom*',
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
                  controller: _priceSmallController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: 'Prix petite taille',
                    labelText: 'Prix petite taille*',
                    suffix: const Text('€'),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Merci de remplir ce champ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceBigController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: 'Prix grande taille',
                    labelText: 'Prix grande taille*',
                    suffix: const Text('€'),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Merci de remplir ce champ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const Text('Ingrédients:'),
                if (pizza.ingredients != null && pizza.ingredients!.isEmpty)
                  const Text('Aucun ingrédient')
                else
                  Wrap(
                    spacing: 5,
                    children: pizza.ingredients!
                        .map(
                          (Ingredient ingredient) => IngredientChip(
                            ingredient: ingredient,
                            onDelete: () {
                              if (mounted) {
                                setState(() {
                                  pizza.ingredients!.removeWhere(
                                    (Ingredient e) => e.id == ingredient.id,
                                  );
                                });
                              }
                            },
                          ),
                        )
                        .toList(),
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
                                isSelected: pizza.ingredients!
                                    .where(
                                      (Ingredient element) =>
                                          element.id == ingredient.id,
                                    )
                                    .isNotEmpty,
                                onClick: (bool? isSelected) {
                                  if (isSelected != null) {
                                    if (mounted) {
                                      setState(() {
                                        if (isSelected) {
                                          pizza.ingredients!.add(ingredient);
                                        } else {
                                          pizza.ingredients!.removeWhere(
                                            (Ingredient e) =>
                                                e.id == ingredient.id,
                                          );
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
        ),
        bottom: SafeArea(
          child: Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.pizza == null) {
                        context.read<PizzaBloc>().add(
                              CreatePizzaEvent(
                                Pizza(
                                  name: _nameController.text,
                                  priceSmall:
                                      double.parse(_priceSmallController.text),
                                  priceBig:
                                      double.parse(_priceBigController.text),
                                  ingredients: pizza.ingredients,
                                ),
                              ),
                            );
                      } else if (widget.pizza!.id != null) {
                        context.read<PizzaBloc>().add(
                              UpdatePizzaByIdEvent(
                                Pizza(
                                  id: widget.pizza!.id,
                                  name: _nameController.text,
                                  priceSmall:
                                      double.parse(_priceSmallController.text),
                                  priceBig:
                                      double.parse(_priceBigController.text),
                                  ingredients: pizza.ingredients,
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
