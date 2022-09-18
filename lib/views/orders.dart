import 'package:flutter/material.dart';
import 'package:pom/models/ingredient.dart';
import 'package:pom/models/order.dart';
import 'package:pom/models/pizza.dart';
import 'package:pom/widgets/order_tab.dart';

class OrdersPage extends StatefulWidget {
  static const String routeName = '/orders';

  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Order> orders = <Order>[
    Order(
      id: '0',
      status: OrderStatus.toDo,
      timeToDeliver: DateTime.now(),
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
      status: OrderStatus.toDo,
      timeToDeliver: DateTime.now(),
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
  late final List<Widget> _pages;
  @override
  void initState() {
    super.initState();

    _pages = <Widget>[
      OrderTab(
        orders: orders
            .where((Order order) => order.status == OrderStatus.toDo)
            .toList(),
      ),
      OrderTab(
        orders: orders
            .where((Order order) => order.status == OrderStatus.done)
            .toList(),
      ),
      OrderTab(
        orders: orders
            .where((Order order) => order.status == OrderStatus.delivered)
            .toList(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Commandes ${_selectedIndex == 0 ? "A faire (${orders.where((Order order) => order.status == OrderStatus.toDo).toList().length})" : _selectedIndex == 1 ? "Faites (${orders.where((Order order) => order.status == OrderStatus.done).toList().length})" : "Livrées (${orders.where((Order order) => order.status == OrderStatus.delivered).toList().length})"}',
        ),
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow_outlined),
            label: 'A faire',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done),
            label: 'Faites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_all_rounded),
            label: 'Livrées',
          ),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.pushNamed(context, PizzaPage.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
