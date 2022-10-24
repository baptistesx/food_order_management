import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fom/blocs/pizza/pizza.dart';
import 'package:fom/blocs/pizza/pizza_events.dart';
import 'package:fom/blocs/pizza/pizza_states.dart';
import 'package:fom/blocs/pizzas/pizzas.dart';
import 'package:fom/blocs/pizzas/pizzas_events.dart';
import 'package:fom/blocs/pizzas/pizzas_states.dart';
import 'package:fom/models/pizza.dart';
import 'package:fom/theme/themes.dart';
import 'package:fom/views/pizza.dart';
import 'package:fom/widgets/confirm_action_dialog.dart';
import 'package:fom/widgets/custom_appbar.dart';
import 'package:fom/widgets/item_card.dart';

class PizzasPage extends StatefulWidget {
  static const String routeName = '/pizzas';

  const PizzasPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PizzasPage> createState() => _PizzasPageState();
}

class _PizzasPageState extends State<PizzasPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Pizzas'),
      ),
      body: BlocListener<PizzaBloc, PizzaState>(
        listener: (BuildContext context, PizzaState pizzaState) {
          if (pizzaState is PizzaDeletedState ||
              pizzaState is PizzaUpdatedState) {
            context.read<PizzasBloc>().add(
                  GetPizzasEvent(),
                );
          }
        },
        child: BlocBuilder<PizzasBloc, PizzasState>(
          builder: (BuildContext context, PizzasState pizzasState) {
            if (pizzasState is PizzasLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (pizzasState is PizzasFetchedState) {
              return RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: () async {
                  context.read<PizzasBloc>().add(GetPizzasEvent());
                },
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  children: pizzasState.pizzas.isEmpty
                      ? <Widget>[const Text('Aucune pizza trouvée.')]
                      : pizzasState.pizzas
                          .map(
                            (Pizza pizza) => ItemCard(
                              item: pizza,
                              onDelete: () async {
                                // ignore: always_specify_types
                                final shouldDelete = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const ConfirmActionDialog();
                                  },
                                );
                                if (shouldDelete != null && shouldDelete) {
                                  if (pizza.id != null && mounted) {
                                    context.read<PizzaBloc>().add(
                                          DeletePizzaByIdEvent(pizza.id!),
                                        );
                                  }
                                }
                              },
                              onEdit: () {
                                Navigator.pushNamed(
                                  context,
                                  PizzaPage.routeName,
                                  arguments: <String, dynamic>{'pizza': pizza},
                                );
                              },
                            ),
                          )
                          .toList(),
                ),
              );
            } else {
              return const Center(
                child: Text('Erreur'),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.themeColors.secondaryColor,
        onPressed: () {
          Navigator.pushNamed(context, PizzaPage.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
