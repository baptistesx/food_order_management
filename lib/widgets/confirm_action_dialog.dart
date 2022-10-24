import 'package:flutter/material.dart';
import 'package:fom/theme/themes.dart';

class ConfirmActionDialog extends StatelessWidget {
  const ConfirmActionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Demande de confirmation'),
      content: const Text(
        'Cette action est définitive, etes vous certain de vouloir effectuer cette action?',
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: context.theme.errorColor),
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text('Confirmer'),
        )
      ],
    );
  }
}
