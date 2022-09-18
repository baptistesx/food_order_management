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
      'timeToDeliver': timeToDeliver.toString(),
      'pizzas': pizzas.map((Pizza x) => x.toMap()).toList(),
      'clientName': clientName,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map, String id) {
    return Order(
      id: id,
      status: OrderStatus.values
          .firstWhere((OrderStatus element) => element.name == map['status']),
      createdAt: DateTime.parse(map['createdAt']),
      timeToDeliver: TimeOfDay.fromDateTime(map['timeToDeliver']),
      pizzas: <
          Pizza>[], //TODO List<Pizza>.from(map['pizzas']?.map((x) => Pizza.fromMap(x.id))),
      clientName: map['clientName'] ?? '',
    );
  }
}
