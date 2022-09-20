import 'package:flutter/material.dart';
import 'package:pom/models/pizza.dart';

enum OrderStatus { toDo, done, delivered }

class Order {
  final String? id;
  final OrderStatus status;
  final DateTime createdAt;
  final TimeOfDay timeToDeliver;
  final List<Pizza> pizzas;
  final String? clientName;

  Order({
    this.id,
    required this.status,
    required this.createdAt,
    required this.timeToDeliver,
    required this.pizzas,
    required this.clientName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'status': status.name,
      'createdAt': createdAt.toString(),
      'timeToDeliver': '${timeToDeliver.hour}:${timeToDeliver.minute}',
      'pizzas': pizzas.map((Pizza x) => x.toMap(true)).toList(),
      'clientName': clientName,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map, String id) {
    return Order(
      id: id,
      status: OrderStatus.values
          .firstWhere((OrderStatus element) => element.name == map['status']),
      createdAt: DateTime.parse(map['createdAt']),
      timeToDeliver: TimeOfDay(
        hour: int.parse(map['timeToDeliver'].split(':')[0]),
        minute: int.parse(map['timeToDeliver'].split(':')[1]),
      ),
      pizzas: List<Pizza>.from(
        map['pizzas']?.map((x) => Pizza.fromMap(x, x['id'])),
      ),
      clientName: map['clientName'],
    );
  }

  @override
  String toString() {
    return 'Order(id: $id, status: $status, createdAt: $createdAt, timeToDeliver: $timeToDeliver, pizzas: $pizzas, clientName: $clientName)';
  }
}
