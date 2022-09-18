import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pom/blocs/orders/orders.dart';
import 'package:pom/blocs/orders/orders_events.dart';
import 'package:pom/blocs/orders/orders_states.dart';
import 'package:pom/models/order.dart';
import 'package:pom/views/order.dart';
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

  final List<Widget> _pages = <Widget>[
    const OrderTab(status: OrderStatus.toDo),
    const OrderTab(status: OrderStatus.done),
    const OrderTab(status: OrderStatus.delivered),
  ];

  @override
  void initState() {
    super.initState();

    context.read<OrdersBloc>().add(GetOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (BuildContext context, OrdersState ordersState) {
            if (ordersState is OrdersFetchedState) {
              return Text(
                'Commandes ${_selectedIndex == 0 ? "A faire (${ordersState.orders.where((Order order) => order.status == OrderStatus.toDo).toList().length})" : _selectedIndex == 1 ? "Faites (${ordersState.orders.where((Order order) => order.status == OrderStatus.done).toList().length})" : "Livrées (${ordersState.orders.where((Order order) => order.status == OrderStatus.delivered).toList().length})"}',
              );
            } else {
              return const Text('Commandes');
            }
          },
        ),
      ),
      body: _pages.elementAt(_selectedIndex),
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
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, OrderPage.routeName);
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
