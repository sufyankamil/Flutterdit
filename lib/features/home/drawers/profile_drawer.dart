import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

import '../../auth/controller/auth_controller.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void navigateToProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/profile/$uid');
  }

  void logout(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                user.photoUrl,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              user.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              user.email,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder<bool>(
              future: checkConnectivity(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!) {
                    return const Text('Online',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ));
                  } else {
                    return Text('Offline',
                        style: TextStyle(
                          color: Pallete.redColor,
                          fontWeight: FontWeight.bold,
                        ));
                  }
                } else {
                  return const Text('Loading...');
                }
              },
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
              onTap: () => navigateToProfile(context, user.uid),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Create Community'),
              onTap: () {
                navigateToCreateCommunity(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shield_moon_outlined),
              title: const Text('Switch Theme'),
              onTap: () {
                toggleTheme(ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {},
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => logout(ref),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Pallete.redColor),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
