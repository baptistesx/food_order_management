import 'package:flutter/material.dart';
import 'package:pom/theme/themes.dart';
import 'package:pom/views/suggestion.dart';

class SuggestionButton extends StatelessWidget {
  const SuggestionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.pushNamed(context, SuggestionPage.routeName);
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: context.themeColors.primaryColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          Text('Un bug? Une suggestion? Avançons ensemble!'),
          SizedBox(
            width: 16,
          ),
          Icon(Icons.arrow_forward)
        ],
      ),
    );
  }
}
