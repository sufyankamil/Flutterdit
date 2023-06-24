import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/home/drawers/community_list_drawer.dart';

import '../auth/controller/auth_controller.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => displayDrawer(context),
              icon: const Icon(Icons.menu),
            );
          }
        ),
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
            },
            icon: CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(user?.photoUrl ?? ''),
            ),
          ),
        ],
      ),
      drawer: CommunityListDrawer(),
      body: Center(
        child: Text('Welcome ${user?.name ?? 'to Reddit Clone'}'),
      ),
    );
  }
}
