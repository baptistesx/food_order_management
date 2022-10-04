import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pom/blocs/auth/auth.dart';
import 'package:pom/blocs/auth/auth_events.dart';
import 'package:pom/blocs/auth/auth_states.dart';
import 'package:pom/theme/themes.dart';
import 'package:pom/views/sign_in.dart';
import 'package:pom/widgets/custom_snackbar_error_content.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final Widget title;
  const CustomAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: <Widget>[
        BlocConsumer<AuthBloc, AuthState>(
          listener: (BuildContext context, AuthState state) {
            if (state is AuthErrorState) {
              final SnackBar snackBar = SnackBar(
                backgroundColor: context.theme.errorColor,
                content: CustomSnackBarErrorContent(
                  state.message,
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (state is AuthInitialState) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                SignInPage.routeName,
                (Route<dynamic> route) => false,
              );
            }
          },
          builder: (BuildContext context, AuthState state) {
            return IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(SignOutEvent());
              },
              icon: const Icon(Icons.logout),
            );
          },
        )
      ],
    );
  }
}
