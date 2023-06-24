import 'package:flutter/material.dart';

import '../../../common/constants.dart';
import '../../../common/signin_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
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
      body: Column(
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
          // TextButton(
          //   onPressed: () {},
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Image.asset(
          //         Constants.googleImage,
          //         height: 30,
          //       ),
          //       const SizedBox(width: 10,),
          //       const Text(
          //         'Sign in with Google',
          //         style: TextStyle(
          //           fontSize: 20,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
