import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fom/blocs/auth/auth.dart';
import 'package:fom/blocs/auth/auth_events.dart';
import 'package:fom/blocs/auth/auth_states.dart';
import 'package:fom/main.dart';
import 'package:fom/theme/themes.dart';
import 'package:fom/views/sign_in.dart';
import 'package:fom/widgets/custom_snackbar_error_content.dart';

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
            return firebaseAuth.currentUser != null
                ? IconButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(SignOutEvent());
                    },
                    icon: const Icon(Icons.logout),
                  )
                : const SizedBox();
          },
        )
      ],
    );
  }
}
