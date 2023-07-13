import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/common/signin_button.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../theme/pallete.dart';
import '../../auth/controller/auth_controller.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    final currentTheme = ref.watch(themeNotifierProvider);

    final isGuest = !user!.isAuthenticated;

    return Drawer(
        child: SafeArea(
            child: Column(
      children: [
        isGuest
            ? const SignInButton()
            : ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Create Community'),
                onTap: () {
                  navigateToCreateCommunity(context);
                },
              ),
        if (!isGuest)
          ref.watch(userCommunitiesProvider).when(
                data: (communities) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: communities.length,
                      itemBuilder: (context, index) {
                        final community = communities[index];
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(community.avatar),
                          ),
                          title: Text(community.name),
                          onTap: () {
                            navigateToCommunity(context, community);
                          },
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Text(error.toString()),
              ),
      ],
    )));
  }
}
