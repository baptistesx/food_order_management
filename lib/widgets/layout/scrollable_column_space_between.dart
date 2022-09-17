import 'package:flutter/material.dart';

class ScrollableColumnSpaceBetween extends StatelessWidget {
  final Widget content;
  final Widget? bottom;
  final EdgeInsets? padding;

  const ScrollableColumnSpaceBetween({
    Key? key,
    required this.content,
    this.bottom,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: Container(
            constraints: constraints.maxHeight.isInfinite
                ? null
                : BoxConstraints(minHeight: constraints.maxHeight),
            padding: padding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                content,
                if (bottom != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: bottom!,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
