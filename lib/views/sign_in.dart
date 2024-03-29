import 'package:flutter/material.dart';
import 'package:fom/main.dart';
import 'package:fom/utils/functions.dart';
import 'package:fom/widgets/google_sign_in_button.dart';
import 'package:fom/widgets/privacy_policy_button.dart';
import 'package:fom/widgets/suggestion_button.dart';

class SignInPage extends StatefulWidget {
  static const String routeName = '/sign-in';

  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  void didChangeDependencies() {
    if (!isVersionChecked) {
      checkVersion(context);

      isVersionChecked = true;
    }
    super.didChangeDependencies();
  }

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
