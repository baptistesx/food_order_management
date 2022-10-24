import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fom/models/order.dart';

class OrdersRepository {
  FirebaseFirestore db = FirebaseFirestore.instance;
  OrdersRepository();

  Future<List<Order>> getOrders() async {
    final List<Order> orders = <Order>[];

    await db
        .collection('orders')
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> event) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in event.docs) {
        orders.add(Order.fromMap(doc.data(), doc.id));
      }
    });

    orders.sort((Order a, Order b) => a.id!.compareTo(b.id!));

    return orders;
  }
}
