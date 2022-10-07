import 'package:flutter/material.dart';
import 'package:pom/widgets/google_sign_in_button.dart';
import 'package:pom/widgets/privacy_policy_button.dart';
import 'package:pom/widgets/suggestion_button.dart';

class SignInPage extends StatelessWidget {
  static const String routeName = '/sign-in';

  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Spacer(),
            Image(
              image: AssetImage('assets/images/logo_text_square.png'),
              width: 250,
            ),
            GoogleSignInButton(),
            Spacer(),
            SuggestionButton(),
            PrivacyPolicyButton(),
          ],
        ),
      ),
    );
  }
}
