import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/models/user_modal.dart';
import 'package:reddit/router.dart';
import 'package:reddit/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
            theme: Pallete.darkModeAppTheme,
            routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
              if (data != null) {
                getData(ref, data);
                if(user != null) {
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
                child: Text('Error'),
              ),
            ),
          ),
        );
  }
}