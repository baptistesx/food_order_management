import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fom/blocs/ingredient/ingredient.dart';
import 'package:fom/blocs/ingredient/ingredient_events.dart';
import 'package:fom/main.dart';
import 'package:fom/models/ingredient.dart';
import 'package:fom/theme/themes.dart';
import 'package:fom/views/ingredient.dart';
import 'package:fom/widgets/confirm_action_dialog.dart';
import 'package:fom/widgets/custom_appbar.dart';
import 'package:fom/widgets/item_card.dart';

class IngredientsPage extends StatefulWidget {
  static const String routeName = '/ingredients';

  const IngredientsPage({Key? key}) : super(key: key);

  @override
  State<IngredientsPage> createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: Text('Ingrédients')),
      body: StreamBuilder<QuerySnapshot<Object?>>(
        stream: FirebaseFirestore.instance
            .collection('ingredients')
            .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
            .snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
        ) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<Ingredient> ingredients = snapshot.data == null
              ? <Ingredient>[]
              : snapshot.data!.docs
                  .map(
                    (QueryDocumentSnapshot<Object?> e) => Ingredient.fromMap(
                      e.data() as Map<String, dynamic>,
                      e.reference.id,
                    ),
                  )
                  .toList();

          if (ingredients.isNotEmpty) {
            ingredients.sort(
              (Ingredient a, Ingredient b) =>
                  a.name.toString().compareTo(b.name.toString()),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            children: ingredients.isEmpty
                ? <Widget>[const Text('Aucun ingrédient trouvé.')]
                : ingredients
                    .map(
                      (Ingredient ingredient) => ItemCard(
                        item: ingredient,
                        onDelete: () async {
                          // ignore: always_specify_types
                          final shouldDelete = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const ConfirmActionDialog();
                            },
                          );
                          if (shouldDelete != null && shouldDelete && mounted) {
                            context.read<IngredientBloc>().add(
                                  DeleteIngredientByIdEvent(ingredient),
                                );
                          }
                        },
                        onEdit: () {
                          Navigator.pushNamed(
                            context,
                            IngredientPage.routeName,
                            arguments: <String, dynamic>{
                              'ingredient': ingredient
                            },
                          );
                        },
                      ),
                    )
                    .toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.themeColors.secondaryColor,
        onPressed: () {
          Navigator.pushNamed(context, IngredientPage.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
