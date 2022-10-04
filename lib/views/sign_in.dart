import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pom/authentication.dart';
import 'package:pom/widgets/google_sign_in_button.dart';

class SignInPage extends StatelessWidget {
  static const String routeName = '/sign-in';

  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Image(
              image: AssetImage('assets/images/logo_text_square.png'),
              width: 250,
            ),
            FutureBuilder<FirebaseApp>(
              future: Authentication.initializeFirebase(context: context),
              builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error initializing Firebase');
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return const GoogleSignInButton();
                }
                return const CircularProgressIndicator();
              },
            )
          ],
        ),
      ),
    );
  }
}
