import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fom/main.dart';
import 'package:fom/models/ingredient.dart';
import 'package:fom/models/order.dart';

class OrdersRepository {
  FirebaseFirestore db = FirebaseFirestore.instance;
  OrdersRepository();

  Future<List<Order>> getOrders() async {
    final List<Order> orders = <Order>[];

    await db
        .collection('orders')
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> event) async {
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

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in event.docs) {
        orders.add(Order.fromMap(doc.data(), doc.id, ingredients));
      }
    });
    orders.sort((Order a, Order b) => a.id!.compareTo(b.id!));

    return orders;
  }
}
