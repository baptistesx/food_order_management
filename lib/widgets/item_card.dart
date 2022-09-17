import 'package:flutter/material.dart';
import 'package:pom/models/item.dart';

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
        title: Text(item.name),
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
