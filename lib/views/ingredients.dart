import 'package:flutter/material.dart';
import 'package:pom/models/ingredient.dart';
import 'package:pom/views/ingredient.dart';
import 'package:pom/widgets/item_card.dart';

class IngredientsPage extends StatefulWidget {
  static const String routeName = '/ingredients';

  const IngredientsPage({Key? key}) : super(key: key);

  @override
  State<IngredientsPage> createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  List<Ingredient> ingredients = <Ingredient>[
    const Ingredient(
      id: '1',
      name: 'Tomates',
    ),
    const Ingredient(
      id: '2',
      name: 'Mozza',
    ),
    const Ingredient(
      id: '3',
      name: 'Olives',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingrédients'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: ingredients
            .map(
              (Ingredient ingredient) => ItemCard(
                item: ingredient,
                onDelete: () {
                  if (mounted) {
                    setState(() {
                      ingredients.removeWhere(
                        (Ingredient e) => e.id == ingredient.id,
                      );
                    });
                  }
                },
                onEdit: () {
                  Navigator.pushNamed(
                    context,
                    IngredientPage.routeName,
                    arguments: <String, dynamic>{'ingredient': ingredient},
                  );
                },
              ),
            )
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, IngredientPage.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
