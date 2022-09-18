import 'package:flutter/material.dart';
import 'package:pom/models/item.dart';
import 'package:pom/models/pizza.dart';

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
        title: Text(
            '${item.name}${item.runtimeType == Pizza ? " / ${(item as Pizza).price}€" : ""}'),
        subtitle: item.runtimeType == Pizza
            ? Text((item as Pizza)
                .ingredients
                .map((e) => e.name)
                .toList()
                .toString())
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
