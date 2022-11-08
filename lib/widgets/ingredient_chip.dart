import 'package:flutter/material.dart';
import 'package:fom/models/ingredient.dart';

class IngredientChip extends StatelessWidget {
  final Ingredient ingredient;
  final void Function() onDelete;

  const IngredientChip({
    Key? key,
    required this.ingredient,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(ingredient.name ?? 'Error'),
      deleteIcon: const Icon(Icons.remove_circle_outline),
      onDeleted: onDelete,
    );
  }
}
