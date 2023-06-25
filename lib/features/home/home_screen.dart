import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/home/delegates/search_community_delegate.dart';
import 'package:reddit/features/home/drawers/community_list_drawer.dart';
import 'package:reddit/features/home/drawers/profile_drawer.dart';

import '../auth/controller/auth_controller.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: false,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => displayDrawer(context),
            icon: const Icon(Icons.menu),
          );
        }),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context, delegate: SearchCommunityDelegate(ref));
            },
            icon: const Icon(Icons.search),
          ),
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () => displayEndDrawer(context),
                icon: CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(user?.photoUrl ?? ''),
                ),
              );
            }
          ),
        ],
      ),
      drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
      body: Center(
        child: Text('Welcome ${user?.name ?? 'to Reddit Clone'}'),
      ),
    );
  }
}
