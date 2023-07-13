import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  const Responsive({
    Key? key,
    required this.child,
    // required this.mobile,
    // required this.tablet,
    // required this.desktop,
  }) : super(key: key);

  // final Widget mobile;
  // final Widget tablet;
  // final Widget desktop;

  final Widget child;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 850 &&
      MediaQuery.of(context).size.width < 1100;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    // return Consumer(
    //   builder: (context, ref, child) {
    //     return LayoutBuilder(
    //       builder: (context, constraints) {
    //         if (constraints.maxWidth >= 1100) {
    //           return desktop;
    //         } else if (constraints.maxWidth >= 850) {
    //           return tablet;
    //         } else {
    //           return mobile;
    //         }
    //       },
    //     );
    //   },
    // );
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
        ),
        child: child,
      ),
    );
  }
}
