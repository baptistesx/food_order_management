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
    final now = new DateTime.now();

    return <String, dynamic>{
      'id': id,
      'status': status.name,
      'createdAt': createdAt.toString(),
      'timeToDeliver': new DateTime(now.year, now.month, now.day,
          timeToDeliver.hour, timeToDeliver.minute),
      'pizzas': pizzas.map((Pizza x) => x.toMap(true)).toList(),
      'clientName': clientName,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map, String id) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(map['timeToDeliver'].seconds*1000);

    return Order(
      id: id,
      status: OrderStatus.values
          .firstWhere((OrderStatus element) => element.name == map['status']),
      createdAt: DateTime.parse(map['createdAt']),
      timeToDeliver: TimeOfDay(hour: date.hour, minute: date.minute),
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

  Order copyWith({
    String? id,
    OrderStatus? status,
    DateTime? createdAt,
    TimeOfDay? timeToDeliver,
    List<Pizza>? pizzas,
    String? clientName,
  }) {
    return Order(
      id: id ?? this.id,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      timeToDeliver: timeToDeliver ?? this.timeToDeliver,
      pizzas: pizzas ?? this.pizzas,
      clientName: clientName ?? this.clientName,
    );
  }
}
