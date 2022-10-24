import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fom/blocs/ingredient/ingredient.dart';
import 'package:fom/blocs/ingredient/ingredient_events.dart';
import 'package:fom/blocs/ingredient/ingredient_states.dart';
import 'package:fom/main.dart';
import 'package:fom/models/ingredient.dart';
import 'package:fom/widgets/custom_appbar.dart';
import 'package:fom/widgets/layout/scrollable_column_space_between.dart';

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
      appBar: CustomAppBar(
        title: Text(
          widget.ingredient != null
              ? 'Editer l\'ingrédient'
              : 'Nouvel ingrédient',
        ),
      ),
      body: ScrollableColumnSpaceBetween(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        content: BlocListener<IngredientBloc, IngredientState>(
          listener: (BuildContext context, IngredientState state) {
            if (state is IngredientAddedState ||
                state is IngredientUpdatedState) {
              Navigator.pop(context);
            }
          },
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  controller: _nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: 'Nom de l\'ingrédient',
                    labelText: 'Nom de l\'ingrédient*',
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
                                Ingredient(
                                  name: _nameController.text,
                                  userId: firebaseAuth.currentUser!.uid,
                                ),
                              ),
                            );
                      } else if (widget.ingredient!.id != null) {
                        context.read<IngredientBloc>().add(
                              UpdateIngredientByIdEvent(
                                Ingredient(
                                  id: widget.ingredient!.id,
                                  name: _nameController.text,
                                  userId: firebaseAuth.currentUser!.uid,
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
