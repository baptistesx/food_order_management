import 'package:flutter/material.dart';
import 'package:pom/models/ingredient.dart';
import 'package:pom/models/pizza.dart';
import 'package:pom/widgets/item_card.dart';
import 'package:pom/widgets/layout/scrollable_column_space_between.dart';

class PizzaPage extends StatefulWidget {
  static const String routeName = '/pizza';
  final Pizza? pizza;

  const PizzaPage({Key? key, this.pizza}) : super(key: key);

  @override
  State<PizzaPage> createState() => _PizzaPage();
}

class _PizzaPage extends State<PizzaPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late Pizza pizza;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.pizza != null ? widget.pizza!.name : '',
    );

    pizza =
        widget.pizza ?? Pizza(id: '0', name: '', ingredients: <Ingredient>[]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pizza != null ? 'Editer la pizza' : 'Nouvelle pizza',
        ),
      ),
      body: ScrollableColumnSpaceBetween(
        padding: const EdgeInsets.all(24.0),
        content: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 24),
              const Text('Ingrédients:'),
              if (pizza.ingredients.isEmpty) const Text('Aucun ingrédient'),
              ...pizza.ingredients
                  .map(
                    (Ingredient ingredient) => ItemCard(
                      item: ingredient,
                      onDelete: () {
                        if (mounted) {
                          setState(() {
                            pizza.ingredients.removeWhere(
                              (Ingredient e) => e.id == ingredient.id,
                            );
                          });
                        }
                      },
                    ),
                  )
                  .toList(),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Ajouter un ingrédient'),
                ),
              )
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
