import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pom/blocs/ingredient/ingredient.dart';
import 'package:pom/blocs/ingredient/ingredient_events.dart';
import 'package:pom/blocs/ingredient/ingredient_states.dart';
import 'package:pom/blocs/ingredients/ingredients.dart';
import 'package:pom/blocs/ingredients/ingredients_events.dart';
import 'package:pom/blocs/ingredients/ingredients_states.dart';
import 'package:pom/models/ingredient.dart';
import 'package:pom/views/ingredient.dart';
import 'package:pom/widgets/item_card.dart';

class IngredientsPage extends StatefulWidget {
  static const String routeName = '/ingredients';

  const IngredientsPage({Key? key}) : super(key: key);

  @override
  State<IngredientsPage> createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingrédients'),
      ),
      body: BlocListener<IngredientBloc, IngredientState>(
        listener: (BuildContext context, IngredientState ingredientState) {
          if (ingredientState is IngredientDeletedState ||
              ingredientState is IngredientUpdatedState) {
            context.read<IngredientsBloc>().add(
                  GetIngredientsEvent(),
                );
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<IngredientsBloc, IngredientsState>(
          builder: (BuildContext context, IngredientsState ingredientsState) {
            if (ingredientsState is IngredientsLoadingState) {
              return const Center(child: const CircularProgressIndicator());
            } else if (ingredientsState is IngredientsFetchedState) {
              return RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: () async {
                  context.read<IngredientsBloc>().add(GetIngredientsEvent());
                },
                child: ingredientsState.ingredients.isEmpty
                    ? Center(
                        child: Text('Aucun ingrédient trouvé.'),
                      )
                    : ListView(
                        children: ingredientsState.ingredients
                            .map(
                              (Ingredient ingredient) => ItemCard(
                                item: ingredient,
                                onDelete: () {
                                  if (ingredient.id != null) {
                                    context.read<IngredientBloc>().add(
                                          DeleteIngredientByIdEvent(
                                              ingredient.id!),
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
                      ),
              );
            } else {
              return const Center(
                child: const Text('Erreur'),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, IngredientPage.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
