import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/constants.dart';
import '../../../common/signin_button.dart';
import '../controller/auth_controller.dart';

class Login extends ConsumerWidget {
   Login({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            Constants.logoImage,
            height: 40,
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text(
                Constants.skipText,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
              ),
            )
          ],
        ),
      body: isLoading ? const Center(child: CircularProgressIndicator(),) :
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50,),
          const Text(
            Constants.diveInText,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              Constants.loginEmote,
              height: 400,
            ),
          ),
          const SizedBox(height: 50,),
          SignInButton(),
        ],
      ),
    );
  }
}
