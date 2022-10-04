import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pom/blocs/auth/auth.dart';
import 'package:pom/blocs/auth/auth_events.dart';
import 'package:pom/blocs/auth/auth_states.dart';
import 'package:pom/theme/themes.dart';
import 'package:pom/views/home.dart';
import 'package:pom/widgets/custom_snackbar_error_content.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state is AuthErrorState) {
          final SnackBar snackBar = SnackBar(
            backgroundColor: context.theme.errorColor,
            content: CustomSnackBarErrorContent(
              state.message,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (state is AuthConnectedState) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomePage.routeName,
            (Route<dynamic> route) => false,
          );
        }
      },
      builder: (BuildContext context, AuthState state) {
        if (state is AuthLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          onPressed: () async {
            context.read<AuthBloc>().add(SignInEvent());
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Image(
                  image: AssetImage('assets/icon/google_logo.png'),
                  height: 35.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
