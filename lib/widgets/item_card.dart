import 'package:flutter/material.dart';
import 'package:fom/models/ingredient.dart';
import 'package:fom/models/item.dart';
import 'package:fom/models/meal.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final void Function() onDelete;
  final void Function()? onEdit;

  const ItemCard({
    Key? key,
    required this.item,
    required this.onDelete,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onEdit,
        title: Text(
          '${item.name}${item.runtimeType == Meal ? " / ${(item as Meal).priceSmall}€ / ${(item as Meal).priceBig}€" : ""}',
        ),
        subtitle: item.runtimeType == Meal
            ? Text(
                (item as Meal).ingredients == null
                    ? 'Erreur'
                    : (item as Meal)
                        .ingredients!
                        .map((Ingredient ingredient) => ingredient.name)
                        .toList()
                        .toString(),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (onEdit != null)
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit),
              ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.remove_circle_outline),
            ),
          ],
        ),
      ),
    );
  }
}
