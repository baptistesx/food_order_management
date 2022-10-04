import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pom/blocs/orders/orders.dart';
import 'package:pom/blocs/orders/orders_events.dart';
import 'package:pom/main.dart';
import 'package:pom/models/order.dart';
import 'package:pom/theme/themes.dart';
import 'package:pom/views/order.dart';
import 'package:pom/widgets/custom_appbar.dart';
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
      appBar: CustomAppBar(
        title: StreamBuilder<QuerySnapshot<Object?>>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
              .orderBy('timeToDeliver')
              .snapshots(),
          builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
          ) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final List<Order> orders = snapshot.data == null
                ? <Order>[]
                : snapshot.data!.docs
                    .map(
                      (QueryDocumentSnapshot<Object?> e) => Order.fromMap(
                        e.data() as Map<String, dynamic>,
                        e.reference.id,
                      ),
                    )
                    .toList();
            if (orders.isEmpty) {
              return const Text('Commandes');
            } else {
              return Text(
                'Commandes ${_selectedIndex == 0 ? "A faire (${orders.where((Order order) => order.status == OrderStatus.toDo).toList().length})" : _selectedIndex == 1 ? "Faites (${orders.where((Order order) => order.status == OrderStatus.done).toList().length})" : "Livrées (${orders.where((Order order) => order.status == OrderStatus.delivered).toList().length})"}',
              );
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
              backgroundColor: context.themeColors.secondaryColor,
              onPressed: () {
                Navigator.pushNamed(context, OrderPage.routeName);
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
