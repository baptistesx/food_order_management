import 'package:flutter/material.dart';
import 'package:pom/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyButton extends StatelessWidget {
  const PrivacyPolicyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        if (!await launchUrl(
          Uri.parse(privacyPolicyUrl),
          mode: LaunchMode.externalApplication,
        )) {
          throw 'Could not launch $privacyPolicyUrl';
        }
      },
      child: const Text('Politique de confidentialité'),
    );
  }
}
