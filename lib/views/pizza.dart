import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fom/blocs/pizza/pizza.dart';
import 'package:fom/blocs/pizza/pizza_events.dart';
import 'package:fom/blocs/pizza/pizza_states.dart';
import 'package:fom/blocs/pizzas/pizzas.dart';
import 'package:fom/blocs/pizzas/pizzas_events.dart';
import 'package:fom/main.dart';
import 'package:fom/models/ingredient.dart';
import 'package:fom/models/pizza.dart';
import 'package:fom/widgets/custom_appbar.dart';
import 'package:fom/widgets/ingredient_chip.dart';
import 'package:fom/widgets/ingredient_with_checkbox.dart';
import 'package:fom/widgets/layout/scrollable_column_space_between.dart';

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
      appBar: CustomAppBar(
        title: Text(
          widget.pizza != null ? 'Editer la pizza' : 'Nouvelle pizza',
        ),
      ),
      body: ScrollableColumnSpaceBetween(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                    hintText: 'Nom de la pizza',
                    labelText: 'Nom de la pizza*',
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
                                  userId: firebaseAuth.currentUser!.uid,
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
                                  userId: firebaseAuth.currentUser!.uid,
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
