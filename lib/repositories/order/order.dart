import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fom/models/exceptions.dart';
import 'package:fom/models/order.dart';

class OrderRepository {
  FirebaseFirestore db = FirebaseFirestore.instance;

  OrderRepository();

  Future<Order> getOrderById(String id) async {
    final Order order = await db
        .collection('orders')
        .doc(id)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> event) {
      if (!event.exists) {
        throw ApiResponseException(message: 'Ingrédient $id non trouvé');
      }
      return Order.fromMap(event.data()!, event.id);
    });

    return order;
  }

  Future<void> deleteOrderById(Order order) async {
    await db.collection('orders').doc(order.id).delete();
  }

  Future<void> updateOrderById(Order order) async {
    await db.collection('orders').doc(order.id).update(order.toMap());
  }

  Future<void> createOrder(Order order) async {
    await db.collection('orders').add(order.toMap());
  }
}
