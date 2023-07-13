import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/models/user_modal.dart';
import 'package:reddit/router.dart';
import 'package:reddit/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'firebase_options.dart';

void main() async {
  await dotenv.load(
      fileName: '.env'); // Loads the environment variables from .env file
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print(dotenv.env['STRIPE_SECRET_KEY']!);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    checkInternetConnectivityAndLaunchApp(context);
  }

  void checkInternetConnectivityAndLaunchApp(BuildContext context) async {
    // Check internet connectivity
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('No Internet'),
            content: const Text('Please check your internet connection'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } else {
      // Launch app
      runApp(
        const ProviderScope(
          child: MyApp(),
        ),
      );
    }
  }

  void getData(WidgetRef ref, User data) async {
    user = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => user);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangesProvider).when(
          data: (data) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Reddit Clone',
            theme: ref.watch(themeNotifierProvider),
            routerDelegate: RoutemasterDelegate(
              routesBuilder: (context) {
                if (data != null) {
                  getData(ref, data);
                  if (user != null) {
                    return loggedInRoute;
                  }
                }
                return loggedOutRoute;
              },
            ),
            routeInformationParser: const RoutemasterParser(),
          ),
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => const MaterialApp(
            home: Scaffold(
              body: Center(
                  child: Text(
                'This is unexpected :(',
                style: TextStyle(fontSize: 18),
              )),
            ),
          ),
        );
  }
}
