import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pom/blocs/ingredient/ingredient.dart';
import 'package:pom/blocs/ingredient/ingredient_events.dart';
import 'package:pom/blocs/ingredient/ingredient_states.dart';
import 'package:pom/blocs/ingredients/ingredients.dart';
import 'package:pom/blocs/ingredients/ingredients_events.dart';
import 'package:pom/models/ingredient.dart';
import 'package:pom/widgets/layout/scrollable_column_space_between.dart';

// TODO: remove useless stateful
class IngredientPage extends StatefulWidget {
  static const String routeName = '/ingredient';
  final Ingredient? ingredient;

  const IngredientPage({Key? key, this.ingredient}) : super(key: key);

  @override
  State<IngredientPage> createState() => _IngredientPage();
}

class _IngredientPage extends State<IngredientPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.ingredient != null ? widget.ingredient!.name : '',
    );
  }

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.ingredient != null
              ? 'Editer l\'ingrédient'
              : 'Nouvel ingrédient',
        ),
      ),
      body: ScrollableColumnSpaceBetween(
        padding: const EdgeInsets.all(24.0),
        content: BlocListener<IngredientBloc, IngredientState>(
          listener: (BuildContext context, IngredientState state) {
            if (state is IngredientAddedState ||
                state is IngredientUpdatedState) {
              context.read<IngredientsBloc>().add(GetIngredientsEvent());
              Navigator.pop(context);
            }
          },
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: 'Nom',
                    labelText: 'Nom*',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Merci de remplir ce champ';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        bottom: SafeArea(
          child: Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.ingredient == null) {
                        context.read<IngredientBloc>().add(
                              CreateIngredientEvent(
                                Ingredient(name: _nameController.text),
                              ),
                            );
                      } else if (widget.ingredient!.id != null) {
                        context.read<IngredientBloc>().add(
                              UpdateIngredientByIdEvent(
                                Ingredient(
                                  id: widget.ingredient!.id,
                                  name: _nameController.text,
                                ),
                              ),
                            );
                      }
                    }
                  },
                  child: const Text('Valider'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
