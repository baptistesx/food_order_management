import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pom/models/order.dart';
import 'package:pom/models/pizza.dart';

class OrderTab extends StatelessWidget {
  const OrderTab({
    Key? key,
    required this.orders,
  }) : super(key: key);

  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ...orders
            .map(
              (Order order) => Card(
                child: ExpansionTile(
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <IconButton>[
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.remove_circle_outline),
                      )
                    ],
                  ),
                  title: Text('♯${order.id} - ${order.clientName}'),
                  subtitle: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Chip>[
                      Chip(
                        label:
                            Text(DateFormat.Hm().format(order.timeToDeliver)),
                      ),
                      Chip(
                        label: Text(order.pizzas.length.toString()),
                      ),
                      Chip(
                        label: Text(
                          '${order.pizzas.map((Pizza pizza) => pizza.price).reduce((double value, double element) => value + element).toString()}€',
                        ),
                      ),
                    ],
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  children: const <Widget>[
                    ListTile(title: Text('This is tile number 3')),
                  ],
                ),
              ),
            )
            .toList()
      ],
    );
  }
}
