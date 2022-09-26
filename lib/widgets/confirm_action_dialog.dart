import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pom/theme/themes.dart';

class ConfirmActionDialog extends StatelessWidget {
  const ConfirmActionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Demande de confirmation'),
      content: Text(
          'Cette action est définitive, etes vous certain de vouloir effectuer cette action?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Annuler')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: context.theme.errorColor),
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text('Confirmer'),
        )
      ],
    );
  }
}
