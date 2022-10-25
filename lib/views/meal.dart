import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fom/blocs/meal/meal.dart';
import 'package:fom/blocs/meal/meal_events.dart';
import 'package:fom/blocs/meal/meal_states.dart';
import 'package:fom/main.dart';
import 'package:fom/models/ingredient.dart';
import 'package:fom/models/meal.dart';
import 'package:fom/widgets/custom_appbar.dart';
import 'package:fom/widgets/ingredient_chip.dart';
import 'package:fom/widgets/ingredient_with_checkbox.dart';
import 'package:fom/widgets/layout/scrollable_column_space_between.dart';

class MealPage extends StatefulWidget {
  static const String routeName = '/meal';
  final Meal? meal;

  const MealPage({Key? key, this.meal}) : super(key: key);

  @override
  State<MealPage> createState() => _MealPage();
}

class _MealPage extends State<MealPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceSmallController;
  late TextEditingController _priceBigController;
  late Meal meal;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.meal != null ? widget.meal!.name : '',
    );
    _priceSmallController = TextEditingController(
      text: widget.meal != null ? widget.meal!.priceSmall.toString() : '',
    );
    _priceBigController = TextEditingController(
      text: widget.meal != null ? widget.meal!.priceBig.toString() : '',
    );

    meal = widget.meal ??
        Meal(
          name: '',
          priceSmall: null,
          priceBig: null,
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
          widget.meal != null ? 'Editer l\'élément' : 'Nouvel élément',
        ),
      ),
      body: ScrollableColumnSpaceBetween(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        content: BlocListener<MealBloc, MealState>(
          listener: (BuildContext context, MealState state) {
            if (state is MealAddedState || state is MealUpdatedState) {
              // context.read<MealsBloc>().add(GetMealsEvent()); // TODO: normalement ok pour delete
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
                if (meal.ingredients != null && meal.ingredients!.isEmpty)
                  const Text('Aucun ingrédient')
                else
                  Wrap(
                    spacing: 5,
                    children: meal.ingredients!
                        .map(
                          (Ingredient ingredient) => IngredientChip(
                            ingredient: ingredient,
                            onDelete: () {
                              if (mounted) {
                                setState(() {
                                  meal.ingredients!.removeWhere(
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
                      // .orderBy('name')
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
                    ingredients.sort((a, b) => a.name == null || b.name == null
                        ? -1
                        : a.name!.compareTo(b.name!));
                    return Column(
                      children: ingredients
                          .map(
                            (Ingredient ingredient) => IngredientWithCheckbox(
                              ingredient: ingredient,
                              isSelected: meal.ingredients!
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
                                        meal.ingredients!.add(ingredient);
                                      } else {
                                        meal.ingredients!.removeWhere(
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
                      if (widget.meal == null) {
                        context.read<MealBloc>().add(
                              CreateMealEvent(
                                Meal(
                                  name: _nameController.text,
                                  priceSmall:
                                      double.parse(_priceSmallController.text),
                                  priceBig:
                                      double.parse(_priceBigController.text),
                                  ingredients: meal.ingredients,
                                  userId: firebaseAuth.currentUser!.uid,
                                ),
                              ),
                            );
                      } else if (widget.meal!.id != null) {
                        context.read<MealBloc>().add(
                              UpdateMealByIdEvent(
                                Meal(
                                  id: widget.meal!.id,
                                  name: _nameController.text,
                                  priceSmall:
                                      double.parse(_priceSmallController.text),
                                  priceBig:
                                      double.parse(_priceBigController.text),
                                  ingredients: meal.ingredients,
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
