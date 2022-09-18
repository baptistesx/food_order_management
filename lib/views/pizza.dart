import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late TextEditingController _priceController;
  late Pizza pizza;

  final List<Ingredient> ingredients = <Ingredient>[
     Ingredient(
      id: '1',
      name: 'Tomates',
    ),
     Ingredient(
      id: '2',
      name: 'Mozza',
    ),
     Ingredient(
      id: '3',
      name: 'Olives',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.pizza != null ? widget.pizza!.name : '',
    );
    _priceController = TextEditingController(
      text: widget.pizza != null ? widget.pizza!.price.toString() : '0',
    );

    pizza = widget.pizza ??
        Pizza(
          id: '0',
          name: '',
          price: 10.5,
          ingredients: <Ingredient>[],
        );
  }

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
    _priceController.dispose();
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
        content: Form(
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
                controller: _priceController,
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: 'Prix',
                  labelText: 'Prix*',
                  suffix: const Text('€'),
                ),
                inputFormatters: <TextInputFormatter>[
                  // for below version 2 use this
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                  FilteringTextInputFormatter.digitsOnly
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
              if (pizza.ingredients.isEmpty) const Text('Aucun ingrédient'),
              Wrap(
                children: pizza.ingredients
                    .map(
                      (Ingredient ingredient) => IngredientChip(
                        ingredient: ingredient,
                        onDelete: () {
                          if (mounted) {
                            setState(() {
                              pizza.ingredients.removeWhere(
                                (Ingredient e) => e.id == ingredient.id,
                              );
                            });
                          }
                        },
                      ),
                    )
                    .toList(),
              ),
              ...ingredients
                  .map(
                    (Ingredient ingredient) => IngredientWithCheckbox(
                      ingredient: ingredient,
                      isSelected: pizza.ingredients
                          .where(
                            (Ingredient element) => element.id == ingredient.id,
                          )
                          .isNotEmpty,
                      onClick: (bool? isSelected) {
                        if (isSelected != null) {
                          if (mounted) {
                            setState(() {
                              if (isSelected) {
                                pizza.ingredients.add(ingredient);
                              } else {
                                pizza.ingredients.removeWhere(
                                  (Ingredient e) => e.id == ingredient.id,
                                );
                              }
                            });
                          }
                        }
                      },
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
        bottom: SafeArea(
          child: Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
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
