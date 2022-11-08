import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fom/models/ingredient.dart';

class IngredientsRepository {
  FirebaseFirestore db = FirebaseFirestore.instance;
  IngredientsRepository();

  Future<List<Ingredient>> getIngredients() async {
    // final List<Ingredient> ingredients = <Ingredient>[];

    // await db
    //     .collection('ingredients')
    //     .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
    //     .get()
    //     .then((QuerySnapshot<Map<String, dynamic>> event) {
    //   for (QueryDocumentSnapshot<Map<String, dynamic>> doc in event.docs) {
    //     ingredients.add(Ingredient.fromMap(doc.data(), doc.id));
    //   }
    // });

    // ingredients
    //     .sort((Ingredient a, Ingredient b) => a.name!.compareTo(b.name!));

    // return ingredients;
    return <Ingredient>[];
  }
}
