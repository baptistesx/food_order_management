import 'package:flutter/material.dart';
import 'package:fom/models/ingredient.dart';

class IngredientWithCheckbox extends StatelessWidget {
  final Ingredient ingredient;
  final bool isSelected;
  final void Function(bool? isSelected) onClick;

  const IngredientWithCheckbox({
    Key? key,
    required this.ingredient,
    required this.isSelected,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(value: isSelected, onChanged: onClick),
        Text(ingredient.name ?? 'Error'),
      ],
    );
  }
}
