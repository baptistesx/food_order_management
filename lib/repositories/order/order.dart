import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fom/main.dart';
import 'package:fom/models/exceptions.dart';
import 'package:fom/models/ingredient.dart';
import 'package:fom/models/order.dart';

class OrderRepository {
  FirebaseFirestore db = FirebaseFirestore.instance;

  OrderRepository();

  Future<Order> getOrderById(String id) async {
    final Order order = await db
        .collection('orders')
        .doc(id)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> event) async {
      if (!event.exists) {
        throw ApiResponseException(message: 'Ingrédient $id non trouvé');
      }

      final List<Ingredient> ingredients = await db
          .collection('ingredients')
          .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
          .get()
          .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
        return snapshot.docs
            .map(
              (QueryDocumentSnapshot<Object?> e) => Ingredient.fromMap(
                e.data() as Map<String, dynamic>,
                e.reference.id,
              ),
            )
            .toList();
      });

      return Order.fromMap(event.data()!, event.id, ingredients);
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
