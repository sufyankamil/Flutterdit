import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/controller/auth_controller.dart';
import '../theme/pallete.dart';
import 'constants.dart';

class SignInButton extends ConsumerWidget {
  final bool isFromLogin;

  const SignInButton({Key? key, this.isFromLogin = false}) : super(key: key);

  // void signInWithGoogle(BuildContext context, WidgetRef ref) async {
  //   ref
  //       .read(authControllerProvider.notifier)
  //       .signInWithGoogle(context, isFromLogin);
  // }

  void signInWithGoogle(BuildContext context, WidgetRef ref) async {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () => signInWithGoogle(context, ref),
        icon: Image.asset(
          Constants.googleImage,
          width: 30,
        ),
        label: const Text(
          Constants.continueWithGoogle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
