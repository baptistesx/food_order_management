import 'package:flutter/material.dart';
import 'package:pom/models/ingredient.dart';
import 'package:pom/models/order.dart';
import 'package:pom/models/pizza.dart';

class StatisticsPage extends StatelessWidget {
  static const String routeName = '/statistics';

  StatisticsPage({Key? key}) : super(key: key);

  final List<Order> orders = <Order>[
    Order(
      id: '0',
      status: OrderStatus.toDo,
      createdAt: DateTime.now(),
      timeToDeliver: TimeOfDay.now(),
      pizzas: <Pizza>[
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
      ],
      clientName: 'Seux',
    ),
    Order(
      id: '1',
      status: OrderStatus.delivered,
      createdAt: DateTime.now(),
      timeToDeliver: TimeOfDay.now(),
      pizzas: <Pizza>[
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
      ],
      clientName: 'Seux',
    )
  ];

  final List<Pizza> pizzas = <Pizza>[
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
    final List<int> pizzasDelivered = orders
        .where((Order order) => order.status == OrderStatus.delivered)
        .toList()
        .map((Order order) => order.pizzas.length)
        .toList();

    const double incomes = 100;
    //  orders
    //     .where((Order order) => order.status == OrderStatus.delivered)
    //     .toList()
    //     .map(
    //       (Order order) => order.pizzas
    //           .map((Pizza pizza) => pizza.price)
    //           .toList()
    //           .reduce((double value, double element) => value + element),
    //     )
    //     .reduce((double value, double element) => value + element);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: <Widget>[
            Text(
              'Total commandes livrées: ${orders.where((Order order) => order.status == OrderStatus.delivered).toList().length}',
            ),
            Text(
              'Total pizzas livrées: ${pizzasDelivered.isNotEmpty ? pizzasDelivered.reduce((int value, int element) => value + element).toString() : "0"}',
            ),
            Text('CA total: ${incomes.toString()}€'),
            ...pizzas
                .map(
                  (Pizza pizza) => Card(
                    child: ListTile(
                      title: Text(
                        '${orders.where((Order order) => order.status == OrderStatus.delivered).toList().map((Order order) => order.pizzas.where((Pizza pizzaSold) => pizzaSold.id == pizza.id).toList().length).reduce((int value, int element) => value + element)} x ${pizza.name}',
                      ),
                    ),
                  ),
                )
                .toList()
          ],
        ),
      ),
    );
  }
}
