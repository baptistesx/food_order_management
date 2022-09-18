import 'package:flutter/material.dart';
import 'package:pom/models/ingredient.dart';
import 'package:pom/models/pizza.dart';
import 'package:pom/views/pizza.dart';
import 'package:pom/widgets/item_card.dart';

class PizzasPage extends StatefulWidget {
  static const String routeName = '/pizzas';

  const PizzasPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PizzasPage> createState() => _PizzasPageState();
}

class _PizzasPageState extends State<PizzasPage> {
  List<Pizza> pizzas = <Pizza>[
    Pizza(
      id: '1',
      name: 'Reine',
      price: 10.5,
      ingredients: <Ingredient>[
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
      ],
    ),
    Pizza(
      id: '2',
      name: 'Royale',
      price: 10.5,
      ingredients: <Ingredient>[
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
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizzas'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: pizzas
            .map(
              (Pizza pizza) => ItemCard(
                item: pizza,
                onDelete: () {
                  if (mounted) {
                    setState(() {
                      pizzas.removeWhere(
                        (Pizza e) => e.id == pizza.id,
                      );
                    });
                  }
                },
                onEdit: () {
                  Navigator.pushNamed(
                    context,
                    PizzaPage.routeName,
                    arguments: <String, dynamic>{'pizza': pizza},
                  );
                },
              ),
            )
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, PizzaPage.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
