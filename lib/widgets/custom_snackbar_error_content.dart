import 'package:flutter/material.dart';

class CustomSnackBarErrorContent extends StatelessWidget {
  final String text;

  const CustomSnackBarErrorContent(
    this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.error_outline_rounded,
          color: Colors.white,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
          ),
        ),
      ],
    );
  }
}
