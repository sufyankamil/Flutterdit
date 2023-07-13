import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/responsive/responsive.dart';
import 'package:reddit/theme/pallete.dart';

import '../../../common/constants.dart';
import '../../../common/signin_button.dart';
import '../controller/auth_controller.dart';

class Login extends ConsumerWidget {
  const Login({super.key});

  void signInAsGuest(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          Constants.logoImage,
          height: 40,
        ),
        actions: [
          TextButton(
            onPressed: () => signInAsGuest(ref, context),
            child: Text(
              Constants.skipText,
              style: TextStyle(
                color: currentTheme.textTheme.bodyLarge!.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  Constants.diveInText,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    Constants.loginEmote,
                    height: 400,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Responsive(
                  child: SignInButton(),
                )
              ],
            ),
    );
  }
}
