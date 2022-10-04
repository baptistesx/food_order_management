import 'package:flutter/material.dart';
import 'package:pom/authentication.dart';
import 'package:pom/utils/functions.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  final Widget title;
  const CustomAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(72);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isSigningOut = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: widget.title,
      actions: <Widget>[
        _isSigningOut
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : IconButton(
                onPressed: () async {
                  setState(() {
                    _isSigningOut = true;
                  });
                  await Authentication.signOut(context: context);
                  setState(() {
                    _isSigningOut = false;
                  });
                  if (mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      routeToSignInScreen(),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
                icon: const Icon(Icons.logout),
              ),
      ],
    );
  }
}
