import 'package:flutter/material.dart';
import 'package:pom/models/ingredient.dart';
import 'package:pom/widgets/layout/scrollable_column_space_between.dart';

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
        content: Form(
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
        bottom: SafeArea(
          child: Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
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
