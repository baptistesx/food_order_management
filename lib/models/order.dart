import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fom/extensions/text_helper.dart';
import 'package:fom/models/meal.dart';

enum OrderStatus { toDo, done, delivered }

class Order {
  final String? id;
  final String? userId;
  final OrderStatus status;
  final DateTime createdAt;
  final TimeOfDay timeToDeliver;
  final List<Meal> meals;
  final String? clientName;

  Order({
    this.id,
    this.userId,
    required this.status,
    required this.createdAt,
    required this.timeToDeliver,
    required this.meals,
    required this.clientName,
  });

  Map<String, dynamic> toMap() {
    final DateTime now = DateTime.now();

    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'status': status.name,
      'createdAt': createdAt.toString(),
      'timeToDeliver': DateTime(
        now.year,
        now.month,
        now.day,
        timeToDeliver.hour,
        timeToDeliver.minute,
      ),
      'meals': meals.map((Meal x) => x.toMap(true)).toList(),
      'clientName': clientName?.trim().toCapitalized(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map, String id) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(
      (map['timeToDeliver'] as Timestamp).seconds * 1000,
    );

    return Order(
      id: id,
      userId: map['userId'],
      status: OrderStatus.values
          .firstWhere((OrderStatus element) => element.name == map['status']),
      createdAt: DateTime.parse(map['createdAt']),
      timeToDeliver: TimeOfDay(hour: date.hour, minute: date.minute),
      meals: map['meals'] == null
          ? <Meal>[]
          : List<Meal>.from(
              (map['meals'] as List<dynamic>?)!.map(
                (dynamic x) =>
                    Meal.fromMap(x, (x as Map<String, dynamic>)['id']),
              ),
            ),
      clientName: (map['clientName'] as String?)?.trim().toCapitalized(),
    );
  }

  Order copyWith({
    String? id,
    String? userId,
    OrderStatus? status,
    DateTime? createdAt,
    TimeOfDay? timeToDeliver,
    List<Meal>? meals,
    String? clientName,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      timeToDeliver: timeToDeliver ?? this.timeToDeliver,
      meals: meals ?? this.meals,
      clientName: clientName ?? this.clientName,
    );
  }
}
