import 'package:flutter/material.dart';

class HomeSectionButton extends StatelessWidget {
  final String title;
  final String route;
  final void Function()? onClick;

  const HomeSectionButton({
    Key? key,
    required this.title,
    required this.route,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          if (onClick != null) {
            onClick!();
          }
          Navigator.pushNamed(context, route);
        },
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
