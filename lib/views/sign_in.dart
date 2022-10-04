import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pom/authentication.dart';
import 'package:pom/widgets/google_sign_in_button.dart';

class SignInPage extends StatefulWidget {
  static const String routeName = '/sign-in';

  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  void initState() {
    super.initState();

    // firebaseAuth.authStateChanges().listen((User? user) {
    //   if (user == null) {
    //     Navigator.pushNamedAndRemoveUntil(
    //       context,
    //       SignInPage.routeName,
    //       (Route<dynamic> route) => false,
    //     );
    //     print('User is currently signed out!');
    //   } else {
    //     print('User is signed in!');
    //     Navigator.pushNamedAndRemoveUntil(
    //       context,
    //       HomePage.routeName,
    //       (Route<dynamic> route) => false,
    //     );
    //   }
    // });

    // firebaseAuth.idTokenChanges().listen((User? user) {
    //   if (user == null) {
    //     print('User is currently signed out!');
    //   } else {
    //     print('User is signed in!');
    //   }
    // });

    // firebaseAuth.userChanges().listen((User? user) {
    //   if (user == null) {
    //     print('User is currently signed out!');
    //   } else {
    //     print('User is signed in!');
    //   }
    // });
  }

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
                return const CircularProgressIndicator(
                    // valueColor: AlwaysStoppedAnimation<Color>(
                    //   CustomColors.firebaseOrange,
                    // ),
                    );
              },
            )

            // SignInButton(Buttons.Google, text: 'Connexion avec Google',
            //     onPressed: () {
            //   context.read<AuthBloc>().add(SignInEvent());
            // })
          ],
        ),
      ),
    );
  }
}
